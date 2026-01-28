local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = require(v1.Modules.Finisher)
local v_u_3 = require(v1.Modules.Utility)
local v_u_4 = {
    "rbxassetid://1848267914",
    "rbxassetid://1848267930",
    "rbxassetid://9038367984",
    "rbxassetid://9042144091",
    "rbxassetid://9038367978"
}
local v_u_5 = setmetatable({}, v_u_2)
v_u_5.__index = v_u_5
function v_u_5.new(...)
    local v6 = v_u_2.new(...)
    local v7 = v_u_5
    local v8 = setmetatable(v6, v7)
    v8:_Init()
    return v8
end
function v_u_5.PlayServer(p_u_9)
    local v_u_10 = Instance.new("BodyVelocity")
    v_u_10.MaxForce = Vector3.new(10000, 10000, 10000)
    v_u_10.Velocity = Vector3.new(0, 4, 0)
    v_u_10.Parent = p_u_9._is_humanoid and p_u_9._subject.RootPart or p_u_9._subject
    local v11 = p_u_9._destroy_these
    table.insert(v11, v_u_10)
    local v_u_12 = Instance.new("BodyAngularVelocity")
    v_u_12.MaxTorque = Vector3.new(10000, 10000, 10000)
    local v13 = math.random() - 0.5
    v_u_12.AngularVelocity = Vector3.new(0, 2, 0) * math.sign(v13)
    v_u_12.Parent = p_u_9._is_humanoid and p_u_9._subject.RootPart or p_u_9._subject
    local v14 = p_u_9._destroy_these
    table.insert(v14, v_u_12)
    p_u_9:_InternalThread(task.delay, 3, function()
        v_u_10.Velocity = Vector3.new(0, 0, 0)
        wait(3)
        v_u_10:Destroy()
        v_u_12:Destroy()
        p_u_9:_AnchorModel()
        p_u_9:_Ragdoll()
    end)
end
function v_u_5.PlayClient(p15)
    for _, v16 in pairs(p15:_GetObjects(true)) do
        if v16:IsA("BasePart") and v16.Transparency < 0.99 then
            v16.Color = Color3.fromRGB(255, 255, 255)
            v16.Material = Enum.Material.SmoothPlastic
            v16.MaterialVariant = ""
            v16.Reflectance = 0.5
            for _, v17 in pairs(script.Texture:GetChildren()) do
                v17:Clone().Parent = v16
            end
            if v16:IsA("MeshPart") then
                v16.TextureID = ""
            end
        elseif v16:IsA("ParticleEmitter") or (v16:IsA("Beam") or (v16:IsA("Trail") or (v16:IsA("Texture") or (v16:IsA("Decal") or (v16:IsA("Clothing") or v16:IsA("ShirtGraphic")))))) then
            v16:Destroy()
        end
    end
    local v_u_18 = script.Particles.Enabled:Clone()
    v_u_18.Parent = p15._is_humanoid and p15._subject.RootPart or p15._subject
    local v19 = script.Particles.Emit:Clone()
    v19.Parent = p15._is_humanoid and p15._subject.RootPart or p15._subject
    v_u_3:PlayParticles(v19)
    if p15._is_humanoid then
        local v20 = Instance.new("Animation")
        v20.AnimationId = "rbxassetid://109647828518093"
        local v21, v22 = pcall(p15._subject.LoadAnimation, p15._subject, v20)
        if v21 then
            v22:Play(0)
            v22:AdjustSpeed(0.75)
        end
    end
    p15:_InternalThread(task.delay, 6, function()
        for _, v23 in pairs(v_u_18:GetDescendants()) do
            if v23:IsA("ParticleEmitter") or v23:IsA("Light") then
                v23.Enabled = false
            end
        end
    end)
    p15:CreateSound(p15:_GetMusicID(), 1, 1, nil, true, 5)
end
function v_u_5._GetMusicID(p24)
    return v_u_4[Random.new(p24._serial and p24._serial.Seed or p24._seed):NextInteger(1, #v_u_4)]
end
function v_u_5._Init(_) end
return v_u_5