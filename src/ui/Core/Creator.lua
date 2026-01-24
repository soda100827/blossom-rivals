-- Fusion-like instance creator
local Creator = {}

-- Helper to apply properties
local function ApplyProperties(instance, props)
    for k, v in pairs(props) do
        if k == "Parent" then
            -- Parent is handled last usually, but Roblox handles it fine.
            -- We might want to defer parenting if optimizing, but for UI it's fine.
            v.Parent = instance -- Handle 'Parent' key specifically if value is an Instance
        elseif typeof(k) == "number" and typeof(v) == "Instance" then
            -- Initializing with children array: { Child1, Child2 }
            v.Parent = instance
        elseif k == "Events" and typeof(v) == "table" then
            for eventName, callback in pairs(v) do
                instance[eventName]:Connect(callback)
            end
        else
            instance[k] = v
        end
    end
end

function Creator.New(className, props)
    local instance = Instance.new(className)
    if props then
        ApplyProperties(instance, props)
    end
    return instance
end

function Creator.AddStroke(parent, color, thickness)
    return Creator.New("UIStroke", {
        Parent = parent,
        Color = color or Color3.new(1, 1, 1),
        Thickness = thickness or 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    })
end

function Creator.AddCorner(parent, radius)
    return Creator.New("UICorner", {
        Parent = parent,
        CornerRadius = UDim.new(0, radius or 6)
    })
end

return Creator
