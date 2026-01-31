--!strict

--// Services

--// Dependencies (require)
local ExecutorUtils = require("../../../shared/ExecutorUtils")
local HookUtils = require("../../../shared/HookUtils")
local PlayerUtils = require("../../../shared/PlayerUtils")
local State = require("../State")
local Helpers = require("../Utils/Helpers")
local Targeting = require("../Systems/Targeting")

--// Constants

--// Types

--// Private state
local SilentAim = {}
SilentAim.__index = SilentAim

local _maid = nil :: any
local _signals = {}
local _state = {
	lastSilentTargetPos = nil :: Vector3?,
	lastSilentOrigin = nil :: Vector3?,
}

--// Private helpers
local function _isGunAction(): boolean
	local debugGlobal = ExecutorUtils.getGlobal("debug")
	local traceback = debugGlobal and debugGlobal.traceback or debug.traceback
	local stack = traceback()
	return (
		stack:find("StartShooting")
		or stack:find("GetEntitiesFromRaycast")
		or stack:find("_LocalTracers")
		or stack:find("_ImpactMarker")
	) ~= nil
end

--// Public API
function SilentAim.isGunAction(): boolean
	return _isGunAction()
end

function SilentAim.setup(maid: any): ()
	_maid = maid
	local hookfunction = ExecutorUtils.getGlobal("hookfunction") or ExecutorUtils.getGlobal("replaceclosure")
	local checkcaller = ExecutorUtils.getGlobal("checkcaller") or function()
		return false
	end

	-- Helper to wrap closures if available to avoid "hook has more upvalues" error
	local newcclosure = ExecutorUtils.getGlobal("newcclosure") or function(f)
		return f
	end

	if not hookfunction then
		if State.logger and (State.logger :: any).warnUnsupported then
			(State.logger :: any):warnUnsupported("hookfunction")
		else
			State.logger:warn("This executor does not support 'hookfunction'. Some features may not work as expected.")
		end
		return
	end

	local isRunning = true
	if _maid then
		_maid:GiveTask(function()
			isRunning = false
		end)
	end

	task.spawn(function()
		if not isRunning then
			return
		end

		local utility = Helpers.getUtility()
		if utility and not State.isUtilityHooked then
			State.isUtilityHooked = true

			local oldRaycast
			oldRaycast = HookUtils.safeHook(utility, "Raycast", function(self, origin, target, distance, filter, ...)
				-- Optimization: Check enabled first
				if not State.isSilentAimEnabled then
					return oldRaycast(self, origin, target, distance, filter, ...)
				end

				-- Allow Silent Aim if it's a game call OR if Ragebot is explicitly shooting
				if State.isRagebotShooting or (not checkcaller() and _isGunAction()) then
					if State.logger then
						State.logger:info("[SilentAim] Hook Activated! MagebotTrigger:", State.isRagebotShooting)
					end
					-- Hit Chance check
					if math.random(1, 100) > State.silentHitChance then
						_state.lastSilentTargetPos = nil
						return oldRaycast(self, origin, target, distance, filter, ...)
					end

					local targetPart = Targeting.getClosestSilentTarget()
					local localPlayer = PlayerUtils.getLocalPlayer()
					local localChar = localPlayer and localPlayer.Character
					if targetPart and localChar and not targetPart:IsDescendantOf(localChar) then
						local newOrigin = origin
						_state.lastSilentTargetPos = targetPart.Position
						_state.lastSilentOrigin = newOrigin
						-- For non-magic bullet silent aim, we just hit the target directly
						return oldRaycast(self, newOrigin, targetPart.Position, distance, filter, ...)
					end
				end
				_state.lastSilentTargetPos = nil
				_state.lastSilentOrigin = nil
				return oldRaycast(self, origin, target, distance, filter, ...)
			end, State.logger, _maid)

			local oldEncode
			oldEncode = HookUtils.safeHook(utility, "EncodeCFrame", function(self, cf)
				if not checkcaller() and State.isSilentAimEnabled and _state.lastSilentTargetPos and _isGunAction() then
					local originPos = cf.Position
					local newCF = CFrame.lookAt(originPos, _state.lastSilentTargetPos :: Vector3)
					return oldEncode(self, newCF)
				end
				return oldEncode(self, cf)
			end, State.logger, _maid)
		end

		local cameraShaker = Helpers.getCameraShaker()
		if cameraShaker and not State.isCameraShakerHooked then
			State.isCameraShakerHooked = true
			local mt = getmetatable(cameraShaker.Presets)
			if mt and mt.__index then
				local oldIdx = mt.__index
				mt.__index = newcclosure(function(t, k)
					if State.isSilentAimEnabled and (k == "StartShooting" or k == "") then
						return nil
					end
					return oldIdx(t, k)
				end)
				if _maid then
					_maid:GiveTask(function()
						mt.__index = oldIdx
					end)
				end
			end
		end
	end)
end

return SilentAim
