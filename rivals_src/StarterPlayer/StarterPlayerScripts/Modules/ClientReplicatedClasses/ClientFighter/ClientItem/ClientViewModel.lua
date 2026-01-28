local v1 = game:GetService("ReplicatedStorage")
game:GetService("UserInputService")
game:GetService("ContentProvider")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.CONSTANTS)
local v_u_4 = require(v1.Modules.CosmeticLibrary)
local v_u_5 = require(v1.Modules.ReplicatedClass)
local v_u_6 = require(v1.Modules.SoundLibrary)
local v_u_7 = require(v1.Modules.ItemLibrary)
local v_u_8 = require(v1.Modules.Utility)
local v_u_9 = require(v1.Modules.Spring)
local v_u_10 = require(v1.Modules.Signal)
local v_u_11 = require(v2.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
local v_u_12 = require(v2.LocalPlayer.PlayerScripts.Controllers.CameraController)
local v_u_13 = require(v2.LocalPlayer.PlayerScripts.Controllers.WrapController)
local v_u_14 = require(v2.LocalPlayer.PlayerScripts.Modules.Charm)
local v_u_15 = require(script:WaitForChild("ViewModelAnimator"))
local v_u_16 = workspace:WaitForChild("ViewModels")
local v_u_17 = v_u_16:WaitForChild("FirstPerson")
local v_u_18 = v1.Assets:WaitForChild("Temp"):WaitForChild("ViewModels")
local v_u_19 = v2.LocalPlayer.PlayerScripts.UserInterface.ScopeGlareGui1
local v_u_20 = v2.LocalPlayer.PlayerScripts.UserInterface.ScopeGlareGui2
local v_u_21 = v2.LocalPlayer.PlayerScripts.Assets.Misc.MuzzleFlashes
local v_u_22 = v2.LocalPlayer.PlayerScripts.Assets.Misc.ViewModelRoot
local v_u_23 = v2.LocalPlayer.PlayerScripts.Assets.ViewModels
local v_u_24 = v2.LocalPlayer.PlayerScripts.Modules.Charms
local v_u_25 = Color3.fromRGB(0, 0, 0)
local v_u_26 = setmetatable({}, v_u_5)
v_u_26.__index = v_u_26
function v_u_26.new(p27, p28)
    local v29 = v_u_5.new(p27)
    local v30 = v_u_26
    local v31 = setmetatable(v29, v30)
    v31.AnimationPlayed = v_u_10.new()
    v31.AnimationStopped = v_u_10.new()
    v31.Equipped = v_u_10.new()
    v31.Unequipped = v_u_10.new()
    v31.ClientItem = p28
    v31.Name = v31:Get("Name")
    v31.Info = v_u_7.ViewModels[v31.Name]
    v31.Model = v_u_22:Clone()
    v31.ItemModel = v_u_8:LookThrough(v_u_23, v31.Name):Clone()
    v31.Animator = v_u_15.new(v31)
    v31.Charm = nil
    v31.ShouldPlayReloadAnimationInstantly = nil
    v31.CurrentBobbingValue = Vector2.zero
    v31.CurrentRecoilValue = Vector3.new(0, 0, 0)
    v31.CurrentSwayValue = Vector2.zero
    v31.CurrentJumpValue = 0
    v31.CurrentAimValue = 0
    v31.CurrentLandingValue = 0
    v31.AimingAnimationEnabled = false
    v31._serial = p27
    v31._destroyed = false
    v31._connections = {}
    v31._preloaded_sounds = {}
    v31._last_hitmarker_sounds = {}
    v31._left_arm = v31.Model.LeftArm
    v31._left_arm_shirt_texture = v31._left_arm.ShirtTexture
    v31._right_arm = v31.Model.RightArm
    v31._right_arm_shirt_texture = v31._right_arm.ShirtTexture
    v31._shirt_id = nil
    v31._left_arm_color = nil
    v31._right_arm_color = nil
    v31._body_model = nil
    v31._original_scale = v31.ItemModel:GetScale()
    v31._equip_spring = v_u_9.new(0, 0.625, 12.5)
    v31._aim_spring = v_u_9.new(0, 1, 30)
    v31._crouching_spring = v_u_9.new(0, 0.875, 17.5)
    v31._sliding_spring = v_u_9.new(0, 0.5, 12.5)
    v31._sprinting_spring = v_u_9.new(0, 0.75, v31.Info.PlayAnimationsInstantly and 100 or 15)
    v31._bobbing_speed_spring = v_u_9.new(0, 1, 20)
    v31._bobbing_value_spring = v_u_9.new(Vector2.zero, 0.5, 12.5)
    v31._sway_spring = v_u_9.new(Vector2.zero, 0.5, 12.5)
    v31._landing_spring = v_u_9.new(0, 0.75, 10)
    v31._jump_spring = v_u_9.new(0, 0.5, 15)
    v31._tilt_spring = v_u_9.new(Vector2.zero, 0.5, 15)
    v31._recoil_spring = v_u_9.new(Vector3.new(0, 0, 0), 0.875, 100)
    v31._unrecoil_spring = v_u_9.new(Vector3.new(0, 0, 0), 0.375, 25)
    v31._head_raycast_spring = v_u_9.new(0, 1, 50)
    v31._raycast_tilt_spring = v_u_9.new(0, 1, 50)
    v31._impulse_position_spring = v_u_9.new(Vector3.new(0, 0, 0), 0.25, 20)
    v31._inspect_spring = v_u_9.new(0, 1, 20)
    v31._render_cooldown = 0
    v31._is_equipped = false
    v31._root_part_offset_inverse = v31.Info.RootPartOffset:Inverse()
    v31._custom_sprinting_enabled = 0
    v31._bobbing_tick = 0
    v31._aim_position_attachment = nil
    v31._aim_lookat_attachment = nil
    v31._center_attachment = nil
    v31._muzzle_attachments = {}
    v31._charm_attachment_model = nil
    v31._charm_pivot_attachment = nil
    v31._scope_glare_attachment = nil
    v31._scope_glare_gui1 = nil
    v31._scope_glare_gui2 = nil
    v31._was_first_person = nil
    v31._local_transparency_modifiers = {}
    v31._local_transparency_modifier_update = {}
    v31._hidden_submodels = {}
    v31._animation_context_submodels = {}
    v31._arm_submodels = {}
    v31._original_wrap_properties = nil
    v31._original_object_transparencies = {}
    v31._right_arm_wrapped_part = nil
    v31._left_arm_wrapped_part = nil
    v31._wrapped_only_objects = {}
    v31:_Init()
    return v31
end
function v_u_26.GetCameraOffset(p32)
    if v_u_8:AngleBetweenVectors(p32.Model.Camera.CFrame.LookVector, p32.Model.HumanoidRootPart.CFrame.LookVector) > 1.5707963267948966 then
        return CFrame.identity
    else
        return p32.Model.HumanoidRootPart.CFrame:ToObjectSpace(p32.Model.Camera.CFrame)
    end
end
function v_u_26.GetImage(p33)
    return p33.Info.Image
end
function v_u_26.IsEquipped(p34)
    return p34._is_equipped
end
function v_u_26.IsRenderingDisabled(p35)
    local v36 = tick() >= p35._render_cooldown and (not (p35.Animator:IsRenderingDisabled() or p35.ClientItem.ClientFighter:Get("IsHiddenByEmotes")) and (not p35.ClientItem.ClientFighter:Get("IsHiddenByCutscene") and p35.ClientItem.ClientFighter.Entity))
    if v36 then
        v36 = p35.ClientItem.ClientFighter.Entity:IsEmoting()
    end
    return v36
end
function v_u_26.AreAnimationsPlaying(p37, ...)
    return p37.Animator:AreAnimationsPlaying(...)
end
function v_u_26.IsAnimationPlaying(p38, ...)
    return p38.Animator:IsAnimationPlaying(...)
end
function v_u_26.GetAnimationTrack(p39, ...)
    return p39.Animator:GetAnimationTrack(...)
end
function v_u_26.GetAnimationKeys(p40, ...)
    return p40.Animator:GetAnimationKeys(...)
end
function v_u_26.Inspect(p41, ...)
    return p41.Animator:Inspect(...)
end
function v_u_26.StopInspecting(p42, ...)
    return p42.Animator:StopInspecting(...)
end
function v_u_26.PlayAnimation(p43, ...)
    return p43.Animator:PlayAnimation(...)
end
function v_u_26.StopAnimation(p44, ...)
    return p44.Animator:StopAnimation(...)
end
function v_u_26.ChangeEquipAnimation(p45, ...)
    return p45.Animator:ChangeEquipAnimation(...)
end
function v_u_26.ChangeIdleAnimation(p46, ...)
    return p46.Animator:ChangeIdleAnimation(...)
end
function v_u_26.ChangeSprintAnimation(p47, ...)
    return p47.Animator:ChangeSprintAnimation(...)
end
function v_u_26.ChangeInspectAnimation(p48, ...)
    return p48.Animator:ChangeInspectAnimation(...)
end
function v_u_26.GetMuzzlePosition(p49)
    local v50
    if p49:IsRenderingDisabled() then
        v50 = p49:_GetDefaultMuzzlePosition()
    else
        v50 = nil
    end
    if v50 or #p49._muzzle_attachments <= 0 then
        if v50 or not (p49._body_model and p49._body_model.PrimaryPart) then
            return v50 or p49:_GetDefaultMuzzlePosition()
        else
            return p49._body_model.PrimaryPart.Position
        end
    else
        local v51 = Vector3.new(0, 0, 0)
        for _, v52 in pairs(p49._muzzle_attachments) do
            v51 = v51 + v52.WorldPosition
        end
        return v51 / #p49._muzzle_attachments
    end
end
function v_u_26.GetWrap(p53)
    local v54 = p53.ClientItem.ClientFighter:Get("IsSpectating") or not v_u_11:Get("Settings Wraps Disabled")
    if v54 then
        v54 = p53:Get("Wrap")
    end
    return v54
end
function v_u_26.SetParent(p55, p56)
    p55.Model.Parent = p56
    p55.Animator:LoadAnimations()
end
function v_u_26.SetArmsData(p57, p58, p59, p60)
    local v61 = not p58 or typeof(p58) == "string"
    local v62 = "Argument 1 invalid, expected a string or nil, got " .. tostring(p58)
    assert(v61, v62)
    p57._shirt_id = p58 or ""
    p57._left_arm_color = p59 or v_u_25
    p57._right_arm_color = p60 or v_u_25
    p57:_UpdateArms()
end
function v_u_26.SetAiming(p63, p64)
    local v65 = typeof(p64) == "boolean"
    assert(v65, "Argument 1 invalid, expected a boolean")
    local _ = p63.AimingAnimationEnabled
    p63._aim_spring.Target = p64 and 1 or 0
    p63._aim_spring.Speed = 30 * (p64 and (p63.ClientItem.Info.AimSpeed or 1) or 1)
    if p64 then
        p63:StopInspecting()
    end
end
function v_u_26.SetCustomSprintingEnabled(p66, p67, p68)
    if p67 then
        p66._custom_sprinting_enabled = tick() + p67
    end
    if p68 then
        p66._sprinting_spring.Value = 0
    end
end
function v_u_26.SetCFrame(p69, p70)
    p69.Model.PrimaryPart.CFrame = p70
end
function v_u_26.CreateSound(p71, ...)
    return p71.ClientItem:CreateSound(...)
end
function v_u_26.CreateSpectatorSound(p72, ...)
    return p72.ClientItem:CreateSpectatorSound(...)
end
function v_u_26.HideCharm(p73, p74)
    if p73.Charm then
        p73.Charm:Hide(p74)
    end
end
function v_u_26.HideSubModel(p_u_75, p_u_76, p77)
    p_u_75._hidden_submodels[p_u_76] = (p_u_75._hidden_submodels[p_u_76] or 0) + 1
    p_u_75:_UpdateSubModelVisibility()
    local v_u_78 = p_u_75._hidden_submodels[p_u_76]
    task.delay(p77, function()
        if p_u_75._hidden_submodels[p_u_76] == v_u_78 then
            p_u_75._hidden_submodels[p_u_76] = false
            p_u_75:_UpdateSubModelVisibility()
        end
    end)
end
function v_u_26.Impulse(p79, p80, p81, p82, p83)
    p79._impulse_position_spring.Position = p83 and p79._impulse_position_spring.Target or p79._impulse_position_spring.Position
    p79._impulse_position_spring.Velocity = p80
    p79._impulse_position_spring.Damper = p81 or p79._impulse_position_spring.Damper
    p79._impulse_position_spring.Speed = p82 or p79._impulse_position_spring.Speed
end
function v_u_26.ApplyRecoil(p84, p85)
    local v86 = typeof(p85) == "Vector3"
    assert(v86, "Argument 1 invalid, expected a Vector3")
    local v87 = p84._recoil_spring
    v87.Target = v87.Target + p85
    local v88 = p84._unrecoil_spring
    v88.Target = v88.Target + p85
end
function v_u_26.Equip(p89, p90)
    p89._is_equipped = true
    p89._render_cooldown = tick() + 0.1
    p89.Animator:SetInspectCooldown(0)
    p89.Animator:PlayIdleAnimation()
    p89:CreateSound(v_u_6.EquipSounds[math.random(#v_u_6.EquipSounds)], p90 and 0.25 or 0.5, 0.9 + 0.2 * math.random(), true, 5)
    p89.Equipped:Fire(p90)
    if p90 then
        p89._equip_spring.Value = 0.5
    elseif not p89.Animator:PlayEquipAnimation() then
        p89._equip_spring.Value = 1
    end
end
function v_u_26.Unequip(p91)
    p91._is_equipped = false
    p91.Unequipped:Fire()
    if p91._highlight then
        p91._highlight:Destroy()
        p91._highlight = nil
    end
    p91.Animator:StopAllAnimations()
end
function v_u_26.MuzzleFlash(p92)
    if p92._aim_spring.Target < 1 or not v_u_11:Get("Settings Aiming Hides Muzzle Flashes") then
        for _, v93 in pairs(p92._muzzle_attachments) do
            v_u_8:PlayParticles(v93)
        end
    end
end
function v_u_26.PlayHitAnimation(p94, p95)
    if p95 and p94.Info.Animations.HeavyAttackAnimationHit then
        p94:PlayAnimation("HeavyAttackAnimationHit", nil, 0)
    end
end
function v_u_26.PlayHitmarkerSound(p96, p97, p98)
    if #p96._last_hitmarker_sounds > 10 then
        for v99 = #p96._last_hitmarker_sounds % 10, 1, -1 do
            p96._last_hitmarker_sounds[v99]:Destroy()
            table.remove(p96._last_hitmarker_sounds, v99)
        end
    end
    if p97 then
        p96:_CreateHitmarkerSound("rbxassetid://16537449730", 3 / p98, 1 + 0.2 * math.random(), script, true, 1)
        p96:_CreateHitmarkerSound("rbxassetid://16537337310", 2 / p98, 1 + 0.2 * math.random(), script, true, 1)
    else
        p96:_CreateHitmarkerSound("rbxassetid://13110130082", 1.5 / p98, 1 + 0.2 * math.random(), script, true, 1)
    end
end
function v_u_26.Update(p100, p101, p102, p103)
    if not p103.IsActive then
        p100:SetParent(v_u_18)
        return
    end
    local v104 = p100.ClientItem.ClientFighter:GetCameraSway(true) * 35
    local v105 = p100.ClientItem.ClientFighter.Entity.Humanoid:GetState()
    local v106 = p100.Animator:GetSprintTrack()
    local v107 = p100._aim_spring.Value * (1 - p100._inspect_spring.Value * 0.125)
    local v108 = 1 - v107
    local v109 = p100._recoil_spring.Value - p100._unrecoil_spring.Value
    local v110 = p102.IsActuallySprinting
    if v110 then
        v110 = p100._aim_spring.Target == 0
    end
    if p100._highlight or (not p102.IsActuallyFirstPerson or (p100:IsRenderingDisabled() or not v_u_11:Get("Settings ViewModel Highlight"))) then
        if p100._highlight and not p102.IsActuallyFirstPerson then
            p100._highlight:Destroy()
            p100._highlight = nil
        end
    else
        p100._highlight = Instance.new("Highlight")
        p100._highlight.Name = "ViewModel"
        p100._highlight.FillTransparency = 1
        p100._highlight.OutlineTransparency = 0.875
        p100._highlight.OutlineColor = Color3.new()
        p100._highlight.Adornee = p100.Model
        p100._highlight.Parent = p100.Model
    end
    if v106 then
        if v110 and not v106.IsPlaying then
            p100.Animator:PlaySprintAnimation()
        elseif not v110 and v106.IsPlaying then
            p100.Animator:StopSprintAnimation()
        end
        if v106.IsPlaying then
            v106:AdjustSpeed(p100.Animator.SprintTrackSpeed * p100._bobbing_speed_spring.Value / 0.1111111111111111 * 0.8)
        end
    end
    local v111 = p102.IsActuallyFirstPerson and 0 or 1
    p100._left_arm.Transparency = v111
    p100._right_arm.Transparency = v111
    p100._left_arm_shirt_texture.Transparency = v111
    p100._right_arm_shirt_texture.Transparency = v111
    if p100._scope_glare_gui1 and p100._scope_glare_gui2 then
        local v112 = (workspace.CurrentCamera.CFrame.Position - p100._scope_glare_attachment.WorldPosition).Unit
        local v113 = p100.ClientItem.ClientFighter.Entity.RootPart.CFrame.LookVector
        local v114 = p100._scope_glare_gui1
        local v115 = not p102.IsActuallyFirstPerson
        if v115 then
            if p100._aim_spring.Target >= 1 then
                v115 = v_u_8:AngleBetweenVectors(v112, v113) < 0.7853981633974483
            else
                v115 = false
            end
        end
        v114.Enabled = v115
        p100._scope_glare_gui2.Enabled = false
    end
    if p100:IsRenderingDisabled() then
        p100:SetCFrame(CFrame.identity)
    elseif p102.IsActuallyFirstPerson then
        local v116 = p100.Animator:IsInspectAnimationPlaying()
        p100._inspect_spring.Target = v116 and 1 or 0
        local v117 = (v_u_3.DEVICE == "VR" and workspace.CurrentCamera.CFrame * v_u_12.VRCameraCFrame.Rotation + v_u_12.VRCameraCFrame.Position * 1.4142135623730951 / 2 or workspace.CurrentCamera.CFrame) * p103.ViewModelOffset * p100.Info.RootPartOffset
        local v118 = p100._sway_spring
        v118.Value = v118.Value + Vector2.new(v104.Y * 0.5, v104.X)
        local v119 = p100._sway_spring.Value * 0.0003
        local v120 = p100._aim_lookat_attachment and p100._aim_lookat_attachment.WorldCFrame:ToObjectSpace(p100.Model.PrimaryPart.CFrame) or CFrame.identity
        local v121 = CFrame.new(v119.Y * 1, -v119.X * 2, 0):Lerp(v120:Inverse() * CFrame.Angles(0, v119.Y * 0.05625, 0) * CFrame.Angles(v119.X * 0.1, 0, 0) * v120, v107)
        local v122 = p100._impulse_position_spring.Value
        local v123 = CFrame.new(v122)
        local v124 = p100._equip_spring.Value
        local v125 = CFrame.new(0, -0.5 * v124, 0.25 * v124) * CFrame.Angles(-0.7853981633974483 * v124, 0, 0.7853981633974483 * v124)
        p100._sliding_spring.Target = p102.IsSliding and 1 or 0
        local v126 = p100._sliding_spring.Value * v108
        local v127 = CFrame.Angles(0, 0, -0.3490658503988659 * v126)
        local v128
        if p100.Info.DisableProceduralSprinting then
            v128 = CFrame.identity
        else
            local v129 = v110 and not (v106 and v106.IsPlaying or v116)
            if v129 then
                v129 = tick() > p100._custom_sprinting_enabled
            end
            p100._sprinting_spring.Target = (v129 or v105 == Enum.HumanoidStateType.Climbing) and 1 or 0
            local v130 = p100._sprinting_spring.Value
            v128 = CFrame.Angles(0, 0.4363323129985824 * v130, 0) * CFrame.Angles(-0.4363323129985824 * v130, 0, 0)
        end
        p100._bobbing_speed_spring.Target = p102.MoveSpeed / v_u_3.BASE_WALKSPEED * 0.1111111111111111 * (p102.IsGrounded and 1 or 0.05)
        p100._bobbing_tick = p100._bobbing_tick + p100._bobbing_speed_spring.Value * p101 * 60
        local v131 = v110 and (v106 and v106.IsPlaying) and 0.25 or 1
        local v132 = p102.MoveSpeed / v_u_3.BASE_WALKSPEED
        local v133 = math.max(0, v132) ^ 2.5 * ((p102.IsSliding or p102.IsBeingKnockedBack) and 0 or 1) * v131 * 0.05 * (p100.ClientItem.Info.AimScopePercent and 1 or v108)
        if not p100.Info.FramesPerSecond then
            ::l82::
            v135 = p100._bobbing_tick
            goto l83
        end
        local v134 = p100._bobbing_tick * p100.Info.FramesPerSecond
        local v135 = math.floor(v134) / p100.Info.FramesPerSecond
        if not v135 then
            goto l82
        end
        ::l83::
        local v136 = math.sin(v135) * v133 * 2
        local v137 = v135 * 2 + 1.5707963267948966
        local v138 = math.cos(v137) * v133
        p100._bobbing_value_spring.Target = Vector2.new(v136, v138)
        local v139 = p100.Info.FramesPerSecond and p100._bobbing_value_spring.Target or p100._bobbing_value_spring.Value
        local v140 = CFrame.new(v139.X, v139.Y, 0)
        p100._landing_spring.Velocity = p102.JustLanded and -10 - 15 * v108 or p100._landing_spring.Velocity
        local v141 = p100._landing_spring.Value
        local v142 = CFrame.new(0, v141 * 0.125, 0)
        local v143 = p100._jump_spring
        local v144 = -16 * v108
        local v145 = p102.PlayerVelocity.Y
        local v146 = math.abs(v145) ^ 1.25
        local v147 = p102.PlayerVelocity.Y
        local v148 = v146 * math.sign(v147)
        v143.Target = math.max(v144, v148)
        local v149 = p100._jump_spring.Value * (2 - 1.5 * v107)
        local v150 = CFrame.Angles
        local v151 = -v149 / 6
        local v152 = math.rad(v151)
        local v153 = v150(math.clamp(v152, -0.7853981633974483, 0.7853981633974483), 0, 0)
        local v154
        if p100.Info.FramesPerSecond then
            local v155 = v107 * p100.Info.FramesPerSecond + (p100.ClientItem.Info.AimScopePercent and 0 or 0.5)
            v154 = math.floor(v155) / p100.Info.FramesPerSecond or v107
        else
            v154 = v107
        end
        local v156 = not p100.AimingAnimationEnabled and CFrame.identity or CFrame.lookAt(p100._aim_position_attachment.WorldPosition, p100._aim_lookat_attachment.WorldPosition, p100._aim_position_attachment.WorldCFrame.UpVector):ToObjectSpace(p100.Model.PrimaryPart.CFrame)
        local v157 = CFrame.new(v156.Position)
        local v158 = v156 - v156.Position
        local v159 = p102.IsActuallyFirstPerson and (p100.ClientItem.Info.AimScopePercent or (1 / 0)) <= v107 and CFrame.new(0, 0, 10) or (not p100.AimingAnimationEnabled and CFrame.identity or CFrame.identity:Lerp(p100._root_part_offset_inverse * p103.ViewModelOffset:Inverse(), v107) * CFrame.identity:Lerp(v157, v154) * CFrame.identity:Lerp(v158, v154))
        local v160 = -p102.MoveVelocity:Cross(p100.ClientItem.ClientFighter.Entity.RootPart.CFrame.LookVector).Y / v_u_3.BASE_WALKSPEED * (1 + v107)
        local v161 = p102.MoveVelocity:Cross(p100.ClientItem.ClientFighter.Entity.RootPart.CFrame.RightVector).Y / v_u_3.BASE_WALKSPEED * (1 - v107 * 0.75)
        p100._tilt_spring.Target = Vector2.new(v160, p102.IsSliding and 0 or v161)
        local v162 = p100._tilt_spring.Value
        local v163 = v120:Inverse() * CFrame.Angles(v162.Y * 0.06981317007977318 * 0.5, 0, v162.X * 0.06981317007977318) * v120
        local v164 = CFrame.new
        local v165 = v109.Z
        local v166 = Vector3.new(0, 0, v165)
        local v167 = v109.X
        local v168 = v109.Y
        local v169 = math.abs(v168)
        local v170 = v109.Z - 1
        local v171 = v164(v166, (Vector3.new(v167, v169, v170)))
        local v172 = CFrame.Angles
        local v173 = v109.Y
        local v174 = v171 * v172(math.abs(v173) * 0.7853981633974483, 0, 1.5707963267948966 * -v109.X)
        local v175 = CFrame.new(v109.X * 2, -v109.Z / 10, v109.Z) * CFrame.Angles(0, v109.X * -2.5, v109.X * 10)
        local v176 = v120:Inverse() * CFrame.identity:Lerp(v174, 1 - v107) * CFrame.identity:Lerp(v175, v107) * v120
        p100:SetCFrame(v117 * v121 * v123 * v125 * v127 * v128 * v140 * v142 * v153 * v159 * v163 * v176)
        p100.CurrentBobbingValue = v139
        p100.CurrentSwayValue = v119
        p100.CurrentJumpValue = v149
        p100.CurrentLandingValue = v141
    else
        p100:SetCFrame(CFrame.new(p100.ClientItem.ClientFighter.Entity.Head.Position) * p100.ClientItem.ClientFighter:GetRotationCFrame())
    end
    if p100.Charm then
        task.defer(p100.Charm.Update, p100.Charm, p101, not p102.IsActuallyFirstPerson)
    end
    if p100._was_first_person ~= p102.IsActuallyFirstPerson then
        p100._was_first_person = p102.IsActuallyFirstPerson
        for v177, v178 in pairs(p100._arm_submodels) do
            v177:ScaleTo(v178 * (p102.IsActuallyFirstPerson and 1 or 1.7))
        end
        if v_u_7.THIRD_PERSON_VIEWMODEL_BLACKLIST[p100.Name] then
            p100:_UpdateWrap()
        end
    end
    p100.CurrentRecoilValue = v109
    p100.CurrentAimValue = v107
    local v179
    if p102.IsActuallyFirstPerson then
        v179 = v_u_17
    else
        v179 = v_u_16
    end
    p100:SetParent(v179)
    return true
end
function v_u_26.Destroy(p180)
    p180._destroyed = true
    for _, v181 in pairs(p180._preloaded_sounds) do
        v181:Destroy()
    end
    for _, v182 in pairs(p180._connections) do
        v182:Disconnect()
    end
    for v183 in pairs(p180._wrapped_only_objects) do
        v183:Destroy()
    end
    p180.Equipped:Destroy()
    p180.Unequipped:Destroy()
    p180.AnimationPlayed:Destroy()
    p180.AnimationStopped:Destroy()
    if p180.Charm then
        p180.Charm:Destroy()
    end
    p180.Animator:Destroy()
    p180.ItemModel:Destroy()
    p180.Model:Destroy()
    v_u_5.Destroy(p180)
end
function v_u_26._GetDefaultMuzzlePosition(p184)
    return (CFrame.new(p184.ClientItem.ClientFighter.Entity.Head.Position) * p184.ClientItem.ClientFighter:GetRotationCFrame() * CFrame.new(0.5, -0.5, -0.5)).Position
end
function v_u_26._AnimationWait(p185, ...)
    return p185.Animator:AnimationWait(...)
end
function v_u_26._CreateHitmarkerSound(p186, ...)
    local v187 = p186.ClientItem.ItemInterface:CreateSound(...)
    if v187 then
        local v188 = p186._last_hitmarker_sounds
        table.insert(v188, v187)
    end
end
function v_u_26._UpdateLocalTransparencyModifiers(p189)
    for v190 in pairs(p189._local_transparency_modifiers) do
        p189:_UpdateLocalTransparencyModifier(v190)
    end
end
function v_u_26._UpdateLocalTransparencyModifier(p_u_191, p_u_192)
    p_u_191._local_transparency_modifier_update[p_u_192] = true
    task.defer(function()
        if p_u_191._local_transparency_modifier_update[p_u_192] then
            p_u_191._local_transparency_modifier_update[p_u_192] = nil
            local v193 = 0
            for _, v194 in pairs(p_u_191._local_transparency_modifiers[p_u_192]) do
                v193 = math.max(v193, v194)
            end
            p_u_192.LocalTransparencyModifier = v193
            for _, v195 in pairs(p_u_192:GetDescendants()) do
                if v195:IsA("Texture") or (v195:IsA("Beam") or (v195:IsA("ParticleEmitter") or (v195:IsA("Trail") or v195:IsA("Decal")))) then
                    v195.LocalTransparencyModifier = v193
                end
            end
        end
    end)
end
function v_u_26._LocalTransparencyModifier(p196, p197, p198, p199)
    p196._local_transparency_modifiers[p197] = p196._local_transparency_modifiers[p197] or {}
    if p196._local_transparency_modifiers[p197][p198] ~= p199 then
        p196._local_transparency_modifiers[p197][p198] = p199
        p196:_UpdateLocalTransparencyModifier(p197)
    end
end
function v_u_26._UpdateWrap(p200)
    local v201
    if v_u_7.THIRD_PERSON_VIEWMODEL_BLACKLIST[p200.Name] and not p200._was_first_person then
        v201 = nil
    else
        v201 = p200:GetWrap()
    end
    if v201 or p200._original_wrap_properties then
        if p200.Name == "Fists" or p200.Name == "Hand Gun" then
            local v202 = v201 ~= nil
            local v203 = v202 and 1 or 0
            p200:_LocalTransparencyModifier(p200._left_arm, "FistsWrap", v203)
            p200:_LocalTransparencyModifier(p200._right_arm, "FistsWrap", v203)
            p200:_LocalTransparencyModifier(p200._left_arm_shirt_texture, "FistsWrap", v203)
            p200:_LocalTransparencyModifier(p200._right_arm_shirt_texture, "FistsWrap", v203)
            for v204, v205 in pairs(p200._wrapped_only_objects) do
                v204.Parent = v202 and v205 and v205 or nil
            end
        end
        p200._original_wrap_properties = p200._original_wrap_properties or v_u_13:RecordOriginalWrapProperties(p200.Model)
        local v206 = v_u_13
        local v207 = p200._original_wrap_properties
        local v208 = nil
        local v209
        if p200.Name == "Fists" or p200.Name == "Hand Gun" then
            v209 = false
        else
            v209 = p200._wrapped_only_objects
        end
        v206:ApplyWrap(v207, v201, v208, v209)
        p200:_UpdateLocalTransparencyModifiers()
    end
end
function v_u_26._UpdateSubModelVisibility(p210)
    for _, v211 in pairs(p210.ItemModel:GetChildren()) do
        local v212 = p210._animation_context_submodels[v211]
        local v213 = p210._hidden_submodels[v211.Name]
        if v212 or v213 ~= nil then
            local v214 = (v213 or v212 and not p210:AreAnimationsPlaying(v212)) and 1 or 0
            for _, v215 in pairs(v211:GetDescendants()) do
                if v215:IsA("BasePart") or v215:IsA("Texture") then
                    p210:_LocalTransparencyModifier(v215, "SubModelVisibility", v214)
                end
            end
        end
    end
end
function v_u_26._UpdateArms(p216)
    v_u_13:ResetWrap(p216._original_wrap_properties)
    p216._original_wrap_properties = nil
    p216._right_arm_shirt_texture.Texture = p216._shirt_id
    p216._left_arm_shirt_texture.Texture = p216._shirt_id
    p216._right_arm.Color = p216._right_arm_color
    p216._left_arm.Color = p216._left_arm_color
    p216._right_arm_wrapped_part.Color = p216._right_arm_color
    p216._left_arm_wrapped_part.Color = p216._left_arm_color
    if p216.Name == "Hand Gun" then
        for _, v217 in pairs(p216.ItemModel:GetChildren()) do
            if v217:FindFirstChild("MeshPart") then
                v217.MeshPart.Color = v217:GetAttribute("IsRightHand") and p216._right_arm_color or p216._left_arm_color
            end
        end
    end
    p216:_UpdateWrap()
end
function v_u_26._Setup(p218)
    if v_u_4.IGNORE_TRANSPARENCY_WHITELIST[p218.ClientItem.Name] then
        for _, v219 in pairs(p218.ItemModel:GetDescendants()) do
            if v219:IsA("BasePart") then
                v219:SetAttribute("IgnoreTransparency", true)
            end
        end
    end
    p218.Model.Name = (p218.ClientItem.ClientFighter.Player and (p218.ClientItem.ClientFighter.Player.Name or "???") or "???") .. " - " .. p218.ClientItem.Name .. " - " .. p218.Name
    p218._right_arm.Mesh.Scale = v_u_3.DEVICE == "VR" and Vector3.new(0, 0, 0) or p218._right_arm.Mesh.Scale
    p218._left_arm.Mesh.Scale = v_u_3.DEVICE == "VR" and Vector3.new(0, 0, 0) or p218._left_arm.Mesh.Scale
    p218._right_arm_wrapped_part = p218.Model.RightArmWrapped
    p218._right_arm_wrapped_part.Parent = nil
    p218._wrapped_only_objects[p218._right_arm_wrapped_part] = p218.Model
    p218._left_arm_wrapped_part = p218.Model.LeftArmWrapped
    p218._left_arm_wrapped_part.Parent = nil
    p218._wrapped_only_objects[p218._left_arm_wrapped_part] = p218.Model
    p218.ItemModel.Name = "ItemVisual"
    p218.ItemModel.Parent = p218.Model
    p218._body_model = p218.Model:FindFirstChild("Body")
    p218._aim_position_attachment = p218.Model:FindFirstChild("_aim_position", true)
    p218._aim_lookat_attachment = p218.Model:FindFirstChild("_aim_lookat", true)
    p218._center_attachment = p218.Model:FindFirstChild("_center", true)
    p218._charm_attachment_model = p218.Model:FindFirstChild("_charm_attachment_model", true)
    p218._charm_pivot_attachment = p218._charm_attachment_model and p218._charm_attachment_model:FindFirstChild("_charm_pivot_attachment", true) or p218.Model:FindFirstChild("_charm_pivot_attachment", true)
    p218._scope_glare_attachment = p218.Model:FindFirstChild("_scope_glare", true)
    local v220
    if p218._aim_position_attachment == nil then
        v220 = false
    else
        v220 = p218._aim_lookat_attachment ~= nil
    end
    p218.AimingAnimationEnabled = v220
    local v221 = p218.Model.PrimaryPart
    local v222 = CFrame.identity
    local v223 = nil
    for _, v224 in pairs(p218.ItemModel:GetChildren()) do
        if v224.Name == "_fake" then
            v224:Destroy()
        else
            v224.PrimaryPart = v224.Primary
            v223 = v223 or v224.PrimaryPart.CFrame
            local v225 = v224.Name == "_right_arm" and "RightArm" or (v224.Name == "_left_arm" and "LeftArm" or nil)
            if v225 then
                p218._arm_submodels[v224] = v224:GetScale()
                local v226 = p218.Model[v225]
                v224.Parent = v226
                v224:PivotTo(v226.CFrame)
                local v227 = Instance.new("WeldConstraint")
                v227.Part0 = v226
                v227.Part1 = v224.PrimaryPart
                v227.Parent = v224.PrimaryPart
            else
                local v228 = Instance.new("Motor6D")
                v228.Part0 = v221
                v228.Part1 = v224.PrimaryPart
                v228.Name = "ItemVisual[\"" .. v224.Name .. "\"]"
                v228.C0 = v224:GetAttribute("C0") or v224.PrimaryPart.CFrame:ToObjectSpace(v223):Inverse() * v222
                v228.C1 = v224:GetAttribute("C1") or CFrame.identity
                v228.Parent = v221
            end
            for _, v229 in pairs(v224:GetDescendants()) do
                if v229:IsA("BasePart") then
                    v229.CastShadow = false
                    v229.CanCollide = false
                    v229.CanTouch = false
                    v229.CanQuery = false
                    v229.Massless = true
                    if v229 ~= v224.PrimaryPart then
                        local v230 = Instance.new("WeldConstraint")
                        v230.Part0 = v224.PrimaryPart
                        v230.Part1 = v229
                        v230.Parent = v224.PrimaryPart
                        v229.Anchored = false
                    end
                end
            end
            v224.PrimaryPart.Anchored = false
            if not v225 then
                v224.PrimaryPart.Name = v224.Name .. "Primary"
                v224:PivotTo(v221.CFrame)
                local v231 = v224:GetAttribute("AnimationContexts")
                if v231 then
                    p218._animation_context_submodels[v224] = {}
                    local v232 = 1
                    for v233 = 1, #v231 do
                        local v234 = v233 - 1
                        if string.sub(v231, v234, v233) == ", " then
                            local v235 = p218._animation_context_submodels[v224]
                            local v236 = v233 - 2
                            local v237 = string.sub(v231, v232, v236)
                            table.insert(v235, v237)
                            v232 = v233 + 1
                        end
                    end
                    if v232 <= #v231 then
                        local v238 = p218._animation_context_submodels[v224]
                        local v239 = #v231
                        local v240 = string.sub(v231, v232, v239)
                        table.insert(v238, v240)
                    end
                end
            end
        end
    end
    for _, v241 in pairs(p218.Model:GetDescendants()) do
        if v241.Name == "_muzzle" then
            local v242 = p218._muzzle_attachments
            table.insert(v242, v241)
            local v243 = v_u_21:FindFirstChild(p218.Name) or (v_u_21:FindFirstChild(p218.ClientItem.Name) or v_u_21.Default)
            for _, v244 in pairs(v243.Attachment:GetChildren()) do
                v244:Clone().Parent = v241
            end
        end
    end
    if p218._scope_glare_attachment then
        p218._scope_glare_gui1 = v_u_19:Clone()
        p218._scope_glare_gui1.Enabled = false
        p218._scope_glare_gui1.Parent = p218._scope_glare_attachment
        p218._scope_glare_gui2 = v_u_20:Clone()
        p218._scope_glare_gui2.Enabled = false
        p218._scope_glare_gui2.Parent = p218._scope_glare_attachment
    end
    if p218._charm_pivot_attachment then
        if p218:Get("Charm") then
            local v245 = p218:Get("Charm")
            local v246 = v_u_24:FindFirstChild(v245.Name, true)
            p218.Charm = (v246 and require(v246) or v_u_14).new(p218, v245, p218._charm_pivot_attachment)
            p218.Charm:SetParent(p218.Model)
        elseif p218._charm_attachment_model then
            p218._charm_attachment_model:Destroy()
        end
    end
    if p218.ClientItem.ClientFighter.IsLocalPlayer then
        for _, v247 in pairs(p218.Info.Animations) do
            v_u_6:PreloadSounds(v_u_6.AnimationSounds[v247], p218._preloaded_sounds)
        end
        if v_u_6.ViewModelSounds[p218.Name] then
            v_u_6:PreloadSounds(v_u_6.ViewModelSounds[p218.Name], p218._preloaded_sounds)
        end
    end
    p218:SetArmsData(nil, nil, nil)
    p218:SetParent(v_u_18)
    p218:SetCFrame(CFrame.identity)
end
function v_u_26._Init(p_u_248)
    p_u_248.Animator.AnimationPlayed:Connect(function(...)
        p_u_248.AnimationPlayed:Fire(...)
        p_u_248:_UpdateSubModelVisibility()
    end)
    p_u_248.Animator.AnimationStopped:Connect(function(...)
        p_u_248.AnimationStopped:Fire(...)
        p_u_248:_UpdateSubModelVisibility()
    end)
    local v249 = p_u_248._connections
    local v250 = p_u_248.ClientItem.ClientFighter:GetDataChangedSignal("IsSpectating")
    table.insert(v249, v250:Connect(function()
        p_u_248:_UpdateWrap()
    end))
    local v251 = p_u_248._connections
    local v252 = v_u_11:GetDataChangedSignal("Settings Wraps Disabled")
    table.insert(v251, v252:Connect(function()
        p_u_248:_UpdateWrap()
    end))
    p_u_248:_Setup()
    p_u_248:_UpdateWrap()
end
return v_u_26