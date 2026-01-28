local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("CollectionService")
game:GetService("Players")
local v3 = require(v1.Modules.ItemLibrary)
local v_u_4 = require(v1.Modules.Utility)
local v_u_5 = {
    [Enum.TextXAlignment.Left] = 0,
    [Enum.TextXAlignment.Right] = 1,
    [Enum.TextYAlignment.Top] = 0,
    [Enum.TextYAlignment.Bottom] = 1
}
local v_u_6 = Color3.fromRGB(0, 0, 0)
local v_u_7 = v3.Statuses.Contraband.Color
local v_u_8 = {}
v_u_8.__index = v_u_8
function v_u_8._new()
    local v9 = v_u_8
    local v10 = setmetatable({}, v9)
    v10._objects = {}
    v10:_Init()
    return v10
end
function v_u_8.Update(p11, p12)
    for v13, v14 in pairs(p11._objects) do
        if v_u_4:IsUIElementVisible(v13) then
            if v14.IsTextLabel then
                local v15 = Vector2.new
                local v16 = v13.AbsoluteSize.X
                local v17 = math.min(5, v16)
                local v18 = v13.AbsoluteSize.Y
                local v19 = v15(v17, (math.min(5, v18))) * Vector2.new(math.random() - 0.5, math.random() - 0.5)
                local v20 = v19.X
                local v21 = math.abs(v20)
                local v22 = v19.Y
                local v23 = math.abs(v22)
                local v24 = math.min(v21, v23)
                local v25 = v14.OriginalPosition
                local v26 = UDim2.new
                local v27 = v19.X
                local v28 = math.abs(v27)
                local v29 = math.min(v28, v24)
                local v30 = v19.X
                local v31 = v29 * math.sign(v30)
                local v32 = v19.Y
                local v33 = math.abs(v32)
                local v34 = math.min(v33, v24)
                local v35 = v19.Y
                v13.Position = v25 + v26(0, v31, 0, v34 * math.sign(v35))
            end
            if tick() > v14.Cooldown then
                v14.Cooldown = tick() + 0.1
                local v36 = v14.IsTextLabel and v13.TextBounds.X or v13.AbsoluteSize.X
                local v37 = v14.IsTextLabel and v13.TextBounds.Y or v13.AbsoluteSize.Y
                local v38 = v14.IsTextLabel and (v_u_5[v13.TextXAlignment] or 0.5) or 0.5
                local v39 = v14.IsTextLabel and (v_u_5[v13.TextYAlignment] or 0.5) or 0.5
                local v40 = (0.375 + 0.25 * math.random()) * 0.375
                local v41 = (0.375 + 0.25 * math.random()) * 0.375
                local v42 = Instance.new("Frame")
                v42.BorderSizePixel = 0
                v42.AnchorPoint = Vector2.new(0.5, 0.5)
                v42.BackgroundColor3 = v_u_7:Lerp(v_u_6, math.random())
                v42.Size = UDim2.new(v40, 0, v41, 0)
                v42.Position = UDim2.new(v38, (math.random() - v38) * v36, v39, (math.random() - v39) * v37)
                local v43 = Instance.new("UIAspectRatioConstraint")
                v43.AspectRatio = 1 + 2 * math.random()
                v43.Parent = v42
                v42.Parent = v13
                local v44 = v14.Particles
                local v45 = {
                    ["Particle"] = v42,
                    ["Age"] = 0,
                    ["OriginalPosition"] = v42.Position
                }
                local v46 = math.random() - 0.5
                v45.Direction = math.sign(v46)
                table.insert(v44, v45)
            end
            for v47 = #v14.Particles, 1, -1 do
                local v48 = v14.Particles[v47]
                v48.Age = v48.Age + p12
                if v48.Age >= 0.5 then
                    v48.Particle:Destroy()
                    table.remove(v14.Particles, v47)
                else
                    v48.Particle.Position = v48.OriginalPosition + UDim2.new(0, v48.Age * 10 * v48.Direction, 0, 0)
                    if not v14.IsTextLabel then
                        local v49 = v48.Particle.AbsoluteSize * Vector2.new(math.random() - 0.5, math.random() - 0.5) * 0.25
                        local v50 = v48.Particle
                        v50.Position = v50.Position + UDim2.new(0, v49.X, 0, v49.Y)
                    end
                end
            end
        end
    end
end
function v_u_8._ObjectRemoved(p51, p52)
    if p51._objects[p52] then
        for _, v53 in pairs(p51._objects[p52].Particles) do
            v53.Particle:Destroy()
        end
        p51._objects[p52] = nil
    end
end
function v_u_8._ObjectAdded(p54, p55)
    p54:_ObjectRemoved(p55)
    p54._objects[p55] = {
        ["IsTextLabel"] = p55:IsA("TextLabel"),
        ["OriginalPosition"] = p55.Position,
        ["Cooldown"] = 0,
        ["Particles"] = {}
    }
end
function v_u_8._Init(p_u_56)
    v_u_2:GetInstanceRemovedSignal("UIGlitchEffect"):Connect(function(p57)
        p_u_56:_ObjectRemoved(p57)
    end)
    v_u_2:GetInstanceAddedSignal("UIGlitchEffect"):Connect(function(p58)
        p_u_56:_ObjectAdded(p58)
    end)
    for _, v59 in pairs(v_u_2:GetTagged("UIGlitchEffect")) do
        task.spawn(p_u_56._ObjectAdded, p_u_56, v59)
    end
end
return v_u_8._new()