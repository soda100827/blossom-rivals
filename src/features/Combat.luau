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
	fovTransparency: number,
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
	isInputLocked: boolean,
	mouseBehavior: Enum.MouseBehavior?,
	mouseDeltaSensitivity: number?,
} =
	{
		client = nil :: any,
		logger = nil :: any,
		isAimbotEnabled = false,
		isSilentAimEnabled = false,
		isFovEnabled = false,
		isSilentAimFovEnabled = false,
		fovRadius = 100,
		silentAimFovRadius = 100,
		fovColor = CONSTANTS.FOV_CIRCLE_COLOR,
		fovTransparency = 0,
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

local function _getGlobal(name: string): any
	local getfenvAny = getfenv :: any
	local env = getfenvAny(0) :: any
	local genv = (env.getgenv and env.getgenv()) or env
	return genv[name] or env[name]
end

local function _hookFighter(fighter: any)
	local hookfunction = _getGlobal("hookfunction") or _getGlobal("replaceclosure")
	if not hookfunction then
		_state.logger:warn("hookfunction not found, Silent Aim will not work.")
		return
	end

	local oldGetCameraData
	oldGetCameraData = hookfunction(fighter.GetCameraData, function(self, ...)
		local result = oldGetCameraData(self, ...)
		if _state.isSilentAimEnabled and _state.silentTarget then
			local character = _state.silentTarget.Character
			local head = character and character:FindFirstChild("Head")
			if head and head:IsA("BasePart") then
				local origin = result[utf8.char(0)].Position
				local targetPos = (head :: BasePart).Position
				result[utf8.char(1)] = CFrame.lookAt(origin, targetPos)
			end
		end
		return result
	end)
	_state.logger:info("Fighter:GetCameraData hooked for Silent Aim.")
end

local function _setupSilentAim()
	task.spawn(function()
		_fetchFighterController(_state.logger)
		if _state.fighterController then
			local fighter = _state.fighterController:WaitForLocalFighter()
			if fighter then
				_hookFighter(fighter)
			end

			-- Hook FighterAdded if necessary (depends on if Fighter objects are reused)
			-- Based on rivals_src, new Fighter objects are created.
			if _state.fighterController.ObjectAdded then
				_state.fighterController.ObjectAdded:Connect(function(obj)
					if obj.IsLocalPlayer then
						task.defer(function()
							local newFighter = _state.fighterController:WaitForLocalFighter()
							if newFighter then
								_hookFighter(newFighter)
							end
						end)
					end
				end)
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
		_state.fovColor,
		_state.fovTransparency
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

	local head = character:FindFirstChild("Head")
	if not head or not head:IsA("BasePart") then
		return false, nil, false, math.huge
	end
	local headPart = head :: BasePart

	if _state.isWallCheckEnabled then
		local origin = camera.CFrame.Position
		local direction = headPart.Position - origin
		local raycastParams = RaycastParams.new()
		raycastParams.FilterDescendantsInstances = { localPlayer.Character :: any, character }
		raycastParams.FilterType = Enum.RaycastFilterType.Exclude

		local result = Workspace:Raycast(origin, direction, raycastParams)
		if result then
			return false, nil, false, math.huge
		end
	end

	local screenPos, onScreen = camera:WorldToViewportPoint(headPart.Position)
	if not onScreen then
		return true, headPart, false, math.huge
	end

	local mouseLocation = UserInputService:GetMouseLocation()
	local distance = (Vector2.new(screenPos.X, screenPos.Y) - mouseLocation).Magnitude
	return true, headPart, true, distance
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
		local isValid, headPart, onScreen, distance = _getTargetState(_state.silentTarget)
		if isValid and headPart and onScreen and distance <= dropRadius then
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

	-- Debug once per target switch or low frequency?
	-- For now, just print if we have logic
	_throttleLog("Aiming...", targetRotation)

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

			_throttleLog("Aimbot Status | Enabled:", _state.isAimbotEnabled, "Silent:", _state.isSilentAimEnabled)

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

			if _state.isSilentAimEnabled then
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

return Combat
