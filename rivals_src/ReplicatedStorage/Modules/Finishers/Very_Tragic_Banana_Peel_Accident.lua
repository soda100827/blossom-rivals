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
        local v9 = Instance.new("Animation")
        v9.AnimationId = "rbxassetid://89773418199914"
        local v10, v11 = pcall(p8._subject.LoadAnimation, p8._subject, v9)
        if v10 then
            v11:Play(0)
        end
        local v12 = p8._subject.RootPart
        local v13 = Instance.new("BodyVelocity")
        v13.Velocity = Vector3.new(0, 0, 0)
        v13.MaxForce = Vector3.new(10000, 10000, 10000)
        v13.Parent = v12
        local v14 = p8._destroy_these
        table.insert(v14, v13)
        v_u_2:AddItem(v13, 0.3)
        local v15 = Instance.new("BodyGyro")
        v15.CFrame = CFrame.new(Vector3.new(0, 0, 0), v12.CFrame.LookVector * Vector3.new(1, 0, 1))
        v15.MaxTorque = Vector3.new(100000, 100000, 100000)
        v15.Parent = v12
        local v16 = p8._destroy_these
        table.insert(v16, v15)
        v_u_2:AddItem(v15, 0.3)
        wait(0.3)
        v15:Destroy()
        v13:Destroy()
        p8:_Ragdoll()
        p8:_AnchorModel()
    end
end
function v_u_4.PlayClient(p17)
    if p17._is_humanoid then
        local v18 = script.Peel:Clone()
        v18.Parent = workspace
        v18:PivotTo(p17._subject.RootPart.CFrame * CFrame.new(-0.5, -2.5, -1))
        local v19 = p17._destroy_these
        table.insert(v19, v18)
        p17:CreateSound("rbxassetid://8845788882", 2, 1, nil, true, 5)
        wait(0.075)
        v18.PrimaryPart.Anchored = false
        v18.PrimaryPart.Velocity = ((CFrame.new(p17._subject.RootPart.Position, v18.PrimaryPart.Position).LookVector * Vector3.new(1, 0, 1)).Unit + Vector3.new(0, 2, 0)) * 20
        v18.PrimaryPart.RotVelocity = Random.new():NextUnitVector() * (15 + 60 * math.random())
    end
end
function v_u_4._Init(_) end
return v_u_4