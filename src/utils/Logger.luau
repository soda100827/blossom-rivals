--!strict
local Logger = {}
Logger.__index = Logger

function Logger.new(source: string)
	return setmetatable({
		Source = source or "System",
	}, Logger)
end

function Logger:Info(...)
	print(string.format("[\27[34m%s\27[0m] ", self.Source), ...)
end

function Logger:Warn(...)
	warn(string.format("[%s] ", self.Source), ...)
end

function Logger:Error(...)
	error(string.format("[%s] ", self.Source) .. ..., 0)
end

return Logger
