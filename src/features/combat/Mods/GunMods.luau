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
		end

		State.isGunModsHooked = true
	end)
end

return GunMods
