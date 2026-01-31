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
local PlayerMods = {}
PlayerMods.__index = PlayerMods

local _maid = nil :: any
local _signals = {}
local _state = {
  lastSoundSpam = 0,
}

--// Private helpers

--// Public API
function PlayerMods.setup(maid: any): ()
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

    local replicatedClassMod = Helpers.getReplicatedClassModule()
    if replicatedClassMod then
      local oldGet
      oldGet = HookUtils.safeHook(replicatedClassMod, "Get", function(self, key)
        if not checkcaller() then
          if key == "SlidingSpeedMax" and State.isSlideBoostEnabled then
            return 3 * State.slideBoostMultiplier
          end
        end
        return oldGet(self, key)
      end, State.logger, _maid)
    end

    local controlsController = Helpers.getControlsController()
    local setControlsRemote = Helpers.getSetControlsRemote()
    if controlsController and setControlsRemote then
      local oldSetControls
      oldSetControls = HookUtils.safeHook(controlsController, "SetControls", function(self, device)
        if not checkcaller() and State.isSpoofDeviceEnabled and State.spoofDevice ~= "None" then
          device = State.spoofDevice
          -- If the game is trying to set a real device, we override and send our spoofed one
          setControlsRemote:FireServer(device)
        end
        return oldSetControls(self, device)
      end, State.logger, _maid)
    end

    -- Sound Spammer using Remote Event
    task.spawn(function()
      local playSoundRemote = Helpers.getPlayMechanicsSoundRemote()
      while isRunning do
        if State.isSoundSpammerEnabled and playSoundRemote then
          local now = os.clock()
          if now - _state.lastSoundSpam >= 0.5 then
            _state.lastSoundSpam = now
            pcall(function()
              playSoundRemote:FireServer(State.soundSpammerType)
            end)
          end
        end
        task.wait(0.1)
      end
    end)

    local flashedMod = Helpers.getFlashedModule()
    if flashedMod then
      local oldAttemptToFlash
      oldAttemptToFlash = HookUtils.safeHook(flashedMod, "AttemptToFlash", function(self, ...)
        if not checkcaller() and State.isAntiFlashEnabled then
          return
        end
        return oldAttemptToFlash(self, ...)
      end, State.logger, _maid)

      local oldFlash
      oldFlash = HookUtils.safeHook(flashedMod, "Flash", function(self, ...)
        if not checkcaller() and State.isAntiFlashEnabled then
          return
        end
        return oldFlash(self, ...)
      end, State.logger, _maid)
    end
  end)
end

return PlayerMods
