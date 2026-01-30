local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.AnimationLibrary)
local v_u_4 = require(v2.LocalPlayer.PlayerScripts.Modules.ItemTypes.Custom)
local v_u_5 = setmetatable({}, v_u_4)
v_u_5.__index = v_u_5
function v_u_5.new(...)
    local v6 = v_u_4.new(...)
    local v7 = v_u_5
    local v8 = setmetatable(v6, v7)
    v8._use_cooldown = 0
    v8._use_hash = 0
    v8:_Init()
    return v8
end
function v_u_5.GetAutoShootReactionTime(_)
    return nil
end
function v_u_5.CanQuickAttack(p9)
    local v10
    if tick() > p9._use_cooldown then
        v10 = not p9:IsEquipping()
    else
        v10 = false
    end
    return v10
end
function v_u_5.StartShooting(p11, p12)
    if not p12 and (tick() < p11._use_cooldown or p11:IsEquipping()) then
        return false
    end
    p11._use_cooldown = tick() + p11.Info.Cooldown
    p11.ViewModel:PlayAnimation("Use", v_u_3.Info[p11.ViewModel.Info.Animations.Use].Length)
    p11.ViewModel:PlayHornEffect()
    if p11.ItemInterface then
        p11.ItemInterface:CooldownEffect("rbxassetid://17156089790", p11.Info.Cooldown, "Use")
    end
    return true, "StartShooting"
end
function v_u_5.Unequip(p13, ...)
    p13._use_hash = p13._use_hash + 1
    v_u_4.Unequip(p13, ...)
end
function v_u_5._CancelUse(p14)
    p14._is_using = false
    p14._use_hash = p14._use_hash + 1
    p14.ViewModel:StopAnimation("Use")
    p14.ViewModel:StopAnimation("UseQuick")
    if p14.ItemInterface then
        p14.ItemInterface:StopCooldownEffect("Healing")
    end
end
function v_u_5._Init(_) end
return v_u_5