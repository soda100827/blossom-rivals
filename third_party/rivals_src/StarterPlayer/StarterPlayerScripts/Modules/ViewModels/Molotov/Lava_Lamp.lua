local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.Utility)
local v_u_4 = require(v2.LocalPlayer.PlayerScripts.Modules.ViewModels.Molotov)
local v_u_5 = setmetatable({}, v_u_4)
v_u_5.__index = v_u_5
function v_u_5.new(...)
    local v6 = v_u_4.new(...)
    local v7 = v_u_5
    local v8 = setmetatable(v6, v7)
    v8:_Init()
    return v8
end
function v_u_5.ExplosionEffect(p9, p10, p11)
    local v12 = v_u_4.ExplosionEffect(p9, p10, p11)
    v_u_3:CreateSound("rbxassetid://100889848836357", 1, 1 + 0.25 * math.random(), v12, true, 10)
end
function v_u_5._Init(_) end
return v_u_5