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
	setSilentAimEnabled: (self: CombatFeature, isEnabled: boolean) -> (),
	setFovEnabled: (self: CombatFeature, isEnabled: boolean) -> (),
	setFovRadius: (self: CombatFeature, radius: number) -> (),
	setTeamCheckEnabled: (self: CombatFeature, isEnabled: boolean) -> (),
	setHeadshotChance: (self: CombatFeature, chance: number) -> (),
}

--// Private state
local Combat = {}
Combat.__index = Combat

local _maid = nil :: any
local _state: {
	client: any,
	logger: any,
	isSilentAimEnabled: boolean,
	isFovEnabled: boolean,
	fovRadius: number,
	isTeamCheckEnabled: boolean,
	headshotChance: number,
	target: Player?,
	fovCircle: any?,
} =
	{
		client = nil :: any,
		logger = nil :: any,
		isSilentAimEnabled = false,
		isFovEnabled = false,
		fovRadius = 100,
		isTeamCheckEnabled = false,
		headshotChance = 100,
		target = nil,
		fovCircle = nil,
	}

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

local function _updateFovCircle()
	local lib = _getDrawingLib()
	if not lib then
		return
	end

	local circle = _state.fovCircle
	if _state.isFovEnabled and _state.isSilentAimEnabled then
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

--// Hook Setup
local function _setupHooks()
	local g = getfenv(0) :: any
	if not g.hookmetamethod then
		if _state.logger then
			_state.logger:warn("hookmetamethod not found, silent aim will not work.")
		end
		return
	end

	local hookmetamethod = g.hookmetamethod
	local getnamecallmethod = g.getnamecallmethod
	local checkcaller = g.checkcaller
	local newcclosure = g.newcclosure

	local oldNamecall
	oldNamecall = hookmetamethod(
		game,
		"__namecall",
		newcclosure(function(self, ...)
			local method = getnamecallmethod()

			if _state.isSilentAimEnabled and not checkcaller() then
				local chance = math.random(1, 100)
				if chance <= _state.headshotChance then
					if method == "Raycast" and (self == Workspace or tostring(self) == "Workspace") then
						local args = { ... }
						if _state.target and _state.target.Character then
							local head = _state.target.Character:FindFirstChild("Head")
							if head and head:IsA("BasePart") then
								local origin = args[1]
								-- Calculate direction to head
								local direction = (head.Position - origin).Unit * args[2].Magnitude
								args[2] = direction
								return oldNamecall(self, table.unpack(args))
							end
						end
					elseif method == "FindPartOnRay" and (self == Workspace or tostring(self) == "Workspace") then
						local args = { ... }
						if _state.target and _state.target.Character then
							local head = _state.target.Character:FindFirstChild("Head")
							if head and head:IsA("BasePart") then
								local ray = args[1]
								if typeof(ray) == "Ray" then
									local newRay =
										Ray.new(ray.Origin, (head.Position - ray.Origin).Unit * ray.Direction.Magnitude)
									args[1] = newRay
									return oldNamecall(self, table.unpack(args))
								end
							end
						end
					end
				end
			end

			return oldNamecall(self, ...)
		end)
	)
end

local function _connect()
	_maid:DoCleaning()

	local runConn = RunService.RenderStepped:Connect(function()
		if _state.isSilentAimEnabled then
			_updateFovCircle()
			_state.target = _getBestTarget()
		else
			if _state.fovCircle then
				_updateFovCircle()
			end -- To hide it
			_state.target = nil
		end
	end)
	_maid:GiveTask(runConn)

	_setupHooks()
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
	_state.logger:info("Combat module initialized")
end

function Combat.cleanup(self: CombatFeature): ()
	_state.isSilentAimEnabled = false
	_disconnect()
end

function Combat.setSilentAimEnabled(self: CombatFeature, isEnabled: boolean): ()
	_state.isSilentAimEnabled = isEnabled
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

function Combat.setHeadshotChance(self: CombatFeature, chance: number): ()
	_state.headshotChance = chance
end

return Combat
