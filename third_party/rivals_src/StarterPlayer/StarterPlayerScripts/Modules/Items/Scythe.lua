local v1 = game:GetService("ReplicatedStorage")
game:GetService("RunService")
local v2 = game:GetService("Players")
require(v1.Modules.BetterDebris)
local v_u_3 = require(v2.LocalPlayer.PlayerScripts.Controllers.ControlsController)
local v_u_4 = require(v2.LocalPlayer.PlayerScripts.Modules.ItemTypes.Melee)
local v_u_5 = setmetatable({}, v_u_4)
v_u_5.__index = v_u_5
function v_u_5.new(...)
    local v6 = v_u_4.new(...)
    local v7 = v_u_5
    local v8 = setmetatable(v6, v7)
    v8._dash_cooldown = 0
    v8:_Init()
    return v8
end
function v_u_5.CanQuickAttack(p9)
    local v10
    if v_u_3.CurrentControls == "Touch" then
        if tick() > p9._dash_cooldown then
            return not p9:IsEquipping()
        end
        v10 = false
    else
        v10 = v_u_4.CanQuickAttack(p9)
    end
    return v10
end
function v_u_5.StartAiming(p11, p12)
    if not p12 and (tick() < p11._dash_cooldown or p11:IsEquipping()) then
        return false
    end
    p11._dash_cooldown = tick() + p11.Info.DashCooldown
    p11.ViewModel:StopAnimation("Inspect")
    if p11.ViewModel:GetAnimationTrack("Dash") then
        p11.ViewModel:PlayAnimation("Dash")
    end
    if not p12 then
        local v13 = p11.ClientFighter:GetMoveVector(true, false, workspace.CurrentCamera.CFrame.LookVector) * p11.Info.DashSpeed
        p11.ClientFighter.Entity:HardDash(v13, p11.Info.DashDuration)
    end
    p11:CreateSound("rbxassetid://16492958314", 1, 1 + 0.1 * math.random(), true)
    if p11.ItemInterface then
        p11.ItemInterface:CooldownEffect("rbxassetid://16828140099", p11.Info.DashCooldown, "Dash")
        p11.ItemInterface:PlaySpeedLines(p11.Info.DashDuration)
    end
    return true, "StartAiming"
end
function v_u_5.FinishAiming(_, _)
    return false
end
function v_u_5._Setup(p_u_14)
    function p_u_14._on_attack_callback()
        p_u_14.ViewModel:StopAnimation("Dash", 0)
    end
end
function v_u_5._Init(p15)
    p15:_Setup()
end
return v_u_5