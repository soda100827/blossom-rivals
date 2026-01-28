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
function v_u_4.PlayServer(p8, ...)
    v_u_2.PlayServer(p8, ...)
    v_u_3:Knockback(p8._is_humanoid and p8._subject.Parent.Head or p8._subject, Random.new():NextUnitVector() * Vector3.new(1, 0, 1) * 50 + Vector3.new(0, 25, 0))
    p8:CreateSound("rbxassetid://127579435864391", 1, 1.5 + 0.25 * math.random(), nil, true, 5)
end
function v_u_4._Init(_) end
return v_u_4