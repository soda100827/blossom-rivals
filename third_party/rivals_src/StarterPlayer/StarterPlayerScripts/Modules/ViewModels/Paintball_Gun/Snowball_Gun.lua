local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.Utility)
local v_u_4 = require(v2.LocalPlayer.PlayerScripts.Modules.ViewModels["Paintball Gun"])
local v_u_5 = Color3.fromRGB(255, 255, 255)
local v_u_6 = Color3.fromRGB(253, 234, 141)
local v_u_7 = setmetatable({}, v_u_4)
v_u_7.__index = v_u_7
function v_u_7.new(...)
    local v8 = v_u_4.new(...)
    local v9 = v_u_7
    local v10 = setmetatable(v8, v9)
    v10:_Init()
    return v10
end
function v_u_7.GetPaintballColor(_)
    return math.random() < 0.001 and v_u_6 or v_u_5
end
function v_u_7.PlaySplatSound(_, p11)
    v_u_3:CreateSound("rbxassetid://11800684590", 0.5, 0.9 + 0.2 * math.random(), p11, true, 5)
end
function v_u_7._Init(_) end
return v_u_7