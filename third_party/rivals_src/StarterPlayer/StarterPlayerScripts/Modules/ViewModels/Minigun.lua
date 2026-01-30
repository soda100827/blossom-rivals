local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("RunService")
local v3 = game:GetService("Players")
local v_u_4 = require(v1.Modules.AnimationLibrary)
local v_u_5 = require(v1.Modules.Utility)
local v_u_6 = require(v3.LocalPlayer.PlayerScripts.Controllers:WaitForChild("CameraController"))
local v_u_7 = require(v3.LocalPlayer.PlayerScripts.Modules:WaitForChild("ClientReplicatedClasses"):WaitForChild("ClientFighter"):WaitForChild("ClientItem"):WaitForChild("ClientViewModel"))
local v_u_8 = setmetatable({}, v_u_7)
v_u_8.__index = v_u_8
function v_u_8.new(...)
    local v9 = v_u_7.new(...)
    local v10 = v_u_8
    local v11 = setmetatable(v9, v10)
    v11.IsChargingMinigun = false
    v11.IsWindingMinigun = false
    v11._active_shooting_finish = 0
    v11._last_winding_sounds = nil
    v11._last_shooting_sounds = nil
    v11._last_ammo_belt_count = 20
    v11._ammo_belt_models = {}
    v11:_Init()
    return v11
end
function v_u_8.StartChargingMinigun(p12)
    local v13 = tick()
    local v14 = v_u_6:GetLastHeartbeatDeltaTime() * 3
    p12._active_shooting_finish = v13 + math.max(0.1, v14)
    p12:_ChargeLoop(true)
end
function v_u_8.Unequip(p15, ...)
    p15:StopAnimation("ChargeStart")
    p15:StopAnimation("ChargeLoop")
    p15:StopAnimation("ChargeFinish", nil, 0)
    v_u_7.Unequip(p15, ...)
end
function v_u_8._CreateMinigunShootingSounds(p16)
    local v17 = p16:CreateSound("rbxassetid://17246880027", 8.75, 1, true)
    v17.TimePosition = 0.25 + 0.25 * math.random()
    v17.Looped = true
    return { v17 }
end
function v_u_8._CreateMinigunWindingSounds(p18)
    local v19 = p18:CreateSound("rbxassetid://17251084003", 0.5, 1, true)
    v19.TimePosition = 2
    v19.Looped = true
    return { v19 }
end
function v_u_8._UpdateAmmoBelt(p20)
    local v21 = p20.ClientItem:Get("Ammo")
    if p20._last_ammo_belt_count ~= v21 then
        p20._last_ammo_belt_count = v21
        for v22, v23 in pairs(p20._ammo_belt_models) do
            for _, v24 in pairs(v23) do
                p20:_LocalTransparencyModifier(v24, "AmmoVisual", p20._last_ammo_belt_count < v22 and 1 or 0)
            end
        end
    end
end
function v_u_8._ChargeLoop(p25, p26)
    if p25.IsChargingMinigun then
        return
    end
    p25.IsChargingMinigun = true
    p25:StopAnimation("ChargeFinish")
    local v_u_27 = p25:_CreateMinigunWindingSounds()
    local v28 = {}
    for _, v29 in pairs(v_u_27) do
        v28[v29] = {
            ["Volume"] = v29.Volume,
            ["PlaybackSpeed"] = v29.PlaybackSpeed
        }
        v29.Volume = 0
    end
    if p25._last_winding_sounds then
        for _, v30 in pairs(p25._last_winding_sounds) do
            v30:Destroy()
        end
    end
    p25._last_winding_sounds = v_u_27
    if p26 then
        local v31 = p25.ClientItem.Info.ChargingWindUpLength
        local v32 = tick() + v31
        p25:PlayAnimation("ChargeStart", v_u_4.Info[p25.Info.Animations.ChargeStart].Length)
        p25.IsWindingMinigun = true
        while not p25._destroyed and (p25._is_equipped and (tick() < v32 and (tick() < p25._active_shooting_finish or p25.ClientItem:Get("IsAiming")))) do
            local v33 = (v31 - (v32 - tick())) / v31
            local v34 = math.clamp(v33, 0, 1)
            for _, v35 in pairs(v_u_27) do
                v35.Volume = v28[v35].Volume * v34
                v35.PlaybackSpeed = v28[v35].PlaybackSpeed * (v34 * 1.5 + 1)
            end
            v_u_2.RenderStepped:Wait()
        end
        p25.IsWindingMinigun = false
    end
    for v36 = 1, (1 / 0) do
        if p25._destroyed or (not p25._is_equipped or tick() > p25._active_shooting_finish and not p25.ClientItem:Get("IsAiming")) then
            break
        end
        if v36 == 1 then
            p25:PlayAnimation("ChargeLoop", (1 / 0))
            for _, v37 in pairs(v_u_27) do
                v37.Volume = v28[v37].Volume
                v37.PlaybackSpeed = v28[v37].PlaybackSpeed * 2.5
            end
        end
        v_u_2.RenderStepped:Wait()
    end
    p25.IsChargingMinigun = false
    p25:StopAnimation("ChargeStart")
    p25:StopAnimation("ChargeLoop")
    if p25._is_equipped then
        p25:PlayAnimation("ChargeFinish", v_u_4.Info[p25.Info.Animations.ChargeFinish].Length)
    end
    local v_u_38 = {}
    for _, v39 in pairs(v_u_27) do
        v_u_38[v39] = {
            ["Volume"] = v39.Volume,
            ["PlaybackSpeed"] = v39.PlaybackSpeed
        }
    end
    v_u_5:RenderstepForLoop(0, 100, 1.5, function(p40)
        local v41 = p40 / 100
        for _, v42 in pairs(v_u_27) do
            v42.Volume = v_u_38[v42].Volume + (0 - v_u_38[v42].Volume) * (1 - (1 - v41) ^ 4)
            v42.PlaybackSpeed = v_u_38[v42].PlaybackSpeed + (1 - v_u_38[v42].PlaybackSpeed) * v41
        end
    end)
    for _, v43 in pairs(v_u_27) do
        v43:Destroy()
    end
end
function v_u_8._Setup(p_u_44)
    local v45 = p_u_44.ItemModel:FindFirstChild("_ammo_belt", true)
    if v45 then
        for v46 = 1, 20 do
            local v47 = v45:WaitForChild(v46)
            p_u_44._ammo_belt_models[v46] = { v47:FindFirstChild("Shell"), v47:FindFirstChild("Strap") }
        end
    end
    task.defer(function()
        p_u_44.ClientItem.Shot:Connect(function()
            p_u_44._active_shooting_finish = tick() + 0.1
            if not p_u_44._last_shooting_sounds then
                p_u_44._last_shooting_sounds = p_u_44:_CreateMinigunShootingSounds()
                task.spawn(function()
                    while not p_u_44._destroyed and tick() < p_u_44._active_shooting_finish do
                        v_u_2.RenderStepped:Wait()
                    end
                    for _, v48 in pairs(p_u_44._last_shooting_sounds) do
                        v48:Destroy()
                    end
                    p_u_44._last_shooting_sounds = nil
                end)
            end
            p_u_44:_ChargeLoop()
        end)
    end)
end
function v_u_8._Init(p_u_49)
    p_u_49.ClientItem:GetDataChangedSignal("IsAiming"):Connect(function(p50)
        if p50 then
            p_u_49:_ChargeLoop(true)
        end
    end)
    p_u_49.ClientItem:GetDataChangedSignal("Ammo"):Connect(function()
        p_u_49:_UpdateAmmoBelt()
    end)
    p_u_49:_Setup()
    p_u_49:_UpdateAmmoBelt()
end
return v_u_8