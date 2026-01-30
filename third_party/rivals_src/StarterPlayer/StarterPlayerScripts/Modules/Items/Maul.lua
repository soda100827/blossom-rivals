local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.AnimationLibrary)
local v_u_4 = require(v2.LocalPlayer.PlayerScripts.Modules.ItemTypes.Melee)
local v_u_5 = setmetatable({}, v_u_4)
v_u_5.__index = v_u_5
function v_u_5.new(...)
    local v6 = v_u_4.new(...)
    local v7 = v_u_5
    local v8 = setmetatable(v6, v7)
    v8._is_charging = false
    v8._charge_start = nil
    v8._charge_hash = 0
    v8._release_queued = false
    v8:_Init()
    return v8
end
function v_u_5.StartAiming(p_u_9, p10)
    if not p10 and (p_u_9._is_charging or (tick() < p_u_9._attack_cooldown or p_u_9:IsEquipping())) then
        return false
    end
    if p_u_9._last_attack_animation_name then
        p_u_9.ViewModel:StopAnimation(p_u_9._last_attack_animation_name)
    end
    p_u_9._is_charging = true
    p_u_9._charge_start = tick()
    p_u_9._attack_cooldown = (1 / 0)
    p_u_9._on_attack_callback()
    p_u_9.ViewModel:StopAnimation("Equip")
    p_u_9.ViewModel:StopAnimation("Inspect")
    p_u_9.ViewModel:PlayAnimation("ChargeIntro", (1 / 0), 0.1)
    local _ = p_u_9.ItemInterface
    p_u_9._charge_hash = p_u_9._charge_hash + 1
    local v_u_11 = p_u_9._charge_hash
    task.spawn(function()
        wait(p_u_9.Info.ChargeIntro)
        if v_u_11 == p_u_9._charge_hash then
            if p_u_9._release_queued then
                p_u_9:_StopCharging()
            end
        end
    end)
    task.spawn(function()
        wait(v_u_3.Info[p_u_9.ViewModel.Info.Animations.ChargeIntro].Length)
        if v_u_11 == p_u_9._charge_hash then
            p_u_9.ViewModel:PlayAnimation("ChargeLoop", (1 / 0), 0)
        end
    end)
    return true, "StartAiming"
end
function v_u_5.FinishAiming(p12, p13)
    if not (p13 or p12._is_charging) then
        return false
    end
    p12:_StopCharging()
    return true, "FinishAiming"
end
function v_u_5.StartSprinting(_, _)
    return false
end
function v_u_5.Unequip(p14, ...)
    task.spawn(p14.Input, p14, "FinishAiming")
    task.defer(p14._StopCharging, p14, true)
    v_u_4.Unequip(p14, ...)
end
function v_u_5._StopCharging(p15, p16)
    local v17 = p15.Info.ChargeReleaseCooldown
    p15._release_queued = false
    p15._is_charging = false
    p15._charge_start = nil
    p15._charge_hash = p15._charge_hash + 1
    p15._attack_cooldown = tick() + (p16 and 0 or v17)
    if not p16 then
        p15.ViewModel:PlayAnimation("ChargeOutro", v17, 0.1)
    end
    p15.ViewModel:StopAnimation("ChargeLoop", 0.1)
    p15.ViewModel:StopAnimation("ChargeIntro", 0.1)
    if p15.ItemInterface and p16 then
        if p16 then
            p15.ItemInterface:StopCooldownEffect("Charging")
            return
        end
        p15.ItemInterface:CooldownEffect("rbxassetid://82245274345461", p15.Info.ChargeAttackDelay, "Charging")
    end
end
function v_u_5._Setup(p_u_18)
    function p_u_18._on_attack_callback()
        p_u_18.ViewModel:StopAnimation("ChargeLoop", 0)
        p_u_18.ViewModel:StopAnimation("ChargeOutro", 0)
    end
end
function v_u_5._Init(p_u_19)
    local v20 = p_u_19._connections
    local v21 = p_u_19.ClientFighter.Interrupted
    table.insert(v20, v21:Connect(function()
        p_u_19:_StopCharging(true)
    end))
    p_u_19:_Setup()
end
return v_u_5