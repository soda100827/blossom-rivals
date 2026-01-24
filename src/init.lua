local Logger = require(script.Parent.Core.Logger)
local EventManager = require(script.Parent.Core.EventManager)

local Client = {
    Logger = Logger.new("Core"),
    Events = EventManager.new(),
    Modules = {},
    IsRunning = false
}

function Client:LoadModule(name, modulePath)
    local success, result = pcall(function()
        return require(modulePath)
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
    
    -- Load Features
    -- In a real scenario, you might iterate over a folder
    self:LoadModule("Movement", script.Parent.Features.Movement)
    self:LoadModule("Visuals", script.Parent.Features.Visuals)
    self:LoadModule("UI", script.Parent.UI.Main)
    
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

return Client
