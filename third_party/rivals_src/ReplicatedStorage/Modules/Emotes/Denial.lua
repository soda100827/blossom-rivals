local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = require(v1.Modules.Emote)
local v_u_3 = setmetatable({}, v_u_2)
v_u_3.__index = v_u_3
function v_u_3.new(...)
    local v4 = v_u_2.new(1.75, script.Name, ...)
    local v5 = v_u_3
    local v6 = setmetatable(v4, v5)
    v6:_Init()
    return v6
end
function v_u_3.PlayClient(p7, ...)
    v_u_2.PlayClient(p7, ...)
    p7:_PlayAnimation("rbxassetid://81555757574094")
    p7:CreateSound("rbxassetid://75485128790168", 1, 1 + 0.1 * math.random(), nil, true, 5)
    wait(0.4)
    p7:CreateSound("rbxassetid://13158735106", 1, 1.2, nil, true, 5)
    wait(0.2)
    p7:CreateSound("rbxassetid://13158735106", 1, 1, nil, true, 5)
    wait(0.2)
    p7:CreateSound("rbxassetid://13158735106", 1, 1.3, nil, true, 5)
end
function v_u_3._Init(_) end
return v_u_3