game:GetService("ReplicatedStorage")
local v1 = game:GetService("Players")
local v_u_2 = require(v1.LocalPlayer.PlayerScripts.Controllers.ControlsController)
local v_u_3 = require(v1.LocalPlayer.PlayerScripts.Modules.ItemTypes.Melee)
local v_u_4 = setmetatable({}, v_u_3)
v_u_4.__index = v_u_4
function v_u_4.new(...)
    local v5 = v_u_3.new(...)
    local v6 = v_u_4
    local v7 = setmetatable(v5, v6)
    v7._deflect_cooldown = 0
    v7._deflect_hash = 0
    v7._deflect_num = 0
    v7:_Init()
    return v7
end
function v_u_4.CanQuickAttack(p8)
    local v9
    if v_u_2.CurrentControls == "Touch" then
        if tick() > p8._deflect_cooldown then
            return not p8:IsEquipping()
        end
        v9 = false
    else
        v9 = v_u_3.CanQuickAttack(p8)
    end
    return v9
end
function v_u_4.StartAiming(p10, p11)
    if p11 or tick() >= p10._deflect_cooldown and not p10:IsEquipping() then
        p10._deflect_cooldown = tick() + p10.Info.DeflectDuration + p10.Info.DeflectCooldown
        p10._attack_cooldown = tick() + p10.Info.DeflectDuration
        p10:_StartDeflecting()
        if p10.ItemInterface then
            p10.ItemInterface:CooldownEffect("rbxassetid://16828414433", p10.Info.DeflectDuration, "Deflect", true)
            task.delay(p10.Info.DeflectDuration, p10.ItemInterface.CooldownEffect, p10.ItemInterface, "rbxassetid://16828414433", p10.Info.DeflectCooldown, "Deflect")
        end
        return true, "StartAiming"
    end
end
function v_u_4.ReplicateFromServer(p12, p13, ...)
    if p13 == "DeflectHit" then
        if p12:IsRendered() then
            p12.ViewModel:StopAnimation("DeflectIdle", 0)
            p12.ViewModel:StopAnimation("Deflect" .. p12._deflect_num)
            p12._deflect_num = p12._deflect_num == #p12.ViewModel:GetAnimationKeys("Deflect") and 1 or p12._deflect_num + 1
            p12.ViewModel:PlayAnimation("Deflect" .. p12._deflect_num, 1, 0)
            p12.ViewModel:PlayDeflectHitParticles()
            p12.ViewModel:PlayDeflectHitSounds()
        end
    else
        v_u_3.ReplicateFromServer(p12, p13, ...)
        return
    end
end
function v_u_4._StopDeflectionAnimations(p14)
    for v15 = 1, #p14.ViewModel:GetAnimationKeys("Deflect") do
        p14.ViewModel:StopAnimation("Deflect" .. v15)
    end
end
function v_u_4._StartDeflecting(p_u_16)
    if p_u_16._last_attack_animation_name then
        p_u_16.ViewModel:StopAnimation(p_u_16._last_attack_animation_name)
    end
    p_u_16._deflect_hash = p_u_16._deflect_hash + 1
    local v_u_17 = p_u_16._deflect_hash
    p_u_16:SetReplicate("FOVOffset", 5)
    p_u_16.ViewModel:StopAnimation("Equip", 0)
    p_u_16.ViewModel:PlayAnimation("DeflectIdle", p_u_16.Info.DeflectDuration)
    p_u_16.ViewModel:PlayDeflectActiveParticles()
    task.spawn(function()
        wait(p_u_16.Info.DeflectDuration)
        if p_u_16._deflect_hash == v_u_17 then
            p_u_16:_StopDeflecting()
            wait(p_u_16.Info.DeflectCooldown)
            if p_u_16._deflect_hash == v_u_17 then
                if p_u_16.ItemInterface then
                    p_u_16.ItemInterface:StopCooldownEffect("Deflect")
                end
            end
        else
            return
        end
    end)
end
function v_u_4._StopDeflecting(p18)
    p18._deflect_hash = p18._deflect_hash + 1
    p18:SetReplicate("FOVOffset", 0)
    p18.ViewModel:ClearDeflectActiveParticles()
    p18:_StopDeflectionAnimations()
end
function v_u_4._Setup(p_u_19)
    function p_u_19._on_attack_callback()
        p_u_19.ViewModel:StopAnimation("DeflectIdle", 0)
        p_u_19:_StopDeflectionAnimations()
    end
end
function v_u_4._Init(p20)
    p20:_Setup()
end
return v_u_4