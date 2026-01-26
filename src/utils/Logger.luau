--!strict

--// Constants
local DEFAULT_SOURCE = "System"

--// Types
export type LoggerInstance = {
	source: string,
	info: (self: LoggerInstance, ...unknown) -> (),
	warn: (self: LoggerInstance, ...unknown) -> (),
	error: (self: LoggerInstance, ...unknown) -> (),
}

export type LoggerModule = {
	new: (source: string?) -> LoggerInstance,
}

--// Private state
local Logger = {}
Logger.__index = Logger

--// Private helpers
local function formatMessage(level: string, source: string, ...): string
	local parts = { ... }
	for i, value in ipairs(parts) do
		parts[i] = tostring(value)
	end
	local message = table.concat(parts, " ")
	return string.format("[%s][%s] %s", level, source, message)
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

function Logger.warn(self: LoggerInstance, ...: unknown): ()
	warn(formatMessage("WARN", self.source, ...))
end

function Logger.error(self: LoggerInstance, ...: unknown): ()
	error(formatMessage("ERROR", self.source, ...), 0)
end

return Logger
