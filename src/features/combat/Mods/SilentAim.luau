--!strict

--// Services

--// Dependencies (require)
local State = require("../State")
local Helpers = require("../Utils/Helpers")
local Targeting = require("../Systems/Targeting")
local ExecutorUtils = require("../../../shared/ExecutorUtils")
local HookUtils = require("../../../shared/HookUtils")

--// Constants

--// Types

--// Private state
local SilentAim = {}
local _lastSilentTargetPos: Vector3? = nil
local _lastSilentOrigin: Vector3? = nil

--// Private helpers

--// Public API
function SilentAim.isGunAction(): boolean
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

function SilentAim.setup(maid: any)
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
	if maid then
		maid:GiveTask(function()
			isRunning = false
		end)
	end

	task.spawn(function()
		if not isRunning then
			return
		end

		local utility = Helpers.getUtility()
		if utility and not State.utilityHooked then
			State.utilityHooked = true

			local oldRaycast
			oldRaycast = HookUtils.safeHook(utility, "Raycast", function(self, origin, target, distance, filter, ...)
				-- Optimization: Check enabled first
				if not State.isSilentAimEnabled then
					return oldRaycast(self, origin, target, distance, filter, ...)
				end

				if not checkcaller() and (distance == 400 or distance == 999) and SilentAim.isGunAction() then
					-- Hit Chance check
					if math.random(1, 100) > State.silentHitChance then
						_lastSilentTargetPos = nil
						return oldRaycast(self, origin, target, distance, filter, ...)
					end

					local targetPart = Targeting.getClosestSilentTarget()
					local localChar = PlayerUtils.getLocalPlayer().Character
					if targetPart and localChar and not targetPart:IsDescendantOf(localChar) then
						local newOrigin = origin
						_lastSilentTargetPos = targetPart.Position
						_lastSilentOrigin = newOrigin
						-- For non-magic bullet silent aim, we just hit the target directly
						return oldRaycast(self, newOrigin, targetPart.Position, distance, filter, ...)
					end
				end
				_lastSilentTargetPos = nil
				_lastSilentOrigin = nil
				return oldRaycast(self, origin, target, distance, filter, ...)
			end, State.logger, maid)

			local oldEncode
			oldEncode = HookUtils.safeHook(utility, "EncodeCFrame", function(self, cf)
				if
					not checkcaller()
					and State.isSilentAimEnabled
					and _lastSilentTargetPos
					and SilentAim.isGunAction()
				then
					local originPos = cf.Position
					local newCF = CFrame.lookAt(originPos, _lastSilentTargetPos :: Vector3)
					return oldEncode(self, newCF)
				end
				return oldEncode(self, cf)
			end, State.logger, maid)
		end

		local cameraShaker = Helpers.getCameraShaker()
		if cameraShaker and not State.cameraShakerHooked then
			State.cameraShakerHooked = true
			local mt = getmetatable(cameraShaker.Presets)
			if mt and mt.__index then
				local oldIdx = mt.__index
				mt.__index = newcclosure(function(t, k)
					if State.isSilentAimEnabled and (k == "StartShooting" or k == "") then
						return nil
					end
					return oldIdx(t, k)
				end)
				if maid then
					maid:GiveTask(function()
						mt.__index = oldIdx
					end)
				end
			end
		end
	end)
end

return SilentAim
