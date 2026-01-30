local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.Utility)
local v_u_4 = require(v2.LocalPlayer.PlayerScripts.Modules.ItemTypes.Throwable)
local v_u_5 = setmetatable({}, v_u_4)
v_u_5.__index = v_u_5
function v_u_5.new(...)
    local v6 = v_u_4.new(...)
    local v7 = v_u_5
    local v8 = setmetatable(v6, v7)
    v8._detonate_cooldown = 0
    v8._detonate_animation_cooldown = 0
    v8:_Init()
    return v8
end
function v_u_5.CanQuickAttack(p9)
    return v_u_4.CanQuickAttack(p9) or p9:Get("NumSatchels") > 0
end
function v_u_5.StartShooting(p10, p11)
    if p11 or ((p10:Get("Ammo") or (1 / 0)) > 0 or p10:Get("NumSatchels") <= 0) then
        return v_u_4.StartShooting(p10, p11)
    else
        return p10:StartAiming(p11)
    end
end
function v_u_5.StartAiming(p12, p13)
    if not p13 and p12:IsEquipping() then
        return false
    end
    if p13 or tick() > p12._detonate_animation_cooldown then
        p12._detonate_animation_cooldown = tick() + 0.25
        p12.ViewModel:PlayAnimation("Detonate")
    end
    if not p13 and (p12:Get("NumSatchels") <= 0 or tick() < p12._detonate_cooldown) then
        return false
    end
    p12._detonate_cooldown = tick() + 0.25
    return true, "StartAiming"
end
function v_u_5.FinishAiming(_, _)
    return false
end
function v_u_5.ReplicateFromServer(p14, p15, ...)
    if p15 == "SatchelAttached" then
        if p14:IsRendered() then
            v_u_3:CreateSound("rbxassetid://128061013194700", 0.1, 1, ..., true, 5)
        end
    else
        v_u_4.ReplicateFromServer(p14, p15, ...)
        return
    end
end
function v_u_5._Init(_) end
return v_u_5