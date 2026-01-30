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
function v_u_3.PlayServer(p7, ...)
    v_u_2.PlayClient(p7, ...)
    if p7._is_humanoid then
        p7._subject.Parent:ScaleTo(p7._subject.Parent:GetScale() * 0.5)
    end
end
function v_u_3.PlayClient(p8, ...)
    v_u_2.PlayClient(p8, ...)
    p8:CreateSound("rbxassetid://84840803158340", 1.5, 1 + 0.1 * math.random(), nil, true, 5)
end
function v_u_3._Init(_) end
return v_u_3