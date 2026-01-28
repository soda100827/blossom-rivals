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
function v_u_4.PlayServer(p8)
    p8:_AnchorModel(0)
end
function v_u_4.PlayClient(p9, ...)
    for _, v10 in pairs(p9:_GetObjects(true)) do
        if v10:IsA("BasePart") then
            v10.Color = Color3.fromRGB(255, 170, 24)
            v10.Material = Enum.Material.Glass
            v10.MaterialVariant = ""
            v10.Reflectance = 0.4
            if v10:IsA("MeshPart") then
                v10.TextureID = ""
            end
        elseif v10:IsA("ParticleEmitter") or (v10:IsA("Beam") or (v10:IsA("Trail") or (v10:IsA("Texture") or (v10:IsA("Decal") or (v10:IsA("Clothing") or v10:IsA("ShirtGraphic")))))) then
            v10:Destroy()
        end
    end
    local v11 = script.Particles.Enabled:Clone()
    v11.Parent = p9._is_humanoid and p9._subject.RootPart or p9._subject
    local v12 = p9._destroy_these
    table.insert(v12, v11)
    local v13 = {}
    for _, v14 in pairs(script.Particles.Emit:GetChildren()) do
        local v15 = v14:Clone()
        v15.Parent = p9._is_humanoid and p9._subject.RootPart or p9._subject
        local v16 = p9._destroy_these
        table.insert(v16, v15)
        table.insert(v13, v15)
    end
    v_u_3:PlayParticles(v13)
    p9:CreateSound("rbxassetid://120916927127339", 1.5, 1 + 0.1 * math.random(), nil, true, 10)
end
function v_u_4._Init(_) end
return v_u_4