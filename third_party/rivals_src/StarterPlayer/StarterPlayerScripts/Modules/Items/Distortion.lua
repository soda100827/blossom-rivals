local v1 = game:GetService("Players")
local v_u_2 = require(v1.LocalPlayer.PlayerScripts.Modules.ItemTypes.Gun)
local v_u_3 = setmetatable({}, v_u_2)
v_u_3.__index = v_u_3
function v_u_3.new(...)
    local v4 = v_u_2.new(...)
    local v5 = v_u_3
    local v6 = setmetatable(v4, v5)
    v6.ToggleAimEnabled = nil
    v6._vortex_cooldown = 0
    v6:_Init()
    return v6
end
function v_u_3.StartAiming(p7, p8)
    if p8 or tick() >= p7._vortex_cooldown and not p7:IsEquipping() then
        p7._vortex_cooldown = tick() + p7.Info.VortexCooldown
        local v9 = p7.ClientFighter:GetCameraData()
        p7:_Recoil(1)
        p7.ViewModel:MuzzleFlash()
        p7.ViewModel:StopAnimation("Equip", 0)
        p7.ViewModel:PlayAnimation("Shoot1")
        if p7.ItemInterface then
            p7.ItemInterface:CooldownEffect("rbxassetid://76793585944473", p7.Info.VortexCooldown, "Vortex")
        end
        return true, "StartAiming", v9
    end
end
function v_u_3.FinishAiming(_, _)
    return false
end
function v_u_3.StartSprinting(_, _)
    return false
end
function v_u_3._Init(_) end
return v_u_3