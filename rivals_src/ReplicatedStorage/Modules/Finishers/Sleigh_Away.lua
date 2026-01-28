local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = require(v1.Modules.Finisher)
local v_u_3 = setmetatable({}, v_u_2)
v_u_3.__index = v_u_3
function v_u_3.new(...)
    local v4 = v_u_2.new(...)
    local v5 = v_u_3
    local v6 = setmetatable(v4, v5)
    v6:_Init()
    return v6
end
function v_u_3.PlayServer(p7)
    local v8 = p7._is_humanoid and p7._subject.RootPart or p7._subject
    v8.Anchored = true
    if p7._is_humanoid then
        local v9 = Instance.new("Animation")
        v9.AnimationId = "rbxassetid://4769412289"
        local v10, v11 = pcall(p7._subject.LoadAnimation, p7._subject, v9)
        if v10 then
            v11:Play(0)
            v11:AdjustSpeed(0.16666666666666666)
        end
    end
    local v12 = Instance.new("Attachment")
    v12.Parent = v8
    local v13 = p7._destroy_these
    table.insert(v13, v12)
    local v14 = script.Model:Clone()
    v14:PivotTo(CFrame.new(v8.Position) * CFrame.Angles(0, math.random() * 3.141592653589793 * 2, 0))
    v14.Parent = workspace
    local v15 = p7._destroy_these
    table.insert(v15, v14)
    local v16, v17 = pcall(v14.AnimationController.LoadAnimation, v14.AnimationController, v14.Animation)
    if v16 then
        v17:Play(0)
        p7:CreateSound("rbxassetid://70986468462566", 1.5, 1 + 0.1 * math.random(), v14.HumanoidRootPart, true, 5)
        wait(0.3)
        local v18 = {}
        for _, v19 in pairs(p7:_GetObjects(true)) do
            if v19:IsA("BasePart") then
                v18[v19] = v19.CollisionGroup
                v19.CollisionGroup = "Noclip"
            end
        end
        v8.Anchored = false
        p7:_Ragdoll()
        local v20 = Instance.new("AlignPosition")
        v20.RigidityEnabled = true
        v20.ApplyAtCenterOfMass = true
        v20.Attachment1 = v14.Broomm.Attachment
        v20.Attachment0 = v12
        v20.Parent = v14
        local v21 = p7._destroy_these
        table.insert(v21, v20)
        wait(1.9)
        wait(0.75)
        v20:Destroy()
        p7:_AnchorModel()
        for v22, v23 in pairs(v18) do
            v22.CollisionGroup = v23
        end
        if v17.IsPlaying then
            v17.Stopped:Wait()
        end
        v14:Destroy()
        wait(3)
    end
end
function v_u_3._Init(_) end
return v_u_3