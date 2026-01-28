local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = require(v1.Modules.Emote)
local v_u_3 = setmetatable({}, v_u_2)
v_u_3.__index = v_u_3
function v_u_3.new(...)
    local v4 = v_u_2.new(2.1, script.Name, ...)
    local v5 = v_u_3
    local v6 = setmetatable(v4, v5)
    v6:_Init()
    return v6
end
function v_u_3.PlayClient(p7, ...)
    v_u_2.PlayClient(p7, ...)
    p7:_PlayAnimation("rbxassetid://103862270973168")
    p7:CreateSound("rbxassetid://88377109323880", 1, 1 + 0.1 * math.random(), nil, true, 5)
    wait(0.7)
    p7:CreateSound("rbxassetid://13160326139", 1.25, 1 + 0.1 * math.random(), nil, true, 5)
end
function v_u_3._Init(_) end
return v_u_3