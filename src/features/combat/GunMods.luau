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

		-- 2. No Spread (GameplayUtility.GetSpread) - Visuals only but a good start
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

		-- 4. ReplicatedClass hooks for "IsAiming" state bypass
		local replicatedClassMod = Helpers.getReplicatedClassModule()
		if replicatedClassMod then
			-- Forced IsAiming state bypass
			local oldGet
			oldGet = hookfunction(replicatedClassMod.Get, function(self, key)
				if not checkcaller() and State.isNoSpreadEnabled and key == "IsAiming" then
					return true
				end
				return oldGet(self, key)
			end)

			local oldSetReplicate
			oldSetReplicate = hookfunction(replicatedClassMod.SetReplicate, function(self, key, value, unreliable)
				if not checkcaller() and State.isNoSpreadEnabled and key == "IsAiming" then
					value = true
				end
				return oldSetReplicate(self, key, value, unreliable)
			end)
		end

		-- 5. Gun Action hooks (Fire Rate & Packet Manipulation)
		local gunMod = Helpers.getGunModule()
		if gunMod then
			local oldStartShooting
			oldStartShooting = hookfunction(gunMod.StartShooting, function(self, ...)
				if checkcaller() then
					return oldStartShooting(self, ...)
				end

				-- No Spread: Modify Info properties before internal calculations
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
				end

				-- Attack Cooldown: Modify fire rate
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
				end

				local returns = { oldStartShooting(self, ...) }

				-- No Spread: Force "IsFullyAiming" flag in the packet sent to server
				if State.isNoSpreadEnabled and #returns >= 4 then
					returns[4] = true
				end

				return unpack(returns)
			end)

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
