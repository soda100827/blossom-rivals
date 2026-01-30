local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = require(v1.Modules.Finishers.Ragdoll)
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
function v_u_4.PlayClient(p8, ...)
    v_u_2.PlayClient(p8, ...)
    for _, v9 in pairs(p8:_GetObjects(true)) do
        if v9:IsA("BasePart") then
            v9.Color = Color3.fromRGB(255, 232, 128)
            v9.Material = Enum.Material.Glass
            v9.MaterialVariant = ""
            v9.Reflectance = 0.4
            if v9:IsA("MeshPart") then
                v9.TextureID = ""
            end
        elseif v9:IsA("ParticleEmitter") or (v9:IsA("Beam") or (v9:IsA("Trail") or (v9:IsA("Texture") or (v9:IsA("Decal") or (v9:IsA("Clothing") or v9:IsA("ShirtGraphic")))))) then
            v9:Destroy()
        end
    end
    local v10 = {}
    for _, v11 in pairs(script.Particles:GetChildren()) do
        local v12 = v11:Clone()
        v12.Parent = p8._is_humanoid and p8._subject.RootPart or p8._subject
        local v13 = p8._destroy_these
        table.insert(v13, v12)
        table.insert(v10, v12)
        if v11:IsA("ParticleEmitter") then
            v_u_3:ScaleParticleEmitter(v11, 0.5)
        end
        for _, v14 in pairs(v12:GetDescendants()) do
            if v14:IsA("ParticleEmitter") then
                v_u_3:ScaleParticleEmitter(v14, 0.5)
            end
        end
    end
    v_u_3:PlayParticles(v10)
    p8:CreateSound("rbxassetid://18179281854", 2, 0.9 + 0.2 * math.random(), nil, true, 10)
end
function v_u_4._Init(_) end
return v_u_4