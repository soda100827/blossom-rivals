--!strict

--// Services

--// Dependencies (require)
local ExecutorUtils = require("../../../shared/ExecutorUtils")
local HookUtils = require("../../../shared/HookUtils")
local State = require("../State")
local Helpers = require("../Utils/Helpers")

--// Constants

--// Types

--// Private state
local GunMods = {}
GunMods.__index = GunMods

local _maid = nil :: any
local _signals = {}
local _state = {
	oldShootCooldowns = {} :: { [any]: number },
}

--// Private helpers

--// Public API
function GunMods.setup(maid: any): ()
	_maid = maid
	local checkcaller = ExecutorUtils.getGlobal("checkcaller") or function()
		return false
	end

	local isRunning = true
	if _maid then
		_maid:GiveTask(function()
			isRunning = false
		end)
	end

	task.spawn(function()
		if not isRunning then
			return
		end

		-- 1. No Recoil (ClientItem._Recoil)
		local clientItemMod = Helpers.getClientItemModule()
		if clientItemMod and not State.isGunModsHooked then
			local oldRecoil
			oldRecoil = HookUtils.safeHook(clientItemMod, "_Recoil", function(self, multiplier)
				if not checkcaller() and State.isNoRecoilEnabled then
					return -- Prevent recoil
				end
				return oldRecoil(self, multiplier)
			end, State.logger, _maid)
		end

		-- 2. No Spread (GameplayUtility.GetSpread) - Visuals only but a good start
		local gameplayUtility = Helpers.getGameplayUtility()
		if gameplayUtility then
			local oldGetSpread
			oldGetSpread = HookUtils.safeHook(gameplayUtility, "GetSpread", function(self, ...)
				if not checkcaller() and State.isNoSpreadEnabled then
					return CFrame.identity -- 0 spread
				end
				return oldGetSpread(self, ...)
			end, State.logger, _maid)
		end

		-- 3. No Muzzle Flash (ClientViewModel.MuzzleFlash)
		local viewModelMod = Helpers.getViewModelModule()
		if viewModelMod then
			local oldMuzzleFlash
			oldMuzzleFlash = HookUtils.safeHook(viewModelMod, "MuzzleFlash", function(self, ...)
				if not checkcaller() and State.isNoMuzzleFlashEnabled then
					return -- Prevent muzzle flash
				end
				return oldMuzzleFlash(self, ...)
			end, State.logger, _maid)
		end

		-- 4. ReplicatedClass hooks for "IsAiming" state bypass
		local replicatedClassMod = Helpers.getReplicatedClassModule()
		if replicatedClassMod then
			local oldGet
			oldGet = HookUtils.safeHook(replicatedClassMod, "Get", function(self, key)
				-- Only spoof IsAiming execution of StartShooting to allow NoSpread without locking camera
				if not checkcaller() and State.isNoSpreadEnabled and key == "IsAiming" and State.forcingAim then
					return true
				end
				return oldGet(self, key)
			end, State.logger, _maid)
		end

		-- 5. Gun Action hooks (Fire Rate & Packet Manipulation)
		local gunMod = Helpers.getGunModule()
		if gunMod then
			-- Helper hook for IsFullyAiming to support StartShooting logic
			local oldIsFullyAiming
			oldIsFullyAiming = HookUtils.safeHook(gunMod, "IsFullyAiming", function(self, ...)
				if not checkcaller() and State.isNoSpreadEnabled and State.forcingAim then
					return true
				end
				return oldIsFullyAiming(self, ...)
			end, State.logger, _maid)

			local oldStartShooting
			oldStartShooting = HookUtils.safeHook(gunMod, "StartShooting", function(self, ...)
				if checkcaller() then
					return oldStartShooting(self, ...)
				end

				local selfAny = self :: any
				local savedShootCooldown = selfAny._shoot_cooldown
				local savedReloadCooldown = selfAny._reload_cooldown
				local savedEquipCooldown = selfAny._equip_cooldown
				local savedNoAmmoCooldown = selfAny._shoot_cooldown_no_ammo

				if State.isRagebotEnabled then
					selfAny._shoot_cooldown = 0
					selfAny._reload_cooldown = 0
					selfAny._equip_cooldown = 0
					selfAny._shoot_cooldown_no_ammo = 0
				end

				-- Capture Originals
				local info = self.Info
				local infoStr = tostring(info)

				-- We use distinct keys for Spread/Burst/Cooldown to avoid conflicts
				if not _state.oldShootCooldowns[infoStr .. "_Shoot"] then
					_state.oldShootCooldowns[infoStr .. "_Shoot"] = info.ShootCooldown
				end
				if not _state.oldShootCooldowns[infoStr .. "_Burst"] then
					_state.oldShootCooldowns[infoStr .. "_Burst"] = info.ShootBurstCooldown
				end
				if not _state.oldShootCooldowns[infoStr .. "_Spread"] then
					_state.oldShootCooldowns[infoStr .. "_Spread"] = info.ShootSpread
				end
				if not _state.oldShootCooldowns[infoStr .. "_AimML"] then
					_state.oldShootCooldowns[infoStr .. "_AimML"] = info.AimSpreadMultiplier
				end
				if not _state.oldShootCooldowns[infoStr .. "_Quick"] then
					_state.oldShootCooldowns[infoStr .. "_Quick"] = info.QuickShotSpread
				end

				local origShoot = _state.oldShootCooldowns[infoStr .. "_Shoot"]
				local origBurst = _state.oldShootCooldowns[infoStr .. "_Burst"]
				local origSpread = _state.oldShootCooldowns[infoStr .. "_Spread"]
				local origAimML = _state.oldShootCooldowns[infoStr .. "_AimML"]
				local origQuick = _state.oldShootCooldowns[infoStr .. "_Quick"]

				-- Apply Modifications
				if State.isNoSpreadEnabled then
					info.ShootSpread = 0
					info.AimSpreadMultiplier = 0
					if info.QuickShotSpread then
						info.QuickShotSpread = 0
					end
					-- Enable Scoped Aim Spoofing
					State.forcingAim = true
				end

				if State.attackCooldownMultiplier < 100 then
					info.ShootCooldown = origShoot * (State.attackCooldownMultiplier / 100)
					if info.ShootBurstCooldown then
						info.ShootBurstCooldown = origBurst * (State.attackCooldownMultiplier / 100)
					end
				end

				-- Call Original
				local returns = { oldStartShooting(self, ...) }

				-- Disable Scoped Aim Spoofing
				State.forcingAim = false

				if State.isRagebotEnabled then
					selfAny._shoot_cooldown = savedShootCooldown
					selfAny._reload_cooldown = savedReloadCooldown
					selfAny._equip_cooldown = savedEquipCooldown
					selfAny._shoot_cooldown_no_ammo = savedNoAmmoCooldown
				end

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
			end, State.logger, _maid)
		end

		State.isGunModsHooked = true
	end)
end

return GunMods
