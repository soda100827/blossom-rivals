--!strict

--// Services
local Players = game:GetService("Players")
local _Workspace = game:GetService("Workspace")

--// Dependencies (require)
local State = require("./State")
local _Targeting = require("./Targeting")
local TeamUtils = require("../../utils/TeamUtils")
local Helpers = require("./Helpers")

--// Constants

--// Types

--// Private state
local MeleeMods = {}

--// Private helpers
local function _getDistance(p1: Vector3, p2: Vector3): number
	return (p1 - p2).Magnitude
end

local function _getNearbyEnemies(): { Player }
	local localPlayer = Helpers.getLocalPlayer()
	local localCharacter = localPlayer.Character
	if not localCharacter then
		return {}
	end
	local localRoot = localCharacter:FindFirstChild("HumanoidRootPart") :: BasePart?
	if not localRoot then
		return {}
	end

	local enemies = {}
	for _, player in ipairs(Players:GetPlayers()) do
		if player == localPlayer then
			continue
		end
		if TeamUtils.isSameTeam(player, localPlayer) then
			continue
		end

		local character = player.Character
		if not character then
			continue
		end
		local root = character:FindFirstChild("HumanoidRootPart") :: BasePart?
		local hum = character:FindFirstChildOfClass("Humanoid")
		if not root or not hum or hum.Health <= 0 then
			continue
		end

		table.insert(enemies, player)
	end
	return enemies
end

--// Public API
function MeleeMods.setup()
	local checkcaller = Helpers.getGlobal("checkcaller") or function()
		return false
	end

	task.spawn(function()
		local meleeMod = Helpers.getMeleeModule()
		if meleeMod then
			local oldStartShooting
			oldStartShooting = Helpers.safeHook(meleeMod, "StartShooting", function(self, ...)
				if not checkcaller() then
					local info = (self :: any).Info

					-- No cooldown during Aura
					if State.isMeleeAuraEnabled then
						(self :: any)._attack_cooldown = 0
						(self :: any)._equip_cooldown = 0
					end

					-- Apply Multiplier
					local originalCooldown: number = info.AttackCooldown
					info.AttackCooldown = originalCooldown * (State.meleeAttackCooldownMultiplier / 100)

					-- Reach manipulation (Always apply reach during Aura)
					local originalReach = info.AttackReach
					if State.isMeleeAuraEnabled then
						info.AttackReach = State.meleeAuraReach -- Configurable reach
					end

					local result = table.pack(oldStartShooting(self, ...))

					-- Restore
					info.AttackCooldown = originalCooldown
					info.AttackReach = originalReach

					return table.unpack(result)
				end
				return oldStartShooting(self, ...)
			end, State.logger)

			local oldCanQuickAttack
			oldCanQuickAttack = Helpers.safeHook(meleeMod, "CanQuickAttack", function(self, ...)
				if not checkcaller() and State.isMeleeAuraEnabled then
					return true
				end
				return oldCanQuickAttack(self, ...)
			end, State.logger)
		end

		-- Hook specific melee items for StartAiming (Skills)
		local itemModules = Helpers.getItemModules()
		if itemModules then
			local hookfunction = Helpers.getGlobal("hookfunction") or Helpers.getGlobal("replaceclosure")
			local newcclosure = Helpers.getGlobal("newcclosure") or function(f)
				return f
			end

			if not hookfunction then
				State.logger:warn("hookfunction not found for item skills, skill cooldowns will not work.")
				return
			end

			local itemsToHook = { "Katana", "Scythe", "BowieKnife" }
			for _, itemName in ipairs(itemsToHook) do
				local itemScript = itemModules:FindFirstChild(itemName)
				if itemScript and itemScript:IsA("ModuleScript") then
					pcall(function()
						local dynamicRequire = require :: any
						local itemMod = dynamicRequire(itemScript)
						if itemMod and itemMod.StartAiming then
							local oldStartAiming
							oldStartAiming = hookfunction(
								itemMod.StartAiming,
								newcclosure(function(self, ...)
									if not checkcaller() then
										local info = (self :: any).Info
										local cooldownFields = { "DeflectCooldown", "DashCooldown", "InvisCooldown" }
										local originals: { [string]: number } = {}
										for _, field in ipairs(cooldownFields) do
											if info[field] then
												originals[field] = info[field]
												info[field] = originals[field]
													* (State.meleeSkillCooldownMultiplier / 100)
											end
										end

										local result = table.pack(oldStartAiming(self, ...))

										for field, val in pairs(originals) do
											info[field] = val
										end
										return table.unpack(result)
									end
									return oldStartAiming(self, ...)
								end)
							)
						end
					end)
				end
			end
		end
	end)

	-- Aura Loop
	task.spawn(function()
		while true do
			local localPlayer = Helpers.getLocalPlayer()
			local character = localPlayer.Character

			Helpers.fetchFighterController(State.logger)
			local localFighter = State.fighterController and State.fighterController.LocalFighter

			if character and localFighter and (State.isMeleeAuraEnabled or State.isTeleportAuraEnabled) then
				local enemies = _getNearbyEnemies()

				-- Sort by distance
				local localRoot = character:FindFirstChild("HumanoidRootPart") :: BasePart?
				if localRoot then
					table.sort(enemies, function(a, b)
						local charA = a.Character
						local charB = b.Character
						if not charA or not charB then
							return false
						end
						local rootA = charA:FindFirstChild("HumanoidRootPart") :: BasePart?
						local rootB = charB:FindFirstChild("HumanoidRootPart") :: BasePart?
						if not rootA or not rootB then
							return false
						end

						local distA = _getDistance(localRoot.Position, rootA.Position)
						local distB = _getDistance(localRoot.Position, rootB.Position)
						return distA < distB
					end)

					local target = enemies[1]
					local targetChar = target and target.Character
					if target and targetChar then
						local targetRoot = targetChar:FindFirstChild("HumanoidRootPart") :: BasePart?
						if targetRoot then
							-- Teleport logic
							if State.isTeleportAuraEnabled then
								localRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 1.5) -- Teleport close behind
							end

							-- Attack logic
							if State.isMeleeAuraEnabled then
								-- Force equip melee (Slot 3)
								local equipped = localFighter.EquippedItem
								if not equipped or (equipped.Info and equipped.Info.IsGun) then
									pcall(function()
										if localFighter.EquipItem then
											localFighter:EquipItem(3)
										end
									end)
								end

								-- Trigger attack
								equipped = localFighter.EquippedItem
								if equipped and (equipped.Info and not equipped.Info.IsGun) then
									-- Re-fetch and check if we can attack
									if equipped.StartShooting then
										equipped:Input("StartShooting")
									end
								end
							end
						end
					end
				end
			end
			task.wait(if State.isMeleeAuraEnabled or State.isTeleportAuraEnabled then 0.01 else 0.1)
		end
	end)
end

return MeleeMods
