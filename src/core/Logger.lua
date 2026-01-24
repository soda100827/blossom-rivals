local Logger = {}
Logger.__index = Logger

function Logger.new(prefix)
    local self = setmetatable({}, Logger)
    -- Prefix is set but user requested standard "[Blossom]:" format mostly.
    -- We can keep the prefix or just hardcode Blossom.
    -- The user said: "[Blossom]: 이렇게만"
    self.Prefix = "Blossom" 
    return self
end

function Logger:Log(...)
    -- Standard print (White/Light Gray usually)
    print(string.format("[%s]:", self.Prefix), ...)
end

function Logger:Warn(...)
    -- Warn (Orange/Yellow)
    warn(string.format("[%s]:", self.Prefix), ...)
end

function Logger:Error(...)
    -- Error (Red)
    -- Using error() stops execution, usually we might want just a red print if available via rconsoleprint 
    -- but for standard roblox output, error() or TestService is used.
    -- Let's stick to error(msg, 0) to avoid stack trace spam if not needed.
    error(string.format("[%s]:", self.Prefix), ..., 0)
end

return Logger
