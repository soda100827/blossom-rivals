--!strict

--// Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

--// Dependencies
local Maid = require("Packages/_Index/soda100827_maid@0.4.0/maid")

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
}

--// Private state
local Aimbot = {}
Aimbot.__index = Aimbot

local _maid = nil :: any
local _state = {
	client = nil :: any,
	settings = {
		Enabled = false,
		TeamCheck = true,
		AliveCheck = true,
		WallCheck = true,
		ShowFOV = false,
		FOVRadius = 100,
		FOVColor = Color3.fromRGB(255, 255, 255),
		Smoothness = 1,
		TargetPart = "Head",
	},
	target = nil :: Player?,
	fovCircle = nil :: any,
}

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
	local closestDistance = _state.settings.FOVRadius

	for _, player in ipairs(Players:GetPlayers()) do
		if player == localPlayer then
			continue
		end
		if _state.settings.TeamCheck and player.Team == localPlayer.Team then
			continue
		end

		local character = player.Character
		if not character then
			continue
		end

		local humanoid = character:FindFirstChild("Humanoid")
		if _state.settings.AliveCheck then
			if not humanoid or not humanoid:IsA("Humanoid") or humanoid.Health <= 0 then
				continue
			end
		end

		local targetPart = character:FindFirstChild(_state.settings.TargetPart)
		if not targetPart or not targetPart:IsA("BasePart") then
			continue
		end

		local onScreen, screenPos = _isOnScreen(targetPart.Position)
		if not onScreen then
			continue
		end

		if _state.settings.WallCheck then
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

	_state.fovCircle.Visible = _state.settings.ShowFOV
	_state.fovCircle.Radius = _state.settings.FOVRadius
	_state.fovCircle.Color = _state.settings.FOVColor
	_state.fovCircle.Position = _getMouseLocation()
end

local function _aimAt(target: Player)
	local character = target.Character
	if not character then
		return
	end

	local targetPart = character:FindFirstChild(_state.settings.TargetPart)
	if not targetPart or not targetPart:IsA("BasePart") then
		return
	end

	local _, screenPos = _isOnScreen(targetPart.Position)
	local mousePos = _getMouseLocation()

	local delta = screenPos - mousePos
	local smoothness = math.max(1, _state.settings.Smoothness)

	-- Global mousemoverel
	local env = getfenv() :: any
	local mousemoverel = env.mousemoverel or (env.input and env.input.mousemoverel)

	if mousemoverel then
		mousemoverel(delta.X / smoothness, delta.Y / smoothness)
	end
end

local function _connect()
	_maid:DoCleaning()

	-- FOV Circle
	local env = getfenv() :: any
	if env.Drawing then
		local circle = env.Drawing.new("Circle")
		circle.Thickness = 1
		circle.NumSides = 100
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

	_maid:GiveTask(RunService.RenderStepped:Connect(function()
		_updateFOV()

		if not _state.settings.Enabled then
			return
		end

		-- Check user input
		if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
			return
		end

		local target = _getBestTarget()
		if target then
			_aimAt(target)
		end
	end))
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
	_state.settings.Enabled = state
end

function Aimbot.setTeamCheck(self: Aimbot, state: boolean)
	_state.settings.TeamCheck = state
end

function Aimbot.setAliveCheck(self: Aimbot, state: boolean)
	_state.settings.AliveCheck = state
end

function Aimbot.setWallCheck(self: Aimbot, state: boolean)
	_state.settings.WallCheck = state
end

function Aimbot.setShowFOV(self: Aimbot, state: boolean)
	_state.settings.ShowFOV = state
end

function Aimbot.setFOVRadius(self: Aimbot, radius: number)
	_state.settings.FOVRadius = radius
end

function Aimbot.setFOVColor(self: Aimbot, color: Color3)
	_state.settings.FOVColor = color
end

function Aimbot.setSmoothness(self: Aimbot, value: number)
	_state.settings.Smoothness = value
end

function Aimbot.setTargetPart(self: Aimbot, partName: string)
	_state.settings.TargetPart = partName
end

return Aimbot
