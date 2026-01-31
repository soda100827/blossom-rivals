--!strict

--// Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

--// Dependencies (require)
local Maid = require("Packages/_Index/soda100827_maid@0.4.0/maid") :: any
local ExecutorUtils = require("./ExecutorUtils")

--// Constants

--// Types
export type TeamId = string | number | Instance | BrickColor | Color3

export type TeamUtils = {
  init: (self: TeamUtils, client: any) -> (),
  Destroy: (self: TeamUtils) -> (),
  getPlayerTeamId: (player: Player) -> TeamId?,
  isSameTeam: (playerA: Player, playerB: Player) -> boolean,
  isInDuel: (player: Player) -> boolean,
  isInSameDuel: (playerA: Player, playerB: Player) -> boolean,
}

--// Private state
local TeamUtils = {}
TeamUtils.__index = TeamUtils

local _cache = ExecutorUtils.getGlobal("cache") :: any

local _maid = nil :: any
local _state = {}
local _signals = {}

local _fighterController = nil :: any -- any: controller shape is dynamic.
local _duelController = nil :: any -- any: controller shape is dynamic.

--// Private helpers
local function _clearPlayerCache(player: Player)
  if _cache and _cache.iscached and _cache.invalidate then
    if _cache.iscached(player) then
      _cache.invalidate(player)
    end
  end
end

local function _connect()
  if not _maid then
    return
  end
  _maid:DoCleaning()
  local removeConn = Players.PlayerRemoving:Connect(function(player)
    _clearPlayerCache(player)
  end)
  _maid:GiveTask(removeConn)
end

local function _getDuelController(): any
  if _duelController then
    return _duelController
  end

  local localPlayer = Players.LocalPlayer
  if not localPlayer then
    return nil
  end
  local playerScripts = localPlayer:FindFirstChild("PlayerScripts")
  if not playerScripts then
    return nil
  end
  local controllers = playerScripts:FindFirstChild("Controllers")
  if not controllers then
    return nil
  end

  local duelControllerScript = controllers:FindFirstChild("DuelController")
  if not (duelControllerScript and duelControllerScript:IsA("ModuleScript")) then
    return nil
  end

  local success, result = pcall(function()
    local dynamicRequire = require :: any -- any: dynamic require for runtime module.
    return dynamicRequire(duelControllerScript)
  end)
  if success then
    _duelController = result
  end

  return _duelController
end

local function _getLocalDuel(): any
  local localPlayer = Players.LocalPlayer
  if not localPlayer then
    return nil
  end

  local duelController = _getDuelController()
  if not duelController or not duelController.GetDuel then
    return nil
  end

  local ok, duel = pcall(duelController.GetDuel, duelController, localPlayer)
  if ok then
    return duel
  end

  return nil
end

local function _getFighterController(): any
  if _fighterController then
    return _fighterController
  end

  local localPlayer = Players.LocalPlayer
  if not localPlayer then
    return nil
  end
  local playerScripts = localPlayer:FindFirstChild("PlayerScripts")
  if not playerScripts then
    return nil
  end
  local controllers = playerScripts:FindFirstChild("Controllers")
  if not controllers then
    return nil
  end

  local fighterControllerScript = controllers:FindFirstChild("FighterController")
  if not (fighterControllerScript and fighterControllerScript:IsA("ModuleScript")) then
    return nil
  end

  local success, result = pcall(function()
    local dynamicRequire = require :: any -- any: dynamic require for runtime module.
    return dynamicRequire(fighterControllerScript)
  end)
  if success then
    _fighterController = result
  end

  return _fighterController
end

local function _areTeamsEqual(teamA: TeamId?, teamB: TeamId?): boolean
  return teamA ~= nil and teamA == teamB
end

local function _getTeamFromFighter(fighter: any, fallbackPlayer: Player?): TeamId?
  if not fighter then
    return nil
  end

  local getFn = fighter.Get
  if getFn then
    local ok, teamId = pcall(getFn, fighter, "TeamID")
    if ok and teamId ~= nil then
      return teamId
    end
  end

  local teamValue = fighter.Team
    or fighter.team
    or fighter.TeamId
    or fighter.teamId
    or fighter.TeamID
    or fighter.teamID
    or fighter.Side
    or fighter.side

  if teamValue ~= nil then
    return teamValue
  end

  local owner = fighter.Owner or fighter.owner or fighter.Player or fighter.player
  if typeof(owner) == "Instance" and owner:IsA("Player") then
    if fallbackPlayer and owner == fallbackPlayer then
      return nil
    end
    return TeamUtils.getPlayerTeamId(owner)
  end

  return nil
end

local function _getFighterIsInDuel(fighter: any): boolean
  if not fighter then
    return false
  end

  local getFn = fighter.Get
  if getFn then
    local ok, isInDuel = pcall(getFn, fighter, "IsInDuel")
    if ok and isInDuel ~= nil then
      return isInDuel == true
    end
  end

  local value = fighter.IsInDuel or fighter.isInDuel
  if value ~= nil then
    return value == true
  end

  return false
end

local function _getFighterForPlayer(controller: any, player: Player): any
  if not controller then
    return nil
  end

  local getter = controller.getFighter
    or controller.GetFighter
    or controller.getFighterByPlayer
    or controller.GetFighterByPlayer
    or controller.getFighterFromPlayer
    or controller.GetFighterFromPlayer

  if getter then
    local ok, fighter = pcall(getter, controller, player)
    if ok and fighter then
      return fighter
    end
  end

  local fighters = controller.Fighters
    or controller.fighters
    or controller._fighters
    or controller.FighterByPlayer
    or controller.fighterByPlayer

  if fighters then
    return fighters[player] or fighters[player.UserId] or fighters[tostring(player.UserId)]
  end

  return nil
end

--// Public API
function TeamUtils.getPlayerTeamId(player: Player): TeamId?
  local controller = _getFighterController()
  local fighter = _getFighterForPlayer(controller, player)
  local fighterTeam = _getTeamFromFighter(fighter, player)
  return fighterTeam
end

function TeamUtils.isSameTeam(playerA: Player, playerB: Player): boolean
  if playerA == playerB then
    return true
  end

  local teamA = TeamUtils.getPlayerTeamId(playerA)
  if teamA == nil then
    return false
  end

  local teamB = TeamUtils.getPlayerTeamId(playerB)
  if teamB == nil then
    return false
  end

  return _areTeamsEqual(teamA, teamB)
end

function TeamUtils.isInDuel(player: Player): boolean
  local controller = _getFighterController()
  local fighter = _getFighterForPlayer(controller, player)
  return _getFighterIsInDuel(fighter)
end

function TeamUtils.isInSameDuel(playerA: Player, playerB: Player): boolean
  local localPlayer = Players.LocalPlayer
  if localPlayer and (playerA == localPlayer or playerB == localPlayer) then
    if not TeamUtils.isInDuel(localPlayer) then
      return false
    end
  end

  local localDuel = _getLocalDuel()
  if localDuel and localDuel.GetDueler then
    local okA, duelerA = pcall(localDuel.GetDueler, localDuel, playerA)
    if not okA or not duelerA then
      return false
    end
    local okB, duelerB = pcall(localDuel.GetDueler, localDuel, playerB)
    if not okB or not duelerB then
      return false
    end
    return true
  end

  local controller = _getFighterController()
  local fighterA = _getFighterForPlayer(controller, playerA)
  local fighterB = _getFighterForPlayer(controller, playerB)

  if not fighterA or not fighterB then
    return false
  end

  -- Check IsInDuel status first
  if not _getFighterIsInDuel(fighterA) or not _getFighterIsInDuel(fighterB) then
    return false
  end

  -- Try to match by MatchID or parent Arena
  local matchA = fighterA.Match or fighterA.MatchID or fighterA.MatchId or fighterA._match
  local matchB = fighterB.Match or fighterB.MatchID or fighterB.MatchId or fighterB._match
  if matchA and matchB and matchA == matchB then
    return true
  end

  -- Fallback: Check if they are in the same sub-folder in workspace if the game uses arenas
  local charA = playerA.Character
  local charB = playerB.Character
  if charA and charB and charA.Parent == charB.Parent and charA.Parent ~= Workspace then
    return true
  end

  return false
end

function TeamUtils.init(self: TeamUtils, _client: any): ()
  _maid = Maid.new()
  _connect()
end

function TeamUtils.Destroy(self: TeamUtils): ()
  if _maid then
    _maid:DoCleaning()
  end
  _fighterController = nil
  _duelController = nil
end

return TeamUtils
