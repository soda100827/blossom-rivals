--!strict

-- Services
local Players = game:GetService("Players")

-- Dependencies (require)
local ExecutorUtils = require("src/shared/ExecutorUtils")
local HookUtils = require("src/shared/HookUtils")
local PlayerUtils = require("src/shared/PlayerUtils")
local State = require("src/features/combat/State")
local TeamUtils = require("src/shared/TeamUtils")
local Helpers = require("src/features/combat/Utils/Helpers")

-- Constants
local AURA_UPDATE_INTERVAL = 0.03
local AURA_IDLE_INTERVAL = 0.15

-- Types
type CheckCaller = () -> boolean

-- Private state
local Module = {}
Module.__index = Module

local _maid = nil :: any
local _signals = {}
local _state = {
  cachedLocalPlayer = nil :: Player?,
  cachedLocalRoot = nil :: BasePart?,
  lastLocalCacheUpdate = 0,
  lastFighterFetch = 0,
  hookedItems = {} :: { [any]: boolean },
  checkcaller = nil :: CheckCaller?,
}

-- Private helpers
local function _getDistance(p1: Vector3, p2: Vector3): number
  return (p1 - p2).Magnitude
end

local function _refreshLocalCache(): ()
  local now = os.clock()
  if now - _state.lastLocalCacheUpdate < 0.25 then
    return
  end
  _state.lastLocalCacheUpdate = now
  local localPlayer = PlayerUtils.getLocalPlayer()
  _state.cachedLocalPlayer = localPlayer
  local character = localPlayer and localPlayer.Character
  _state.cachedLocalRoot = character and (character:FindFirstChild("HumanoidRootPart") :: BasePart?) or nil
end

local function _getClosestEnemy(localPlayer: Player, localRoot: BasePart): (Player?, BasePart?)
  local closestPlayer: Player? = nil
  local closestRoot: BasePart? = nil
  local closestDist = math.huge
  for _, player in ipairs(Players:GetPlayers()) do
    if player == localPlayer then
      continue
    end
    if TeamUtils.isSameTeam(player, localPlayer) then
      continue
    end
    if not TeamUtils.isInSameDuel(localPlayer, player) then
      continue
    end

    local character = player.Character
    if not character then
      continue
    end
    local root = character:FindFirstChild("HumanoidRootPart") :: BasePart?
    local hum = character:FindFirstChildOfClass("Humanoid")
    if not root or not hum or hum.Health <= 0 then
      continue
    end

    local dist = _getDistance(localRoot.Position, root.Position)
    if dist < closestDist then
      closestDist = dist
      closestPlayer = player
      closestRoot = root
    end
  end
  return closestPlayer, closestRoot
end

local function _hookMeleeStartShooting(itemMod: any): ()
  if _state.hookedItems[itemMod] then
    return
  end
  _state.hookedItems[itemMod] = true

  local oldStartShooting
  oldStartShooting = HookUtils.safeHook(itemMod, "StartShooting", function(self, ...)
    local checkcaller = _state.checkcaller :: CheckCaller
    if not checkcaller() then
      local info = (self :: any).Info
      local originalCooldown = info and info.AttackCooldown
      if type(originalCooldown) == "number" then
        info.AttackCooldown = originalCooldown * (State.meleeAttackCooldownMultiplier / 100)
      end

      local result = table.pack(oldStartShooting(self, ...))

      if type(originalCooldown) == "number" then
        info.AttackCooldown = originalCooldown
      end
      return table.unpack(result)
    end
    return oldStartShooting(self, ...)
  end, State.logger, _maid)
end

-- Public API
function Module.setup(maid: any): ()
  _maid = maid
  local checkcaller = ExecutorUtils.getGlobal("checkcaller") :: CheckCaller
  _state.checkcaller = checkcaller

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

    local meleeMod = Helpers.getMeleeModule()
    if meleeMod then
      local oldStartShooting
      oldStartShooting = HookUtils.safeHook(meleeMod, "StartShooting", function(self, ...)
        if not checkcaller() then
          local info = (self :: any).Info

          if State.isMeleeAuraEnabled then
            (self :: any)._attack_cooldown = 0
            (self :: any)._equip_cooldown = 0
          end

          local originalCooldown: number = info.AttackCooldown
          info.AttackCooldown = originalCooldown * (State.meleeAttackCooldownMultiplier / 100)

          local result = table.pack(oldStartShooting(self, ...))

          info.AttackCooldown = originalCooldown

          return table.unpack(result)
        end
        return oldStartShooting(self, ...)
      end, State.logger, _maid)

      local oldCanQuickAttack
      oldCanQuickAttack = HookUtils.safeHook(meleeMod, "CanQuickAttack", function(self, ...)
        if not checkcaller() and State.isMeleeAuraEnabled then
          return true
        end
        return oldCanQuickAttack(self, ...)
      end, State.logger, _maid)
    end

    local itemModules = Helpers.getItemModules()
    if itemModules then
      for _, itemScript in ipairs(itemModules:GetChildren()) do
        if itemScript:IsA("ModuleScript") then
          pcall(function()
            local dynamicRequire = require :: any
            local itemMod = dynamicRequire(itemScript)
            local info = itemMod and itemMod.Info
            if itemMod and itemMod.StartShooting and info and info.AttackCooldown then
              _hookMeleeStartShooting(itemMod)
            end
          end)
        end
      end

      local itemsToHook = { "Katana", "Scythe", "BowieKnife" }
      for _, itemName in ipairs(itemsToHook) do
        local itemScript = itemModules:FindFirstChild(itemName)
        if itemScript and itemScript:IsA("ModuleScript") then
          pcall(function()
            local dynamicRequire = require :: any
            local itemMod = dynamicRequire(itemScript)
            if itemMod and itemMod.StartAiming then
              local oldStartAiming
              oldStartAiming = HookUtils.safeHook(itemMod, "StartAiming", function(self, ...)
                if not checkcaller() then
                  local info = (self :: any).Info
                  local cooldownFields = { "DeflectCooldown", "DashCooldown", "InvisCooldown" }
                  local originals: { [string]: number } = {}
                  for _, field in ipairs(cooldownFields) do
                    if info[field] then
                      originals[field] = info[field]
                      info[field] = originals[field] * (State.meleeSkillCooldownMultiplier / 100)
                    end
                  end

                  local result = table.pack(oldStartAiming(self, ...))

                  for field, val in pairs(originals) do
                    info[field] = val
                  end
                  return table.unpack(result)
                end
                return oldStartAiming(self, ...)
              end, State.logger, _maid)
            end
          end)
        end
      end
    end
  end)

  task.spawn(function()
    while isRunning do
      _refreshLocalCache()
      local localPlayer = _state.cachedLocalPlayer
      local localRoot = _state.cachedLocalRoot
      local character = localPlayer and localPlayer.Character

      local now = os.clock()
      if now - _state.lastFighterFetch >= 0.25 then
        _state.lastFighterFetch = now
        Helpers.fetchFighterController(State.logger)
      end
      local localFighter = State.fighterController and State.fighterController.LocalFighter

      if
        localPlayer
        and localRoot
        and character
        and localFighter
        and (State.isMeleeAuraEnabled or State.isTeleportAuraEnabled)
      then
        local target, targetRoot = _getClosestEnemy(localPlayer, localRoot)
        if target and targetRoot then
          if State.isTeleportAuraEnabled then
            localRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 1.5)
          end

          if State.isMeleeAuraEnabled then
            local equipped = localFighter.EquippedItem
            if not equipped or (equipped.Info and equipped.Info.IsGun) then
              pcall(function()
                if localFighter.EquipItem then
                  localFighter:EquipItem(3)
                end
              end)
            end

            equipped = localFighter.EquippedItem
            if equipped and (equipped.Info and not equipped.Info.IsGun) then
              if equipped.StartShooting then
                equipped:Input("StartShooting")
              end
            end
          end
        end
      end
      task.wait(
        if State.isMeleeAuraEnabled or State.isTeleportAuraEnabled
          then AURA_UPDATE_INTERVAL
          else AURA_IDLE_INTERVAL
      )
    end
  end)
end

return Module
