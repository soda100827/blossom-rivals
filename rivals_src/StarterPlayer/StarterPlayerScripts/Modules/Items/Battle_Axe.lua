local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
require(v1.Modules.AnimationLibrary)
require(v1.Modules.BetterDebris)
local v_u_3 = require(v2.LocalPlayer.PlayerScripts.Modules.ItemTypes.Melee)
local v_u_4 = setmetatable({}, v_u_3)
v_u_4.__index = v_u_4
function v_u_4.new(...)
    local v5 = v_u_3.new(...)
    local v6 = v_u_4
    local v7 = setmetatable(v5, v6)
    v7._spin_cooldown = 0
    v7:_Init()
    return v7
end
function v_u_4.CanQuickAttack(p8)
    local v9
    if tick() > p8._spin_cooldown then
        v9 = not p8:IsEquipping()
    else
        v9 = false
    end
    return v9
end
function v_u_4.StartAiming(p10, p11)
    if p11 or tick() >= p10._spin_cooldown and (tick() >= p10._attack_cooldown and not p10:IsEquipping()) then
        p10._spin_cooldown = tick() + p10.Info.SpinCooldown
        p10._attack_cooldown = tick() + p10.Info.SpinDuration + 0.5
        if not p11 then
            local v12 = workspace.CurrentCamera.CFrame.LookVector:FuzzyEq(Vector3.new(0, 1, 0)) and Vector3.new(0, 0, 0) or (workspace.CurrentCamera.CFrame.LookVector * Vector3.new(1, 0, 1)).Unit
            local v13 = p10.ClientFighter:GetMoveVector(true, true, v12) * p10.Info.SpinSpeed
            p10.ClientFighter.Entity:HardDash(v13, p10.Info.SpinDuration, true, Vector3.new(0, 0.625, 0))
        end
        if p10.ItemInterface then
            p10.ItemInterface:CooldownEffect("rbxassetid://16828140099", p10.Info.SpinCooldown, "Spin")
            p10.ItemInterface:PlaySpeedLines(p10.Info.SpinDuration)
        end
        if p10._last_attack_animation_name then
            p10.ViewModel:StopAnimation(p10._last_attack_animation_name)
        end
        p10.ViewModel:StopAnimation("Equip")
        p10.ViewModel:PlayAnimation("SpinAttack", 1)
        p10.ViewModel:PlaySpinParticles()
        p10:_Shake("BattleAxeSpin")
        return true, "StartAiming", p10.ClientFighter:GetCameraData()
    end
end
function v_u_4._Setup(p_u_14)
    function p_u_14._on_attack_callback()
        p_u_14.ViewModel:StopAnimation("SpinAttack")
    end
end
function v_u_4._Init(p15)
    p15:_Setup()
end
return v_u_4