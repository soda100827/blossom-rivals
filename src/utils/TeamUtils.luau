--!strict

--// Services
local Players = game:GetService("Players")

--// Dependencies (require)
local Maid = require("Packages/_Index/soda100827_maid@0.4.0/maid") :: any

--// Types
export type TeamId = string | number | Instance | BrickColor | Color3

export type TeamUtils = {
	getPlayerTeamId: (player: Player) -> TeamId?,
	isSameTeam: (playerA: Player, playerB: Player) -> boolean,
	isInDuel: (player: Player) -> boolean,
}

--// Private state
local TeamUtils = {}
TeamUtils.__index = TeamUtils

local getfenvAny = getfenv :: any
local env = getfenvAny(0) :: any
local genv = (env.getgenv and env.getgenv()) or env
local _cache = (genv.cache or env.cache) :: any

local _maid = Maid.new()
local _state = {}
local _signals = {}

local _fighterController = nil :: any -- any: controller shape is dynamic.

--// Private helpers
local function _clearPlayerCache(player: Player)
	if _cache and _cache.iscached and _cache.invalidate then
		if _cache.iscached(player) then
			_cache.invalidate(player)
		end
	end
end

local function _connect()
	local removeConn = Players.PlayerRemoving:Connect(function(player)
		_clearPlayerCache(player)
	end)
	_maid:GiveTask(removeConn)
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

_connect()

return TeamUtils
