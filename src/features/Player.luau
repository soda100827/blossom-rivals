--!strict

--// Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

--// Dependencies (require)
local Maid = require("Packages/_Index/soda100827_maid@0.4.0/maid") :: any

--// Constants
local DEFAULT_FLY_SPEED = 50
local DEFAULT_FLY_KEY = Enum.KeyCode.F
local DEFAULT_NOCLIP_KEY = Enum.KeyCode.N
local DEFAULT_WALK_SPEED_KEY = Enum.KeyCode.T
local DEFAULT_JUMP_POWER_KEY = Enum.KeyCode.Y

local INPUT_MAP = {
	[Enum.KeyCode.W] = "forward",
	[Enum.KeyCode.S] = "back",
	[Enum.KeyCode.A] = "left",
	[Enum.KeyCode.D] = "right",
	[Enum.KeyCode.Space] = "up",
	[Enum.KeyCode.LeftControl] = "down",
}

--// Types
export type PlayerFeature = {
	init: (self: PlayerFeature, client: any) -> (),
	cleanup: (self: PlayerFeature) -> (),
	setFlyEnabled: (self: PlayerFeature, isEnabled: boolean) -> (),
	setNoclipEnabled: (self: PlayerFeature, isEnabled: boolean) -> (),
	setWalkSpeedEnabled: (self: PlayerFeature, isEnabled: boolean) -> (),
	setJumpPowerEnabled: (self: PlayerFeature, isEnabled: boolean) -> (),
	setWalkSpeed: (self: PlayerFeature, value: number) -> (),
	setJumpPower: (self: PlayerFeature, value: number) -> (),
	setFlySpeed: (self: PlayerFeature, value: number) -> (),
	setFlyKeybind: (self: PlayerFeature, keybind: Enum.KeyCode | string | { [string]: any }) -> (),
	setNoclipKeybind: (self: PlayerFeature, keybind: Enum.KeyCode | string | { [string]: any }) -> (),
	setWalkSpeedKeybind: (self: PlayerFeature, keybind: Enum.KeyCode | string | { [string]: any }) -> (),
	setJumpPowerKeybind: (self: PlayerFeature, keybind: Enum.KeyCode | string | { [string]: any }) -> (),
}

type InputState = {
	forward: number,
	back: number,
	left: number,
	right: number,
	up: number,
	down: number,
}

--// Private state
local Player = {}
Player.__index = Player

local _maid = nil :: any
local _state: {
	client: any,
	logger: any,
	character: Model?,
	humanoid: Humanoid?,
	rootPart: BasePart?,
	isFlyEnabled: boolean,
	isNoclipEnabled: boolean,
	isWalkSpeedEnabled: boolean,
	isJumpPowerEnabled: boolean,
	walkSpeedValue: number,
	jumpPowerValue: number,
	flySpeed: number,
	defaultWalkSpeed: number?,
	defaultJumpPower: number?,
	defaultJumpHeight: number?,
	defaultUseJumpPower: boolean?,
	defaultAutoRotate: boolean?,
	defaultPlatformStand: boolean?,
	flyKeybind: Enum.KeyCode,
	noclipKeybind: Enum.KeyCode,
	walkSpeedKeybind: Enum.KeyCode,
	jumpPowerKeybind: Enum.KeyCode,
	noclipParts: { [BasePart]: boolean },
	input: InputState,
} = {
	client = nil :: any,
	logger = nil :: any,
	character = nil,
	humanoid = nil,
	rootPart = nil,
	isFlyEnabled = false,
	isNoclipEnabled = false,
	isWalkSpeedEnabled = false,
	isJumpPowerEnabled = false,
	walkSpeedValue = 16,
	jumpPowerValue = 50,
	flySpeed = DEFAULT_FLY_SPEED,
	defaultWalkSpeed = nil,
	defaultJumpPower = nil,
	defaultJumpHeight = nil,
	defaultUseJumpPower = nil,
	defaultAutoRotate = nil,
	defaultPlatformStand = nil,
	flyKeybind = DEFAULT_FLY_KEY,
	noclipKeybind = DEFAULT_NOCLIP_KEY,
	walkSpeedKeybind = DEFAULT_WALK_SPEED_KEY,
	jumpPowerKeybind = DEFAULT_JUMP_POWER_KEY,
	noclipParts = {},
	input = {
		forward = 0,
		back = 0,
		left = 0,
		right = 0,
		up = 0,
		down = 0,
	},
}
local _signals = {}

--// Private helpers
local function _getLocalPlayer(): Player?
	return Players.LocalPlayer
end

local function _coerceKeyCode(keybind: Enum.KeyCode | string | { [string]: any }): Enum.KeyCode?
	if typeof(keybind) == "EnumItem" then
		if (keybind :: EnumItem).EnumType == Enum.KeyCode then
			return keybind :: Enum.KeyCode
		end
		return nil
	end
	if typeof(keybind) == "string" then
		return Enum.KeyCode[keybind]
	end
	if typeof(keybind) == "table" then
		local keyField = (keybind :: any).KeyCode or (keybind :: any).Key
		if typeof(keyField) == "EnumItem" and (keyField :: EnumItem).EnumType == Enum.KeyCode then
			return keyField :: Enum.KeyCode
		end
	end
	return nil
end

local function _cacheDefaults(humanoid: Humanoid)
	_state.defaultWalkSpeed = humanoid.WalkSpeed
	_state.defaultUseJumpPower = humanoid.UseJumpPower
	if humanoid.UseJumpPower then
		_state.defaultJumpPower = humanoid.JumpPower
		_state.defaultJumpHeight = nil
	else
		_state.defaultJumpPower = nil
		_state.defaultJumpHeight = humanoid.JumpHeight
	end
	_state.defaultAutoRotate = humanoid.AutoRotate
	_state.defaultPlatformStand = humanoid.PlatformStand
end

local function _applyWalkSpeed()
	local humanoid = _state.humanoid
	if not humanoid then
		return
	end
	if _state.isWalkSpeedEnabled then
		humanoid.WalkSpeed = _state.walkSpeedValue
	elseif _state.defaultWalkSpeed ~= nil then
		humanoid.WalkSpeed = _state.defaultWalkSpeed
	end
end

local function _applyJumpPower()
	local humanoid = _state.humanoid
	if not humanoid then
		return
	end
	if _state.isJumpPowerEnabled then
		if humanoid.UseJumpPower then
			humanoid.JumpPower = _state.jumpPowerValue
		else
			humanoid.JumpHeight = _state.jumpPowerValue
		end
	else
		if _state.defaultUseJumpPower ~= nil then
			humanoid.UseJumpPower = _state.defaultUseJumpPower
		end
		if _state.defaultUseJumpPower then
			if _state.defaultJumpPower ~= nil then
				humanoid.JumpPower = _state.defaultJumpPower
			end
		else
			if _state.defaultJumpHeight ~= nil then
				humanoid.JumpHeight = _state.defaultJumpHeight
			end
		end
	end
end

local function _restoreMovementDefaults()
	local humanoid = _state.humanoid
	if not humanoid then
		return
	end
	if _state.defaultWalkSpeed ~= nil then
		humanoid.WalkSpeed = _state.defaultWalkSpeed
	end
	if _state.defaultUseJumpPower ~= nil then
		humanoid.UseJumpPower = _state.defaultUseJumpPower
	end
	if _state.defaultUseJumpPower then
		if _state.defaultJumpPower ~= nil then
			humanoid.JumpPower = _state.defaultJumpPower
		end
	else
		if _state.defaultJumpHeight ~= nil then
			humanoid.JumpHeight = _state.defaultJumpHeight
		end
	end
	if _state.defaultAutoRotate ~= nil then
		humanoid.AutoRotate = _state.defaultAutoRotate
	end
	if _state.defaultPlatformStand ~= nil then
		humanoid.PlatformStand = _state.defaultPlatformStand
	end
end

local function _setCharacter(character: Model?)
	_state.character = character
	_state.humanoid = nil
	_state.rootPart = nil
	if not character then
		return
	end
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	local rootPart = character:FindFirstChild("HumanoidRootPart")
	if humanoid then
		_state.humanoid = humanoid
		_cacheDefaults(humanoid)
	end
	if rootPart and rootPart:IsA("BasePart") then
		_state.rootPart = rootPart
	end
	_applyWalkSpeed()
	_applyJumpPower()
end

local function _applyNoclip()
	local character = _state.character
	if not character then
		return
	end
	for _, part in ipairs(character:GetDescendants()) do
		if part:IsA("BasePart") then
			if _state.noclipParts[part] == nil then
				_state.noclipParts[part] = part.CanCollide
			end
			part.CanCollide = false
		end
	end
end

local function _restoreNoclip()
	for part, original in pairs(_state.noclipParts) do
		if part and part.Parent then
			part.CanCollide = original
		end
	end
	_state.noclipParts = {}
end

local function _applyFlyState()
	local humanoid = _state.humanoid
	if not humanoid then
		return
	end
	if _state.isFlyEnabled then
		humanoid.PlatformStand = true
		humanoid.AutoRotate = false
		humanoid:ChangeState(Enum.HumanoidStateType.Physics)
	else
		local rootPart = _state.rootPart
		if rootPart then
			rootPart.AssemblyLinearVelocity = Vector3.zero
			rootPart.AssemblyAngularVelocity = Vector3.zero
		end
		if _state.defaultPlatformStand ~= nil then
			humanoid.PlatformStand = _state.defaultPlatformStand
		end
		if _state.defaultAutoRotate ~= nil then
			humanoid.AutoRotate = _state.defaultAutoRotate
		end
	end
end

local function _getFlyMoveVector(): Vector3
	local camera = Workspace.CurrentCamera
	if not camera then
		return Vector3.zero
	end
	local forward = camera.CFrame.LookVector
	local right = camera.CFrame.RightVector
	local up = camera.CFrame.UpVector
	local move = forward * (_state.input.forward - _state.input.back)
		+ right * (_state.input.right - _state.input.left)
		+ up * (_state.input.up - _state.input.down)
	if move.Magnitude > 1 then
		move = move.Unit
	end
	return move
end

local function _onCharacterAdded(character: Model)
	_setCharacter(character)
	if _state.isFlyEnabled then
		_applyFlyState()
	end
	if _state.isNoclipEnabled then
		_applyNoclip()
	end
end

local function _onCharacterRemoving()
	_restoreNoclip()
	_state.character = nil
	_state.humanoid = nil
	_state.rootPart = nil
end

local function _onInputChanged(input: InputObject, isPressed: boolean)
	local keyName = INPUT_MAP[input.KeyCode]
	if not keyName then
		return
	end
	_state.input[keyName] = isPressed and 1 or 0
end

local function _toggleFly()
	_state.isFlyEnabled = not _state.isFlyEnabled
	_applyFlyState()
end

local function _toggleNoclip()
	_state.isNoclipEnabled = not _state.isNoclipEnabled
	if _state.isNoclipEnabled then
		_applyNoclip()
	else
		_restoreNoclip()
	end
end

local function _toggleWalkSpeed()
	_state.isWalkSpeedEnabled = not _state.isWalkSpeedEnabled
	_applyWalkSpeed()
end

local function _toggleJumpPower()
	_state.isJumpPowerEnabled = not _state.isJumpPowerEnabled
	_applyJumpPower()
end

local function _connect()
	_maid:DoCleaning()

	local player = _getLocalPlayer()
	if player then
		local addedConn = player.CharacterAdded:Connect(function(character)
			_onCharacterAdded(character)
		end)
		_maid:GiveTask(addedConn)

		local removingConn = player.CharacterRemoving:Connect(function()
			_onCharacterRemoving()
		end)
		_maid:GiveTask(removingConn)

		if player.Character then
			_onCharacterAdded(player.Character)
		end
	end

	local inputBeganConn = UserInputService.InputBegan:Connect(function(input, processed)
		if processed then
			return
		end
		if input.KeyCode == _state.flyKeybind then
			_toggleFly()
			return
		end
		if input.KeyCode == _state.noclipKeybind then
			_toggleNoclip()
			return
		end
		if input.KeyCode == _state.walkSpeedKeybind then
			_toggleWalkSpeed()
			return
		end
		if input.KeyCode == _state.jumpPowerKeybind then
			_toggleJumpPower()
			return
		end
		_onInputChanged(input, true)
	end)
	_maid:GiveTask(inputBeganConn)

	local inputEndedConn = UserInputService.InputEnded:Connect(function(input, processed)
		if processed then
			return
		end
		_onInputChanged(input, false)
	end)
	_maid:GiveTask(inputEndedConn)

	local renderConn = RunService.RenderStepped:Connect(function()
		if not _state.isFlyEnabled then
			return
		end
		local rootPart = _state.rootPart
		if not rootPart then
			return
		end
		local move = _getFlyMoveVector()
		rootPart.AssemblyLinearVelocity = move * _state.flySpeed
		rootPart.AssemblyAngularVelocity = Vector3.zero
	end)
	_maid:GiveTask(renderConn)

	local steppedConn = RunService.Stepped:Connect(function()
		if _state.isNoclipEnabled then
			_applyNoclip()
		end
	end)
	_maid:GiveTask(steppedConn)
end

--// Public API
function Player.init(self: PlayerFeature, client: any): ()
	_state.client = client
	_state.logger = client.Logger
	_maid = Maid.new()
	_connect()
end

function Player.cleanup(self: PlayerFeature): ()
	_state.isFlyEnabled = false
	_state.isNoclipEnabled = false
	_state.isWalkSpeedEnabled = false
	_state.isJumpPowerEnabled = false
	_restoreNoclip()
	_restoreMovementDefaults()
	if _maid then
		_maid:DoCleaning()
	end
end

function Player.setFlyEnabled(self: PlayerFeature, isEnabled: boolean): ()
	if _state.isFlyEnabled == isEnabled then
		return
	end
	_state.isFlyEnabled = isEnabled
	_applyFlyState()
end

function Player.setNoclipEnabled(self: PlayerFeature, isEnabled: boolean): ()
	if _state.isNoclipEnabled == isEnabled then
		return
	end
	_state.isNoclipEnabled = isEnabled
	if not isEnabled then
		_restoreNoclip()
	else
		_applyNoclip()
	end
end

function Player.setWalkSpeedEnabled(self: PlayerFeature, isEnabled: boolean): ()
	if _state.isWalkSpeedEnabled == isEnabled then
		return
	end
	_state.isWalkSpeedEnabled = isEnabled
	_applyWalkSpeed()
end

function Player.setJumpPowerEnabled(self: PlayerFeature, isEnabled: boolean): ()
	if _state.isJumpPowerEnabled == isEnabled then
		return
	end
	_state.isJumpPowerEnabled = isEnabled
	_applyJumpPower()
end

function Player.setWalkSpeed(self: PlayerFeature, value: number): ()
	_state.walkSpeedValue = value
	_applyWalkSpeed()
end

function Player.setJumpPower(self: PlayerFeature, value: number): ()
	_state.jumpPowerValue = value
	_applyJumpPower()
end

function Player.setFlySpeed(self: PlayerFeature, value: number): ()
	_state.flySpeed = value
end

function Player.setFlyKeybind(self: PlayerFeature, keybind: Enum.KeyCode | string | { [string]: any }): ()
	local resolved = _coerceKeyCode(keybind)
	if resolved then
		_state.flyKeybind = resolved
	end
end

function Player.setNoclipKeybind(self: PlayerFeature, keybind: Enum.KeyCode | string | { [string]: any }): ()
	local resolved = _coerceKeyCode(keybind)
	if resolved then
		_state.noclipKeybind = resolved
	end
end

function Player.setWalkSpeedKeybind(self: PlayerFeature, keybind: Enum.KeyCode | string | { [string]: any }): ()
	local resolved = _coerceKeyCode(keybind)
	if resolved then
		_state.walkSpeedKeybind = resolved
	end
end

function Player.setJumpPowerKeybind(self: PlayerFeature, keybind: Enum.KeyCode | string | { [string]: any }): ()
	local resolved = _coerceKeyCode(keybind)
	if resolved then
		_state.jumpPowerKeybind = resolved
	end
end

return Player
