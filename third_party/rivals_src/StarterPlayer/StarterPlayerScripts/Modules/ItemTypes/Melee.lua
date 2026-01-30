local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
require(v1.Modules.Utility)
local v_u_3 = require(v2.LocalPlayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientFighter.ClientItem)
local v_u_4 = setmetatable({}, v_u_3)
v_u_4.__index = v_u_4
function v_u_4.new(...)
    local v5 = v_u_3.new(...)
    local v6 = v_u_4
    local v7 = setmetatable(v5, v6)
    v7._attack_cooldown = 0
    v7._attack_num = 0
    v7._attack_hash = 0
    v7._last_attack_animation_name = nil
    v7._on_attack_callback = nil
    v7:_Init()
    return v7
end
function v_u_4.GetAutoShootReach(p8)
    return p8.Info.AttackReach
end
function v_u_4.CanQuickAttack(p9)
    local v10
    if tick() > p9._attack_cooldown then
        v10 = not p9:IsEquipping()
    else
        v10 = false
    end
    return v10
end
function v_u_4.StartShooting(p_u_11, p12, p13)
    if not p12 and (tick() < p_u_11._attack_cooldown or p_u_11:IsEquipping()) then
        return false
    end
    if p_u_11._last_attack_animation_name then
        p_u_11.ViewModel:StopAnimation(p_u_11._last_attack_animation_name)
    end
    p_u_11._attack_cooldown = tick() + p_u_11.Info.AttackCooldown
    p_u_11._attack_hash = p_u_11._attack_hash + 1
    local v_u_14 = p_u_11._attack_hash
    p_u_11._attack_num = p_u_11._attack_num % #p_u_11.ViewModel:GetAnimationKeys("Attack") + 1
    local v15 = p13 and p_u_11:FromEnum(p13) or "Attack" .. p_u_11._attack_num
    p_u_11._last_attack_animation_name = v15
    p_u_11.ViewModel:StopAnimation("Equip")
    p_u_11.ViewModel:PlayAnimation(v15, p_u_11.Info.AttackCooldown)
    if p_u_11._on_attack_callback then
        p_u_11._on_attack_callback()
    end
    task.delay(p_u_11.Info.AttackDelay, function()
        if v_u_14 == p_u_11._attack_hash then
            if p_u_11.ClientFighter.IsLocalPlayer then
                local v16, v17 = p_u_11.ClientFighter:GetCameraData()
                p_u_11:_ImpactMarkerSlash(p_u_11.Info.AttackReach, v16, v17)
            end
            p_u_11:_Shake("Bump")
        end
    end)
    return true, "StartShooting", p_u_11.ClientFighter:GetCameraData(), p_u_11:ToEnum(v15)
end
function v_u_4.Equip(p18, ...)
    v_u_3.Equip(p18, ...)
    p18._attack_hash = p18._attack_hash + 1
end
function v_u_4.Unequip(p19, ...)
    p19._attack_hash = p19._attack_hash + 1
    v_u_3.Unequip(p19, ...)
end
function v_u_4._Init(_) end
return v_u_4