--// Services
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

--// Constants
local DEFAULT_SOURCE = "System"
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
}

--// Private state
local Logger = {}
Logger.__index = Logger

--// Private helpers
local function _enableRichText()
	-- Continuously ensure RichText is enabled on DevConsole
	RunService.Heartbeat:Connect(function()
		pcall(function()
			local devConsole = CoreGui:FindFirstChild("DevConsoleMaster")
			if devConsole then
				for _, label in pairs(devConsole:GetDescendants()) do
					if label:IsA("TextLabel") and not label.RichText then
						label.RichText = true
					end
				end
			end
		end)
	end)
end

local function formatMessage(level: string, source: string, ...): string
	local parts = { ... }
	for i, value in ipairs(parts) do
		parts[i] = tostring(value)
	end
	local message = table.concat(parts, " ")

	local levelColor = COLORS.White
	if level == "INFO" then
		levelColor = COLORS.White
	elseif level == "SUCCESS" then
		levelColor = COLORS.Green
	elseif level == "WARN" then
		levelColor = COLORS.Yellow
	elseif level == "ERROR" then
		levelColor = COLORS.Red
	end

	return string.format(
		"<stroke color='#000000' thickness='1'><font color='rgb(%s)'><b>[%s]</b></font></stroke> <stroke color='#000000' thickness='1'><font color='rgb(%s)'><b>[%s]</b></font></stroke> <font color='rgb(%s)'>%s</font>",
		levelColor,
		level,
		COLORS.Pink,
		source,
		COLORS.White,
		message
	)
end

--// Public API
function Logger.new(source: string?): LoggerInstance
	local instance = setmetatable({
		source = source or DEFAULT_SOURCE,
	}, Logger)
	return (instance :: any) :: LoggerInstance
end

function Logger.info(self: LoggerInstance, ...: unknown): ()
	print(formatMessage("INFO", self.source, ...))
end

function Logger.success(self: LoggerInstance, ...: unknown): ()
	print(formatMessage("SUCCESS", self.source, ...))
end

function Logger.warn(self: LoggerInstance, ...: unknown): ()
	warn(formatMessage("WARN", self.source, ...))
end

function Logger.error(self: LoggerInstance, ...: unknown): ()
	-- Error usually stops execution or prints stack trace, we format the message part
	error(formatMessage("ERROR", self.source, ...), 0)
end

-- Initialize the RichText enabler
task.spawn(_enableRichText)

return Logger
