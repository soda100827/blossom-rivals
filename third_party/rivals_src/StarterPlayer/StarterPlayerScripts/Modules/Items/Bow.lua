local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.AnimationLibrary)
local v_u_4 = require(v2.LocalPlayer.PlayerScripts.Modules.ItemTypes.Gun)
local v_u_5 = setmetatable({}, v_u_4)
v_u_5.__index = v_u_5
function v_u_5.new(...)
    local v6 = v_u_4.new(...)
    local v7 = v_u_5
    local v8 = setmetatable(v6, v7)
    v8.ToggleAimEnabled = nil
    v8._is_charging = false
    v8._charge_hash = 0
    v8:_Init()
    return v8
end
function v_u_5.StartAiming(p_u_9, p10)
    if not p10 then
        if p_u_9._is_charging or (tick() < p_u_9._shoot_cooldown or (tick() < p_u_9._reload_cooldown or (tick() < p_u_9._shoot_cooldown_no_ammo or p_u_9:IsEquipping()))) then
            return false
        end
        if p_u_9:Get("Ammo") <= 0 then
            local v11 = { p_u_9:StartReloading() }
            if v11[1] then
                return table.unpack(v11)
            end
            p_u_9._shoot_cooldown_no_ammo = tick() + p_u_9.Info.ShootCooldown
            p_u_9:CreateSound("rbxassetid://13087319223", 1, 1, true, 5)
            return false
        end
    end
    local v_u_12 = p_u_9.Info.ChargeLevelTimestamps
    p_u_9._is_charging = true
    p_u_9._shoot_cooldown = (1 / 0)
    p_u_9._reload_cooldown = (1 / 0)
    p_u_9:_StartAimAssist()
    p_u_9._on_shoot_callback()
    p_u_9.ViewModel:PlayAnimation("Charge", (1 / 0), 0.1)
    if p_u_9.ItemInterface then
        p_u_9.ItemInterface.Charge:Set(1)
        p_u_9.ItemInterface.Charge:Start(v_u_12)
    end
    p_u_9._charge_hash = p_u_9._charge_hash + 1
    local v_u_13 = p_u_9._charge_hash
    task.spawn(function()
        for v14, v15 in pairs(v_u_12) do
            if v15 > 0 then
                wait(v15 - (v_u_12[v14 - 1] or 0))
                if v_u_13 ~= p_u_9._charge_hash then
                    return
                end
                p_u_9:SetReplicate("FOVOffset", 5 * (v14 - 1))
                p_u_9.ViewModel:PlayChargeEffect(v14)
                if p_u_9.ItemInterface then
                    p_u_9.ItemInterface.Charge:Set(v14)
                    p_u_9.ItemInterface.Charge:Play()
                end
            end
        end
    end)
    task.spawn(function()
        wait(v_u_3.Info[p_u_9.ViewModel.Info.Animations.Charge].Length)
        if v_u_13 == p_u_9._charge_hash then
            p_u_9.ViewModel:PlayAnimation("ChargeLoop", (1 / 0), 0)
        end
    end)
    return true, "StartAiming"
end
function v_u_5.FinishAiming(p16, p17)
    if not (p17 or p16._is_charging) then
        return false
    end
    p16:_StopCharging()
    return true, "FinishAiming", p16.ClientFighter:GetCameraData()
end
function v_u_5.StartSprinting(_, _)
    return false
end
function v_u_5.Unequip(p18, ...)
    task.spawn(p18.Input, p18, "FinishAiming")
    task.defer(p18._StopCharging, p18, true)
    v_u_4.Unequip(p18, ...)
end
function v_u_5._StopCharging(p19, p20)
    local v21 = p19.Info.ChargeReleaseCooldown
    p19._is_charging = false
    p19._charge_hash = p19._charge_hash + 1
    p19._shoot_cooldown = tick() + v21
    p19._reload_cooldown = tick() + v21
    p19:_FinishAimAssist()
    p19:SetReplicate("FOVOffset", 0)
    if not p20 then
        p19.ViewModel:PlayAnimation("ChargeRelease", v21, 0)
    end
    p19.ViewModel:StopAnimation("ChargeLoop", 0.1)
    p19.ViewModel:StopAnimation("Charge", 0.1)
    if p19.ItemInterface then
        p19.ItemInterface.Charge:Stop(p20)
    end
end
function v_u_5._Setup(p_u_22)
    function p_u_22._on_shoot_callback()
        p_u_22.ViewModel:StopAnimation("ChargeLoop", 0)
        p_u_22.ViewModel:StopAnimation("ChargeRelease", 0)
    end
end
function v_u_5._Init(p_u_23)
    local v24 = p_u_23._connections
    local v25 = p_u_23.ClientFighter.Interrupted
    table.insert(v24, v25:Connect(function()
        p_u_23:_StopCharging(true)
    end))
    p_u_23:_Setup()
end
return v_u_5