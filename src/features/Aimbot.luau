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
local FOV_CIRCLE_SIDES = 100

--// Private state
local Aimbot = {}
Aimbot.__index = Aimbot

local _maid = nil :: any
local _fakeCameraCFrame = CFrame.new()
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

--// [BYPASS] 정밀 메타테이블 후킹
local function _applyBypass()
	local mt = getrawmetatable(game)
	local oldIndex = mt.__index
	local oldNewIndex = mt.__newindex
	setreadonly(mt, false)

	mt.__index = newcclosure(function(self, key)
		if not checkcaller() and self:IsA("Camera") and key == "CFrame" then
			-- [핵심] 총기 스크립트(보통 이름에 Gun, Weapon, Bullet 등이 포함됨)는 진짜 좌표를 읽게 함
			local callingScript = getcallingscript()
			if callingScript then
				local name = callingScript.Name:lower()
				if name:find("gun") or name:find("weapon") or name:find("client") or name:find("bullet") then
					return oldIndex(self, key) -- 에임봇이 적용된 실제 Camera.CFrame 반환
				end
			end
			return _fakeCameraCFrame -- 그 외(안티치트)에는 가짜 좌표 반환
		end
		return oldIndex(self, key)
	end)

	mt.__newindex = newcclosure(function(self, key, value)
		if not checkcaller() and self:IsA("Camera") and key == "CFrame" then
			_fakeCameraCFrame = value
		end
		return oldNewIndex(self, key, value)
	end)

	setreadonly(mt, true)
end

--// Private helpers
local function _getMouseLocation(): Vector2
	return UserInputService:GetMouseLocation()
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
		if _state.settings.shouldAliveCheck and (not humanoid or humanoid.Health <= 0) then
			continue
		end

		local targetPart = character:FindFirstChild(_state.settings.targetPart)
		if not targetPart or not targetPart:IsA("BasePart") then
			continue
		end

		local screenPos, onScreen = camera:WorldToViewportPoint(targetPart.Position)
		if not onScreen then
			continue
		end

		local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
		if distance < closestDistance then
			closestDistance = distance
			bestTarget = player
		end
	end
	return bestTarget
end

--// Aimbot Logic
local function _aimAt(target: Player)
	local character = target.Character
	local targetPart = character and character:FindFirstChild(_state.settings.targetPart)
	local camera = Workspace.CurrentCamera

	if camera and targetPart and targetPart:IsA("BasePart") then
		-- 빡고: 즉시 타겟 고정
		camera.CFrame = CFrame.lookAt(camera.CFrame.Position, targetPart.Position)
	end
end

local function _connect()
	_maid:DoCleaning()
	_applyBypass()

	local env = getfenv() :: any
	if env.Drawing then
		local circle = env.Drawing.new("Circle")
		circle.Thickness = 1
		circle.NumSides = FOV_CIRCLE_SIDES
		circle.Filled = false
		_state.fovCircle = circle
		_maid:GiveTask(function()
			if _state.fovCircle then
				_state.fovCircle:Remove()
			end
		end)
	end

	RunService:BindToRenderStep(AIMBOT_RENDER_STEP, Enum.RenderPriority.Camera.Value + 1, function()
		if _state.fovCircle then
			_state.fovCircle.Visible = _state.settings.shouldShowFov
			_state.fovCircle.Radius = _state.settings.fovRadius
			_state.fovCircle.Position = _getMouseLocation()
		end

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

function Aimbot.toggle(self: Aimbot, state: boolean)
	_state.settings.isEnabled = state
end
function Aimbot.setShowFOV(self: Aimbot, state: boolean)
	_state.settings.shouldShowFov = state
end
function Aimbot.setFOVRadius(self: Aimbot, radius: number)
	_state.settings.fovRadius = radius
end
function Aimbot.setTargetPart(self: Aimbot, partName: string)
	_state.settings.targetPart = partName
end

return Aimbot
