local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("RunService")
local v_u_3 = require(v1.Modules.Finisher)
local v_u_4 = setmetatable({}, v_u_3)
v_u_4.__index = v_u_4
function v_u_4.new(...)
    local v5 = v_u_3.new(...)
    local v6 = v_u_4
    local v7 = setmetatable(v5, v6)
    v7:_Init()
    return v7
end
function v_u_4.PlayServer(p8)
    local v9 = p8._is_humanoid and p8._subject.RootPart or p8._subject
    v9.Anchored = true
    if p8._is_humanoid then
        local v10 = Instance.new("Animation")
        v10.AnimationId = "rbxassetid://90573604180891"
        local v11, v12 = pcall(p8._subject.LoadAnimation, p8._subject, v10)
        if v11 then
            v12:Play(0)
        end
    end
    wait(1.8)
    v9.Anchored = false
    p8:_Ragdoll()
    p8:_AnchorModel()
end
function v_u_4.PlayClient(p13)
    if p13._is_humanoid then
        local v_u_14 = p13._subject.Parent.Head
        local v_u_15 = v_u_14:Clone()
        v_u_15.CanCollide = false
        v_u_15.CanTouch = false
        v_u_15.CanQuery = false
        v_u_15.Anchored = true
        v_u_15.Parent = v_u_14
        for _, v16 in pairs(v_u_15:GetChildren()) do
            if not v16:IsA("Decal") then
                v16:Destroy()
            end
        end
        for _, v17 in pairs(v_u_14:GetChildren()) do
            if v17:IsA("Decal") then
                v17.LocalTransparencyModifier = 1
            end
        end
        v_u_14.LocalTransparencyModifier = 1
        local v_u_18 = tick()
        local v19 = p13._connections
        local v20 = v_u_2.RenderStepped
        table.insert(v19, v20:Connect(function(_)
            local v21 = (tick() - v_u_18) / 1.8
            local v22 = math.clamp(v21, 0, 1)
            v_u_15.Size = v_u_14.Size * (v22 * 2 + 1)
            v_u_15.CFrame = v_u_14.CFrame * CFrame.new(0, -v_u_14.Size.Y / 2 + v_u_15.Size.Y / 2, 0)
        end))
        p13:CreateSound("rbxassetid://102780719481956", 1, 1, nil, true, 5)
    end
end
function v_u_4._Init(_) end
return v_u_4