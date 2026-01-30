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
    wait(0.75)
    local v9 = script.Particles.Attachment:Clone()
    v9.Parent = p8._is_humanoid and p8._subject.Parent.LowerTorso or p8._subject
    local v10 = p8._destroy_these
    table.insert(v10, v9)
    v_u_3:PlayParticles(v9)
    p8:CreateSound("rbxassetid://16924073325", 1, 1 + 0.2 * math.random(), nil, true, 5)
end
function v_u_4._Init(_) end
return v_u_4