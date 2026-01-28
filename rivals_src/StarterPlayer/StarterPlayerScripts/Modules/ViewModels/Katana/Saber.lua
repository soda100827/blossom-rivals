local v1 = game:GetService("Players")
local v_u_2 = require(v1.LocalPlayer.PlayerScripts.Modules.ViewModels.Katana)
local v_u_3 = setmetatable({}, v_u_2)
v_u_3.__index = v_u_3
function v_u_3.new(...)
    local v4 = v_u_2.new(...)
    local v5 = v_u_3
    local v6 = setmetatable(v4, v5)
    v6:_Init()
    return v6
end
function v_u_3.PlayDeflectHitSounds(p7)
    p7:CreateSound("rbxassetid://17640978084", 1.75, 0.9 + 0.2 * math.random(), true, 5)
end
function v_u_3._Init(_) end
return v_u_3