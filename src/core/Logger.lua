local Logger = {}
Logger.__index = Logger

function Logger.new(prefix)
    local self = setmetatable({}, Logger)
    self.Prefix = prefix or "Blossom"
    return self
end

function Logger:Log(...)
    print(string.format("[%s] [INFO]", self.Prefix), ...)
end

function Logger:Warn(...)
    warn(string.format("[%s] [WARN]", self.Prefix), ...)
end

function Logger:Error(...)
    error(string.format("[%s] [ERROR]", self.Prefix), ..., 0)
end

return Logger
