--!strict

--// Services
local Players = game:GetService("Players")

--// Dependencies (require)
local PlayerUtils = require("../../../shared/PlayerUtils")
local TeamUtils = require("../../../shared/TeamUtils")
local Helpers = require("../Utils/Helpers")
local State = require("../State")

--// Constants
local TARGET_REFRESH_INTERVAL = 0.5
local UNDERGROUND_OFFSET = Vector3.new(0, -50, 0)
local TELEPORT_OFFSET = CFrame.new(0, 0, -2)

--// Types

--// Private state
local Ragebot = {}
Ragebot.__index = Ragebot

local _maid = nil :: any
local _signals = {}
local _state = {
  lastTargetRefresh = 0,
}

--// Private helpers
local function _isRoundStarted(): boolean
  local duel = TeamUtils.getLocalDuel()
  if not duel or not duel.Get then
    return false
  end
  local ok, status = pcall(duel.Get, duel, "Status")
  if not ok then
    return false
  end
  return status == "RoundStarted"
end

local function _getValidTarget(localPlayer: Player): Player?
  local localChar = localPlayer.Character
  local localRoot = localChar and localChar:FindFirstChild("HumanoidRootPart")
  if not localRoot then
    return nil
  end

  local closest: Player? = nil
  local closestDist = math.huge

  for _, player in ipairs(Players:GetPlayers()) do
    if player == localPlayer then
      continue
    end
    if not TeamUtils.isInSameDuel(localPlayer, player) then
      continue
    end
    if TeamUtils.isSameTeam(player, localPlayer) then
      continue
    end

    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not character or not humanoid or not root or humanoid.Health <= 0 then
      continue
    end

    local distance = (root.Position - localRoot.Position).Magnitude
    if distance < closestDist then
      closestDist = distance
      closest = player
    end
  end

  return closest
end

local function _refreshTarget(localPlayer: Player): Player?
  local now = os.clock()
  if now - _state.lastTargetRefresh < TARGET_REFRESH_INTERVAL then
    return State.ragebotTarget
  end
  _state.lastTargetRefresh = now

  local target = State.ragebotTarget
  if target then
    if not TeamUtils.isInSameDuel(localPlayer, target) then
      target = nil
    elseif TeamUtils.isSameTeam(target, localPlayer) then
      target = nil
    else
      local char = target.Character
      local hum = char and char:FindFirstChildOfClass("Humanoid")
      if not char or not hum or hum.Health <= 0 then
        target = nil
      end
    end
  end

  if not target then
    target = _getValidTarget(localPlayer)
  end

  State.ragebotTarget = target
  return target
end

local function _isReloading(item: any): boolean
  local reloadCooldown = item and item._reload_cooldown
  if type(reloadCooldown) == "number" and tick() < reloadCooldown then
    return true
  end
  if item and item.IsEquipping and item:IsEquipping() then
    return true
  end
  local equipCooldown = item and item._equip_cooldown
  if type(equipCooldown) == "number" and tick() < equipCooldown then
    return true
  end
  return false
end

local function _autoShoot(localFighter: any)
  local equipped = localFighter and localFighter.EquippedItem
  if not equipped then
    return
  end
  if equipped.Input then
    equipped:Input("StartShooting")
    return
  end
  if equipped.StartShooting then
    equipped:StartShooting()
  end
end

--// Public API
function Ragebot.setup(maid: any): ()
  _maid = maid
end

function Ragebot.update(): ()
  if not State.isRagebotEnabled then
    return
  end

  local localPlayer = PlayerUtils.getLocalPlayer()
  if not localPlayer or not TeamUtils.isInDuel(localPlayer) then
    State.ragebotTarget = nil
    return
  end

  local localChar = localPlayer.Character
  local localRoot = localChar and localChar:FindFirstChild("HumanoidRootPart")
  local localHumanoid = localChar and localChar:FindFirstChildOfClass("Humanoid")
  if not localRoot or not localHumanoid or localHumanoid.Health <= 0 then
    return
  end

  Helpers.fetchFighterController(State.logger)
  local localFighter = State.fighterController and State.fighterController.LocalFighter

  if localFighter and _isReloading(localFighter.EquippedItem) then
    if not State.ragebotHomeCFrame then
      State.ragebotHomeCFrame = localRoot.CFrame
    end
    localRoot.CFrame = State.ragebotHomeCFrame * CFrame.new(UNDERGROUND_OFFSET)
    return
  end

  if State.ragebotHomeCFrame then
    localRoot.CFrame = State.ragebotHomeCFrame
    State.ragebotHomeCFrame = nil
  end

  if not _isRoundStarted() then
    return
  end

  local target = _refreshTarget(localPlayer)
  if not target then
    return
  end

  local targetChar = target.Character
  local targetRoot = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
  if not targetRoot then
    return
  end

  localRoot.CFrame = targetRoot.CFrame * TELEPORT_OFFSET
  if localFighter then
    _autoShoot(localFighter)
  end
end

return Ragebot
