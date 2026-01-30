local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = require(v1.Modules.Emote)
local v_u_3 = setmetatable({}, v_u_2)
v_u_3.__index = v_u_3
function v_u_3.new(...)
    local v4 = v_u_2.new(6.2, script.Name, ...)
    local v5 = v_u_3
    local v6 = setmetatable(v4, v5)
    v6:_Init()
    return v6
end
function v_u_3.PlayClient(p7, ...)
    v_u_2.PlayClient(p7, ...)
    p7:_PlayAnimation("rbxassetid://137924113002985")
    local v8 = p7:_SetupMultipleProps(script.ItsTimeProp)
    wait(1.9)
    p7:CreateSound("rbxassetid://85464929329408", 1, 0.8 + 0.1 * math.random(), nil, true, 5)
    wait(0.65)
    p7:CreateSound("rbxassetid://85464929329408", 1, 0.9 + 0.1 * math.random(), nil, true, 5)
    wait(0.55)
    p7:CreateSound("rbxassetid://85464929329408", 1, 1 + 0.1 * math.random(), nil, true, 5)
    wait(0.35)
    p7:CreateSound("rbxassetid://135970869546121", 1.25, 1 + 0.1 * math.random(), nil, true, 5)
    wait(0.55)
    for _, v9 in pairs(v8) do
        v9.LocalTransparencyModifier = 1
    end
end
function v_u_3._Init(_) end
return v_u_3