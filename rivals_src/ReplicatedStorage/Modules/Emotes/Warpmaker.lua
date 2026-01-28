local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = require(v1.Modules.Emote)
local v_u_3 = setmetatable({}, v_u_2)
v_u_3.__index = v_u_3
function v_u_3.new(...)
    local v4 = v_u_2.new(nil, script.Name, ...)
    local v5 = v_u_3
    local v6 = setmetatable(v4, v5)
    v6:_Init()
    return v6
end
function v_u_3.PlayClient(p7, ...)
    v_u_2.PlayClient(p7, ...)
    p7:_SetupProp(script.PortalProp)
    p7:_PlayAnimation("rbxassetid://118879812674727", "rbxassetid://137721007241440", 2.45)
    wait(1.4)
    p7:CreateSound("rbxassetid://7127702569", 1, 1.2, nil, true, 5)
end
function v_u_3._Init(_) end
return v_u_3