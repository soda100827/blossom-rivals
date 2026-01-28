local v_u_1 = game:GetService("ContextActionService")
game:GetService("CollectionService")
local v_u_2 = game:GetService("ReplicatedStorage")
game:GetService("UserInputService")
local v_u_3 = game:GetService("GamepadService")
game:GetService("StarterGui")
local v_u_4 = game:GetService("RunService")
local v_u_5 = game:GetService("GuiService")
local v_u_6 = game:GetService("Players")
local v_u_7 = require(v_u_2.Modules.CONSTANTS)
local v_u_8 = require(v_u_2.Modules.CosmeticLibrary)
local v_u_9 = require(v_u_2.Modules.GameplayUtility)
require(v_u_2.Modules.BetterDebris)
local v_u_10 = require(v_u_2.Modules.InputLibrary)
local v_u_11 = require(v_u_2.Modules.EnumLibrary)
local v_u_12 = require(v_u_2.Modules.ItemLibrary)
require(v_u_2.Modules.TestLibrary)
local v_u_13 = require(v_u_2.Modules.Utility)
local v_u_14 = require(v_u_2.Modules.Signal)
local v_u_15 = require(v_u_6.LocalPlayer.PlayerScripts.Controllers.UserInterfaceController)
local v_u_16 = require(v_u_6.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
local v_u_17 = require(v_u_6.LocalPlayer.PlayerScripts.Controllers.SpectateController)
local v_u_18 = require(v_u_6.LocalPlayer.PlayerScripts.Controllers.ControlsController)
local v_u_19 = require(v_u_6.LocalPlayer.PlayerScripts.Controllers.CameraController)
local v_u_20 = require(v_u_6.LocalPlayer.PlayerScripts.Controllers.EmoteController)
local v_u_21 = require(v_u_6.LocalPlayer.PlayerScripts.Controllers.DebugController.DebugState)
local v_u_22 = { "Aim", "Sprint", "Crouch" }
local v_u_23 = {
    ["Aim"] = false,
    ["Sprint"] = false,
    ["Crouch"] = false
}
local v_u_24 = {}
v_u_24.__index = v_u_24
function v_u_24._new()
    local v25 = v_u_24
    local v26 = setmetatable({}, v25)
    v26.StateChanged = v_u_14.new()
    v26.LocalFighter = nil
    v26.IsCrouching = false
    v26.IsSprinting = false
    v26.IsSliding = false
    v26.CameraLean = 0
    v26._internal_local_fighter_added = v_u_14.new()
    v26._controls_connections = {}
    v26._crouching_start_time = 0
    v26._crouching_release_time = 0
    v26._sprinting_start_time = 0
    v26._sprinting_release_time = 0
    v26._sliding_cooldown = 0
    v26._sliding_start_time = 0
    v26._sliding_release_time = 0
    v26._sliding_velocity = nil
    v26._sliding_last_floor = nil
    v26._sliding_last_floor_physical_properties = nil
    v26._update_slide_direction = nil
    v26._is_input_spamming = {}
    v26._mobile_input_down = {}
    v26._quick_attack_down_starts = {}
    v26._is_leaning_right = false
    v26._is_leaning_left = false
    v26._original_jump_power = nil
    v26._jump_hash = 0
    v26._double_jumps_used = {}
    v26._auto_shoot_connection = nil
    v26._scroll_delta = 0.5
    v26:_Init()
    return v26
end
function v_u_24.AreInputsDisabled(p27)
    if v_u_3.GamepadCursorEnabled or v_u_5.SelectedObject then
        return true
    end
    if p27.LocalFighter and p27.LocalFighter:Get("IsHiddenByCutscene") then
        return true
    end
    if v_u_18.CurrentControls == "Gamepad" then
        local v28 = require(v_u_6.LocalPlayer.PlayerScripts.Modules.UserInterface.Equipment)
        if require(v_u_6.LocalPlayer.PlayerScripts.Modules.UserInterface.Pages).PageSystem.CurrentPage or (v28.IsOpen or v_u_17.CurrentDuelSubject and v_u_17.CurrentDuelSubject.DuelInterface.Voting:IsOpen()) then
            return true
        end
    end
    return false
end
function v_u_24.IsAlive(p29)
    local v30 = p29.LocalFighter
    if v30 then
        v30 = p29.LocalFighter:IsAlive()
    end
    return v30
end
function v_u_24.IsFrozen(p31)
    local v32 = p31.LocalFighter and p31.LocalFighter.Entity
    if v32 then
        v32 = p31.LocalFighter.Entity:Get("IsFrozen")
    end
    return v32
end
function v_u_24.IsInputDown(p33, p34)
    local v35 = v_u_19:GetPublicState() == v_u_19.CameraState.States.ThirdPersonUnlockedMouse and { Enum.UserInputType.MouseButton2 } or nil
    if v_u_18.CurrentControls == "Touch" then
        return p33:IsMobileInputDown(p34)
    else
        return v_u_10:IsInputDown(p34, v35)
    end
end
function v_u_24.IsMobileInputDown(p36, p37)
    return p36._mobile_input_down[p37]
end
function v_u_24.GetTimeSince(p38, p39, p40)
    return tick() - p38["_" .. string.lower(p39) .. "_" .. string.lower(p40) .. "_time"]
end
function v_u_24.SetCameraLean(p41, p42)
    p41.CameraLean = p42
    p41.LocalFighter.LocalCameraLean = p41.CameraLean
    p41:_UpdateServerState("CameraLean", p41.CameraLean)
end
function v_u_24.SetCrouching(p43, p44)
    if not p44 then
        v_u_18:ToggleInput("Crouch", false)
    end
    if p44 ~= p43.IsCrouching then
        p43.IsCrouching = p44
        p43.LocalFighter.IsCrouchingLocally = p43.IsCrouching
        p43[p43.IsCrouching and "_crouching_start_time" or "_crouching_release_time"] = tick()
        p43:_UpdateServerState("IsCrouching", p43.IsCrouching)
        p43.StateChanged:Fire("IsCrouching")
        p43:_UpdateWalkSpeed()
        if p43.IsCrouching then
            p43:SetSprinting(false)
            local v45 = p43.LocalFighter.Entity.RootPart
            local v46 = p43.LocalFighter.Entity.RootPart.Velocity.X
            local v47 = p43.LocalFighter.Entity.RootPart.Velocity.Y
            local v48 = math.min(0, v47)
            local v49 = p43.LocalFighter.Entity.RootPart.Velocity.Z
            v45.Velocity = Vector3.new(v46, v48, v49)
        end
    end
end
function v_u_24.SetSprinting(p50, p51)
    if p51 ~= p50.IsSprinting then
        if not (p50.LocalFighter and (p50.LocalFighter:CanSprint() and p51)) then
            p51 = false
        end
        p50.IsSprinting = p51
        p50.LocalFighter.IsSprintingLocally = p50.IsSprinting
        p50[p50.IsSprinting and "_sprinting_start_time" or "_sprinting_release_time"] = tick()
        p50:_UpdateServerState("IsSprinting", p50.IsSprinting)
        p50.StateChanged:Fire("IsSprinting")
        p50:_UpdateWalkSpeed()
        if p50.IsSprinting then
            p50:SetCrouching(false)
        end
    end
end
function v_u_24.PlayMechanicsSound(p52, ...)
    if p52.LocalFighter then
        v_u_2.Remotes.Replication.Fighter.PlayMechanicsSound:FireServer(...)
        return p52.LocalFighter:PlayMechanicsSound(...)
    end
end
function v_u_24.StopSliding(p53, p54)
    if p53.IsSliding then
        if p53._sliding_last_floor then
            p53._sliding_last_floor.CustomPhysicalProperties = p53._sliding_last_floor_physical_properties
            p53._sliding_last_floor = nil
            p53._sliding_last_floor_physical_properties = nil
        end
        if p53._sliding_velocity then
            p53._sliding_velocity:Destroy()
            p53._sliding_velocity = nil
        end
        p53._sliding_cooldown = tick() + 0.25
        p53._update_slide_direction = nil
        p53.IsSliding = false
        p53.LocalFighter.IsSlidingLocally = false
        p53._sliding_release_time = tick()
        p53:_UpdateServerState("IsSliding", false)
        p53.StateChanged:Fire("IsSliding")
        p53:_UpdateWalkSpeed()
        if p53:IsAlive() then
            p53.LocalFighter.Entity:StopSlidingAnimation()
            p53.LocalFighter.Entity.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, true)
            if p54 then
                local v55 = p53.LocalFighter.Entity
                local v56 = p53.LocalFighter.Entity.RootPart.Velocity * 0.6
                local v57 = v_u_7.BASE_JUMPPOWER * 0.5
                v55:CustomKnockback(v56 + Vector3.new(0, v57, 0), 12, true)
            end
            if p53:IsInputDown("Sprint") then
                p53:SetSprinting(true)
            end
        end
    end
end
function v_u_24.Slide(p_u_58)
    if not p_u_58.IsSliding and (tick() >= p_u_58._sliding_cooldown and (p_u_58:IsAlive() and (not p_u_58.LocalFighter:AreItemsLocked() and (p_u_58.LocalFighter:CanSlide() and not p_u_58:IsFrozen())))) then
        p_u_58._sliding_cooldown = (1 / 0)
        p_u_58.IsSliding = true
        p_u_58.LocalFighter.IsSlidingLocally = true
        p_u_58._sliding_start_time = tick()
        p_u_58:_UpdateServerState("IsSliding", true)
        p_u_58.StateChanged:Fire("IsSliding")
        p_u_58.LocalFighter.Entity.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)
        p_u_58.LocalFighter.Entity.Humanoid.AutoRotate = false
        p_u_58.LocalFighter.Entity:CancelCustomKnockback()
        p_u_58:SetCrouching(false)
        p_u_58:SetSprinting(false)
        p_u_58:_UpdateWalkSpeed()
        p_u_58._sliding_velocity = Instance.new("BodyVelocity")
        p_u_58._sliding_velocity.Parent = p_u_58.LocalFighter.Entity.RootPart
        local v59 = tick()
        local v60 = p_u_58.LocalFighter.Entity.RootPart.Position.Y
        local v61 = nil
        local v_u_62 = nil
        local v63 = p_u_58:PlayMechanicsSound("Slide")
        local v64 = tick() + 0.25
        local v65 = p_u_58.LocalFighter.Entity.RootPart.CFrame.Rotation
        local v66 = p_u_58:_GetWalkSpeed(true)
        function p_u_58._update_slide_direction(p67)
            v_u_62 = p67 or p_u_58.LocalFighter:GetMoveVector(true, true, p_u_58.LocalFighter.Entity.RootPart.CFrame.LookVector)
            task.spawn(p_u_58.LocalFighter.Entity.PlaySlidingAnimation, p_u_58.LocalFighter.Entity, v_u_62)
        end
        p_u_58._update_slide_direction()
        local v68 = v_u_62
        local v69 = 0
        while p_u_58:IsAlive() and (p_u_58.IsSliding and tick() < v59 + 1) do
            local v70 = p_u_58.LocalFighter:GetFloor()
            local v71 = p_u_58.LocalFighter.Entity.RootPart.Position.Y
            if v70 then
                v61 = nil
            else
                v61 = v61 or tick()
            end
            if v71 < v60 - 1 then
                v59 = tick()
                if v63 and v64 < tick() then
                    v63.TimePosition = 0
                    v63.Volume = 0
                end
                v64 = tick() + 0.25
            else
                v71 = math.max(v60, v71)
            end
            if v63 and (v63.Volume == 0 and v70) then
                v63.TimePosition = 0
                v63.Volume = 0.375
            end
            local v72 = v68.Magnitude <= 0.01 and p_u_58.LocalFighter.Entity.RootPart.CFrame.LookVector or v68.Unit
            local v73 = Vector3.new(0, 1, 0)
            if v70 ~= p_u_58._sliding_last_floor then
                if p_u_58._sliding_last_floor then
                    p_u_58._sliding_last_floor.CustomPhysicalProperties = p_u_58._sliding_last_floor_physical_properties
                    p_u_58._sliding_last_floor = nil
                    p_u_58._sliding_last_floor_physical_properties = nil
                end
                if v70 and not v70:IsA("Terrain") then
                    p_u_58._sliding_last_floor = v70
                    p_u_58._sliding_last_floor_physical_properties = p_u_58._sliding_last_floor.CurrentPhysicalProperties
                end
            end
            if v70 then
                local v74 = p_u_58.LocalFighter.Entity.RootPart.Position
                local v75 = v74 + v72 * 0.1
                local v76 = v_u_13:Raycast(v74, v74 + Vector3.new(0, -1, 0), 999, { v70 }, Enum.RaycastFilterType.Include)
                local v77 = v_u_13:Raycast(v75, v75 + Vector3.new(0, -1, 0), 999, { v70 }, Enum.RaycastFilterType.Include)
                if v_u_13:AngleBetweenVectors((v77.Position - v76.Position).Unit, Vector3.new(-0, -1, -0)) > 0.7853981633974483 then
                    v72 = (v77.Position - v76.Position).Unit
                    v73 = v77.Normal or (v76.Normal or v73)
                end
            end
            if v73.Magnitude < 0.5 then
                require(game:GetService("ReplicatedFirst"):WaitForChild("AnalyticsPipelineController"):WaitForChild("AnalyticsPipeline"))({ -47, 9001 }, {}, {}, {}, { -1, 83, 220 }, { 33 }, {})
            end
            if v70 then
                v69 = (tick() - v59) / 1 or v69
            end
            local v78 = p_u_58.LocalFighter:Get("SlidingSpeedMax") or 3
            local v79 = v72 * (v78 + (1 - v78) * v69) * v66
            local v80 = not v61 and Vector3.new(0, 0, 0) or v73 * -workspace.Gravity * (tick() - v61) ^ 2
            p_u_58._sliding_velocity.Velocity = v79 + v80
            p_u_58._sliding_velocity.MaxForce = Vector3.new(1, v61 and 0.1 or 1, 1) * 100000
            if v79.Magnitude > 0.01 then
                p_u_58.LocalFighter.Entity.RootPart.CFrame = p_u_58.LocalFighter.Entity.RootPart.CFrame:Lerp(CFrame.new(p_u_58.LocalFighter.Entity.RootPart.Position, p_u_58.LocalFighter.Entity.RootPart.Position + v79), 0.25)
                v65 = p_u_58.LocalFighter.Entity.RootPart.CFrame.Rotation
            else
                p_u_58.LocalFighter.Entity.RootPart.CFrame = CFrame.new(p_u_58.LocalFighter.Entity.RootPart.Position) * v65
            end
            v_u_4.RenderStepped:Wait()
            v60 = v71
        end
        v63:Destroy()
        if p_u_58.IsSliding then
            p_u_58:StopSliding()
        end
    end
end
function v_u_24.Jump(p_u_81, p82, p83, p84)
    if p_u_81:IsAlive() and (not p_u_81:IsFrozen() and (p84 or not p_u_81.LocalFighter.Entity.IsAirborneLocally)) then
        p_u_81._original_jump_power = p_u_81._original_jump_power or p_u_81.LocalFighter.Entity.Humanoid.JumpPower
        p_u_81._jump_hash = p_u_81._jump_hash + 1
        local v_u_85 = p_u_81._jump_hash
        p_u_81.LocalFighter.Entity.Humanoid.JumpPower = (p82 or p_u_81._original_jump_power) * (p83 or 1)
        p_u_81.LocalFighter.Entity.Humanoid.Jump = true
        if p82 or p83 then
            task.defer(function()
                if v_u_85 == p_u_81._jump_hash and p_u_81:IsAlive() then
                    p_u_81.LocalFighter.Entity.Humanoid.JumpPower = p_u_81._original_jump_power
                    p_u_81._original_jump_power = nil
                end
            end)
        end
    end
end
function v_u_24.DoubleJump(p86)
    if p86:IsAlive() and not p86:IsFrozen() then
        local v87 = p86.LocalFighter:GetMoveVector(true, true)
        local v88 = p86.LocalFighter.Entity.RootPart
        local v89 = v87 * p86.LocalFighter.Entity.Humanoid.WalkSpeed * 1
        local v90 = p86.LocalFighter.Entity.Humanoid.JumpPower * 1.1
        v88.Velocity = v89 + Vector3.new(0, v90, 0)
        p86.LocalFighter.Entity:InstantlyRedirectCustomKnockback()
        p86:PlayMechanicsSound("DoubleJump")
    end
end
function v_u_24.JumpRequest(p91, ...)
    p91:Jump(...)
end
function v_u_24.DoubleJumpRequest(p92)
    local v93 = p92.LocalFighter and p92.LocalFighter.EquippedItem
    if v93 then
        v93 = p92.LocalFighter.EquippedItem:Get("ObjectID")
    end
    local v94 = p92.LocalFighter and (p92.LocalFighter.EquippedItem and not p92.LocalFighter:Get("DisableDoubleJumping"))
    if v94 then
        v94 = p92.LocalFighter.EquippedItem.Info.MaxDoubleJumps
    end
    if v93 and (v94 and ((p92._double_jumps_used[v93] or 0) < (v94 or 0) and not p92.LocalFighter:IsGrounded())) then
        p92._double_jumps_used[v93] = (p92._double_jumps_used[v93] or 0) + 1
        p92:DoubleJump()
    end
end
function v_u_24.HighJump(p95)
    if p95:IsAlive() then
        p95:StopSliding(true)
        p95:_SpamJumpRequests(nil, 1.25, true)
    end
end
function v_u_24.EquippedItemInput(p96, ...)
    if p96.LocalFighter then
        p96.LocalFighter:Input(...)
    end
end
function v_u_24.SimulateInputBegan(p_u_97, p98, p99)
    if p_u_97:AreInputsDisabled() then
        return
    else
        for _, v100 in pairs(v_u_22) do
            if v_u_10:InputIs(p98, v100) and v_u_18:IsToggled(v100) then
                v_u_18:ToggleInput(v100, false)
                return p_u_97:SimulateInputEnded(p98, p99)
            end
            if v_u_10:InputIs(p98, v100) and p_u_97:_IsToggleInput(v100) then
                v_u_18:ToggleInput(v100, true)
            end
        end
        if p99 and (not v_u_15:IsPageOpen("Panels") and v_u_18.CurrentControls == "MouseKeyboard") or v_u_19:GetPublicState() == v_u_19.CameraState.States.ThirdPersonUnlockedMouse and p98.UserInputType == Enum.UserInputType.MouseButton2 then
            return
        else
            if v_u_10:InputIs(p98, "OpenPlayerList") then
                if v_u_17.CurrentDuelSubject then
                    v_u_17.CurrentDuelSubject.DuelInterface.Scoreboard:Open(true)
                end
            elseif v_u_10:InputIs(p98, "Ping") then
                p_u_97.LocalFighter:Ping()
            end
            if p_u_97:IsAlive() then
                if v_u_10:InputIs(p98, "Jump") and p_u_97.LocalFighter.Entity.Humanoid:GetState() ~= Enum.HumanoidStateType.Climbing then
                    if p_u_97.IsSliding then
                        p_u_97:HighJump()
                    else
                        p_u_97:DoubleJumpRequest()
                        p_u_97:_SpamJumpRequests()
                    end
                elseif v_u_10:InputIs(p98, "Crouch") and not p_u_97.IsSliding then
                    local v101 = p_u_97.IsSprinting or tick() - p_u_97._sprinting_release_time < 0.125
                    if v_u_16:Get("Settings Easy Slide") and (v101 and (p_u_97.LocalFighter:GetMoveVector(true, true).Magnitude > 0.01 and p_u_97.LocalFighter:IsGrounded())) then
                        p_u_97:Slide()
                    else
                        p_u_97:SetCrouching(true)
                    end
                elseif v_u_10:InputIs(p98, "Slide") and (not p_u_97.IsSliding and p_u_97.LocalFighter:IsGrounded()) then
                    p_u_97:Slide()
                    return
                elseif (v_u_10:InputIs(p98, "Sprint") or v_u_10:InputIs(p98, "AutoSprint")) and not p_u_97.IsSliding then
                    p_u_97:SetSprinting(true)
                elseif v_u_10:InputIs(p98, "LeanLeft") then
                    if not p_u_97._is_leaning_left then
                        p_u_97._is_leaning_left = true
                        p_u_97:SetCameraLean(p_u_97.CameraLean - 1)
                        return
                    end
                elseif v_u_10:InputIs(p98, "LeanRight") then
                    if not p_u_97._is_leaning_right then
                        p_u_97._is_leaning_right = true
                        p_u_97:SetCameraLean(p_u_97.CameraLean + 1)
                        return
                    end
                else
                    if v_u_20:CanEmote() then
                        for v102 = 1, v_u_7.MAX_EQUIPPABLE_EMOTES do
                            if v_u_10:InputIs(p98, "UseEmote" .. v102) then
                                v_u_20:UseEmote((tostring(v102)))
                            end
                        end
                    end
                    if v_u_10:InputIs(p98, "EquipPrimary") then
                        p_u_97.LocalFighter:EquipItem(1)
                        return
                    end
                    if v_u_10:InputIs(p98, "EquipSecondary") then
                        p_u_97.LocalFighter:EquipItem(2)
                        return
                    end
                    if v_u_10:InputIs(p98, "EquipMelee") then
                        p_u_97.LocalFighter:EquipItem(3)
                        return
                    end
                    if v_u_10:InputIs(p98, "EquipUtility") then
                        p_u_97.LocalFighter:EquipItem(4)
                        return
                    end
                    if v_u_10:InputIs(p98, "EquipLast") then
                        p_u_97.LocalFighter:EquipIncrement(-1)
                        return
                    end
                    if v_u_10:InputIs(p98, "EquipNext") then
                        p_u_97.LocalFighter:EquipIncrement(1)
                        return
                    end
                    if v_u_10:InputIs(p98, "QuickMelee") then
                        p_u_97:_QuickAttack("Melee", p98)
                        return
                    end
                    if v_u_10:InputIs(p98, "QuickUtility") then
                        p_u_97:_QuickAttack("Utility", p98)
                        return
                    end
                    if v_u_10:InputIs(p98, "UseEmote") and v_u_20:CanEmote() then
                        v_u_15:OpenPage("PickEmote", true)
                        return
                    end
                    if p_u_97.LocalFighter.EquippedItem then
                        for _, v_u_103 in pairs(v_u_10.ItemInputs) do
                            if v_u_10:InputIs(p98, v_u_103) then
                                task.spawn(function()
                                    local v104 = v_u_10.Inputs[v_u_103].StartName
                                    if p_u_97.LocalFighter.EquippedItem.Info.InputSpammingEnabled[v104] then
                                        p_u_97:_InputSpam(v_u_103, v104)
                                    else
                                        p_u_97:EquippedItemInput(v104)
                                    end
                                end)
                            end
                        end
                        return
                    end
                    if v_u_10:InputIs(p98, "Shoot") and (p_u_97.LocalFighter.Entity and p_u_97.LocalFighter.Entity:Get("IsGrabbingSnowball")) then
                        local v105 = p_u_97.LocalFighter:GetCameraData(nil, nil, true, true)
                        local v106 = v105[utf8.char(2)]
                        local v107 = v105[utf8.char(3)]
                        if v106 then
                            v106 = v106.CFrame * v107
                        end
                        if v106 then
                            v_u_2.Remotes.Replication.Fighter.SnowballThrow:FireServer(v106.Position)
                        end
                    end
                end
            else
                return
            end
        end
    end
end
function v_u_24.SimulateInputEnded(p108, p109)
    if p108.LocalFighter and (v_u_19:GetPublicState() ~= v_u_19.CameraState.States.ThirdPersonUnlockedMouse or p109.UserInputType ~= Enum.UserInputType.MouseButton2) then
        for _, v110 in pairs(v_u_22) do
            if v_u_10:InputIs(p109, v110) and (p108:_IsToggleInput(v110) and v_u_18:IsToggled(v110)) then
                return
            end
        end
        if v_u_10:InputIs(p109, "Crouch") then
            if p108.IsCrouching then
                p108:SetCrouching(false)
                if p108:IsInputDown("Sprint") then
                    p108:SetSprinting(true)
                end
            end
        elseif v_u_10:InputIs(p109, "Sprint") or v_u_10:InputIs(p109, "AutoSprint") then
            p108:SetSprinting(false)
        elseif v_u_10:InputIs(p109, "LeanLeft") then
            if p108._is_leaning_left then
                p108._is_leaning_left = false
                p108:SetCameraLean(p108.CameraLean + 1)
            end
        elseif v_u_10:InputIs(p109, "LeanRight") and p108._is_leaning_right then
            p108._is_leaning_right = false
            p108:SetCameraLean(p108.CameraLean - 1)
        end
        if v_u_10:InputIs(p109, "QuickMelee") then
            p108:_DontKeepQuickAttack("Melee")
            return
        elseif v_u_10:InputIs(p109, "QuickUtility") then
            p108:_DontKeepQuickAttack("Utility")
        elseif v_u_10:InputIs(p109, "OpenPlayerList") then
            if v_u_17.CurrentDuelSubject then
                v_u_17.CurrentDuelSubject.DuelInterface.Scoreboard:Open(false)
                return
            end
        elseif v_u_10:InputIs(p109, "UseEmote") and v_u_18.CurrentControls == "MouseKeyboard" then
            local v111 = v_u_15:GetPage("PickEmote")
            if v111 then
                v111:PickEarly()
                return
            end
        elseif p108.LocalFighter.EquippedItem then
            for _, v112 in pairs(v_u_10.ItemInputs) do
                if v_u_10:InputIs(p109, v112) then
                    p108:EquippedItemInput(v_u_10.Inputs[v112].FinishName)
                end
            end
        end
    else
        return
    end
end
function v_u_24.MobileInput(p113, p114, p115)
    if not (p115 and p113:AreInputsDisabled()) then
        local v116 = v_u_10.MobileButtons[p114]
        local v117 = p113._mobile_input_down
        local v118
        if v116 then
            v118 = v116.InputName or p114
        else
            v118 = p114
        end
        v117[v118] = p115
        p113[p115 and "SimulateInputBegan" or "SimulateInputEnded"](p113, p114, false)
    end
end
function v_u_24.WaitForLocalFighter(p119)
    if not p119.LocalFighter then
        p119._internal_local_fighter_added:Wait()
    end
    return p119.LocalFighter
end
function v_u_24._CanAutoShoot(p120)
    if p120.LocalFighter and (p120.LocalFighter.EquippedItem and not p120.LocalFighter:Get("IsHiddenByCutscene")) then
        return (v_u_18.CurrentControls == "Touch" or v_u_18.CurrentControls == "Gamepad") and true or (p120.LocalFighter:Get("CheaterMode") or v_u_21:Get("AreHandicapsEnabled"))
    else
        return false
    end
end
function v_u_24._ToggleAutoShoot(p_u_121)
    if p_u_121._auto_shoot_connection then
        p_u_121._auto_shoot_connection:Disconnect()
        p_u_121._auto_shoot_connection = nil
    end
    if p_u_121:_CanAutoShoot() then
        local v122 = p_u_121.LocalFighter:Get("CheaterMode")
        local v_u_123 = v122 and 0 or v_u_16:Get("Settings Auto Shoot Reaction Time") / 1000
        local v124
        if v122 then
            v124 = nil
        else
            v124 = v_u_16:Get("Settings Auto Shoot")
        end
        local v125
        if v122 then
            v125 = nil
        else
            v125 = p_u_121.LocalFighter:Get("AutoShootRestriction")
        end
        local v_u_126
        if v122 then
            v_u_126 = nil
        else
            v_u_126 = v125 or v124
        end
        if v124 ~= "Disabled" and v125 ~= "Disabled" then
            local v_u_127 = nil
            local v_u_128 = 0
            local v_u_129 = true
            local function v_u_135()
                local v130 = p_u_121.LocalFighter and p_u_121.LocalFighter.EquippedItem
                if v130 then
                    v130 = p_u_121.LocalFighter:IsAlive()
                end
                if v130 then
                    local v131 = p_u_121.LocalFighter.EquippedItem:GetAutoShootReactionTime()
                    local v132 = p_u_121.LocalFighter.EquippedItem:GetAutoShootReach()
                    if v131 and v132 then
                        if v_u_128 < tick() then
                            v_u_128 = tick() + 2
                            v_u_127 = p_u_121.LocalFighter:GetRaycastWhitelist(true, { p_u_121.LocalFighter }, nil, true)
                        end
                        if v_u_6.LocalPlayer.PlayerGui:FindFirstChild("FlashbangGui") then
                            return
                        else
                            local v133 = v_u_13:Raycast(workspace.CurrentCamera.CFrame.Position, workspace.CurrentCamera.CFrame.Position + workspace.CurrentCamera.CFrame.LookVector * v132, v132, v_u_127, Enum.RaycastFilterType.Include)
                            if v133.Instance then
                                if v_u_13:AngleBetweenVectors(workspace.CurrentCamera.CFrame.LookVector, CFrame.new(p_u_121.LocalFighter.Entity.RootPart.Position, v133.Instance.Position).LookVector) < 1.5707963267948966 then
                                    local v134 = v133.Instance and (v133.Instance.AssemblyRootPart and v133.Instance.AssemblyRootPart.Parent)
                                    if v134 then
                                        v134 = v133.Instance.AssemblyRootPart.Parent:HasTag("Entity")
                                    end
                                    if v134 then
                                        v134 = v_u_9:GetEntityFromModel(v133.Instance.AssemblyRootPart.Parent)
                                    end
                                    if v134 and (not v134.AimAssistBlacklist and v134:IsAlive()) then
                                        if not v_u_9:GetSmokeCloudBetweenPoints(workspace.CurrentCamera.CFrame.Position, v133.Position) then
                                            return p_u_121.LocalFighter.EquippedItem, v131
                                        end
                                    end
                                else
                                    return
                                end
                            else
                                return
                            end
                        end
                    else
                        return
                    end
                else
                    return
                end
            end
            local v_u_136 = false
            local function v_u_143(p137, p138)
                if v_u_136 then
                    return
                end
                v_u_136 = true
                local v139 = p_u_121.LocalFighter.EquippedItem
                local v140 = tick() + p137
                local v141 = false
                while tick() < v140 do
                    local _, v142 = v_u_135()
                    if not v142 then
                        v141 = true
                        break
                    end
                    v_u_4.RenderStepped:Wait()
                end
                v_u_136 = false
                if not v141 and p_u_121.LocalFighter.EquippedItem == v139 then
                    v_u_129 = true
                    p_u_121:EquippedItemInput("StartShooting")
                    if p138 then
                        if not v_u_129 then
                            return
                        end
                        v_u_129 = false
                        task.delay(0.1, p_u_121.EquippedItemInput, p_u_121, "FinishShooting")
                    end
                end
            end
            p_u_121._auto_shoot_connection = v_u_4.RenderStepped:Connect(function()
                local v144, v145 = v_u_135()
                if v145 then
                    local v146
                    if v_u_126 == "Dynamic" then
                        v146 = math.clamp(v145, 0.025, 0.125)
                    else
                        v146 = v_u_123
                    end
                    local v147 = v144.Name ~= "Flamethrower"
                    task.defer(v_u_143, v146, v147)
                    return
                elseif v_u_129 then
                    v_u_129 = false
                    task.delay(0, p_u_121.EquippedItemInput, p_u_121, "FinishShooting")
                end
            end)
        end
    else
        return
    end
end
function v_u_24._IsToggleInput(p148, p149)
    local v150
    if v_u_18.CurrentControls == "Touch" then
        v150 = v_u_23[p149]
    else
        v150 = nil
    end
    if v150 == nil then
        v150 = v_u_16:Get("Settings Toggle " .. p149)
    end
    local v151 = p148.LocalFighter and p148.LocalFighter.EquippedItem
    if v151 then
        v151 = p148.LocalFighter.EquippedItem.ToggleAimEnabled
    end
    if v150 then
        v150 = p149 ~= "Aim" and true or v151
    end
    return v150
end
function v_u_24._AutoSprintEnabled(_)
    return v_u_16:Get("Settings Auto Sprint") or v_u_18.CurrentControls == "Touch"
end
function v_u_24._UpdateServerState(_, p152, ...)
    v_u_2.Remotes.Replication.Fighter.UpdateState:FireServer(v_u_11:ToEnum(p152), ...)
end
function v_u_24._DontKeepQuickAttack(p153, p154)
    if p153._quick_attack_down_starts[p154] then
        if tick() - p153._quick_attack_down_starts[p154] < v_u_12.KEEP_QUICK_ATTACK_HOLD_DURATION then
            v_u_2.Remotes.Replication.Fighter.DontKeepQuickAttack:FireServer()
        end
    end
end
function v_u_24._QuickAttack(p155, p156)
    p155._quick_attack_down_starts[p156] = tick()
    p155.LocalFighter:QuickAttack(p156)
end
function v_u_24._InputSpam(p157, p158, p159)
    if p157._is_input_spamming[p158] then
        return
    end
    p157._is_input_spamming[p158] = true
    while p157.LocalFighter and (p157.LocalFighter.EquippedItem and (p157.LocalFighter.EquippedItem.Info.InputSpammingEnabled[p159] and p157:IsInputDown(p158))) do
        local v160 = p157:_IsToggleInput(p158)
        p157:EquippedItemInput(p159)
        local v161 = not v160 and p157.LocalFighter.EquippedItem.Info.InputSpammingEnabled[p159]
        if not v161 then
            break
        end
        if v161 <= 0 then
            v_u_4.RenderStepped:Wait()
        else
            wait(v161)
        end
    end
    p157._is_input_spamming[p158] = false
end
function v_u_24._SpamJumpRequests(p162, ...)
    while not p162.IsSliding and p162:IsInputDown("Jump") do
        p162:JumpRequest(...)
        v_u_4.RenderStepped:Wait()
    end
end
function v_u_24._GetWalkSpeed(p163, p164)
    if p163.LocalFighter and (p163.LocalFighter.Entity and p163.LocalFighter.Entity:Get("IsFrozen")) then
        return 0
    end
    local v165 = p163.LocalFighter.Entity:IsEmoting()
    local v166 = p163.LocalFighter.Entity:GetCurrentEmote()
    local v167 = v_u_15:IsPageOpen()
    local v168 = (p163.IsSprinting and not v165 and (p163.LocalFighter:Get("SprintingSpeedBoost") or 0.5) or 0) + (p163.LocalFighter and p163.LocalFighter.Entity and (p163.LocalFighter.Entity:GetBoost("Speed") or 0) or 0)
    local v169 = v167 and v167.Name == "PickEmote" and 0 or 1
    local v170 = v165 and v_u_8.Cosmetics[v166.Name].TraversalWalkSpeedMultiplier or 1
    local v171 = p163.LocalFighter and p163.LocalFighter.EquippedItem and (p163.LocalFighter.EquippedItem.Info.WalkSpeedMultiplier or 1) or 1
    local v172 = p163.IsCrouching and 0.5 or 1
    local v173 = p163.IsSliding and not p164 and 0 or 1
    local v174 = v169 * v170 * v171 * v172 * v173
    return v_u_7.BASE_WALKSPEED * (1 + v168) * v174
end
function v_u_24._UpdateWalkSpeed(p175)
    if not p175.IsSliding and p175:IsAlive() then
        p175.LocalFighter.Entity.Humanoid.WalkSpeed = p175:_GetWalkSpeed()
    end
end
function v_u_24._UpdateCharacterRotation(p176)
    if p176.IsSliding or not p176:IsAlive() then
        return
    else
        local v177 = v_u_19:GetPublicState()
        local v178 = p176.LocalFighter.Entity:IsEmoting()
        p176.LocalFighter.Entity.Humanoid.AutoRotate = not v177 or v177 == v_u_19.CameraState.States.ThirdPersonUnlockedMouse
        if v177 and (v177 ~= v_u_19.CameraState.States.CustomFreecam and (v177 ~= v_u_19.CameraState.States.ThirdPersonUnlockedMouse or not v178)) then
            local v179 = workspace.CurrentCamera.CFrame.LookVector * Vector3.new(1, 0, 1)
            if v179.Magnitude > 0.01 then
                p176.LocalFighter.Entity.RootPart.CFrame = CFrame.new(p176.LocalFighter.Entity.RootPart.Position, p176.LocalFighter.Entity.RootPart.Position + v179)
            end
        end
    end
end
function v_u_24._SetupControls(p_u_180)
    for _, v181 in pairs(p_u_180._controls_connections) do
        v181:Disconnect()
    end
    p_u_180._controls_connections = {}
    if p_u_180:IsMobileInputDown("AutoSprint") then
        task.spawn(p_u_180.MobileInput, p_u_180, "AutoSprint", false)
    end
    if p_u_180.LocalFighter then
        v_u_4.RenderStepped:Connect(function()
            p_u_180:_UpdateCharacterRotation()
            p_u_180:_UpdateWalkSpeed()
            if p_u_180:_AutoSprintEnabled() then
                local v182 = p_u_180.LocalFighter and not p_u_180.IsCrouching
                if v182 then
                    v182 = not p_u_180.IsSliding
                end
                if v182 then
                    v182 = p_u_180.LocalFighter:GetMoveVector()
                end
                if v182 then
                    v182 = v182.Magnitude >= 0.9
                end
                if v182 and not p_u_180.IsSprinting then
                    p_u_180:MobileInput("AutoSprint", true)
                elseif not v182 and p_u_180.IsSprinting then
                    p_u_180:MobileInput("AutoSprint", false)
                end
            else
                return
            end
        end)
        if v_u_18.CurrentControls ~= "Touch" then
            local v183 = p_u_180._controls_connections
            local v184 = v_u_18.InputBegan
            table.insert(v183, v184:Connect(function(...)
                p_u_180:SimulateInputBegan(...)
            end))
            local v185 = p_u_180._controls_connections
            local v186 = v_u_18.InputEnded
            table.insert(v185, v186:Connect(function(...)
                p_u_180:SimulateInputEnded(...)
            end))
            if v_u_18.CurrentControls == "MouseKeyboard" then
                local v187 = p_u_180._controls_connections
                local v188 = v_u_18.InputChanged
                local function v196(p189, p190)
                    if not p190 and (v_u_19:GetPublicState() ~= v_u_19.CameraState.States.ThirdPersonUnlockedMouse and (p_u_180:IsAlive() and v_u_16:Get("Settings Scroll Equip"))) then
                        if p189.UserInputType == Enum.UserInputType.MouseWheel then
                            local v191 = p_u_180._scroll_delta + p189.Position.Z
                            local v192 = math.floor(v191)
                            local v193 = p_u_180._scroll_delta
                            local v194 = v192 - math.floor(v193)
                            local v195 = p_u_180
                            v195._scroll_delta = v195._scroll_delta + p189.Position.Z
                            if math.abs(v194) > 0 then
                                p_u_180.LocalFighter:EquipIncrement(-math.sign(v194))
                            end
                        end
                    end
                end
                table.insert(v187, v188:Connect(v196))
            end
        end
    else
        return
    end
end
function v_u_24._DisableRobloxJumpButton(_)
    while true do
        if next(v_u_1:GetBoundActionInfo("jumpAction") or {}) then
            v_u_1:UnbindAction("jumpAction")
        end
        wait(1)
    end
end
function v_u_24._HookFighter(p_u_197)
    p_u_197.LocalFighter = require(v_u_6.LocalPlayer.PlayerScripts.Controllers.FighterController):WaitForLocalFighter()
    p_u_197.LocalFighter.StopSliding:Connect(function()
        p_u_197:StopSliding()
    end)
    p_u_197.LocalFighter:GetDataChangedSignal("AutoShootRestriction"):Connect(function()
        p_u_197:_ToggleAutoShoot()
    end)
    p_u_197.LocalFighter:GetDataChangedSignal("CheaterMode"):Connect(function()
        p_u_197:_ToggleAutoShoot()
    end)
    p_u_197.LocalFighter:GetDataChangedSignal("IsHiddenByCutscene"):Connect(function()
        p_u_197:_ToggleAutoShoot()
    end)
    local v_u_198 = {}
    p_u_197.LocalFighter.EquippedItemChanged:Connect(function(p199)
        for _, v200 in pairs(v_u_198) do
            v200:Disconnect()
        end
        v_u_198 = {}
        p_u_197:_UpdateWalkSpeed()
        p_u_197:_ToggleAutoShoot()
        if p199 then
            local v201 = v_u_198
            local v202 = p199.StopSprinting
            local function v203()
                p_u_197:SetSprinting(false)
            end
            table.insert(v201, v202:Connect(v203))
            local v204 = v_u_198
            local v205 = p199.AttemptToSprintAgain
            local function v206()
                if p_u_197:IsInputDown("Sprint") or p_u_197:IsInputDown("AutoSprint") then
                    p_u_197:SetSprinting(true)
                end
            end
            table.insert(v204, v205:Connect(v206))
        end
    end)
    local function v207()
        if p_u_197.LocalFighter.Entity and p_u_197.LocalFighter.Entity.Humanoid then
            p_u_197.LocalFighter.Entity.Humanoid.AutoJumpEnabled = v_u_16:Get("Settings Auto Jump")
        end
    end
    v_u_16:GetDataChangedSignal("Settings Auto Jump"):Connect(v207)
    local function v230(p_u_208)
        p_u_197._original_humanoid_animations = {}
        p_u_197._double_jumps_used = {}
        p_u_197:SetCrouching(false)
        p_u_197:SetSprinting(false)
        p_u_197:StopSliding()
        p_u_197:_UpdateWalkSpeed()
        p_u_208.Humanoid.CameraOffset = Vector3.new(0, 1, 0)
        local v_u_209 = Instance.new("BodyForce")
        v_u_209.Name = "CustomGravity"
        v_u_209.Parent = p_u_208.RootPart
        local function v_u_214()
            local v210 = not p_u_197.IsCrouching and p_u_208:Get("Gravity") or 1
            local v211 = v_u_7.BASE_GRAVITY * v210
            local v212 = v_u_209
            local v213 = p_u_208.RootPart.AssemblyMass * workspace.Gravity * (1 - v211)
            v212.Force = Vector3.new(0, v213, 0)
            p_u_208.Humanoid.JumpPower = v_u_7.BASE_JUMPPOWER
        end
        p_u_208:GetDataChangedSignal("Gravity"):Connect(v_u_214)
        p_u_208.EmoteStatusChanged:Connect(v_u_214)
        p_u_197.StateChanged:Connect(v_u_214)
        local v215 = p_u_197.IsCrouching and 1 or (p_u_208:Get("Gravity") or 1)
        local v216 = v_u_7.BASE_GRAVITY * v215
        local v217 = p_u_208.RootPart.AssemblyMass * workspace.Gravity * (1 - v216)
        v_u_209.Force = Vector3.new(0, v217, 0)
        p_u_208.Humanoid.JumpPower = v_u_7.BASE_JUMPPOWER
        p_u_208.Model.DescendantAdded:Connect(function(p218)
            if p218:IsA("BasePart") then
                p218:GetPropertyChangedSignal("AssemblyMass"):Connect(v_u_214)
                p218:GetPropertyChangedSignal("Mass"):Connect(v_u_214)
            end
        end)
        for _, v219 in pairs(p_u_208.Model:GetDescendants()) do
            if v219:IsA("BasePart") then
                v219:GetPropertyChangedSignal("AssemblyMass"):Connect(v_u_214)
                v219:GetPropertyChangedSignal("Mass"):Connect(v_u_214)
            end
        end
        p_u_208.Humanoid.Jumping:Connect(function()
            local v220 = not p_u_197.IsCrouching and p_u_208:Get("Gravity") or 1
            local v221 = v_u_7.BASE_GRAVITY * v220
            local v222 = v_u_209
            local v223 = p_u_208.RootPart.AssemblyMass * workspace.Gravity * (1 - v221)
            v222.Force = Vector3.new(0, v223, 0)
            p_u_208.Humanoid.JumpPower = v_u_7.BASE_JUMPPOWER
            p_u_197:StopSliding(true)
        end)
        p_u_208.Humanoid.StateChanged:Connect(function(_, p224)
            local v225 = p_u_197.IsCrouching and 1 or (p_u_208:Get("Gravity") or 1)
            local v226 = v_u_7.BASE_GRAVITY * v225
            local v227 = v_u_209
            local v228 = p_u_208.RootPart.AssemblyMass * workspace.Gravity * (1 - v226)
            v227.Force = Vector3.new(0, v228, 0)
            p_u_208.Humanoid.JumpPower = v_u_7.BASE_JUMPPOWER
            if p224 == Enum.HumanoidStateType.Climbing then
                p_u_197:StopSliding()
            elseif p224 == Enum.HumanoidStateType.Landed then
                p_u_197._double_jumps_used = {}
            end
        end)
        p_u_208.Humanoid.Died:Connect(function()
            p_u_197:SetSprinting(false)
            p_u_197:SetCrouching(false)
            p_u_197:StopSliding()
        end)
        p_u_208.AirborneLocallyChanged:Connect(function()
            p_u_197:_UpdateServerState("IsAirborne", p_u_208:IsAirborne())
        end)
        p_u_208.RedirectSliding:Connect(function(p229)
            if p_u_197._update_slide_direction then
                p_u_197._update_slide_direction(p229)
            end
        end)
        if p_u_197.LocalFighter.Entity and p_u_197.LocalFighter.Entity.Humanoid then
            p_u_197.LocalFighter.Entity.Humanoid.AutoJumpEnabled = v_u_16:Get("Settings Auto Jump")
        end
    end
    p_u_197.LocalFighter.EntityAdded:Connect(v230)
    if p_u_197.LocalFighter.Entity then
        task.spawn(v230, p_u_197.LocalFighter.Entity)
    end
    p_u_197._internal_local_fighter_added:Fire()
    p_u_197:_SetupControls()
    p_u_197:_ToggleAutoShoot()
    task.defer(p_u_197._DisableRobloxJumpButton, p_u_197)
end
function v_u_24._Init(p_u_231)
    v_u_18.ControlsChanged:Connect(function()
        p_u_231:_SetupControls()
        p_u_231:_ToggleAutoShoot()
    end)
    v_u_16:GetDataChangedSignal("Settings Auto Shoot"):Connect(function()
        p_u_231:_ToggleAutoShoot()
    end)
    v_u_16:GetDataChangedSignal("Settings Auto Shoot Reaction Time"):Connect(function()
        p_u_231:_ToggleAutoShoot()
    end)
    task.defer(p_u_231._HookFighter, p_u_231)
end
return v_u_24._new()