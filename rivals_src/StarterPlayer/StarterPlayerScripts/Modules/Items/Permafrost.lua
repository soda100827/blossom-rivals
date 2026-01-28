local v1 = game:GetService("Players")
local v_u_2 = require(v1.LocalPlayer.PlayerScripts.Modules.ItemTypes.Gun)
local v_u_3 = setmetatable({}, v_u_2)
v_u_3.__index = v_u_3
function v_u_3.new(...)
    local v4 = v_u_2.new(...)
    local v5 = v_u_3
    local v6 = setmetatable(v4, v5)
    v6.ToggleAimEnabled = nil
    v6:_Init()
    return v6
end
function v_u_3.StartAiming(p7, p8)
    if p8 or tick() >= p7._shoot_cooldown and (tick() >= p7._reload_cooldown and (p7:Get("Ammo") > 0 and not p7:IsEquipping())) then
        p7._reload_cooldown = tick() + 0.35
        task.delay(0.35, p7._CheckReload, p7)
        p7.ViewModel:PlayAnimation("Throw")
        return true, "StartAiming", p7.ClientFighter:GetCameraData()
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