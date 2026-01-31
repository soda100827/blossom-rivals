--!strict

--// Services
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

--// Dependencies (require)
local Logger = require("../shared/Logger")
local Maid = require("../../Packages/_Index/soda100827_maid@0.4.0/maid")
local FastSignal = require("../../Packages/_Index/lucasmzreal_fastsignal@10.4.0/fastsignal/Deferred")
local ExecutorUtils = require("../shared/ExecutorUtils")
local ModuleRegistry = require("./ModuleRegistry")

--// Constants
local BUNDLE_URL = "https://raw.githubusercontent.com/soda100827/blossom-rivals/refs/heads/main/build/loader.luau"
local CLIENT_MODULE_NAME = "Client"

--// Types
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
  Started: FastSignal,
  Stopped: FastSignal,
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
local _loggerModule = (Logger :: any) :: LoggerModule
local _initialLogger = _loggerModule.new("Blossom")
local _state: {
  isRunning: boolean,
  shouldTeleportQueue: boolean,
  isSilent: boolean,
  logger: LoggerInstance,
} = {
  isRunning = false,
  shouldTeleportQueue = false,
  isSilent = ExecutorUtils.getGlobal("BlossomSilent") or false,
  logger = _initialLogger,
}
local _signals: { started: FastSignal, stopped: FastSignal } = {
  started = FastSignal.new(),
  stopped = FastSignal.new(),
}
local _modules: { [string]: Module } = {}
local _syn = ExecutorUtils.getGlobal("syn")
local _queueOnTeleport = ExecutorUtils.getGlobal("queue_on_teleport")
  or ExecutorUtils.getGlobal("queueonteleport")
  or (_syn and _syn.queue_on_teleport)
local _clearTeleportQueue = ExecutorUtils.getGlobal("clear_teleport_queue")
  or ExecutorUtils.getGlobal("clearteleportqueue")
  or (_syn and _syn.clear_teleport_queue)
local _rawGetLoadedModules = ExecutorUtils.getGlobal("getloadedmodules")
local _getLoadedModules = _rawGetLoadedModules or function()
  return nil
end
local _hookfunction = ExecutorUtils.getGlobal("hookfunction") or ExecutorUtils.getGlobal("replaceclosure")
local _newcclosure = ExecutorUtils.getGlobal("newcclosure")
local _checkcaller = ExecutorUtils.getGlobal("checkcaller")
local _getgenvFunc = ExecutorUtils.getGlobal("getgenv")

local MODULES: { { name: string, loader: Module } } = ModuleRegistry.getModules()

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

  local hookfunction = _hookfunction
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
  end)
end

local function _checkExecutorSupport(logger: LoggerInstance)
  local missing = {}

  if not _queueOnTeleport then
    missing.queue_on_teleport = true
  end
  if not _clearTeleportQueue then
    missing.clear_teleport_queue = true
  end
  if not _hookfunction then
    missing.hookfunction = true
  end
  if not _newcclosure then
    missing.newcclosure = true
  end
  if not _checkcaller then
    missing.checkcaller = true
  end
  if not _getgenvFunc then
    missing.getgenv = true
  end
  if not _rawGetLoadedModules then
    missing.getloadedmodules = true
  end

  for name in pairs(missing) do
    if logger.warnUnsupported then
      logger:warnUnsupported(name)
    else
      logger:warn(
        string.format("This executor does not support '%s'. Some features may not work as expected.", name)
      )
    end
  end
end

local function _handleTeleportQueue(shouldEnable: boolean)
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
  else
    if _clearTeleportQueue then
      _clearTeleportQueue()
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

  local startTime = os.clock()
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
    if os.clock() - startTime > 15 then
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

  _checkExecutorSupport(_state.logger)
  _disableAnalyticsPipeline(_state.logger)
  local startTime = os.clock()
  _waitForClientLoaded()

  for _, entry in ipairs(MODULES) do
    self:loadModule(entry.name, entry.loader)
  end

  _connect()
  _signals.started:Fire()
  _state.logger:info(string.format("Blossom loaded in %.2f seconds.", os.clock() - startTime))
end

function Client.destroy(self: BlossomClient): ()
  if not _state.isRunning then
    return
  end
  _state.isRunning = false
  _signals.stopped:Fire()
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

local client = (setmetatable({}, Client) :: any) :: BlossomClient
client.Version = "1.0.0"
client.Logger = _initialLogger
client.Modules = _modules
client.Started = _signals.started
client.Stopped = _signals.stopped
client.IsSilent = _state.isSilent

_state.logger = client.Logger

return client:start()
