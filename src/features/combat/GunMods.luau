--!strict

--// Services

--// Dependencies (require)
local State = require("./State")
local Helpers = require("./Helpers")

--// Constants

--// Types

--// Private state
local GunMods = {}
local _oldShootCooldowns = {} :: { [any]: number }

--// Private helpers

--// Public API
function GunMods.setup()
	local hookfunction = Helpers.getGlobal("hookfunction") or Helpers.getGlobal("replaceclosure")
	local checkcaller = Helpers.getGlobal("checkcaller") or function()
		return false
	end

	if not hookfunction then
		State.logger:warn("hookfunction not found, Gun Mods will not work.")
		return
	end

	task.spawn(function()
		-- 1. No Recoil (ClientItem._Recoil)
		local clientItemMod = Helpers.getClientItemModule()
		if clientItemMod and not State.gunModsHooked then
			local oldRecoil
			oldRecoil = hookfunction(clientItemMod._Recoil, function(self, multiplier)
				if not checkcaller() and State.isNoRecoilEnabled then
					return -- Prevent recoil
				end
				return oldRecoil(self, multiplier)
			end)
		end

		-- 2. No Spread (GameplayUtility.GetSpread)
		local gameplayUtility = Helpers.getGameplayUtility()
		if gameplayUtility then
			local oldGetSpread
			oldGetSpread = hookfunction(gameplayUtility.GetSpread, function(self, ...)
				if not checkcaller() and State.isNoSpreadEnabled then
					return CFrame.identity -- 0 spread
				end
				return oldGetSpread(self, ...)
			end)
		end

		-- 3. No Muzzle Flash (ClientViewModel.MuzzleFlash)
		local viewModelMod = Helpers.getViewModelModule()
		if viewModelMod then
			local oldMuzzleFlash
			oldMuzzleFlash = hookfunction(viewModelMod.MuzzleFlash, function(self, ...)
				if not checkcaller() and State.isNoMuzzleFlashEnabled then
					return -- Prevent muzzle flash
				end
				return oldMuzzleFlash(self, ...)
			end)
		end

		-- 4. Attack Cooldown & Spread Info Modification
		local gunMod = Helpers.getGunModule()
		if gunMod then
			local oldStartShooting
			oldStartShooting = hookfunction(gunMod.StartShooting, function(self, ...)
				if not checkcaller() then
					-- No Spread: Modify Info properties
					if State.isNoSpreadEnabled then
						if not _oldShootCooldowns[tostring(self.Info) .. "_Spread"] then
							_oldShootCooldowns[tostring(self.Info) .. "_Spread"] = self.Info.ShootSpread
							_oldShootCooldowns[tostring(self.Info) .. "_AimML"] = self.Info.AimSpreadMultiplier
						end
						self.Info.ShootSpread = 0
						self.Info.AimSpreadMultiplier = 0
						if self.Info.QuickShotSpread then
							if not _oldShootCooldowns[tostring(self.Info) .. "_Quick"] then
								_oldShootCooldowns[tostring(self.Info) .. "_Quick"] = self.Info.QuickShotSpread
							end
							self.Info.QuickShotSpread = 0
						end
					elseif _oldShootCooldowns[tostring(self.Info) .. "_Spread"] then
						self.Info.ShootSpread = _oldShootCooldowns[tostring(self.Info) .. "_Spread"]
						self.Info.AimSpreadMultiplier = _oldShootCooldowns[tostring(self.Info) .. "_AimML"]
						if self.Info.QuickShotSpread and _oldShootCooldowns[tostring(self.Info) .. "_Quick"] then
							self.Info.QuickShotSpread = _oldShootCooldowns[tostring(self.Info) .. "_Quick"]
						end
					end

					-- Attack Cooldown
					if State.attackCooldownMultiplier < 100 then
						if not _oldShootCooldowns[self.Info] then
							_oldShootCooldowns[self.Info] = self.Info.ShootCooldown
						end
						self.Info.ShootCooldown = _oldShootCooldowns[self.Info] * (State.attackCooldownMultiplier / 100)

						if self.Info.ShootBurstCooldown then
							if not _oldShootCooldowns[self.Info.ShootBurstCooldown] then
								_oldShootCooldowns[self.Info.ShootBurstCooldown] = self.Info.ShootBurstCooldown
							end
							self.Info.ShootBurstCooldown = _oldShootCooldowns[self.Info.ShootBurstCooldown]
								* (State.attackCooldownMultiplier / 100)
						end
					elseif _oldShootCooldowns[self.Info] then
						self.Info.ShootCooldown = _oldShootCooldowns[self.Info]
						if self.Info.ShootBurstCooldown and _oldShootCooldowns[self.Info.ShootBurstCooldown] then
							self.Info.ShootBurstCooldown = _oldShootCooldowns[self.Info.ShootBurstCooldown]
						end
					end
				end
				return oldStartShooting(self, ...)
			end)

			-- No Spread: Hook IsFullyAiming to trick the server into thinking we are aiming (less spread)
			local oldIsFullyAiming
			oldIsFullyAiming = hookfunction(gunMod.IsFullyAiming, function(self, ...)
				if not checkcaller() and State.isNoSpreadEnabled then
					return true
				end
				return oldIsFullyAiming(self, ...)
			end)
		end

		State.gunModsHooked = true
	end)
end

return GunMods
