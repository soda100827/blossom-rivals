local v1 = game:GetService("ReplicatedStorage")
game:GetService("RunService")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.AnimationLibrary)
local v_u_4 = require(v1.Modules.Utility)
local v_u_5 = require(v2.LocalPlayer.PlayerScripts.Modules.ItemTypes.Melee)
local v_u_6 = setmetatable({}, v_u_5)
v_u_6.__index = v_u_6
function v_u_6.new(...)
    local v7 = v_u_5.new(...)
    local v8 = v_u_6
    local v9 = setmetatable(v7, v8)
    v9._is_holding = false
    v9._hold_hash = 0
    v9._hold_sounds = nil
    v9._hold_sounds_progress = 0
    v9._hold_particles = {}
    v9:_Init()
    return v9
end
function v_u_6.StartAiming(p_u_10, p11)
    if not p11 and (p_u_10._is_holding or (tick() < p_u_10._attack_cooldown or (p_u_10:Get("Ammo") <= 0 or p_u_10:IsEquipping()))) then
        return false
    end
    p_u_10._is_holding = true
    p_u_10._attack_cooldown = (1 / 0)
    if p_u_10._last_attack_animation_name then
        p_u_10.ViewModel:StopAnimation(p_u_10._last_attack_animation_name)
    end
    p_u_10.ViewModel:StopAnimation(p_u_10.ViewModel.Animator:GetEquipAnimationKey(), 0)
    p_u_10.ViewModel:PlayAnimation("HoldStart", (1 / 0), 0.1)
    p_u_10.ViewModel:StopAnimation("HoldFinish", 0.1)
    p_u_10._hold_hash = p_u_10._hold_hash + 1
    local v_u_12 = p_u_10._hold_hash
    task.spawn(function()
        local v13 = tick()
        local v14 = nil
        local v15 = nil
        while p_u_10._is_holding and v_u_12 == p_u_10._hold_hash do
            local v16 = p_u_10.Info.HoldSpeedBoostMin
            local v17 = p_u_10.Info.HoldSpeedBoostMax - p_u_10.Info.HoldSpeedBoostMin
            local v18 = (tick() - v13) / p_u_10.Info.HoldSpeedBoostRampTime
            local v19 = v16 + v17 * math.clamp(v18, 0, 1)
            p_u_10.ClientFighter.Entity:SetBoost("Speed", "ChainsawHold", 0.3, v19)
            p_u_10:_Shake("ChainsawHold")
            if v14 and v14 == p_u_10:Get("Ammo") then
                if tick() - v15 > 0.25 then
                    p_u_10:Input("FinishAiming")
                    return
                end
            else
                v14 = p_u_10:Get("Ammo")
                v15 = tick()
            end
            wait(0.1)
        end
    end)
    task.spawn(function()
        wait(v_u_3.Info[p_u_10.ViewModel.Info.Animations.HoldStart].Length)
        if v_u_12 == p_u_10._hold_hash then
            p_u_10.ViewModel:PlayAnimation("HoldLoop", (1 / 0), 0)
            p_u_10.ViewModel:EnableParticles(true)
        end
    end)
    if not p_u_10._hold_sounds then
        p_u_10._hold_sounds = {}
        for _, v20 in pairs(p_u_10.ViewModel:CreateHoldSounds()) do
            p_u_10._hold_sounds[v20] = v20.Volume
            v20.Looped = true
        end
        p_u_10.ViewModel:PlayStartingHoldSounds()
    end
    task.spawn(v_u_4.RenderstepForLoop, v_u_4, p_u_10._hold_sounds_progress, 100, 25, function(p21)
        if v_u_12 ~= p_u_10._hold_hash then
            return true
        end
        p_u_10._hold_sounds_progress = p21
        for v22, v23 in pairs(p_u_10._hold_sounds) do
            v22.Volume = v23 * p21 / 100
        end
    end)
    return true, "StartAiming"
end
function v_u_6.FinishAiming(p24, p25)
    if p25 or p24._is_holding then
        p24:_StopHolding(true)
        return true, "FinishAiming"
    end
end
function v_u_6.Equip(p26)
    v_u_5.Equip(p26)
    p26:_StopHolding()
end
function v_u_6.Unequip(p27)
    p27:_StopHolding(true)
    v_u_5.Unequip(p27)
end
function v_u_6.ReplicateFromServer(p28, p29, ...)
    if p29 == "StopHolding" then
        p28:_StopHolding(true)
    else
        v_u_5.ReplicateFromServer(p28, p29, ...)
    end
end
function v_u_6.Destroy(p30)
    p30:_StopHolding()
    v_u_5.Destroy(p30)
end
function v_u_6._StopHolding(p_u_31, p32)
    local v33 = p_u_31._is_holding
    p_u_31._hold_hash = p_u_31._hold_hash + 1
    p_u_31._is_holding = false
    p_u_31._attack_cooldown = p32 and 0 or p_u_31._attack_cooldown
    if p_u_31.ClientFighter.Entity then
        p_u_31.ClientFighter.Entity:RemoveBoost("ChainsawHold")
    end
    if v33 then
        p_u_31.ViewModel:PlayAnimation("HoldFinish", v_u_3.Info[p_u_31.ViewModel.Info.Animations.HoldFinish].Length, 0.1)
    end
    p_u_31.ViewModel:StopAnimation("HoldStart", 0.1)
    p_u_31.ViewModel:StopAnimation("HoldLoop", 0.1)
    if p_u_31._hold_sounds then
        local v_u_34 = p_u_31._hold_hash
        task.spawn(function()
            v_u_4:RenderstepForLoop(p_u_31._hold_sounds_progress, 0, -10, function(p35)
                if v_u_34 ~= p_u_31._hold_hash then
                    return true
                end
                p_u_31._hold_sounds_progress = p35
                for v36, v37 in pairs(p_u_31._hold_sounds) do
                    v36.Volume = v37 * (p35 / 100) ^ 2
                end
            end)
            if v_u_34 == p_u_31._hold_hash then
                for v38 in pairs(p_u_31._hold_sounds) do
                    v38:Destroy()
                end
                p_u_31._hold_sounds = nil
            end
        end)
    end
    p_u_31.ViewModel:EnableParticles(false)
end
function v_u_6._Setup(p_u_39)
    function p_u_39._on_attack_callback()
        p_u_39.ViewModel:StopAnimation("HoldFinish")
    end
end
function v_u_6._Init(p_u_40)
    local v41 = p_u_40._connections
    local v42 = p_u_40.ClientFighter.Interrupted
    table.insert(v41, v42:Connect(function()
        if p_u_40._is_holding then
            p_u_40:_StopHolding(true)
        end
    end))
    p_u_40:_Setup()
end
return v_u_6