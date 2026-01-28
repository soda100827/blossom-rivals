--!strict

--// Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

--// Dependencies (require)
local Maid = require("Packages/_Index/soda100827_maid@0.4.0/maid") :: any

--// Constants
local AIMBOT_RENDER_STEP = "BlossomAimbot"
local AIMBOT_RENDER_PRIORITY = Enum.RenderPriority.Last.Value
local MAX_SMOOTHNESS = 100
local MIN_SMOOTHNESS = 1
local FOV_CIRCLE_SIDES = 100

--// Types
export type Aimbot = {
	init: (self: Aimbot, client: any) -> (),
	cleanup: (self: Aimbot) -> (),
	toggle: (self: Aimbot, state: boolean) -> (),
	setTeamCheck: (self: Aimbot, state: boolean) -> (),
	setAliveCheck: (self: Aimbot, state: boolean) -> (),
	setWallCheck: (self: Aimbot, state: boolean) -> (),
	setShowFOV: (self: Aimbot, state: boolean) -> (),
	setFOVRadius: (self: Aimbot, radius: number) -> (),
	setFOVColor: (self: Aimbot, color: Color3) -> (),
	setSmoothness: (self: Aimbot, value: number) -> (),
	setTargetPart: (self: Aimbot, partName: string) -> (),
	setDebug: (self: Aimbot, state: boolean) -> (),
}

--// Private state
local Aimbot = {}
Aimbot.__index = Aimbot

local _maid = nil :: any
local _state = {
	client = nil :: any,
	settings = {
		isEnabled = false,
		shouldTeamCheck = true,
		shouldAliveCheck = true,
		shouldWallCheck = true,
		shouldShowFov = false,
		fovRadius = 100,
		fovColor = Color3.fromRGB(255, 255, 255),
		smoothness = 1,
		targetPart = "Head",
		isDebug = false,
	},
	target = nil :: Player?,
	lockedTarget = nil :: Player?,
	fovCircle = nil :: any,
	defaultAutoRotate = nil :: boolean?,
	hasAutoRotateOverride = false,
	defaultMouseSensitivity = nil :: number?,
	hasMouseSensitivityOverride = false,
	cameraController = nil :: any,
}
local _signals = {}

--// Private helpers
local function _getMouseLocation(): Vector2
	return UserInputService:GetMouseLocation()
end

local function _getScreenCenter(): Vector2
	local camera = Workspace.CurrentCamera
	if not camera then
		return _getMouseLocation()
	end
	local viewport = camera.ViewportSize
	return Vector2.new(viewport.X / 2, viewport.Y / 2)
end

local function _getAimScreenPosition(isAiming: boolean): Vector2
	if isAiming then
		return _getScreenCenter()
	end
	return _getMouseLocation()
end

local function _getLocalHumanoid(): Humanoid?
	local localPlayer = Players.LocalPlayer
	if not localPlayer then
		return nil
	end
	local character = localPlayer.Character
	if not character then
		return nil
	end
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if humanoid and humanoid:IsA("Humanoid") then
		return humanoid
	end
	return nil
end

local function _getLocalRootPart(): BasePart?
	local localPlayer = Players.LocalPlayer
	if not localPlayer then
		return nil
	end
	local character = localPlayer.Character
	if not character then
		return nil
	end
	local rootPart = character:FindFirstChild("HumanoidRootPart")
	if rootPart and rootPart:IsA("BasePart") then
		return rootPart
	end
	return nil
end

local function _getCameraController(): any
	if _state.cameraController then
		return _state.cameraController
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
	local cameraModule = controllers:FindFirstChild("CameraController")
	if not cameraModule or not cameraModule:IsA("ModuleScript") then
		return nil
	end
	local success, result = pcall(function()
		return require(cameraModule)
	end)
	if not success then
		return nil
	end
	_state.cameraController = result
	return result
end

local function _setAutoRotateOverride(shouldDisable: boolean)
	local humanoid = _getLocalHumanoid()
	if not humanoid then
		return
	end
	if shouldDisable then
		if not _state.hasAutoRotateOverride then
			_state.defaultAutoRotate = humanoid.AutoRotate
			_state.hasAutoRotateOverride = true
		end
		humanoid.AutoRotate = false
		return
	end
	if _state.hasAutoRotateOverride then
		humanoid.AutoRotate = _state.defaultAutoRotate == nil and true or _state.defaultAutoRotate
		_state.hasAutoRotateOverride = false
	end
end

local function _setMouseSensitivityOverride(shouldDisable: boolean)
	if shouldDisable then
		if not _state.hasMouseSensitivityOverride then
			_state.defaultMouseSensitivity = UserInputService.MouseDeltaSensitivity
			_state.hasMouseSensitivityOverride = true
		end
		UserInputService.MouseDeltaSensitivity = 0
		return
	end
	if _state.hasMouseSensitivityOverride then
		if _state.defaultMouseSensitivity ~= nil then
			UserInputService.MouseDeltaSensitivity = _state.defaultMouseSensitivity
		end
		_state.hasMouseSensitivityOverride = false
	end
end

local function _isOnScreen(position: Vector3): (boolean, Vector2)
	local camera = Workspace.CurrentCamera
	if not camera then
		return false, Vector2.zero
	end
	local screenPos, onScreen = camera:WorldToViewportPoint(position)
	return onScreen, Vector2.new(screenPos.X, screenPos.Y)
end

local function _isVisible(targetPart: BasePart, origin: Vector3): boolean
	local params = RaycastParams.new()
	if Players.LocalPlayer and Players.LocalPlayer.Character then
		params.FilterDescendantsInstances = {
			Players.LocalPlayer.Character,
			Workspace.CurrentCamera,
		}
	else
		params.FilterDescendantsInstances = { Workspace.CurrentCamera }
	end
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.IgnoreWater = true

	local direction = targetPart.Position - origin
	local result = Workspace:Raycast(origin, direction, params)

	if result then
		return result.Instance:IsDescendantOf(targetPart.Parent :: Instance)
	end
	return true
end

local function _getBestTarget(aimScreenPos: Vector2): Player?
	local camera = Workspace.CurrentCamera
	local localPlayer = Players.LocalPlayer

	if not camera or not localPlayer then
		return nil
	end

	local bestTarget = nil
	local closestDistance = _state.settings.fovRadius

	for _, player in ipairs(Players:GetPlayers()) do
		if player == localPlayer then
			continue
		end
		if _state.settings.shouldTeamCheck and player.Team == localPlayer.Team then
			continue
		end

		local character = player.Character
		if not character then
			continue
		end

		local humanoid = character:FindFirstChild("Humanoid")
		if _state.settings.shouldAliveCheck then
			if not humanoid or not humanoid:IsA("Humanoid") or humanoid.Health <= 0 then
				continue
			end
		end

		local targetPart = character:FindFirstChild(_state.settings.targetPart)
		if not targetPart or not targetPart:IsA("BasePart") then
			continue
		end

		local onScreen, screenPos = _isOnScreen(targetPart.Position)
		if not onScreen then
			continue
		end

		if _state.settings.shouldWallCheck then
			local origin = camera.CFrame.Position
			if not _isVisible(targetPart, origin) then
				continue
			end
		end

		local distance = (screenPos - aimScreenPos).Magnitude
		if distance < closestDistance then
			closestDistance = distance
			bestTarget = player
		end
	end

	return bestTarget
end

local function _isTargetValid(target: Player, isAiming: boolean): boolean
	local camera = Workspace.CurrentCamera
	local localPlayer = Players.LocalPlayer
	if not camera or not localPlayer then
		return false
	end
	if target == localPlayer then
		return false
	end
	if _state.settings.shouldTeamCheck and target.Team == localPlayer.Team then
		return false
	end
	local character = target.Character
	if not character then
		return false
	end
	local humanoid = character:FindFirstChild("Humanoid")
	if _state.settings.shouldAliveCheck then
		if not humanoid or not humanoid:IsA("Humanoid") or humanoid.Health <= 0 then
			return false
		end
	end
	local targetPart = character:FindFirstChild(_state.settings.targetPart)
	if not targetPart or not targetPart:IsA("BasePart") then
		return false
	end
	if not isAiming then
		local onScreen = _isOnScreen(targetPart.Position)
		if not onScreen then
			return false
		end
	end
	if _state.settings.shouldWallCheck then
		local origin = camera.CFrame.Position
		if not _isVisible(targetPart, origin) then
			return false
		end
	end
	return true
end

local function _updateFOV(aimScreenPos: Vector2)
	if not _state.fovCircle then
		return
	end

	_state.fovCircle.Visible = _state.settings.shouldShowFov
	_state.fovCircle.Radius = _state.settings.fovRadius
	_state.fovCircle.Color = _state.settings.fovColor
	_state.fovCircle.Position = aimScreenPos
end

local function _applyCameraControllerRotation(targetPosition: Vector3)
	local camera = Workspace.CurrentCamera
	if not camera then
		return
	end
	local controller = _getCameraController()
	if not controller then
		return
	end
	local targetCFrame = CFrame.lookAt(camera.CFrame.Position, targetPosition)
	local pitch, yaw, _ = targetCFrame:ToOrientation()
	if controller.SetRotation then
		controller:SetRotation(Vector2.new(pitch, yaw))
	elseif controller.Rotation ~= nil then
		controller.Rotation = Vector2.new(pitch, yaw)
	end
end

local function _applyCameraAim(camera: Camera, targetPosition: Vector3, deltaTime: number)
	local smoothness = math.clamp(_state.settings.smoothness, MIN_SMOOTHNESS, MAX_SMOOTHNESS)
	local isInstant = smoothness >= MAX_SMOOTHNESS
	local targetCFrame = CFrame.lookAt(camera.CFrame.Position, targetPosition)

	if isInstant then
		camera.CFrame = targetCFrame
		return
	end

	local duration = (MAX_SMOOTHNESS - smoothness) / MAX_SMOOTHNESS
	if duration <= 0 then
		camera.CFrame = targetCFrame
		return
	end

	local alpha = math.clamp(deltaTime / duration, 0, 1)
	camera.CFrame = camera.CFrame:Lerp(targetCFrame, alpha)
end

local function _applyCharacterAim(targetPosition: Vector3)
	local rootPart = _getLocalRootPart()
	if not rootPart then
		return
	end
	local flatTarget = Vector3.new(targetPosition.X, rootPart.Position.Y, targetPosition.Z)
	rootPart.CFrame = CFrame.lookAt(rootPart.Position, flatTarget)
end

local function _applyMouseAim(camera: Camera, targetPosition: Vector3)
	local smoothness = math.clamp(_state.settings.smoothness, MIN_SMOOTHNESS, MAX_SMOOTHNESS)
	local _, screenPos = _isOnScreen(targetPosition)
	local mousePos = _getMouseLocation()
	local delta = screenPos - mousePos

	local mouseDivisor = (MAX_SMOOTHNESS - smoothness) / 5 + 1

	local env = getfenv() :: any
	local mousemoverel = env.mousemoverel or (env.input and env.input.mousemoverel)

	if mousemoverel then
		mousemoverel(delta.X / mouseDivisor, delta.Y / mouseDivisor)
	end
end

local function _aimAt(target: Player, deltaTime: number)
	local character = target.Character
	if not character then
		return
	end

	local targetPart = character:FindFirstChild(_state.settings.targetPart)
	if not targetPart or not targetPart:IsA("BasePart") then
		return
	end

	local camera = Workspace.CurrentCamera
	if not camera then
		return
	end

	local targetPosition = (targetPart :: BasePart).Position
	_setAutoRotateOverride(true)
	_setMouseSensitivityOverride(true)
	_applyCameraControllerRotation(targetPosition)
	_applyCharacterAim(targetPosition)
	_applyCameraAim(camera, targetPosition, deltaTime)
	_applyMouseAim(camera, targetPosition)

	if _state.settings.isDebug and _state.client.Logger then
		_state.client.Logger:info(
			"Aiming at:",
			target.Name,
			"| Dist:",
			math.floor((targetPosition - camera.CFrame.Position).Magnitude)
		)
	end
end

local function _connect()
	_maid:DoCleaning()

	local env = getfenv() :: any
	if env.Drawing then
		local circle = env.Drawing.new("Circle")
		circle.Thickness = 1
		circle.NumSides = FOV_CIRCLE_SIDES
		circle.Filled = false
		circle.Transparency = 1
		_state.fovCircle = circle

		_maid:GiveTask(function()
			if _state.fovCircle then
				_state.fovCircle:Remove()
				_state.fovCircle = nil
			end
		end)
	end

	-- Run after the game's camera controller so we don't get overwritten.
	RunService:BindToRenderStep(AIMBOT_RENDER_STEP, AIMBOT_RENDER_PRIORITY, function(deltaTime)
		local isAiming = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
		local aimScreenPos = _getAimScreenPosition(isAiming)

		_updateFOV(aimScreenPos)

		if not _state.settings.isEnabled then
			_setAutoRotateOverride(false)
			_setMouseSensitivityOverride(false)
			return
		end

		if not isAiming then
			_setAutoRotateOverride(false)
			_setMouseSensitivityOverride(false)
			_state.lockedTarget = nil
			return
		end

		local target = _state.lockedTarget
		if target and not _isTargetValid(target, isAiming) then
			target = nil
		end
		if not target then
			target = _getBestTarget(aimScreenPos)
		end
		if not target then
			_setAutoRotateOverride(false)
			_setMouseSensitivityOverride(false)
			_state.lockedTarget = nil
			return
		end
		_state.lockedTarget = target
		_aimAt(target, deltaTime)
	end)

	_maid:GiveTask(function()
		RunService:UnbindFromRenderStep(AIMBOT_RENDER_STEP)
	end)
end

--// Public API
function Aimbot.init(self: Aimbot, client: any)
	_state.client = client
	_maid = Maid.new()
	_connect()
end

function Aimbot.cleanup(self: Aimbot)
	_setAutoRotateOverride(false)
	_setMouseSensitivityOverride(false)
	_maid:DoCleaning()
end

function Aimbot.toggle(self: Aimbot, state: boolean)
	_state.settings.isEnabled = state
end

function Aimbot.setTeamCheck(self: Aimbot, state: boolean)
	_state.settings.shouldTeamCheck = state
end

function Aimbot.setAliveCheck(self: Aimbot, state: boolean)
	_state.settings.shouldAliveCheck = state
end

function Aimbot.setWallCheck(self: Aimbot, state: boolean)
	_state.settings.shouldWallCheck = state
end

function Aimbot.setShowFOV(self: Aimbot, state: boolean)
	_state.settings.shouldShowFov = state
end

function Aimbot.setFOVRadius(self: Aimbot, radius: number)
	_state.settings.fovRadius = radius
end

function Aimbot.setFOVColor(self: Aimbot, color: Color3)
	_state.settings.fovColor = color
end

function Aimbot.setSmoothness(self: Aimbot, value: number)
	_state.settings.smoothness = value
end

function Aimbot.setTargetPart(self: Aimbot, partName: string)
	_state.settings.targetPart = partName
end

function Aimbot.setDebug(self: Aimbot, state: boolean)
	_state.settings.isDebug = state
end

return Aimbot
