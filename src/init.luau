--!strict

--// Services
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

--// Dependencies (require)
local Logger = require("src/utils/Logger")
local Maid = require("Packages/_Index/soda100827_maid@0.4.0/maid")
local Signal = require("Packages/_Index/lucasmzreal_fastsignal@10.4.0/fastsignal/Deferred")

--// Constants
local BUNDLE_URL =
	"https://raw.githubusercontent.com/soda100827/blossom-rivals/refs/heads/main/Distribution/bundle.luau"
local CLIENT_MODULE_NAME = "Client"

--// Environment Check
local getfenvAny = getfenv :: any
local env = getfenvAny(0) :: any
local genv = (env.getgenv and env.getgenv()) or env
local function getGlobal(k: string)
	return genv[k] or env[k]
end

local queue_on_teleport = getGlobal("queue_on_teleport")
	or getGlobal("queueonteleport")
	or (env.syn and env.syn.queue_on_teleport)
local clear_teleport_queue = getGlobal("clear_teleport_queue")
	or getGlobal("clearteleportqueue")
	or (env.syn and env.syn.clear_teleport_queue)
local getloadedmodules = getGlobal("getloadedmodules") or function()
	return nil
end

local MODULES: { { name: string, loader: Module } } = {
	{ name = "Visuals", loader = require("src/features/visuals") :: Module },
	{ name = "Player", loader = require("src/features/player") :: Module },
	{ name = "Combat", loader = require("src/features/combat") :: Module },
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
	success: (self: LoggerInstance, ...unknown) -> (),
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
	IsSilent: boolean,
	loadModule: (self: BlossomClient, name: string, moduleOrPath: ModuleOrPath) -> (),
	setTeleportQueue: (self: BlossomClient, shouldEnable: boolean) -> (),
	setSilent: (self: BlossomClient, isSilent: boolean) -> (),
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
	isSilent: boolean,
	logger: LoggerInstance,
} = {
	isRunning = false,
	shouldTeleportQueue = false,
	isSilent = genv.BlossomSilent or env.BlossomSilent or false,
	logger = nil :: any,
}
local _signals: { started: Signal, stopped: Signal } = {
	started = Signal.new(),
	stopped = Signal.new(),
}
local _modules: { [string]: Module } = {}

--// Private helpers
local function _disableAnalyticsPipeline(logger: LoggerInstance)
	pcall(function()
		local controller = ReplicatedFirst:FindFirstChild("AnalyticsPipelineController")
		if not controller then
			controller = ReplicatedFirst:WaitForChild("AnalyticsPipelineController", 10)
		end
		if controller and controller:IsA("LocalScript") then
			(controller :: any).Disabled = true
		end
	end)

	local hookfunction = getGlobal("hookfunction")
	if not hookfunction then
		return
	end

	pcall(function()
		local controller = ReplicatedFirst:FindFirstChild("AnalyticsPipelineController")
		if not controller then
			controller = ReplicatedFirst:WaitForChild("AnalyticsPipelineController", 10)
		end
		if not controller then
			return
		end
		local pipeline = controller:FindFirstChild("AnalyticsPipeline")
		if not (pipeline and pipeline:IsA("ModuleScript")) then
			return
		end

		local originalRequire
		local pipelineModule = pipeline :: any
		originalRequire = hookfunction(require, function(module, ...)
			if (module :: any) == pipelineModule then
				return function() end
			end
			return (originalRequire :: any)(module, ...)
		end)
		logger:info("AnalyticsPipeline disabled and stubbed.")
	end)
end

local function _handleTeleportQueue(shouldEnable: boolean)
	if shouldEnable then
		if clear_teleport_queue then
			clear_teleport_queue()
		end

		if queue_on_teleport then
			local silentFlag = _state.isSilent and "getgenv().BlossomSilent = true; _G.BlossomSilent = true;" or ""
			queue_on_teleport(
				([[print("Blossom: Auto-loading..."); %s loadstring(game:HttpGet("%s"))()]]):format(
					silentFlag,
					BUNDLE_URL
				)
			)
		end
	else
		if clear_teleport_queue then
			clear_teleport_queue()
		end
	end
end

local function _connect()
	_maid:DoCleaning()
	if _state.shouldTeleportQueue then
		_handleTeleportQueue(true)
	end
end

local function _waitForClientLoaded()
	_state.logger:info("Rivals의 Client로드를 기다리는중.")

	local localPlayer = Players.LocalPlayer
	while not localPlayer do
		RunService.Heartbeat:Wait()
		localPlayer = Players.LocalPlayer
	end

	local playerScripts = localPlayer:WaitForChild("PlayerScripts")

	local clientModule
	repeat
		clientModule = playerScripts:FindFirstChild(CLIENT_MODULE_NAME)
		if not (clientModule and clientModule:IsA("ModuleScript")) then
			clientModule = nil
			task.wait(1)
		end
	until clientModule

	local controllersFolder
	repeat
		controllersFolder = playerScripts:FindFirstChild("Controllers")
		if not controllersFolder then
			task.wait(1)
		end
	until controllersFolder
	local folder = controllersFolder :: Instance

	while true do
		local allLoaded = true
		local loaded = getloadedmodules()
		local loadedSet = {} :: { [ModuleScript]: boolean }
		local hasLoaded = loaded ~= nil
		if loaded then
			for _, mod in ipairs(loaded) do
				loadedSet[mod] = true
			end
		end
		local function isLoaded(mod: ModuleScript): boolean
			if not hasLoaded then
				return true
			end
			return loadedSet[mod] == true
		end

		if hasLoaded and not isLoaded(clientModule :: ModuleScript) then
			allLoaded = false
		else
			for _, child in ipairs(folder:GetChildren()) do
				if child:IsA("ModuleScript") then
					if hasLoaded and not isLoaded(child) then
						allLoaded = false
						break
					end
				end
			end
		end

		if allLoaded then
			break
		end
		task.wait(0.5)
	end
end

--// Public API
function Client.loadModule(self: BlossomClient, name: string, moduleOrPath: ModuleOrPath): ()
	if _modules[name] then
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
		local initFn = moduleResult.init or moduleResult.Init
		if initFn then
			task.spawn(function()
				(initFn :: any)(moduleResult, self)
			end)
		end
	else
		_state.logger:warn("Failed to load module:", name, result)
	end
end

function Client.setTeleportQueue(self: BlossomClient, shouldEnable: boolean): ()
	_state.shouldTeleportQueue = shouldEnable
	if _state.isRunning then
		_handleTeleportQueue(shouldEnable)
	end
end

function Client.setSilent(self: BlossomClient, isSilent: boolean): ()
	if _state.isSilent == isSilent then
		return
	end
	_state.isSilent = isSilent
	if _state.shouldTeleportQueue and _state.isRunning then
		_handleTeleportQueue(true)
	end
end

function Client.start(self: BlossomClient): ()
	if _state.isRunning then
		return
	end
	_state.isRunning = true

	_disableAnalyticsPipeline(_state.logger)
	_state.logger:info("Blossom 초기화 시작됨.")
	_waitForClientLoaded()

	for _, entry in ipairs(MODULES) do
		self:loadModule(entry.name, entry.loader)
	end

	_connect()
	_signals.started:Fire()
	_state.logger:success("Blossom 로드 완료.")
end

function Client.destroy(self: BlossomClient): ()
	if not _state.isRunning then
		return
	end
	_state.isRunning = false
	_signals.stopped:Fire()
	_maid:DoCleaning()

	for _, moduleResult in pairs(_modules) do
		local cleanupFn = moduleResult.cleanup or moduleResult.Cleanup
		if cleanupFn then
			pcall(cleanupFn, moduleResult)
		end
	end
end

local loggerModule = (Logger :: any) :: LoggerModule

local client = (setmetatable({}, Client) :: any) :: BlossomClient
client.Version = "1.0.0"
client.Logger = loggerModule.new("Blossom")
client.Modules = _modules
client.Started = _signals.started
client.Stopped = _signals.stopped
client.IsSilent = _state.isSilent

_state.logger = client.Logger

return client:start()
