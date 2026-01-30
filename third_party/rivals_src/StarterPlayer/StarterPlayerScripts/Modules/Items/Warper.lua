local v1 = game:GetService("Players")
local v_u_2 = require(v1.LocalPlayer.PlayerScripts.Modules.ItemTypes.Custom)
local v_u_3 = setmetatable({}, v_u_2)
v_u_3.__index = v_u_3
function v_u_3.new(...)
    local v4 = v_u_2.new(...)
    local v5 = v_u_3
    local v6 = setmetatable(v4, v5)
    v6._portal_cooldown = 0
    v6:_Init()
    return v6
end
function v_u_3.GetAutoShootReactionTime(_)
    return nil
end
function v_u_3.StartShooting(p7, ...)
    return p7:_OpenPortal("StartShooting", ...)
end
function v_u_3.StartAiming(p8, ...)
    return p8:_OpenPortal("StartAiming", ...)
end
function v_u_3._OpenPortal(p9, p10, p11)
    if p11 or tick() >= p9._portal_cooldown and not p9:IsEquipping() then
        p9._portal_cooldown = tick() + p9.Info.ShootCooldown
        local v12 = p9.ClientFighter:GetCameraData()
        p9:_Recoil(1)
        p9.ViewModel:MuzzleFlash()
        p9.ViewModel:StopAnimation("Equip", 0)
        p9.ViewModel:PlayAnimation("Shoot1", p9.Info.ShootCooldown, 0)
        return true, p10, v12
    end
end
function v_u_3._Init(_) end
return v_u_3