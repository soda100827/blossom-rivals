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
    p7:_PlayAnimation("rbxassetid://93712852727557", "rbxassetid://97084758451290", 3.6)
    local v8 = p7:_SetupMultipleProps(script.SparklersProp)
    wait(1.1)
    for _, v9 in pairs(v8.stick1:GetDescendants()) do
        if v9:IsA("ParticleEmitter") or v9:IsA("Trail") then
            v9.Enabled = true
        end
    end
    p7:CreateSound("rbxassetid://15573552175", 3, 1 + 0.1 * math.random(), nil, true, 5)
    p7:CreateSound("rbxassetid://75644699023746", 1, 1, nil, true).Looped = true
    wait(1.65)
    for _, v10 in pairs(v8.stick2:GetDescendants()) do
        if v10:IsA("ParticleEmitter") or v10:IsA("Trail") then
            v10.Enabled = true
        end
    end
    p7:CreateSound("rbxassetid://15573552175", 3, 1 + 0.1 * math.random(), nil, true, 5)
end
function v_u_3._Init(_) end
return v_u_3