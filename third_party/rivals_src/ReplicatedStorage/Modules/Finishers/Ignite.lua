local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = require(v1.Modules.Finishers.Ragdoll)
local v_u_3 = setmetatable({}, v_u_2)
v_u_3.__index = v_u_3
function v_u_3.new(...)
    local v4 = v_u_2.new(...)
    local v5 = v_u_3
    local v6 = setmetatable(v4, v5)
    v6:_Init()
    return v6
end
function v_u_3.PlayClient(p7, ...)
    v_u_2.PlayClient(p7, ...)
    for _, v8 in pairs(p7:_GetObjects(true)) do
        if v8:IsA("BasePart") then
            v8.Color = Color3.fromRGB(0, 0, 0)
            v8.Material = Enum.Material.SmoothPlastic
            v8.MaterialVariant = "Scorched"
            if v8:IsA("MeshPart") then
                v8.TextureID = ""
            end
        elseif v8:IsA("ParticleEmitter") or (v8:IsA("Beam") or (v8:IsA("Trail") or (v8:IsA("Texture") or (v8:IsA("Decal") or (v8:IsA("Clothing") or v8:IsA("ShirtGraphic")))))) then
            v8:Destroy()
        end
    end
    for _, v9 in pairs(p7:_GetObjects()) do
        if v9:IsA("BasePart") then
            for _, v10 in pairs(script.Particles:GetChildren()) do
                local v11 = v10:Clone()
                v11.Parent = v9
                local v12 = p7._destroy_these
                table.insert(v12, v11)
            end
        end
    end
    p7:CreateSound("rbxassetid://130652232992636", 1, 1 + 0.1 * math.random(), nil, true, 5)
    p7:CreateSound("rbxassetid://99039883606432", 1, 1, nil, true)
end
function v_u_3._Init(_) end
return v_u_3