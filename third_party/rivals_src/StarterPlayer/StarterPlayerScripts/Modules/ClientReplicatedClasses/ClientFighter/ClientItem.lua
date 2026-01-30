local v_u_1 = game:GetService("ReplicatedStorage")
game:GetService("CollectionService")
game:GetService("UserInputService")
local v_u_2 = game:GetService("TweenService")
local v_u_3 = game:GetService("RunService")
game:GetService("GuiService")
local v_u_4 = game:GetService("Players")
require(v_u_1.Modules.CONSTANTS)
local v_u_5 = require(v_u_1.Modules.QuaternionSpring)
local v_u_6 = require(v_u_1.Modules.ReplicatedClass)
local v_u_7 = require(v_u_1.Modules.BetterDebris)
local v_u_8 = require(v_u_1.Modules.InputLibrary)
local v_u_9 = require(v_u_1.Modules.SoundLibrary)
local v_u_10 = require(v_u_1.Modules.EnumLibrary)
local v_u_11 = require(v_u_1.Modules.ItemLibrary)
local v_u_12 = require(v_u_1.Modules.GameplayUtility)
require(v_u_1.Modules.TestLibrary)
local v_u_13 = require(v_u_1.Modules.Quaternion)
local v_u_14 = require(v_u_1.Modules.Utility)
require(v_u_1.Modules.Spring)
local v_u_15 = require(v_u_1.Modules.Signal)
local v_u_16 = require(v_u_4.LocalPlayer.PlayerScripts.Controllers.GameComponentsController)
local v_u_17 = require(v_u_4.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
local v_u_18 = require(v_u_4.LocalPlayer.PlayerScripts.Controllers.FunctionsController)
local v_u_19 = require(v_u_4.LocalPlayer.PlayerScripts.Controllers.ControlsController)
local v_u_20 = require(v_u_4.LocalPlayer.PlayerScripts.Controllers.CameraController)
local v_u_21 = require(v_u_4.LocalPlayer.PlayerScripts.Controllers.EntityController)
local v_u_22 = require(v_u_4.LocalPlayer.PlayerScripts.Controllers.DebugController.DebugState)
local v_u_23 = require(v_u_4.LocalPlayer.PlayerScripts.Modules.CameraShaker)
local v_u_24 = require(script:WaitForChild("ClientViewModel"))
local v_u_25 = require(script:WaitForChild("ItemInterface"))
local v_u_26 = v_u_4.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild("ImpactMarkerSlash")
local v_u_27 = v_u_4.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild("ImpactMarkerBullet")
local v_u_28 = v_u_4.LocalPlayer.PlayerScripts.Modules:WaitForChild("ItemInterfaces")
local v_u_29 = v_u_4.LocalPlayer.PlayerScripts.Modules:WaitForChild("ViewModels")
local v_u_30 = TweenInfo.new(0.25, Enum.EasingStyle.Cubic, Enum.EasingDirection.In)
local v_u_31 = setmetatable({}, v_u_6)
v_u_31.__index = v_u_31
function v_u_31.new(p32, p33)
    local v34 = v_u_6.new(p32)
    local v35 = v_u_31
    local v36 = setmetatable(v34, v35)
    v36.StopSprinting = v_u_15.new()
    v36.AttemptToSprintAgain = v_u_15.new()
    v36.InterfaceAdded = v_u_15.new()
    v36.InterfaceRemoved = v_u_15.new()
    v36.EquippedChanged = v_u_15.new()
    v36.ToggleOffMobileInputButton = v_u_15.new()
    v36.ClientFighter = p33
    v36.Name = v36:Get("Name")
    v36.Info = v_u_11.Items[v36.Name]
    v36.ViewModel = v36:_CreateViewModel(p32.ViewModel)
    v36.ItemInterface = nil
    v36.IsEquipped = false
    v36.SprintingDisabled = nil
    v36.SlidingDisabled = nil
    v36.Data.FOVOffset = 0
    v36.Data.ItemIndex = -1
    v36._destroyed = false
    v36._connections = {}
    v36._aim_assist_connections = {}
    v36._inspect_cooldown = 0
    v36._sounds = {}
    v36._hitmarker_queue = {}
    v36._is_playing_hitmarker_queue = false
    v36._impact_markers = {}
    v36._preloaded_sounds = {}
    v36._equip_hash = 0
    v36._equip_cooldown = tick() + v36.Info.EquipCooldown
    v36:_Init()
    return v36
end
function v_u_31.IsRendered(p37)
    local v38 = p37.ClientFighter:IsRendered()
    if v38 then
        v38 = not p37.ClientFighter:Get("IsHiddenByEmotes")
    end
    return v38
end
function v_u_31.IsEquipping(p39)
    return tick() < p39._equip_cooldown
end
function v_u_31.CanQuickAttack(_)
    return false
end
function v_u_31.GetAutoShootReactionTime(_)
    return 0
end
function v_u_31.GetAutoShootReach(_)
    return 500
end
function v_u_31.StartInspecting(p40, p41, p42)
    if p41 or tick() >= p40._inspect_cooldown then
        p40._inspect_cooldown = tick() + 0.25
        local v43, v44 = p40.ViewModel:Inspect(p42)
        return v43, "StartInspecting", v44
    end
end
function v_u_31.IsActive(p45)
    return p45.ClientFighter:IsItemActive(p45)
end
function v_u_31.GetAimSpeed(p46)
    return p46.Info.AimSpeed or 1
end
function v_u_31.GetWrap(p47)
    local v48 = p47.ViewModel
    if v48 then
        v48 = p47.ViewModel:GetWrap()
    end
    return v48
end
function v_u_31.GetViewModelDetails(p49)
    return p49.ViewModel and {
        ["ViewModelName"] = p49.ViewModel.Name,
        ["Wrap"] = p49.ViewModel:Get("Wrap"),
        ["Charm"] = p49.ViewModel:Get("Charm")
    } or nil
end
function v_u_31.CreateSound(p_u_50, p51, p52, p53, p54, p55, p56, p57, p58, p59)
    if not p_u_50:Get("IsHiddenByEmotes") then
        local v60 = p_u_50:IsActive()
        local v61 = v60 and p52 and p52 or p52 * 0.5
        local v62 = v60 and script
        if not v62 then
            if p_u_50.ClientFighter.Entity then
                v62 = p_u_50.ClientFighter.Entity.RootPart or nil
            else
                v62 = nil
            end
        end
        local v_u_63 = v_u_14:CreateSound(p51, v61, p53, v62, p54, p55, p56, p57, p58, p59)
        local v64 = p_u_50._sounds
        table.insert(v64, v_u_63)
        v_u_63.Destroying:Connect(function()
            local v65 = table.find(p_u_50._sounds, v_u_63)
            if v65 then
                table.remove(p_u_50._sounds, v65)
            end
        end)
        return v_u_63
    end
end
function v_u_31.CreateSpectatorSound(p66, ...)
    if p66.ClientFighter:Get("IsSpectating") then
        return p66:CreateSound(...)
    end
end
function v_u_31.Equip(p_u_67)
    local v68 = p_u_67:Get("QuickAttackQueued")
    local v69 = p_u_67:Get("SkipEquipAnimation")
    local v70 = v68 or v69
    p_u_67.IsEquipped = true
    p_u_67._equip_hash = p_u_67._equip_hash + 1
    p_u_67._equip_cooldown = tick() + (v70 and 0 or p_u_67.Info.EquipCooldown)
    p_u_67.EquippedChanged:Fire(p_u_67.IsEquipped)
    if v69 then
        p_u_67:SetReplicate("SkipEquipAnimation", nil)
    end
    p_u_67:ClearSounds()
    p_u_67.ViewModel:Equip(v70)
    if p_u_67.ItemInterface then
        p_u_67.ItemInterface:Equip()
    end
    if v68 and p_u_67.ClientFighter.IsLocalPlayer then
        task.defer(function()
            if not p_u_67:QuickAttackInputs() then
                v_u_1.Remotes.Replication.Fighter.CancelQuickAttack:FireServer()
            end
        end)
    end
end
function v_u_31.Unequip(p71)
    p71.IsEquipped = false
    p71._equip_hash = p71._equip_hash + 1
    p71.EquippedChanged:Fire(p71.IsEquipped)
    p71.ViewModel:Unequip()
    if p71.ItemInterface then
        p71.ItemInterface:Unequip()
    end
    p71:ClearSounds()
    p71:_FinishAimAssist()
    p71:FinishAllInputs()
end
function v_u_31.Input(p72, p73)
    if not p72[p73] then
        return false
    end
    local v74 = typeof(p73) == "string"
    assert(v74, "Argument 1 invalid, expected a string")
    if p72.ClientFighter.Player ~= v_u_4.LocalPlayer or not p72.IsEquipped and string.sub(p73, 1, 5) == "Start" then
        return false
    end
    local v75 = p72._equip_hash
    local v76 = false
    local v77
    if p73 == "StartAiming" then
        v77 = p72.Name == "Revolver"
    else
        v77 = false
    end
    local v78 = v77 and p72.Info.MaxAmmo or (p73 == "StartShooting" and (p72.Info.ShootBurst or 1) or 1)
    local v79 = v77 and p72.Info.QuickShotCooldown or (p72.Info.ShootBurstCooldown or 0)
    for _ = 1, v78 do
        if v75 ~= p72._equip_hash then
            break
        end
        local v80 = { p72[p73](p72) }
        local v81 = table.remove(v80, 1)
        local v82 = table.remove(v80, 1)
        if v81 then
            local v83 = v_u_10:ToEnum(v82) or v82
            local v84 = {}
            v76 = true
            for v85, v86 in pairs(v80) do
                v84[utf8.char(v85)] = v86
            end
            v_u_1.Remotes.Replication.Fighter.UseItem:FireServer(p72:Get("ObjectID"), v83, v84, nil)
            wait(v79)
        end
    end
    return v76
end
function v_u_31.QuickAttackInputs(p87)
    local v88 = v_u_19.CurrentControls == "Touch" and p87.Info.QuickAttackInputsEasy or p87.Info.QuickAttackInputs
    if not v88 then
        return false
    end
    for _, v89 in pairs(v88) do
        if not p87:Input(v89) then
            return false
        end
        wait(0.05)
    end
    return true
end
function v_u_31.FinishAllInputs(p90)
    for _, v91 in pairs(v_u_8.ItemInputs) do
        p90:Input(v_u_8.Inputs[v91].FinishName)
    end
end
function v_u_31.QuickAttackFailed(p92)
    if p92.ClientFighter.FighterInterface then
        p92.ClientFighter.FighterInterface.Hotbar:QuickAttackFailedEffect(p92)
    end
end
function v_u_31.GenerateInterface(p93)
    if not p93.ItemInterface then
        p93.ItemInterface = (v_u_28:FindFirstChild(p93.Name) and require(v_u_28[p93.Name]) or v_u_25).new(p93)
        p93.InterfaceAdded:Fire(p93.ItemInterface)
    end
end
function v_u_31.ClearInterface(p94)
    if not p94.ClientFighter.IsLocalPlayer then
        local v95 = p94.ItemInterface
        if v95 then
            p94.ItemInterface = nil
            v95:Destroy()
            p94.InterfaceRemoved:Fire(v95)
        end
    end
end
function v_u_31.ClearSounds(p96, p97)
    for v98 = #p96._sounds, 1, -1 do
        local v99 = p96._sounds[v98]
        if p97 or not v99:GetAttribute("DontClearSound") then
            v99:Destroy()
        end
    end
    p96._sounds = {}
end
function v_u_31.Update(p100, p101, p102, p103)
    if p100.ViewModel then
        p100.ViewModel:Update(p101, p102, p103)
    end
    if p100.ItemInterface then
        p100.ItemInterface:Update(p101, p102, p103)
    end
end
function v_u_31.ReplicateFromServer(p104, p105, ...)
    if v_u_8.ItemInputTypeToName[p105] == nil then
        if p105 == "HitEffect" then
            if p104:IsRendered() then
                if #p104._hitmarker_queue > 5 then
                    return
                else
                    local v106 = ...
                    if v106.Damage ~= 0 then
                        local v107 = p104._hitmarker_queue
                        table.insert(v107, v106)
                        p104:_PlayHitmarkerQueue()
                    end
                end
            else
                return
            end
        end
        if p105 == "ExplosionEffect" then
            if p104:IsRendered() then
                p104:_ExplosionEffect(...)
            end
        end
        if p105 == "ExtinguishEffect" then
            if p104:IsRendered() then
                local v108, v109 = ...
                local v110 = v_u_16.Components.FireHitboxes:Extinguish(v109)
                v_u_18:FireAsync(p104:ToEnum("ExtinguishEffect"), CFrame.new(v110 or v108))
            end
        end
        v_u_6.ReplicateFromServer(p104, p105, ...)
    else
        if not p104:IsRendered() then
            return
        end
        if p104.ClientFighter.Player ~= v_u_4.LocalPlayer and (p104[p105] and (p104.IsEquipped or string.sub(p105, 1, 5) ~= "Start")) then
            p104[p105](p104, true, ...)
            return
        end
    end
end
function v_u_31.Destroy(p111)
    p111._destroyed = true
    for _, v112 in pairs(p111._connections) do
        v112:Disconnect()
    end
    for _, v113 in pairs(p111._preloaded_sounds) do
        v113:Destroy()
    end
    p111._hitmarker_queue = {}
    p111._equip_hash = p111._equip_hash + 1
    p111:ClearSounds(true)
    p111:_FinishAimAssist()
    p111.ViewModel:Destroy()
    if p111.ItemInterface then
        p111.ItemInterface:Destroy()
    end
    p111.StopSprinting:Destroy()
    p111.AttemptToSprintAgain:Destroy()
    p111.InterfaceAdded:Destroy()
    p111.InterfaceRemoved:Destroy()
    p111.EquippedChanged:Destroy()
    p111.ToggleOffMobileInputButton:Destroy()
    v_u_6.Destroy(p111)
end
function v_u_31._VerifyAimAssist(p114)
    if not p114:_CanUseAimAssist() then
        p114:_FinishAimAssist()
    end
end
function v_u_31._CanUseAimAssist(p115)
    if p115.ClientFighter.IsLocalPlayer and not p115.ClientFighter:Get("IsHiddenByCutscene") then
        return (v_u_19.CurrentControls == "Touch" or v_u_19.CurrentControls == "Gamepad") and true or (p115.ClientFighter:Get("CheaterMode") or v_u_22:Get("AreHandicapsEnabled"))
    else
        return false
    end
end
function v_u_31._StartAimAssist(p_u_116)
    p_u_116:_FinishAimAssist()
    if p_u_116:_CanUseAimAssist() then
        local v117
        if p_u_116.ClientFighter:Get("CheaterMode") then
            v117 = 100
        else
            local v118 = v_u_17:Get("Settings Aim Assist Strength")
            local v119 = p_u_116.ClientFighter:Get("AimAssistRestriction") or (1 / 0)
            v117 = math.min(v118, v119)
        end
        if v117 > 0 then
            local v_u_120 = p_u_116.ClientFighter:GetEntityLookupParams()
            local v_u_121 = p_u_116.ClientFighter:GetRaycastWhitelist()
            local v_u_122 = nil
            local v_u_123 = v_u_5.new(v_u_13.fromCFrame(CFrame.identity), 1, v117 * 10)
            local v124 = p_u_116._aim_assist_connections
            local v125 = v_u_20.RotationDeltaApplied
            local function v127(p126)
                v_u_123.Position = v_u_13.fromCFrame(v_u_123.Position:ToCFrame().Rotation * v_u_20:GetRotationCFrame(p126))
            end
            table.insert(v124, v125:Connect(v127))
            local v128 = p_u_116._aim_assist_connections
            local v129 = v_u_3.RenderStepped
            local function v142(_)
                local v130 = v_u_122
                v_u_122 = nil
                if v_u_20:GetGamepadRotationInput().Magnitude > 0.001 then
                    return
                end
                if v_u_4.LocalPlayer.PlayerGui:FindFirstChild("FlashbangGui") then
                    return
                end
                local v131 = v_u_21:GetScreenPoints(v_u_120, true)
                local v132 = p_u_116.ClientFighter:GetMouseLocation()
                local v133 = {}
                for v134, v135 in pairs(v131) do
                    if v_u_14:AngleBetweenVectors(workspace.CurrentCamera.CFrame.LookVector, v134.RootPart.Position - workspace.CurrentCamera.CFrame.Position) <= 0.2617993877991494 and not v_u_12:GetSmokeCloudBetweenPoints(workspace.CurrentCamera.CFrame.Position, v134.RootPart.Position) then
                        local v136 = {
                            ["Entity"] = v134
                        }
                        local v137 = (v132.X - v135.X) ^ 2 + (v132.Y - v135.Y) ^ 2
                        v136.Distance = math.sqrt(v137)
                        table.insert(v133, v136)
                    end
                end
                table.sort(v133, function(p138, p139)
                    return p138.Distance < p139.Distance
                end)
                local v140 = nil
                for _, v141 in pairs(v133) do
                    if not v_u_14:Raycast(workspace.CurrentCamera.CFrame.Position, v141.Entity.RootPart.Position, (workspace.CurrentCamera.CFrame.Position - v141.Entity.RootPart.Position).Magnitude, v_u_121, Enum.RaycastFilterType.Include).Instance then
                        v140 = v141
                        break
                    end
                end
                if v140 then
                    v_u_122 = v140.Entity
                    if v140.Entity ~= v130 then
                        v_u_123.Position = v_u_13.fromCFrame(workspace.CurrentCamera.CFrame.Rotation)
                    end
                    v_u_123.Target = v_u_13.fromCFrame(CFrame.new(workspace.CurrentCamera.CFrame.Position, v140.Entity.RootPart.Position).Rotation)
                    v_u_20:MimicRotation(CFrame.new(workspace.CurrentCamera.CFrame.Position) * v_u_123.Position:ToCFrame().Rotation)
                end
            end
            table.insert(v128, v129:Connect(v142))
        end
    else
        return
    end
end
function v_u_31._FinishAimAssist(p143)
    for _, v144 in pairs(p143._aim_assist_connections) do
        v144:Disconnect()
    end
    p143._aim_assist_connections = {}
end
function v_u_31._ExplosionEffect(p145, ...)
    if p145.ViewModel.ExplosionEffect then
        p145.ViewModel:ExplosionEffect(...)
    else
        v_u_18:FireAsync(p145:ToEnum("ExplosionEffect"), ...)
    end
end
function v_u_31._AddImpactMarker(p_u_146, p_u_147, p_u_148, p149)
    v_u_7:AddItem(p_u_147, p_u_148 + 5)
    local v150 = p_u_146._impact_markers
    table.insert(v150, 1, p_u_147)
    task.spawn(function()
        local v_u_151 = p_u_147.Decal
        wait(p_u_148)
        local _ = v_u_151.Transparency
        v_u_14:RenderstepForLoop(0, 100, 4, function(p152)
            v_u_151.Transparency = v_u_151.Transparency + (1 - v_u_151.Transparency) * (p152 / 100)
        end)
        p_u_147:Destroy()
        local v153 = table.find(p_u_146._impact_markers, p_u_147)
        if v153 then
            table.remove(p_u_146._impact_markers, v153)
        end
    end)
    local v154 = table.remove(p_u_146._impact_markers, p149 + 1)
    if v154 then
        v154:Destroy()
    end
end
function v_u_31._ImpactMarkerSlash(p_u_155, p156, p157, p_u_158)
    if p_u_158.Instance and (p_u_158.Instance:IsDescendantOf(workspace) and (p_u_158.Instance.Anchored and not (v_u_12:IsEntity(p_u_158.Instance) or p_u_158.Instance:HasTag("TrowelBrick")))) then
        if p156 >= (v_u_14:DecodeCFrame(p157[utf8.char(0)]).Position - p_u_158.Position).Magnitude then
            task.delay(0.1, function()
                if p_u_158.Instance and p_u_158.Instance:IsDescendantOf(workspace) then
                    local v159 = v_u_26:Clone()
                    v159.Size = v159.Size * (0.875 + 0.25 * math.random())
                    v159.CFrame = CFrame.new(p_u_158.Position, p_u_158.Position + p_u_158.Normal) * CFrame.Angles(0, 0, math.random() * 3.141592653589793 * 2)
                    v159.Parent = p_u_158.Instance
                    p_u_155:_AddImpactMarker(v159, 6, 5)
                    p_u_155:CreateSound("rbxassetid://17046228481", 0.5, 1.25 + 0.25 * math.random(), true, 2)
                end
            end)
        end
    else
        return
    end
end
function v_u_31._ImpactMarker(p160, p161, p162)
    local v163 = p161 or {}
    v163.Normal = v163.Normal or nil
    v163.Position = v163.Position or nil
    v163.Part = v163.Part or nil
    local v164 = p162 or {}
    v164.NoTween = v164.NoTween or nil
    v164.Color = v164.Color or nil
    local v165 = v163.Part and Color3.new(v163.Part.Color.R / 2, v163.Part.Color.G / 2, v163.Part.Color.B / 2) or Color3.new()
    local v166 = v_u_27:Clone()
    v166.Particles.Color = ColorSequence.new(v165)
    v166.Decal.Color3 = v164.Color or Color3.fromRGB(255, 177, 128)
    v166.Decal.Transparency = 0
    v166.Size = v166.Size * (0.875 + 0.25 * math.random())
    v166.CFrame = CFrame.new(v163.Position, v163.Position + v163.Normal) * CFrame.Angles(0, 0, math.random() * 3.141592653589793 * 2)
    v166.Parent = v163.Part or workspace
    p160:_AddImpactMarker(v166, 6, 20)
    if not v164.NoTween then
        v_u_2:Create(v166.Decal, v_u_30, {
            ["Color3"] = v165,
            ["Transparency"] = 0.5
        }):Play()
    end
end
function v_u_31._ImpactMarkers(p167, p168)
    for _, v169 in pairs(p168) do
        if v169.Position and v169.Normal then
            if p167.Info.ShootExplosionRadius and p167.Info.ShootExplosionRadius > 0 then
                p167:_ExplosionEffect(v169.Position, p167.Info.ShootExplosionRadius)
            elseif v169.Instance and (v169.Instance.Anchored and not v_u_12:IsEntity(v169.Instance)) then
                p167:_ImpactMarker({
                    ["Position"] = v169.Position,
                    ["Normal"] = v169.Normal,
                    ["Part"] = v169.Instance
                })
            end
        end
    end
end
function v_u_31._PlayHitmarkerQueue(p170)
    if not p170._is_playing_hitmarker_queue then
        p170._is_playing_hitmarker_queue = true
        while #p170._hitmarker_queue > 0 do
            local v171 = #p170._hitmarker_queue
            local v172 = math.max(0.2, v171)
            local v173 = table.remove(p170._hitmarker_queue, 1)
            if p170.ItemInterface then
                p170.ItemInterface:DamageEffect(v173, v172)
            end
            p170.ViewModel:PlayHitAnimation(v173[utf8.char(1)])
            wait(0.04)
        end
        p170._is_playing_hitmarker_queue = false
    end
end
function v_u_31._Shake(p174, p175)
    if p174.ClientFighter:Get("IsSpectating") then
        local v176 = typeof(p175) == "string"
        assert(v176, "Argument 1 invalid, expected a string")
        v_u_20:Shake(v_u_23.Presets[p175])
    end
end
function v_u_31._ShakeOnce(p177, ...)
    if p177.ClientFighter:Get("IsSpectating") then
        v_u_20:ShakeOnce(...)
    end
end
function v_u_31._Recoil(p178, p179)
    local v180 = (p178.Info.ShootRecoil or 1) * (p179 or 1)
    local v181 = p178.ViewModel
    local v182 = (math.random() - 0.5) * v180
    local v183 = (math.random() - 0.5) * v180
    local v184 = math.sqrt(v180) * 5
    v181:ApplyRecoil(Vector3.new(v182, v183, v184) * 0.04)
    local v185 = v180 ^ 1.2
    local v186 = 10 / (1 + (v180 - 1) / 4)
    local v187 = math.log(v180)
    p178:_ShakeOnce(v185, v186, 0.05, math.max(1, v187) * 0.4, Vector3.new(0, 0, 0), Vector3.new(1, 1, 2))
end
function v_u_31._CreateViewModel(p188, p189)
    local v190 = v_u_29:FindFirstChild(p189[p188:ToEnum("Data")][p188:ToEnum("Name")], true)
    local v191 = v_u_29:FindFirstChild(p188.Name, true)
    return (v190 and require(v190) or (v191 and require(v191) or v_u_24)).new(p189, p188)
end
function v_u_31._EntityAdded(p_u_192, p193)
    local v194 = p_u_192._connections
    local v195 = p193.Model.ChildAdded
    table.insert(v194, v195:Connect(function()
        p_u_192.ViewModel:SetArmsData(p_u_192.ClientFighter:GetArmsData())
    end))
    p_u_192.ViewModel:SetArmsData(p_u_192.ClientFighter:GetArmsData())
end
function v_u_31._Setup(p196)
    if p196.ClientFighter.IsLocalPlayer and v_u_9.ItemSounds[p196.Name] then
        v_u_9:PreloadSounds(v_u_9.ItemSounds[p196.Name], p196._preloaded_sounds)
    end
end
function v_u_31._Init(p_u_197)
    p_u_197.InterfaceAdded:Connect(function(p198)
        if p_u_197.IsEquipped then
            p198:Equip()
        end
    end)
    local v199 = p_u_197._connections
    local v200 = p_u_197.ClientFighter.EntityAdded
    table.insert(v199, v200:Connect(function(p201)
        p_u_197:_EntityAdded(p201)
    end))
    local v202 = p_u_197._connections
    local v203 = p_u_197.ClientFighter:GetDataChangedSignal("CheaterMode")
    table.insert(v202, v203:Connect(function(_)
        p_u_197:_VerifyAimAssist()
    end))
    local v204 = p_u_197._connections
    local v205 = p_u_197.ClientFighter:GetDataChangedSignal("IsHiddenByCutscene")
    table.insert(v204, v205:Connect(function(_)
        p_u_197:_VerifyAimAssist()
    end))
    local v206 = p_u_197._connections
    local v207 = v_u_19.ControlsChanged
    table.insert(v206, v207:Connect(function()
        p_u_197:_VerifyAimAssist()
    end))
    if p_u_197.ClientFighter.Entity then
        task.spawn(p_u_197._EntityAdded, p_u_197, p_u_197.ClientFighter.Entity)
    end
    p_u_197:_Setup()
end
return v_u_31