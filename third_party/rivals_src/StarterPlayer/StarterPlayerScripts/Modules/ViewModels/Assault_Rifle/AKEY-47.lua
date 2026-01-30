local v1 = game:GetService("Players")
local v_u_2 = require(v1.LocalPlayer.PlayerScripts.Modules.ViewModels["Assault Rifle"])
local v_u_3 = ColorSequence.new(Color3.fromRGB(255, 218, 155))
local v_u_4 = setmetatable({}, v_u_2)
v_u_4.__index = v_u_4
function v_u_4.new(...)
    local v5 = v_u_2.new(...)
    local v6 = v_u_4
    local v7 = setmetatable(v5, v6)
    v7:_Init()
    return v7
end
function v_u_4.GetFriendlyTracerColor(_)
    return v_u_3
end
function v_u_4.PlayAimSound(p8, p9)
    p8:CreateSound("rbxassetid://96253147006478", 0.375, 2 + (p9 and 0.1 or 0), true, 5)
end
function v_u_4._Init(_) end
return v_u_4