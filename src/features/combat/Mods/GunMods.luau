--!strict

-- Services

-- Dependencies (require)
local ExecutorUtils = require("src/shared/ExecutorUtils")
local HookUtils = require("src/shared/HookUtils")
local State = require("src/features/combat/State")
local Helpers = require("src/features/combat/Utils/Helpers")

-- Constants

-- Types
type CheckCaller = () -> boolean

-- Private state
local Module = {}
Module.__index = Module

local _maid = nil :: any
local _signals = {}
local _state = {
  oldShootCooldowns = {} :: { [any]: number },
}

-- Private helpers

-- Public API
function Module.setup(maid: any): ()
  _maid = maid
  local checkcaller = ExecutorUtils.getGlobal("checkcaller") :: CheckCaller

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

    local clientItemMod = Helpers.getClientItemModule()
    if clientItemMod and not State.isGunModsHooked then
      local oldRecoil
      oldRecoil = HookUtils.safeHook(clientItemMod, "_Recoil", function(self, multiplier)
        if not checkcaller() and State.isNoRecoilEnabled then
          return
        end
        return oldRecoil(self, multiplier)
      end, State.logger, _maid)
    end

    local gameplayUtility = Helpers.getGameplayUtility()
    if gameplayUtility then
      local oldGetSpread
      oldGetSpread = HookUtils.safeHook(gameplayUtility, "GetSpread", function(self, ...)
        if not checkcaller() and State.isNoSpreadEnabled then
          return CFrame.identity
        end
        return oldGetSpread(self, ...)
      end, State.logger, _maid)
    end

    local viewModelMod = Helpers.getViewModelModule()
    if viewModelMod then
      local oldMuzzleFlash
      oldMuzzleFlash = HookUtils.safeHook(viewModelMod, "MuzzleFlash", function(self, ...)
        if not checkcaller() and State.isNoMuzzleFlashEnabled then
          return
        end
        return oldMuzzleFlash(self, ...)
      end, State.logger, _maid)
    end

    local replicatedClassMod = Helpers.getReplicatedClassModule()
    if replicatedClassMod then
      local oldGet
      oldGet = HookUtils.safeHook(replicatedClassMod, "Get", function(self, key)
        if not checkcaller() and State.isNoSpreadEnabled and key == "IsAiming" and State.forcingAim then
          return true
        end
        return oldGet(self, key)
      end, State.logger, _maid)
    end

    local gunMod = Helpers.getGunModule()
    if gunMod then
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

return Module
