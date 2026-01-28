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
    local v9 = p8._subject.RootPart
    local v10 = Instance.new("BodyVelocity")
    v10.Velocity = Vector3.new(0, 0, 0)
    v10.MaxForce = Vector3.new(10000, 0, 10000)
    v10.Parent = v9
    local v11 = p8._destroy_these
    table.insert(v11, v10)
    v_u_2:AddItem(v10, 1.05)
    local v12 = Instance.new("BodyGyro")
    v12.CFrame = CFrame.new(Vector3.new(0, 0, 0), v9.CFrame.LookVector * Vector3.new(1, 0, 1))
    v12.MaxTorque = Vector3.new(100000, 100000, 100000)
    v12.Parent = v9
    local v13 = p8._destroy_these
    table.insert(v13, v12)
    v_u_2:AddItem(v12, 1.05)
    wait(1.05)
    p8:_Ragdoll()
    p8:_AnchorModel()
end
function v_u_4.PlayClient(p14)
    if p14._is_humanoid then
        local v15 = Instance.new("Animation")
        v15.AnimationId = "rbxassetid://85156698673400"
        local v16, v17 = pcall(p14._subject.LoadAnimation, p14._subject, v15)
        if v16 then
            v17:Play(0)
        end
    end
end
function v_u_4._Init(_) end
return v_u_4