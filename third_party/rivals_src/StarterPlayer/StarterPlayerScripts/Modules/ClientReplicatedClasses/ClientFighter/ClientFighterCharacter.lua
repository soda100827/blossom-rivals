local v1 = game:GetService("ReplicatedStorage")
game:GetService("UserInputService")
local v_u_2 = game:GetService("RunService")
local v3 = game:GetService("Players")
local v_u_4 = require(v1.Modules.CONSTANTS)
require(v1.Modules.SettingsLibrary)
local v_u_5 = require(v1.Modules.BetterDebris)
local v_u_6 = require(v1.Modules.SoundLibrary)
local v_u_7 = require(v1.Modules.Utility)
local v_u_8 = require(v1.Modules.Spring)
local v_u_9 = require(v1.Modules.Signal)
local v_u_10 = require(v3.LocalPlayer.PlayerScripts.Controllers.LeaderboardController)
local v_u_11 = require(v3.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
require(v3.LocalPlayer.PlayerScripts.Controllers.ControlsController)
local v_u_12 = require(v3.LocalPlayer.PlayerScripts.Controllers.PreloadController)
local v_u_13 = require(v3.LocalPlayer.PlayerScripts.Controllers.CameraController)
require(v3.LocalPlayer.PlayerScripts.Controllers.EnemyController)
local v_u_14 = require(v3.LocalPlayer.PlayerScripts.Controllers.DebugController.DebugState)
local v_u_15 = require(v3.LocalPlayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientEntity.ClientHumanoidEntity)
local v_u_16 = require(v3.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("MobileButtons"))
local v_u_17 = require(v3.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Teleporting"))
local v_u_18 = require(v3.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Shutdown"))
local v_u_19 = require(v3.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Pages"))
local v_u_20 = require(v3.LocalPlayer.PlayerScripts.Modules.Nametag)
workspace:WaitForChild("ViewModels"):WaitForChild("FirstPerson")
local v_u_21 = v3.LocalPlayer.PlayerScripts.Assets:WaitForChild("Misc"):WaitForChild("DashParticles")
local v_u_22 = v3.LocalPlayer.PlayerScripts.Assets.Misc.SnowballParticles
local v_u_23 = v3.LocalPlayer.PlayerScripts.UserInterface.BlindedGui
local v_u_24 = v3.LocalPlayer.PlayerScripts.Assets.Misc.Snowballs
CFrame.Angles(1.5707963267948966, 0, -1.5707963267948966)
CFrame.Angles(1.5707963267948966, 0, -1.5707963267948966)
local v_u_25 = {
    "HitboxHead",
    "HitboxBody",
    "HitboxHeadSmall",
    "HitboxBodySmall"
}
local v_u_26 = {
    ["Speed"] = true
}
local v_u_27 = {
    ["idle"] = "rbxassetid://17702749856",
    ["run"] = "rbxassetid://17702824140",
    ["walk"] = "rbxassetid://17702824140",
    ["runBack"] = "rbxassetid://17703291282",
    ["walkBack"] = "rbxassetid://17703291282",
    ["runForwardLeft"] = "rbxassetid://17703649282",
    ["walkForwardLeft"] = "rbxassetid://17703649282",
    ["runBackwardLeft"] = "rbxassetid://17703612699",
    ["walkBackwardLeft"] = "rbxassetid://17703612699",
    ["runLeft"] = "rbxassetid://17703296049",
    ["runLeft2"] = "rbxassetid://17703296049",
    ["walkLeft"] = "rbxassetid://17703296049",
    ["walkLeft2"] = "rbxassetid://17703296049",
    ["runForwardRight"] = "rbxassetid://17703652486",
    ["walkForwardRight"] = "rbxassetid://17703652486",
    ["runBackwardRight"] = "rbxassetid://17703646109",
    ["walkBackwardRight"] = "rbxassetid://17703646109",
    ["runRight"] = "rbxassetid://17703299653",
    ["runRight2"] = "rbxassetid://17703299653",
    ["walkRight"] = "rbxassetid://17703299653",
    ["walkRight2"] = "rbxassetid://17703299653"
}
local v_u_28 = {
    ["Start"] = {
        { "SlidingStartForward", "LookVector", 1 },
        { "SlidingStartRightward", "RightVector", 1 },
        { "SlidingStartBackward", "LookVector", -1 },
        { "SlidingStartLeftward", "RightVector", -1 }
    },
    ["Loop"] = {
        { "SlidingLoopForward", "LookVector", 1 },
        { "SlidingLoopRightward", "RightVector", 1 },
        { "SlidingLoopBackward", "LookVector", -1 },
        { "SlidingLoopLeftward", "RightVector", -1 }
    }
}
local v_u_29 = setmetatable({}, v_u_15)
v_u_29.__index = v_u_29
function v_u_29.new(p30, p31)
    local v32 = v_u_15.new(p30)
    local v33 = v_u_29
    local v34 = setmetatable(v32, v33)
    v34.BoostsChanged = v_u_9.new()
    v34.AirborneLocallyChanged = v_u_9.new()
    v34.RedirectSliding = v_u_9.new()
    v34.ClientFighter = p31
    v34.Player = p30.Player
    v34.Head = nil
    v34.IsAirborneLocally = false
    v34._destroyed = false
    v34._last_is_alive_check = nil
    v34._last_footstep = 0
    v34._last_is_grounded_check = nil
    v34._is_grounded_time = nil
    v34._camera_rotation_spring = v_u_8.new(Vector2.zero, 1, 50)
    v34._camera_lean_spring = v_u_8.new(0, 1, 20)
    v34._original_character_properties = {}
    v34._is_hidden = false
    v34._boosts = {}
    v34._custom_knockback_velocity = nil
    v34._custom_knockback_spring = nil
    v34._custom_knockback_effects = {}
    v34._custom_knockback_hash = 0
    v34._custom_knockback_start = 0
    v34._nametag = nil
    v34._chat_bubble_mover = Instance.new("Part")
    v34._waist_motor6d = nil
    v34._neck_motor6d = nil
    v34._root_motor6d = nil
    v34._root_motor6d_origin = nil
    v34._hitboxes_visible = nil
    v34._update_hitboxes_check = false
    v34._right_hand_ik_control = Instance.new("IKControl")
    v34._left_hand_ik_control = Instance.new("IKControl")
    v34._ik_control_target_item = nil
    v34._ik_arms_disable_hash = 0
    v34._original_humanoid_animations = {}
    v34._sliding_jump_fall_animation_track = nil
    v34._sliding_animation_hash = 0
    v34._sliding_animation_track = nil
    v34._grab_snowball_hash = 0
    v34._grab_snowball_visual = nil
    v34._grab_snowball_animation_start = Instance.new("Animation")
    v34._grab_snowball_animation_idle = Instance.new("Animation")
    v34._grab_snowball_animation_throw = Instance.new("Animation")
    v34._grab_snowball_animation_track_start = nil
    v34._grab_snowball_animation_track_idle = nil
    v34._is_translucent = false
    v34._fov_offset_spring = v_u_8.new(0, 0.75, 10)
    v34._camera_flashlight = nil
    v34:_Init()
    return v34
end
function v_u_29.IsRendered(p35)
    local v36 = v_u_15.IsRendered(p35)
    if v36 then
        v36 = not p35.ClientFighter:Get("IsHiddenByEmotes")
    end
    return v36
end
function v_u_29.IsAlive(p37)
    local _ = p37._last_is_alive_check == nil
    local v38 = p37.Head
    if v38 then
        v38 = v_u_15.IsAlive(p37)
    end
    p37._last_is_alive_check = v38
    return v38
end
function v_u_29.IsGrounded(p39)
    if p39._last_is_grounded_check ~= nil then
        return p39._last_is_grounded_check
    end
    if not p39:IsAlive() then
        p39._last_is_grounded_check = false
        return false
    end
    local v40 = not v_u_4.AIRBORNE_HUMANOID_STATES[p39.Humanoid:GetState()]
    p39._last_is_grounded_check = v40
    return v40
end
function v_u_29.IsAirborne(p41)
    if p41.ClientFighter.IsLocalPlayer then
        return p41.IsAirborneLocally
    else
        return p41:Get("IsAirborne")
    end
end
function v_u_29.GetClampedVelocity(p42)
    if not p42.RootPart then
        return Vector3.new(0, 0, 0)
    end
    local v43 = p42.RootPart.Velocity.Magnitude <= 0.01 and p42.RootPart.Velocity
    if not v43 then
        local v44 = p42.RootPart.Velocity.Unit
        local v45 = p42.RootPart.Velocity.Magnitude
        local v46 = v_u_4.BASE_WALKSPEED * 2.5
        v43 = v44 * math.clamp(v45, 0, v46)
    end
    return v43
end
function v_u_29.GetFOVOffset(p47)
    return p47._fov_offset_spring.Value
end
function v_u_29.GetFloor(p48, p49)
    local v50 = p49 or 3.5 * p48.RootPart.Size.Z
    local v51 = v_u_7:Raycast(p48.RootPart.Position, p48.RootPart.Position - Vector3.new(0, 1, 0), v50, p48.ClientFighter:GetRaycastWhitelist(), Enum.RaycastFilterType.Include)
    return v51.Instance, v51
end
function v_u_29.GetArmsData(p52)
    return v_u_7:GetArmsData(p52.Model)
end
function v_u_29.GetBoostByName(p53, p54)
    local v55 = typeof(p54) == "string"
    local v56 = "Argument 1 invalid, expected a string, got " .. tostring(p54)
    assert(v55, v56)
    p53:_ClearExpiredBoosts()
    return p53._boosts[p54]
end
function v_u_29.GetBoost(p57, p58)
    local v59 = v_u_26[p58]
    local v60 = "Argument 1 invalid, got " .. tostring(p58)
    assert(v59, v60)
    p57:_ClearExpiredBoosts()
    local v61 = 0
    for _, v62 in pairs(p57._boosts) do
        if v62.Type == p58 then
            v61 = v61 + v62.Boost
        end
    end
    return v61
end
function v_u_29.SetBoost(p63, p64, p65, p66, p67, p68)
    local v69 = v_u_26[p64]
    local v70 = "Argument 1 invalid, got " .. tostring(p64)
    assert(v69, v70)
    local v71 = typeof(p65) == "string"
    local v72 = "Argument 2 invalid, expected a string, got " .. tostring(p65)
    assert(v71, v72)
    local v73 = typeof(p66) == "number"
    local v74 = "Argument 3 invalid, expected a number, got " .. tostring(p66)
    assert(v73, v74)
    local v75 = typeof(p67) == "number"
    local v76 = "Argument 4 invalid, expected a number, got " .. tostring(p67)
    assert(v75, v76)
    local v77 = not p68 or typeof(p68) == "boolean"
    local v78 = "Argument 5 invalid, expected a boolean or nil, got " .. tostring(p68)
    assert(v77, v78)
    p63._boosts[p65] = {
        ["Type"] = p64,
        ["Window"] = tick() + p66,
        ["Boost"] = p67
    }
    if not p68 then
        p63.BoostsChanged:Fire()
    end
end
function v_u_29.RemoveBoost(p79, p80, p81)
    local v82 = typeof(p80) == "string"
    local v83 = "Argument 1 invalid, expected a string, got " .. tostring(p80)
    assert(v82, v83)
    local v84 = not p81 or typeof(p81) == "boolean"
    local v85 = "Argument 2 invalid, expected a boolean or nil, got " .. tostring(p81)
    assert(v84, v85)
    if p79._boosts[p80] then
        p79._boosts[p80] = nil
        if not p81 then
            p79.BoostsChanged:Fire()
        end
    end
end
function v_u_29.SetTranslucent(p86, p87)
    if p87 ~= p86._is_translucent then
        p86._is_translucent = p87
        p86:_BulkUpdateVisibility()
    end
end
function v_u_29.SetHitboxesVisible(p88, p89)
    p88._hitboxes_visible = p89
    p88:_UpdatePlayerHitboxes()
end
function v_u_29.CloneModel(p90)
    p90:_UpdateVisibility(true, false)
    local v91 = p90.Model.Archivable
    p90.Model.Archivable = true
    local v92 = p90.Model:Clone()
    p90.Model.Archivable = v91
    p90:_UpdateVisibility(true, nil)
    return v92
end
function v_u_29.DisableIKArms(p_u_93, p_u_94, p_u_95, p_u_96)
    p_u_93._ik_arms_disable_hash = p_u_93._ik_arms_disable_hash + 1
    local v_u_97 = p_u_93._ik_arms_disable_hash
    if p_u_94 >= (1 / 0) then
        if not p_u_95 then
            p_u_93._right_hand_ik_control.Weight = 0
        end
        if not p_u_96 then
            p_u_93._left_hand_ik_control.Weight = 0
        end
    else
        task.spawn(function()
            local v98 = tick()
            while tick() < v98 + p_u_94 do
                if v_u_97 ~= p_u_93._ik_arms_disable_hash then
                    return
                end
                local v99 = (tick() - v98) / p_u_94
                local v100 = math.clamp(v99, 0, 1) ^ 4
                if not p_u_95 then
                    p_u_93._right_hand_ik_control.Weight = v100
                end
                if not p_u_96 then
                    p_u_93._left_hand_ik_control.Weight = v100
                end
                v_u_2.RenderStepped:Wait()
            end
            if not p_u_95 then
                p_u_93._right_hand_ik_control.Weight = 1
            end
            if not p_u_96 then
                p_u_93._left_hand_ik_control.Weight = 1
            end
        end)
    end
end
function v_u_29.SetIKControlTargetItem(p101, p102)
    if p102 ~= p101._ik_control_target_item then
        p101._ik_control_target_item = p102
        p101._right_hand_ik_control.Enabled = false
        p101._left_hand_ik_control.Enabled = false
        local v103 = p101._right_hand_ik_control
        local v104
        if p101._ik_control_target_item then
            v104 = p101._ik_control_target_item.ViewModel.Model.RightArm.HandAttachment or nil
        else
            v104 = nil
        end
        v103.Target = v104
        local v105 = p101._left_hand_ik_control
        local v106
        if p101._ik_control_target_item then
            v106 = p101._ik_control_target_item.ViewModel.Model.LeftArm.HandAttachment or nil
        else
            v106 = nil
        end
        v105.Target = v106
        p101:_UpdateIKControl(nil, nil)
    end
end
function v_u_29.PlaySlidingAnimation(p107, p108)
    p107:StopSlidingAnimation()
    if p107.ClientFighter.IsLocalPlayer then
        p107._sliding_animation_hash = p107._sliding_animation_hash + 1
        local v109 = p107._sliding_animation_hash
        local v110 = p107:_GetSlidingAnimation("Start", p108)
        local v111 = pcall
        local v112 = p107.Humanoid.LoadAnimation
        local v113 = p107.Humanoid
        local v114 = v_u_12
        if v110 then
            v110 = v110[1]
        end
        local v115, v116 = v111(v112, v113, v114:GetPreloadedAnimation(v110))
        if v115 then
            p107._sliding_animation_track = v116
            p107._sliding_animation_track:Play()
            wait(0.4)
        end
        if v109 == p107._sliding_animation_hash then
            local v117 = nil
            while v109 == p107._sliding_animation_hash do
                local v118 = p107:_GetSlidingAnimation("Loop", p108)
                if v118 and v118[1] ~= v117 then
                    v117 = v118[1]
                    if p107._sliding_animation_track then
                        p107._sliding_animation_track:Stop(0)
                        p107._sliding_animation_track:Destroy()
                        p107._sliding_animation_track = nil
                    end
                    local v119, v120 = pcall(p107.Humanoid.LoadAnimation, p107.Humanoid, v_u_12:GetPreloadedAnimation(v117))
                    if v119 then
                        p107._sliding_animation_track = v120
                        p107._sliding_animation_track:Play(0)
                    end
                end
                v_u_2.RenderStepped:Wait()
            end
        end
    else
        return
    end
end
function v_u_29.StopSlidingAnimation(p121)
    p121._sliding_animation_hash = p121._sliding_animation_hash + 1
    if p121._sliding_animation_track then
        p121._sliding_animation_track:Stop(0)
        p121._sliding_animation_track = nil
    end
end
function v_u_29.HardDash(p_u_122, p123, p_u_124, p125, p_u_126)
    p_u_122:CancelCustomKnockback()
    p_u_122.ClientFighter.StopSliding:Fire()
    local v_u_127 = Instance.new("BodyVelocity")
    v_u_127.MaxForce = Vector3.new(40000, 40000, 40000)
    v_u_127.Velocity = p123
    v_u_127.Parent = p_u_122.RootPart
    v_u_5:AddItem(v_u_127, p_u_124 + 0.1)
    task.delay(p_u_124, function()
        v_u_127:Destroy()
        local v128 = p_u_122.RootPart
        v128.AssemblyLinearVelocity = v128.AssemblyLinearVelocity * (p_u_126 or Vector3.new(0, 0, 0))
        p_u_122:CancelCustomKnockback()
        p_u_122.ClientFighter.StopSliding:Fire()
    end)
    if not p125 then
        task.spawn(function()
            local v129 = p_u_122.ClientFighter.Entity.RootPart
            if v129 then
                local v130 = v_u_21:Clone()
                v130.Parent = v129
                v_u_5:AddItem(v130, p_u_124 + 5)
                local v131 = v129.Position
                local v132 = tick() + p_u_124
                for _, v133 in pairs(v130:GetChildren()) do
                    if v133:IsA("ParticleEmitter") then
                        v133.Enabled = true
                    end
                end
                while tick() < v132 do
                    if (v131 - v129.Position).Magnitude > 0.01 then
                        v130.CFrame = CFrame.new(v129.Position, v131) * CFrame.Angles(0, 3.141592653589793, 0)
                    end
                    v_u_2.RenderStepped:Wait()
                end
                for _, v134 in pairs(v130:GetChildren()) do
                    if v134:IsA("ParticleEmitter") then
                        v134.Enabled = false
                    end
                end
            end
        end)
    end
end
function v_u_29.WarpTo(p135, p136)
    if p135:IsAlive() then
        p135.RootPart.CFrame = p136
        p135._fov_offset_spring.Value = 10
        local v137 = v_u_7:AngleBetweenVectors(p136.LookVector, Vector3.new(0, 1, 0)) < 0.7853981633974483 and true or v_u_7:AngleBetweenVectors(p136.LookVector, Vector3.new(-0, -1, -0)) < 0.7853981633974483
        if not v137 then
            v_u_13:MimicRotation(p136)
        end
        if p135.ClientFighter:IsSliding() and not v137 then
            p135.RedirectSliding:Fire(p136.LookVector)
        else
            local v138 = p135.RootPart.Velocity
            local v139
            if v137 then
                local v140 = v138.Unit
                local v141 = (v138 * (Vector3.new(1, 0, 1)).Unit).Magnitude
                local v142 = p135.Humanoid.WalkSpeed
                v139 = v140 * math.max(v141, v142)
            else
                v139 = nil
            end
            if not v139 or (v139 ~= v139 or (v139.Magnitude <= 0.001 or not v139)) then
                v139 = nil
            end
            local v143 = p136.LookVector
            local v144 = v138.Magnitude
            local v145 = math.sqrt(v144)
            p135:CustomKnockback(v143 * math.max(16, v145), 12, nil, v139)
        end
    else
        return
    end
end
function v_u_29.InstantlyRedirectCustomKnockback(p146, p147, p148)
    if p146._custom_knockback_spring then
        local v149 = p147 or p146._custom_knockback_spring.Target
        p146._custom_knockback_spring.Value = v149 * (p148 or 1)
    end
end
function v_u_29.CustomKnockback(p_u_150, p151, p_u_152, p153, p_u_154, _)
    if p_u_150.ClientFighter.IsLocalPlayer and not (p153 and p_u_150._custom_knockback_velocity) and (p151.Magnitude > 0.01 and not p_u_150:Get("IsFrozen")) then
        local v155 = p_u_150._custom_knockback_velocity and (p_u_150._custom_knockback_velocity.Velocity or Vector3.new(0, 0, 0)) or Vector3.new(0, 0, 0)
        local v156
        if p_u_150._custom_knockback_velocity then
            v156 = p_u_150._custom_knockback_velocity.Velocity or p151
        else
            v156 = p151
        end
        local v157 = p151.X
        local v158 = math.abs(v157)
        local v159 = v155.X
        local v160 = math.abs(v159)
        local v161 = math.max(v158, v160)
        local v162 = v156.X
        local v163 = v161 * math.sign(v162)
        local v164 = p151.Y
        local v165 = p151.Z
        local v166 = math.abs(v165)
        local v167 = v155.Z
        local v168 = math.abs(v167)
        local v169 = math.max(v166, v168)
        local v170 = v156.Z
        local v171 = v169 * math.sign(v170)
        local v_u_172 = Vector3.new(v163, v164, v171)
        if p_u_150._custom_knockback_velocity then
            p_u_150._custom_knockback_velocity:Destroy()
            p_u_150._custom_knockback_velocity = nil
        end
        local v_u_173 = Instance.new("BodyVelocity")
        v_u_173.MaxForce = Vector3.new(100000, 100000, 100000)
        v_u_173.Velocity = Vector3.new(0, 0, 0)
        v_u_5:AddItem(v_u_173, 5)
        p_u_150._custom_knockback_hash = p_u_150._custom_knockback_hash + 1
        p_u_150._custom_knockback_start = tick()
        p_u_150._custom_knockback_velocity = v_u_173
        p_u_150.ClientFighter.StopSliding:Fire()
        p_u_150.IsAirborneLocally = true
        p_u_150.AirborneLocallyChanged:Fire()
        p_u_150:_UpdateKnockbackAnimation(0)
        task.spawn(function()
            v_u_173.Parent = p_u_150.RootPart
            p_u_150._custom_knockback_spring = v_u_8.new(p_u_154 and p_u_154.Unit or v_u_172.Unit, 1, p_u_152)
            local v174 = p_u_154 and p_u_154.Magnitude or (v_u_172 * Vector3.new(1, 0, 1)).Magnitude
            local v175 = tick()
            local v176 = false
            local v177 = nil
            while not p_u_150._destroyed and (v_u_173 == p_u_150._custom_knockback_velocity and (v_u_173:IsDescendantOf(p_u_150.RootPart) and (p_u_150:IsAlive() and (tick() - v175 <= 0.2 or p_u_150.RootPart.Velocity.Magnitude >= 5)))) do
                if not v176 and tick() - v175 > 0.2 then
                    local v178 = v_u_173
                    v178.MaxForce = v178.MaxForce * Vector3.new(0.1, 1, 0.1)
                    v176 = true
                end
                local v179, v180 = p_u_150:GetFloor()
                if tick() - v175 > 0.2 and (v179 and v_u_7:AngleBetweenVectors(Vector3.new(0, 1, 0), v180.Normal) < 0.1308996938995747) then
                    if v_u_172.Y < 0 then
                        break
                    end
                    if v177 then
                        if tick() - v177 > 1 then
                            break
                        end
                    else
                        v177 = tick()
                    end
                else
                    v177 = nil
                end
                p_u_150._custom_knockback_spring.Target = p_u_150.ClientFighter:GetMoveVector(true, true)
                local v181 = v_u_173
                local v182 = p_u_150._custom_knockback_spring.Value * Vector3.new(1, 0, 1) * v174
                local v183 = v_u_172.Y
                v181.Velocity = (v182 + Vector3.new(0, v183, 0)) / p_u_150.RootPart.AssemblyMass * 16
                if v_u_173.MaxForce.Y > 0 and tick() - v175 > 0.2 then
                    local v184 = v_u_173
                    v184.MaxForce = v184.MaxForce * Vector3.new(1, 0, 1)
                end
                v_u_2.RenderStepped:Wait()
            end
            if p_u_150._custom_knockback_velocity == v_u_173 then
                p_u_150:CancelCustomKnockback()
            end
        end)
    end
end
function v_u_29.CancelCustomKnockback(p185)
    if p185.ClientFighter.IsLocalPlayer then
        p185._custom_knockback_hash = p185._custom_knockback_hash + 1
        p185._custom_knockback_spring = nil
        if p185._custom_knockback_velocity then
            p185._custom_knockback_velocity:Destroy()
            p185._custom_knockback_velocity = nil
        end
        p185.IsAirborneLocally = false
        p185.AirborneLocallyChanged:Fire()
        p185:_UpdateKnockbackAnimation()
    end
end
function v_u_29.Update(p186, p187, p188)
    p186._last_is_grounded_check = nil
    p186._last_is_alive_check = nil
    p186:_UpdateFalling(p187, p188)
    p186:_UpdateFootstep(p187, p188)
    p186:_UpdateSpine(p187, p188)
    p186:_UpdateIKControl(p187, p188)
    p186:_UpdateFlashlight()
end
function v_u_29.ReplicateFromServer(p189, p190, ...)
    if p190 == "HurtEffect" then
        if p189:IsRendered() then
            local v191 = (...)[utf8.char(0)] / p189.Humanoid.MaxHealth
            if p189.ClientFighter.FighterInterface then
                task.spawn(p189.ClientFighter.FighterInterface.HurtEffect, p189.ClientFighter.FighterInterface, ...)
            end
            for v192 in pairs(p189.ClientFighter:GetEquippedItems()) do
                local v193 = v192.ViewModel
                local v194 = math.random() - 0.5
                local v195 = math.random() - 0.5
                local v196 = math.random() - 0.5
                v193:ApplyRecoil(Vector3.new(v194, v195, v196) * 1.5 * v191)
            end
            if p189.ClientFighter:Get("IsSpectating") then
                v_u_13:ShakeOnce(60 * v191, 10, 0, 0.4, Vector3.new(0.25, 0.25, 0), Vector3.new(0, 0, 0))
            end
            p189:_HurtEffect(...)
        end
    else
        if p190 == "HealEffect" then
            if not p189:IsRendered() then
                return
            end
            if p189.ClientFighter.FighterInterface then
                p189.ClientFighter.FighterInterface:HealEffect(...)
                return
            end
        else
            if p190 == "BlindedEffect" then
                if p189:IsRendered() and not p189.ClientFighter:Get("IsSpectating") then
                    local v197 = ...
                    local v198 = tick()
                    local v199 = v_u_23:Clone()
                    v199.Parent = p189.Model:FindFirstChild("Head") or p189.RootPart
                    v_u_5:AddItem(v199, v197)
                    local v200 = v199.ImageLabel
                    while tick() < v198 + v197 do
                        local v201 = (tick() - v198) / v197
                        v200.ImageTransparency = math.min(1, v201) ^ 5
                        v_u_2.RenderStepped:Wait()
                    end
                    v199:Destroy()
                end
            end
            if p190 == "KnockbackEffect" then
                if p189.ClientFighter.IsLocalPlayer then
                    local v202, v203, v204 = ...
                    if v204 then
                        p189:CancelCustomKnockback()
                    end
                    p189:CustomKnockback(v202 * 0.75, v203 or 4)
                end
            end
            if p190 == "SetBoost" then
                p189:SetBoost(...)
                return
            end
            if p190 == "ThrowSnowball" then
                local v205 = p189:Get("IsGrabbingSnowball")
                p189:SetReplicate("IsGrabbingSnowball", nil)
                p189:_ThrowSnowball(..., v205)
                return
            end
            if p190 == "WarpTo" then
                if p189.ClientFighter.IsLocalPlayer then
                    p189:WarpTo(...)
                end
            end
            v_u_15.ReplicateFromServer(p189, p190, ...)
        end
        return
    end
end
function v_u_29.Destroy(p206)
    p206._destroyed = true
    p206._sliding_animation_hash = p206._sliding_animation_hash + 1
    p206._ik_arms_disable_hash = p206._ik_arms_disable_hash + 1
    if p206._falling_sound then
        p206._falling_sound:Destroy()
        p206._falling_sound = nil
    end
    if p206._chat_bubble_mover then
        p206._chat_bubble_mover:Destroy()
    end
    if p206._camera_flashlight then
        p206._camera_flashlight:Destroy()
    end
    p206._original_character_properties = {}
    p206:_ThrowSnowball(nil)
    p206.BoostsChanged:Destroy()
    p206.AirborneLocallyChanged:Destroy()
    p206.RedirectSliding:Destroy()
    v_u_15.Destroy(p206)
end
function v_u_29._GrabSnowball(p_u_207, p208)
    p_u_207:_ThrowSnowball(nil)
    local v209 = p_u_207.Model:FindFirstChild("RightHand")
    if v209 then
        p_u_207._grab_snowball_hash = p_u_207._grab_snowball_hash + 1
        local v_u_210 = p_u_207._grab_snowball_hash
        local v211, v212 = pcall(p_u_207.Humanoid.LoadAnimation, p_u_207.Humanoid, p_u_207._grab_snowball_animation_start)
        if v211 then
            p_u_207._grab_snowball_animation_track_start = v212
            p_u_207._grab_snowball_animation_track_start:Play(0)
            p_u_207._grab_snowball_animation_track_start:AdjustSpeed(3)
            task.delay(0.5, function()
                if v_u_210 == p_u_207._grab_snowball_hash then
                    local v213, v214 = pcall(p_u_207.Humanoid.LoadAnimation, p_u_207.Humanoid, p_u_207._grab_snowball_animation_idle)
                    if v213 then
                        p_u_207._grab_snowball_animation_track_idle = v214
                        p_u_207._grab_snowball_animation_track_idle:Play()
                    end
                end
            end)
        end
        if p208 then
            p_u_207._grab_snowball_visual = v_u_24[p208]:Clone()
            p_u_207._grab_snowball_visual.PrimaryPart = p_u_207._grab_snowball_visual.Primary
            p_u_207._grab_snowball_visual:PivotTo(v209.CFrame)
            p_u_207._grab_snowball_visual.Parent = v209
            local v215 = Instance.new("WeldConstraint")
            v215.Part0 = v209
            v215.Part1 = p_u_207._grab_snowball_visual.PrimaryPart
            v215.Parent = p_u_207._grab_snowball_visual
        end
    else
        return
    end
end
function v_u_29._ThrowSnowball(p_u_216, p_u_217, p_u_218)
    p_u_216._grab_snowball_hash = p_u_216._grab_snowball_hash + 1
    if p_u_216._grab_snowball_visual then
        p_u_216._grab_snowball_visual:Destroy()
        p_u_216._grab_snowball_visual = nil
    end
    if p_u_216._grab_snowball_animation_track_start then
        p_u_216._grab_snowball_animation_track_start:Stop(0)
        p_u_216._grab_snowball_animation_track_start:Destroy()
        p_u_216._grab_snowball_animation_track_start = nil
    end
    if p_u_216._grab_snowball_animation_track_idle then
        p_u_216._grab_snowball_animation_track_idle:Stop(0)
        p_u_216._grab_snowball_animation_track_idle:Destroy()
        p_u_216._grab_snowball_animation_track_idle = nil
    end
    if p_u_217 and p_u_218 then
        local v_u_219 = p_u_216.Model:FindFirstChild("RightHand")
        if v_u_219 then
            task.spawn(function()
                local v_u_220 = v_u_219.Position
                local v221 = (v_u_220 - p_u_217).Magnitude
                local v_u_222 = v_u_24[p_u_218]:Clone()
                v_u_222.PrimaryPart = v_u_222.Primary
                v_u_222:PivotTo(v_u_219.CFrame)
                v_u_222.Parent = workspace
                local v223 = Instance.new("WeldConstraint")
                v223.Part0 = v_u_219
                v223.Part1 = v_u_222.PrimaryPart
                v223.Parent = v_u_222
                local v224, v225 = pcall(p_u_216.Humanoid.LoadAnimation, p_u_216.Humanoid, p_u_216._grab_snowball_animation_throw)
                if v224 then
                    v225:Play()
                    v225:AdjustSpeed(1.25)
                    v_u_5:AddItem(v225, 2)
                    wait(0.32)
                end
                v_u_222.PrimaryPart.Anchored = true
                v223.Part0 = nil
                local v_u_226 = CFrame.Angles(math.random() * 3.141592653589793 * 2, math.random() * 3.141592653589793 * 2, math.random() * 3.141592653589793 * 2)
                v_u_7:RenderstepForLoop(0, 100, 225 / v221, function(p227)
                    local v228 = p227 / 100
                    local v229 = CFrame.new(v_u_220:Lerp(p_u_217, v228))
                    local v230 = v_u_220.Y
                    local v231 = p_u_217.Y - v_u_220.Y
                    local v232 = 1.8849555921538759 * v228
                    local v233 = v230 + v231 * (math.sin(v232) / 0.9510565162951536)
                    local v234 = 3.141592653589793 * v228
                    local v235 = math.sin(v234) * 3
                    local v236 = v_u_222
                    local v237 = CFrame.new
                    local v238 = v229.X
                    local v239 = v229.Y
                    local v240 = v229.Y - v233
                    local v241 = math.abs(v240)
                    v236:PivotTo(v237(v238, v239 + math.max(v235, v241), v229.Z) * v_u_226)
                end)
                for _, v242 in pairs(v_u_222:GetDescendants()) do
                    if v242:IsA("BasePart") then
                        v242.LocalTransparencyModifier = 1
                    end
                end
                v_u_5:AddItem(v_u_222, 4)
                local v243 = v_u_22[p_u_218].Attachment:Clone()
                v243.Parent = v_u_222.PrimaryPart
                v_u_7:PlayParticles(v243)
                v_u_7:CreateSound("rbxassetid://11800684590", 0.4, 0.9 + 0.2 * math.random(), v_u_222.PrimaryPart, true, 5)
            end)
        end
    else
        return
    end
end
function v_u_29._UpdateFlashlight(p244)
    if p244._camera_flashlight then
        local v245 = p244._camera_flashlight
        local v246
        if p244.ClientFighter:IsActuallyFirstPerson() then
            v246 = workspace.CurrentCamera.CFrame
        else
            v246 = (p244.Model:FindFirstChild("Head") or p244.RootPart).CFrame
        end
        v245.CFrame = v246
    end
end
function v_u_29._VerifyCameraFlashlight(p247)
    if p247:Get("CameraFlashlightEnabled") and not p247._camera_flashlight then
        p247._camera_flashlight = Instance.new("Part")
        p247._camera_flashlight.Size = Vector3.new(0, 0, 0)
        p247._camera_flashlight.Transparency = 1
        p247._camera_flashlight.CanCollide = false
        p247._camera_flashlight.CanTouch = false
        p247._camera_flashlight.CanQuery = false
        p247._camera_flashlight.Anchored = true
        p247._camera_flashlight.Name = "CameraFlashlight"
        p247._camera_flashlight.Parent = workspace
        local v248 = Instance.new("SpotLight")
        v248.Range = 48
        v248.Brightness = 3
        v248.Shadows = true
        v248.Parent = p247._camera_flashlight
        p247:_UpdateFlashlight()
    elseif not p247:Get("CameraFlashlightEnabled") and p247._camera_flashlight then
        p247._camera_flashlight:Destroy()
        p247._camera_flashlight = nil
    end
end
function v_u_29._UpdateAirborneEffect(p249)
    for _, v250 in pairs(p249._custom_knockback_effects) do
        if v250:IsA("Trail") then
            v250.Enabled = false
        end
        v_u_5:AddItem(v250, 0.25)
    end
    p249._custom_knockback_effects = {}
    if p249:IsAirborne() and not (p249.ClientFighter:Get("IsHiddenByEmotes") or p249.ClientFighter:Get("IsHiddenByCutscene")) then
        local v251 = Instance.new("Attachment")
        v251.Position = Vector3.new(-0.5, -2.9, 0)
        v251.Name = "Knockback0"
        v251.Parent = p249.RootPart
        local v252 = p249._custom_knockback_effects
        table.insert(v252, v251)
        local v253 = Instance.new("Attachment")
        v253.Position = Vector3.new(0.5, -2.9, 0)
        v253.Name = "Knockback1"
        v253.Parent = p249.RootPart
        local v254 = p249._custom_knockback_effects
        table.insert(v254, v253)
        local v255 = Instance.new("Trail")
        v255.Transparency = NumberSequence.new(1, 0)
        v255.WidthScale = NumberSequence.new(1, 0)
        v255.LightEmission = 1
        v255.FaceCamera = true
        v255.Lifetime = 0.25
        v255.Attachment0 = v251
        v255.Attachment1 = v253
        v255.Parent = p249.RootPart
        local v256 = p249._custom_knockback_effects
        table.insert(v256, v255)
    end
end
function v_u_29._UpdateChatBubbleMover(p_u_257)
    local v_u_258 = p_u_257._nametag
    if v_u_258 then
        v_u_258 = p_u_257._nametag:GetWinStreak() > 0
    end
    if not (v_u_258 and p_u_257._chat_bubble_mover.Parent) and (v_u_258 or p_u_257._chat_bubble_mover.Parent) then
        pcall(function()
            p_u_257._chat_bubble_mover.Parent = v_u_258 and p_u_257.RootPart or nil
        end)
        if v_u_258 then
            p_u_257._chat_bubble_mover:ClearAllChildren()
            p_u_257._chat_bubble_mover.CFrame = p_u_257.RootPart.CFrame + Vector3.new(0, 5, 0)
            local v259 = Instance.new("WeldConstraint")
            v259.Part0 = p_u_257.RootPart
            v259.Part1 = p_u_257._chat_bubble_mover
            v259.Parent = p_u_257._chat_bubble_mover
        end
    end
end
function v_u_29._UpdateHumanoidStates(p260)
    p260.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
    p260.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    p260.Humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, p260:Get("IsFrozen") or false)
    p260.Humanoid.PlatformStand = p260:Get("IsFrozen")
end
function v_u_29._GetSlidingAnimation(p261, p262, p263)
    local v264 = p263 * Vector3.new(1, 0, 1)
    p261.ClientFighter:GetRotationCFrame()
    local v265 = (1 / 0)
    local v266 = nil
    for _, v267 in pairs(v_u_28[p262]) do
        local v268 = v_u_7:AngleBetweenVectors(v264, p261.ClientFighter:GetRotationCFrame()[v267[2]] * v267[3] * Vector3.new(1, 0, 1))
        if v268 < v265 then
            v266 = v267
            v265 = v268
        end
    end
    return v266
end
function v_u_29._UpdateKnockbackAnimation(p_u_269, p270)
    if p_u_269._sliding_jump_fall_animation_track then
        p_u_269._sliding_jump_fall_animation_track:Stop(p270)
        p_u_269._sliding_jump_fall_animation_track:Destroy()
        p_u_269._sliding_jump_fall_animation_track = nil
    end
    if p_u_269.IsAirborneLocally then
        local v_u_271 = p_u_269._custom_knockback_hash
        local v272, v273 = pcall(p_u_269.Humanoid.LoadAnimation, p_u_269.Humanoid, v_u_12:GetPreloadedAnimation("SlidingJump"))
        if v272 then
            local v274 = p_u_269._animation_cleanup
            table.insert(v274, v273)
            v273:Play(0)
            p_u_269:DisableIKArms(1, true)
            task.delay(0.18333333333333332, function()
                if v_u_271 == p_u_269._custom_knockback_hash and p_u_269:IsAlive() then
                    local v275, v276 = pcall(p_u_269.Humanoid.LoadAnimation, p_u_269.Humanoid, v_u_12:GetPreloadedAnimation("SlidingJumpFall"))
                    if v275 then
                        local v277 = p_u_269._animation_cleanup
                        table.insert(v277, v276)
                        p_u_269._sliding_jump_fall_animation_track = v276
                        p_u_269._sliding_jump_fall_animation_track:Play(0)
                    end
                end
            end)
        end
    else
        return
    end
end
function v_u_29._SetHumanoidAnimation(p278, p279, p280)
    if p279 then
        p278._original_humanoid_animations[p279] = p278._original_humanoid_animations[p279] or p279.AnimationId
        p279.AnimationId = p280 or p278._original_humanoid_animations[p279]
    end
end
function v_u_29._UpdateHumanoidAnimations(p281)
    if p281.ClientFighter.IsLocalPlayer then
        local v282 = p281.Model:FindFirstChild("Animate")
        if v282 then
            local v283 = p281.ClientFighter:Get("IsCrouching")
            for v284, v285 in pairs(v_u_27) do
                local v286 = v282:FindFirstChild(v284)
                if v286 then
                    for _, v287 in pairs(v286:GetChildren()) do
                        p281:_SetHumanoidAnimation(v287, v283 and v285 and v285 or nil)
                    end
                end
            end
            if v282:FindFirstChild("Refresh") then
                v282.Refresh:Fire()
            end
        end
    else
        return
    end
end
function v_u_29._GetCharacterHeight(p288)
    local v289 = Instance.new("Model")
    for _, v290 in pairs(p288.Model:GetChildren()) do
        if v290:IsA("BasePart") and (v290.Transparency < 0.9 and v290.Material ~= Enum.Material.ForceField) then
            local v291 = Instance.new("Part")
            v291.Size = v290.ExtentsSize
            v291.CFrame = v290.ExtentsCFrame
            v291.Parent = v289
        end
    end
    local _, v292 = v289:GetBoundingBox()
    return v292.Y
end
function v_u_29._UpdatePlayerHitboxes(p_u_293)
    if p_u_293._hitboxes_visible ~= nil then
        p_u_293._update_hitboxes_check = true
        task.defer(function()
            if p_u_293._update_hitboxes_check and not p_u_293._destroyed then
                p_u_293._update_hitboxes_check = false
                local v294 = p_u_293._hitboxes_visible
                if v294 then
                    v294 = not p_u_293.ClientFighter:IsActuallyFirstPerson()
                end
                local v295 = v294 and 0 or 1
                for _, v296 in pairs(v_u_25) do
                    v_u_7:SilentWaitForChild(p_u_293.Model, v296).Transparency = v295
                end
            end
        end)
    end
end
function v_u_29._UpdateNametag(p297)
    if p297._nametag then
        p297._nametag:Destroy()
        p297._nametag = nil
    end
    task.defer(p297._UpdateChatBubbleMover, p297)
    if v_u_19.PageSystem.CurrentPage or (v_u_16.EditorEnabled or (v_u_17.Enabled or (v_u_18.Enabled or (p297.ClientFighter:Get("IsInDuel") or v_u_11:Get("Settings Hide HUD"))))) then
        return
    elseif not p297.ClientFighter:IsActuallyFirstPerson() then
        p297._nametag = v_u_20.new(p297.Player, p297.ClientFighter:Get("Controls"), p297.ClientFighter.Player:GetAttribute("StatisticDuelsWinStreak"), p297.ClientFighter.Player:GetAttribute("Level"), p297.ClientFighter.Player:GetAttribute("DisplayELO"), p297.ClientFighter.Player:GetAttribute("PlayerStatus"))
        p297._nametag:SetParent(p297.RootPart)
    end
end
function v_u_29._ClearExpiredBoosts(p298)
    local v299 = false
    for v300, v301 in pairs(p298._boosts) do
        if tick() > v301.Window then
            p298:RemoveBoost(v300, true)
            v299 = true
        end
    end
    if v299 then
        p298.BoostsChanged:Fire()
    end
end
function v_u_29._UpdateFalling(p302, _, p303)
    local v304 = p303.IsGrounded or p303.IsHiddenByCutscene
    if v304 or p302._falling_start then
        if v304 and (p302._falling_start and tick() - p302._falling_start > 0.25) then
            local v305 = p302.ClientFighter
            local v306 = (tick() - p302._falling_start - 1) * 0.45
            v305:CreateSound("rbxassetid://16736552001", math.clamp(v306, 0, 0.9) + 0.1, 1 + 0.75 * math.random(), true, 5)
            if p302._falling_sound then
                p302._falling_sound:Destroy()
                p302._falling_sound = nil
            end
            p302._falling_start = nil
            p303.JustLanded = true
            return true
        end
    else
        p302._falling_start = tick()
        local v307 = p302.ClientFighter.IsLocalPlayer
        if v307 then
            v307 = p302.ClientFighter:CreateSound("rbxassetid://16737738355", 0, 1, true)
        end
        p302._falling_sound = v307
        p302.ClientFighter:CreateSound("rbxassetid://16736552098", 0.5, 1 + 0.5 * math.random(), true, 5)
        if p302._falling_sound then
            p302._falling_sound.Looped = true
        end
    end
    if p302._falling_sound then
        local v308 = p302._falling_sound
        local v309 = -p302.RootPart.Velocity.Y - 24
        local v310 = math.max(0, v309)
        local v311 = (math.sqrt(v310) / 15) ^ 2 * 2
        v308.Volume = math.min(1, v311)
    end
end
function v_u_29._UpdateIKControl(p312, _, p313)
    if (not p313 or p313.IsAlive) and not p312._is_hidden then
        local v314 = p312._ik_control_target_item
        if v314 then
            v314 = (p312._ik_control_target_item.ViewModel.Model.HumanoidRootPart.Position - p312.RootPart.Position).Magnitude < 16
        end
        p312._right_hand_ik_control.Enabled = p312._right_hand_ik_control.Target and v314
        p312._left_hand_ik_control.Enabled = p312._left_hand_ik_control.Target and v314
    end
end
function v_u_29._UpdateSpine(p315, _, p316)
    if p316.IsAlive and not p315._is_hidden then
        p315._camera_rotation_spring.Target = Vector2.new(p316.CameraRotationRaw.X > 3.141592653589793 and p316.CameraRotationRaw.X - 6.283185307179586 or p316.CameraRotationRaw.X, p316.CameraRotationRaw.Y > 3.141592653589793 and p316.CameraRotationRaw.Y - 6.283185307179586 or p316.CameraRotationRaw.Y)
        p315._camera_lean_spring.Target = p316.CameraLean
        local v317 = p315._camera_rotation_spring.Value
        local v318 = p315._camera_lean_spring.Value
        if p315._waist_motor6d then
            p315._waist_motor6d.C0 = CFrame.new(p315._waist_motor6d.C0.Position) * CFrame.Angles(v317.X * 0.25, 0, 0)
            p315._waist_motor6d.C1 = CFrame.new(p315._waist_motor6d.C1.Position)
        end
        if p315._neck_motor6d then
            p315._neck_motor6d.C0 = CFrame.new(p315._neck_motor6d.C0.Position) * CFrame.Angles(v317.X * 0.75, 0, 0)
            p315._neck_motor6d.C1 = CFrame.new(p315._neck_motor6d.C1.Position)
        end
        if p315._root_motor6d and p315._root_motor6d_origin then
            p315._root_motor6d.C0 = p315._root_motor6d_origin * CFrame.new(v318 * 1.25, 0, 0) * CFrame.Angles(0, 0, v318 * -0.3490658503988659)
        end
    end
end
function v_u_29._UpdateFootstep(p319, _, p320)
    if not p320.IsAlive or (p320.IsCrouching or (p320.IsSliding or not (p320.IsGrounded or p320.IsClimbing))) or (p320.IsHiddenByEmotes or p320.IsHiddenByCutscene) then
        return
    end
    local v321 = p319:GetCurrentEmote()
    if v321 and (v321.Info.HideFootsteps and not p319.ClientFighter:Get("IsInDuel")) then
        return
    end
    local v322 = p319.ClientFighter.Entity:Get("Scale") or 1
    local v323 = 1 + (v322 - 1) / 2
    if p320.IsClimbing then
        local v324 = p320.PlayerVelocity.Y * 1.25
        v325 = math.abs(v324)
        if v325 then
            goto l15
        end
    end
    local v325 = p320.MoveSpeed / v323
    ::l15::
    if v325 < 1 or tick() < p319._last_footstep + 4.5 / v325 then
        return
    else
        p319._last_footstep = tick()
        local v326 = p320.IsClimbing and "Climbing" or (v322 >= 2 and "Stomping" or (v_u_6.FootstepSounds[p319.Humanoid.FloorMaterial.Name] and (p319.Humanoid.FloorMaterial.Name or "Default") or "Default"))
        local v327 = v_u_6.FootstepSounds[v326]
        local v328 = v_u_6.FootstepSounds[v327] or v327
        if #v328 ~= 0 then
            local v329 = (0.875 + 0.25 * math.random()) * (1 + 0.1 * (v325 / 16))
            local v330 = v325 / 32 * (v326 == "Default" and 2 or 1) * (v326 == "Stomping" and 2 or 1) * (p319.ClientFighter:Get("IsSpectating") and 0.5 or 1)
            p319.ClientFighter:CreateSound(v328[math.random(#v328)], v330 * 0.75, v329, true, 5, 32, 100)
        end
    end
end
function v_u_29._UpdateObjectVisibility(p331, p332)
    if p331._original_character_properties[p332] or p331:IsAlive() then
        local v333 = p331._is_hidden or (p331.ClientFighter:Get("IsHiddenByEmotes") or p331.ClientFighter:Get("IsHiddenByCutscene"))
        local v334 = not p331._is_translucent and p331:Get("IsTranslucent")
        if v334 then
            v334 = not p331.ClientFighter:Get("IsSpectating")
        end
        if p332:IsA("BasePart") or (p332:IsA("Decal") or p332:IsA("Texture")) then
            p331._original_character_properties[p332] = p331._original_character_properties[p332] or {
                ["Transparency"] = p332.Transparency
            }
            local v335 = p331._original_character_properties[p332].Transparency
            p332.Transparency = v335 + (1 - v335) * (v333 and 1 or (v334 and 0.875 or 0))
        elseif p332:IsA("ParticleEmitter") or (p332:IsA("Fire") or (p332:IsA("Sparkles") or (p332:IsA("Smoke") or p332:IsA("Trail")))) then
            p331._original_character_properties[p332] = p331._original_character_properties[p332] or {
                ["Enabled"] = p332.Enabled
            }
            local v336
            if v333 or v334 then
                v336 = false
            else
                v336 = p331._original_character_properties[p332].Enabled
            end
            p332.Enabled = v336
            if not p332.Enabled and p332:IsA("ParticleEmitter") then
                p332:Clear()
            end
        end
    else
        return
    end
end
function v_u_29._BulkUpdateVisibility(p337)
    for _, v338 in pairs(p337.Model:GetDescendants()) do
        if not (table.find(v_u_25, v338.Name) or v338:GetAttribute("IgnoreVisibilityCheck")) then
            p337:_UpdateObjectVisibility(v338)
        end
    end
end
function v_u_29._UpdateVisibility(p339, p340, p341)
    local v342 = p339.ClientFighter:IsActuallyFirstPerson()
    if v342 then
        v342 = p339.ClientFighter:IsActive()
    end
    if p340 or v342 ~= p339._is_hidden then
        if p341 ~= nil then
            v342 = p341
        end
        p339._is_hidden = v342
        p339:_BulkUpdateVisibility()
    end
end
function v_u_29._Setup(p_u_343)
    p_u_343._chat_bubble_mover.CanCollide = false
    p_u_343._chat_bubble_mover.CanTouch = false
    p_u_343._chat_bubble_mover.CanQuery = false
    p_u_343._chat_bubble_mover.Massless = true
    p_u_343._chat_bubble_mover.Transparency = 1
    p_u_343._grab_snowball_animation_start.AnimationId = "rbxassetid://127148856297189"
    p_u_343._grab_snowball_animation_idle.AnimationId = "rbxassetid://120318438418071"
    p_u_343._grab_snowball_animation_throw.AnimationId = "rbxassetid://107298949913168"
    local v344 = p_u_343._animation_cleanup
    local v345 = p_u_343._grab_snowball_animation_start
    table.insert(v344, v345)
    local v346 = p_u_343._animation_cleanup
    local v347 = p_u_343._grab_snowball_animation_idle
    table.insert(v346, v347)
    local v348 = p_u_343._animation_cleanup
    local v349 = p_u_343._grab_snowball_animation_throw
    table.insert(v348, v349)
    p_u_343._right_hand_ik_control.Name = "RightHandIKControl"
    p_u_343._right_hand_ik_control.EndEffector = p_u_343.Model:WaitForChild("RightHand")
    p_u_343._right_hand_ik_control.ChainRoot = p_u_343.Model:WaitForChild("RightUpperArm")
    p_u_343._right_hand_ik_control.SmoothTime = 0
    p_u_343._right_hand_ik_control.Enabled = false
    p_u_343._right_hand_ik_control.Parent = p_u_343.Humanoid
    p_u_343._left_hand_ik_control.Name = "LeftHandIKControl"
    p_u_343._left_hand_ik_control.EndEffector = p_u_343.Model:WaitForChild("LeftHand")
    p_u_343._left_hand_ik_control.ChainRoot = p_u_343.Model:WaitForChild("LeftUpperArm")
    p_u_343._left_hand_ik_control.SmoothTime = 0
    p_u_343._left_hand_ik_control.Enabled = false
    p_u_343._left_hand_ik_control.Parent = p_u_343.Humanoid
    while not p_u_343.Model:IsDescendantOf(workspace) do
        p_u_343.Model.AncestryChanged:Wait()
    end
    if not p_u_343._destroyed then
        p_u_343.Head = p_u_343.Model:WaitForChild("Head")
        p_u_343._waist_motor6d = p_u_343.Model:WaitForChild("UpperTorso"):WaitForChild("Waist")
        p_u_343._neck_motor6d = p_u_343.Model:WaitForChild("Head"):WaitForChild("Neck")
        p_u_343._root_motor6d = p_u_343.Model:WaitForChild("LowerTorso"):WaitForChild("Root")
        p_u_343._root_motor6d_origin = p_u_343._root_motor6d.C0
        local v_u_350 = {}
        local function v354()
            for v351, v353 in pairs(v_u_350) do
                if p_u_343.ClientFighter:Get("IsInDuel") and not v_u_14:Get("DisableTransparentHats") then
                    local v353 = v353 + (1 - v353) * 0.875
                end
                v351.Transparency = v353
            end
        end
        local v355 = p_u_343._connections
        local v356 = p_u_343.ClientFighter:GetDataChangedSignal("IsInDuel")
        table.insert(v355, v356:Connect(v354))
        local v357 = p_u_343._connections
        local v358 = v_u_14:GetDataChangedSignal("DisableTransparentHats")
        table.insert(v357, v358:Connect(v354))
        local function v_u_367(p359)
            if not p_u_343.ClientFighter.IsLocalPlayer and p359:IsA("Accessory") then
                local function v365(p_u_360)
                    if p_u_360:IsA("BasePart") then
                        local function v364()
                            local v361 = 3 * (p_u_343:Get("Scale") or 1)
                            if v361 < p_u_360.Size.X or (v361 < p_u_360.Size.Y or v361 < p_u_360.Size.Z) then
                                v_u_350[p_u_360] = v_u_350[p_u_360] or p_u_360.Transparency
                                local v362 = p_u_360
                                local v363 = p_u_360.Transparency
                                if p_u_343.ClientFighter:Get("IsInDuel") and not v_u_14:Get("DisableTransparentHats") then
                                    v363 = v363 + (1 - v363) * 0.875
                                end
                                v362.Transparency = v363
                            end
                        end
                        p_u_360:GetPropertyChangedSignal("Size"):Connect(v364)
                        v364()
                    end
                end
                p359.ChildAdded:Connect(v365)
                for _, v366 in pairs(p359:GetChildren()) do
                    v365(v366)
                end
            end
        end
        for _, v368 in pairs(p_u_343.Model:GetChildren()) do
            v_u_367(v368)
        end
        local v_u_369 = false
        p_u_343.Model.ChildAdded:Connect(function(p370)
            if p_u_343:IsAlive() then
                v_u_367(p370)
                v_u_369 = true
                task.defer(function()
                    if v_u_369 then
                        v_u_369 = false
                        p_u_343:_UpdateVisibility(true)
                        p_u_343:_UpdatePlayerHitboxes()
                    end
                end)
            end
        end)
        p_u_343:_UpdateVisibility(true)
        p_u_343:_UpdateNametag()
        p_u_343:_UpdatePlayerHitboxes()
        p_u_343:_UpdateHumanoidStates()
        p_u_343:_UpdateHumanoidAnimations()
        p_u_343:_VerifyCameraFlashlight()
    end
end
function v_u_29._Init(p_u_371)
    p_u_371.Died:Connect(function()
        local v372 = p_u_371
        v372._sliding_animation_hash = v372._sliding_animation_hash + 1
        if p_u_371._falling_sound then
            p_u_371._falling_sound:Destroy()
            p_u_371._falling_sound = nil
        end
    end)
    p_u_371.AirborneLocallyChanged:Connect(function()
        p_u_371:_UpdateAirborneEffect()
    end)
    p_u_371.BurnEffectPlaying:Connect(function()
        for _, v373 in pairs(p_u_371._burn_effect_particles) do
            p_u_371:_UpdateObjectVisibility(v373)
        end
    end)
    p_u_371.EmoteStatusChanged:Connect(function()
        if p_u_371:IsEmoting() then
            p_u_371:DisableIKArms((1 / 0))
        else
            p_u_371:DisableIKArms(0)
        end
    end)
    p_u_371:GetDataChangedSignal("IsFrozen"):Connect(function()
        if p_u_371:Get("IsFrozen") then
            p_u_371:CancelCustomKnockback()
        end
        p_u_371:_UpdateHumanoidStates()
    end)
    p_u_371:GetDataChangedSignal("IsGrabbingSnowball"):Connect(function()
        local v374 = p_u_371:Get("IsGrabbingSnowball")
        if v374 then
            p_u_371:_GrabSnowball(v374)
        end
    end)
    p_u_371:GetDataChangedSignal("IsTranslucent"):Connect(function()
        p_u_371:_UpdateVisibility()
    end)
    p_u_371:GetDataChangedSignal("CameraFlashlightEnabled"):Connect(function()
        p_u_371:_VerifyCameraFlashlight()
    end)
    if not p_u_371.ClientFighter.IsLocalPlayer then
        p_u_371:GetDataChangedSignal("IsAirborne"):Connect(function()
            p_u_371:_UpdateAirborneEffect()
        end)
    end
    local v375 = p_u_371._connections
    local v376 = p_u_371.ClientFighter:GetDataChangedSignal("IsSpectating")
    table.insert(v375, v376:Connect(function()
        p_u_371:_UpdateVisibility()
        p_u_371:_UpdateNametag()
        p_u_371:_UpdatePlayerHitboxes()
    end))
    local v377 = p_u_371._connections
    local v378 = p_u_371.ClientFighter:GetDataChangedSignal("IsInDuel")
    table.insert(v377, v378:Connect(function()
        p_u_371:_UpdateVisibility()
        p_u_371:_UpdateNametag()
    end))
    local v379 = p_u_371._connections
    local v380 = p_u_371.ClientFighter.ItemAdded
    table.insert(v379, v380:Connect(function()
        p_u_371:_UpdateVisibility()
        p_u_371:_UpdatePlayerHitboxes()
    end))
    local v381 = p_u_371._connections
    local v382 = p_u_371.ClientFighter.ItemRemoved
    table.insert(v381, v382:Connect(function()
        p_u_371:_UpdateVisibility()
        p_u_371:_UpdatePlayerHitboxes()
    end))
    local v383 = p_u_371._connections
    local v384 = p_u_371.ClientFighter.EquippedItemChanged
    table.insert(v383, v384:Connect(function()
        p_u_371:_UpdateIKControl(nil, nil)
    end))
    local v385 = p_u_371._connections
    local v386 = p_u_371.ClientFighter:GetDataChangedSignal("Controls")
    table.insert(v385, v386:Connect(function()
        p_u_371:_UpdateNametag()
    end))
    local v387 = p_u_371._connections
    local v388 = p_u_371.ClientFighter:GetDataChangedSignal("IsInDuel")
    table.insert(v387, v388:Connect(function()
        p_u_371:_UpdateNametag()
    end))
    local v389 = p_u_371._connections
    local v390 = p_u_371.ClientFighter:GetDataChangedSignal("IsHiddenByEmotes")
    table.insert(v389, v390:Connect(function()
        p_u_371:_UpdateVisibility(true)
        p_u_371:_UpdateAirborneEffect()
    end))
    local v391 = p_u_371._connections
    local v392 = p_u_371.ClientFighter:GetDataChangedSignal("IsHiddenByCutscene")
    table.insert(v391, v392:Connect(function()
        p_u_371:_UpdateVisibility(true)
        p_u_371:_UpdateAirborneEffect()
    end))
    local v393 = p_u_371._connections
    local v394 = p_u_371.ClientFighter.Player:GetAttributeChangedSignal("StatisticDuelsWinStreak")
    table.insert(v393, v394:Connect(function()
        p_u_371:_UpdateNametag()
    end))
    local v395 = p_u_371._connections
    local v396 = p_u_371.ClientFighter.Player:GetAttributeChangedSignal("Level")
    table.insert(v395, v396:Connect(function()
        p_u_371:_UpdateNametag()
    end))
    local v397 = p_u_371._connections
    local v398 = p_u_371.ClientFighter.Player:GetAttributeChangedSignal("DisplayELO")
    table.insert(v397, v398:Connect(function()
        p_u_371:_UpdateNametag()
    end))
    local v399 = p_u_371._connections
    local v400 = p_u_371.ClientFighter.Player:GetAttributeChangedSignal("PlayerStatus")
    table.insert(v399, v400:Connect(function()
        p_u_371:_UpdateNametag()
    end))
    local v401 = p_u_371._connections
    local v402 = v_u_13.StateChanged
    table.insert(v401, v402:Connect(function()
        p_u_371:_UpdateVisibility()
        p_u_371:_UpdateNametag()
        p_u_371:_UpdatePlayerHitboxes()
    end))
    local v403 = p_u_371._connections
    local v404 = v_u_19.PageSystem.PagesActivity
    table.insert(v403, v404:Connect(function()
        p_u_371:_UpdateNametag()
    end))
    local v405 = p_u_371._connections
    local v406 = v_u_16.EditorEnabledChanged
    table.insert(v405, v406:Connect(function()
        p_u_371:_UpdateNametag()
    end))
    local v407 = p_u_371._connections
    local v408 = v_u_17.EnabledChanged
    table.insert(v407, v408:Connect(function()
        p_u_371:_UpdateNametag()
    end))
    local v409 = p_u_371._connections
    local v410 = v_u_18.EnabledChanged
    table.insert(v409, v410:Connect(function()
        p_u_371:_UpdateNametag()
    end))
    local v411 = p_u_371._connections
    local v412 = v_u_11:GetDataChangedSignal("Settings Player Hitboxes")
    table.insert(v411, v412:Connect(function()
        p_u_371:_UpdatePlayerHitboxes()
    end))
    local v413 = p_u_371._connections
    local v414 = v_u_11:GetDataChangedSignal("Settings Hide HUD")
    table.insert(v413, v414:Connect(function()
        p_u_371:_UpdateNametag()
    end))
    local v415 = p_u_371._connections
    local v416 = v_u_10:GetLeaderboardRefreshedSignal("Highest ELO")
    table.insert(v415, v416:Connect(function()
        p_u_371:_UpdateNametag()
    end))
    local v417 = p_u_371._connections
    local v418 = p_u_371.ClientFighter:GetDataChangedSignal("IsCrouching")
    table.insert(v417, v418:Connect(function()
        p_u_371:_UpdateHumanoidAnimations()
    end))
    local v419 = p_u_371._connections
    local v420
    if p_u_371.ClientFighter.IsLocalPlayer then
        v420 = p_u_371.Humanoid.StateChanged:Connect(function(_, p421)
            if p_u_371._custom_knockback_velocity and (not v_u_4.AIRBORNE_HUMANOID_STATES[p421] and tick() > p_u_371._custom_knockback_start + 0.1) then
                p_u_371:CancelCustomKnockback()
            end
        end)
    else
        v420 = nil
    end
    table.insert(v419, v420)
    task.spawn(p_u_371._Setup, p_u_371)
end
return v_u_29