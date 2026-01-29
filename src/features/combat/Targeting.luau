--!strict
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local State = require("./State")
local Constants = require("./Constants")
local Helpers = require("./Helpers")

local Targeting = {}

function Targeting.getTargetState(player: Player): (boolean, BasePart?, boolean, number)
	local camera = Helpers.getCamera()
	local localPlayer = Helpers.getLocalPlayer()
	if player == localPlayer then
		return false, nil, false, math.huge
	end
	if State.isTeamCheckEnabled and player.Team == localPlayer.Team then
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

	local targetParts = {}
	if State.isClosestPositionEnabled then
		for _, partName in ipairs(State.closestPositionWhitelist) do
			local p = character:FindFirstChild(partName)
			if p and p:IsA("BasePart") then
				table.insert(targetParts, p)
			end
		end
	else
		local p = character:FindFirstChild(State.targetPart) or character:FindFirstChild("Head")
		if p and p:IsA("BasePart") then
			table.insert(targetParts, p)
		end
	end

	if #targetParts == 0 then
		return false, nil, false, math.huge
	end

	local bestPart = nil
	local shortestDist = math.huge
	local anyOnScreen = false

	local mouseLocation = UserInputService:GetMouseLocation()

	for _, part in ipairs(targetParts) do
		if State.isWallCheckEnabled then
			local origin = camera.CFrame.Position
			local direction = part.Position - origin
			local raycastParams = RaycastParams.new()
			raycastParams.FilterDescendantsInstances = { localPlayer.Character :: any, character }
			raycastParams.FilterType = Enum.RaycastFilterType.Exclude

			local result = Workspace:Raycast(origin, direction, raycastParams)
			if result then
				continue
			end
		end

		local screenPos, onScreen = camera:WorldToViewportPoint(part.Position)
		if not onScreen then
			if not bestPart then
				bestPart = part
			end
			continue
		end

		anyOnScreen = true
		local distance = (Vector2.new(screenPos.X, screenPos.Y) - mouseLocation).Magnitude
		if distance < shortestDist then
			shortestDist = distance
			bestPart = part
		end
	end

	if not bestPart then
		return false, nil, false, math.huge
	end

	return true, bestPart, anyOnScreen, shortestDist
end

function Targeting.getBestTarget(radius: number): Player?
	local localPlayer = Helpers.getLocalPlayer()

	local bestTarget = nil
	local shortestDistance = radius

	for _, player in ipairs(Players:GetPlayers()) do
		if player == localPlayer then
			continue
		end
		local isValid, headPart, onScreen, distance = Targeting.getTargetState(player)
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
		local isValid, headPart, onScreen, distance = Targeting.getTargetState(State.target)
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
		local isValid, headPart, onScreen, distance = Targeting.getTargetState(State.silentTarget)
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
	local camera = Helpers.getCamera()
	local localPlayer = Helpers.getLocalPlayer()
	local collectionService = game:GetService("CollectionService")

	local closest, closestDist = nil, State.silentAimFovRadius
	local mouseLocation = UserInputService:GetMouseLocation()

	for _, entity in ipairs(collectionService:GetTagged("Entity")) do
		if entity == localPlayer.Character then
			continue
		end

		local hum = entity:FindFirstChildOfClass("Humanoid")
		if not hum or hum.Health <= 0 then
			continue
		end

		local targetParts = {}
		if State.isClosestPositionEnabled then
			for _, partName in ipairs(State.closestPositionWhitelist) do
				local p = entity:FindFirstChild(partName)
				if p and p:IsA("BasePart") then
					table.insert(targetParts, p)
				end
			end
		else
			local p = entity:FindFirstChild(State.targetPart) or entity:FindFirstChild("Head")
			if p and p:IsA("BasePart") then
				table.insert(targetParts, p)
			end
		end

		if #targetParts == 0 then
			continue
		end

		for _, targetPart in ipairs(targetParts) do
			-- Team check
			if State.isTeamCheckEnabled then
				local player = game:GetService("Players"):GetPlayerFromCharacter(entity :: Model)
				if player and player.Team == localPlayer.Team then
					continue
				end
			end

			-- Wall check
			if State.isWallCheckEnabled then
				local origin = camera.CFrame.Position
				local direction = targetPart.Position - origin
				local raycastParams = RaycastParams.new()
				raycastParams.FilterDescendantsInstances = { localPlayer.Character :: any, entity }
				raycastParams.FilterType = Enum.RaycastFilterType.Exclude

				local result = Workspace:Raycast(origin, direction, raycastParams)
				if result then
					continue
				end
			end

			local pos, onScreen = camera:WorldToViewportPoint(targetPart.Position)
			if onScreen then
				local dist = (Vector2.new(pos.X, pos.Y) - mouseLocation).Magnitude
				if dist < closestDist then
					closest = targetPart
					closestDist = dist
				end
			end
		end
	end
	return closest :: any
end

return Targeting
