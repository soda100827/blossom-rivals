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

local function _getNearbyEnemies(radius: number): { Player }
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

		local dist = _getDistance(localRoot.Position, root.Position)
		if dist <= radius then
			table.insert(enemies, player)
		end
	end
	return enemies
end

--// Public API
function MeleeMods.setup()
	local hookfunction = Helpers.getGlobal("hookfunction") or Helpers.getGlobal("replaceclosure")
	local checkcaller = Helpers.getGlobal("checkcaller") or function()
		return false
	end

	if not hookfunction then
		State.logger:warn("hookfunction not found, Melee Mods will not work.")
		return
	end

	task.spawn(function()
		local meleeMod = Helpers.getMeleeModule()
		if meleeMod then
			local oldStartShooting
			oldStartShooting = hookfunction(meleeMod.StartShooting, function(self, ...)
				if not checkcaller() then
					-- self.Info is usually shared, so we temporarily override it or modify it
					local originalCooldown: number = self.Info.AttackCooldown
					self.Info.AttackCooldown = originalCooldown * (State.meleeAttackCooldownMultiplier / 100)
					local result = table.pack(oldStartShooting(self, ...))
					self.Info.AttackCooldown = originalCooldown
					return table.unpack(result)
				end
				return oldStartShooting(self, ...)
			end)
		end

		-- Hook specific melee items for StartAiming (Skills)
		local itemModules = Helpers.getItemModules()
		if itemModules then
			local itemsToHook = { "Katana", "Scythe", "BowieKnife" }
			for _, itemName in ipairs(itemsToHook) do
				local itemScript = itemModules:FindFirstChild(itemName)
				if itemScript and itemScript:IsA("ModuleScript") then
					pcall(function()
						local dynamicRequire = require :: any
						local itemMod = dynamicRequire(itemScript)
						if itemMod and itemMod.StartAiming then
							local oldStartAiming
							oldStartAiming = hookfunction(itemMod.StartAiming, function(self, ...)
								if not checkcaller() then
									-- Find potentially multiple cooldown fields
									local cooldownFields = { "DeflectCooldown", "DashCooldown", "InvisCooldown" }
									local originals: { [string]: number } = {}
									for _, field in ipairs(cooldownFields) do
										if self.Info[field] then
											originals[field] = self.Info[field]
											self.Info[field] = originals[field]
												* (State.meleeSkillCooldownMultiplier / 100)
										end
									end

									local result = table.pack(oldStartAiming(self, ...))

									for field, val in pairs(originals) do
										self.Info[field] = val
									end
									return table.unpack(result)
								end
								return oldStartAiming(self, ...)
							end)
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
			if character and (State.isMeleeAuraEnabled or State.isTeleportAuraEnabled) then
				local radius = math.max(State.meleeAuraRadius, State.teleportAuraRadius)
				local enemies = _getNearbyEnemies(radius)

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
							if
								State.isTeleportAuraEnabled
								and _getDistance(localRoot.Position, targetRoot.Position)
									<= State.teleportAuraRadius
							then
								localRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 3) -- Teleport slightly behind
							end

							-- Attack logic
							if
								State.isMeleeAuraEnabled
								and _getDistance(localRoot.Position, targetRoot.Position) <= State.meleeAuraRadius
							then
								-- Trigger melee attack
								Helpers.fetchFighterController(State.logger)
								if State.fighterController and State.fighterController.LocalFighter then
									local item = State.fighterController.LocalFighter.EquippedItem
									if item and item.StartShooting and not item.Info.IsGun then
										item:Input("StartShooting")
									end
								end
							end
						end
					end
				end
			end
			task.wait(0.1)
		end
	end)
end

return MeleeMods
