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
					local localChar = Helpers.getLocalPlayer().Character
					if targetPart and localChar and not targetPart:IsDescendantOf(localChar) then
						local newOrigin = origin
						if State.isManipulationEnabled then
							-- Magic Bullet: Spawn bullet slightly above target (1 stud) to be outside hitbox
							newOrigin = targetPart.Position + Vector3.new(0, 1, 0)

							-- Extend the target position downwards to ensure the ray doesn't stop AT the target center
							-- but continues through it to hit the floor/map.
							local direction = (targetPart.Position - newOrigin).Unit
							local extendedTarget = newOrigin + (direction * 100) -- Shoot 100 studs through

							-- Debug Logging
							-- print(string.format("[MagicBullet] Origin: %s | Dir: %s | ExtendedTgt: %s",
							-- 	tostring(newOrigin), tostring(direction), tostring(extendedTarget)))

							-- CRITICAL: Add target to filter to force "penetration" logic.
							-- We add BOTH the specific part and the character model to be safe.
							if type(filter) == "table" then
								table.insert(filter, targetPart)
								table.insert(filter, targetPart.Parent)
								-- print("[MagicBullet] Added Target & Parent to filter: " .. tostring(targetPart))
							else
								warn("[MagicBullet] Filter is not a table: " .. typeof(filter))
							end

							-- Update return to use extendedTarget
							_lastSilentTargetPos = targetPart.Position
							_lastSilentOrigin = newOrigin

							local result = oldRaycast(self, newOrigin, extendedTarget, distance, filter, ...)

							-- PROXY/SPOOFING LOGIC:
							-- The ray physically hits the FLOOR (due to filter), which is good for tracers/server validation of "Through" shot.
							-- BUT the game logic needs to see a Player Hit to fire damage.
							-- So we wrap the result and lie about the Instance.
							if result then
								local fakeResult = {
									Instance = targetPart, -- LIE: We hit the player
									Position = result.Position, -- TRUTH: End of ray (Floor)
									Material = result.Material,
									Normal = result.Normal,
									Distance = result.Distance,
								}
								return fakeResult
							end

							return result
						end

						_lastSilentTargetPos = targetPart.Position
						_lastSilentOrigin = newOrigin
						-- For non-magic bullet silent aim, we just hit the target directly
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
