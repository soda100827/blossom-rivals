--!strict

--// Services

--// Dependencies (require)
local Constants = require("./Constants")
local Types = require("./Types")

--// Constants

--// Types

--// Private state
local _maid = nil :: any
local _signals = {}
local _state: Types.PlayerState = {
  client = nil :: any,
  logger = nil :: any,
  character = nil,
  humanoid = nil,
  rootPart = nil,
  isFlyEnabled = false,
  isNoclipEnabled = false,
  isWalkSpeedEnabled = false,
  isJumpPowerEnabled = false,
  walkSpeedValue = 16,
  jumpPowerValue = 50,
  flySpeed = Constants.DEFAULT_FLY_SPEED,
  defaultWalkSpeed = nil,
  defaultJumpPower = nil,
  defaultJumpHeight = nil,
  defaultUseJumpPower = nil,
  defaultAutoRotate = nil,
  defaultPlatformStand = nil,
  noclipParts = {},
  characterMaid = nil :: any,
  input = {
    forward = 0,
    back = 0,
    left = 0,
    right = 0,
    up = 0,
    down = 0,
  },
  isSlideBoostEnabled = false,
  slideBoostMultiplier = 1,
  spoofDevice = "None",
  isSpoofDeviceEnabled = false,
  isAntiFlashEnabled = false,
  isSoundSpammerEnabled = false,
  soundSpammerType = "DoubleJump",
}

--// Private helpers

--// Public API
return _state
