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
local CONTROLLER_NAMES = {
	"PlayerDataController",
	"ComplianceController",
	"FunctionsController",
	"MiscController",
	"UserInterfaceController",
	"MonetizationController",
	"EnemyController",
	"CameraController",
	"MechanicsController",
	"FighterController",
	"SpectateController",
	"TightropeController",
	"EntityController",
	"DuelController",
	"GameComponentsController",
	"ControlsController",
	"LeaderboardController",
	"LobbyController",
	"QueuePadController",
	"LightingController",
	"ShootingRangeController",
	"CoreGuiController",
	"MusicController",
	"MobileController",
	"ShopController",
	"ProximityPromptController",
	"PlayerInteractionController",
	"DebugController",
	"MatchmakingController",
	"ChattingController",
	"EventController",
	"PrivateServerController",
	"TestingController",
	"ShadyChickenController",
	"WrapController",
	"ScavengerHuntController",
	"SocialController",
	"FFlagController",
	"AudioController",
	"BirthdayController",
	"ArcadeController",
	"EmoteController",
	"SeasonController",
}

local MODULES: { { name: string, loader: Module } } = {
	{ name = "Visuals", loader = require("src/features/Visuals") :: Module },
	{ name = "Player", loader = require("src/features/Player") :: Module },
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
	isSilent = (function()
		local getfenvAny = getfenv :: any
		local g = getfenvAny(0) :: any
		return g.BlossomSilent or (g.getgenv and g.getgenv().BlossomSilent) or false
	end)(),
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
			logger:info("AnalyticsPipelineController Disabled")
		end
	end)

	if not success then
		logger:warn("Failed to disable AnalyticsPipelineController:", err)
	end
end

local function _getQueueOnTeleport(): ((string) -> ())?
	local env = getfenv() :: any
	return env.queue_on_teleport or env.queueonteleport or (env.syn and env.syn.queue_on_teleport)
end

local function _getClearTeleportQueue(): (() -> ())?
	local env = getfenv() :: any
	return env.clear_teleport_queue or env.clearteleportqueue or (env.syn and env.syn.clear_teleport_queue)
end

local function _handleTeleportQueue(shouldEnable: boolean)
	if shouldEnable then
		local queueOnTeleport = _getQueueOnTeleport()
		local clearTeleportQueue = _getClearTeleportQueue()

		-- Attempt to clear first to avoid duplicates if possible
		if clearTeleportQueue then
			clearTeleportQueue()
		end

		if queueOnTeleport then
			_state.logger:info("Queueing auto-load script...")
			local silentFlag = _state.isSilent and "getgenv().BlossomSilent = true; _G.BlossomSilent = true;" or ""
			queueOnTeleport(
				([[print("Blossom: Auto-loading..."); %s loadstring(game:HttpGet("%s"))()]]):format(
					silentFlag,
					BUNDLE_URL
				)
			)
		else
			_state.logger:warn("queue_on_teleport function not found!")
		end
	else
		local clearTeleportQueue = _getClearTeleportQueue()
		if clearTeleportQueue then
			_state.logger:info("Clearing teleport queue...")
			clearTeleportQueue()
		else
			_state.logger:warn("clear_teleport_queue function not found!")
		end
	end
end

local function _connect()
	_maid:DoCleaning()
	-- Refresh queue if needed (e.g. silent state changed)
	if _state.shouldTeleportQueue then
		_handleTeleportQueue(true)
	end
end

local function _waitForClientLoaded()
	local localPlayer = Players.LocalPlayer
	while not localPlayer do
		RunService.Heartbeat:Wait()
		localPlayer = Players.LocalPlayer
	end
	local playerScripts = localPlayer:WaitForChild("PlayerScripts")
	local clientModule = playerScripts:WaitForChild(CLIENT_MODULE_NAME)
	if not clientModule:IsA("ModuleScript") then
		return
	end
	local ok, client = pcall(function()
		local requireAny = require :: any
		return requireAny(clientModule)
	end)
	if not ok or type(client) ~= "table" then
		return
	end
	_state.logger:info("Waiting for Client controllers to load...")
	while true do
		local allLoaded = true
		for _, name in ipairs(CONTROLLER_NAMES) do
			if client[name] == nil then
				allLoaded = false
				break
			end
		end
		if allLoaded then
			break
		end
		RunService.Heartbeat:Wait()
	end
	_state.logger:info("Client controllers loaded.")
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
		_handleTeleportQueue(shouldEnable)
	end
end

function Client.setSilent(self: BlossomClient, isSilent: boolean): ()
	if _state.isSilent == isSilent then
		return
	end
	_state.isSilent = isSilent
	-- If teleport queue is active, we need to update the script string
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
	_state.logger:info("Client initializing...")
	_waitForClientLoaded()

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
client.IsSilent = _state.isSilent

_state.logger = client.Logger

return client:start()
