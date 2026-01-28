local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = require(v1.Modules.Utility)
local v_u_3 = {}
v_u_3.__index = v_u_3
function v_u_3.new(p4)
    local v5 = v_u_3
    local v6 = setmetatable({}, v5)
    v6.FighterInterface = p4
    v6.RefillAmmoVignette = v6.FighterInterface.Frame:WaitForChild("RefillAmmoVignette")
    v6.RefillAmmoVignetteTexture = v6.RefillAmmoVignette:WaitForChild("Texture")
    v6._refill_ammo_effect_hash = 0
    v6:_Init()
    return v6
end
function v_u_3.RefillAmmoEffect(p_u_7)
    if p_u_7.FighterInterface:IsActive() then
        p_u_7._refill_ammo_effect_hash = p_u_7._refill_ammo_effect_hash + 1
        local v_u_8 = p_u_7._refill_ammo_effect_hash
        p_u_7.FighterInterface:CreateSound("rbxassetid://93185674378015", 1, 1, script, true, 10)
        p_u_7.FighterInterface:CreateSound("rbxassetid://96308464356768", 1.5, 1, script, true, 10)
        task.spawn(v_u_2.RenderstepForLoop, v_u_2, 0, 100, 4, function(p9)
            if v_u_8 ~= p_u_7._refill_ammo_effect_hash then
                return true
            end
            local v10 = 0 + 1 * (p9 / 100)
            p_u_7.RefillAmmoVignette.ImageTransparency = v10
            p_u_7.RefillAmmoVignetteTexture.ImageTransparency = v10
        end)
    end
end
function v_u_3.Destroy(p11)
    p11._refill_ammo_effect_hash = p11._refill_ammo_effect_hash + 1
end
function v_u_3._Init(_) end
return v_u_3