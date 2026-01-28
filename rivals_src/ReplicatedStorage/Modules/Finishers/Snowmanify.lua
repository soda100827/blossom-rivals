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
    local v9 = p8._is_humanoid
    if v9 then
        v9 = p8._subject.Parent:FindFirstChild("Head")
    end
    if v9 then
        for _, v10 in pairs(p8:_GetObjects(true)) do
            if v10:IsA("BasePart") then
                v10.Color = Color3.fromRGB(248, 248, 248)
                v10.Material = Enum.Material.SmoothPlastic
                v10.MaterialVariant = ""
                if v10:IsA("MeshPart") then
                    v10.TextureID = ""
                end
            elseif v10:IsA("ParticleEmitter") or (v10:IsA("Beam") or (v10:IsA("Trail") or (v10:IsA("Texture") or (v10:IsA("Decal") or (v10:IsA("Clothing") or v10:IsA("ShirtGraphic")))))) then
                v10:Destroy()
            end
        end
        local v11 = script.Model:Clone()
        v11.PrimaryPart = v11.Primary
        v11:PivotTo(v9.CFrame)
        v11.Parent = v9
        local v12 = p8._destroy_these
        table.insert(v12, v11)
        local v13 = Instance.new("WeldConstraint")
        v13.Part0 = v9
        v13.Part1 = v11.Primary
        v13.Parent = v11
        local v14 = script.Particles.Attachment:Clone()
        v14.Parent = v9
        local v15 = p8._destroy_these
        table.insert(v15, v14)
        v_u_3:PlayParticles(v14)
        p8:CreateSound("rbxassetid://103150011493508", 1.5, 1 + 0.1 * math.random(), nil, true, 5)
    end
end
function v_u_4._Init(_) end
return v_u_4