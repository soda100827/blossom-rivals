local v1 = game:GetService("Players")
local v_u_2 = require(v1.LocalPlayer.PlayerScripts.Modules.ViewModels.Flamethrower)
local v_u_3 = setmetatable({}, v_u_2)
v_u_3.__index = v_u_3
function v_u_3.new(...)
    local v4 = v_u_2.new(...)
    local v5 = v_u_3
    local v6 = setmetatable(v4, v5)
    v6:_Init()
    return v6
end
function v_u_3.PlayAirblastSoundEffect(p7)
    p7:CreateSound("rbxassetid://17772394926", 1, 1, true)
end
function v_u_3._CreateFlameSoundEffects(p8)
    return { p8:CreateSound("rbxassetid://17772394725", 2, 1.25, true) }
end
function v_u_3._Init(_) end
return v_u_3