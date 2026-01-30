local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.AnimationLibrary)
require(v1.Modules.BetterDebris)
local v_u_4 = require(v1.Modules.Utility)
local v_u_5 = require(v2.LocalPlayer.PlayerScripts.Controllers.ControlsController)
local v_u_6 = require(v2.LocalPlayer.PlayerScripts.Modules.ItemTypes.Melee)
local v_u_7 = setmetatable({}, v_u_6)
v_u_7.__index = v_u_7
function v_u_7.new(...)
    local v8 = v_u_6.new(...)
    local v9 = v_u_7
    local v10 = setmetatable(v8, v9)
    v10._build_cooldown = 0
    v10:_Init()
    return v10
end
function v_u_7.CanQuickAttack(p11)
    local v12
    if v_u_5.CurrentControls == "Touch" then
        if tick() > p11._build_cooldown then
            return not p11:IsEquipping()
        end
        v12 = false
    else
        v12 = v_u_6.CanQuickAttack(p11)
    end
    return v12
end
function v_u_7.StartAiming(p13, p14)
    if not p14 and (tick() < p13._build_cooldown or p13:IsEquipping()) then
        return false
    end
    local _, v15 = p13.ClientFighter:GetCameraData()
    p13._build_cooldown = tick() + p13.Info.BuildCooldown
    if p13.ItemInterface then
        p13.ItemInterface:CooldownEffect("rbxassetid://17132668997", p13.Info.BuildCooldown, "Build")
    end
    p13.ViewModel:PlayAnimation("Build", v_u_3.Info[p13.ViewModel.Info.Animations.Build].Length)
    return true, "StartAiming", v15.Position
end
function v_u_7.FinishAiming(_, _)
    return false
end
function v_u_7.ReplicateFromServer(p16, p17, ...)
    if p17 == "HardenEffect" then
        if p16:IsRendered() then
            v_u_4:CreateSound("rbxassetid://17138809559", 1.25, 1 + 0.2 * math.random(), ..., true, 5)
        end
    elseif p17 == "ThrowEffect" then
        if p16:IsRendered() then
            v_u_4:CreateSound("rbxassetid://14522189766", 1.25, 2 + 0.25 * math.random(), ..., true, 5)
        end
    else
        v_u_6.ReplicateFromServer(p16, p17, ...)
        return
    end
end
function v_u_7._Setup(p_u_18)
    function p_u_18._on_attack_callback()
        p_u_18.ViewModel:StopAnimation("Build")
    end
end
function v_u_7._Init(p19)
    p19:_Setup()
end
return v_u_7