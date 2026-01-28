local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("ContentProvider")
local v_u_3 = require(v1.Modules.AnimationLibrary)
local v_u_4 = require(v1.Modules.SoundLibrary)
local v_u_5 = require(v1.Modules.Signal)
local v_u_6 = {}
v_u_6.__index = v_u_6
function v_u_6.new(p7)
    local v8 = v_u_6
    local v9 = setmetatable({}, v8)
    v9.AnimationPlayed = v_u_5.new()
    v9.AnimationStopped = v_u_5.new()
    v9.ClientViewModel = p7
    v9.SprintTrackSpeed = 1
    v9._viewmodel_animations = v9.ClientViewModel.Info.Animations
    v9._play_animations_instantly = v9.ClientViewModel.Info.PlayAnimationsInstantly
    v9._render_cooldown = 0
    v9._inspect_cooldown = 0
    v9._animations_loaded = false
    v9._animation_cleanup = {}
    v9._animation_tracks = {}
    v9._animation_hashes = {}
    v9._animation_keys_lookup = {}
    v9._equip_animation = nil
    v9._idle_animation = nil
    v9._inspect_animation = nil
    v9._rare_inspect_animation = nil
    v9._sprint_animation = nil
    v9._should_override_previous_animations_on_play = false
    v9._last_animation_key_played = nil
    v9._blocked_animations = {}
    v9:_Init()
    return v9
end
function v_u_6.IsRenderingDisabled(p10)
    return tick() < p10._render_cooldown
end
function v_u_6.IsAnimationPlaying(p11, p12)
    local v13 = p11:GetAnimationTrack(p12)
    if v13 then
        v13 = v13.IsPlaying
    end
    return v13
end
function v_u_6.AreAnimationsPlaying(p14, p15)
    for _, v16 in pairs(p15) do
        if p14:IsAnimationPlaying(v16) then
            return true
        end
    end
end
function v_u_6.GetEquipAnimationKey(p17)
    return p17._equip_animation
end
function v_u_6.GetIdleAnimationKey(p18)
    return p18._idle_animation
end
function v_u_6.GetInspectAnimationKey(p19)
    return p19._inspect_animation
end
function v_u_6.GetRareInspectAnimationKey(p20)
    return p20._rare_inspect_animation
end
function v_u_6.GetAnimationTrack(p21, p22)
    return p21._animation_tracks[p22]
end
function v_u_6.GetAnimationKeys(p23, p24)
    if p23._animation_keys_lookup[p24] then
        return p23._animation_keys_lookup[p24]
    end
    local v25 = {}
    for v26 = 1, (1 / 0) do
        local v27 = p24 .. v26
        if not p23:GetAnimationTrack(v27) then
            break
        end
        table.insert(v25, v27)
    end
    p23._animation_keys_lookup[p24] = v25
    return v25
end
function v_u_6.IsInspectAnimationPlaying(p28)
    return p28:IsAnimationPlaying(p28._inspect_animation) or p28:IsAnimationPlaying(p28._rare_inspect_animation)
end
function v_u_6.GetSprintTrack(p29)
    return p29:GetAnimationTrack(p29._sprint_animation)
end
function v_u_6.IsAnimationHashValid(p30, p31, p32)
    return p30._animation_hashes[p31] == p32
end
function v_u_6.AnimationWait(p33, p34, p35, p36)
    local v37 = wait(p36)
    if v37 then
        v37 = p33:IsAnimationHashValid(p34, p35)
    end
    return v37
end
function v_u_6.SetInspectCooldown(p38, p39)
    p38._inspect_cooldown = tick() + p39
end
function v_u_6.CreateSound(p40, ...)
    return p40.ClientViewModel:CreateSound(...)
end
function v_u_6.OverridePreviousAnimationsOnPlay(p41, p42)
    p41._should_override_previous_animations_on_play = p42
end
function v_u_6.BlockAnimation(p43, p44, p45)
    local v46 = typeof(p44) == "string"
    assert(v46, "Argument 1 invalid, expected a string")
    local v47 = typeof(p45) == "number"
    assert(v47, "Argument 2 invalid, expected a number")
    p43._blocked_animations[p44] = tick() + p45
end
function v_u_6.PlayAnimation(p48, p49, p50, p51, p52, p53)
    local v54 = typeof(p49) == "string"
    assert(v54, "Argument 1 invalid, expected a string")
    local v55 = not p50 or typeof(p50) == "number"
    assert(v55, "Argument 2 invalid, expected a number")
    if tick() < (p48._blocked_animations[p49] or 0) then
        return
    else
        local v56 = p48._play_animations_instantly and 0 or p51
        if p50 then
            p48:SetInspectCooldown(p50)
            p48:StopInspecting()
        end
        local v57 = p48:_AnimationKeyToName(p49)
        if v57 then
            p48._animation_hashes[v57] = (p48._animation_hashes[v57] or 0) + 1
        end
        if p48._should_override_previous_animations_on_play and (p49 ~= p48:GetIdleAnimationKey() and (p49 ~= p48._sprint_animation and (p48._last_animation_key_played ~= p48:GetIdleAnimationKey() and p48._last_animation_key_played ~= p48._sprint_animation))) then
            if p48._last_animation_key_played then
                p48:StopAnimation(p48._last_animation_key_played, 0)
            end
            p48._last_animation_key_played = p49
        end
        local v58 = p48:GetAnimationTrack(p49)
        if v58 then
            local v59 = v_u_3.Info[v57]
            local v60 = v59.Speed * (p53 or 1)
            v58:Play(v56, p52, v60)
            if v59.SoundCallback then
                task.defer(v59.SoundCallback, p48.ClientViewModel, p48._animation_hashes[v57], v60)
            end
            p48.AnimationPlayed:Fire(p49)
        else
            warn("Animation key failed to play (not found): " .. tostring(p49))
        end
    end
end
function v_u_6.PlayIdleAnimation(p61)
    if p61.ClientViewModel:IsEquipped() then
        p61:PlayAnimation(p61._idle_animation, nil, 0)
    end
end
function v_u_6.PlayEquipAnimation(p62)
    if p62:GetAnimationTrack(p62._equip_animation) then
        p62:PlayAnimation(p62._equip_animation)
        return true
    end
end
function v_u_6.PlaySprintAnimation(p63)
    p63:PlayAnimation(p63._sprint_animation)
end
function v_u_6.Inspect(p64, p65)
    local v66 = not p65 or typeof(p65) == "boolean"
    assert(v66, "Argument 1 invalid, expected a boolean or nil")
    if tick() < p64._inspect_cooldown or p64.ClientViewModel.ClientItem:IsEquipping() then
        return false
    end
    p64:StopAnimation(p64._equip_animation, 0)
    local v67 = p64:StopInspecting()
    local v68 = not p65 and (p65 == nil and p64:GetAnimationTrack(p64._rare_inspect_animation))
    if v68 then
        v68 = math.random() < 0.1
    end
    if v68 then
        p64:CreateSound(v_u_4.EquipSounds[math.random(#v_u_4.EquipSounds)], 0.375, 1.4 + 0.2 * math.random(), true, 5)
        p64:CreateSound("rbxassetid://13159969353", 0.25, 1 + 0.25 * math.random(), true, 5)
        p64:PlayAnimation(p64._rare_inspect_animation, nil, v67 and 0 or 0.2)
    else
        if not p64:GetAnimationTrack(p64._inspect_animation) then
            return false
        end
        p64:CreateSound(v_u_4.EquipSounds[math.random(#v_u_4.EquipSounds)], 0.375, 1.4 + 0.2 * math.random(), true, 5)
        p64:PlayAnimation(p64._inspect_animation, nil, v67 and 0 or 0.2)
    end
    return true, v68
end
function v_u_6.StopAnimation(p69, p70, p71, p72)
    local v73 = typeof(p70) == "string"
    assert(v73, "Argument 1 invalid, expected a string")
    local v74 = not p72 or typeof(p72) == "number"
    assert(v74, "Argument 3 invalid, expected a number")
    local v75 = p69._play_animations_instantly and 0 or p71
    if p72 then
        p69:SetInspectCooldown(p72)
        p69:StopInspecting()
    end
    local v76 = p69:_AnimationKeyToName(p70)
    if v76 then
        p69._animation_hashes[v76] = (p69._animation_hashes[v76] or 0) + 1
    end
    local v77 = p69:GetAnimationTrack(p70)
    if v77 then
        v77:Stop(v75)
        p69.AnimationStopped:Fire(p70)
    end
end
function v_u_6.StopInspecting(p78)
    if p78:GetAnimationTrack(p78._inspect_animation) and p78:GetAnimationTrack(p78._inspect_animation).IsPlaying then
        p78:StopAnimation(p78._inspect_animation, 0.1)
        return 0.1
    end
    if p78:GetAnimationTrack(p78._rare_inspect_animation) and p78:GetAnimationTrack(p78._rare_inspect_animation).IsPlaying then
        p78:StopAnimation(p78._rare_inspect_animation, 0.1)
        return 0.1
    end
end
function v_u_6.StopSprintAnimation(p79)
    p79:StopAnimation(p79._sprint_animation)
end
function v_u_6.StopAllAnimations(p80)
    for v81 in pairs(p80._animation_tracks) do
        p80:StopAnimation(v81)
    end
end
function v_u_6.ChangeEquipAnimation(p82, p83)
    local v84 = p83 or "Equip"
    if v84 ~= p82._equip_animation then
        p82._equip_animation = v84
    end
end
function v_u_6.ChangeIdleAnimation(p85, p86)
    local v87 = p86 or "Idle"
    if v87 ~= p85._idle_animation then
        if p85._idle_animation then
            p85:StopAnimation(p85._idle_animation)
        end
        p85._idle_animation = v87
        p85:PlayIdleAnimation()
    end
end
function v_u_6.ChangeSprintAnimation(p88, p89)
    local v90 = p89 or "Sprint"
    if v90 ~= p88._sprint_animation then
        if p88._sprint_animation then
            p88:StopAnimation(p88._sprint_animation)
        end
        p88._sprint_animation = v90
        p88.SprintTrackSpeed = p88:_AnimationKeyToName(p88._sprint_animation) and (v_u_3.Info[p88:_AnimationKeyToName(p88._sprint_animation)].Speed or 1) or 1
    end
end
function v_u_6.ChangeInspectAnimation(p91, p92)
    local v93 = p92 or "Inspect"
    if v93 ~= p91._inspect_animation then
        if p91._inspect_animation then
            p91:StopAnimation(p91._inspect_animation)
        end
        p91._inspect_animation = v93
    end
end
function v_u_6.ChangeRareInspectAnimation(p94, p95)
    local v96 = p95 ~= "nil" and (p95 or "RareInspect") or nil
    if v96 ~= p94._rare_inspect_animation then
        if p94._rare_inspect_animation then
            p94:StopAnimation(p94._rare_inspect_animation)
        end
        p94._rare_inspect_animation = v96
    end
end
function v_u_6.LoadAnimations(p_u_97)
    if not p_u_97._animations_loaded and p_u_97.ClientViewModel.Model:IsDescendantOf(game) then
        p_u_97._animations_loaded = true
        local v_u_98 = {}
        local function v108(p_u_99, p_u_100)
            local v101 = v_u_3.Info[p_u_100].AnimationID
            local v102 = Instance.new("Animation")
            v102.AnimationId = v101
            local v103 = v_u_98
            table.insert(v103, v102)
            local v104 = p_u_97._animation_cleanup
            table.insert(v104, v102)
            local v105, v_u_106 = pcall(p_u_97.ClientViewModel.Model.AnimationController.Animator.LoadAnimation, p_u_97.ClientViewModel.Model.AnimationController.Animator, v102)
            if v105 then
                local v107 = p_u_97._animation_cleanup
                table.insert(v107, v_u_106)
                v_u_106.Stopped:Connect(function()
                    p_u_97._animation_hashes[p_u_100] = (p_u_97._animation_hashes[p_u_100] or 0) + 1
                    p_u_97.AnimationStopped:Fire(p_u_99)
                    if p_u_97._play_animations_instantly then
                        v_u_106:Stop(0)
                    end
                end)
                p_u_97._animation_tracks[p_u_99] = v_u_106
            else
                warn("FAILED TO LOAD ANIMATION FOR " .. p_u_97.ClientViewModel.Name .. ": " .. p_u_99 .. ", " .. p_u_100 .. ", " .. v101)
            end
        end
        for v109, v110 in pairs(p_u_97._viewmodel_animations) do
            task.spawn(v108, v109, v110)
        end
        task.spawn(function()
            v_u_2:PreloadAsync(v_u_98)
            p_u_97._render_cooldown = tick() + 0.1
        end)
        p_u_97._render_cooldown = tick() + 5
        p_u_97:ChangeEquipAnimation("Equip")
        p_u_97:ChangeIdleAnimation("Idle")
        p_u_97:ChangeSprintAnimation("Sprint")
        p_u_97:ChangeInspectAnimation("Inspect")
        p_u_97:ChangeRareInspectAnimation("RareInspect")
        p_u_97:PlayIdleAnimation()
    end
end
function v_u_6.Destroy(p111)
    for _, v112 in pairs(p111._animation_cleanup) do
        v112:Destroy()
    end
    p111._animation_cleanup = {}
    p111._animation_hashes = {}
end
function v_u_6._AnimationKeyToName(p113, p114)
    return p113._viewmodel_animations[p114]
end
function v_u_6._Init(_) end
return v_u_6