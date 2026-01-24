--!strict
local Services = {
	Players = game:GetService("Players"),
	RunService = game:GetService("RunService"),
	UserInputService = game:GetService("UserInputService"),
}

local Logger = require(script.Parent.utils.Logger)
local Signal = require(script.Parent.utils.Signal)

type BlossomClient = {
	Version: string,
	Logger: any,
	Events: { [string]: any },
	Modules: { [string]: any },
	IsRunning: boolean,
	LoadModule: (self: BlossomClient, name: string, path: string) -> (),
	Start: (self: BlossomClient) -> (),
	Stop: (self: BlossomClient) -> (),
}

local Client: BlossomClient = {
	Version = "1.0.0",
	Logger = Logger.new("Blossom"),
	Events = {
		Started = Signal.new(),
		Stopped = Signal.new(),
	},
	Modules = {},
	IsRunning = false,
}

function Client:LoadModule(name, moduleScript)
	local success, result = pcall(require, moduleScript)

	if success then
		self.Modules[name] = result
		if result.Init then
			task.spawn(function()
				result:Init(self)
			end)
		end
		self.Logger:Info("Loaded module:", name)
	else
		self.Logger:Warn("Failed to load module:", name, result)
	end
end

function Client:Start()
	if self.IsRunning then
		return
	end
	self.IsRunning = true

	self.Logger:Info("Client initializing...")

	-- Load Features
	self:LoadModule("Movement", script.Parent.features.Movement)
	self:LoadModule("Visuals", script.Parent.features.Visuals)
	self:LoadModule("Interface", script.Parent.ui.Interface)

	self.Events.Started:Fire()
end

function Client:Stop()
	self.IsRunning = false
	self.Events.Stopped:Fire()

	for name, module in pairs(self.Modules) do
		if module.Cleanup then
			pcall(module.Cleanup, module)
		end
	end

	self.Logger:Info("Client stopped.")
end

return Client:Start()
