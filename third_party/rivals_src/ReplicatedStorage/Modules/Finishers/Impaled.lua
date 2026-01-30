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
        v_u_2:AddItem(v10, 1.5)
        local v12 = Instance.new("Animation")
        v12.AnimationId = "rbxassetid://135124706498215"
        local v13, v14 = pcall(p8._subject.LoadAnimation, p8._subject, v12)
        if v13 then
            v14:Play(0)
        end
        wait(1.25)
        local v15 = p8._subject.RootPart.Position
        wait(0.25)
        v10:Destroy()
        p8:_Ragdoll()
        p8:_AnchorModel()
        local v16 = p8._subject.RootPart.Position - v15
        local v17 = v16.Magnitude <= 0.01 and Vector3.new(0, 0, 0) or v16.Unit
        p8._subject.RootPart.Velocity = v17 * -256
    end
end
function v_u_4.PlayClient(p18)
    if p18._is_humanoid then
        local v19 = Instance.new("Animation")
        v19.AnimationId = "rbxassetid://135124706498215"
        local v20 = script.Model:Clone()
        v20.PrimaryPart = v20.HumanoidRootPart
        v20:PivotTo(p18._subject.RootPart.CFrame)
        v20.Parent = workspace
        local v21 = p18._destroy_these
        table.insert(v21, v20)
        v_u_2:AddItem(v20, 2.2)
        for _, v22 in pairs(v20:GetDescendants()) do
            if v22:IsA("BasePart") then
                v22.CollisionGroup = "Noclip"
            end
        end
        local v23, v24 = pcall(v20.AnimationController.LoadAnimation, v20.AnimationController, v19)
        if v23 then
            v24:Play(0)
        end
        p18:CreateSound("rbxassetid://77810366972840", 1, 1 + 0.1 * math.random(), nil, true, 5)
        wait(1)
        p18:CreateSound("rbxassetid://76979641579471", 1, 1 + 0.1 * math.random(), nil, true, 5)
    end
end
function v_u_4._Init(_) end
return v_u_4