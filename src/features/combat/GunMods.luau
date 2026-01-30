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
	local checkcaller = Helpers.getGlobal("checkcaller") or function()
		return false
	end

	task.spawn(function()
		-- 1. No Recoil (ClientItem._Recoil)
		local clientItemMod = Helpers.getClientItemModule()
		if clientItemMod and not State.gunModsHooked then
			local oldRecoil
			oldRecoil = Helpers.safeHook(clientItemMod, "_Recoil", function(self, multiplier)
				if not checkcaller() and State.isNoRecoilEnabled then
					return -- Prevent recoil
				end
				return oldRecoil(self, multiplier)
			end, State.logger)
		end

		-- 2. No Spread (GameplayUtility.GetSpread) - Visuals only but a good start
		local gameplayUtility = Helpers.getGameplayUtility()
		if gameplayUtility then
			local oldGetSpread
			oldGetSpread = Helpers.safeHook(gameplayUtility, "GetSpread", function(self, ...)
				if not checkcaller() and State.isNoSpreadEnabled then
					return CFrame.identity -- 0 spread
				end
				return oldGetSpread(self, ...)
			end, State.logger)
		end

		-- 3. No Muzzle Flash (ClientViewModel.MuzzleFlash)
		local viewModelMod = Helpers.getViewModelModule()
		if viewModelMod then
			local oldMuzzleFlash
			oldMuzzleFlash = Helpers.safeHook(viewModelMod, "MuzzleFlash", function(self, ...)
				if not checkcaller() and State.isNoMuzzleFlashEnabled then
					return -- Prevent muzzle flash
				end
				return oldMuzzleFlash(self, ...)
			end, State.logger)
		end

		-- 4. Gun Action hooks (Fire Rate & Packet Manipulation)
		local gunMod = Helpers.getGunModule()
		if gunMod then
			local oldStartShooting
			oldStartShooting = Helpers.safeHook(gunMod, "StartShooting", function(self, ...)
				if checkcaller() then
					return oldStartShooting(self, ...)
				end

				-- Capture Originals
				local info = self.Info
				local infoStr = tostring(info)

				-- We use distinct keys for Spread/Burst/Cooldown to avoid conflicts
				if not _oldShootCooldowns[infoStr .. "_Shoot"] then
					_oldShootCooldowns[infoStr .. "_Shoot"] = info.ShootCooldown
				end
				if not _oldShootCooldowns[infoStr .. "_Burst"] then
					_oldShootCooldowns[infoStr .. "_Burst"] = info.ShootBurstCooldown
				end
				if not _oldShootCooldowns[infoStr .. "_Spread"] then
					_oldShootCooldowns[infoStr .. "_Spread"] = info.ShootSpread
				end
				if not _oldShootCooldowns[infoStr .. "_AimML"] then
					_oldShootCooldowns[infoStr .. "_AimML"] = info.AimSpreadMultiplier
				end
				if not _oldShootCooldowns[infoStr .. "_Quick"] then
					_oldShootCooldowns[infoStr .. "_Quick"] = info.QuickShotSpread
				end

				local origShoot = _oldShootCooldowns[infoStr .. "_Shoot"]
				local origBurst = _oldShootCooldowns[infoStr .. "_Burst"]
				local origSpread = _oldShootCooldowns[infoStr .. "_Spread"]
				local origAimML = _oldShootCooldowns[infoStr .. "_AimML"]
				local origQuick = _oldShootCooldowns[infoStr .. "_Quick"]

				-- Apply Modifications
				if State.isNoSpreadEnabled then
					info.ShootSpread = 0
					info.AimSpreadMultiplier = 0
					if info.QuickShotSpread then
						info.QuickShotSpread = 0
					end
				end

				if State.attackCooldownMultiplier < 100 then
					info.ShootCooldown = origShoot * (State.attackCooldownMultiplier / 100)
					if info.ShootBurstCooldown then
						info.ShootBurstCooldown = origBurst * (State.attackCooldownMultiplier / 100)
					end
				end

				-- Call Original
				local returns = { oldStartShooting(self, ...) }

				-- Restore Originals Immediately
				info.ShootCooldown = origShoot
				if info.ShootBurstCooldown then
					info.ShootBurstCooldown = origBurst
				end
				info.ShootSpread = origSpread
				info.AimSpreadMultiplier = origAimML
				if info.QuickShotSpread then
					info.QuickShotSpread = origQuick
				end

				-- No Spread: Force "IsFullyAiming" flag in the packet sent to server
				if State.isNoSpreadEnabled and #returns >= 4 then
					returns[4] = true
				end

				return unpack(returns)
			end, State.logger)
		end

		State.gunModsHooked = true
	end)
end

return GunMods
