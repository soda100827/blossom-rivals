local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
require(v1.Modules.Utility)
local v_u_3 = require(v2.LocalPlayer.PlayerScripts.Modules.ItemTypes.Melee)
local v_u_4 = setmetatable({}, v_u_3)
v_u_4.__index = v_u_4
function v_u_4.new(...)
    local v5 = v_u_3.new(...)
    local v6 = v_u_4
    local v7 = setmetatable(v5, v6)
    v7._heavy_attack_num = 0
    v7._backstab_hash = 0
    v7._fov_offset_speed = 1
    v7:_Init()
    return v7
end
function v_u_4.GetAimSpeed(p8)
    return p8._fov_offset_speed
end
function v_u_4.StartAiming(p_u_9, p10, p11)
    if not p10 and (tick() < p_u_9._attack_cooldown or p_u_9:IsEquipping()) then
        return false
    end
    p_u_9._attack_cooldown = tick() + p_u_9.Info.HeavyAttackCooldown
    if p_u_9._last_attack_animation_name then
        p_u_9.ViewModel:StopAnimation(p_u_9._last_attack_animation_name)
    end
    p_u_9._heavy_attack_num = p_u_9._heavy_attack_num % #p_u_9.ViewModel:GetAnimationKeys("HeavyAttack") + 1
    local v12 = p11 and p_u_9:FromEnum(p11) or "HeavyAttack" .. p_u_9._heavy_attack_num
    p_u_9._last_attack_animation_name = v12
    p_u_9.ViewModel:StopAnimation("HeavyAttackAnimationHit")
    p_u_9.ViewModel:StopAnimation("Equip")
    p_u_9.ViewModel:PlayAnimation(v12, p_u_9.Info.HeavyAttackCooldown)
    task.delay(0.1, function()
        p_u_9:_Shake("Bump")
    end)
    local v13, v14 = p_u_9.ClientFighter:GetCameraData()
    if p_u_9.ClientFighter.IsLocalPlayer then
        p_u_9:_ImpactMarkerSlash(p_u_9.Info.HeavyAttackReach, v13, v14)
    end
    if p_u_9.ItemInterface then
        p_u_9.ItemInterface:CooldownEffect("rbxassetid://133090003053503", p_u_9.Info.HeavyAttackCooldown, "HeavyAttack")
    end
    if p_u_9:Get("DashOnAim") then
        if not p10 then
            local v15 = p_u_9.ClientFighter:GetMoveVector(true, false, workspace.CurrentCamera.CFrame.LookVector) * 100
            p_u_9.ClientFighter.Entity:HardDash(v15, 0.25)
        end
        p_u_9:CreateSound("rbxassetid://16492958314", 1, 1 + 0.1 * math.random(), true)
    end
    return true, "StartAiming", v13, p_u_9:ToEnum(v12)
end
function v_u_4.ReplicateFromServer(p16, p17, ...)
    if p17 == "BackstabEffect" then
        if p16:IsRendered() then
            p16._backstab_hash = p16._backstab_hash + 1
            local v18 = p16._backstab_hash
            p16._fov_offset_speed = 5
            p16:SetReplicate("FOVOffset", -10)
            wait(0.25)
            if p16._backstab_hash == v18 then
                p16._fov_offset_speed = 1
                p16:SetReplicate("FOVOffset", 0)
            end
        else
            return
        end
    else
        v_u_3.ReplicateFromServer(p16, p17, ...)
        return
    end
end
function v_u_4._Setup(p_u_19)
    function p_u_19._on_attack_callback()
        p_u_19.ViewModel:StopAnimation("HeavyAttackAnimationHit")
    end
end
function v_u_4._Init(p20)
    p20:_Setup()
end
return v_u_4