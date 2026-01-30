local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = require(v1.Modules.Finisher)
local v_u_3 = require(v1.Modules.Utility)
local v_u_4 = setmetatable({}, v_u_2)
v_u_4.__index = v_u_4
function v_u_4.new(...)
    local v5 = v_u_2.new(...)
    local v6 = v_u_4
    local v7 = setmetatable(v5, v6)
    v7:_Init()
    return v7
end
function v_u_4.PlayServer(p_u_8)
    p_u_8:_AnchorModel(0)
    p_u_8:_InternalThread(task.delay, 0.25, function()
        p_u_8:_AnchorModel(0, false)
        p_u_8:_AnchorModel()
        p_u_8:_BreakJoints()
        if p_u_8._is_humanoid then
            p_u_8._subject.Parent:BreakJoints()
        end
        for _, v9 in pairs(p_u_8:_GetObjects()) do
            if v9:IsA("BasePart") then
                local v10 = Instance.new("BodyVelocity")
                local v11 = math.random() - 0.5
                local v12 = math.random() - 0.5
                v10.Velocity = Vector3.new(v11, 0, v12).Unit * 40
                v10.MaxForce = Vector3.new(100000, 100000, 100000)
                v10.Parent = v9
                local v13 = p_u_8._destroy_these
                table.insert(v13, v10)
                v9.CFrame = v9.CFrame * CFrame.Angles(math.random() * 3.141592653589793 * 2, math.random() * 3.141592653589793 * 2, math.random() * 3.141592653589793 * 2)
            end
        end
    end)
end
function v_u_4.PlayClient(p14)
    for _, v15 in pairs(p14:_GetObjects(true)) do
        if v15:IsA("BasePart") then
            v15.Color = Color3.fromRGB(0, 0, 0)
            v15.Material = Enum.Material.Glass
            v15.MaterialVariant = ""
            if v15:IsA("MeshPart") then
                v15.TextureID = ""
            end
        elseif v15:IsA("ParticleEmitter") or (v15:IsA("Beam") or v15:IsA("Trail")) then
            v15.Color = ColorSequence.new(Color3.fromRGB(0, 0, 0))
        elseif v15:IsA("Texture") or v15:IsA("Decal") then
            v15.Color3 = Color3.fromRGB(0, 0, 0)
        elseif v15:IsA("Clothing") or v15:IsA("ShirtGraphic") then
            v15:Destroy()
        end
    end
    for _, v16 in pairs(p14:_GetObjects()) do
        if v16:IsA("BasePart") and v16.Transparency <= 0 then
            for _, v17 in pairs(script.Particles:GetChildren()) do
                local v18 = v17:Clone()
                v18.Parent = v16
                local v19 = p14._destroy_these
                table.insert(v19, v18)
            end
        end
    end
    p14:CreateSound("rbxassetid://133729942047865", 1, 1 + 0.2 * math.random(), p14._is_humanoid and p14._subject.RootPart.Position or p14._subject.Position, true, 5)
    wait(0.25)
    local v20 = {}
    for _, v21 in pairs(script.ExplodeParticles:GetChildren()) do
        local v22 = v21:Clone()
        v22.Parent = p14._is_humanoid and p14._subject.RootPart or p14._subject
        local v23 = p14._destroy_these
        table.insert(v23, v22)
        table.insert(v20, v22)
        for _, v24 in pairs(v22:GetDescendants()) do
            if v24:IsA("ParticleEmitter") then
                v_u_3:ScaleParticleEmitter(v24, 3)
            end
        end
    end
    v_u_3:PlayParticles(v20)
    p14:CreateSound("rbxassetid://90611785538933", 1, 0.8 + 0.2 * math.random(), p14._is_humanoid and p14._subject.RootPart.Position or p14._subject.Position, true, 10)
end
function v_u_4._Init(_) end
return v_u_4