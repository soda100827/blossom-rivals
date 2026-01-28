local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.AnimationLibrary)
local v_u_4 = require(v1.Modules.Signal)
local v_u_5 = require(v2.LocalPlayer.PlayerScripts.Modules.ItemTypes.Custom)
local v_u_6 = setmetatable({}, v_u_5)
v_u_6.__index = v_u_6
function v_u_6.new(...)
    local v7 = v_u_5.new(...)
    local v8 = v_u_6
    local v9 = setmetatable(v7, v8)
    v9.AnimationReachedHealTimestamp = v_u_4.new()
    v9._is_using = false
    v9._use_cooldown = 0
    v9._use_hash = 0
    v9:_Init()
    return v9
end
function v_u_6.GetAutoShootReactionTime(_)
    return nil
end
function v_u_6.CanQuickAttack(p10)
    local v11 = not p10._is_using and (tick() > p10._use_cooldown and not p10:IsEquipping())
    if v11 then
        v11 = p10.ClientFighter:GetHealth() < p10.ClientFighter:GetMaxHealth()
    end
    return v11
end
function v_u_6.StartShooting(p12, p13)
    if not p13 and (p12._is_using or (tick() < p12._use_cooldown or (p12:IsEquipping() or p12.ClientFighter:GetHealth() >= p12.ClientFighter:GetMaxHealth()))) then
        return false
    end
    p12:_Use("Long")
    return true, "StartShooting"
end
function v_u_6.StartAiming(p14, p15)
    if not p15 and (p14._is_using or (tick() < p14._use_cooldown or (p14:IsEquipping() or p14.ClientFighter:GetHealth() >= p14.ClientFighter:GetMaxHealth()))) then
        return false
    end
    p14:_Use("Quick")
    return true, "StartAiming"
end
function v_u_6.Unequip(p16, ...)
    p16:_CancelUse()
    v_u_5.Unequip(p16, ...)
end
function v_u_6.ReplicateFromServer(p17, p18, ...)
    if p18 == "CancelUse" then
        if p17:IsRendered() then
            p17:_CancelUse()
        end
    elseif p18 == "SetCooldown" then
        if p17:IsRendered() then
            p17:_SetCooldown()
        end
    else
        v_u_5.ReplicateFromServer(p17, p18, ...)
        return
    end
end
function v_u_6.Destroy(p19)
    p19.AnimationReachedHealTimestamp:Destroy()
    v_u_5.Destroy(p19)
end
function v_u_6._SetCooldown(p20)
    p20._use_cooldown = tick() + p20.Info.Cooldown
    p20._is_using = false
    if p20.ItemInterface then
        p20.ItemInterface:CooldownEffect("rbxassetid://17156089790", p20.Info.Cooldown, "Heal")
    end
end
function v_u_6._CancelUse(p21)
    p21._is_using = false
    p21._use_hash = p21._use_hash + 1
    p21.ViewModel:StopAnimation("Use")
    p21.ViewModel:StopAnimation("UseQuick")
    if p21.ItemInterface then
        p21.ItemInterface:StopCooldownEffect("Healing")
    end
end
function v_u_6._Use(p_u_22, p23)
    p_u_22._is_using = true
    local v_u_24 = p_u_22._use_hash
    local v_u_25 = p_u_22.Info[p23 .. "ActionTimestamp"]
    local v26 = p23 == "Long" and "Use" or (p23 == "Quick" and "UseQuick" or nil)
    local v_u_27 = v_u_3.Info[p_u_22.ViewModel.Info.Animations[v26]]
    p_u_22.ViewModel:StopAnimation(p_u_22.ViewModel.Animator:GetEquipAnimationKey())
    p_u_22.ViewModel:PlayAnimation(v26, v_u_27.Length)
    if p_u_22.ItemInterface then
        p_u_22.ItemInterface:CooldownEffect("rbxassetid://17140223250", v_u_25, "Healing", true)
    end
    task.spawn(function()
        wait(v_u_25)
        if v_u_24 == p_u_22._use_hash then
            p_u_22.AnimationReachedHealTimestamp:Fire()
            p_u_22._use_cooldown = tick() + 1
            p_u_22._is_using = false
        end
    end)
    task.spawn(function()
        wait(v_u_27.Length)
        if v_u_24 == p_u_22._use_hash then
            if p_u_22.ViewModel.PlayEquipAnimationOnHeal then
                p_u_22.ViewModel:PlayAnimation(p_u_22.ViewModel.Animator:GetEquipAnimationKey())
            end
        end
    end)
end
function v_u_6._Init(_) end
return v_u_6