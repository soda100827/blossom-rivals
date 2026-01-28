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
function v_u_4.PlayClient(p9)
    for _, v10 in pairs(p9:_GetObjects(true)) do
        if v10:IsA("BasePart") then
            v10.Color = Color3.fromRGB(163, 162, 165)
            v10.Material = Enum.Material.Slate
            v10.MaterialVariant = ""
            if v10:IsA("MeshPart") then
                v10.TextureID = ""
            end
        elseif v10:IsA("ParticleEmitter") or (v10:IsA("Beam") or (v10:IsA("Trail") or (v10:IsA("Texture") or (v10:IsA("Decal") or (v10:IsA("Clothing") or v10:IsA("ShirtGraphic")))))) then
            v10:Destroy()
        end
    end
    local v11 = {}
    for _, v12 in pairs(script.Particles:GetChildren()) do
        local v13 = v12:Clone()
        v13.Parent = p9._is_humanoid and p9._subject.RootPart or p9._subject
        local v14 = p9._destroy_these
        table.insert(v14, v13)
        table.insert(v11, v13)
    end
    v_u_3:PlayParticles(v11)
    p9:CreateSound("rbxassetid://113140086283098", 1.25, 0.9 + 0.2 * math.random(), nil, true, 10)
    p9:CreateSound("rbxassetid://120323428371971", 1, 0.9 + 0.2 * math.random(), nil, true, 10)
end
function v_u_4._Init(_) end
return v_u_4