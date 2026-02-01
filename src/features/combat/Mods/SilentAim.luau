--!strict

-- Services

-- Dependencies (require)
local ExecutorUtils = require("src/shared/ExecutorUtils")
local HookUtils = require("src/shared/HookUtils")
local PlayerUtils = require("src/shared/PlayerUtils")
local State = require("src/features/combat/State")
local Helpers = require("src/features/combat/Utils/Helpers")
local Targeting = require("src/features/combat/Systems/Targeting")

-- Constants

-- Types
type CheckCaller = () -> boolean
type NewCClosure = (func: (...unknown) -> ...unknown) -> (...unknown) -> ...unknown

-- Private state
local Module = {}
Module.__index = Module

local _maid = nil :: any
local _signals = {}
local _state = {
  lastSilentTargetPos = nil :: Vector3?,
  lastSilentOrigin = nil :: Vector3?,
}

-- Private helpers
local function _isGunAction(): boolean
  local debugGlobal = ExecutorUtils.getGlobal("debug")
  local traceback = debugGlobal and debugGlobal.traceback or debug.traceback
  local stack = traceback()
  return (
    stack:find("StartShooting")
    or stack:find("GetEntitiesFromRaycast")
    or stack:find("_LocalTracers")
    or stack:find("_ImpactMarker")
  ) ~= nil
end

-- Public API
function Module.isGunAction(): boolean
  return _isGunAction()
end

function Module.setup(maid: any): ()
  _maid = maid
  local checkcaller = ExecutorUtils.getGlobal("checkcaller") :: CheckCaller
  local newcclosure = ExecutorUtils.getGlobal("newcclosure") :: NewCClosure

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

    local utility = Helpers.getUtility()
    if utility and not State.isUtilityHooked then
      State.isUtilityHooked = true

      local oldRaycast
      oldRaycast = HookUtils.safeHook(utility, "Raycast", function(self, origin, target, distance, filter, ...)
        if not State.isSilentAimEnabled then
          return oldRaycast(self, origin, target, distance, filter, ...)
        end

        if State.isRagebotShooting or (not checkcaller() and _isGunAction()) then
          if State.logger then
            State.logger:info("[SilentAim] Hook Activated! MagebotTrigger:", State.isRagebotShooting)
          end
          if math.random(1, 100) > State.silentHitChance then
            _state.lastSilentTargetPos = nil
            return oldRaycast(self, origin, target, distance, filter, ...)
          end

          local targetPart = Targeting.getClosestSilentTarget()
          local localPlayer = PlayerUtils.getLocalPlayer()
          local localChar = localPlayer and localPlayer.Character
          if targetPart and localChar and not targetPart:IsDescendantOf(localChar) then
            local newOrigin = origin
            _state.lastSilentTargetPos = targetPart.Position
            _state.lastSilentOrigin = newOrigin
            return oldRaycast(self, newOrigin, targetPart.Position, distance, filter, ...)
          end
        end
        _state.lastSilentTargetPos = nil
        _state.lastSilentOrigin = nil
        return oldRaycast(self, origin, target, distance, filter, ...)
      end, State.logger, _maid)

      local oldEncode
      oldEncode = HookUtils.safeHook(utility, "EncodeCFrame", function(self, cf)
        if not checkcaller() and State.isSilentAimEnabled and _state.lastSilentTargetPos and _isGunAction() then
          local originPos = cf.Position
          local newCF = CFrame.lookAt(originPos, _state.lastSilentTargetPos :: Vector3)
          return oldEncode(self, newCF)
        end
        return oldEncode(self, cf)
      end, State.logger, _maid)
    end

    local cameraShaker = Helpers.getCameraShaker()
    if cameraShaker and not State.isCameraShakerHooked then
      State.isCameraShakerHooked = true
      local mt = getmetatable(cameraShaker.Presets)
      if mt and mt.__index then
        local oldIdx = mt.__index
        mt.__index = newcclosure(function(t, k)
          if State.isSilentAimEnabled and (k == "StartShooting" or k == "") then
            return nil
          end
          return oldIdx(t, k)
        end)
        if _maid then
          _maid:GiveTask(function()
            mt.__index = oldIdx
          end)
        end
      end
    end
  end)
end

return Module
