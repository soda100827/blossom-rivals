local v1 = game:GetService("ReplicatedStorage")
game:GetService("RunService")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.AnimationLibrary)
require(v1.Modules.BetterDebris)
local v_u_4 = require(v2.LocalPlayer.PlayerScripts.Modules.ItemTypes.Gun)
local v_u_5 = setmetatable({}, v_u_4)
v_u_5.__index = v_u_5
function v_u_5.new(...)
    local v6 = v_u_4.new(...)
    local v7 = v_u_5
    local v8 = setmetatable(v6, v7)
    v8.ToggleAimEnabled = nil
    v8._transition_cooldown = 0
    v8._blade_cooldown = 0
    v8._blade_attack_num = 0
    v8._last_blade_animation_name = nil
    v8._dash_cooldown = 0
    v8._fov_offset_speed = 1
    v8._blade_critical_hit_hash = 0
    v8._transition_animation_playing = 0
    v8:_Init()
    return v8
end
function v_u_5.CanQuickAttack(p9)
    local v10
    if tick() > p9._transition_cooldown then
        if p9:Get("Mode") == "Gun" then
            return v_u_4.CanQuickAttack(p9)
        end
        if tick() > p9._blade_cooldown then
            v10 = not p9:IsEquipping()
        else
            v10 = false
        end
    else
        v10 = false
    end
    return v10
end
function v_u_5.GetAutoShootReactionTime(p11)
    return p11:Get("Mode") == "Blade" and 0 or v_u_4.GetAutoShootReactionTime(p11)
end
function v_u_5.GetAutoShootReach(p12)
    if p12:Get("Mode") == "Blade" then
        return p12.Info.BladeReach
    else
        return v_u_4.GetAutoShootReach(p12)
    end
end
function v_u_5.GetAimSpeed(p13)
    return p13._fov_offset_speed
end
function v_u_5.StartShooting(p14, p15, p16, ...)
    local v17 = p16 or p14:Get("Mode")
    if p15 or tick() >= p14._transition_cooldown and not p14:IsEquipping() then
        p14.ViewModel:StopAnimation("To" .. v17)
        if v17 == "Gun" then
            return v_u_4.StartShooting(p14, p15, ...)
        elseif v17 == "Blade" then
            return p14:_StartShootingBladeMode(p15, ...)
        else
            return false
        end
    else
        return false
    end
end
function v_u_5.StartAiming(p18, p19, p20, ...)
    local v21 = p20 or p18:Get("Mode")
    if p19 or (v21 ~= "Gun" or tick() >= p18._transition_cooldown) and not p18:IsEquipping() then
        p18.ViewModel:StopAnimation("To" .. v21)
        if v21 == "Gun" then
            return v_u_4.StartAiming(p18, p19, ...)
        elseif v21 == "Blade" then
            return p18:_StartAimingBladeMode(p19, ...)
        else
            return false
        end
    else
        return false
    end
end
function v_u_5.ReplicateFromServer(p22, p23, ...)
    if p23 == "BladeCriticalHit" then
        if p22:IsRendered() then
            if p22.IsEquipped then
                p22._blade_critical_hit_hash = p22._blade_critical_hit_hash + 1
                local v24 = p22._blade_critical_hit_hash
                p22._fov_offset_speed = 5
                p22:SetReplicate("FOVOffset", -5)
                if p22._last_blade_animation_name then
                    p22.ViewModel:StopAnimation(p22._last_blade_animation_name)
                end
                p22.ViewModel:PlayAnimation("BladeAttackOnHit", nil, 0)
                wait(v_u_3.Info[p22.ViewModel.Info.Animations.BladeAttackOnHit].ActionTimestamp)
                if p22._blade_critical_hit_hash == v24 then
                    p22:SetReplicate("FOVOffset", 5)
                    p22:_Recoil(2)
                    p22.ViewModel:MuzzleFlash()
                    wait(0.125)
                    if p22._blade_critical_hit_hash == v24 then
                        p22._fov_offset_speed = 1
                        p22:SetReplicate("FOVOffset", 0)
                    end
                else
                    return
                end
            else
                return
            end
        else
            return
        end
    else
        v_u_4.ReplicateFromServer(p22, p23, ...)
        return
    end
end
function v_u_5._StartShootingBladeMode(p_u_25, p26)
    if not p26 and tick() < p_u_25._blade_cooldown then
        return false
    end
    p_u_25._blade_cooldown = tick() + p_u_25.Info.BladeCooldown
    if p_u_25._last_blade_animation_name then
        p_u_25.ViewModel:StopAnimation(p_u_25._last_blade_animation_name)
    end
    p_u_25._blade_attack_num = p_u_25._blade_attack_num % #p_u_25.ViewModel:GetAnimationKeys("BladeAttack") + 1
    p_u_25._last_blade_animation_name = "BladeAttack" .. p_u_25._blade_attack_num
    p_u_25.ViewModel:StopAnimation("BladeAttackOnHit")
    p_u_25.ViewModel:StopAnimation("Equip")
    p_u_25.ViewModel:PlayAnimation(p_u_25._last_blade_animation_name, p_u_25.Info.BladeCooldown)
    task.delay(0.1, function()
        p_u_25:_Shake("Bump")
    end)
    local v27, v28 = p_u_25.ClientFighter:GetCameraData()
    if p_u_25.ClientFighter.IsLocalPlayer then
        p_u_25:_ImpactMarkerSlash(p_u_25.Info.BladeReach, v27, v28)
    end
    return true, "StartShooting", v27
end
function v_u_5._StartAimingBladeMode(p29, p30)
    if not p30 and tick() < p29._dash_cooldown then
        return false
    end
    p29._dash_cooldown = tick() + p29.Info.DashCooldown
    if not p30 then
        local v31 = p29.ClientFighter:GetMoveVector(true, false, workspace.CurrentCamera.CFrame.LookVector) * p29.Info.DashSpeed
        p29.ClientFighter.Entity:HardDash(v31, p29.Info.DashDuration)
    end
    p29:CreateSound("rbxassetid://16492958314", 1, 1 + 0.1 * math.random(), true)
    if p29.ItemInterface then
        p29.ItemInterface:CooldownEffect("rbxassetid://16828140099", p29.Info.DashCooldown, "Dash")
        p29.ItemInterface:PlaySpeedLines(p29.Info.DashDuration)
    end
    return true, "StartAiming"
end
function v_u_5._ModeChanged(p32, p33)
    if p32._last_shoot_animation_name then
        p32.ViewModel:StopAnimation(p32._last_shoot_animation_name)
    end
    if p32._last_blade_animation_name then
        p32.ViewModel:StopAnimation(p32._last_blade_animation_name)
    end
    local v34 = p32:Get("Mode")
    local v35 = v34 == "Blade" and "Blade" or ""
    p32.ViewModel:ChangeEquipAnimation(v35 .. "Equip")
    p32.ViewModel:ChangeIdleAnimation(v35 .. "Idle")
    p32.ViewModel:ChangeSprintAnimation(v35 .. "Sprint")
    p32.ViewModel:ChangeInspectAnimation(v35 .. "Inspect")
    if not p33 then
        p32.ViewModel:PlayAnimation("To" .. v34 .. (v34 == "Gun" and (p32._blade_attack_num or "") or ""))
        for _, v36 in pairs({ "Shoot", "BladeAttack" }) do
            for v37 = 1, #p32.ViewModel:GetAnimationKeys(v36) do
                p32.ViewModel.Animator:BlockAnimation(v36 .. v37, 0.25)
            end
        end
    end
    p32.ToggleAimEnabled = v34 == "Gun"
end
function v_u_5._Init(p_u_38)
    p_u_38.Shot:Connect(function()
        p_u_38.ViewModel:StopAnimation("BladeAttackOnHit")
    end)
    p_u_38:GetDataChangedSignal("Mode"):Connect(function()
        task.spawn(p_u_38.Input, p_u_38, "FinishAiming")
        p_u_38._blade_attack_num = p_u_38:Get("Mode") == "Blade" and 0 or p_u_38._blade_attack_num
        p_u_38._transition_cooldown = tick() + p_u_38.Info.TransitionCooldown - 0.1
        p_u_38:_ModeChanged()
    end)
    p_u_38:_ModeChanged(true)
end
return v_u_5