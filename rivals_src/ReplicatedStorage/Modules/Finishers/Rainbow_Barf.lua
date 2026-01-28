local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("RunService")
local v_u_3 = require(v1.Modules.BetterDebris)
local v_u_4 = require(v1.Modules.Finishers.Ragdoll)
local v_u_5 = setmetatable({}, v_u_4)
v_u_5.__index = v_u_5
function v_u_5.new(...)
    local v6 = v_u_4.new(...)
    local v7 = v_u_5
    local v8 = setmetatable(v6, v7)
    v8:_Init()
    return v8
end
function v_u_5.PlayServer(p9, ...)
    v_u_4.PlayServer(p9, ...)
    local v10 = p9._is_humanoid and p9._subject.RootPart or p9._subject
    local v11 = Instance.new("BodyVelocity")
    v11.MaxForce = Vector3.new(1000000, 1000000, 1000000)
    v11.Velocity = (CFrame.new(Vector3.new(0, 0, 0), Vector3.new(0, 1, 0)) * CFrame.Angles(0, 0, math.random() * 3.141592653589793 * 2) * CFrame.Angles(0, 0.7853981633974483 * (math.random() - 0.5), 0)).LookVector * 100
    v11.Parent = v10
    v_u_3:AddItem(v11, 0.25)
end
function v_u_5.PlayClient(p12, ...)
    v_u_4.PlayClient(p12, ...)
    local v13 = p12._is_humanoid and p12._subject.RootPart or p12._subject
    local v_u_14 = p12._is_humanoid and p12._subject.Parent.Head or p12._subject
    local v_u_15 = script.Particles:Clone()
    v_u_15.CollisionGroup = "IgnorePlayers"
    v_u_15.CFrame = CFrame.new(v13.Position) * CFrame.Angles(-1.5707963267948966, 0, 0) - Vector3.new(0, 3, 0)
    v_u_15.Parent = workspace
    local v16 = p12._destroy_these
    table.insert(v16, v_u_15)
    local v_u_17 = nil
    local v_u_18 = 0
    local v_u_19 = tick()
    local v27 = v_u_2.RenderStepped:Connect(function(p20)
        v_u_18 = v_u_18 + p20
        v_u_15.Finish.Puddle.Size = NumberSequence.new(v_u_18 * 5 + 1)
        if v_u_17 then
            local v21 = tick() - v_u_19 - 0.5
            local v22 = v_u_17.Position
            local v23 = (v_u_15.Finish.WorldPosition - v_u_17.Position).Unit
            local v24 = v21 * 64
            local v25 = (v_u_15.Finish.WorldPosition - v_u_17.Position).Magnitude
            local v26 = v22 + v23 * math.clamp(v24, 0, v25)
            v_u_15.Start.WorldCFrame = CFrame.new(v26) * v_u_17.Rotation
        else
            v_u_15.Start.WorldCFrame = v_u_14.CFrame
        end
    end)
    local v28 = p12._connections
    table.insert(v28, v27)
    p12:CreateSound("rbxassetid://93843878451088", 1.5, 1, nil, true, 5)
    p12:CreateSound("rbxassetid://108905869931161", 2, 1, nil, true, 5)
    wait(0.5)
    v_u_17 = v_u_14.CFrame
    wait((v_u_17.Position - v_u_15.Finish.WorldPosition).Magnitude / 64)
    v27:Disconnect()
    for _, v29 in pairs(v_u_15:GetDescendants()) do
        if v29:IsA("ParticleEmitter") or v29:IsA("Beam") then
            v29.Enabled = v29.Name == "Puddle"
        end
    end
    wait(2)
    v_u_15.Finish.Puddle.Enabled = false
    wait(3)
end
function v_u_5._Init(_) end
return v_u_5