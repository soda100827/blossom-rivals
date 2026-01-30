--!strict

--// Services

--// Dependencies (require)
local State = require("./State")
local Helpers = require("./Helpers")
local Targeting = require("./Targeting")

--// Constants

--// Types

--// Private state
local SilentAim = {}
local _lastSilentTargetPos: Vector3? = nil
local _lastSilentOrigin: Vector3? = nil

--// Private helpers

--// Public API
function SilentAim.isGunAction(): boolean
	local debugGlobal = Helpers.getGlobal("debug")
	local traceback = debugGlobal and debugGlobal.traceback or debug.traceback
	local stack = traceback()
	return (
		stack:find("StartShooting")
		or stack:find("GetEntitiesFromRaycast")
		or stack:find("_LocalTracers")
		or stack:find("_ImpactMarker")
	) ~= nil
end

function SilentAim.setup()
	local hookfunction = Helpers.getGlobal("hookfunction") or Helpers.getGlobal("replaceclosure")
	local checkcaller = Helpers.getGlobal("checkcaller") or function()
		return false
	end

	-- Helper to wrap closures if available to avoid "hook has more upvalues" error
	local newcclosure = Helpers.getGlobal("newcclosure") or function(f)
		return f
	end

	if not hookfunction then
		State.logger:warn("hookfunction not found, Perfect Silent Aim will not work.")
		return
	end

	task.spawn(function()
		local utility = Helpers.getUtility()
		if utility and not State.utilityHooked then
			State.utilityHooked = true

			local oldRaycast
			oldRaycast = Helpers.safeHook(utility, "Raycast", function(self, origin, target, distance, filter, ...)
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
					if targetPart then
						local newOrigin = origin
						if State.isManipulationEnabled then
							-- Magic Bullet: Rayback calculation
							local camera = Helpers.getCamera()
							if camera then
								local camPos = camera.CFrame.Position
								local dir = (targetPart.Position - camPos).Unit
								-- Start 5 studs away from target, approaching from camera direction
								newOrigin = targetPart.Position - (dir * 5)
							else
								-- Fallback
								newOrigin = targetPart.Position + Vector3.new(0, 1, 0)
							end
						end

						_lastSilentTargetPos = targetPart.Position
						_lastSilentOrigin = newOrigin
						return oldRaycast(self, newOrigin, targetPart.Position, distance, filter, ...)
					end
				end
				_lastSilentTargetPos = nil
				_lastSilentOrigin = nil
				return oldRaycast(self, origin, target, distance, filter, ...)
			end, State.logger)

			local oldEncode
			oldEncode = Helpers.safeHook(utility, "EncodeCFrame", function(self, cf)
				if
					not checkcaller()
					and State.isSilentAimEnabled
					and _lastSilentTargetPos
					and SilentAim.isGunAction()
				then
					local originPos = cf.Position
					if State.isManipulationEnabled and _lastSilentOrigin then
						originPos = _lastSilentOrigin
					end
					local newCF = CFrame.lookAt(originPos, _lastSilentTargetPos :: Vector3)
					return oldEncode(self, newCF)
				end
				return oldEncode(self, cf)
			end, State.logger)
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
			end
		end
	end)
end

return SilentAim
