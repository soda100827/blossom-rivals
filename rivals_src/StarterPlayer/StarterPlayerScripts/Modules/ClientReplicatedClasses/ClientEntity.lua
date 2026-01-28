local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("CollectionService")
local v3 = game:GetService("Players")
local v_u_4 = require(v1.Modules.CONSTANTS)
local v_u_5 = require(v1.Modules.ReplicatedClass)
local v_u_6 = require(v1.Modules.BetterDebris)
local v_u_7 = require(v1.Modules.GameplayUtility)
local v_u_8 = require(v1.Modules.Utility)
local v_u_9 = require(v1.Modules.Signal)
local v_u_10 = v3.LocalPlayer.PlayerScripts.Assets.Misc.InvincibilityParticles.Attachment
local v_u_11 = v3.LocalPlayer.PlayerScripts.Assets.Misc.ExtinguishParticles
local v_u_12 = v3.LocalPlayer.PlayerScripts.Assets.Misc.FreezeEffects
local v_u_13 = v3.LocalPlayer.PlayerScripts.Assets.Misc.BurningEffects
local v_u_14 = v3.LocalPlayer.PlayerScripts.Assets.Misc.BlipEffects
local v_u_15 = v1.Modules.Finishers
local v_u_16 = setmetatable({}, v_u_5)
v_u_16.__index = v_u_16
function v_u_16.new(p17)
    local v18 = v_u_5.new(p17)
    local v19 = v_u_16
    local v20 = setmetatable(v18, v19)
    v20.Model = p17.Model
    v20.RootPart = p17.RootPart
    v20.AimAssistBlacklist = false
    v20.Died = v_u_9.new()
    v20.HealthChanged = v_u_9.new()
    v20.BurnEffectPlaying = v_u_9.new()
    v20._destroyed = nil
    v20._is_dead = nil
    v20._connections = {}
    v20._hurt_effect_hash = 0
    v20._hitboxes = {}
    v20._burn_effect_finish = 0
    v20._burn_effect_sound = nil
    v20._burn_effect_particles = {}
    v20._model_original_parent_hurt_effect = nil
    v20._thaw_callback = nil
    v20._current_finisher = nil
    v20._invincibility_visual = nil
    v20._headshot_particles = nil
    v20:_Init()
    return v20
end
function v_u_16.IsRendered(p21)
    local v22 = v_u_4.SHOULD_ALWAYS_REPLICATE()
    if not v22 then
        if p21.ClientFighter then
            return p21.ClientFighter:IsRendered()
        end
        v22 = (workspace.CurrentCamera.CFrame.Position - p21.RootPart.Position).Magnitude < v_u_4.RENDER_DISTANCE
    end
    return v22
end
function v_u_16.IsAlive(p23)
    local v24 = not (p23._destroyed or p23._is_dead)
    if v24 then
        v24 = p23:GetHealth() > 0
    end
    return v24
end
function v_u_16.GetScreenPoint(p25)
    return workspace.CurrentCamera:WorldToScreenPoint(p25.RootPart.Position)
end
function v_u_16.GetHitboxes(p26)
    return p26._hitboxes
end
function v_u_16.ReplicateFromServer(p27, p28, ...)
    if p28 == "BurnEffect" then
        if p27:IsRendered() then
            p27:_BurnEffect(...)
        end
    elseif p28 == "ExtinguishEffect" then
        if p27:IsRendered() then
            p27:_ExtinguishEffect(...)
        end
    elseif p28 == "HurtEffect" then
        if p27:IsRendered() then
            p27:_HurtEffect(...)
        end
    elseif p28 == "HealEffect" then
        if p27:IsRendered() then
            p27:_HealEffect(...)
        end
    elseif p28 == "FreezeEffect" then
        if p27:IsRendered() then
            p27:_FreezeEffect(...)
        end
    elseif p28 == "ThawFreezeEffect" then
        if p27:IsRendered() then
            p27:_ThawFreezeEffect(...)
        end
    elseif p28 == "FinisherEffect" then
        if p27:IsRendered() then
            local v29, v30, v31, v32 = ...
            p27:_PlayFinisher(p27:FromEnum(v29), v30, v31, v32)
        end
    elseif p28 == "BlipEffect" then
        if p27:IsRendered() then
            p27:_BlipEffect(...)
        end
    elseif p28 == "CreateSound" then
        if p27:IsRendered() then
            p27:_CreateSound(...)
        end
    elseif p28 == "Died" then
        p27._is_dead = true
        p27.Died:Fire()
    else
        v_u_5.ReplicateFromServer(p27, p28, ...)
    end
end
function v_u_16.Destroy(p33)
    p33._destroyed = true
    for _, v34 in pairs(p33._connections) do
        v34:Disconnect()
    end
    p33._hitboxes = {}
    p33.Died:Destroy()
    p33.HealthChanged:Destroy()
    p33.BurnEffectPlaying:Destroy()
    if p33.Model then
        p33.Model:Destroy()
    end
    if p33._current_finisher then
        p33._current_finisher:Destroy()
        p33._current_finisher = nil
    end
    v_u_5.Destroy(p33)
end
function v_u_16._CreateSound(p35, p36, p37, p38, p39, p40)
    local v41 = p40 and 400 or nil
    local v42 = v_u_8:CreateSound(p36, p37 * (p40 and 2 or 1), p38, p35.RootPart, true, 15, v41, v41)
    if p39 and p39 ~= 1 then
        local v43 = Instance.new("PitchShiftSoundEffect")
        v43.Octave = p39
        v43.Parent = v42
    end
end
function v_u_16._UpdateInvincibilityVisual(p44)
    if p44:Get("IsInvincible") or not p44._invincibility_visual then
        if p44:Get("IsInvincible") and not p44._invincibility_visual then
            p44._invincibility_visual = v_u_10:Clone()
            p44._invincibility_visual.Parent = p44.RootPart
        end
    else
        p44._invincibility_visual:Destroy()
        p44._invincibility_visual = nil
    end
end
function v_u_16._PlayFinisher(p45, p46, p47, p48, p49)
    local v50 = p45.Humanoid or p45.RootPart
    if v50 and v50:IsDescendantOf(workspace) then
        if p45._current_finisher then
            p45._current_finisher:Destroy()
        end
        p45._current_finisher = require(v_u_15[p46]).new(v50, p47, p48)
        p45._current_finisher:SetSerial(p49)
        if v_u_4.IS_STUDIO then
            p45._current_finisher:PlayClient()
        else
            pcall(p45._current_finisher.PlayClient, p45._current_finisher)
        end
    else
        return
    end
end
function v_u_16._BlipEffect(p51, p52, p53)
    local v54 = (v_u_14:FindFirstChild(p53) or v_u_14.Default):Clone()
    v54.CFrame = p52 or p51.RootPart.CFrame
    v54.Parent = workspace
    v_u_6:AddItem(v54, 5)
    v_u_8:PlayParticles(v54)
    v_u_8:CreateSound("rbxassetid://123181974576488", 1, 1.5 + 0.2 * math.random(), p51.RootPart, true, 5)
end
function v_u_16._ThawFreezeEffect(p55)
    if p55._thaw_callback then
        pcall(p55._thaw_callback, p55)
        p55._thaw_callback = nil
    end
end
function v_u_16._FreezeEffect(p_u_56, p57, p_u_58)
    p_u_56:_ThawFreezeEffect()
    local v_u_59 = (v_u_12:FindFirstChild(p_u_58 or "Default") or v_u_12.Default):Clone()
    v_u_59.PrimaryPart = v_u_59.Primary
    for _, v60 in pairs(v_u_59:GetDescendants()) do
        if v60:IsA("BasePart") then
            v60.CanCollide = false
            v60.CanTouch = false
            v60.CanQuery = false
            v60.CanTouch = false
            v60.Massless = true
            v60.Anchored = false
            if v60 ~= v_u_59.PrimaryPart then
                local v61 = Instance.new("WeldConstraint")
                v61.Part0 = v_u_59.PrimaryPart
                v61.Part1 = v60
                v61.Parent = v_u_59.PrimaryPart
            end
        end
    end
    v_u_59:SetPrimaryPartCFrame(p_u_56.RootPart.CFrame)
    v_u_59.Parent = workspace
    v_u_6:AddItem(v_u_59, p57 + 3)
    local v62 = Instance.new("WeldConstraint")
    v62.Part0 = p_u_56.RootPart
    v62.Part1 = v_u_59.PrimaryPart
    v62.Parent = v_u_59
    if p_u_58 == "Bubble" or p_u_58 == "Gum" then
        function p_u_56._thaw_callback()
            if v_u_59.PrimaryPart then
                v_u_6:AddItem(v_u_59, 2)
                local v63 = v_u_8
                local v64 = "rbxassetid://18763517194"
                local v65 = 1
                local v66 = 1
                local v67 = v_u_59.PrimaryPart
                if v67 then
                    v67 = v_u_59.PrimaryPart.Position
                end
                v63:CreateSound(v64, v65, v66, v67, true, 10)
                local v_u_68 = v_u_59.PrimaryPart.Size
                v_u_8:RenderstepForLoop(0, 100, 10, function(p69)
                    if not v_u_59.PrimaryPart then
                        return true
                    end
                    local v70 = 1 - (1 - p69 / 100) ^ 3
                    v_u_59.PrimaryPart.Transparency = 0.5 + 0.5 * v70
                    v_u_59.PrimaryPart.Size = v_u_68 * (1 + 2 * v70)
                end)
                v_u_59:Destroy()
            else
                v_u_59:Destroy()
            end
        end
    elseif p_u_58 == "Temporal" then
        v_u_8:CreateSound("rbxassetid://18431054727", 1.5, 1 + 0.1 * math.random(), v_u_59.PrimaryPart, true, 10)
        v_u_8:CreateSound("rbxassetid://8571334160", 0.75, 1.2, v_u_59.PrimaryPart, true, 10)
        function p_u_56._thaw_callback()
            if v_u_59.PrimaryPart then
                v_u_6:AddItem(v_u_59, 2)
                local v71 = v_u_8
                local v72 = "rbxassetid://8571436177"
                local v73 = 0.5
                local v74 = 2
                local v75 = v_u_59.PrimaryPart
                if v75 then
                    v75 = v_u_59.PrimaryPart.Position
                end
                v71:CreateSound(v72, v73, v74, v75, true, 10)
                local v_u_76 = v_u_59.PrimaryPart.Size
                v_u_8:RenderstepForLoop(0, 100, 5, function(p77)
                    if not v_u_59.PrimaryPart then
                        return true
                    end
                    local v78 = (p77 / 100) ^ 3
                    v_u_59.PrimaryPart.Transparency = v78
                    v_u_59.PrimaryPart.Size = v_u_76 * (1 + 2 * v78)
                end)
                v_u_59:Destroy()
            else
                v_u_59:Destroy()
            end
        end
    elseif p_u_58 == "Cocoon" then
        function p_u_56._thaw_callback()
            local v79 = v_u_59:FindFirstChild("Cocoon")
            if v79 then
                v79.Transparency = 1
                v_u_6:AddItem(v_u_59, 2)
                v_u_8:PlayParticles(v79)
            else
                v_u_59:Destroy()
            end
        end
    else
        if p_u_58 == "Wrapped" then
            v_u_8:CreateSound("rbxassetid://74885181688460", 0.875, 1 + 0.1 * math.random(), v_u_59.PrimaryPart, true, 5)
        else
            v_u_8:CreateSound("rbxassetid://18429138544", 0.75, 2 + 0.5 * math.random(), v_u_59.PrimaryPart, true, 10)
        end
        function p_u_56._thaw_callback()
            if v_u_59.PrimaryPart then
                v_u_6:AddItem(v_u_59, 2)
                local v80 = v_u_59.PrimaryPart.Position
                v_u_59.PrimaryPart:Destroy()
                for _, v81 in pairs(v_u_59:GetChildren()) do
                    if v81:IsA("BasePart") then
                        v81.Velocity = CFrame.new(v80, v81.Position).LookVector * (25 + 25 * math.random())
                        v81.RotVelocity = CFrame.Angles(math.random() * 3.141592653589793 * 2, math.random() * 3.141592653589793 * 2, math.random() * 3.141592653589793 * 2).LookVector * (10 + 10 * math.random())
                    end
                end
                if p_u_58 == "Wrapped" then
                    v_u_8:CreateSound("rbxassetid://121822631205080", 0.875, 1, v80, true, 10)
                else
                    v_u_8:CreateSound("rbxassetid://135970869546121", 0.875, 1, v80, true, 10)
                end
            else
                v_u_59:Destroy()
                return
            end
        end
    end
    local v_u_82 = p_u_56._thaw_callback
    task.delay(p57, function()
        if p_u_56._thaw_callback == v_u_82 then
            p_u_56._thaw_callback = nil
            v_u_82()
        end
    end)
end
function v_u_16._ExtinguishEffect(p83)
    for _, v84 in pairs(p83._burn_effect_particles) do
        v84:Destroy()
    end
    p83._burn_effect_particles = {}
    p83._burn_effect_finish = 0
    if p83._burn_effect_sound then
        p83._burn_effect_sound:Destroy()
        p83._burn_effect_sound = nil
    end
    local v85 = v_u_11:Clone()
    v85.CFrame = p83.RootPart.CFrame
    v85.Parent = workspace
    v_u_6:AddItem(v85, 10)
    v_u_8:CreateSound("rbxassetid://16812185839", 0.75, 1.3 + 0.2 * math.random(), v85, true)
    v_u_8:CreateSound("rbxassetid://16812389263", 0.75, 1.3 + 0.2 * math.random(), v85, true)
    v_u_8:PlayParticles(v85.Attachment)
end
function v_u_16._BurnEffect(p86, p87, p88)
    if p88 then
        p88 = p86:FromEnum(p88)
    end
    local v89 = tick() < p86._burn_effect_finish
    if p86._burn_effect_sound then
        p86._burn_effect_sound:Destroy()
    end
    p86._burn_effect_sound = v_u_8:CreateSound("rbxassetid://13702989275", 0.25, 0.9 + 0.2 * math.random(), p86.RootPart, true, 10)
    p86._burn_effect_finish = tick() + p87
    if not v89 then
        local v90 = p86.RootPart.Size.Y / 2
        local v91 = {}
        for _, v92 in pairs((v_u_13:FindFirstChild(p88 or "Default") or v_u_13.Default):GetChildren()) do
            if v92:IsA("ParticleEmitter") then
                local v93 = v92:Clone()
                v93.Parent = p86.RootPart
                table.insert(v91, v93)
                v_u_8:ScaleParticleEmitter(v93, v90)
            elseif v92:IsA("Light") then
                local v94 = v92:Clone()
                v94.Range = v94.Range * v90
                v94.Parent = p86.RootPart
                v_u_6:AddItem(v94, p87 + 4)
                table.insert(v91, v94)
            end
        end
        p86._burn_effect_particles = v91
        p86.BurnEffectPlaying:Fire()
        while tick() < p86._burn_effect_finish do
            wait(p86._burn_effect_finish - tick())
        end
        for _, v_u_95 in pairs(v91) do
            if v_u_95:IsA("ParticleEmitter") then
                v_u_95.Enabled = false
                v_u_6:AddItem(v_u_95, v_u_95.Lifetime.Max / v_u_95.TimeScale)
            elseif v_u_95:IsA("Light") then
                task.spawn(function()
                    local v_u_96 = v_u_95.Brightness
                    v_u_8:RenderstepForLoop(0, 100, 1, function(p97)
                        v_u_95.Brightness = v_u_96 * (1 - p97 / 100)
                    end)
                    v_u_95:Destroy()
                end)
            end
        end
        p86._burn_effect_sound = nil
    end
end
function v_u_16._HealEffect(p98)
    local v_u_99 = Instance.new("Highlight")
    v_u_99.FillColor = Color3.fromRGB(100, 255, 50)
    v_u_99.OutlineColor = Color3.fromRGB(179, 255, 153)
    v_u_99.DepthMode = Enum.HighlightDepthMode.Occluded
    v_u_99.Adornee = p98.Model
    v_u_99.Parent = p98.Model
    v_u_8:RenderstepForLoop(0, 100, 2, function(p100)
        local v101 = p100 / 100
        v_u_99.OutlineTransparency = v101
        v_u_99.FillTransparency = v101
    end)
    v_u_99:Destroy()
end
function v_u_16._HurtEffect(p102, p103)
    local v104 = p103[utf8.char(0)] or 0
    if math.abs(v104) < 0.001 then
        return
    else
        if p103[utf8.char(1)] and (not p102._is_hidden and p102._headshot_particles) then
            v_u_8:PlayParticles(p102._headshot_particles)
        end
        if #v_u_7:GetSmokeCloudsInSphere(p102.RootPart.Position) > 0 then
            return
        else
            p102._hurt_effect_hash = p102._hurt_effect_hash + 1
            local v105 = p102._hurt_effect_hash
            if p102.Model.Parent then
                p102._model_original_parent_hurt_effect = p102._model_original_parent_hurt_effect or p102.Model.Parent
                p102.Model.Parent = workspace.HurtEffect
                workspace.HurtEffect:SetAttribute("PlayHurtEffect", workspace.HurtEffect:GetAttribute("PlayHurtEffect") + 1)
                wait(1)
                if p102._hurt_effect_hash == v105 and p102.Model.Parent then
                    p102.Model.Parent = p102._model_original_parent_hurt_effect
                    p102._model_original_parent_hurt_effect = nil
                end
            else
                return
            end
        end
    end
end
function v_u_16._PotentialHitboxAdded(p_u_106, p_u_107)
    if p_u_107:IsA("BasePart") then
        local function v110()
            if v_u_2:HasTag(p_u_107, "EntityHitbox") and not table.find(p_u_106._hitboxes, p_u_107) then
                local v108 = p_u_106._hitboxes
                local v109 = p_u_107
                table.insert(v108, v109)
            end
        end
        p_u_107:GetAttributeChangedSignal("EntityHitboxUpdate"):Connect(v110)
        if v_u_2:HasTag(p_u_107, "EntityHitbox") and not table.find(p_u_106._hitboxes, p_u_107) then
            local v111 = p_u_106._hitboxes
            table.insert(v111, p_u_107)
        end
    end
end
function v_u_16._Setup(p_u_112)
    if p_u_112.Model then
        p_u_112.Model.DescendantAdded:Connect(function(p113)
            p_u_112:_PotentialHitboxAdded(p113)
        end)
        for _, v114 in pairs(p_u_112.Model:GetDescendants()) do
            p_u_112:_PotentialHitboxAdded(v114)
        end
    end
end
function v_u_16._Init(p_u_115)
    p_u_115.Died:Connect(function()
        p_u_115.HealthChanged:Fire()
    end)
    p_u_115:GetDataChangedSignal("IsInvincible"):Connect(function()
        p_u_115:_UpdateInvincibilityVisual()
    end)
    p_u_115:_Setup()
    p_u_115:_UpdateInvincibilityVisual()
end
return v_u_16