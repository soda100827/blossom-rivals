local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = require(v1.Modules.Emote)
local v_u_3 = setmetatable({}, v_u_2)
v_u_3.__index = v_u_3
function v_u_3.new(...)
    local v4 = v_u_2.new(3.85, script.Name, ...)
    local v5 = v_u_3
    local v6 = setmetatable(v4, v5)
    v6:_Init()
    return v6
end
function v_u_3.PlayClient(p7, ...)
    v_u_2.PlayClient(p7, ...)
    p7:_PlayAnimation("rbxassetid://119282539520778")
    wait(0.4)
    p7:CreateSound("rbxassetid://79768694812211", 0.8, 0.9, nil, true, 5)
    wait(0.6)
    p7:CreateSound("rbxassetid://79768694812211", 1, 1.1, nil, true, 5)
    wait(0.95)
    p7:CreateSound("rbxassetid://79768694812211", 0.8, 0.8, nil, true, 5)
    wait(0.4)
    p7:CreateSound("rbxassetid://79768694812211", 1, 1, nil, true, 5)
end
function v_u_3._Init(_) end
return v_u_3