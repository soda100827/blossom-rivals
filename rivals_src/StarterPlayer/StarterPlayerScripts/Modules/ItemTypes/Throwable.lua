local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("RunService")
local v3 = game:GetService("Players")
local v_u_4 = require(v1.Modules.AnimationLibrary)
local v_u_5 = require(v1.Modules.BetterDebris)
local v_u_6 = require(v1.Modules.Utility)
local v_u_7 = require(v1.Modules.Spring)
local v_u_8 = require(v1.Modules.Signal)
local v_u_9 = require(v3.LocalPlayer.PlayerScripts.Controllers.WrapController)
local v_u_10 = require(v3.LocalPlayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientFighter.ClientItem)
local v_u_11 = require(v3.LocalPlayer.PlayerScripts.Modules.TrajectoryVisual)
local v_u_12 = v3.LocalPlayer.PlayerScripts.Assets:WaitForChild("Throwables")
local v_u_13 = CFrame.new(0.75, -0.5, 0)
local v_u_14 = setmetatable({}, v_u_10)
v_u_14.__index = v_u_14
function v_u_14.new(...)
    local v15 = v_u_10.new(...)
    local v16 = v_u_14
    local v17 = setmetatable(v15, v16)
    v17.ProjectileThrown = v_u_8.new()
    v17._is_throwing = nil
    v17._throw_type = nil
    v17._throw_cooldown = 0
    v17._throw_hash = 0
    v17._trajectory_visual = nil
    local v18 = v17.Info.CanCook
    if v18 then
        v18 = v17.Info.DetonateDelay
    end
    v17._cook_detonate_delay = v18
    v17:_Init()
    return v17
end
function v_u_14.GetAutoShootReactionTime(_)
    return nil
end
function v_u_14.CanQuickAttack(p19)
    local v20 = not p19._is_throwing
    if v20 then
        if tick() > p19._throw_cooldown and (p19:Get("Ammo") or (1 / 0)) > 0 then
            v20 = not p19:IsEquipping()
        else
            v20 = false
        end
    end
    return v20
end
function v_u_14.StartShooting(p21, p22)
    if not p22 and (p21._is_throwing or (tick() < p21._throw_cooldown or ((p21:Get("Ammo") or (1 / 0)) <= 0 or p21:IsEquipping()))) then
        return false
    end
    p21._throw_type = "Throw"
    p21:_StartThrow("ThrowStart", "ThrowIdle", p21.Info.ThrowMaxChargeTime, p21.Info.ThrowForceMin, p21.Info.ThrowForceMax, p21.Info.ThrowGravity, "FinishShooting")
    return true, "StartShooting"
end
function v_u_14.FinishShooting(p23, p24)
    if p24 or p23._is_throwing and (tick() >= p23._throw_cooldown and ((p23:Get("Ammo") or (1 / 0)) > 0 and p23._throw_type == "Throw")) then
        p23._throw_type = nil
        local v25, v26 = p23:_FinishThrow("ThrowStart", "ThrowIdle", "ThrowFinish", p23.Info.ThrowMaxChargeTime)
        if v25 then
            return true, "FinishShooting", p23:_GetThrowCameraCFrame(), v25, v26
        else
            return false
        end
    else
        return false
    end
end
function v_u_14.StartAiming(p27, p28)
    if not p28 and (p27._is_throwing or (tick() < p27._throw_cooldown or ((p27:Get("Ammo") or (1 / 0)) <= 0 or p27:IsEquipping()))) then
        return false
    end
    p27._throw_type = "Lob"
    p27:_StartThrow("LobStart", "LobIdle", p27.Info.LobMaxChargeTime, p27.Info.LobForceMin, p27.Info.LobForceMax, p27.Info.LobGravity, "FinishAiming")
    return true, "StartAiming"
end
function v_u_14.FinishAiming(p29, p30)
    if p30 or p29._is_throwing and (tick() >= p29._throw_cooldown and ((p29:Get("Ammo") or (1 / 0)) > 0 and p29._throw_type == "Lob")) then
        p29._throw_type = nil
        local v31, v32 = p29:_FinishThrow("LobStart", "LobIdle", "LobFinish", p29.Info.LobMaxChargeTime)
        if v31 then
            return true, "FinishAiming", p29:_GetThrowCameraCFrame(), v31, v32
        else
            return false
        end
    else
        return false
    end
end
function v_u_14.Unequip(p33, ...)
    p33:_CancelThrow()
    v_u_10.Unequip(p33, ...)
end
function v_u_14.ReplicateFromServer(p_u_34, p35, ...)
    if p35 == "ThrowEffect" then
        if p_u_34:IsRendered() then
            local v_u_36 = ...
            if v_u_36 then
                v_u_36.Transparency = 1
                v_u_36.CanCollide = false
                local v_u_37 = (v_u_12:FindFirstChild(p_u_34.ViewModel.Name) or v_u_12[p_u_34.Name]):Clone()
                v_u_37.WorldPivot = v_u_37.Primary.CFrame
                v_u_37.Parent = workspace
                v_u_5:AddItem(v_u_37, p_u_34.Info.Lifetime + 10)
                v_u_9:ApplyWrap(v_u_9:RecordOriginalWrapProperties(v_u_37), p_u_34:GetWrap(), true)
                for _, v38 in pairs(v_u_37:GetChildren()) do
                    v38.CanCollide = false
                    v38.CanTouch = false
                    v38.CanQuery = false
                    v38.Anchored = true
                end
                p_u_34.ProjectileThrown:Fire(v_u_36, v_u_37)
                task.defer(function()
                    local v39 = p_u_34.ClientFighter:IsActuallyFirstPerson()
                    local v40 = v_u_7.new(v_u_36.Position + (v39 and -v_u_36.Velocity.Unit * 200 or Vector3.new(0, 0, 0)), 1, 40)
                    local v41 = CFrame.Angles(math.random() * 3.141592653589793 * 2, math.random() * 3.141592653589793 * 2, math.random() * 3.141592653589793 * 2)
                    local v42 = tick()
                    local v43 = 0
                    local v44 = 0
                    local v45 = nil
                    local v_u_46 = nil
                    local function v47()
                        v_u_46 = v_u_36:GetAttribute("ThrowableOrientation")
                    end
                    v_u_36:GetAttributeChangedSignal("ThrowableOrientation"):Connect(v47)
                    v_u_46 = v_u_36:GetAttribute("ThrowableOrientation")
                    local v48 = v_u_46
                    while v_u_36:IsDescendantOf(workspace) do
                        local v49 = (tick() - v42) * 1.5
                        local v50 = math.clamp(v49, 0.01, 1)
                        v40.Speed = v50 * 60 + 40
                        v40.Target = v_u_36.Position - workspace.CurrentCamera.CFrame.UpVector * (1 - v50) * 0.5
                        v43 = v43 + v_u_36.Velocity.Magnitude * v44 * 0.25
                        v45 = v_u_36.Velocity.Magnitude > 0 and CFrame.new(v40.Position, v40.Position + v_u_36.Velocity) or CFrame.new(v40.Position) * (v45 and v45 - v45.Position or CFrame.identity)
                        local v51 = v45 * v41 * CFrame.Angles(-v43, 0, 0)
                        if v48 then
                            v51 = CFrame.new(v51.Position) * v48.Rotation
                        end
                        if p_u_34.ViewModel.Name == "Skullbang" then
                            local v52 = CFrame.new(v51.Position, workspace.CurrentCamera.CFrame.Position)
                            local v53 = 1.25 * (tick() - v42) / p_u_34.Info.DetonateDelay
                            v51 = v51:Lerp(v52, (math.min(1, v53)))
                        end
                        v_u_37:ScaleTo(v50 * 1.5)
                        v_u_37:PivotTo(v51)
                        v44 = v_u_2.RenderStepped:Wait()
                    end
                    local v54 = 0
                    for _, v55 in pairs(v_u_37:GetDescendants()) do
                        if v55:IsA("BasePart") or (v55:IsA("Texture") or (v55:IsA("Beam") or v55:IsA("Decal"))) then
                            v55.LocalTransparencyModifier = 1
                        elseif v55:IsA("ParticleEmitter") then
                            v55.Enabled = false
                        elseif v55:IsA("Trail") then
                            local v56 = v55.Lifetime
                            v54 = math.max(v54, v56)
                        end
                    end
                    v_u_5:AddItem(v_u_37, v54)
                end)
            end
        else
            return
        end
    else
        v_u_10.ReplicateFromServer(p_u_34, p35, ...)
        return
    end
end
function v_u_14.Destroy(p57)
    p57.ProjectileThrown:Destroy()
    p57:_ClearTrajectoryVisual()
    v_u_10.Destroy(p57)
end
function v_u_14._CancelThrow(p58)
    p58:_ClearTrajectoryVisual()
    if p58._is_throwing then
        p58._throw_type = nil
        p58._is_throwing = nil
        p58._throw_hash = p58._throw_hash + 1
    end
    p58.ViewModel:StopAnimation("ThrowStart")
    p58.ViewModel:StopAnimation("ThrowIdle")
    p58.ViewModel:StopAnimation("ThrowFinish")
    p58.ViewModel:StopAnimation("LobStart")
    p58.ViewModel:StopAnimation("LobIdle")
    p58.ViewModel:StopAnimation("LobFinish", nil, 0)
end
function v_u_14._FinishThrow(p59, p60, p61, p62, p63)
    p59:_ClearTrajectoryVisual()
    local v64 = p59._is_throwing
    if v64 then
        local v65 = (tick() - p59._is_throwing) / p63
        v64 = math.clamp(v65, 0, 1)
    end
    local v66 = p59._is_throwing
    if v66 then
        v66 = p59._cook_detonate_delay and p59._is_throwing + (p59._cook_detonate_delay or 0) - tick() or p59.Info.DetonateDelay
    end
    p59._is_throwing = nil
    p59._throw_cooldown = p59.Info.Cooldown and (tick() + p59.Info.Cooldown or 0) or 0
    p59._throw_hash = p59._throw_hash + 1
    p59.ViewModel:StopAnimation(p60, nil, 0)
    p59.ViewModel:StopAnimation(p61, nil, 0)
    if not p59._cook_detonate_delay or (not v66 or v66 > 0) then
        p59.ViewModel:PlayAnimation(p62, v_u_4.Info[p59.ViewModel.Info.Animations[p62]].Length)
    end
    if p59.Info.Cooldown and p59.ItemInterface then
        p59.ItemInterface:CooldownEffect("rbxassetid://17156089790", p59.Info.Cooldown, "Throw")
    end
    return v64, v66
end
function v_u_14._StartThrow(p_u_67, p_u_68, p_u_69, p70, p71, p72, p73, p_u_74)
    p_u_67._is_throwing = tick()
    p_u_67._throw_hash = p_u_67._throw_hash + 1
    p_u_67.ViewModel:StopAnimation("Equip")
    p_u_67.ViewModel:PlayAnimation(p_u_68, (1 / 0))
    if p_u_67.ClientFighter.IsLocalPlayer then
        p_u_67:_CreateTractoryVisual(p70, p71, p72, p73)
    end
    local v_u_75 = p_u_67._throw_hash
    task.spawn(function()
        wait(v_u_4.Info[p_u_67.ViewModel.Info.Animations[p_u_68]].Length or 0.1)
        if v_u_75 == p_u_67._throw_hash then
            p_u_67.ViewModel:PlayAnimation(p_u_69, nil, 0)
        end
    end)
    if p_u_67._cook_detonate_delay then
        task.delay(p_u_67._cook_detonate_delay, function()
            if v_u_75 == p_u_67._throw_hash then
                p_u_67:Input(p_u_74)
            end
        end)
    end
end
function v_u_14._GetThrowCameraCFrame(p76, p77, p78, p79)
    local v80 = p76.ClientFighter:GetCameraData(p77, p78, true)
    local v81 = v80[utf8.char(0)]
    local v82 = v80[utf8.char(1)]
    local v83 = v80[utf8.char(2)]
    local v84 = v80[utf8.char(3)]
    if v83 then
        v83 = v83.CFrame * (v84 or CFrame.identity)
    end
    if v83 then
        v82 = CFrame.new(v82.Position, v83.Position) or v82
    end
    local v85 = v_u_6:Raycast(v82.Position, v82.Position + v82.LookVector * 999, 999, p77, Enum.RaycastFilterType.Include)
    local v86 = CFrame.new(v81.Position, v85.Position) * v_u_13
    if p79 then
        return v86
    else
        return v_u_6:EncodeCFrame(v86)
    end
end
function v_u_14._ClearTrajectoryVisual(p87)
    if p87._trajectory_visual then
        p87._trajectory_visual:Destroy()
        p87._trajectory_visual = nil
    end
end
function v_u_14._CreateTractoryVisual(p_u_88, p_u_89, p_u_90, p_u_91, p_u_92)
    p_u_88:_ClearTrajectoryVisual()
    local v_u_93 = p_u_88.ClientFighter:GetRaycastWhitelist(true)
    p_u_88._trajectory_visual = v_u_11.new()
    p_u_88._trajectory_visual:OnStep(function()
        local v94 = p_u_88:_GetThrowCameraCFrame(v_u_93, nil, true)
        local v95 = (tick() - (p_u_88._is_throwing or p_u_88._is_lobbing)) / p_u_89
        local v96 = math.clamp(v95, 0, 1)
        local v97 = p_u_90 + (p_u_91 - p_u_90) * v96
        local v98
        if p_u_88._cook_detonate_delay then
            v98 = p_u_88._is_throwing + p_u_88._cook_detonate_delay - tick()
        else
            v98 = p_u_88.Info.DetonateDelay
        end
        p_u_88._trajectory_visual:Update(v94.Position, v94.LookVector * v97, workspace.Gravity * 0.5 * p_u_92, nil, v_u_93, v98)
    end)
end
function v_u_14._Init(p_u_99)
    local v100 = p_u_99._connections
    local v101 = p_u_99.ClientFighter.Interrupted
    table.insert(v100, v101:Connect(function()
        p_u_99:_CancelThrow()
    end))
end
return v_u_14