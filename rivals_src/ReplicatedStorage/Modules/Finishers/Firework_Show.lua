local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("RunService")
local v_u_3 = require(v1.Modules.Finishers.Ragdoll)
local v_u_4 = require(v1.Modules.Utility)
local v_u_5 = setmetatable({}, v_u_3)
v_u_5.__index = v_u_5
function v_u_5.new(...)
    local v6 = v_u_3.new(...)
    local v7 = v_u_5
    local v8 = setmetatable(v6, v7)
    v8:_Init()
    return v8
end
function v_u_5.PlayServer(p9)
    v_u_3.PlayServer(p9)
    if p9._is_humanoid then
        p9:_AnchorModel(0, false)
        local v10 = p9._subject.RootPart
        local v11 = Instance.new("BodyVelocity")
        v11.MaxForce = Vector3.new(100000, 100000, 100000)
        v11.Velocity = Vector3.new(0, 64, 0)
        v11.Parent = v10
        local v12 = p9._destroy_these
        table.insert(v12, v11)
        wait(0.5)
        local v13 = tick()
        while tick() < v13 + 0.75 do
            local v14 = (tick() - v13) / 0.75
            local v15 = math.clamp(v14, 0, 1)
            v11.Velocity = (CFrame.new(Vector3.new(0, 0, 0), Vector3.new(0, 1, 0)) * CFrame.Angles(6.283185307179586 * v15, 0, 0)).LookVector * 64
            v_u_2.Heartbeat:Wait()
        end
        v11.Velocity = Vector3.new(0, 64, 0)
        wait(1)
        v11:Destroy()
        local v16 = math.random() - 0.5
        local v17 = math.random() - 0.5
        v10.Velocity = Vector3.new(0, 64, 0) + Vector3.new(v16, 0, v17) * 64 * 0.1
        p9:_AnchorModel()
    end
end
function v_u_5.PlayClient(p18)
    v_u_3.PlayClient(p18)
    if p18._is_humanoid then
        local v19 = p18._subject.RootPart
        local v20 = {}
        for _, v21 in pairs(script.Trail:GetChildren()) do
            local v22 = v21:Clone()
            v22.Parent = v19
            local v23 = p18._destroy_these
            table.insert(v23, v22)
            table.insert(v20, v22)
        end
        p18:CreateSound("rbxassetid://108099224793848", 1.25, 1 + 0.1 * math.random(), nil, true, 5)
        wait(2.25)
        for _, v24 in pairs(v20) do
            if v24:IsA("ParticleEmitter") then
                v24.Enabled = false
            end
            for _, v25 in pairs(v24:GetDescendants()) do
                if v25:IsA("ParticleEmitter") then
                    v25.Enabled = false
                end
            end
        end
        local v26 = script.Explode.Attachment:Clone()
        v26.Parent = v19
        v_u_4:PlayParticles(v26)
        local v27 = p18._destroy_these
        table.insert(v27, v26)
        p18:CreateSound("rbxassetid://133816595599115", 1.5, 1 + 0.1 * math.random(), nil, true, 5)
    end
end
function v_u_5._Init(_) end
return v_u_5