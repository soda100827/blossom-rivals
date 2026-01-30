--!strict

--// Services
local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

--// Dependencies (require)
local State = require("../State")
local Constants = require("../Constants")
local PlayerUtils = require("../../../shared/PlayerUtils")
local TeamUtils = require("../../../shared/TeamUtils")

--// Constants

--// Types

--// Private state
local Targeting = {}
local _raycastParams = RaycastParams.new()
local _raycastFilter = table.create(2)
local _cachedMouseLocation = Vector2.zero
local _cachedCamera = nil :: Camera?
local _lastUpdate = 0

_raycastParams.FilterType = Enum.RaycastFilterType.Exclude

--// Private helpers
local function _getBestPartForCharacter(
	character: Model,
	camera: Camera,
	localCharacter: Model?,
	mouseLocation: Vector2
): (BasePart?, boolean, number)
	local bestPart: BasePart? = nil
	local shortestDistSq = math.huge
	local anyOnScreen = false

	local origin = camera.CFrame.Position

	local function checkPart(part: Instance)
		if not part:IsA("BasePart") then
			return
		end

		local screenPos, onScreen = camera:WorldToViewportPoint(part.Position)
		if not onScreen then
			if not bestPart then
				bestPart = part
			end
			return
		end

		if State.isWallCheckEnabled and not State.isManipulationEnabled then
			_raycastFilter[1] = localCharacter
			_raycastFilter[2] = character
			_raycastParams.FilterDescendantsInstances = _raycastFilter

			local direction = part.Position - origin
			local result = Workspace:Raycast(origin, direction, _raycastParams)
			if result then
				return
			end
		end

		anyOnScreen = true
		local dx = screenPos.X - mouseLocation.X
		local dy = screenPos.Y - mouseLocation.Y
		local distSq = (dx * dx) + (dy * dy)
		if distSq < shortestDistSq then
			shortestDistSq = distSq
			bestPart = part
		end
	end

	if State.isClosestPositionEnabled then
		for _, partName in ipairs(State.closestPositionWhitelist) do
			local p = character:FindFirstChild(partName)
			if p then
				checkPart(p)
			end
		end
	else
		local p = character:FindFirstChild(State.targetPart) or character:FindFirstChild("Head")
		if p then
			checkPart(p)
		end
	end

	return bestPart, anyOnScreen, shortestDistSq
end

local function _getTargetStateWithMouse(
	localPlayer: Player,
	player: Player,
	camera: Camera,
	mouseLocation: Vector2
): (boolean, BasePart?, boolean, number)
	if player == localPlayer then
		return false, nil, false, math.huge
	end
	if not TeamUtils.isInSameDuel(localPlayer, player) then
		return false, nil, false, math.huge
	end
	if TeamUtils.isSameTeam(player, localPlayer) then
		return false, nil, false, math.huge
	end

	local character = player.Character
	if not character then
		return false, nil, false, math.huge
	end

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoid or humanoid.Health <= 0 then
		return false, nil, false, math.huge
	end

	-- Check for ForceField (Spawn Protection)
	if character:FindFirstChildOfClass("ForceField") then
		return false, nil, false, math.huge
	end

	local bestPart, anyOnScreen, shortestDistSq =
		_getBestPartForCharacter(character, camera, localPlayer.Character, mouseLocation)

	if not bestPart then
		return false, nil, false, math.huge
	end

	local shortestDist = if shortestDistSq == math.huge then math.huge else math.sqrt(shortestDistSq)
	return true, bestPart, anyOnScreen, shortestDist
end

--// Public API
function Targeting.getTargetState(player: Player): (boolean, BasePart?, boolean, number)
	_refreshCaches()
	local camera = _getCamera()
	local localPlayer = PlayerUtils.getLocalPlayer()
	local mouseLocation = _getMouseLocation()
	return _getTargetStateWithMouse(localPlayer, player, camera, mouseLocation)
end

function Targeting.getBestTarget(radius: number): Player?
	_refreshCaches()
	local localPlayer = PlayerUtils.getLocalPlayer()
	if not TeamUtils.isInDuel(localPlayer) then
		return nil
	end
	local camera = _getCamera()
	local mouseLocation = _getMouseLocation()

	local bestTarget: Player? = nil
	local shortestDistance = radius

	for _, player in ipairs(Players:GetPlayers()) do
		if player == localPlayer then
			continue
		end
		local isValid, headPart, onScreen, distance =
			_getTargetStateWithMouse(localPlayer, player, camera, mouseLocation)
		if not isValid or not headPart or not onScreen then
			continue
		end

		if distance > radius then
			continue
		end
		if distance < shortestDistance then
			shortestDistance = distance
			bestTarget = player
		end
	end

	return bestTarget
end

function Targeting.resolveTarget(): Player?
	if State.target then
		local dropRadius = State.fovRadius * Constants.TARGET_DROP_FOV_MULTIPLIER
		_refreshCaches()
		local camera = _getCamera()
		local localPlayer = PlayerUtils.getLocalPlayer()
		local mouseLocation = _getMouseLocation()
		local isValid, headPart, onScreen, distance =
			_getTargetStateWithMouse(localPlayer, State.target, camera, mouseLocation)
		if isValid and headPart and onScreen and distance <= dropRadius then
			State.targetLostAt = nil
			return State.target
		end

		if not isValid or not headPart then
			State.targetLostAt = nil
			State.target = nil
		else
			local now = os.clock()
			local targetLostAt = State.targetLostAt
			if not targetLostAt then
				targetLostAt = now
				State.targetLostAt = now
			end
			if now - (targetLostAt :: number) < Constants.TARGET_DROP_DELAY then
				return State.target
			end
			State.targetLostAt = nil
			State.target = nil
		end
	end
	local newTarget = Targeting.getBestTarget(State.fovRadius)
	State.target = newTarget
	return newTarget
end

function Targeting.resolveSilentTarget(): Player?
	if State.silentTarget then
		local dropRadius = State.silentAimFovRadius * Constants.TARGET_DROP_FOV_MULTIPLIER
		_refreshCaches()
		local camera = _getCamera()
		local localPlayer = PlayerUtils.getLocalPlayer()
		local mouseLocation = _getMouseLocation()
		local isValid, headPart, onScreen, distance =
			_getTargetStateWithMouse(localPlayer, State.silentTarget, camera, mouseLocation)
		if isValid and headPart and onScreen and distance <= dropRadius then
			State.silentTargetLostAt = nil
			return State.silentTarget
		end

		if not isValid or not headPart then
			State.silentTargetLostAt = nil
			State.silentTarget = nil
		else
			local now = os.clock()
			local silentTargetLostAt = State.silentTargetLostAt
			if not silentTargetLostAt then
				silentTargetLostAt = now
				State.silentTargetLostAt = now
			end
			if now - (silentTargetLostAt :: number) < Constants.TARGET_DROP_DELAY then
				return State.silentTarget
			end
			State.silentTargetLostAt = nil
			State.silentTarget = nil
		end
	end
	local newTarget = Targeting.getBestTarget(State.silentAimFovRadius)
	State.silentTarget = newTarget
	return newTarget
end

function Targeting.getClosestSilentTarget(): BasePart?
	_refreshCaches()
	local camera = _getCamera()
	local localPlayer = PlayerUtils.getLocalPlayer()

	if not TeamUtils.isInDuel(localPlayer) then
		return nil
	end

	local closest: BasePart? = nil
	local closestDistSq = State.silentAimFovRadius * State.silentAimFovRadius
	local mouseLocation = _getMouseLocation()

	for _, entity in ipairs(CollectionService:GetTagged("Entity")) do
		if entity == localPlayer.Character or entity.Name == localPlayer.Name then
			continue
		end

		local player = Players:GetPlayerFromCharacter(entity :: Model)
		if player and not TeamUtils.isInSameDuel(localPlayer, player) then
			continue
		end
		if player and TeamUtils.isSameTeam(player, localPlayer) then
			continue
		end

		local hum = entity:FindFirstChildOfClass("Humanoid")
		if not hum or hum.Health <= 0 then
			continue
		end

		local bestPart, anyOnScreen, distSq =
			_getBestPartForCharacter(entity :: Model, camera, localPlayer.Character, mouseLocation)
		if not anyOnScreen or not bestPart then
			continue
		end

		if distSq < closestDistSq then
			closest = bestPart
			closestDistSq = distSq
		end
	end
	return closest
end

return Targeting
local function _refreshCaches()
	local now = os.clock()
	if now - _lastUpdate < Constants.TARGETING_UPDATE_INTERVAL then
		return
	end
	_lastUpdate = now
	_cachedMouseLocation = UserInputService:GetMouseLocation()
	_cachedCamera = PlayerUtils.getCamera()
end

local function _getMouseLocation(): Vector2
	return _cachedMouseLocation
end

local function _getCamera(): Camera
	return (_cachedCamera or PlayerUtils.getCamera()) :: Camera
end
