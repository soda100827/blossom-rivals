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
    p7:_PlayAnimation("rbxassetid://115000869501227", "rbxassetid://83376670167687", 4.15)
    p7:CreateSound("rbxassetid://80133530921906", 1.5, 1, nil, true)
    wait(15.54)
    p7:CreateSound("rbxassetid://98970356172671", 1.5, 1, nil, true).Looped = true
end
function v_u_3._Init(_) end
return v_u_3