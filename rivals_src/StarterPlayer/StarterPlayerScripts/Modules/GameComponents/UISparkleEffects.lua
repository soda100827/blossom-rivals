local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("CollectionService")
local v_u_3 = game:GetService("Players")
local v_u_4 = require(v1.Modules.Utility)
local v_u_5 = v_u_3.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("PrimeSparkle")
local v_u_6 = {
    [Enum.TextXAlignment.Left] = 0,
    [Enum.TextXAlignment.Right] = 1,
    [Enum.TextYAlignment.Top] = 0,
    [Enum.TextYAlignment.Bottom] = 1
}
local v_u_7 = Color3.fromRGB(255, 255, 255)
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
            if tick() > v14.Cooldown then
                v14.Cooldown = tick() + 0.5
                local v15 = v14.IsTextLabel and v13.TextBounds.X or v13.AbsoluteSize.X
                local v16 = v14.IsTextLabel and v13.TextBounds.Y or v13.AbsoluteSize.Y
                local v17 = v14.IsTextLabel and (v_u_6[v13.TextXAlignment] or 0.5) or 0.5
                local v18 = v14.IsTextLabel and (v_u_6[v13.TextYAlignment] or 0.5) or 0.5
                local v19 = (0.375 + 0.25 * math.random()) * 1
                local v20 = v_u_5:Clone()
                v20.ImageTransparency = v14.IsTextLabel and v13.TextTransparency or (v14.IsImageLabel and (v13.ImageTransparency or 0) or 0)
                v20.ImageColor3 = v_u_7
                v20.Size = UDim2.new(v19, 0, v19, 0)
                v20.Position = UDim2.new(v17, (math.random() - v17) * v15, v18, (math.random() - v18) * v16)
                v20.Rotation = math.random() * 360
                v20.Parent = v13
                if v20:IsDescendantOf(v_u_3) then
                    v20:TweenSize(UDim2.new(), "In", "Back", 2, true)
                end
                local v21 = v14.Particles
                table.insert(v21, {
                    ["Particle"] = v20,
                    ["Age"] = 0
                })
            end
            for v22 = #v14.Particles, 1, -1 do
                local v23 = v14.Particles[v22]
                v23.Age = v23.Age + p12
                if v23.Age >= 2 then
                    v23.Particle:Destroy()
                    table.remove(v14.Particles, v22)
                else
                    v23.Particle.Rotation = v23.Age * 180 * 1
                end
            end
        end
    end
end
function v_u_8._ObjectRemoved(p24, p25)
    if p24._objects[p25] then
        for _, v26 in pairs(p24._objects[p25].Particles) do
            v26.Particle:Destroy()
        end
        p24._objects[p25] = nil
    end
end
function v_u_8._ObjectAdded(p27, p28)
    p27:_ObjectRemoved(p28)
    p27._objects[p28] = {
        ["IsTextLabel"] = p28:IsA("TextLabel"),
        ["IsImageLabel"] = p28:IsA("ImageLabel"),
        ["Cooldown"] = 0,
        ["Particles"] = {}
    }
end
function v_u_8._Init(p_u_29)
    v_u_2:GetInstanceRemovedSignal("UISparkleEffect"):Connect(function(p30)
        p_u_29:_ObjectRemoved(p30)
    end)
    v_u_2:GetInstanceAddedSignal("UISparkleEffect"):Connect(function(p31)
        p_u_29:_ObjectAdded(p31)
    end)
    for _, v32 in pairs(v_u_2:GetTagged("UISparkleEffect")) do
        task.spawn(p_u_29._ObjectAdded, p_u_29, v32)
    end
end
return v_u_8._new()