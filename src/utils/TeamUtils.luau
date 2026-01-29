--!strict

--// Services
local Players = game:GetService("Players")

--// Dependencies (require)

--// Constants
local TEAM_ATTRIBUTE_KEYS = {
	"TeamId",
}

--// Types
export type TeamId = string | number | Instance | BrickColor | Color3

export type TeamUtils = {
	getPlayerTeamId: (player: Player) -> TeamId?,
	isSameTeam: (playerA: Player, playerB: Player) -> boolean,
}

--// Private state
local TeamUtils = {}
TeamUtils.__index = TeamUtils

local _fighterController = nil :: any -- any: controller shape is dynamic.
local _searchedController = false

--// Private helpers
local function _getFighterController(): any
	if _searchedController then
		return _fighterController
	end
	_searchedController = true

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

local function _readAttributeTeam(container: Instance): TeamId?
	for _, key in ipairs(TEAM_ATTRIBUTE_KEYS) do
		local value = container:GetAttribute(key) :: TeamId?
		if value ~= nil then
			return value
		end
	end
	return nil
end

local function _readValueObjectTeam(container: Instance): TeamId?
	for _, key in ipairs(TEAM_ATTRIBUTE_KEYS) do
		local valueObj = container:FindFirstChild(key)
		if valueObj and valueObj:IsA("ValueBase") then
			return ((valueObj :: any).Value :: TeamId?) -- any: ValueBase.Value is not typed in Luau.
		end
	end
	return nil
end

local function _getTeamFromFighter(fighter: any): TeamId?
	if not fighter then
		return nil
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
		return TeamUtils.getPlayerTeamId(owner)
	end

	return nil
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
	local fighterTeam = _getTeamFromFighter(fighter)
	if fighterTeam ~= nil then
		return fighterTeam
	end

	local playerAttr = _readAttributeTeam(player)
	if playerAttr ~= nil then
		return playerAttr
	end

	local playerValue = _readValueObjectTeam(player)
	if playerValue ~= nil then
		return playerValue
	end

	local character = player.Character
	if character then
		local characterAttr = _readAttributeTeam(character)
		if characterAttr ~= nil then
			return characterAttr
		end

		local characterValue = _readValueObjectTeam(character)
		if characterValue ~= nil then
			return characterValue
		end
	end

	return nil
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

	return teamA == teamB
end

return TeamUtils
