local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("RunService")
local v_u_3 = require(v1.Modules.BetterDebris)
local v_u_4 = require(v1.Modules.Finisher)
local v_u_5 = setmetatable({}, v_u_4)
v_u_5.__index = v_u_5
function v_u_5.new(...)
    local v6 = v_u_4.new(...)
    local v7 = v_u_5
    local v8 = setmetatable(v6, v7)
    v8:_Init()
    return v8
end
function v_u_5.PlayServer(p9)
    if p9._is_humanoid then
        local v10 = p9._subject.RootPart
        local v11 = Instance.new("BodyGyro")
        v11.CFrame = CFrame.new(Vector3.new(0, 0, 0), v10.CFrame.LookVector * Vector3.new(1, 0, 1))
        v11.MaxTorque = Vector3.new(100000, 100000, 100000)
        v11.Parent = v10
        local v12 = p9._destroy_these
        table.insert(v12, v11)
        v_u_3:AddItem(v11, 2)
        local v13 = Instance.new("BodyPosition")
        v13.Position = v10.Position
        v13.MaxForce = Vector3.new(1000000, 1000000, 1000000)
        v13.Parent = v10
        local v14 = p9._destroy_these
        table.insert(v14, v11)
        v_u_3:AddItem(v11, 2)
        local v15 = Instance.new("Animation")
        v15.AnimationId = "rbxassetid://118451940351578"
        local v16, v17 = pcall(p9._subject.LoadAnimation, p9._subject, v15)
        if v16 then
            v17:Play(0)
        end
        wait(2)
        v11:Destroy()
        p9:_Ragdoll()
        p9:_AnchorModel()
    end
end
function v_u_5.PlayClient(p18)
    if p18._is_humanoid then
        local v_u_19 = p18._subject.RootPart
        local v20 = Instance.new("Animation")
        v20.AnimationId = "rbxassetid://118451940351578"
        local v_u_21 = script.Model:Clone()
        v_u_21.PrimaryPart = v_u_21.HumanoidRootPart
        v_u_21:PivotTo(p18._subject.RootPart.CFrame)
        v_u_21.Parent = workspace
        local v22 = p18._destroy_these
        table.insert(v22, v_u_21)
        v_u_3:AddItem(v_u_21, 2.4)
        local v23 = v_u_2.RenderStepped:Connect(function()
            v_u_21:PivotTo(v_u_19.CFrame)
        end)
        local v24 = p18._connections
        table.insert(v24, v23)
        for _, v25 in pairs(v_u_21:GetDescendants()) do
            if v25:IsA("BasePart") then
                v25.CollisionGroup = "Noclip"
            end
        end
        local v26, v27 = pcall(v_u_21.AnimationController.LoadAnimation, v_u_21.AnimationController, v20)
        if v26 then
            v27:Play(0)
        end
        p18:CreateSound("rbxassetid://74600054680969", 2, 1 + 0.2 * math.random(), nil, true, 5)
        wait(1.2)
        p18:CreateSound("rbxassetid://133211885821177", 1.5, 1 + 0.2 * math.random(), nil, true, 5)
    end
end
function v_u_5._Init(_) end
return v_u_5