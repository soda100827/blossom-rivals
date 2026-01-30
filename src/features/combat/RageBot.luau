--!strict

--// Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

--// Dependencies (require)
local State = require("./State")
local Helpers = require("./Helpers")
local TeamUtils = require("../../utils/TeamUtils")

--// Constants

--// Types

--// Private state
local RageBot = {}
local _originalCFrame: CFrame? = nil
local _isRaging = false

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
function RageBot.setup()
	task.spawn(function()
		while true do
			local localPlayer = Helpers.getLocalPlayer()
			local character = localPlayer.Character

			if State.isRageBotEnabled and character and TeamUtils.isInDuel(localPlayer) then
				Helpers.fetchFighterController(State.logger)
				local localFighter = State.fighterController and State.fighterController.LocalFighter

				if localFighter then
					local enemies = _getNearbyEnemies()
					local localRoot = character:FindFirstChild("HumanoidRootPart") :: BasePart?

					if localRoot and #enemies > 0 then
						if not _isRaging then
							_originalCFrame = localRoot.CFrame
							_isRaging = true
						end

						-- Sort enemies by distance
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
							return _getDistance(localRoot.Position, rootA.Position)
								< _getDistance(localRoot.Position, rootB.Position)
						end)

						local target = enemies[1]
						local targetChar = target.Character
						local targetRoot = targetChar:FindFirstChild("HumanoidRootPart") :: BasePart?

						if targetRoot then
							-- Target Strafe Logic
							local strafeOffset = Vector3.new(0, 0, 0)
							if State.isTargetStrafeEnabled then
								local t = os.clock() * 20 -- Faster for "Rage"
								strafeOffset =
									Vector3.new(math.sin(t) * 15, 10 + math.cos(t * 1.5) * 10, math.cos(t) * 15)
							end

							-- Move to target (Airborne strafe)
							localRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 8) + strafeOffset

							-- Attack logic
							local equipped = localFighter.EquippedItem
							local isReloading = false
							if equipped and equipped.Info and equipped.Info.IsGun then
								isReloading = equipped._reloading or equipped.Reloading
							end

							-- Swap Weapon On Reload logic
							if State.isSwapWeaponOnReloadEnabled and isReloading then
								-- Swap to secondary (Slot 2) or primary (Slot 1)
								local targetSlot = 1
								if localFighter.EquippedSlot == 1 then
									targetSlot = 2
								end
								pcall(function()
									localFighter:EquipItem(targetSlot)
								end)
								-- Re-check reloading after swap
								equipped = localFighter.EquippedItem
								if equipped and equipped.Info and equipped.Info.IsGun then
									isReloading = equipped._reloading or equipped.Reloading
								end
							end

							-- If still reloading (or swapping failed/secondary also empty), return to position
							if isReloading and _originalCFrame then
								localRoot.CFrame = _originalCFrame
							else
								-- Force fire
								if equipped and equipped.Input then
									equipped:Input("StartShooting")
								end
							end
						end
					else
						-- No enemies found, return to original position if we were raging
						if _isRaging and _originalCFrame and localRoot then
							localRoot.CFrame = _originalCFrame
							_isRaging = false
							_originalCFrame = nil
						end
					end
				end
			else
				-- Not enabled or not in duel, return if needed
				if _isRaging and _originalCFrame and character then
					local localRoot = character:FindFirstChild("HumanoidRootPart") :: BasePart?
					if localRoot then
						localRoot.CFrame = _originalCFrame
					end
					_isRaging = false
					_originalCFrame = nil
				end
			end
			task.wait(0.01)
		end
	end)
end

return RageBot
