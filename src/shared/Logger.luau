--!strict

--// Services
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

--// Dependencies (require)
local Maid = require("Packages/_Index/soda100827_maid@0.4.0/maid") :: any

--// Constants
local DEFAULT_SOURCE = "System"
local RICHTEXT_CHECK_INTERVAL = 0.5
local RICHTEXT_MAX_EMPTY_CHECKS = 6
local PREFIX_LABEL = "Blossm"
local COLORS = {
  Cyan = "33, 161, 163",
  Green = "0, 255, 0",
  Pink = "255, 102, 153",
  White = "255, 255, 255",
  Yellow = "255, 215, 0",
  Red = "220, 20, 60",
}

--// Types
export type LoggerInstance = {
  source: string,
  info: (self: LoggerInstance, ...unknown) -> (),
  warn: (self: LoggerInstance, ...unknown) -> (),
  error: (self: LoggerInstance, ...unknown) -> (),
  success: (self: LoggerInstance, ...unknown) -> (),
  warnUnsupported: (self: LoggerInstance, name: string) -> (),
}

export type LoggerModule = {
  new: (source: string?) -> LoggerInstance,
  Destroy: () -> (),
}

type LoggerState = {
  lastRichTextCheck: number,
  isRichTextConnected: boolean,
}

--// Private state
local Logger = {}
Logger.__index = Logger

local _maid = Maid.new()
local _state: LoggerState = {
  lastRichTextCheck = 0,
  isRichTextConnected = false,
}
local _emptyChecks = 0
local _signals = {}

--// Private helpers
local function _setRichTextOnLabels()
  pcall(function()
    local devConsole = CoreGui:FindFirstChild("DevConsoleMaster")
    if not devConsole then
      _emptyChecks += 1
      return
    end
    _emptyChecks = 0
    for _, label in ipairs(devConsole:GetDescendants()) do
      if label:IsA("TextLabel") and not label.RichText then
        label.RichText = true
      end
    end
  end)
end

local function _connect()
  if _state.isRichTextConnected then
    return
  end
  _state.isRichTextConnected = true

  local conn = RunService.Heartbeat:Connect(function()
    local now = os.clock()
    if now - _state.lastRichTextCheck < RICHTEXT_CHECK_INTERVAL then
      return
    end
    _state.lastRichTextCheck = now
    _setRichTextOnLabels()
    if _emptyChecks >= RICHTEXT_MAX_EMPTY_CHECKS then
      _maid:DoCleaning()
      _state.isRichTextConnected = false
      _emptyChecks = 0
    end
  end)
  _maid:GiveTask(conn)
end

local function _formatMessage(...): string
  local parts = { ... }
  for i, value in ipairs(parts) do
    parts[i] = tostring(value)
  end
  local message = table.concat(parts, " ")
  return string.format("<font color='rgb(%s)'>[%s]:</font> %s", COLORS.Pink, PREFIX_LABEL, message)
end

--// Public API
function Logger.new(source: string?): LoggerInstance
  _connect()
  local instance = setmetatable({
    source = source or DEFAULT_SOURCE,
  }, Logger)
  return (instance :: any) :: LoggerInstance
end

function Logger.Destroy(): ()
  _maid:DoCleaning()
  _state.isRichTextConnected = false
end

function Logger.info(self: LoggerInstance, ...: unknown): ()
  print(_formatMessage(...))
end

function Logger.success(self: LoggerInstance, ...: unknown): ()
  print(_formatMessage(...))
end

function Logger.warn(self: LoggerInstance, ...: unknown): ()
  warn(_formatMessage(...))
end

function Logger.error(self: LoggerInstance, ...: unknown): ()
  error(_formatMessage(...), 0)
end

function Logger.warnUnsupported(self: LoggerInstance, name: string): ()
  self:warn(
    string.format(
      "This executor does not support '%s'. Some features may not work as expected.",
      name
    )
  )
end

return Logger
