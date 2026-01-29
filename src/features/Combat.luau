--!strict

--// Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

--// Dependencies (require)
local Maid = require("Packages/_Index/soda100827_maid@0.4.0/maid") :: any

--// Constants
local CONSTANTS = {
	FOV_CIRCLE_COLOR = Color3.fromRGB(255, 255, 255),
	FOV_CIRCLE_THICKNESS = 1,
	FOV_CIRCLE_NUM_SIDES = 64,
	MIN_AIM_SPEED = 4,
	MAX_AIM_SPEED = 40,
	MAX_SMOOTHNESS = 1,
	TARGET_DROP_DELAY = 0.15,
	TARGET_DROP_FOV_MULTIPLIER = 1.2,
	AIMBOT_RENDER_STEP_NAME = "CombatAimbot",
}

--// Types
export type CombatFeature = {
	init: (self: CombatFeature, client: any) -> (),
	cleanup: (self: CombatFeature) -> (),
	setAimbotEnabled: (self: CombatFeature, isEnabled: boolean) -> (),
	setFovEnabled: (self: CombatFeature, isEnabled: boolean) -> (),
	setFovRadius: (self: CombatFeature, radius: number) -> (),
	setFovColor: (self: CombatFeature, color: Color3) -> (),
	setFovTransparency: (self: CombatFeature, transparency: number) -> (),
	setTeamCheckEnabled: (self: CombatFeature, isEnabled: boolean) -> (),
	setSmoothness: (self: CombatFeature, smoothness: number) -> (),
	setWallCheckEnabled: (self: CombatFeature, isEnabled: boolean) -> (),
	setSilentAimEnabled: (self: CombatFeature, isEnabled: boolean) -> (),
	setSilentAimFovEnabled: (self: CombatFeature, isEnabled: boolean) -> (),
	setSilentAimFovRadius: (self: CombatFeature, radius: number) -> (),
	setSilentAimFovColor: (self: CombatFeature, color: Color3) -> (),
	setSilentAimFovTransparency: (self: CombatFeature, transparency: number) -> (),
	setSilentHitChance: (self: CombatFeature, chance: number) -> (),
	setTargetPart: (self: CombatFeature, part: string) -> (),
	setManipulationEnabled: (self: CombatFeature, enabled: boolean) -> (),
	setAntiKatanaEnabled: (self: CombatFeature, enabled: boolean) -> (),
	setClosestPositionEnabled: (self: CombatFeature, enabled: boolean) -> (),
	setClosestPositionWhitelist: (self: CombatFeature, whitelist: { string }) -> (),
}

--// Private state
local Combat = {}
Combat.__index = Combat

local _maid = nil :: any
local _state: {
	client: any,
	logger: any,
	isAimbotEnabled: boolean,
	isSilentAimEnabled: boolean,
	isFovEnabled: boolean,
	isSilentAimFovEnabled: boolean,
	fovRadius: number,
	silentAimFovRadius: number,
	fovColor: Color3,
	silentAimFovColor: Color3,
	fovTransparency: number,
	silentAimFovTransparency: number,
	silentHitChance: number,
	targetPart: string,
	isManipulationEnabled: boolean,
	isAntiKatanaEnabled: boolean,
	isClosestPositionEnabled: boolean,
	closestPositionWhitelist: { string },
	isTeamCheckEnabled: boolean,
	isWallCheckEnabled: boolean,
	smoothness: number,
	target: Player?,
	silentTarget: Player?,
	targetLostAt: number?,
	silentTargetLostAt: number?,
	fovCircle: any?,
	silentAimFovCircle: any?,
	cameraController: any?,
	fighterController: any?,
	remoteHooked: boolean,
	utilityHooked: boolean,
	cameraShakerHooked: boolean,
	isInputLocked: boolean,
	mouseBehavior: Enum.MouseBehavior?,
	mouseDeltaSensitivity: number?,
} =
	{
		client = nil :: any,
		logger = nil :: any,
		isAimbotEnabled = false,
		isSilentAimEnabled = false,
		isFovEnabled = true,
		isSilentAimFovEnabled = true,
		fovRadius = 100,
		silentAimFovRadius = 100,
		fovColor = CONSTANTS.FOV_CIRCLE_COLOR,
		silentAimFovColor = CONSTANTS.FOV_CIRCLE_COLOR,
		fovTransparency = 0,
		silentAimFovTransparency = 0,
		silentHitChance = 100,
		targetPart = "Head",
		isManipulationEnabled = false,
		isAntiKatanaEnabled = false,
		isClosestPositionEnabled = false,
		closestPositionWhitelist = { "Head" },
		isTeamCheckEnabled = false,
		isWallCheckEnabled = false,
		smoothness = 0,
		target = nil,
		silentTarget = nil,
		targetLostAt = nil,
		silentTargetLostAt = nil,
		fovCircle = nil,
		silentAimFovCircle = nil,
		cameraController = nil,
		fighterController = nil,
		remoteHooked = false,
		utilityHooked = false,
		cameraShakerHooked = false,
		isInputLocked = false,
		mouseBehavior = nil,
		mouseDeltaSensitivity = nil,
	}

local function _getGlobal(name: string): any
	local getfenvAny = getfenv :: any
	local env = getfenvAny(0) :: any
	local genv = (env.getgenv and env.getgenv()) or env
	return genv[name] or env[name]
end

local function _getUtility(): any
	local replicatedStorage = game:GetService("ReplicatedStorage")
	local modules = replicatedStorage:WaitForChild("Modules", 5)
	if not modules then
		return nil
	end
	local utility = modules:WaitForChild("Utility", 5)
	if not utility then
		return nil
	end
	local success, result = pcall(function()
		local dynamicRequire = require :: any
		return dynamicRequire(utility)
	end)
	return success and result or nil
end

local function _getCameraShaker(): any
	local localPlayer = game:GetService("Players").LocalPlayer
	local playerScripts = localPlayer:WaitForChild("PlayerScripts", 5)
	if not playerScripts then
		return nil
	end
	local modules = playerScripts:WaitForChild("Modules", 5)
	if not modules then
		return nil
	end
	local cameraShaker = modules:WaitForChild("CameraShaker", 5)
	if not cameraShaker then
		return nil
	end
	local success, result = pcall(function()
		local dynamicRequire = require :: any
		return dynamicRequire(cameraShaker)
	end)
	return success and result or nil
end

--// Private helpers
local function _getCamera(): Camera
	local camera = Workspace.CurrentCamera
	if not camera then
		camera = Workspace:WaitForChild("Camera") :: Camera
	end
	return camera
end

local function _getLocalPlayer(): Player
	return Players.LocalPlayer
end

local function _getDrawingLib()
	local getfenvAny = getfenv :: any
	local g = getfenvAny(0) :: any
	local lib = g.Drawing
	if not lib and g.getgenv then
		lib = g.getgenv().Drawing
	end
	if not lib then
		lib = rawget(_G, "Drawing")
	end
	return lib
end

local function _applyInputLock(isLocked: boolean)
	if isLocked and _state.smoothness < CONSTANTS.MAX_SMOOTHNESS then
		return
	end
	if isLocked == _state.isInputLocked then
		return
	end

	if isLocked then
		if _state.mouseBehavior == nil then
			_state.mouseBehavior = UserInputService.MouseBehavior
		end
		if _state.mouseDeltaSensitivity == nil then
			_state.mouseDeltaSensitivity = UserInputService.MouseDeltaSensitivity
		end
		UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
		UserInputService.MouseDeltaSensitivity = 0
	else
		local restoreBehavior = _state.mouseBehavior or Enum.MouseBehavior.Default
		local restoreSensitivity = _state.mouseDeltaSensitivity or 1
		UserInputService.MouseBehavior = restoreBehavior
		UserInputService.MouseDeltaSensitivity = restoreSensitivity
		_state.mouseBehavior = nil
		_state.mouseDeltaSensitivity = nil
	end

	_state.isInputLocked = isLocked
end

local function _isMaxSmoothness(): boolean
	return _state.smoothness >= CONSTANTS.MAX_SMOOTHNESS
end

local function _fetchCameraController(logger: any)
	if _state.cameraController then
		return
	end
	if logger then
		logger:info("Fetching start...")
	end

	local playerScripts = _getLocalPlayer():WaitForChild("PlayerScripts")
	if not playerScripts then
		return
	end

	local controllers = playerScripts:WaitForChild("Controllers")
	if not controllers then
		return
	end

	local camControllerScript = controllers:WaitForChild("CameraController")
	if camControllerScript and camControllerScript:IsA("ModuleScript") then
		local success, result = pcall(function()
			local dynamicRequire = require :: any
			return dynamicRequire(camControllerScript)
		end)
		if success then
			_state.cameraController = result
			if logger then
				logger:info("Success CameraController")
			end
		else
			if logger then
				logger:error("Failed CameraController", result)
			end
		end
	end
end

local function _fetchFighterController(logger: any)
	if _state.fighterController then
		return
	end
	local playerScripts = _getLocalPlayer():WaitForChild("PlayerScripts", 10)
	if not playerScripts then
		return
	end

	local controllers = playerScripts:WaitForChild("Controllers", 10)
	if not controllers then
		return
	end

	local fighterControllerScript = controllers:WaitForChild("FighterController", 5)
	if fighterControllerScript and fighterControllerScript:IsA("ModuleScript") then
		local success, result = pcall(function()
			local dynamicRequire = require :: any
			return dynamicRequire(fighterControllerScript)
		end)
		if success then
			_state.fighterController = result
			if logger then
				logger:info("Success FighterController")
			end
		else
			if logger then
				logger:error("Failed FighterController", result)
			end
		end
	end
end

-- Moved to top

local _lastSilentTargetPos: Vector3? = nil

local function _isGunAction(): boolean
	local debugGlobal = _getGlobal("debug")
	local traceback = debugGlobal and debugGlobal.traceback or debug.traceback
	local stack = traceback()
	return (
		stack:find("StartShooting")
		or stack:find("GetEntitiesFromRaycast")
		or stack:find("_LocalTracers")
		or stack:find("_ImpactMarker")
	) ~= nil
end

local function _getClosestSilentTarget(): BasePart?
	local camera = _getCamera()
	local localPlayer = _getLocalPlayer()
	local collectionService = game:GetService("CollectionService")

	local closest, closestDist = nil, _state.silentAimFovRadius
	local screenCenter = camera.ViewportSize / 2

	for _, entity in ipairs(collectionService:GetTagged("Entity")) do
		if entity == localPlayer.Character then
			continue
		end

		local hum = entity:FindFirstChildOfClass("Humanoid")
		if not hum or hum.Health <= 0 then
			continue
		end

		local targetParts = {}
		if _state.isClosestPositionEnabled then
			for _, partName in ipairs(_state.closestPositionWhitelist) do
				local p = entity:FindFirstChild(partName)
				if p and p:IsA("BasePart") then
					table.insert(targetParts, p)
				end
			end
		else
			local p = entity:FindFirstChild(_state.targetPart) or entity:FindFirstChild("Head")
			if p and p:IsA("BasePart") then
				table.insert(targetParts, p)
			end
		end

		if #targetParts == 0 then
			continue
		end

		for _, targetPart in ipairs(targetParts) do
			-- Team check
			if _state.isTeamCheckEnabled then
				local player = game:GetService("Players"):GetPlayerFromCharacter(entity :: Model)
				if player and player.Team == localPlayer.Team then
					continue
				end
			end

			-- Wall check
			if _state.isWallCheckEnabled then
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
				local dist = (Vector2.new(pos.X, pos.Y) - screenCenter).Magnitude
				if dist < closestDist then
					closest = targetPart
					closestDist = dist
				end
			end
		end
	end
	return closest :: any
end

local function _setupSilentAim()
	local hookfunction = _getGlobal("hookfunction") or _getGlobal("replaceclosure")
	local checkcaller = _getGlobal("checkcaller") or function()
		return false
	end

	if not hookfunction then
		_state.logger:warn("hookfunction not found, Perfect Silent Aim will not work.")
		return
	end

	task.spawn(function()
		local utility = _getUtility()
		if utility and not _state.utilityHooked then
			_state.utilityHooked = true

			local oldRaycast
			oldRaycast = hookfunction(utility.Raycast, function(self, origin, target, distance, filter, ...)
				if
					not checkcaller()
					and _state.isSilentAimEnabled
					and (distance == 400 or distance == 999)
					and _isGunAction()
				then
					-- Hit Chance check
					if math.random(1, 100) > _state.silentHitChance then
						_lastSilentTargetPos = nil
						return oldRaycast(self, origin, target, distance, filter, ...)
					end

					local targetPart = _getClosestSilentTarget()
					if targetPart then
						_lastSilentTargetPos = targetPart.Position
						return oldRaycast(self, origin, targetPart.Position, distance, filter, ...)
					end
				end
				_lastSilentTargetPos = nil
				return oldRaycast(self, origin, target, distance, filter, ...)
			end)

			local oldEncode
			oldEncode = hookfunction(utility.EncodeCFrame, function(self, cf)
				if not checkcaller() and _state.isSilentAimEnabled and _lastSilentTargetPos and _isGunAction() then
					local newCF = CFrame.lookAt(cf.Position, _lastSilentTargetPos)
					return oldEncode(self, newCF)
				end
				return oldEncode(self, cf)
			end)

			_state.logger:info("Utility.Raycast and Utility.EncodeCFrame hooked for Silent Aim.")
		end

		local cameraShaker = _getCameraShaker()
		if cameraShaker and not _state.cameraShakerHooked then
			_state.cameraShakerHooked = true
			local mt = getmetatable(cameraShaker.Presets)
			if mt and mt.__index then
				local oldIdx = mt.__index
				mt.__index = function(t, k)
					if _state.isSilentAimEnabled and (k == "StartShooting" or k == "") then
						return nil
					end
					return oldIdx(t, k)
				end
				_state.logger:info("CameraShaker.Presets hooked to neutralize shake.")
			end
		end
	end)
end

local function _updateFovCircle()
	local lib = _getDrawingLib()
	if not lib then
		return
	end

	local function updateCircle(circleType, isEnabled, radius, color, transparency)
		local circle = _state[circleType]
		if isEnabled then
			if not circle then
				circle = lib.new("Circle")
				_state[circleType] = circle
			end

			local c = circle :: any
			c.Thickness = CONSTANTS.FOV_CIRCLE_THICKNESS
			c.NumSides = CONSTANTS.FOV_CIRCLE_NUM_SIDES
			c.Filled = false
			c.Color = color
			c.Transparency = math.clamp(transparency, 0, 1)

			local mouseLocation = UserInputService:GetMouseLocation()
			c.Position = mouseLocation
			c.Radius = radius
			c.Visible = true
		else
			local c = circle :: any
			if c then
				c.Visible = false
			end
		end
	end

	updateCircle("fovCircle", _state.isFovEnabled, _state.fovRadius, _state.fovColor, _state.fovTransparency)
	updateCircle(
		"silentAimFovCircle",
		_state.isSilentAimFovEnabled,
		_state.silentAimFovRadius,
		_state.silentAimFovColor,
		_state.silentAimFovTransparency
	)
end

local function _getTargetState(player: Player): (boolean, BasePart?, boolean, number)
	local camera = _getCamera()
	local localPlayer = _getLocalPlayer()
	if player == localPlayer then
		return false, nil, false, math.huge
	end
	if _state.isTeamCheckEnabled and player.Team == localPlayer.Team then
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
	if _state.isClosestPositionEnabled then
		for _, partName in ipairs(_state.closestPositionWhitelist) do
			local p = character:FindFirstChild(partName)
			if p and p:IsA("BasePart") then
				table.insert(targetParts, p)
			end
		end
	else
		local p = character:FindFirstChild(_state.targetPart) or character:FindFirstChild("Head")
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
		if _state.isWallCheckEnabled then
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

local function _getBestTarget(radius: number): Player?
	local localPlayer = _getLocalPlayer()

	local bestTarget = nil
	local shortestDistance = radius

	for _, player in ipairs(Players:GetPlayers()) do
		if player == localPlayer then
			continue
		end
		local isValid, headPart, onScreen, distance = _getTargetState(player)
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

local function _resolveTarget(): Player?
	if _state.target then
		local dropRadius = _state.fovRadius * CONSTANTS.TARGET_DROP_FOV_MULTIPLIER
		local isValid, headPart, onScreen, distance = _getTargetState(_state.target)
		if isValid and headPart and onScreen and distance <= dropRadius then
			_state.targetLostAt = nil
			return _state.target
		end

		if not isValid or not headPart then
			_state.targetLostAt = nil
			_state.target = nil
		else
			local now = os.clock()
			local targetLostAt = _state.targetLostAt
			if not targetLostAt then
				targetLostAt = now
				_state.targetLostAt = now
			end
			if now - (targetLostAt :: number) < CONSTANTS.TARGET_DROP_DELAY then
				return _state.target
			end
			_state.targetLostAt = nil
			_state.target = nil
		end
	end
	local newTarget = _getBestTarget(_state.fovRadius)
	_state.target = newTarget
	return newTarget
end

local function _resolveSilentTarget(): Player?
	if _state.silentTarget then
		local dropRadius = _state.silentAimFovRadius * CONSTANTS.TARGET_DROP_FOV_MULTIPLIER
		local isValid, headPart, _onScreen, _distance = _getTargetState(_state.silentTarget)
		if isValid and headPart and _onScreen and _distance <= dropRadius then
			_state.silentTargetLostAt = nil
			return _state.silentTarget
		end

		if not isValid or not headPart then
			_state.silentTargetLostAt = nil
			_state.silentTarget = nil
		else
			local now = os.clock()
			local silentTargetLostAt = _state.silentTargetLostAt
			if not silentTargetLostAt then
				silentTargetLostAt = now
				_state.silentTargetLostAt = now
			end
			if now - (silentTargetLostAt :: number) < CONSTANTS.TARGET_DROP_DELAY then
				return _state.silentTarget
			end
			_state.silentTargetLostAt = nil
			_state.silentTarget = nil
		end
	end
	local newTarget = _getBestTarget(_state.silentAimFovRadius)
	_state.silentTarget = newTarget
	return newTarget
end

local function _aimAt(target: Player, bestPart: BasePart, deltaTime: number)
	if not target.Character then
		return
	end
	local targetPos = (bestPart :: BasePart).Position

	local camera = _getCamera()
	-- Calculate LookVector needed
	local currentCFrame = camera.CFrame
	local lookAtCFrame = CFrame.lookAt(currentCFrame.Position, targetPos)

	if not _state.cameraController or not _state.cameraController.SetRotation then
		local alpha = 1
		if not _isMaxSmoothness() then
			local speed = CONSTANTS.MIN_AIM_SPEED
				+ (1 - _state.smoothness) * (CONSTANTS.MAX_AIM_SPEED - CONSTANTS.MIN_AIM_SPEED)
			alpha = 1 - math.exp(-speed * deltaTime)
		end
		camera.CFrame = currentCFrame:Lerp(lookAtCFrame, alpha)
		return
	end

	-- We need to extract the Pitch (X) and Yaw (Y) rotation from this CFrame
	-- CameraController:SetRotation(Vector2) logic usually calls for X and Y in radians
	-- But typically Rotation.X is Pitch, Rotation.Y is Yaw
	local x, y, _ = lookAtCFrame:ToOrientation()
	-- ToOrientation returns (X, Y, Z) in radians (Pitch, Yaw, Roll)
	-- Roblox order: Y (Yaw), X (Pitch), Z (Roll) for EulerAngles?
	-- ToOrientation returns (RX, RY, RZ).

	local targetRotation = Vector2.new(x, y)

	-- Smoothness
	if _isMaxSmoothness() then
		_state.cameraController:SetRotation(targetRotation)
	elseif _state.smoothness > 0 then
		local currentRot = _state.cameraController.Rotation :: Vector2
		local speed = CONSTANTS.MIN_AIM_SPEED
			+ (1 - _state.smoothness) * (CONSTANTS.MAX_AIM_SPEED - CONSTANTS.MIN_AIM_SPEED)
		local alpha = 1 - math.exp(-speed * deltaTime)
		local newRot = currentRot:Lerp(targetRotation, alpha)
		_state.cameraController:SetRotation(newRot)
	else
		_state.cameraController:SetRotation(targetRotation)
	end
end

local function _connect()
	_maid:DoCleaning()
	task.spawn(function()
		_fetchCameraController(_state.logger)
	end)
	_setupSilentAim()

	RunService:BindToRenderStep(
		CONSTANTS.AIMBOT_RENDER_STEP_NAME,
		Enum.RenderPriority.Camera.Value + 1,
		function(deltaTime)
			_updateFovCircle()

			if _state.isAimbotEnabled then
				local target = _resolveTarget()
				if target then
					local _isValid, _bestPart, _anyOnScreen, _shortestDist = _getTargetState(target)
					if _isValid and _bestPart then
						_applyInputLock(true)
						_aimAt(target, _bestPart, deltaTime)
					else
						_applyInputLock(false)
					end
				else
					_applyInputLock(false)
				end
			else
				_state.target = nil
				_applyInputLock(false)
			end

			if _state.isSilentAimEnabled then
				-- Silent target is now handled by hooks synchronously during raycast calls,
				-- but we can still resolve it here for UI/Drawing purposes if needed.
				_resolveSilentTarget()
			else
				_state.silentTarget = nil
			end
		end
	)
	_maid:GiveTask(function()
		RunService:UnbindFromRenderStep(CONSTANTS.AIMBOT_RENDER_STEP_NAME)
	end)
end

local function _disconnect()
	if _state.fovCircle then
		pcall(function()
			(_state.fovCircle :: any):Remove()
		end)
		_state.fovCircle = nil
	end
	if _state.silentAimFovCircle then
		pcall(function()
			(_state.silentAimFovCircle :: any):Remove()
		end)
		_state.silentAimFovCircle = nil
	end
	_state.target = nil
	_state.silentTarget = nil
	_state.targetLostAt = nil
	_state.silentTargetLostAt = nil
	_applyInputLock(false)
	_maid:DoCleaning()
end

--// Public API
function Combat.init(self: CombatFeature, client: any): ()
	_state.client = client
	_state.logger = client.Logger
	_maid = Maid.new()
	_connect()
end

function Combat.cleanup(self: CombatFeature): ()
	_state.isAimbotEnabled = false
	_disconnect()
end

function Combat.setAimbotEnabled(self: CombatFeature, isEnabled: boolean): ()
	if _state.isAimbotEnabled == isEnabled then
		return
	end
	_state.logger:info("Set Aimbot Enabled:", isEnabled)
	_state.isAimbotEnabled = isEnabled
	if not isEnabled then
		_state.target = nil
		_state.targetLostAt = nil
		_applyInputLock(false)
	end
end

function Combat.setFovEnabled(self: CombatFeature, isEnabled: boolean): ()
	_state.isFovEnabled = isEnabled
end

function Combat.setFovRadius(self: CombatFeature, radius: number): ()
	_state.fovRadius = radius
end

function Combat.setFovColor(self: CombatFeature, color: Color3): ()
	_state.fovColor = color
end

function Combat.setFovTransparency(self: CombatFeature, transparency: number): ()
	_state.fovTransparency = math.clamp(transparency, 0, 1)
end

function Combat.setTeamCheckEnabled(self: CombatFeature, isEnabled: boolean): ()
	_state.isTeamCheckEnabled = isEnabled
end

function Combat.setSmoothness(self: CombatFeature, smoothness: number): ()
	local wasMaxSmoothness = _isMaxSmoothness()
	_state.smoothness = math.clamp(smoothness, 0, CONSTANTS.MAX_SMOOTHNESS)
	if wasMaxSmoothness and not _isMaxSmoothness() then
		_applyInputLock(false)
	end
end

function Combat.setWallCheckEnabled(self: CombatFeature, isEnabled: boolean): ()
	_state.isWallCheckEnabled = isEnabled
end

function Combat.setSilentAimEnabled(self: CombatFeature, isEnabled: boolean): ()
	_state.logger:info("Set Silent Aim Enabled:", isEnabled)
	_state.isSilentAimEnabled = isEnabled
	if not isEnabled then
		_state.silentTarget = nil
		_state.silentTargetLostAt = nil
	end
end

function Combat.setSilentAimFovEnabled(self: CombatFeature, isEnabled: boolean): ()
	_state.isSilentAimFovEnabled = isEnabled
end

function Combat.setSilentAimFovRadius(self: CombatFeature, radius: number): ()
	_state.silentAimFovRadius = radius
end

function Combat.setSilentAimFovColor(self: CombatFeature, color: Color3): ()
	_state.silentAimFovColor = color
end

function Combat.setSilentAimFovTransparency(self: CombatFeature, transparency: number): ()
	_state.silentAimFovTransparency = math.clamp(transparency, 0, 1)
end

function Combat.setSilentHitChance(self: CombatFeature, chance: number): ()
	_state.silentHitChance = math.clamp(chance, 0, 100)
end

function Combat.setTargetPart(self: CombatFeature, part: string): ()
	_state.targetPart = part
end

function Combat.setManipulationEnabled(self: CombatFeature, enabled: boolean): ()
	_state.isManipulationEnabled = enabled
end

function Combat.setAntiKatanaEnabled(self: CombatFeature, enabled: boolean): ()
	_state.isAntiKatanaEnabled = enabled
end

function Combat.setClosestPositionEnabled(self: CombatFeature, enabled: boolean): ()
	_state.isClosestPositionEnabled = enabled
end

function Combat.setClosestPositionWhitelist(self: CombatFeature, whitelist: { string }): ()
	_state.closestPositionWhitelist = whitelist
end

return Combat
