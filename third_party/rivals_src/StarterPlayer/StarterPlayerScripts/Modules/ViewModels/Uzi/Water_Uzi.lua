local v1 = game:GetService("Players")
local v_u_2 = require(v1.LocalPlayer.PlayerScripts.Modules.ViewModels.Uzi)
local v_u_3 = ColorSequence.new(Color3.fromRGB(20, 161, 255))
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
function v_u_4._Init(_) end
return v_u_4