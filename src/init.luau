--!strict
local Services = {
	Players = game:GetService("Players"),
	RunService = game:GetService("RunService"),
	UserInputService = game:GetService("UserInputService"),
}

local Logger = require("src/utils/Logger")
local Signal = require("@pkg/_Index/lucasmzreal_fastsignal@10.4.0/fastsignal/Deferred")

type BlossomClient = {
	Version: string,
	Logger: any,
	Events: { [string]: any },
	Modules: { [string]: any },
	IsRunning: boolean,
	LoadModule: (self: BlossomClient, name: string, moduleOrPath: any) -> (),
	SetTeleportQueue: (self: BlossomClient, enabled: boolean) -> (),
	Start: (self: BlossomClient) -> (),
	Stop: (self: BlossomClient) -> (),
	_TeleportQueueConn: any?,
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
	_TeleportQueueConn = nil,
}

function Client:LoadModule(name, moduleOrPath)
	local loader = function()
		if type(moduleOrPath) == "string" then
			return require(moduleOrPath)
		end
		return moduleOrPath
	end

	local success, result = pcall(loader)

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

function Client:SetTeleportQueue(enabled: boolean)
	if self._TeleportQueueConn then
		self._TeleportQueueConn:Disconnect()
		self._TeleportQueueConn = nil
	end

	if not enabled then
		return
	end

	local queueOnTeleport = queue_on_teleport or queueonteleport or (syn and syn.queue_on_teleport)
	if not queueOnTeleport then
		self.Logger:Warn("queue_on_teleport not available.")
		return
	end

	local success, player = pcall(function()
		return game:GetService("Players").LocalPlayer
	end)
	if not success or not player then
		self.Logger:Warn("LocalPlayer not available for teleport queue.")
		return
	end

	self._TeleportQueueConn = player.OnTeleport:Connect(function(state)
		if state == Enum.TeleportState.Started then
			queueOnTeleport([[
loadstring(game:HttpGet("https://raw.githubusercontent.com/soda100827/blossom-rivals/refs/heads/main/Distribution/bundle.luau"))()
]])
		end
	end)
end

function Client:Start()
	if self.IsRunning then
		return
	end
	self.IsRunning = true

	self.Logger:Info("Client initializing...")

	-- Load Features
	self:LoadModule("Movement", require("src/features/Movement"))
	self:LoadModule("Visuals", require("src/features/Visuals"))
	self:LoadModule("Interface", require("src/ui/Interface"))

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
