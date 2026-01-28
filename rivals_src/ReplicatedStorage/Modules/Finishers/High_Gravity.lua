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
    local v10 = Instance.new("BodyVelocity")
    v10.MaxForce = Vector3.new(0, 10000, 0)
    v10.Velocity = Vector3.new(0, -100, 0)
    v10.Parent = p9._is_humanoid and p9._subject.RootPart or p9._subject
    v_u_3:AddItem(v10, 3)
end
function v_u_5.PlayClient(p11, ...)
    v_u_4.PlayClient(p11, ...)
    local v_u_12 = p11._is_humanoid and p11._subject.RootPart or p11._subject
    local v_u_13 = script.Particles:Clone()
    v_u_13.Parent = v_u_12
    local v14 = p11._destroy_these
    table.insert(v14, v_u_13)
    local v15 = v_u_2.RenderStepped:Connect(function()
        v_u_13.CFrame = CFrame.new(v_u_12.Position)
    end)
    local v16 = p11._connections
    table.insert(v16, v15)
    p11:CreateSound("rbxassetid://71853893910123", 2, 1, nil, true, 5)
    wait(3)
    v15:Disconnect()
    for _, v17 in pairs(v_u_13:GetDescendants()) do
        if v17:IsA("ParticleEmitter") or v17:IsA("Beam") then
            v17.Enabled = false
        end
    end
end
function v_u_5._Init(_) end
return v_u_5