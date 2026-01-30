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
function v_u_3.PlayClient(p_u_7, ...)
    v_u_2.PlayClient(p_u_7, ...)
    p_u_7:_SetupProp(script.PortalProp)
    p_u_7:_PlayAnimation("rbxassetid://114622720984788", "rbxassetid://100757699753241", 1.15)
    p_u_7:_InternalThread(task.spawn, function()
        wait(0.9)
        p_u_7:CreateSound("rbxassetid://81610952487049", 0.375, 1 + 0.1 * math.random(), nil, true, 5)
        p_u_7:CreateSound("rbxassetid://7127702569", 0.25, 1 + 0.25 * math.random(), nil, true, 5)
        wait(0.266)
        for v8 = 1, (1 / 0) do
            p_u_7:CreateSound("rbxassetid://81610952487049", 0.25, 1 + 0.1 * math.random(), nil, true, 5)
            p_u_7:CreateSound("rbxassetid://7127702569", 0.5 / (1 + 0.25 * (v8 - 1)), 1 + 0.25 * math.random(), nil, true, 5)
            wait(0.26666666666666666)
        end
    end)
end
function v_u_3._Init(_) end
return v_u_3