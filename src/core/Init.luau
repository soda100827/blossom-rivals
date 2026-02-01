--!strict

-- Services
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Dependencies (require)
local ExecutorUtils = require("src/shared/ExecutorUtils")
local Logger = require("src/shared/Logger")
local ModuleRegistry = require("src/core/ModuleRegistry")
local FastSignal = require("Packages/_Index/lucasmzreal_fastsignal@10.4.0/fastsignal/Deferred")
local Maid = require("Packages/_Index/soda100827_maid@0.4.0/maid")

-- Constants
local BUNDLE_URL = "https://raw.githubusercontent.com/soda100827/blossom-rivals/refs/heads/main/build/loader.luau"
local CLIENT_MODULE_NAME = "Client"
local VERSION = "5.2.3"

-- Types
export type FastSignal = {
	Fire: (self: FastSignal, ...unknown) -> (),
}

export type LoggerInstance = {
	info: (self: LoggerInstance, ...unknown) -> (),
	warn: (self: LoggerInstance, ...unknown) -> (),
	error: (self: LoggerInstance, ...unknown) -> (),
	success: (self: LoggerInstance, ...unknown) -> (),
	warnUnsupported: (self: LoggerInstance, name: string) -> (),
}

export type LoggerModule = {
	new: (source: string?) -> LoggerInstance,
	Destroy: (() -> ())?,
}

export type Module = {
	init: ((self: Module, client: BlossomClient) -> ())?,
	Init: ((self: Module, client: BlossomClient) -> ())?,
	Destroy: ((self: Module) -> ())?,
	[string]: unknown,
}

export type ModuleOrPath = Module | string

export type BlossomClient = {
	Version: string,
	Logger: LoggerInstance,
	Modules: { [string]: Module },
	IsSilent: boolean,
	loadModule: (self: BlossomClient, name: string, moduleOrPath: ModuleOrPath) -> (),
	setTeleportQueue: (self: BlossomClient, shouldEnable: boolean) -> (),
	setSilent: (self: BlossomClient, isSilent: boolean) -> (),
	start: (self: BlossomClient) -> (),
	destroy: (self: BlossomClient) -> (),
	getStarted: (self: BlossomClient) -> FastSignal,
	getStopped: (self: BlossomClient) -> FastSignal,
	Init: (self: BlossomClient) -> (),
	Destroy: (self: BlossomClient) -> (),
}

type State = {
	isRunning: boolean,
	shouldTeleportQueue: boolean,
	isSilent: boolean,
	logger: LoggerInstance,
}

type Signals = {
	Started: FastSignal,
	Stopped: FastSignal,
}

type QueueOnTeleport = (code: string) -> ()
type ClearTeleportQueue = () -> ()
type HookFunction = (target: (...unknown) -> ...unknown, hook: (...unknown) -> ...unknown) -> (...unknown) -> ...unknown
type NewCClosure = (func: (...unknown) -> ...unknown) -> (...unknown) -> ...unknown
type CheckCaller = () -> boolean
type GetGenv = () -> { [string]: unknown }
type GetLoadedModules = () -> { ModuleScript }?
type Syn = { queue_on_teleport: QueueOnTeleport?, clear_teleport_queue: ClearTeleportQueue? }
type ModuleEntry = { name: string, loader: Module }

-- Private state
local Module = {}

local _maid = Maid.new()
local _loggerModule = Logger :: LoggerModule
local _initialLogger = _loggerModule.new("Blossom")
local _state: State = {
	isRunning = false,
	shouldTeleportQueue = false,
	isSilent = (ExecutorUtils.getGlobal("BlossomSilent") :: boolean?) or false,
	logger = _initialLogger,
}
local _signals: Signals = {
	Started = FastSignal.new(),
	Stopped = FastSignal.new(),
}
local _modules: { [string]: Module } = {}
local _syn = ExecutorUtils.getGlobal("syn") :: Syn?
local _queueOnTeleport = (ExecutorUtils.getGlobal("queue_on_teleport") :: QueueOnTeleport?)
	or (ExecutorUtils.getGlobal("queueonteleport") :: QueueOnTeleport?)
	or (_syn and _syn.queue_on_teleport)
local _clearTeleportQueue = (ExecutorUtils.getGlobal("clear_teleport_queue") :: ClearTeleportQueue?)
	or (ExecutorUtils.getGlobal("clearteleportqueue") :: ClearTeleportQueue?)
	or (_syn and _syn.clear_teleport_queue)
local _rawGetLoadedModules = ExecutorUtils.getGlobal("getloadedmodules") :: GetLoadedModules?
local _hookfunction = (ExecutorUtils.getGlobal("hookfunction") :: HookFunction?)
	or ExecutorUtils.getGlobal("replaceclosure") :: HookFunction?
local _newcclosure = ExecutorUtils.getGlobal("newcclosure") :: NewCClosure?
local _checkcaller = ExecutorUtils.getGlobal("checkcaller") :: CheckCaller?
local _getgenvFunc = ExecutorUtils.getGlobal("getgenv") :: GetGenv?
local _moduleEntries: { ModuleEntry } = ModuleRegistry.getModules()

-- Private helpers
local function _getLoadedModules(): { ModuleScript }?
	if _rawGetLoadedModules then
		return _rawGetLoadedModules()
	end

	return nil
end

local function _initSignals(): ()
	_signals.Started = FastSignal.new()
	_signals.Stopped = FastSignal.new()
end

local function _connect(): () end

local function _disableAnalyticsPipeline(): ()
	pcall(function()
		local controller = ReplicatedFirst:FindFirstChild("AnalyticsPipelineController")
		if not controller then
			controller = ReplicatedFirst:WaitForChild("AnalyticsPipelineController", 10)
		end
		if controller and controller:IsA("LocalScript") then
			(controller :: LocalScript).Disabled = true
		end
	end)

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

		local originalRequire: ((...unknown) -> ...unknown)?
		local pipelineModule = pipeline :: ModuleScript
		originalRequire = _hookfunction(require, function(module, ...)
			if module == pipelineModule then
				return function() end
			end
			return (originalRequire :: (...unknown) -> ...unknown)(module, ...)
		end)
	end)
end

local function _checkExecutorSupport(logger: LoggerInstance): boolean
	local missing = {} :: { string }

	local function _markMissing(name: string): ()
		table.insert(missing, name)
	end

	if not _queueOnTeleport then
		_markMissing("queue_on_teleport")
	end
	if not _clearTeleportQueue then
		_markMissing("clear_teleport_queue")
	end
	if not _hookfunction then
		_markMissing("hookfunction")
	end
	if not _newcclosure then
		_markMissing("newcclosure")
	end
	if not _checkcaller then
		_markMissing("checkcaller")
	end
	if not _getgenvFunc then
		_markMissing("getgenv")
	end
	if not _rawGetLoadedModules then
		_markMissing("getloadedmodules")
	end

	if #missing == 0 then
		return true
	end

	for _, name in ipairs(missing) do
		if logger.warnUnsupported then
			logger:warnUnsupported(name)
		else
			logger:warn(
				string.format("This executor does not support '%s'. Some features may not work as expected.", name)
			)
		end
	end

	local localPlayer = Players.LocalPlayer
	if not localPlayer then
		localPlayer = Players.PlayerAdded:Wait()
	end
	localPlayer:Kick(string.format("Required executor APIs are missing: %s", table.concat(missing, ", ")))
	return false
end

local function _handleTeleportQueue(shouldEnable: boolean): ()
	if shouldEnable then
		if _clearTeleportQueue then
			_clearTeleportQueue()
		end

		if _queueOnTeleport then
			local silentFlag = _state.isSilent and "getgenv().BlossomSilent = true; _G.BlossomSilent = true;" or ""
			_queueOnTeleport(
				([[print("Blossom: Auto-loading..."); %s loadstring(game:HttpGet("%s"))()]]):format(
					silentFlag,
					BUNDLE_URL
				)
			)
		end

		return
	end

	if _clearTeleportQueue then
		_clearTeleportQueue()
	end
end

local function _waitForClientLoaded(): ()
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
		local isAllLoaded = true
		local loaded = _getLoadedModules()
		local loadedSet = {} :: { [ModuleScript]: boolean }
		local hasLoaded = loaded ~= nil

		if loaded then
			for _, mod in ipairs(loaded) do
				loadedSet[mod] = true
			end
		end

		local function _isLoaded(mod: ModuleScript): boolean
			if not hasLoaded then
				return true
			end
			return loadedSet[mod] == true
		end

		if hasLoaded and not _isLoaded(clientModule :: ModuleScript) then
			isAllLoaded = false
		else
			for _, child in ipairs(folder:GetChildren()) do
				if child:IsA("ModuleScript") then
					if hasLoaded and not _isLoaded(child) then
						isAllLoaded = false
						break
					end
				end
			end
		end

		if isAllLoaded then
			break
		end
		task.wait(0.5)
	end
end

-- Public API
function Module.loadModule(self: BlossomClient, name: string, moduleOrPath: ModuleOrPath): ()
	if _modules[name] then
		return
	end

	local loader = function(): Module
		if type(moduleOrPath) == "string" then
			local dynamicRequire = require :: (string) -> Module
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
				(initFn :: (Module, BlossomClient) -> ())(moduleResult, self)
			end)
		end
		return
	end

	_state.logger:warn("Failed to load module:", name, result)
end

function Module.setTeleportQueue(self: BlossomClient, shouldEnable: boolean): ()
	_state.shouldTeleportQueue = shouldEnable
	if _state.isRunning then
		_handleTeleportQueue(shouldEnable)
	end
end

function Module.setSilent(self: BlossomClient, isSilent: boolean): ()
	if _state.isSilent == isSilent then
		return
	end

	_state.isSilent = isSilent
	self.IsSilent = _state.isSilent

	if _state.shouldTeleportQueue and _state.isRunning then
		_handleTeleportQueue(true)
	end
end

function Module.getStarted(self: BlossomClient): FastSignal
	return _signals.Started
end

function Module.getStopped(self: BlossomClient): FastSignal
	return _signals.Stopped
end

function Module.start(self: BlossomClient): ()
	if _state.isRunning then
		return
	end
	_state.isRunning = true

	self:Init()

	if not _checkExecutorSupport(_state.logger) then
		_state.isRunning = false
		return
	end
	_disableAnalyticsPipeline()

	local startTime = os.clock()
	_waitForClientLoaded()

	for _, entry in ipairs(_moduleEntries) do
		self:loadModule(entry.name, entry.loader)
	end

	if _state.shouldTeleportQueue then
		_handleTeleportQueue(true)
	end

	_signals.Started:Fire()
	_state.logger:info(string.format("Blossom loaded in %.2f seconds.", os.clock() - startTime))
end

function Module.destroy(self: BlossomClient): ()
	if not _state.isRunning then
		return
	end
	_state.isRunning = false

	_signals.Stopped:Fire()
	_maid:DoCleaning()

	for _, moduleResult in pairs(_modules) do
		local destroyFn = moduleResult.Destroy
		if destroyFn then
			pcall(destroyFn, moduleResult)
		end
	end

	if _loggerModule and _loggerModule.Destroy then
		_loggerModule.Destroy()
	end
end

function Module.Init(self: BlossomClient): ()
	_initSignals()
	_connect()
end

function Module.Destroy(self: BlossomClient): ()
	self:destroy()
end

Module.Version = VERSION
Module.Logger = _initialLogger
Module.Modules = _modules
Module.IsSilent = _state.isSilent

_state.logger = Module.Logger

Module:start()

return Module
