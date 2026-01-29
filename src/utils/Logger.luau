--!strict

--// Services
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

--// Dependencies (require)
local Maid = require("Packages/_Index/soda100827_maid@0.4.0/maid") :: any

--// Constants
local DEFAULT_SOURCE = "System"
local RICHTEXT_CHECK_INTERVAL = 0.5
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
local _signals = {}

--// Private helpers
local function _setRichTextOnLabels()
	pcall(function()
		local devConsole = CoreGui:FindFirstChild("DevConsoleMaster")
		if not devConsole then
			return
		end
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
	end)
	_maid:GiveTask(conn)
end

local function _formatMessage(level: string, source: string, ...): string
	local parts = { ... }
	for i, value in ipairs(parts) do
		parts[i] = tostring(value)
	end
	local message = table.concat(parts, " ")

	local levelColor = COLORS.White
	if level == "SUCCESS" then
		levelColor = COLORS.Green
	elseif level == "WARN" then
		levelColor = COLORS.Yellow
	elseif level == "ERROR" then
		levelColor = COLORS.Red
	end

	return string.format(
		"<stroke color='#000000' thickness='1'><font color='rgb(%s)'><b>[%s]:</b></font></stroke> <font color='rgb(%s)'>%s</font>",
		levelColor,
		source,
		COLORS.White,
		message
	)
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
	print(_formatMessage("INFO", self.source, ...))
end

function Logger.success(self: LoggerInstance, ...: unknown): ()
	print(_formatMessage("SUCCESS", self.source, ...))
end

function Logger.warn(self: LoggerInstance, ...: unknown): ()
	warn(_formatMessage("WARN", self.source, ...))
end

function Logger.error(self: LoggerInstance, ...: unknown): ()
	error(_formatMessage("ERROR", self.source, ...), 0)
end

return Logger
