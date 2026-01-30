local v1 = game:GetService("ReplicatedStorage")
game:GetService("RunService")
local v_u_2 = require(v1.Modules.BetterDebris)
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
function v_u_5.PlayServer(p9, ...)
    v_u_3.PlayServer(p9, ...)
    local v10 = p9._is_humanoid and p9._subject.RootPart or p9._subject
    local v11 = Instance.new("BodyAngularVelocity")
    v11.MaxTorque = Vector3.new(100000, 100000, 100000)
    v11.AngularVelocity = Random.new():NextUnitVector() * 10
    v11.Parent = v10
    v_u_2:AddItem(v11, 3)
    local v12 = nil
    for _, v13 in pairs(p9:_GetObjects()) do
        if v13:IsA("BasePart") then
            local v14 = Instance.new("BodyVelocity")
            v14.MaxForce = Vector3.new(1, 1, 1) * (v13 == v10 and 10000 or 500)
            v14.Velocity = Vector3.new(0, 2, 0)
            v14.Parent = v13
            v_u_2:AddItem(v14, 3)
            if v13 == v10 then
                v12 = v14
            end
        end
    end
    wait(0.25)
    if v12 then
        v12.Velocity = v12.Velocity * 150
    end
end
function v_u_5.PlayClient(p_u_15, ...)
    v_u_3.PlayClient(p_u_15, ...)
    local v16 = p_u_15._is_humanoid and p_u_15._subject.RootPart or p_u_15._subject
    local v_u_17 = script.Particles:Clone()
    v_u_17.CFrame = CFrame.new(v16.Position) * CFrame.Angles(0, 0, 1.5707963267948966) - Vector3.new(0, 2, 0)
    v_u_17.Parent = v16
    local v18 = p_u_15._destroy_these
    table.insert(v18, v_u_17)
    p_u_15:CreateSound("rbxassetid://116502031018076", 1.5, 0.95 + 0.1 * math.random(), v_u_17, true, 10)
    p_u_15:_InternalThread(task.delay, 0.1, p_u_15.CreateSound, p_u_15, "rbxassetid://76502718325596", 1.5, 0.95 + 0.1 * math.random(), v_u_17, true, 10)
    local v_u_19 = {}
    v_u_4:RenderstepForLoop(0, 100, 4, function(p20)
        local v21 = 1 - (p20 / 100) ^ 3
        for _, v22 in pairs(v_u_17:GetDescendants()) do
            if v22:IsA("ParticleEmitter") or v22:IsA("Beam") then
                v_u_19[v22] = v_u_19[v22] or v22.Width1
                v22.Width1 = v_u_19[v22] * v21
            elseif v22:IsA("Light") then
                v_u_19[v22] = v_u_19[v22] or v22.Brightness
                v22.Brightness = v_u_19[v22] * v21
            end
        end
    end)
    for _, v23 in pairs(v_u_17:GetDescendants()) do
        if v23:IsA("ParticleEmitter") or v23:IsA("Beam") then
            v23.Enabled = false
        end
    end
    v_u_4:RenderstepForLoop(0, 100, 4, function(p24)
        local v25 = 1 - (1 - p24 / 100) ^ 3
        for _, v26 in pairs(p_u_15:_GetObjects(true)) do
            if v26:IsA("BasePart") then
                v26.LocalTransparencyModifier = v25
            end
        end
    end)
    for _, v27 in pairs(p_u_15:_GetObjects(true)) do
        if v27:IsA("BasePart") and v27 ~= v16 then
            v27:Destroy()
        end
    end
    v_u_17:Destroy()
end
function v_u_5._Init(_) end
return v_u_5