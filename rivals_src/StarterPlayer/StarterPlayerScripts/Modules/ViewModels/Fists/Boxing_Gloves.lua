local v1 = game:GetService("Players")
local v_u_2 = require(v1.LocalPlayer.PlayerScripts.Modules.ViewModels.Fists)
local v_u_3 = setmetatable({}, v_u_2)
v_u_3.__index = v_u_3
function v_u_3.new(...)
    local v4 = v_u_2.new(...)
    local v5 = v_u_3
    local v6 = setmetatable(v4, v5)
    v6:_Init()
    return v6
end
function v_u_3.PlayHitmarkerSound(p7, p8, p9)
    if p8 then
        v_u_2.PlayHitmarkerSound(p7, p8, p9)
    else
        p7:_CreateHitmarkerSound("rbxassetid://17650289572", 1.5 / p9, 1.25 + 0.25 * math.random(), script, true, 1)
    end
end
function v_u_3._Init(_) end
return v_u_3