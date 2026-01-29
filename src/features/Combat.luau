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
}

--// Types
export type CombatFeature = {
	init: (self: CombatFeature, client: any) -> (),
	cleanup: (self: CombatFeature) -> (),
	setAimbotEnabled: (self: CombatFeature, isEnabled: boolean) -> (),
	setFovEnabled: (self: CombatFeature, isEnabled: boolean) -> (),
	setFovRadius: (self: CombatFeature, radius: number) -> (),
	setTeamCheckEnabled: (self: CombatFeature, isEnabled: boolean) -> (),
	setSmoothness: (self: CombatFeature, smoothness: number) -> (),
	setWallCheckEnabled: (self: CombatFeature, isEnabled: boolean) -> (),
	setTriggerKey: (self: CombatFeature, key: string | Enum.KeyCode) -> (),
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
	isTeamCheckEnabled: boolean,
	isWallCheckEnabled: boolean,
	smoothness: number,
	triggerKey: any, -- Enum.KeyCode or Enum.UserInputType
	target: Player?,
	fovCircle: any?,
	cameraController: any?,
	isAiming: boolean,
} =
	{
		client = nil :: any,
		logger = nil :: any,
		isAimbotEnabled = false,
		isFovEnabled = false,
		fovRadius = 100,
		isTeamCheckEnabled = false,
		isWallCheckEnabled = false,
		smoothness = 0,
		triggerKey = Enum.UserInputType.MouseButton2,
		target = nil,
		fovCircle = nil,
		cameraController = nil,
		isAiming = false,
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
	if _state.isFovEnabled and _state.isAimbotEnabled then
		if not circle then
			circle = lib.new("Circle")
			_state.fovCircle = circle
		end

		-- Use local variable cast to 'any' to mute strict linting on dynamic drawing object
		local c = circle :: any

		c.Thickness = CONSTANTS.FOV_CIRCLE_THICKNESS
		c.NumSides = CONSTANTS.FOV_CIRCLE_NUM_SIDES
		c.Filled = false
		c.Color = CONSTANTS.FOV_CIRCLE_COLOR

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

local function _getBestTarget(): Player?
	local camera = _getCamera()
	local localPlayer = _getLocalPlayer()
	local mouseLocation = UserInputService:GetMouseLocation()

	local bestTarget = nil
	local shortestDistance = _state.fovRadius

	for _, player in ipairs(Players:GetPlayers()) do
		if player == localPlayer then
			continue
		end
		if _state.isTeamCheckEnabled and player.Team == localPlayer.Team then
			continue
		end

		local character = player.Character
		if not character then
			continue
		end

		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if not humanoid or humanoid.Health <= 0 then
			continue
		end

		local head = character:FindFirstChild("Head")
		if not head then
			continue
		end

		if not head:IsA("BasePart") then
			continue
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
				continue -- Obscured
			end
		end

		local screenPos, onScreen = camera:WorldToViewportPoint(headPart.Position)
		if not onScreen then
			continue
		end

		local distance = (Vector2.new(screenPos.X, screenPos.Y) - mouseLocation).Magnitude
		if distance < shortestDistance then
			shortestDistance = distance
			bestTarget = player
		end
	end

	return bestTarget
end

local function _aimAt(target: Player)
	if not _state.cameraController then
		return
	end
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

	-- We need to extract the Pitch (X) and Yaw (Y) rotation from this CFrame
	-- CameraController:SetRotation(Vector2) logic usually calls for X and Y in radians
	-- But typically Rotation.X is Pitch, Rotation.Y is Yaw
	local x, y, _ = lookAtCFrame:ToOrientation()
	-- ToOrientation returns (X, Y, Z) in radians (Pitch, Yaw, Roll)
	-- Roblox order: Y (Yaw), X (Pitch), Z (Roll) for EulerAngles?
	-- ToOrientation returns (RX, RY, RZ).

	local targetRotation = Vector2.new(y, x)

	-- Debug once per target switch or low frequency?
	-- For now, just print if we have logic
	_state.logger:info("Aiming...", targetRotation)

	-- Smoothness
	if _state.smoothness > 0 then
		local currentRot = _state.cameraController.Rotation :: Vector2
		local diff = targetRotation - currentRot
		-- Handle wrap around for Yaw (Y) if needed, but Vector2 math might just work if close
		-- Simple Lerp
		local step = (1 - _state.smoothness) -- If smoothness 1, step 0. If 0, step 1.
		-- Adjusted for frame rate potentially, but standard lerp for now
		local newRot = currentRot:Lerp(targetRotation, step)
		_state.cameraController:SetRotation(newRot)
	else
		_state.cameraController:SetRotation(targetRotation)
	end
end

local function _handleInput(input: InputObject)
	-- Check trigger key
	if not _state.triggerKey then
		return
	end

	local key = _state.triggerKey
	local isTrigger = false

	if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == key then
		isTrigger = true
	elseif input.UserInputType == Enum.UserInputType.MouseButton1 and key == "MouseButton1" then
		isTrigger = true
	elseif input.UserInputType == Enum.UserInputType.MouseButton2 and key == "MouseButton2" then
		isTrigger = true
	end

	if isTrigger then
		_state.isAiming = (input.UserInputState == Enum.UserInputState.Begin)
	end
end

local function _checkKeyDown()
	-- Polling specific keys if keypicker returns strings
	if type(_state.triggerKey) == "string" then
		local keyName = _state.triggerKey
		if keyName == "MouseButton1" then
			return UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
		elseif keyName == "MouseButton2" then
			return UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
		else
			local success, keyCode = pcall(function()
				return Enum.KeyCode[keyName]
			end)
			if success and keyCode then
				return UserInputService:IsKeyDown(keyCode)
			end
		end
	elseif typeof(_state.triggerKey) == "EnumItem" then
		if _state.triggerKey.EnumType == Enum.KeyCode then
			return UserInputService:IsKeyDown(_state.triggerKey)
		elseif _state.triggerKey.EnumType == Enum.UserInputType then
			return UserInputService:IsMouseButtonPressed(_state.triggerKey)
		end
	end
	return false
end

local function _connect()
	_maid:DoCleaning()
	task.spawn(function()
		_fetchCameraController(_state.logger)
	end)

	local runConn = RunService.RenderStepped:Connect(function()
		_updateFovCircle()

		if _state.isAimbotEnabled then
			-- Check if key is held
			_state.isAiming = _checkKeyDown()

			_throttleLog("Aimbot Status | Enabled:", _state.isAimbotEnabled, "Key:", _state.isAiming)

			if _state.isAiming then
				local target = _getBestTarget()
				if target then
					_state.logger:info("Target found:", target.Name)
					_aimAt(target)
				end
			end
		end
	end)
	_maid:GiveTask(runConn)
end

local function _disconnect()
	if _state.fovCircle then
		pcall(function()
			(_state.fovCircle :: any):Remove()
		end)
		_state.fovCircle = nil
	end
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
	_state.logger:info("Set Aimbot Enabled:", isEnabled)
	_state.isAimbotEnabled = isEnabled
end

function Combat.setFovEnabled(self: CombatFeature, isEnabled: boolean): ()
	_state.isFovEnabled = isEnabled
end

function Combat.setFovRadius(self: CombatFeature, radius: number): ()
	_state.fovRadius = radius
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

function Combat.setTriggerKey(self: CombatFeature, key: any): ()
	-- LinoriaLib sends strings for KeyPickers usually, or EnumItems?
	-- Adjust based on what we receive.
	_state.triggerKey = key
end

return Combat
