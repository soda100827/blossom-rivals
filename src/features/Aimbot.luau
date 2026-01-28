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
local _fakeCameraCFrame = CFrame.new() -- 안티치트에게 보여줄 가짜 데이터 저장소
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
	fovCircle = nil :: any,
}

--// [BYPASS] Metatable Hooking (익스큐터 전용)
-- 게임이 카메라를 읽을 때는 가짜 값을, 에임봇이 쓸 때는 진짜 값을 허용함
local function _applyBypass()
	local mt = getrawmetatable(game)
	local oldIndex = mt.__index
	local oldNewIndex = mt.__newindex
	setreadonly(mt, false)

	mt.__index = newcclosure(function(self, key)
		if not checkcaller() and self:IsA("Camera") and key == "CFrame" then
			return _fakeCameraCFrame
		end
		return oldIndex(self, key)
	end)

	mt.__newindex = newcclosure(function(self, key, value)
		if not checkcaller() and self:IsA("Camera") and key == "CFrame" then
			_fakeCameraCFrame = value -- 게임이 평소에 움직이는 시점 정보를 따로 기록
		end
		return oldNewIndex(self, key, value)
	end)

	setreadonly(mt, true)
end

--// Private helpers
local function _getMouseLocation(): Vector2
	return UserInputService:GetMouseLocation()
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

local function _getBestTarget(): Player?
	local camera = Workspace.CurrentCamera
	local localPlayer = Players.LocalPlayer
	local mousePos = _getMouseLocation()

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

		local distance = (screenPos - mousePos).Magnitude
		if distance < closestDistance then
			closestDistance = distance
			bestTarget = player
		end
	end

	return bestTarget
end

local function _updateFOV()
	if not _state.fovCircle then
		return
	end
	_state.fovCircle.Visible = _state.settings.shouldShowFov
	_state.fovCircle.Radius = _state.settings.fovRadius
	_state.fovCircle.Color = _state.settings.fovColor
	_state.fovCircle.Position = _getMouseLocation()
end

--// Modified Aimbot Logic (No Smoothness, Pure Snap with Bypass)
local function _aimAt(target: Player)
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

	--// 빡고: 델타타임/Smoothness 무시하고 즉시 고정
	--// 익스큐터 권한(checkcaller)으로 할당하여 메타테이블 우회를 통과함
	camera.CFrame = CFrame.lookAt(camera.CFrame.Position, targetPart.Position)

	if _state.settings.isDebug and _state.client and _state.client.Logger then
		_state.client.Logger:info("Aiming at:", target.Name)
	end
end

local function _connect()
	_maid:DoCleaning()
	_applyBypass() -- 안티치트 우회 활성화

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

	-- Run after the game's camera controller
	RunService:BindToRenderStep(AIMBOT_RENDER_STEP, Enum.RenderPriority.Camera.Value + 1, function()
		_updateFOV()

		if not _state.settings.isEnabled then
			return
		end
		if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
			return
		end

		local target = _getBestTarget()
		if target then
			_aimAt(target)
		end
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
