--!strict

--// Services

--// Dependencies (require)
local PlayerUtils = require("../../../shared/PlayerUtils")
local Constants = require("../Constants")
local State = require("../State")

--// Constants

--// Types

--// Private state
local Helpers = {}
local _cachedNoclipParts = {} :: { BasePart }

--// Private helpers

--// Public API

function Helpers.resetInput()
	State.input = {
		forward = 0,
		back = 0,
		left = 0,
		right = 0,
		up = 0,
		down = 0,
	}
end

function Helpers.cacheDefaults(humanoid: Humanoid)
	State.defaultWalkSpeed = humanoid.WalkSpeed
	State.defaultUseJumpPower = humanoid.UseJumpPower
	if humanoid.UseJumpPower then
		State.defaultJumpPower = humanoid.JumpPower
		State.defaultJumpHeight = nil
	else
		State.defaultJumpPower = nil
		State.defaultJumpHeight = humanoid.JumpHeight
	end
	State.defaultAutoRotate = humanoid.AutoRotate
	State.defaultPlatformStand = humanoid.PlatformStand
end

function Helpers.applyWalkSpeed()
	local humanoid = State.humanoid
	if not humanoid then
		return
	end
	if State.defaultWalkSpeed ~= nil then
		humanoid.WalkSpeed = State.defaultWalkSpeed
	end
end

function Helpers.applyJumpPower()
	return
end

function Helpers.restoreMovementDefaults()
	local humanoid = State.humanoid
	if not humanoid then
		return
	end
	if State.defaultWalkSpeed ~= nil then
		humanoid.WalkSpeed = State.defaultWalkSpeed
	end
	if State.defaultUseJumpPower ~= nil then
		humanoid.UseJumpPower = State.defaultUseJumpPower
	end
	if State.defaultUseJumpPower then
		if State.defaultJumpPower ~= nil then
			humanoid.JumpPower = State.defaultJumpPower
		end
	else
		if State.defaultJumpHeight ~= nil then
			humanoid.JumpHeight = State.defaultJumpHeight
		end
	end
	if State.defaultAutoRotate ~= nil then
		humanoid.AutoRotate = State.defaultAutoRotate
	end
	if State.defaultPlatformStand ~= nil then
		humanoid.PlatformStand = State.defaultPlatformStand
	end
end

function Helpers.setCharacter(character: Model?)
	State.character = character
	State.humanoid = nil
	State.rootPart = nil
	if not character then
		return
	end
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoid then
		humanoid = character:WaitForChild("Humanoid", 5) :: Humanoid?
	end
	local rootPart = character:FindFirstChild("HumanoidRootPart")
	if not rootPart then
		rootPart = character:WaitForChild("HumanoidRootPart", 5)
	end
	if humanoid then
		State.humanoid = humanoid
		Helpers.cacheDefaults(humanoid)
	end
	if rootPart and rootPart:IsA("BasePart") then
		State.rootPart = rootPart
	end
	Helpers.applyWalkSpeed()
	Helpers.applyJumpPower()
end

function Helpers.applyNoclip()
	local character = State.character
	if not character then
		return
	end
	if #_cachedNoclipParts == 0 then
		for _, part in ipairs(character:GetDescendants()) do
			if part:IsA("BasePart") then
				table.insert(_cachedNoclipParts, part)
			end
		end
	end
	for _, part in ipairs(_cachedNoclipParts) do
		if part:IsA("BasePart") then
			if State.noclipParts[part] == nil then
				State.noclipParts[part] = part.CanCollide
			end
			part.CanCollide = false
		end
	end
end

function Helpers.restoreNoclip()
	_cachedNoclipParts = {}
	for part, original in pairs(State.noclipParts) do
		if part and part.Parent then
			part.CanCollide = original
		end
	end
	State.noclipParts = {}
end

function Helpers.applyFlyState()
	local humanoid = State.humanoid
	if not humanoid then
		return
	end
	if State.isFlyEnabled then
		humanoid.PlatformStand = false
		humanoid.AutoRotate = true
	else
		local rootPart = State.rootPart
		if rootPart then
			rootPart.AssemblyLinearVelocity = Vector3.zero
			rootPart.AssemblyAngularVelocity = Vector3.zero
		end
		if State.defaultPlatformStand ~= nil then
			humanoid.PlatformStand = State.defaultPlatformStand
		end
		if State.defaultAutoRotate ~= nil then
			humanoid.AutoRotate = State.defaultAutoRotate
		end
	end
end

function Helpers.getFlyMoveVector(): Vector3
	local camera = PlayerUtils.getCamera()
	local forward = camera.CFrame.LookVector
	local right = camera.CFrame.RightVector
	local up = camera.CFrame.UpVector
	local move = forward * (State.input.forward - State.input.back)
		+ right * (State.input.right - State.input.left)
		+ up * (State.input.up - State.input.down)
	if move.Magnitude > 1 then
		move = move.Unit
	end
	return move
end

function Helpers.onCharacterAdded(character: Model)
	Helpers.resetInput()
	Helpers.setCharacter(character)
	_cachedNoclipParts = {}
	if State.isFlyEnabled then
		Helpers.applyFlyState()
	end
	if State.isNoclipEnabled then
		Helpers.applyNoclip()
	end
end

function Helpers.onCharacterRemoving()
	Helpers.restoreNoclip()
	if State.characterMaid then
		State.characterMaid:DoCleaning()
		State.characterMaid = nil
	end
	Helpers.resetInput()
	State.character = nil
	State.humanoid = nil
	State.rootPart = nil
end

function Helpers.onInputChanged(input: InputObject, isPressed: boolean)
	local keyName = Constants.INPUT_MAP[input.KeyCode]
	if not keyName then
		return
	end
	State.input[keyName] = isPressed and 1 or 0
end

function Helpers.getReplicatedClassModule(): any
	local replicatedStorage = game:GetService("ReplicatedStorage")
	local modules = replicatedStorage:WaitForChild("Modules", 5)
	if not modules then
		return nil
	end
	local replicatedClass = modules:WaitForChild("ReplicatedClass", 5)
	if not replicatedClass then
		return nil
	end
	local success, result = pcall(function()
		local dynamicRequire = require :: any
		return dynamicRequire(replicatedClass)
	end)
	return success and result or nil
end

function Helpers.getControlsController(): any
	local player = PlayerUtils.getLocalPlayer()
	if not player then
		return nil
	end
	local playerScripts = player:WaitForChild("PlayerScripts", 5)
	if not playerScripts then
		return nil
	end
	local controllers = playerScripts:WaitForChild("Controllers", 5)
	if not controllers then
		return nil
	end
	local controlsController = controllers:WaitForChild("ControlsController", 5)
	if not controlsController then
		return nil
	end
	local success, result = pcall(function()
		local dynamicRequire = require :: any
		return dynamicRequire(controlsController)
	end)
	return success and result or nil
end

function Helpers.getFlashedModule(): any
	local player = PlayerUtils.getLocalPlayer()
	if not player then
		return nil
	end
	local playerScripts = player:WaitForChild("PlayerScripts", 5)
	if not playerScripts then
		return nil
	end
	local modules = playerScripts:WaitForChild("Modules", 5)
	if not modules then
		return nil
	end
	local clientReplicatedClasses = modules:WaitForChild("ClientReplicatedClasses", 5)
	if not clientReplicatedClasses then
		return nil
	end
	local clientFighter = clientReplicatedClasses:WaitForChild("ClientFighter", 5)
	if not clientFighter then
		return nil
	end
	local fighterInterface = clientFighter:WaitForChild("FighterInterface", 5)
	if not fighterInterface then
		return nil
	end
	local flashed = fighterInterface:WaitForChild("Flashed", 5)
	if not flashed then
		return nil
	end
	local success, result = pcall(function()
		local dynamicRequire = require :: any
		return dynamicRequire(flashed)
	end)
	return success and result or nil
end

function Helpers.getMechanicsController(): any
	local player = PlayerUtils.getLocalPlayer()
	if not player then
		return nil
	end
	local playerScripts = player:WaitForChild("PlayerScripts", 5)
	if not playerScripts then
		return nil
	end
	local controllers = playerScripts:WaitForChild("Controllers", 5)
	if not controllers then
		return nil
	end
	local mechanicsController = controllers:WaitForChild("MechanicsController", 5)
	if not mechanicsController then
		return nil
	end
	local success, result = pcall(function()
		local dynamicRequire = require :: any
		return dynamicRequire(mechanicsController)
	end)
	return success and result or nil
end

function Helpers.getSetControlsRemote(): any
	local replicatedStorage = game:GetService("ReplicatedStorage")
	local remotes = replicatedStorage:WaitForChild("Remotes", 5)
	if not remotes then
		return nil
	end
	local replication = remotes:WaitForChild("Replication", 5)
	if not replication then
		return nil
	end
	local fighter = replication:WaitForChild("Fighter", 5)
	if not fighter then
		return nil
	end
	return fighter:WaitForChild("SetControls", 5)
end

function Helpers.getPlayMechanicsSoundRemote(): any
	local replicatedStorage = game:GetService("ReplicatedStorage")
	local remotes = replicatedStorage:WaitForChild("Remotes", 5)
	if not remotes then
		return nil
	end
	local replication = remotes:WaitForChild("Replication", 5)
	if not replication then
		return nil
	end
	local fighter = replication:WaitForChild("Fighter", 5)
	if not fighter then
		return nil
	end
	return fighter:WaitForChild("PlayMechanicsSound", 5)
end

return Helpers
