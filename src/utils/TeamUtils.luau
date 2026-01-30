--!strict

--// Services
local Players = game:GetService("Players")

--// Dependencies (require)

--// Constants
local TEAM_ATTRIBUTE_KEYS = {
	"TeamID",
	"TeamId",
}

--// Types
export type TeamId = string | number | Instance | BrickColor | Color3

export type TeamUtils = {
	getPlayerTeamId: (player: Player) -> TeamId?,
	isSameTeam: (playerA: Player, playerB: Player) -> boolean,
	isInDuel: (player: Player) -> boolean,
	setDebugEnabled: (isEnabled: boolean) -> (),
	setTeamSource: (source: string?) -> (),
}

--// Private state
local TeamUtils = {}
TeamUtils.__index = TeamUtils

local _maid = nil :: any
local _state = {
	isDebugEnabled = false,
	teamSource = nil :: string?,
}
local _signals = {}

local _fighterController = nil :: any -- any: controller shape is dynamic.

--// Private helpers
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
			return (valueObj :: any).Value :: TeamId? -- any: ValueBase.Value is not typed in Luau.
		end
	end
	return nil
end

local function _formatTeamValue(teamId: TeamId?): string
	if teamId == nil then
		return "nil"
	end
	local teamType = typeof(teamId)
	return string.format("%s(%s)", tostring(teamId), teamType)
end

local function _debugLog(player: Player, source: string, teamId: TeamId?)
	if not _state.isDebugEnabled then
		return
	end
	local playerName = player.Name
	print(string.format("[TeamUtils] %s source=%s team=%s", playerName, source, _formatTeamValue(teamId)))
end

local function _normalizeTeamId(teamId: TeamId?): TeamId?
	if teamId == nil then
		return nil
	end
	if typeof(teamId) == "Instance" then
		local instance = teamId :: Instance
		if instance:IsA("Team") then
			return instance
		end
	end
	return teamId
end

local function _areTeamsEqual(teamA: TeamId?, teamB: TeamId?): boolean
	if teamA == nil or teamB == nil then
		return false
	end

	teamA = _normalizeTeamId(teamA)
	teamB = _normalizeTeamId(teamB)

	if typeof(teamA) == "Instance" and typeof(teamB) == "Instance" then
		return teamA == teamB
	end

	if typeof(teamA) == "Instance" and teamA:IsA("Team") then
		local teamInstance = teamA :: Team
		if typeof(teamB) == "BrickColor" then
			return teamInstance.TeamColor == teamB
		end
		if typeof(teamB) == "Color3" then
			return teamInstance.TeamColor.Color == teamB
		end
		if typeof(teamB) == "string" then
			return teamInstance.Name == teamB
		end
	end

	if typeof(teamB) == "Instance" and teamB:IsA("Team") then
		local teamInstance = teamB :: Team
		if typeof(teamA) == "BrickColor" then
			return teamInstance.TeamColor == teamA
		end
		if typeof(teamA) == "Color3" then
			return teamInstance.TeamColor.Color == teamA
		end
		if typeof(teamA) == "string" then
			return teamInstance.Name == teamA
		end
	end

	if typeof(teamA) == "BrickColor" and typeof(teamB) == "BrickColor" then
		return teamA.Number == teamB.Number
	end

	if typeof(teamA) == "Color3" and typeof(teamB) == "Color3" then
		return teamA == teamB
	end

	return tostring(teamA) == tostring(teamB)
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
	local source = _state.teamSource

	if source == "fighter" then
		local fighterTeam = _getTeamFromFighter(fighter, player)
		_debugLog(player, "fighter", fighterTeam)
		return fighterTeam
	end

	if source == "player-attr" then
		local playerAttr = _readAttributeTeam(player)
		_debugLog(player, "player-attr", playerAttr)
		return playerAttr
	end

	if source == "player-value" then
		local playerValue = _readValueObjectTeam(player)
		_debugLog(player, "player-value", playerValue)
		return playerValue
	end

	local fighterTeam = _getTeamFromFighter(fighter, player)
	if fighterTeam ~= nil then
		_debugLog(player, "fighter", fighterTeam)
		return fighterTeam
	end

	local playerAttr = _readAttributeTeam(player)
	if playerAttr ~= nil then
		_debugLog(player, "player-attr", playerAttr)
		return playerAttr
	end

	local playerValue = _readValueObjectTeam(player)
	if playerValue ~= nil then
		_debugLog(player, "player-value", playerValue)
		return playerValue
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

	return _areTeamsEqual(teamA, teamB)
end

function TeamUtils.isInDuel(player: Player): boolean
	local controller = _getFighterController()
	local fighter = _getFighterForPlayer(controller, player)
	return _getFighterIsInDuel(fighter)
end

function TeamUtils.setDebugEnabled(isEnabled: boolean): ()
	_state.isDebugEnabled = isEnabled
end

function TeamUtils.setTeamSource(source: string?): ()
	_state.teamSource = source
end

return TeamUtils
