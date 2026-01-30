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
            v9.Color = Color3.fromRGB(124, 92, 70)
            v9.Material = Enum.Material.Wood
            v9.MaterialVariant = "Wood01a"
            if v9:IsA("MeshPart") then
                v9.TextureID = ""
            end
        elseif v9:IsA("ParticleEmitter") or (v9:IsA("Beam") or (v9:IsA("Trail") or (v9:IsA("Texture") or (v9:IsA("Decal") or (v9:IsA("Clothing") or v9:IsA("ShirtGraphic")))))) then
            v9:Destroy()
        end
    end
    for _, v10 in pairs({ "Head", "HumanoidRootPart" }) do
        local v11 = p8._is_humanoid
        if v11 then
            v11 = p8._subject.Parent:FindFirstChild(v10)
        end
        if v11 then
            local v12 = script[v10]:Clone()
            v12.PrimaryPart = v12.Primary
            v12:PivotTo(v11.CFrame)
            v12.Parent = v11
            local v13 = p8._destroy_these
            table.insert(v13, v12)
            local v14 = Instance.new("WeldConstraint")
            v14.Part0 = v11
            v14.Part1 = v12.Primary
            v14.Parent = v12
        end
    end
    local v15 = {}
    for _, v16 in pairs(script.Particles:GetChildren()) do
        local v17 = v16:Clone()
        v17.Parent = p8._is_humanoid and p8._subject.RootPart or p8._subject
        local v18 = p8._destroy_these
        table.insert(v18, v17)
        table.insert(v15, v17)
    end
    v_u_3:PlayParticles(v15)
    p8:CreateSound("rbxassetid://96385683410648", 1.5, 1 + 0.1 * math.random(), nil, true, 5)
end
function v_u_4._Init(_) end
return v_u_4