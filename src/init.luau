--!strict

--// Services
local Players = game:GetService("Players")
local ReplicatedFirst = game:GetService("ReplicatedFirst")

--// Dependencies (require)
local Logger = require("src/utils/Logger")
local Maid = require("Packages/maid")
local Signal = require("Packages/_Index/lucasmzreal_fastsignal@10.4.0/fastsignal/Deferred")

--// Constants
local BUNDLE_URL =
	"https://raw.githubusercontent.com/soda100827/blossom-rivals/refs/heads/main/Distribution/bundle.luau"

local MODULES: { { name: string, loader: Module } } = {
	{ name = "Visuals", loader = require("src/features/Visuals") :: Module },
	{ name = "Interface", loader = require("src/ui/Interface") :: Module },
}

--// Types
export type Signal = {
	Fire: (self: Signal, ...unknown) -> (),
}

export type LoggerInstance = {
	info: (self: LoggerInstance, ...unknown) -> (),
	warn: (self: LoggerInstance, ...unknown) -> (),
	error: (self: LoggerInstance, ...unknown) -> (),
}

export type LoggerModule = {
	new: (source: string?) -> LoggerInstance,
}

export type Module = {
	init: ((self: Module, client: BlossomClient) -> ())?,
	cleanup: ((self: Module) -> ())?,
	Init: ((self: Module, client: BlossomClient) -> ())?,
	Cleanup: ((self: Module) -> ())?,
	[string]: unknown,
}

export type ModuleOrPath = Module | string

export type BlossomClient = {
	Version: string,
	Logger: LoggerInstance,
	Modules: { [string]: Module },
	Started: Signal,
	Stopped: Signal,
	loadModule: (self: BlossomClient, name: string, moduleOrPath: ModuleOrPath) -> (),
	setTeleportQueue: (self: BlossomClient, shouldEnable: boolean) -> (),
	start: (self: BlossomClient) -> (),
	destroy: (self: BlossomClient) -> (),
}

--// Private state
local Client = {}
Client.__index = Client

local _maid = Maid.new()
local _state: {
	isRunning: boolean,
	shouldTeleportQueue: boolean,
	logger: LoggerInstance,
} = {
	isRunning = false,
	shouldTeleportQueue = false,
	logger = nil :: any,
}
local _signals: { started: Signal, stopped: Signal } = {
	started = Signal.new(),
	stopped = Signal.new(),
}
local _modules: { [string]: Module } = {}

--// Private helpers
local function _disableAnalyticsPipeline(logger: LoggerInstance)
	local success, err = pcall(function()
		local controller = ReplicatedFirst:FindFirstChild("AnalyticsPipelineController")
		if not controller then
			controller = ReplicatedFirst:WaitForChild("AnalyticsPipelineController", 10)
		end
		if controller then
			(controller :: any).Disabled = true
		end
	end)

	if not success then
		logger:warn("Failed to disable AnalyticsPipelineController:", err)
	end
end

local function _getQueueOnTeleport(): ((string) -> ())?
	local globals = _G :: any
	local synCompat = globals.syn
	return queue_on_teleport or queueonteleport or (synCompat and synCompat.queue_on_teleport)
end

local function _connect()
	_maid:DoCleaning()
	if not _state.shouldTeleportQueue then
		return
	end

	local queueOnTeleport = _getQueueOnTeleport()
	if not queueOnTeleport then
		_state.logger:warn("queue_on_teleport not available.")
		return
	end

	local player = Players.LocalPlayer
	if not player then
		_state.logger:warn("LocalPlayer not available for teleport queue.")
		return
	end

	local conn = player.OnTeleport:Connect(function(state)
		if state == Enum.TeleportState.Started then
			queueOnTeleport(([[loadstring(game:HttpGet("%s"))()]]):format(BUNDLE_URL))
		end
	end)
	_maid:GiveTask(conn)
end

local function _getModuleInit(moduleResult: Module)
	return moduleResult.init or moduleResult.Init
end

local function _getModuleCleanup(moduleResult: Module)
	return moduleResult.cleanup or moduleResult.Cleanup
end

--// Public API
function Client.loadModule(self: BlossomClient, name: string, moduleOrPath: ModuleOrPath): ()
	if _modules[name] then
		_state.logger:warn("Module already loaded:", name)
		return
	end

	local loader = function()
		if type(moduleOrPath) == "string" then
			local dynamicRequire = require :: any
			return dynamicRequire(moduleOrPath)
		end
		return moduleOrPath
	end

	local success, result = pcall(loader)
	if success then
		local moduleResult = result :: Module
		_modules[name] = moduleResult
		local initFn = _getModuleInit(moduleResult) :: any
		if initFn then
			task.spawn(function()
				initFn(moduleResult, self)
			end)
		end
		_state.logger:info("Loaded module:", name)
	else
		_state.logger:warn("Failed to load module:", name, result)
	end
end

function Client.setTeleportQueue(self: BlossomClient, shouldEnable: boolean): ()
	_state.shouldTeleportQueue = shouldEnable
	if _state.isRunning then
		_connect()
	end
end

function Client.start(self: BlossomClient): ()
	if _state.isRunning then
		return
	end
	_state.isRunning = true

	_disableAnalyticsPipeline(_state.logger)
	_state.logger:info("Client initializing...")

	for _, entry in ipairs(MODULES) do
		self:loadModule(entry.name, entry.loader)
	end

	_connect()
	_signals.started:Fire()
end

function Client.destroy(self: BlossomClient): ()
	if not _state.isRunning then
		return
	end
	_state.isRunning = false
	_signals.stopped:Fire()
	_maid:DoCleaning()

	for _, moduleResult in pairs(_modules) do
		local cleanupFn = _getModuleCleanup(moduleResult) :: any
		if cleanupFn then
			pcall(cleanupFn, moduleResult)
		end
	end

	_state.logger:info("Client stopped.")
end

local loggerModule = (Logger :: any) :: LoggerModule

local client = (setmetatable({}, Client) :: any) :: BlossomClient
client.Version = "1.0.0"
client.Logger = loggerModule.new("Blossom")
client.Modules = _modules
client.Started = _signals.started
client.Stopped = _signals.stopped

_state.logger = client.Logger

return client:start()
