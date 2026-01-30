local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.Utility)
local v_u_4 = require(v2.LocalPlayer.PlayerScripts.Controllers.FunctionsController)
local v_u_5 = require(v2.LocalPlayer.PlayerScripts.Modules.ViewModels.Grenade)
local v_u_6 = setmetatable({}, v_u_5)
v_u_6.__index = v_u_6
function v_u_6.new(...)
    local v7 = v_u_5.new(...)
    local v8 = v_u_6
    local v9 = setmetatable(v7, v8)
    v9:_Init()
    return v9
end
function v_u_6.ExplosionEffect(p10, p11, p12)
    v_u_3:CreateSound("rbxassetid://99261833097954", 0.5, 0.9 + 0.2 * math.random(), p11, true, 10)
    v_u_4:FireAsync(p10:ToEnum("ExplosionEffect"), p11, p12)
end
function v_u_6._Init(_) end
return v_u_6