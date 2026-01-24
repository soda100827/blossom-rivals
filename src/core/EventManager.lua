local EventManager = {}
EventManager.__index = EventManager

function EventManager.new()
    local self = setmetatable({}, EventManager)
    self.Listeners = {}
    return self
end

function EventManager:Connect(eventName, callback)
    if not self.Listeners[eventName] then
        self.Listeners[eventName] = {}
    end
    
    table.insert(self.Listeners[eventName], callback)
    
    return {
        Disconnect = function()
            for i, v in ipairs(self.Listeners[eventName]) do
                if v == callback then
                    table.remove(self.Listeners[eventName], i)
                    break
                end
            end
        end
    }
end

function EventManager:Fire(eventName, ...)
    if not self.Listeners[eventName] then return end
    
    for _, callback in ipairs(self.Listeners[eventName]) do
        task.spawn(callback, ...)
    end
end

return EventManager
