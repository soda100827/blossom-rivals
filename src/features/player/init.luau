--!strict

--// Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

--// Dependencies (require)
local Maid = require("Packages/_Index/soda100827_maid@0.4.0/maid") :: any
local Helpers = require("./Helpers")
local State = require("./State")
local Types = require("./Types")
local PlayerMods = require("./PlayerMods")

--// Constants

--// Types
type PlayerFeature = Types.PlayerFeature

--// Private state
local Player = {}
Player.__index = Player

local _maid = nil :: any
local _signals = {}

--// Private helpers
local function _connect()
	_maid:DoCleaning()

	local function bindCharacter()
		if State.characterMaid then
			State.characterMaid:DoCleaning()
		end
		State.characterMaid = Maid.new()
		local humanoid = State.humanoid
		local rootPart = State.rootPart
		if humanoid and rootPart then
			local stateConn = humanoid.StateChanged:Connect(function(_, newState)
				if not State.isJumpPowerEnabled then
					return
				end
				if newState == Enum.HumanoidStateType.Jumping then
					local current = rootPart.AssemblyLinearVelocity
					local jumpVelocity = State.jumpPowerValue
					if current.Y < jumpVelocity then
						rootPart.AssemblyLinearVelocity = Vector3.new(current.X, jumpVelocity, current.Z)
					end
				end
			end)
			State.characterMaid:GiveTask(stateConn)
		end
	end

	local function handleCharacterAdded(character: Model)
		Helpers.onCharacterAdded(character)
		bindCharacter()
	end

	local function handleCharacterRemoving()
		Helpers.onCharacterRemoving()
	end

	local function attachPlayer(player: Player)
		local addedConn = player.CharacterAdded:Connect(function(character)
			handleCharacterAdded(character)
		end)
		_maid:GiveTask(addedConn)

		local removingConn = player.CharacterRemoving:Connect(function()
			handleCharacterRemoving()
		end)
		_maid:GiveTask(removingConn)

		if player.Character then
			handleCharacterAdded(player.Character)
		end
	end

	local player = Helpers.getLocalPlayer()
	if player then
		attachPlayer(player)
	else
		local playerAddedConn = Players.PlayerAdded:Connect(function(addedPlayer)
			if addedPlayer == Helpers.getLocalPlayer() then
				attachPlayer(addedPlayer)
			end
		end)
		_maid:GiveTask(playerAddedConn)
	end

	local inputBeganConn = UserInputService.InputBegan:Connect(function(input, processed)
		if processed then
			return
		end
		Helpers.onInputChanged(input, true)
	end)
	_maid:GiveTask(inputBeganConn)

	local inputEndedConn = UserInputService.InputEnded:Connect(function(input, processed)
		if processed then
			return
		end
		Helpers.onInputChanged(input, false)
	end)
	_maid:GiveTask(inputEndedConn)

	local renderConn = RunService.RenderStepped:Connect(function()
		if not State.isFlyEnabled then
			local rootPart = State.rootPart
			local humanoid = State.humanoid
			if rootPart and humanoid and State.isWalkSpeedEnabled then
				local moveDir = humanoid.MoveDirection
				local horizontal = Vector3.new(moveDir.X, 0, moveDir.Z)
				if horizontal.Magnitude > 0 then
					horizontal = horizontal.Unit * State.walkSpeedValue
				end
				local current = rootPart.AssemblyLinearVelocity
				rootPart.AssemblyLinearVelocity = Vector3.new(horizontal.X, current.Y, horizontal.Z)
			end
			return
		end
		local rootPart = State.rootPart
		if not rootPart then
			return
		end
		local move = Helpers.getFlyMoveVector()
		rootPart.AssemblyLinearVelocity = move * State.flySpeed
		rootPart.AssemblyAngularVelocity = Vector3.zero
		local camera = Workspace.CurrentCamera
		if camera then
			local look = Vector3.new(camera.CFrame.LookVector.X, 0, camera.CFrame.LookVector.Z)
			if look.Magnitude > 0.001 then
				rootPart.CFrame = CFrame.new(rootPart.Position, rootPart.Position + look)
			end
		end
	end)
	_maid:GiveTask(renderConn)

	local steppedConn = RunService.Stepped:Connect(function()
		if State.isNoclipEnabled then
			Helpers.applyNoclip()
		end
	end)
	_maid:GiveTask(steppedConn)
end

--// Public API
function Player.init(self: PlayerFeature, client: any): ()
	State.client = client
	State.logger = client.Logger
	_maid = Maid.new()
	_connect()
	PlayerMods.setup()
end

function Player.cleanup(self: PlayerFeature): ()
	State.isFlyEnabled = false
	State.isNoclipEnabled = false
	State.isWalkSpeedEnabled = false
	State.isJumpPowerEnabled = false
	Helpers.restoreNoclip()
	Helpers.restoreMovementDefaults()
	if _maid then
		_maid:DoCleaning()
	end
end

function Player.setFlyEnabled(self: PlayerFeature, isEnabled: boolean): ()
	if State.isFlyEnabled == isEnabled then
		return
	end
	State.isFlyEnabled = isEnabled
	Helpers.applyFlyState()
end

function Player.setNoclipEnabled(self: PlayerFeature, isEnabled: boolean): ()
	if State.isNoclipEnabled == isEnabled then
		return
	end
	State.isNoclipEnabled = isEnabled
	if not isEnabled then
		Helpers.restoreNoclip()
	else
		Helpers.applyNoclip()
	end
end

function Player.setWalkSpeedEnabled(self: PlayerFeature, isEnabled: boolean): ()
	if State.isWalkSpeedEnabled == isEnabled then
		return
	end
	State.isWalkSpeedEnabled = isEnabled
	Helpers.applyWalkSpeed()
end

function Player.setJumpPowerEnabled(self: PlayerFeature, isEnabled: boolean): ()
	if State.isJumpPowerEnabled == isEnabled then
		return
	end
	State.isJumpPowerEnabled = isEnabled
	Helpers.applyJumpPower()
end

function Player.setWalkSpeed(self: PlayerFeature, value: number): ()
	State.walkSpeedValue = value
	Helpers.applyWalkSpeed()
end

function Player.setJumpPower(self: PlayerFeature, value: number): ()
	State.jumpPowerValue = value
	Helpers.applyJumpPower()
end

function Player.setFlySpeed(self: PlayerFeature, value: number): ()
	State.flySpeed = value
end

function Player.setSlideBoostEnabled(self: PlayerFeature, isEnabled: boolean): ()
	State.isSlideBoostEnabled = isEnabled
end

function Player.setSlideBoostMultiplier(self: PlayerFeature, multiplier: number): ()
	State.slideBoostMultiplier = multiplier
end

function Player.setSpoofDevice(self: PlayerFeature, device: string): ()
	State.spoofDevice = device
	local controlsController = Helpers.getControlsController()
	if controlsController and device ~= "None" then
		controlsController:SetControls(device)
	end
end

return Player
