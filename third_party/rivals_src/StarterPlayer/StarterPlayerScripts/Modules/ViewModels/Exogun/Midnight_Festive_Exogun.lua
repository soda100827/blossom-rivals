local v1 = game:GetService("Players")
local v_u_2 = require(v1.LocalPlayer.PlayerScripts.Modules.FestiveLightsCircuit)
local v_u_3 = require(v1.LocalPlayer.PlayerScripts.Modules.ViewModels.Exogun)
local v_u_4 = v1.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild("MidnightFestiveExogunExplosionParticles")
local v_u_5 = ColorSequence.new(Color3.fromRGB(22, 5, 255))
local v_u_6 = setmetatable({}, v_u_3)
v_u_6.__index = v_u_6
function v_u_6.new(...)
    local v7 = v_u_3.new(...)
    local v8 = v_u_6
    local v9 = setmetatable(v7, v8)
    v9._festive_lights_circuit = v_u_2.new(0.5, v9.ItemModel:WaitForChild("Body"):WaitForChild("Light1"), v9.ItemModel:WaitForChild("Body"):WaitForChild("Light2"), v9.ItemModel:WaitForChild("Body"):WaitForChild("Light3"))
    v9:_Init()
    return v9
end
function v_u_6.GetFriendlyTracerColor(_)
    return v_u_5
end
function v_u_6.ExplosionEffect(p10, p11, p12)
    v_u_3.ExplosionEffect(p10, p11, p12, v_u_4)
end
function v_u_6.Update(p13, p14, p15, p16)
    v_u_3.Update(p13, p14, p15, p16)
    if p16.IsActive then
        p13._festive_lights_circuit:Update(p14)
    end
end
function v_u_6.Destroy(p17)
    p17._festive_lights_circuit:Destroy()
    v_u_3.Destroy(p17)
end
function v_u_6._Init(_) end
return v_u_6