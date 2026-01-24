-- Note: Directory imports match Lowercase/Uppercase of actual git structure
-- src/core, src/features, src/ui are lowercase on disk/git
local Logger = BlossomImport("src/core/Logger.lua")
local EventManager = BlossomImport("src/core/EventManager.lua")

local Client = {
    Version = "1.0.0",
    Logger = Logger.new("Core"),
    Events = EventManager.new(),
    Modules = {},
    IsRunning = false
}

function Client:LoadModule(name, path)
    local success, result = pcall(function()
        return BlossomImport(path)
    end)
    
    if success then
        self.Modules[name] = result
        if result.Init then
            result:Init(self)
        end
        self.Logger:Log("Loaded module:", name)
    else
        self.Logger:Warn("Failed to load module:", name, result)
    end
end

function Client:Start()
    if self.IsRunning then return end
    self.IsRunning = true
    
    self.Logger:Log("Starting Blossom Client...")
    
    -- Load Features via Web Import paths (Case Sensitive!)
    self:LoadModule("Movement", "src/features/Movement.lua")
    self:LoadModule("Visuals", "src/features/Visuals.lua")
    self:LoadModule("UI", "src/ui/Interface.lua")
    
    self.Events:Fire("ClientStarted")
end

function Client:Stop()
    self.IsRunning = false
    self.Events:Fire("ClientStopped")
    
    for name, module in pairs(self.Modules) do
        if module.Cleanup then
            module:Cleanup()
        end
    end
    
    self.Logger:Log("Client Stopped.")
end

return Client:Start()
