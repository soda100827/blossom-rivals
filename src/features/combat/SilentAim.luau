--!strict
local State = require("./State")
local Helpers = require("./Helpers")
local Targeting = require("./Targeting")

local SilentAim = {}
local _lastSilentTargetPos: Vector3? = nil

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

	if not hookfunction then
		State.logger:warn("hookfunction not found, Perfect Silent Aim will not work.")
		return
	end

	task.spawn(function()
		local utility = Helpers.getUtility()
		if utility and not State.utilityHooked then
			State.utilityHooked = true

			local oldRaycast
			oldRaycast = hookfunction(utility.Raycast, function(self, origin, target, distance, filter, ...)
				if
					not checkcaller()
					and State.isSilentAimEnabled
					and (distance == 400 or distance == 999)
					and SilentAim.isGunAction()
				then
					-- Hit Chance check
					if math.random(1, 100) > State.silentHitChance then
						_lastSilentTargetPos = nil
						return oldRaycast(self, origin, target, distance, filter, ...)
					end

					local targetPart = Targeting.getClosestSilentTarget()
					if targetPart then
						_lastSilentTargetPos = targetPart.Position
						return oldRaycast(self, origin, targetPart.Position, distance, filter, ...)
					end
				end
				_lastSilentTargetPos = nil
				return oldRaycast(self, origin, target, distance, filter, ...)
			end)

			local oldEncode
			oldEncode = hookfunction(utility.EncodeCFrame, function(self, cf)
				if
					not checkcaller()
					and State.isSilentAimEnabled
					and _lastSilentTargetPos
					and SilentAim.isGunAction()
				then
					local newCF = CFrame.lookAt(cf.Position, _lastSilentTargetPos :: Vector3)
					return oldEncode(self, newCF)
				end
				return oldEncode(self, cf)
			end)

			State.logger:info("Utility.Raycast and Utility.EncodeCFrame hooked for Silent Aim.")
		end

		local cameraShaker = Helpers.getCameraShaker()
		if cameraShaker and not State.cameraShakerHooked then
			State.cameraShakerHooked = true
			local mt = getmetatable(cameraShaker.Presets)
			if mt and mt.__index then
				local oldIdx = mt.__index
				mt.__index = function(t, k)
					if State.isSilentAimEnabled and (k == "StartShooting" or k == "") then
						return nil
					end
					return oldIdx(t, k)
				end
				State.logger:info("CameraShaker.Presets hooked to neutralize shake.")
			end
		end
	end)
end

return SilentAim
