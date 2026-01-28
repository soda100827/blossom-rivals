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
    p8:_AnchorModel(10)
    for _, v9 in pairs(p8:_GetObjects(true)) do
        if v9:IsA("BasePart") then
            v9.CustomPhysicalProperties = PhysicalProperties.new(v9.CurrentPhysicalProperties.Density, 0, 0, 100, 100)
            v9.Velocity = Random.new():NextUnitVector() * 10
            v9.RotVelocity = Random.new():NextUnitVector() * 25
        end
    end
end
function v_u_4.PlayClient(p10)
    for _, v11 in pairs(p10:_GetObjects(true)) do
        if v11:IsA("BasePart") then
            v11.Color = Color3.fromRGB(110, 241, 243)
            v11.Material = Enum.Material.Glass
            v11.MaterialVariant = ""
            v11.Reflectance = 0.4
        elseif v11:IsA("ParticleEmitter") or (v11:IsA("Beam") or v11:IsA("Trail")) then
            v11:Destroy()
        end
    end
    local v12 = p10._is_humanoid and p10._subject.RootPart or p10._subject
    local v13 = script.Particles.Appear:Clone()
    v13.Parent = v12
    local v14 = p10._destroy_these
    table.insert(v14, v13)
    v_u_3:PlayParticles(v13)
    p10:CreateSound("rbxassetid://93583856628897", 1.5, 1.5 + 0.2 * math.random(), nil, true, 5)
end
function v_u_4._Init(_) end
return v_u_4