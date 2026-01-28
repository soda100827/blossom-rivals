local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("RunService")
local v_u_3 = game:GetService("Players")
local v_u_4 = require(v1.Modules.CONSTANTS)
local v_u_5 = require(v1.Modules.AnimationLibrary)
local v_u_6 = require(v1.Modules.GameplayUtility)
local v_u_7 = require(v1.Modules.BetterDebris)
local v_u_8 = require(v1.Modules.Utility)
local v_u_9 = require(v1.Modules.Spring)
local v_u_10 = require(v1.Modules.Signal)
local v_u_11 = require(v_u_3.LocalPlayer.PlayerScripts.Controllers.WrapController)
local v_u_12 = require(v_u_3.LocalPlayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientFighter.ClientItem)
local v_u_13 = require(v_u_3.LocalPlayer.PlayerScripts.Modules.TracerEffect)
local v_u_14 = v_u_3.LocalPlayer.PlayerScripts.Assets:WaitForChild("Projectiles")
local v_u_15 = setmetatable({}, v_u_12)
v_u_15.__index = v_u_15
function v_u_15.new(...)
    local v16 = v_u_12.new(...)
    local v17 = v_u_15
    local v18 = setmetatable(v16, v17)
    v18.Shot = v_u_10.new()
    v18.ProjectileShot = v_u_10.new()
    v18.ToggleAimEnabled = true
    v18.Data.IsAiming = false
    v18._last_shot = 0
    v18._burst_count = 0
    v18._shoot_cooldown = 0
    v18._is_revolver_quick_shooting = nil
    v18._shoot_animation_num = 1
    v18._last_shoot_animation_name = nil
    v18._shoot_cooldown_no_ammo = 0
    v18._on_shoot_callback = nil
    v18._reload_threads = {}
    v18._reload_cooldown = 0
    v18._reload_cancel_cooldown = 0
    v18._reload_cancel_expiration = 0
    v18._reload_delay = 0
    v18._local_tracers = {}
    v18._num_shooting_animations = #v18.ViewModel:GetAnimationKeys("Shoot")
    v18._on_reload_callback = nil
    v18._projectile_template = nil
    v18._projectile_part_to_model = {}
    v18._is_input_queueing = false
    v18:_Init()
    return v18
end
function v_u_15.CanQuickAttack(p19)
    local v20
    if tick() > p19._shoot_cooldown and p19:Get("Ammo") > 0 then
        v20 = not p19:IsEquipping()
    else
        v20 = false
    end
    return v20
end
function v_u_15.GetAutoShootReactionTime(p21)
    if p21.Info.ShootBurst > 1 then
        return (p21.Info.ShootBurstCooldown * p21.Info.ShootBurst) ^ 2
    else
        return p21.Info.ShootCooldown ^ 2
    end
end
function v_u_15.GetAimSpeed(p22)
    return p22:Get("IsAiming") and p22.Info.AimSpeed or 1
end
function v_u_15.IsFullyAiming(p23)
    return not (p23:Get("IsAiming") and p23.Info.AimScopePercent) or p23.ViewModel.CurrentAimValue >= p23.Info.AimScopePercent
end
function v_u_15.StartShooting(p_u_24, p25, p26)
    if tick() < (p_u_24._is_revolver_quick_shooting or 0) and not p26 then
        return false
    end
    local v27 = p_u_24:Get("Ammo")
    if not p25 then
        if tick() < p_u_24._shoot_cooldown_no_ammo or p_u_24:IsEquipping() then
            return false
        end
        if tick() < p_u_24._reload_cooldown and (tick() < p_u_24._reload_cancel_cooldown or (v27 <= 0 or tick() >= p_u_24._reload_cancel_expiration)) then
            return false
        end
        if p_u_24.Info.MaxAmmo and (v27 <= 0 and tick() > p_u_24._reload_delay) then
            local v28 = { p_u_24:StartReloading() }
            if v28[1] then
                return table.unpack(v28)
            end
            local v29 = tick()
            local v30 = p_u_24.Info.ShootCooldown
            p_u_24._shoot_cooldown_no_ammo = v29 + math.max(0.1, v30)
            p_u_24:CreateSound("rbxassetid://13087319223", 1, 1, true, 5)
            return false
        end
        if tick() < p_u_24._shoot_cooldown then
            if not p_u_24._is_input_queueing and (not p_u_24.Info.InputSpammingEnabled.StartShooting and p_u_24._shoot_cooldown - tick() < 0.1) then
                p_u_24._is_input_queueing = true
                task.delay(p_u_24._shoot_cooldown - tick(), function()
                    p_u_24._is_input_queueing = false
                    p_u_24:Input("StartShooting")
                end)
            end
            return false
        end
        if p_u_24.Name == "Minigun" and (p_u_24.ViewModel.IsWindingMinigun or not p_u_24.ViewModel.IsChargingMinigun) then
            task.defer(p_u_24.ViewModel.StartChargingMinigun, p_u_24.ViewModel)
            return false
        end
    end
    if p26 then
        p_u_24._is_revolver_quick_shooting = tick() + p_u_24.Info.QuickShotCooldown * p_u_24.Info.MaxAmmo
    end
    p_u_24.ViewModel:StopAnimation("Equip")
    p_u_24.ViewModel:StopAnimation("EquipEmpty")
    p_u_24:_ResetReloadState()
    p_u_24._burst_count = tick() - p_u_24._last_shot >= p_u_24.Info.ShootCooldown and 0 or p_u_24._burst_count
    p_u_24._burst_count = p_u_24._burst_count % p_u_24.Info.ShootBurst + 1
    p_u_24._last_shot = tick()
    local v31 = p_u_24:IsFullyAiming()
    local v32 = v27 + (p25 and 1 or 0)
    local v33 = p26 and p_u_24.Info.QuickShotCooldown or (p_u_24._burst_count < p_u_24.Info.ShootBurst and p_u_24.Info.ShootBurstCooldown or p_u_24.Info.ShootCooldown)
    p_u_24._shoot_cooldown = tick() + v33
    if p_u_24._num_shooting_animations > 0 then
        local v34 = p26 and "QuickShot" or (p_u_24.ViewModel.Info.Animations.FinalShoot and v32 == 1 and "FinalShoot" or (p_u_24.ViewModel.Info.Animations.ShootAiming and v31 and "ShootAiming" or "Shoot" .. p_u_24._shoot_animation_num))
        p_u_24._shoot_animation_num = p_u_24._num_shooting_animations == 0 and 0 or p_u_24._shoot_animation_num % p_u_24._num_shooting_animations + 1
        if p_u_24._last_shoot_animation_name then
            p_u_24.ViewModel:StopAnimation(p_u_24._last_shoot_animation_name)
        end
        p_u_24._last_shoot_animation_name = v34
        p_u_24.ViewModel:PlayAnimation(v34, v33, 0)
    end
    local v35 = p_u_24.ClientFighter:GetCameraData()
    if p_u_24._on_shoot_callback then
        p_u_24._on_shoot_callback(v35)
    end
    p_u_24:_Recoil(v31 and 0.5 or 1)
    p_u_24.ViewModel:MuzzleFlash()
    if v32 < (1 / 0) and v32 <= p_u_24.Info.MaxAmmo * 0.25 then
        p_u_24:CreateSound("rbxassetid://13087319223", 1, 1, true, 5)
    end
    if p_u_24.ClientFighter.IsLocalPlayer and (p_u_24.Info.IsRaycast and not p_u_24.Info.DisableTracerEffects) then
        p_u_24:_LocalTracers(v31, p26)
    end
    if p_u_24.Info.AimScopePercent or p_u_24.Name == "Shotgun" then
        task.defer(p_u_24.Input, p_u_24, "FinishAiming")
        p_u_24.ToggleOffMobileInputButton:Fire("mobile_aim")
    end
    p_u_24.Shot:Fire()
    local v36 = true
    local v37 = "StartShooting"
    if not v31 then
        if p26 then
            v31 = false
        else
            v31 = nil
        end
    end
    return v36, v37, v35, v31, p26
end
function v_u_15.StartReloading(p_u_38, p39, p40, p41)
    local v42 = p_u_38:Get("Ammo")
    local v43 = p_u_38:Get("AmmoReserve")
    if not p_u_38.Info.ReloadType then
        return false
    end
    if not p39 and (tick() < p_u_38._reload_cooldown or (p_u_38:IsEquipping() or not p_u_38.ClientFighter:Get("InfiniteAmmoReserve") and (v43 and v43 <= 0))) then
        return false
    end
    if p_u_38.Info.MaxAmmo <= v42 then
        return false
    end
    task.defer(p_u_38.Input, p_u_38, "FinishAiming")
    p_u_38.ToggleOffMobileInputButton:Fire("mobile_aim")
    p_u_38.ViewModel:StopAnimation("Equip")
    p_u_38.ViewModel:StopAnimation("EquipEmpty")
    if p_u_38._last_shoot_animation_name then
        p_u_38.ViewModel:StopAnimation(p_u_38._last_shoot_animation_name, 0)
    end
    p_u_38._is_revolver_quick_shooting = nil
    p_u_38._shoot_animation_num = 1
    p_u_38:_ResetReloadState()
    if p_u_38._on_reload_callback then
        p_u_38._on_reload_callback()
    end
    local v44 = v42 == 0
    local v_u_45 = p40 and p_u_38:FromEnum(p40) or (v44 and p_u_38.Info.HasEmptyReload and "EmptyReload" or "Reload")
    if p_u_38.Info.ReloadType == "Regular" then
        local v_u_46 = p_u_38.Info[v_u_45 .. "Length"]
        local v_u_47 = p_u_38.Info[v_u_45 .. "ActionTimestamp"]
        p_u_38._reload_cooldown = tick() + v_u_46
        p_u_38._reload_cancel_expiration = tick() + p_u_38.Info[v_u_45 .. "ActionTimestamp"]
        p_u_38._reload_cancel_cooldown = tick() + (not v44 and 0.25 or v_u_46)
        p_u_38.ViewModel:PlayAnimation(v_u_45, v_u_46, p_u_38.ViewModel.ShouldPlayReloadAnimationInstantly and 0 or 0.1)
        if p_u_38.ItemInterface then
            p_u_38.ItemInterface:CooldownEffect("rbxassetid://17139961241", v_u_47, "Reload", true)
        end
        local v48 = p_u_38._reload_threads
        local v49 = task.spawn
        table.insert(v48, v49(function()
            wait(v_u_47)
            if p_u_38.ItemInterface then
                p_u_38.ItemInterface:CooldownEffect("rbxassetid://17156089790", v_u_46 - v_u_47, "Reload")
            end
        end))
        return true, "StartReloading", p_u_38:ToEnum(v_u_45)
    end
    if p_u_38.Info.ReloadType ~= "Segmented" then
        return false
    end
    local v_u_50 = p_u_38.Info[v_u_45 .. "StartLength"]
    local v_u_51 = p_u_38.Info[v_u_45 .. "StartActionTimestamp"]
    local v_u_52 = p_u_38.Info[v_u_45 .. "SegmentLength"]
    local v_u_53 = p_u_38.Info[v_u_45 .. "SegmentActionTimestamp"]
    local v54 = p_u_38.Info[v_u_45 .. "FinishLength"]
    local v_u_55 = p_u_38.Info[v_u_45 .. "FinishActionTimestamp"]
    local v_u_56
    if p41 then
        v_u_56 = utf8.codepoint(p41)
    else
        local v57 = (p_u_38.ClientFighter:Get("InfiniteAmmoReserve") or not v43) and (1 / 0) or v43
        local v58 = p_u_38.Info.MaxAmmo - v42
        v_u_56 = math.min(v57, v58) - (v_u_51 and 1 or 0) - (v_u_55 and 1 or 0)
    end
    local v59 = v_u_50 + v_u_52 * v_u_56 + v54
    local v60 = v_u_51 or v_u_50 + v_u_53
    p_u_38._reload_cooldown = tick() + v59
    p_u_38._reload_cancel_expiration = (1 / 0)
    if not v44 then
        v60 = tick() + 0.25
    end
    p_u_38._reload_cancel_cooldown = v60
    local v61 = p_u_38._reload_threads
    local v62 = task.spawn
    table.insert(v61, v62(function()
        if p_u_38.ItemInterface and v_u_51 then
            p_u_38.ItemInterface:CooldownEffect("rbxassetid://17139961241", v_u_51, "Reload", true)
        end
        wait(v_u_50)
        for _ = 1, v_u_56 do
            if p_u_38.ItemInterface then
                p_u_38.ItemInterface:CooldownEffect("rbxassetid://17139961241", v_u_53, "Reload", true)
            end
            wait(v_u_52)
        end
        if p_u_38.ItemInterface and v_u_55 then
            p_u_38.ItemInterface:CooldownEffect("rbxassetid://17139961241", v_u_55, "Reload", true)
        end
    end))
    local v63 = p_u_38._reload_threads
    local v64 = task.spawn
    local function v68()
        local v65 = v_u_5.Info[p_u_38.ViewModel.Info.Animations[v_u_45 .. "Start"]].Length
        local v66 = v_u_5.Info[p_u_38.ViewModel.Info.Animations[v_u_45 .. "Segment"]].Length
        local v67 = v_u_5.Info[p_u_38.ViewModel.Info.Animations[v_u_45 .. "Finish"]].Length
        p_u_38.ViewModel:PlayAnimation(v_u_45 .. "Start", v65, p_u_38.ViewModel.ShouldPlayReloadAnimationInstantly and 0 or 0.1)
        wait(v65)
        for _ = 1, v_u_56 do
            p_u_38.ViewModel:PlayAnimation(v_u_45 .. "Segment", v66, 0)
            wait(v66)
        end
        p_u_38.ViewModel:PlayAnimation(v_u_45 .. "Finish", v67, 0)
    end
    table.insert(v63, v64(v68))
    return true, "StartReloading", p_u_38:ToEnum(v_u_45)
end
function v_u_15.StartAiming(p69, p70)
    if not p70 and (p69:Get("IsAiming") or (tick() < p69._reload_cooldown or p69:IsEquipping())) then
        return false
    end
    p69:SetReplicate("IsAiming", true)
    p69.StopSprinting:Fire()
    p69.ViewModel:SetAiming(true)
    p69:SetReplicate("FOVOffset", p69.Info.AimFOVOffset)
    p69:_StartAimAssist()
    if p69.ClientFighter:Get("IsSpectating") then
        p69:CreateSound("rbxassetid://13949557885", 1, 1, true, 5)
        if p69.ViewModel.PlayAimSound then
            p69.ViewModel:PlayAimSound(true)
        end
    end
    return true, "StartAiming"
end
function v_u_15.FinishAiming(p71, _)
    if not p71:Get("IsAiming") then
        return false
    end
    p71:_FinishAiming()
    p71.AttemptToSprintAgain:Fire()
    if p71.ClientFighter:Get("IsSpectating") then
        p71:CreateSound("rbxassetid://13949557844", 1, 1, true, 5)
        if p71.ViewModel.PlayAimSound then
            p71.ViewModel:PlayAimSound(false)
        end
    end
    return true, "FinishAiming"
end
function v_u_15.StartSprinting(p72, _)
    p72:Input("FinishAiming")
    return false
end
function v_u_15.Equip(p73, ...)
    v_u_12.Equip(p73, ...)
    p73._is_revolver_quick_shooting = nil
    p73._shoot_cooldown = p73._shoot_cooldown and p73._shoot_cooldown >= (1 / 0) and 0 or p73._shoot_cooldown
    p73:_ResetReloadState()
end
function v_u_15.Unequip(p74, ...)
    p74._is_revolver_quick_shooting = nil
    p74._shoot_cooldown = p74._shoot_cooldown and p74._shoot_cooldown >= (1 / 0) and 0 or p74._shoot_cooldown
    p74:_ResetReloadState()
    p74:_FinishAiming()
    p74.ViewModel:StopAnimation("Reload")
    p74.ViewModel:StopAnimation("EmptyReload")
    p74.ViewModel:StopAnimation("ReloadStart")
    p74.ViewModel:StopAnimation("ReloadSegment")
    p74.ViewModel:StopAnimation("ReloadFinish")
    p74.ViewModel:StopAnimation("EmptyReloadStart")
    p74.ViewModel:StopAnimation("EmptyReloadSegment")
    p74.ViewModel:StopAnimation("EmptyReloadFinish")
    v_u_12.Unequip(p74, ...)
end
function v_u_15.Update(p75, ...)
    v_u_12.Update(p75, ...)
    if p75.ItemInterface then
        local v76 = p75.Info.AimScopePercent
        if v76 then
            if p75.ViewModel.CurrentAimValue >= p75.Info.AimScopePercent then
                v76 = p75.ClientFighter:IsActuallyFirstPerson()
            else
                v76 = false
            end
        end
        if not p75.ItemInterface:IsScopeActive() and v76 then
            p75.ItemInterface:SetScopeActive(true)
            return
        end
        if p75.ItemInterface:IsScopeActive() and not v76 then
            p75.ItemInterface:SetScopeActive(false)
        end
    end
end
function v_u_15.ReplicateFromServer(p77, p78, ...)
    if p78 == "ShootEffect" then
        if p77:IsRendered() then
            p77:_ShootEffect(...)
        end
    elseif p78 == "ProjectileEffect" then
        if p77:IsRendered() then
            p77:_ProjectileEffect(...)
        end
    else
        v_u_12.ReplicateFromServer(p77, p78, ...)
        return
    end
end
function v_u_15.Destroy(p79)
    p79.Shot:Destroy()
    p79.ProjectileShot:Destroy()
    p79:_ResetReloadState()
    p79:_FinishAiming()
    v_u_12.Destroy(p79)
end
function v_u_15._FinishAiming(p80)
    p80:SetReplicate("IsAiming", false)
    p80.ViewModel:SetAiming(false)
    p80:SetReplicate("FOVOffset", 0)
    p80:_FinishAimAssist()
end
function v_u_15._ProjectileEffect(p_u_81, p_u_82, p83)
    if p_u_82 and p83 then
        p_u_81._projectile_template = p_u_81._projectile_template or (v_u_14:FindFirstChild(p_u_81.ViewModel.Name) or v_u_14[p_u_81.Name])
        p_u_82.Transparency = 1
        p83.Transparency = 1
        local v84 = p_u_81._projectile_template:Clone()
        v84.Parent = workspace
        p_u_81._projectile_part_to_model[p_u_82] = v84
        v_u_7:AddItem(v84, 60)
        v_u_11:ApplyWrap(v_u_11:RecordOriginalWrapProperties(v84), p_u_81:GetWrap(), true)
        p_u_82.Destroying:Connect(function()
            p_u_81._projectile_part_to_model[p_u_82] = nil
        end)
        p_u_81.ProjectileShot:Fire(p_u_82, p83, v84)
        if p_u_81.Name == "Slingshot" then
            v84:PivotTo(p_u_82.CFrame)
            for _, v85 in pairs(v84:GetChildren()) do
                v85.CanCollide = false
                v85.CanTouch = false
                v85.CanQuery = false
                v85.Massless = true
                local v86 = Instance.new("WeldConstraint")
                v86.Part0 = p_u_82
                v86.Part1 = v85
                v86.Parent = v85
                v85.Anchored = false
            end
        else
            for _, v87 in pairs(v84:GetChildren()) do
                v87.CanCollide = false
                v87.CanTouch = false
                v87.CanQuery = false
                v87.Anchored = true
            end
            local v88 = 0.5
            for _, v89 in pairs(v84:GetDescendants()) do
                if v89:IsA("Trail") then
                    local v90 = v89.Lifetime
                    v88 = math.max(v88, v90)
                elseif v89:IsA("ParticleEmitter") then
                    local v91 = v89.Lifetime.Max
                    v88 = math.max(v88, v91)
                end
            end
            local v92 = not p_u_81.Info.ProjectileClientSided
            if v92 then
                v92 = p_u_81.ClientFighter:IsActuallyFirstPerson()
            end
            local v93 = v_u_9.new(p_u_82.Position + (v92 and (-p_u_82.Velocity.Unit * 200 or Vector3.new(0, 0, 0)) or Vector3.new(0, 0, 0)), 1, 40)
            local v94 = tick()
            local v95 = tick() + v88
            local v96 = Vector3.new(0, 0, 0)
            local v97 = 0
            local v98 = false
            local v99 = Vector3.new(0, 0, 0)
            while tick() < v95 do
                if p_u_82:IsDescendantOf(workspace) then
                    v95 = tick() + v88
                    v93.Target = p_u_82.Position
                else
                    v93.Target = v93.Target + v96 * v97
                    if not v98 then
                        v98 = true
                        for _, v_u_100 in pairs(v84:GetDescendants()) do
                            if v_u_100:IsA("BasePart") or (v_u_100:IsA("Texture") or v_u_100:IsA("Decal")) then
                                v_u_100.LocalTransparencyModifier = 1
                            elseif v_u_100:IsA("Trail") or (v_u_100:IsA("Beam") or v_u_100:IsA("ParticleEmitter")) then
                                v_u_100.Enabled = false
                            elseif v_u_100:IsA("Light") then
                                local v_u_101 = v_u_100.Brightness
                                task.spawn(v_u_8.RenderstepForLoop, v_u_8, 0, 100, 1, function(p102)
                                    v_u_100.Brightness = v_u_101 * (1 - p102 / 100)
                                end)
                            end
                        end
                    end
                end
                local v103 = tick() - v94
                v93.Speed = math.clamp(v103, 0.01, 1) * 60 + 40
                if p_u_82.Velocity.Magnitude > 0.01 then
                    v99 = p_u_82.Velocity or v99
                end
                if v99.Magnitude > 0.01 and p_u_81.Name ~= "Flare Gun" then
                    v84:PivotTo(CFrame.new(v93.Position, v93.Position + p_u_82.Velocity))
                else
                    v84:PivotTo(CFrame.new(v93.Position) * p_u_82.CFrame.Rotation)
                end
                v96 = v99.Magnitude > v96.Magnitude and v99 and v99 or v96
                v97 = v_u_2.RenderStepped:Wait()
            end
            v84:SetAttribute("Destroying", true)
            v_u_7:AddItem(v84, v88)
        end
    else
        return
    end
end
function v_u_15._ResetReloadState(p104)
    p104._reload_cooldown = 0
    for _, v105 in pairs(p104._reload_threads) do
        task.cancel(v105)
    end
    if p104.ItemInterface then
        p104.ItemInterface:StopCooldownEffect("Reload")
    end
    p104.ViewModel:StopAnimation("Reload")
    p104.ViewModel:StopAnimation("EmptyReload")
    p104.ViewModel:StopAnimation("ReloadStart")
    p104.ViewModel:StopAnimation("ReloadSegment")
    p104.ViewModel:StopAnimation("ReloadFinish")
    p104.ViewModel:StopAnimation("EmptyReloadStart")
    p104.ViewModel:StopAnimation("EmptyReloadFinish")
end
function v_u_15._LocalTracers(p_u_106, p107, p108)
    local v109 = p_u_106.ClientFighter:GetEntityLookupParams()
    local v110 = p_u_106.ClientFighter:Get("EnvironmentID")
    local v111 = p_u_106.ClientFighter:IsCrouching()
    local v112 = p_u_106.ClientFighter:GetRaycastWhitelist(true)
    local v_u_113 = {}
    for v114 = 1, p_u_106.Info.ShootPellets do
        local v115 = v_u_6:GetSpread(p108 and p_u_106.Info.QuickShotSpread or p_u_106.Info.ShootSpread, p_u_106.Info.AimSpreadMultiplier, p107, v111, v114, p_u_106.Info.ShootPellets, p_u_106.Info.ShootSpreadConsistent)
        local v116 = p_u_106.ClientFighter:GetCameraData(v112, v115, true)
        local v117 = v116[utf8.char(0)]
        local v118 = v116[utf8.char(1)]
        local v119 = v116[utf8.char(2)]
        local v120 = v116[utf8.char(3)]
        local v121 = v119 and (v119.CFrame * v120).Position or (v118 * v115 * CFrame.new(0, 0, -v_u_4.MAX_RAYCAST_DISTANCE)).Position
        local v122 = v117.Position
        local v123 = (v121 - v122).Unit
        for v124 = 0, p_u_106.Info.RaycastBounceCount do
            if v123 ~= v123 then
                local v125 = {
                    ["Position"] = v122 + v123 * v_u_4.MAX_RAYCAST_DISTANCE
                }
                table.insert(v_u_113, v125)
                break
            end
            local _, v126 = v_u_6:GetEntitiesFromRaycast(v110, v109, v122, v123, v_u_4.MAX_RAYCAST_DISTANCE, p_u_106.Info.RaycastPierceCount)
            local v127 = {
                ["Position"] = v126.Position
            }
            if v124 > 0 then
                v127.LastRaycastResult = v_u_113[#v_u_113]
                v127.StartPosition = v127.LastRaycastResult.Position
            end
            table.insert(v_u_113, v127)
            if not v126.Normal then
                break
            end
            v122 = v126.Position
            v123 = v_u_6:GetRaycastRedirection(v110, v109, v123 - 2 * v123:Dot(v126.Normal) * v126.Normal, v122, p_u_106.Info.RaycastBounceRedirectionAngle)
        end
    end
    local v128 = p_u_106._local_tracers
    table.insert(v128, v_u_113)
    task.delay(1, function()
        local v129 = table.find(p_u_106._local_tracers, v_u_113)
        if v129 then
            table.remove(p_u_106._local_tracers, v129)
        end
    end)
    p_u_106:_Tracers({
        ["RaycastResults"] = v_u_113,
        ["IsEnemy"] = false,
        ["IsLocal"] = true
    })
end
function v_u_15._CorrectLocalTracers(p130, p131)
    local v132 = table.remove(p130._local_tracers, 1)
    if v132 then
        for v133, v134 in pairs(p131) do
            for v135, v136 in pairs(v134) do
                v132[v133][v135] = v136
            end
            v132[v133].StartPosition = v132[v133].CurrentTracerPosition
        end
    end
end
function v_u_15._Tracers(p137, p138, p139)
    local v140 = {}
    local v141 = p137.ViewModel.GetFriendlyTracerColor
    if v141 then
        v141 = p137.ViewModel:GetFriendlyTracerColor()
    end
    v140.FriendlyTracerColor = v141
    v140.ActuallyFirstPerson = p137.ClientFighter:IsActuallyFirstPerson()
    v140.MuzzlePosition = p137.ViewModel:GetMuzzlePosition()
    local v142, v143, v144 = v_u_13:VerifyTracerData(p138, p139, v140)
    if p137.ViewModel.CustomTracers then
        return p137.ViewModel:CustomTracers(v142, v143, v144)
    end
    v_u_13:Play(v142, v143, v144)
end
function v_u_15._ShootEffect(p145, p146)
    local v147 = {}
    for v148, v149 in pairs(p146) do
        v147[utf8.codepoint(v148) + 1] = {
            ["Position"] = v149[utf8.char(0)] or nil,
            ["Instance"] = v149[utf8.char(1)] or nil,
            ["Normal"] = v149[utf8.char(2)] or nil,
            ["LastRaycastIndex"] = v149[utf8.char(3)] and utf8.codepoint(v149[utf8.char(3)]) + 1 or nil
        }
    end
    for _, v150 in pairs(v147) do
        local v151
        if v150.LastRaycastIndex then
            v151 = v147[v150.LastRaycastIndex] or nil
        else
            v151 = nil
        end
        v150.LastRaycastResult = v151
        v150.LastRaycastIndex = nil
        local v152
        if v150.LastRaycastResult then
            v152 = v150.LastRaycastResult.Position or nil
        else
            v152 = nil
        end
        v150.StartPosition = v152
    end
    if not p145.ClientFighter.IsLocalPlayer or #p145._local_tracers <= 0 then
        p145:_Tracers({
            ["RaycastResults"] = v147,
            ["IsEnemy"] = v_u_3.LocalPlayer:GetAttribute("TeamID") ~= p145.ClientFighter.Player:GetAttribute("TeamID"),
            ["IsLocal"] = p145.ClientFighter.IsLocalPlayer
        })
    end
    p145:_ImpactMarkers(v147)
end
function v_u_15._CheckReload(p153)
    if p153:Get("Ammo") <= 0 then
        if p153.Name == "Daggers" then
            p153._reload_delay = tick() + 0.2
            wait(0.2)
        end
        p153:Input("StartReloading")
    end
end
function v_u_15._Init(p_u_154)
    p_u_154:GetDataChangedSignal("Ammo"):Connect(function()
        p_u_154:_CheckReload()
    end)
    p_u_154:GetDataChangedSignal("AmmoReserve"):Connect(function()
        p_u_154:_CheckReload()
    end)
    p_u_154.ViewModel.AnimationPlayed:Connect(function(p155)
        if (p155 == p_u_154.ViewModel.Animator:GetInspectAnimationKey() or p155 == p_u_154.ViewModel.Animator:GetRareInspectAnimationKey()) and p_u_154._last_shoot_animation_name then
            p_u_154.ViewModel:StopAnimation(p_u_154._last_shoot_animation_name, 0)
        end
    end)
    local v156 = p_u_154._connections
    local v157 = p_u_154.ClientFighter.Interrupted
    table.insert(v156, v157:Connect(function()
        p_u_154:Input("FinishAiming")
    end))
end
return v_u_15