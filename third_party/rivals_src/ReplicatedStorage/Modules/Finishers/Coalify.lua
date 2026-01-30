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
            v9.Color = Color3.fromRGB(0, 0, 0)
            v9.Material = Enum.Material.Slate
            v9.MaterialVariant = "Slate02gun"
            if v9:IsA("MeshPart") then
                v9.TextureID = ""
            end
        elseif v9:IsA("ParticleEmitter") or (v9:IsA("Beam") or (v9:IsA("Trail") or (v9:IsA("Texture") or (v9:IsA("Decal") or (v9:IsA("Clothing") or v9:IsA("ShirtGraphic")))))) then
            v9:Destroy()
        end
    end
    for _, v10 in pairs(p8:_GetObjects()) do
        if v10:IsA("BasePart") then
            for _, v11 in pairs(script.Particles:GetChildren()) do
                local v12 = v11:Clone()
                v12.Parent = v10
                local v13 = p8._destroy_these
                table.insert(v13, v12)
                task.delay(0.25 * math.random(), v_u_3.PlayParticles, v_u_3, v12)
            end
        end
    end
    p8:CreateSound("rbxassetid://128688584579956", 1.5, 1 + 0.1 * math.random(), nil, true, 5)
end
function v_u_4._Init(_) end
return v_u_4