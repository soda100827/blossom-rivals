--!strict
local Logger = {}
Logger.__index = Logger

function Logger.new(source: string)
	return setmetatable({
		Source = source or "System",
	}, Logger)
end

local function formatMessage(level: string, source: string, ...)
	local parts = { ... }
	for i, value in ipairs(parts) do
		parts[i] = tostring(value)
	end
	local message = table.concat(parts, " ")
	local timestamp = os.date("%H:%M:%S")
	return string.format("[%s][%s][%s] %s", timestamp, source, level, message)
end

function Logger:Info(...)
	print(formatMessage("INFO", self.Source, ...))
end

function Logger:Warn(...)
	warn(formatMessage("WARN", self.Source, ...))
end

function Logger:Error(...)
	error(formatMessage("ERROR", self.Source, ...), 0)
end

return Logger
