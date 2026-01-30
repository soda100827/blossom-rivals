local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = require(v1.Modules.BetterDebris)
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
    if p8._is_humanoid then
        local v9 = p8._subject.RootPart
        local v10 = Instance.new("BodyGyro")
        v10.CFrame = CFrame.new(Vector3.new(0, 0, 0), v9.CFrame.LookVector * Vector3.new(1, 0, 1))
        v10.MaxTorque = Vector3.new(100000, 100000, 100000)
        v10.Parent = v9
        local v11 = p8._destroy_these
        table.insert(v11, v10)
        v_u_2:AddItem(v10, 0.9)
        local v12 = Instance.new("Animation")
        v12.AnimationId = "rbxassetid://124846559963188"
        local v13, v14 = pcall(p8._subject.LoadAnimation, p8._subject, v12)
        if v13 then
            v14:Play(0)
        end
        wait(0.9)
        v10:Destroy()
        p8:_Ragdoll()
        p8:_AnchorModel()
    end
end
function v_u_4.PlayClient(p15)
    if p15._is_humanoid then
        local v16 = Instance.new("Animation")
        v16.AnimationId = "rbxassetid://124846559963188"
        local v17 = script.Model:Clone()
        v17.PrimaryPart = v17.HumanoidRootPart
        v17:PivotTo(p15._subject.RootPart.CFrame)
        v17.Parent = workspace
        local v18 = p15._destroy_these
        table.insert(v18, v17)
        v_u_2:AddItem(v17, 1.7)
        for _, v19 in pairs(v17:GetDescendants()) do
            if v19:IsA("BasePart") then
                v19.CollisionGroup = "Noclip"
            end
        end
        local v20, v21 = pcall(v17.AnimationController.LoadAnimation, v17.AnimationController, v16)
        if v20 then
            v21:Play(0)
        end
        p15:CreateSound("rbxassetid://71681149544292", 1, 1, nil, true, 5)
        wait(0.6)
        p15:CreateSound("rbxassetid://83125848403089", 3, 1, nil, true, 5)
        wait(0.25)
        p15:CreateSound("rbxassetid://99072929297079", 1.5, 1, nil, true, 5)
    end
end
function v_u_4._Init(_) end
return v_u_4