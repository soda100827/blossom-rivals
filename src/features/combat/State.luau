--!strict

--// Services

--// Dependencies (require)
local Types = require("./Types")
local Constants = require("./Constants")

--// Constants

--// Types

--// Private state
local _maid = nil :: any
local _signals = {}
local _state: Types.CombatState = {
  client = nil :: any,
  logger = nil :: any,
  isAimbotEnabled = false,
  isSilentAimEnabled = false,
  isFovEnabled = true,
  isSilentAimFovEnabled = true,
  fovRadius = 100,
  silentAimFovRadius = 100,
  fovColor = Constants.FOV_CIRCLE_COLOR,
  silentAimFovColor = Constants.FOV_CIRCLE_COLOR,
  fovTransparency = 0,
  silentAimFovTransparency = 0,
  silentHitChance = 100,
  targetPart = "Head",
  isManipulationEnabled = false,
  isAntiKatanaEnabled = false,
  isClosestPositionEnabled = true,
  closestPositionWhitelist = {
    "Head",
    "UpperTorso",
    "LowerTorso",
    "LeftUpperArm",
    "RightUpperArm",
    "LeftUpperLeg",
    "RightUpperLeg",
    "LowerTorso",
  },
  isWallCheckEnabled = false,
  smoothness = 0,
  isNoRecoilEnabled = false,
  isNoSpreadEnabled = false,
  isNoMuzzleFlashEnabled = false,
  attackCooldownMultiplier = 100, -- 100% (Normal)
  isMeleeAttackCooldownEnabled = false,
  meleeAttackCooldownMultiplier = 100,
  isMeleeSkillCooldownEnabled = false,
  meleeSkillCooldownMultiplier = 100,
  isMeleeAuraEnabled = false,
  isTeleportAuraEnabled = false,
  target = nil,
  silentTarget = nil,
  targetLostAt = nil,
  silentTargetLostAt = nil,
  fovCircle = nil,
  silentAimFovCircle = nil,
  cameraController = nil,
  fighterController = nil,
  isRemoteHooked = false,
  isUtilityHooked = false,
  isCameraShakerHooked = false,
  isGunModsHooked = false,
  isInputLocked = false,
  mouseBehavior = nil,
  mouseDeltaSensitivity = nil,
}

--// Private helpers

--// Public API
return _state
