--!strict

--// Services
local RunService = game:GetService("RunService")

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

		-- 4. Attack Cooldown (Gun.StartShooting cooldown modification)
		-- Since we can't easily hook the 'tick()' check inside the function without more advanced tools,
		-- we can try to modify the 'Info.ShootCooldown' of the gun when it's equipped.
		-- Or hook 'StartShooting' and modify the cooldown value it uses.
		local gunMod = Helpers.getGunModule()
		if gunMod then
			local oldStartShooting
			oldStartShooting = hookfunction(gunMod.StartShooting, function(self, ...)
				if not checkcaller() and State.attackCooldownMultiplier < 100 then
					if not _oldShootCooldowns[self.Info] then
						_oldShootCooldowns[self.Info] = self.Info.ShootCooldown
					end
					-- Apply multiplier (e.g., 1% means 0.01 multiplier)
					self.Info.ShootCooldown = _oldShootCooldowns[self.Info] * (State.attackCooldownMultiplier / 100)

					-- Also handle burst/quickshot if needed
					if self.Info.ShootBurstCooldown then
						if not _oldShootCooldowns[self.Info.ShootBurstCooldown] then
							_oldShootCooldowns[self.Info.ShootBurstCooldown] = self.Info.ShootBurstCooldown
						end
						self.Info.ShootBurstCooldown = _oldShootCooldowns[self.Info.ShootBurstCooldown]
							* (State.attackCooldownMultiplier / 100)
					end
				elseif not checkcaller() and _oldShootCooldowns[self.Info] then
					-- Reset if multiplier is 100%
					self.Info.ShootCooldown = _oldShootCooldowns[self.Info]
					if self.Info.ShootBurstCooldown and _oldShootCooldowns[self.Info.ShootBurstCooldown] then
						self.Info.ShootBurstCooldown = _oldShootCooldowns[self.Info.ShootBurstCooldown]
					end
				end
				return oldStartShooting(self, ...)
			end)
		end

		State.gunModsHooked = true
	end)
end

return GunMods
