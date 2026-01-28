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
            v10.Color = Color3.fromRGB(110, 241, 243)
            v10.Material = Enum.Material.Glass
            v10.MaterialVariant = ""
            v10.Reflectance = 0.4
        elseif v10:IsA("ParticleEmitter") or (v10:IsA("Beam") or v10:IsA("Trail")) then
            v10:Destroy()
        end
    end
    local v11 = p9._is_humanoid and p9._subject.RootPart or p9._subject
    local v12 = script.Particles.Appear:Clone()
    v12.Parent = v11
    local v13 = p9._destroy_these
    table.insert(v13, v12)
    v_u_3:PlayParticles(v12)
    p9:CreateSound("rbxassetid://93583856628897", 1.5, 1 + 0.1 * math.random(), nil, true, 5)
    wait(3)
    p9:CreateSound("rbxassetid://132622182757236", 1, 1 + 0.1 * math.random(), nil, true, 5)
    p9:CreateSound("rbxassetid://122487606797793", 1, 1 + 0.1 * math.random(), nil, true, 5)
    v12:Destroy()
    for _, v14 in pairs(p9:_GetObjects(true)) do
        if v14:IsA("BasePart") and v14 ~= v11 then
            v14:Destroy()
        end
    end
    local v15 = script.Particles.Emit:Clone()
    v15.Parent = v11
    local v16 = p9._destroy_these
    table.insert(v16, v15)
    v_u_3:PlayParticles(v15)
end
function v_u_4._Init(_) end
return v_u_4