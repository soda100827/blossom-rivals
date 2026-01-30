local v_u_1 = game:GetService("CollectionService")
local v2 = game:GetService("ReplicatedStorage")
local v_u_3 = game:GetService("UserInputService")
game:GetService("GuiService")
local v_u_4 = game:GetService("RunService")
local v_u_5 = game:GetService("VRService")
local v6 = game:GetService("Players")
local v_u_7 = require(v2.Modules.CONSTANTS)
local v_u_8 = require(v2.Modules.QuaternionSpring)
local v_u_9 = require(v2.Modules.GameplayUtility)
require(v2.Modules.DebugLibrary)
local v_u_10 = require(v2.Modules.InputLibrary)
require(v2.Modules.TaskLibrary)
require(v2.Modules.TestLibrary)
local v_u_11 = require(v2.Modules.Quaternion)
local v_u_12 = require(v2.Modules.Utility)
local v_u_13 = require(v2.Modules.Spring)
local v_u_14 = require(v2.Modules.Signal)
require(v6.LocalPlayer.PlayerScripts.Controllers.PrivateServerController)
local v_u_15 = require(v6.LocalPlayer.PlayerScripts.Controllers.UserInterfaceController)
local v_u_16 = require(v6.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
local v_u_17 = require(v6.LocalPlayer.PlayerScripts.Controllers.ControlsController)
local v_u_18 = require(v6.LocalPlayer.PlayerScripts.Controllers.SettingsController)
local v_u_19 = require(v6.LocalPlayer.PlayerScripts.Controllers.DebugController.DebugState)
local v_u_20 = require(v6.LocalPlayer.PlayerScripts.Modules.CameraShaker)
local v_u_21 = require(script:WaitForChild("CameraState"))
local v_u_22 = Enum.RenderPriority.Camera.Value
local v_u_23 = Vector2.new(0.77, 1) * 0.008726646259971648
local v_u_24 = {
    ["MouseKeyboard"] = 1,
    ["Touch"] = 0.875,
    ["Gamepad"] = 0.75
}
local v_u_25 = {}
v_u_25.__index = v_u_25
function v_u_25._new()
    local v26 = v_u_25
    local v27 = setmetatable({}, v26)
    v27.StateChanged = v_u_14.new()
    v27.ActiveStateChanged = v_u_14.new()
    v27.POVStateChanged = v_u_14.new()
    v27.CustomFreecamStateChanged = v_u_14.new()
    v27.RotationDeltaApplied = v_u_14.new()
    v27.SubjectChanged = v_u_14.new()
    v27.CameraState = v_u_21.new(v27)
    v27.Rotation = Vector2.zero
    v27.ShakeCFrame = CFrame.identity
    v27.ViewModelOffsetCFrame = CFrame.identity
    v27.VRCameraCFrame = nil
    v27._current_subject = nil
    v27._current_duel_subject = nil
    v27._third_person_override = nil
    v27._external_fov_offsets = {}
    v27._is_editing_mobile_buttons = false
    v27._last_dt = 0
    v27._last_mouse_behavior = nil
    v27._gamepad_rotation_input = Vector2.zero
    v27._bobbing_tick = 0
    v27._fov_spring = v_u_13.new(60, 0.75, 30)
    v27._fov_viewmodel_offset_spring = v_u_13.new(0, 1, 20)
    v27._position_spring = v_u_13.new(Vector3.new(0, 0, 0), 0.75, 30)
    v27._pov_spring = v_u_13.new(Vector3.new(0, 0, 0), 0.875, 25)
    v27._sway_spring = v_u_13.new(Vector2.zero, 0.5, 12.5)
    v27._bobbing_speed_spring = v_u_13.new(0, 0.5, 12.5)
    v27._bobbing_value_spring = v_u_13.new(0, 0.75, 12.5)
    v27._jump_spring = v_u_13.new(0, 0.5, 15)
    v27._sliding_spring = v_u_13.new(0, 0.5, 15)
    v27._leaning_spring = v_u_13.new(0, 1, 20)
    v27._camera_shaker = nil
    v27._collision_whitelist = {}
    v27._next_collision_whitelist_fetch = 0
    v27._viewmodel_animation_spring = v_u_8.new(v_u_11.fromCFrame(CFrame.identity), 1, 10)
    v27._crosshair_disabled = false
    v27._base_fov = 80
    v27._fov_effects = true
    v27._shake_enabled = true
    v27._open_playerlist_input_down = false
    v27._inverted_identity_vector = Vector2.one
    v27._camera_sensitivity = 1
    v27._camera_sensitivity_ads_multiplier = 1
    v27._camera_sensitivity_x = 1
    v27._camera_sensitivity_y = 1
    v27._fov_offset_strength = 0
    v27._gamepad_deadzone = 0.25
    v27:_Init()
    return v27
end
function v_u_25.GetPublicState(p28, ...)
    return p28.CameraState:GetPublicState(...)
end
function v_u_25.GetCurrentSubject(p29)
    return p29._current_subject
end
function v_u_25.IsSubjectEmoting(p30)
    local v31 = p30:GetCurrentSubject()
    local v32 = v31 and v31.Entity
    if v32 then
        v32 = v31.Entity:IsEmoting()
    end
    return v32
end
function v_u_25.HasThirdPersonAccess(p33, p34)
    if p33._third_person_override == nil then
        return p33._current_subject and p33._current_subject:Get("CheaterMode") and true or (not p34 and p33:IsSubjectEmoting() and true or (v_u_19:Get("AreHandicapsEnabled") or v_u_17.CurrentControls == "Touch"))
    else
        return p33._third_person_override
    end
end
function v_u_25.HasUnlockedMouseAccess(p35)
    local v36 = p35:HasThirdPersonAccess()
    if v36 then
        v36 = v_u_17.CurrentControls == "MouseKeyboard" and true or p35:IsSubjectEmoting()
    end
    return v36
end
function v_u_25.GetLastHeartbeatDeltaTime(p37)
    return p37._last_dt
end
function v_u_25.GetRenderstepPriority(_)
    return v_u_22
end
function v_u_25.GetCameraCFrame(p38)
    if v_u_17.CurrentControls == "VR" then
        return workspace.CurrentCamera.CFrame * p38.VRCameraCFrame
    end
    if not (p38._current_subject and p38._current_subject.Entity) then
        return CFrame.identity
    end
    local v39
    if p38.CameraState:GetPublicState() == p38.CameraState.States.FirstPerson then
        v39 = CFrame.new(p38._leaning_spring.Value * Vector3.new(2, 0.1, 0))
    else
        v39 = CFrame.identity
    end
    return CFrame.new(p38._current_subject.Entity.RootPart.Position) * CFrame.new(p38._position_spring.Value) * p38:GetRotationCFrame() * v39
end
function v_u_25.GetRotationCFrame(p40, p41)
    local v42 = p41 or p40.Rotation
    return CFrame.Angles(0, v42.Y, 0) * CFrame.Angles(v42.X, 0, 0)
end
function v_u_25.GetGamepadRotationInput(p43, p44)
    return p44 and Vector2.new(p43._gamepad_rotation_input.Y, p43._gamepad_rotation_input.X) or p43._gamepad_rotation_input
end
function v_u_25.SetRotation(p45, p46)
    if not (p45._current_subject and (p45._current_subject.Entity and p45._current_subject.Entity:Get("IsFrozen"))) then
        local v47 = Vector2.new
        local v48 = p46.X
        p45.Rotation = v47(math.clamp(v48, -1.5690509975429023, 1.5690509975429023), p46.Y)
    end
end
function v_u_25.GetExternalFOVOffset(p49)
    local v50 = 0
    for _, v51 in pairs(p49._external_fov_offsets) do
        v50 = v50 + v51
    end
    return v50
end
function v_u_25.GetCameraSensitivity(p52)
    local v53 = p52._current_subject and p52._current_subject.EquippedItem
    if v53 then
        v53 = p52._current_subject.EquippedItem:Get("IsAiming")
    end
    return p52._camera_sensitivity * (v53 and p52._camera_sensitivity_ads_multiplier or 1)
end
function v_u_25.SetSubject(p54, p55)
    p54._current_subject = p55
    p54.SubjectChanged:Fire()
end
function v_u_25.SetDuelSubject(p56, p57)
    p56._current_duel_subject = p57
end
function v_u_25.SetExternalFOVOffset(p58, p59, p60)
    local v61 = p58._external_fov_offsets
    if p60 == 0 then
        p60 = nil
    end
    v61[p59] = p60
end
function v_u_25.SetThirdPersonOverride(p62, p63)
    p62._third_person_override = p63
    p62.CameraState:VerifyPOV()
end
function v_u_25.SetIsEditingMobileButtons(p64, p65)
    p64._is_editing_mobile_buttons = p65
end
function v_u_25.Freeze(p66, p67)
    if p67 and not p66.IsFrozen then
        v_u_3.MouseIconEnabled = true
        v_u_3.MouseBehavior = Enum.MouseBehavior.Default
    elseif not p67 and p66.IsFrozen then
        p66._last_mouse_behavior = nil
    end
    p66.IsFrozen = p67
    p66:Update(0)
end
function v_u_25.ApplyRotationDelta(p68, p69)
    local v70 = p69 * p68._inverted_identity_vector * p68:GetCameraSensitivity() * Vector2.new(p68._camera_sensitivity_y, p68._camera_sensitivity_x)
    p68:SetRotation(p68.Rotation + v70)
    p68.RotationDeltaApplied:Fire(v70)
end
function v_u_25.ShakeOnce(p71, ...)
    p71._camera_shaker:ShakeOnce(...)
end
function v_u_25.Shake(p72, ...)
    p72._camera_shaker:Shake(...)
end
function v_u_25.MimicRotation(p73, p74)
    local v75, v76, _ = p74:ToOrientation()
    p73:SetRotation(Vector2.new(v75, v76))
end
function v_u_25.Update(p77, p78)
    if p77.IsFrozen or p77.CameraState:GetPublicState() == p77.CameraState.States.CustomFreecam then
        return
    else
        local v79 = p78 or 0
        local v80 = p77._current_subject ~= nil and p77._current_subject:IsAlive()
        if v80 then
            v80 = p77._current_subject
        end
        local v81 = p77.CameraState
        local v82
        if v80 then
            v82 = v80:IsActive()
        else
            v82 = v80
        end
        v81:SetActive(v82)
        local v83 = p77.CameraState:GetPublicState()
        local v84 = not v83 and p77._current_duel_subject
        if v84 then
            v84 = not p77._current_duel_subject.LocalDueler
        end
        local v85
        if v84 then
            v85 = p77._current_duel_subject.Map and p77._current_duel_subject.Map:GetSpectatePart() or v_u_1:GetTagged("WaitingRoomSpectate")[1]
        else
            v85 = nil
        end
        if v85 then
            v_u_3.MouseIconEnabled = true
            v_u_3.MouseBehavior = Enum.MouseBehavior.Default
            workspace.CurrentCamera.CameraSubject = nil
            workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
            workspace.CurrentCamera.CFrame = v85.CFrame
            return
        else
            local v86 = v83 == p77.CameraState.States.ThirdPersonUnlockedMouse and true or not (v80 and v80.IsLocalPlayer)
            local v87
            if v83 then
                v87 = v83 ~= p77.CameraState.States.ThirdPersonUnlockedMouse
            else
                v87 = v83
            end
            local v88
            if v80 then
                v88 = v80.EquippedItem
            else
                v88 = v80
            end
            local v89 = p77:_Modal()
            local v90
            if v89 then
                v90 = v_u_17.CurrentControls == "MouseKeyboard"
            else
                v90 = v89
            end
            local v91 = v87 and (not v86 and (v_u_17.CurrentControls == "MouseKeyboard" and not v90)) and Enum.MouseBehavior.LockCenter or Enum.MouseBehavior.Default
            local v92 = workspace.CurrentCamera.CameraType
            local v93 = workspace.CurrentCamera
            local v94
            if v80 and v80.Entity then
                v94 = v80.Entity.Humanoid or nil
            else
                v94 = nil
            end
            v93.CameraSubject = v94
            workspace.CurrentCamera.CameraType = v87 and Enum.CameraType.Scriptable or Enum.CameraType.Custom
            v_u_3.MouseIconEnabled = v90 or (not (v88 and v80) or (not v80.IsLocalPlayer or (v_u_17.CurrentControls == "Touch" and true or p77._crosshair_disabled and v86)))
            if v91 == Enum.MouseBehavior.LockCenter or v91 ~= p77._last_mouse_behavior then
                v_u_3.MouseBehavior = v91
                p77._last_mouse_behavior = v91
            end
            if not v87 then
                p77:MimicRotation(workspace.CurrentCamera.CFrame.Rotation * CFrame.Angles(0.17453292519943295, 0, 0))
            end
            if v80 then
                local v95 = CFrame.new(v80.Entity.RootPart.Position)
                local v96
                if v92 == Enum.CameraType.Custom and workspace.CurrentCamera.CameraType ~= Enum.CameraType.Custom then
                    v96 = (workspace.CurrentCamera.CFrame.Position - v95.Position).Magnitude < 128
                else
                    v96 = false
                end
                if v96 then
                    p77._fov_spring.Value = workspace.CurrentCamera.FieldOfView
                end
                local v97 = v80.IsLocalPlayer
                v80:IsSprinting()
                local v98 = v80:IsCrouching()
                local v99 = v80:IsSliding()
                local v100 = v80:IsGrounded()
                local v101 = v80 and (v80.Entity and v80.Entity.Humanoid)
                if v101 then
                    v101 = v80.Entity.Humanoid:GetState() == Enum.HumanoidStateType.Climbing
                end
                local v102 = v80:GetRotationCFrame()
                local v103 = v80:GetCameraSway() * 0.25
                local v104 = v80:GetCameraLean()
                local v105 = v80.Entity:GetClampedVelocity()
                local v106 = (v105 * Vector3.new(1, 0, 1)).Magnitude
                p77._fov_viewmodel_offset_spring.Speed = 20 * v80:GetAimSpeed()
                p77._fov_viewmodel_offset_spring.Target = v83 == p77.CameraState.States.ThirdPersonUnlockedMouse and 0 or v80:GetFOVOffset() * p77._fov_offset_strength
                local v107 = p77._fov_spring
                local v108 = p77._base_fov
                local v109
                if p77._fov_effects then
                    local v110 = v106 - v_u_7.BASE_WALKSPEED
                    v109 = math.max(0, v110) * 10 / v_u_7.BASE_WALKSPEED or 0
                else
                    v109 = 0
                end
                v107.Target = v108 + v109 + p77:GetExternalFOVOffset()
                local v111 = p77._fov_spring.Value + p77._fov_viewmodel_offset_spring.Value * (p77._fov_spring.Value / 80)
                workspace.CurrentCamera.FieldOfView = v111
                p77._position_spring.Target = Vector3.new(0, 1.75, 0) + Vector3.new(0, v99 and -3 or (v101 and -2.5 or (v98 and -2 or 0)), 0)
                if workspace.CurrentCamera.CameraType == Enum.CameraType.Scriptable then
                    if v96 then
                        p77._position_spring.Value = workspace.CurrentCamera.CFrame:ToObjectSpace(v95):Inverse().Position * 0.5
                    end
                    if v_u_17.CurrentControls == "Gamepad" and not (v89 or v_u_15:IsPageOpen()) then
                        p77:ApplyRotationDelta(p77._gamepad_rotation_input * p77:_GetFOVMultiplier() * v79 * 60)
                    end
                    local v112 = CFrame.new(p77._position_spring.Value)
                    local v113 = CFrame.identity
                    local v114 = CFrame.identity
                    if v83 == p77.CameraState.States.FirstPerson and not v97 then
                        p77._bobbing_speed_spring.Target = v106 / v_u_7.BASE_WALKSPEED * (v100 and 1 or 0) * 0.111
                        p77._bobbing_tick = p77._bobbing_tick + p77._bobbing_speed_spring.Value * v79 * 60
                        local v115 = p77._bobbing_value_spring
                        local v116 = p77._bobbing_tick
                        local v117 = math.sin(v116)
                        v115.Target = (math.abs(v117) - 0.5) * (v106 / v_u_7.BASE_WALKSPEED) ^ 2 * (v99 and 0 or 1) * 0.125
                        local v118 = p77._bobbing_value_spring.Value
                        v113 = CFrame.new(0, v118, 0)
                        v114 = CFrame.Angles(v118 * 0.08726646259971647, 0, 0)
                    end
                    local v119 = p77._pov_spring.Value
                    local v120 = CFrame.new(v119)
                    local v121 = p77._sway_spring
                    v121.Value = v121.Value + Vector2.new(v103.Y * 0.5, v103.X)
                    local v122 = p77._sway_spring.Value * (v97 and 0 or 0.025)
                    local v123 = CFrame.Angles(v122.X, 0, v122.Y)
                    local v124 = v97 and CFrame.identity
                    if not v124 then
                        local v125 = CFrame.Angles
                        local v126 = tick() * 0.23983 % 6.283185307179586
                        local v127 = math.sin(v126) * 0.004363323129985824
                        local v128 = tick() * 0.372721 % 6.283185307179586
                        local v129 = math.sin(v128) * 0.004363323129985824
                        local v130 = tick() * 0.43123 % 6.283185307179586
                        v124 = v125(v127, v129, math.sin(v130) * 0.004363323129985824)
                    end
                    p77._jump_spring.Target = v105.Y
                    local v131 = p77._jump_spring.Value / v_u_7.BASE_GRAVITY * (v97 and 0 or 0.5)
                    local v132 = CFrame.Angles
                    local v133 = -v131 / 15
                    local v134 = math.rad(v133)
                    local v135 = v132(math.clamp(v134, -0.7853981633974483, 0.7853981633974483), 0, 0)
                    p77._sliding_spring.Target = v99 and 1 or 0
                    local v136 = p77._sliding_spring.Value
                    local v137 = CFrame.Angles(0, 0, -0.08726646259971647 * v136)
                    p77._leaning_spring.Target = v83 == p77.CameraState.States.FirstPerson and v104 and v104 or 0
                    local v138 = p77._leaning_spring.Value
                    local v139 = CFrame.new(v138 * Vector3.new(2, 0.1, 0)) * CFrame.Angles(0, 0, v138 * -0.08726646259971647)
                    local v140 = v95 * v112 * (v113 * v102 * v114 * v120 * v123 * v124 * v135 * v137 * v139 * p77.ViewModelOffsetCFrame * p77.ShakeCFrame)
                    local v141 = v140.Position
                    if tick() > p77._next_collision_whitelist_fetch then
                        p77._next_collision_whitelist_fetch = tick() + 5
                        p77._collision_whitelist = v_u_9:GetRaycastWhitelist(v80:Get("EnvironmentID"))
                    end
                    local v142 = v_u_12:Raycast(v80.Entity.RootPart.Position, v140.Position, (v140.Position - v80.Entity.RootPart.Position).Magnitude, p77._collision_whitelist, Enum.RaycastFilterType.Include)
                    if v142.Instance then
                        v141 = v80.Entity.RootPart.Position + (v140.Position - v80.Entity.RootPart.Position).Unit * ((v80.Entity.RootPart.Position - v142.Position).Magnitude - 0.5)
                    end
                    workspace.CurrentCamera.CFrame = CFrame.new(v141) * v140.Rotation
                end
            else
                workspace.CurrentCamera.FieldOfView = p77._base_fov
                return
            end
        end
    end
end
function v_u_25._UpdateSettings(p143)
    p143._crosshair_disabled = v_u_16:Get("Settings Crosshair Disabled")
    p143._base_fov = v_u_16:Get("Settings Camera FOV")
    p143._fov_effects = v_u_16:Get("Settings Camera FOV Effects")
    p143._shake_enabled = v_u_16:Get("Settings Camera Shake")
    p143._inverted_identity_vector = Vector2.new(v_u_16:Get("Settings Camera Inverted Y") and -1 or 1, v_u_16:Get("Settings Camera Inverted X") and -1 or 1)
    p143._camera_sensitivity = v_u_16:Get("Settings Camera Sensitivity")
    p143._camera_sensitivity_ads_multiplier = v_u_16:Get("Settings Camera Sensitivity ADS")
    p143._camera_sensitivity_x = v_u_16:Get("Settings Camera Sensitivity X")
    p143._camera_sensitivity_y = v_u_16:Get("Settings Camera Sensitivity Y")
    p143._fov_offset_strength = v_u_16:Get("Settings Camera Zoom Effects")
    p143._gamepad_deadzone = v_u_16:Get("Settings Gamepad Deadzone")
end
function v_u_25._Modal(p144)
    local v145 = p144._current_duel_subject and p144._current_duel_subject.DuelInterface
    if v145 then
        v145 = p144._current_duel_subject.DuelInterface.Scoreboard:IsOpen()
    end
    return v145 or (v_u_15:IsPageOpen() or p144._open_playerlist_input_down)
end
function v_u_25._GetFOVMultiplier(p146)
    return workspace.CurrentCamera.FieldOfView < p146._base_fov and workspace.CurrentCamera.FieldOfView / p146._base_fov or 1
end
function v_u_25._InputChanged(p147, p148, p149)
    if p149 or p147._is_editing_mobile_buttons then
        return
    elseif v_u_17.CurrentControls == "MouseKeyboard" and (p148.UserInputType ~= Enum.UserInputType.MouseMovement and p148.UserInputType ~= Enum.UserInputType.MouseWheel) then
        return
    else
        local v150 = v_u_24[v_u_17.CurrentControls]
        if v_u_17.CurrentControls == "MouseKeyboard" or v_u_17.CurrentControls == "Touch" then
            p147:ApplyRotationDelta(Vector2.new(p148.Delta.Y, p148.Delta.X) * v_u_23 * v150 * p147:_GetFOVMultiplier() * -1)
        elseif v_u_17.CurrentControls == "Gamepad" and (p148.KeyCode == Enum.KeyCode.Thumbstick1 or p148.KeyCode == Enum.KeyCode.Thumbstick2) then
            local v151 = (Vector2.new(p148.Position.X, p148.Position.Y).Magnitude - p147._gamepad_deadzone) / (1 - p147._gamepad_deadzone)
            local v152 = math.max(0, v151)
            local v153 = p148.Position.X * v152
            local v154 = p148.Position.Y * v152 * 10 + 0.5
            local v155 = math.floor(v154) * v150
            local v156 = v153 * 10 + 0.5
            local v157 = -math.floor(v156) * v150
            p147._gamepad_rotation_input = Vector2.new(v155, v157) * 0.01
        end
    end
end
function v_u_25._Setup(p_u_158)
    if v_u_5:GetUserCFrameEnabled(Enum.UserCFrame.RightHand) then
        p_u_158.VRCameraCFrame = v_u_5:GetUserCFrame(Enum.UserCFrame.RightHand)
    end
    p_u_158._camera_shaker = v_u_20.new(Enum.RenderPriority.Camera.Value + 1, function(p159)
        p_u_158.ShakeCFrame = p_u_158._shake_enabled and p159 and p159 or CFrame.identity
    end)
    p_u_158._camera_shaker:Start()
end
function v_u_25._Init(p_u_160)
    p_u_160.StateChanged:Connect(function()
        local v161 = p_u_160.CameraState:GetPublicState()
        p_u_160._pov_spring.Target = v161 == p_u_160.CameraState.States.ThirdPerson and Vector3.new(3, 1.5, 7.5) or (v161 == p_u_160.CameraState.States.ThirdPersonMirrored and Vector3.new(-3, 1.5, 7.5) or (v161 == p_u_160.CameraState.States.ThirdPersonUnlockedMouse and Vector3.new(0, 3, 10) or Vector3.new(0, 0, 0)))
    end)
    p_u_160.CameraState.StateChanged:Connect(function(p162, p163)
        p_u_160.StateChanged:Fire(p162, p163)
        if not (p162 and p163) then
            p_u_160.ActiveStateChanged:Fire(p162, p163)
        end
        if p162 == p_u_160.CameraState.States.CustomFreecam or p163 == p_u_160.CameraState.States.CustomFreecam then
            p_u_160.CustomFreecamStateChanged:Fire(p162, p163)
        end
        local v164 = table.find(p_u_160.CameraState.POVStates, p162)
        local v165 = table.find(p_u_160.CameraState.POVStates, p163)
        if v164 or v165 then
            p_u_160.POVStateChanged:Fire(p162, p163, v164 and v165)
        end
    end)
    v_u_17.InputBegan:Connect(function(p166, p167)
        local v168 = p_u_160.CameraState:GetPublicState()
        local v169
        if v168 == p_u_160.CameraState.States.CustomFreecam then
            v169 = v_u_12:IsTextBoxFocused()
        else
            v169 = p167
        end
        if not v169 and v_u_10:InputIs(p166, "HideHUD") then
            v_u_18:ChangeSetting("Settings Hide HUD", not v_u_16:Get("Settings Hide HUD"))
        end
        if p_u_160.IsFrozen or not v168 then
            return
        elseif p167 or not v_u_10:InputIs(p166, "SwitchCameraPOV") then
            if not p167 and v_u_10:InputIs(p166, "OpenPlayerList") then
                p_u_160._open_playerlist_input_down = true
            end
        else
            p_u_160.CameraState:TogglePOV()
        end
    end)
    v_u_17.InputChanged:Connect(function(...)
        if not p_u_160.IsFrozen and p_u_160.CameraState:GetPublicState() then
            p_u_160:_InputChanged(...)
        end
    end)
    v_u_17.InputEnded:Connect(function(p170, _)
        if v_u_10:InputIs(p170, "OpenPlayerList") then
            p_u_160._open_playerlist_input_down = false
        end
    end)
    v_u_5.UserCFrameChanged:Connect(function(_, _)
        if not p_u_160.IsFrozen and p_u_160.CameraState:GetPublicState() then
            local v171 = v_u_5:GetUserCFrameEnabled(Enum.UserCFrame.RightHand)
            if v171 then
                v171 = v_u_5:GetUserCFrame(Enum.UserCFrame.RightHand)
            end
            local v172 = v_u_5:GetUserCFrameEnabled(Enum.UserCFrame.Head)
            if v172 then
                v172 = v_u_5:GetUserCFrame(Enum.UserCFrame.Head)
            end
            local v173 = v172 or (v171 or CFrame.identity)
            local v174 = v171 or (v172 or CFrame.identity)
            p_u_160.VRCameraCFrame = CFrame.new(v173.Position) * (v174 - v174.Position)
        end
    end)
    v_u_4:BindToRenderStep("CameraController", v_u_22, function(p175)
        p_u_160._last_dt = p175
        p_u_160:Update(p175)
    end)
    v_u_16:GetDataChangedSignal("Settings Crosshair Disabled"):Connect(function()
        p_u_160:_UpdateSettings()
    end)
    v_u_16:GetDataChangedSignal("Settings Camera FOV"):Connect(function()
        p_u_160:_UpdateSettings()
    end)
    v_u_16:GetDataChangedSignal("Settings Camera FOV Effects"):Connect(function()
        p_u_160:_UpdateSettings()
    end)
    v_u_16:GetDataChangedSignal("Settings Camera Inverted X"):Connect(function()
        p_u_160:_UpdateSettings()
    end)
    v_u_16:GetDataChangedSignal("Settings Camera Inverted Y"):Connect(function()
        p_u_160:_UpdateSettings()
    end)
    v_u_16:GetDataChangedSignal("Settings Camera Shake"):Connect(function()
        p_u_160:_UpdateSettings()
    end)
    v_u_16:GetDataChangedSignal("Settings Camera Sensitivity"):Connect(function()
        p_u_160:_UpdateSettings()
    end)
    v_u_16:GetDataChangedSignal("Settings Camera Sensitivity ADS"):Connect(function()
        p_u_160:_UpdateSettings()
    end)
    v_u_16:GetDataChangedSignal("Settings Camera Zoom Effects"):Connect(function()
        p_u_160:_UpdateSettings()
    end)
    v_u_16:GetDataChangedSignal("Settings Gamepad Deadzone"):Connect(function()
        p_u_160:_UpdateSettings()
    end)
    v_u_16:GetDataChangedSignal("Settings Camera Sensitivity X"):Connect(function()
        p_u_160:_UpdateSettings()
    end)
    v_u_16:GetDataChangedSignal("Settings Camera Sensitivity Y"):Connect(function()
        p_u_160:_UpdateSettings()
    end)
    v_u_16.SettingsSliderChanged:Connect(function(p176, p177)
        if p176 == "Settings Camera FOV" then
            p_u_160._base_fov = p177
        end
    end)
    p_u_160:_Setup()
    p_u_160:_UpdateSettings()
end
return v_u_25._new()