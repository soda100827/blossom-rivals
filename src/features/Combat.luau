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
	setHardLockEnabled: (self: CombatFeature, isEnabled: boolean) -> (),
}

--// Private state
local Combat = {}
Combat.__index = Combat

local _maid = nil :: any
local _state: {
	client: any,
	logger: any,
	isAimbotEnabled: boolean,
	isFovEnabled: boolean,
	fovRadius: number,
	fovColor: Color3,
	fovTransparency: number,
	isTeamCheckEnabled: boolean,
	isWallCheckEnabled: boolean,
	smoothness: number,
	isHardLockEnabled: boolean,
	target: Player?,
	fovCircle: any?,
	cameraController: any?,
	isInputLocked: boolean,
	mouseBehavior: Enum.MouseBehavior?,
	mouseDeltaSensitivity: number?,
} =
	{
		client = nil :: any,
		logger = nil :: any,
		isAimbotEnabled = false,
		isFovEnabled = false,
		fovRadius = 100,
		fovColor = CONSTANTS.FOV_CIRCLE_COLOR,
		fovTransparency = 0,
		isTeamCheckEnabled = false,
		isWallCheckEnabled = false,
		smoothness = 0,
		isHardLockEnabled = false,
		target = nil,
		fovCircle = nil,
		cameraController = nil,
		isInputLocked = false,
		mouseBehavior = nil,
		mouseDeltaSensitivity = nil,
	}

local _lastLogTime = 0
local function _throttleLog(...)
	if os.clock() - _lastLogTime > 2 then
		_state.logger:info(...)
		_lastLogTime = os.clock()
	end
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
	if isLocked and not _state.isHardLockEnabled then
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
			return require(camControllerScript)
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

local function _updateFovCircle()
	local lib = _getDrawingLib()
	if not lib then
		return
	end

	local circle = _state.fovCircle
	if _state.isFovEnabled then
		if not circle then
			circle = lib.new("Circle")
			_state.fovCircle = circle
		end

		-- Use local variable cast to 'any' to mute strict linting on dynamic drawing object
		local c = circle :: any

		c.Thickness = CONSTANTS.FOV_CIRCLE_THICKNESS
		c.NumSides = CONSTANTS.FOV_CIRCLE_NUM_SIDES
		c.Filled = false
		c.Color = _state.fovColor
		c.Transparency = math.clamp(_state.fovTransparency, 0, 1)

		local mouseLocation = UserInputService:GetMouseLocation()
		c.Position = mouseLocation
		c.Radius = _state.fovRadius
		c.Visible = true
	else
		local c = circle :: any
		if c then
			c.Visible = false
		end
	end
end

local function _isValidTarget(player: Player): (boolean, BasePart?)
	local camera = _getCamera()
	local localPlayer = _getLocalPlayer()
	if player == localPlayer then
		return false, nil
	end
	if _state.isTeamCheckEnabled and player.Team == localPlayer.Team then
		return false, nil
	end

	local character = player.Character
	if not character then
		return false, nil
	end

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoid or humanoid.Health <= 0 then
		return false, nil
	end

	local head = character:FindFirstChild("Head")
	if not head or not head:IsA("BasePart") then
		return false, nil
	end
	local headPart = head :: BasePart

	if _state.isWallCheckEnabled then
		local origin = camera.CFrame.Position
		local direction = headPart.Position - origin
		local raycastParams = RaycastParams.new()
		raycastParams.FilterDescendantsInstances = { localPlayer.Character, character }
		raycastParams.FilterType = Enum.RaycastFilterType.Exclude

		local result = Workspace:Raycast(origin, direction, raycastParams)
		if result then
			return false, nil
		end
	end

	local screenPos, onScreen = camera:WorldToViewportPoint(headPart.Position)
	if not onScreen then
		return false, nil
	end

	local mouseLocation = UserInputService:GetMouseLocation()
	local distance = (Vector2.new(screenPos.X, screenPos.Y) - mouseLocation).Magnitude
	if distance > _state.fovRadius then
		return false, nil
	end

	return true, headPart
end

local function _getBestTarget(): Player?
	local localPlayer = _getLocalPlayer()
	local mouseLocation = UserInputService:GetMouseLocation()

	local bestTarget = nil
	local shortestDistance = _state.fovRadius

	for _, player in ipairs(Players:GetPlayers()) do
		if player == localPlayer then
			continue
		end
		local isValid = _isValidTarget(player)
		if not isValid then
			continue
		end

		local head = player.Character and player.Character:FindFirstChild("Head")
		if not head or not head:IsA("BasePart") then
			continue
		end

		local camera = _getCamera()
		local screenPos = camera:WorldToViewportPoint((head :: BasePart).Position)
		local distance = (Vector2.new(screenPos.X, screenPos.Y) - mouseLocation).Magnitude
		if distance < shortestDistance then
			shortestDistance = distance
			bestTarget = player
		end
	end

	return bestTarget
end

local function _resolveTarget(): Player?
	if _state.target then
		local isValid = _isValidTarget(_state.target)
		if isValid then
			return _state.target
		end
	end
	local newTarget = _getBestTarget()
	_state.target = newTarget
	return newTarget
end

local function _aimAt(target: Player, deltaTime: number)
	if not target.Character then
		return
	end
	local head = target.Character:FindFirstChild("Head")
	if not head or not head:IsA("BasePart") then
		return
	end

	local camera = _getCamera()
	local targetPos = (head :: BasePart).Position

	-- Calculate LookVector needed
	local currentCFrame = camera.CFrame
	local lookAtCFrame = CFrame.lookAt(currentCFrame.Position, targetPos)

	if not _state.cameraController or not _state.cameraController.SetRotation then
		local alpha = 1
		if not _state.isHardLockEnabled then
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

	-- Debug once per target switch or low frequency?
	-- For now, just print if we have logic
	_throttleLog("Aiming...", targetRotation)

	-- Smoothness
	if _state.isHardLockEnabled then
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

	RunService:BindToRenderStep(
		CONSTANTS.AIMBOT_RENDER_STEP_NAME,
		Enum.RenderPriority.Camera.Value + 1,
		function(deltaTime)
			_updateFovCircle()

			_throttleLog("Aimbot Status | Enabled:", _state.isAimbotEnabled)

			if _state.isAimbotEnabled then
				local target = _resolveTarget()
				if target then
					_applyInputLock(true)
					_state.logger:info("Target found:", target.Name)
					_aimAt(target, deltaTime)
				else
					_applyInputLock(false)
				end
			else
				_state.target = nil
				_applyInputLock(false)
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
	_state.target = nil
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
	_state.smoothness = smoothness
end

function Combat.setWallCheckEnabled(self: CombatFeature, isEnabled: boolean): ()
	_state.isWallCheckEnabled = isEnabled
end

function Combat.setHardLockEnabled(self: CombatFeature, isEnabled: boolean): ()
	if _state.isHardLockEnabled == isEnabled then
		return
	end
	_state.isHardLockEnabled = isEnabled
	if not isEnabled then
		_applyInputLock(false)
	end
end

return Combat
