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
function v_u_4.PlayServer(p8, ...)
    p8:_Ragdoll()
    p8:_AnchorModel(0, false)
    p8:_AnchorModel(6.2)
    local v_u_9 = p8._is_humanoid and p8._subject.RootPart or p8._subject
    local v10 = Instance.new("Attachment")
    v10.Parent = v_u_9
    local v11 = p8._destroy_these
    table.insert(v11, v10)
    local v_u_12 = script.Model:Clone()
    v_u_12.Parent = workspace
    local v13 = p8._destroy_these
    table.insert(v13, v_u_12)
    local v_u_14 = CFrame.Angles(0, math.random() * 3.141592653589793 * 2, 0)
    local v15 = v_u_2.Heartbeat:Connect(function()
        v_u_12:PivotTo(CFrame.new(v_u_9.Position) * v_u_14 - Vector3.new(0, 1.5, 0))
    end)
    local v16 = p8._connections
    table.insert(v16, v15)
    local v17, v18 = pcall(v_u_12.AnimationController.LoadAnimation, v_u_12.AnimationController, v_u_12.Animation)
    if v17 then
        v18:Play(0)
        p8:CreateSound("rbxassetid://8971407111", 1, 1, nil, true, 5)
        wait(1.95)
        p8:CreateSound("rbxassetid://8971407217", 1, 1, nil, true, 5)
        v15:Disconnect()
        v10.WorldCFrame = v_u_12.Hook.Attachment.WorldCFrame
        local v19 = Instance.new("AlignPosition")
        v19.RigidityEnabled = true
        v19.Attachment1 = v_u_12.Hook.Attachment
        v19.Attachment0 = v10
        v19.Parent = v_u_12
        local v20 = p8._destroy_these
        table.insert(v20, v19)
        wait(0.75)
        p8:CreateSound("rbxassetid://8971407314", 1, 1, nil, true, 5)
        wait(0.5)
        v19:Destroy()
        v10:Destroy()
        p8:_AnchorModel()
    end
    v15:Disconnect()
    v_u_12:Destroy()
end
function v_u_4._Init(_) end
return v_u_4