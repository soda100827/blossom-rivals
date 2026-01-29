--!strict
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local State = require("./State")
local Constants = require("./Constants")

local Helpers = {}

function Helpers.getGlobal(name: string): any
	local getfenvAny = getfenv :: any
	local env = getfenvAny(0) :: any
	local genv = (env.getgenv and env.getgenv()) or env
	return genv[name] or env[name]
end

function Helpers.getUtility(): any
	local replicatedStorage = game:GetService("ReplicatedStorage")
	local modules = replicatedStorage:WaitForChild("Modules", 5)
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

function Helpers.getCameraShaker(): any
	local localPlayer = game:GetService("Players").LocalPlayer
	local playerScripts = localPlayer:WaitForChild("PlayerScripts", 5)
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

function Helpers.getCamera(): Camera
	local camera = Workspace.CurrentCamera
	if not camera then
		camera = Workspace:WaitForChild("Camera") :: Camera
	end
	return camera
end

function Helpers.getLocalPlayer(): Player
	return Players.LocalPlayer
end

function Helpers.getDrawingLib()
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
	if logger then
		logger:info("Fetching start...")
	end

	local playerScripts = Helpers.getLocalPlayer():WaitForChild("PlayerScripts")
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

function Helpers.fetchFighterController(logger: any)
	if State.fighterController then
		return
	end
	local playerScripts = Helpers.getLocalPlayer():WaitForChild("PlayerScripts", 10)
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

return Helpers
