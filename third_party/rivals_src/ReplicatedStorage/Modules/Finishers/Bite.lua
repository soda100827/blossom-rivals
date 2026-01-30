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
    local v9 = p8._is_humanoid and p8._subject.RootPart or p8._subject
    local v10 = script.Particles:Clone()
    v10.CFrame = v9.CFrame
    v10.Parent = p8._subject
    local v11 = p8._destroy_these
    table.insert(v11, v10)
    local v12 = Instance.new("WeldConstraint")
    v12.Part0 = v9
    v12.Part1 = v10
    v12.Parent = v10
    v_u_3:PlayParticles(v10)
    p8:CreateSound("rbxassetid://119051363107007", 1.25, 1 + 0.2 * math.random(), nil, true, 5)
    p8:CreateSound("rbxassetid://70929054322985", 1.25, 1 + 0.2 * math.random(), nil, true, 5)
end
function v_u_4._Init(_) end
return v_u_4