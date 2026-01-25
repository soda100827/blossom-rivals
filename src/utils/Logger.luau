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
	return string.format("[%s][%s] %s", level, source, message)
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
