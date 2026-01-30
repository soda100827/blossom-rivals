local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = require(v1.Modules.Utility)
local v_u_3 = require(v1.Modules.Emote)
local v_u_4 = setmetatable({}, v_u_3)
v_u_4.__index = v_u_4
function v_u_4.new(...)
    local v5 = v_u_3.new(3.9, script.Name, ...)
    local v6 = v_u_4
    local v7 = setmetatable(v5, v6)
    v7:_Init()
    return v7
end
function v_u_4.PlayClient(p8, ...)
    v_u_3.PlayClient(p8, ...)
    local v9 = p8:_SetupProp(script.PhoneProp)
    p8:_PlayAnimation("rbxassetid://87719925359671")
    wait(0.4)
    v_u_2:PlayParticles(v9)
    p8:CreateSound("rbxassetid://96932112018810", 1, 1, nil, true, 5)
    wait(0.65)
    v_u_2:PlayParticles(v9)
    p8:CreateSound("rbxassetid://96932112018810", 1, 1, nil, true, 5)
    wait(0.15)
    v_u_2:PlayParticles(v9)
    p8:CreateSound("rbxassetid://96932112018810", 1, 1, nil, true, 5)
end
function v_u_4._Init(_) end
return v_u_4