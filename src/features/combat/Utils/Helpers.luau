--!strict

--// Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Dependencies (require)
local PlayerUtils = require("../../../shared/PlayerUtils")
local State = require("../State")
local Constants = require("../Constants")

--// Constants

--// Types

--// Private state
local Helpers = {}

--// Private helpers

--// Public API

function Helpers.getUtility(): any
	local modules = ReplicatedStorage:WaitForChild("Modules", 5)
	if not modules then
		return nil
	end
	local utility = modules:WaitForChild("Utility", 5)
	if not utility then
		return nil
	end
	local success, result = pcall(function()
		local dynamicRequire = require :: any
		return dynamicRequire(utility)
	end)
	return success and result or nil
end

function Helpers.getGameplayUtility(): any
	local modules = ReplicatedStorage:WaitForChild("Modules", 5)
	if not modules then
		return nil
	end
	local utility = modules:WaitForChild("GameplayUtility", 5)
	if not utility then
		return nil
	end
	local success, result = pcall(function()
		local dynamicRequire = require :: any
		return dynamicRequire(utility)
	end)
	return success and result or nil
end

function Helpers.getCameraShaker(): any
	local playerScripts = Players.LocalPlayer:WaitForChild("PlayerScripts", 5)
	if not playerScripts then
		return nil
	end
	local modules = playerScripts:WaitForChild("Modules", 5)
	if not modules then
		return nil
	end
	local cameraShaker = modules:WaitForChild("CameraShaker", 5)
	if not cameraShaker then
		return nil
	end
	local success, result = pcall(function()
		local dynamicRequire = require :: any
		return dynamicRequire(cameraShaker)
	end)
	return success and result or nil
end

function Helpers.applyInputLock(isLocked: boolean)
	if isLocked and State.smoothness < Constants.MAX_SMOOTHNESS then
		return
	end
	if isLocked == State.isInputLocked then
		return
	end

	if isLocked then
		if State.mouseBehavior == nil then
			State.mouseBehavior = UserInputService.MouseBehavior
		end
		if State.mouseDeltaSensitivity == nil then
			State.mouseDeltaSensitivity = UserInputService.MouseDeltaSensitivity
		end
		UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
		UserInputService.MouseDeltaSensitivity = 0
	else
		local restoreBehavior = State.mouseBehavior or Enum.MouseBehavior.Default
		local restoreSensitivity = State.mouseDeltaSensitivity or 1
		UserInputService.MouseBehavior = restoreBehavior
		UserInputService.MouseDeltaSensitivity = restoreSensitivity
		State.mouseBehavior = nil
		State.mouseDeltaSensitivity = nil
	end

	State.isInputLocked = isLocked
end

function Helpers.isMaxSmoothness(): boolean
	return State.smoothness >= Constants.MAX_SMOOTHNESS
end

function Helpers.fetchCameraController(logger: any)
	if State.cameraController then
		return
	end

	local player = PlayerUtils.getLocalPlayer()
	if not player then
		return
	end
	local playerScripts = player:WaitForChild("PlayerScripts")
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
			State.cameraController = result
		else
			if logger then
				logger:error("Failed CameraController", result)
			end
		end
	end
end

function Helpers.fetchFighterController(logger: any)
	if State.fighterController then
		return
	end
	local player = PlayerUtils.getLocalPlayer()
	if not player then
		return
	end
	local playerScripts = player:WaitForChild("PlayerScripts", 10)
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
			State.fighterController = result
		end
	end
end

function Helpers.getGunModule(): any
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
	local itemTypes = modules:WaitForChild("ItemTypes", 5)
	if not itemTypes then
		return nil
	end
	local gun = itemTypes:WaitForChild("Gun", 5)
	if not gun then
		return nil
	end
	local success, result = pcall(function()
		local dynamicRequire = require :: any
		return dynamicRequire(gun)
	end)
	return success and result or nil
end

function Helpers.getClientItemModule(): any
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
	local clientItem = clientFighter:WaitForChild("ClientItem", 5)
	if not clientItem then
		return nil
	end
	local success, result = pcall(function()
		local dynamicRequire = require :: any
		return dynamicRequire(clientItem)
	end)
	return success and result or nil
end

function Helpers.getViewModelModule(): any
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
	local clientItemScript = clientFighter:WaitForChild("ClientItem", 5)
	if not clientItemScript then
		return nil
	end
	local viewModel = clientItemScript:WaitForChild("ClientViewModel", 5)
	if not viewModel then
		return nil
	end
	local success, result = pcall(function()
		local dynamicRequire = require :: any
		return dynamicRequire(viewModel)
	end)
	return success and result or nil
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

function Helpers.getMeleeModule(): any
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
	local itemTypes = modules:WaitForChild("ItemTypes", 5)
	if not itemTypes then
		return nil
	end
	local melee = itemTypes:WaitForChild("Melee", 5)
	if not melee then
		return nil
	end
	local success, result = pcall(function()
		local dynamicRequire = require :: any
		return dynamicRequire(melee)
	end)
	return success and result or nil
end

function Helpers.getItemModules(): any
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
	return modules:WaitForChild("Items", 5)
end

return Helpers
