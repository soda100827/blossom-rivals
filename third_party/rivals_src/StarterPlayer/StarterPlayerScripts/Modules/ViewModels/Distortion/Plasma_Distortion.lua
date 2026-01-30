local v1 = game:GetService("Players")
local v_u_2 = require(v1.LocalPlayer.PlayerScripts.Modules.ViewModels.Distortion)
local v_u_3 = v1.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild("PlasmaDistortionExplosionParticles")
local v_u_4 = ColorSequence.new(Color3.fromRGB(119, 29, 255))
local v_u_5 = setmetatable({}, v_u_2)
v_u_5.__index = v_u_5
function v_u_5.new(...)
    local v6 = v_u_2.new(...)
    local v7 = v_u_5
    local v8 = setmetatable(v6, v7)
    v8:_Init()
    return v8
end
function v_u_5.GetFriendlyTracerColor(_)
    return v_u_4
end
function v_u_5.ExplosionEffect(p9, p10, p11)
    v_u_2.ExplosionEffect(p9, p10, p11, v_u_3)
end
function v_u_5._Init(_) end
return v_u_5