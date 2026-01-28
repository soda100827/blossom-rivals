local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("UserInputService")
local v_u_3 = game:GetService("ContentProvider")
local v_u_4 = game:GetService("TweenService")
local v_u_5 = game:GetService("HttpService")
local v_u_6 = game:GetService("RunService")
local v7 = game:GetService("Players")
local v_u_8 = require(v1.Modules.BetterDebris)
local v_u_9 = require(v1.Modules.SoundLibrary)
local v_u_10 = require(v1.Modules.Utility)
local v_u_11 = require(v7.LocalPlayer.PlayerScripts.Controllers.CameraController)
local v_u_12 = require(v7.LocalPlayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientDuel.ClientMap)
local v_u_13 = require(v7.LocalPlayer.PlayerScripts.Modules.StaticModel.StaticViewModel)
local v_u_14 = v7.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild("ChickenTrojanExplosionEffect")
local v_u_15 = v7.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("ZombieTowerLadderGui")
local v_u_16 = {
    "rbxassetid://98587858115094",
    "rbxassetid://72483809453170",
    "rbxassetid://129922197154277",
    "rbxassetid://113975047764762",
    "rbxassetid://121368500414901"
}
local v_u_17 = {
    "rbxassetid://116380542394210",
    "rbxassetid://125379277208360",
    "rbxassetid://96610433230092",
    "rbxassetid://122643453923681",
    "rbxassetid://94468135009167",
    "rbxassetid://133107467882960",
    "rbxassetid://122210005572726",
    "rbxassetid://102260065267741"
}
local v_u_18 = {
    { 0, 24 },
    { 9.97, 24 },
    { 10.53, 17 },
    { 10.87, 17 },
    { 11.62, 30 },
    { 11.83, 30 },
    { 12.55, 17 },
    { 13.03, 30 },
    { 16.52, 30 },
    { 17.53, 10 },
    { 19.12, 30, true },
    { 22.9, 50 },
    { 23.4, 20 },
    { 24.58, 50 },
    { 26.02, 35 }
}
local v_u_19 = setmetatable({}, v_u_12)
v_u_19.__index = v_u_19
function v_u_19.new(...)
    local v20 = v_u_12.new(...)
    local v21 = v_u_19
    local v22 = setmetatable(v20, v21)
    v22._floors_folder = v22.Model:WaitForChild("Floors")
    v22._cutscene_hash = 0
    v22._cutscene_renderstep_id = nil
    v22._cutscene_boss_animation = Instance.new("Animation")
    v22._cutscene_camera_animation = Instance.new("Animation")
    v22._cutscene_player_animations = {}
    v22._cutscene_animation_tracks = {}
    v22._cutscene_cleanup = {}
    v22._cutscene_threads = {}
    v22._cutscene_hidden_duelers = {}
    v22._preloaded_sounds = v_u_9:PreloadSounds(v_u_16)
    v22._spectating_thread = nil
    v22._flashing_red_enemies_connection = nil
    v22._active_enemy_humanoids = {}
    v22._ladder_guide_bbg = v_u_15:Clone()
    v22:_Init()
    return v22
end
function v_u_19.GetScoreboardDisplay(p23)
    local v24 = p23:_GetCurrentFloor()
    return "Zombie Tower" .. (v24 and "   \226\128\162   Floor " .. v24 or "")
end
function v_u_19.ReplicateFromServer(p25, p26, ...)
    if p26 == "ChickenTrojanEffect" then
        if p25:IsRendered() then
            p25:_ChickenTrojan(...)
        end
    elseif p26 == "GiantChombieCutscene" then
        if p25:IsRendered() then
            p25:_PlayCutscene(...)
        end
    elseif p26 == "FinishGiantChombieCutscene" then
        if p25:IsRendered() then
            p25:_StopCutscene()
        end
    else
        v_u_12.ReplicateFromServer(p25, ...)
        return
    end
end
function v_u_19.Destroy(p27)
    for _, v28 in pairs(p27._preloaded_sounds) do
        v28:Destroy()
    end
    if p27._spectating_thread then
        task.cancel(p27._spectating_thread)
        p27._spectating_thread = nil
    end
    if p27._flashing_red_enemies_connection then
        p27._flashing_red_enemies_connection:Disconnect()
        p27._flashing_red_enemies_connection = nil
    end
    p27:_StopCutscene()
    v_u_12.Destroy(p27)
end
function v_u_19._UpdateSpectating(p_u_29)
    if p_u_29._flashing_red_enemies_connection then
        p_u_29._flashing_red_enemies_connection:Disconnect()
        p_u_29._flashing_red_enemies_connection = nil
    end
    if not p_u_29._destroyed and p_u_29.ClientDuel:Get("IsSpectating") then
        p_u_29._flashing_red_enemies_connection = v_u_6.RenderStepped:Connect(function()
            local v30 = 3.141592653589793 * tick()
            local v31 = math.sin(v30)
            local v32 = math.max(0, v31)
            for v33, v34 in pairs(p_u_29._active_enemy_humanoids) do
                if tick() >= v34.StartFlashingRed then
                    if not v34.Highlight then
                        v34.Highlight = Instance.new("Highlight")
                        v34.Highlight.FillColor = Color3.fromRGB(255, 0, 0)
                        v34.Highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
                        v34.Highlight.Adornee = v33.Parent
                        v34.Highlight.Name = "FlashingRed"
                        v34.Highlight.Parent = v33
                    end
                    v34.Highlight.OutlineTransparency = v32 * 1 + 0
                    v34.Highlight.FillTransparency = v32 * 0.125 + 0.875
                end
            end
        end)
    end
end
function v_u_19._FloorAdded(p_u_35, p36)
    local v37 = p36:WaitForChild("MobGroups")
    local function v_u_40(p_u_38)
        local v_u_39 = {
            ["StartFlashingRed"] = 0,
            ["Highlight"] = nil
        }
        p_u_38.HealthChanged:Connect(function()
            v_u_39.StartFlashingRed = tick() + 60
            if v_u_39.Highlight then
                v_u_39.Highlight:Destroy()
                v_u_39.Highlight = nil
            end
        end)
        v_u_39.StartFlashingRed = tick() + 60
        if v_u_39.Highlight then
            v_u_39.Highlight:Destroy()
            v_u_39.Highlight = nil
        end
        p_u_35._active_enemy_humanoids[p_u_38] = v_u_39
        p_u_38.Destroying:Connect(function()
            p_u_35._active_enemy_humanoids[p_u_38] = nil
        end)
    end
    local function v_u_44(p_u_41)
        local v_u_42 = false
        local function v43()
            if v_u_42 then
                return
            elseif p_u_41.Value then
                v_u_42 = true
                task.spawn(v_u_40, p_u_41.Value)
            end
        end
        p_u_41:GetPropertyChangedSignal("Value"):Connect(v43)
        if not v_u_42 and p_u_41.Value then
            v_u_42 = true
            task.spawn(v_u_40, p_u_41.Value)
        end
    end
    local function v48(p45)
        local v46 = p45:WaitForChild("EntityHumanoidObjectValues", 3)
        if v46 then
            v46.ChildAdded:Connect(v_u_44)
            for _, v47 in pairs(v46:GetChildren()) do
                task.spawn(v_u_44, v47)
            end
        end
    end
    v37.ChildAdded:Connect(v48)
    for _, v49 in pairs(v37:GetChildren()) do
        task.spawn(v48, v49)
    end
    local v50 = p36.Name
    if (tonumber(v50) or 0) > 2 then
        task.delay(1, p_u_35.CreateSound, p_u_35, "rbxassetid://1843115730", 2, 1, p36:WaitForChild("Important"):WaitForChild("Entrance"), true, 10, 400, 400)
    end
end
function v_u_19._GetCurrentFloor(p51)
    for _, v52 in pairs(p51._floors_folder:GetChildren()) do
        local v53 = v52:FindFirstChild("Important")
        if v53 then
            v53 = v52.Important:FindFirstChild("Volume")
        end
        if v53 and v_u_10:IsWithinPart(v53, workspace.CurrentCamera.CFrame.Position) then
            local v54 = v52.Name
            return tonumber(v54)
        end
    end
end
function v_u_19._ChickenTrojan(p55, p56, p57, p58)
    local v59 = tick() + p57
    while tick() < v59 do
        local v60 = v_u_14:Clone()
        local v61 = CFrame.new(p56)
        local v62 = math.random() - 0.5
        local v63 = math.random() - 0.5
        local v64 = math.random() - 0.5
        v60.CFrame = v61 + Vector3.new(v62, v63, v64) * 12
        v60.Parent = workspace
        v_u_8:AddItem(v60, 5)
        v_u_10:ScaleParticleEmitter(v60, 0.5 + 0.75 * math.random())
        v_u_10:PlayParticles(v60)
        p55:CreateSound("rbxassetid://97884024654711", 0.875 + 0.25 * math.random(), 1 + 0.25 * math.random(), v60, true, 5)
        wait(p58 or 0.2)
    end
end
function v_u_19._LoadAnimation(p65, p66, p67, p68)
    if p66 then
        local v69, v70 = pcall(p66.LoadAnimation, p66, p67)
        if v69 then
            v70:Play(0)
            local v71 = p65._cutscene_animation_tracks
            table.insert(v71, v70)
            local v72 = p65._cutscene_threads
            local v73 = task.spawn
            table.insert(v72, v73(p68, v70))
        else
            warn("Animation " .. p67.AnimationId .. " failed to animate, error:", v70)
        end
    else
        return
    end
end
function v_u_19._StopCutscene(p74)
    p74._cutscene_hash = p74._cutscene_hash + 1
    for _, v75 in pairs(p74._cutscene_animation_tracks) do
        v75:Stop(0)
        v75:Destroy()
    end
    for _, v76 in pairs(p74._cutscene_cleanup) do
        v76:Destroy()
    end
    for _, v77 in pairs(p74._cutscene_threads) do
        task.cancel(v77)
    end
    for v78 in pairs(p74._cutscene_hidden_duelers) do
        v78:SetReplicate("IsHiddenByCutscene", nil)
    end
    p74._cutscene_animation_tracks = {}
    p74._cutscene_cleanup = {}
    p74._cutscene_threads = {}
    if p74._cutscene_renderstep_id then
        v_u_6:UnbindFromRenderStep(p74._cutscene_renderstep_id)
        p74._cutscene_renderstep_id = nil
    end
end
function v_u_19._PlayCutscene(p_u_79, p80, p_u_81, p82)
    p_u_79:_StopCutscene()
    local v83 = p_u_81:WaitForChild("CameraRig"):WaitForChild("AnimationController")
    p_u_79._cutscene_renderstep_id = "GiantChombie" .. v_u_5:GenerateGUID(false)
    p_u_79._cutscene_hash = p_u_79._cutscene_hash + 1
    local v_u_84 = p_u_79._cutscene_hash
    local v_u_85 = v_u_18[1][2]
    p_u_79:_LoadAnimation(p80, p_u_79._cutscene_boss_animation, function(_)
        task.delay(23.1, v_u_10.PlayParticles, v_u_10, p_u_81:WaitForChild("SlamParticles"))
        wait(1.25)
        p_u_79:CreateSound("rbxassetid://72483809453170", 0.35, 0.675, script, true, 10)
        wait(3.2)
        p_u_79:CreateSound("rbxassetid://72483809453170", 0.6, 0.7, script, true, 10)
        wait(2.15)
        p_u_79:CreateSound("rbxassetid://72483809453170", 0.65, 0.725, script, true, 10)
        wait(1.4)
        p_u_79:CreateSound("rbxassetid://72483809453170", 0.7, 0.75, script, true, 10)
        wait(1.5)
        p_u_79:CreateSound("rbxassetid://72483809453170", 0.75, 0.775, script, true, 10)
        wait(3.45)
        p_u_79:CreateSound("rbxassetid://72483809453170", 1.5, 0.8, script, true, 10)
        wait(2.3)
        p_u_79:CreateSound("rbxassetid://72483809453170", 0.3, 0.75, script, true, 10)
        wait(2)
        p_u_79:CreateSound("rbxassetid://72483809453170", 0.25, 1, script, true, 10)
        wait(3.85)
        p_u_79:CreateSound("rbxassetid://98587858115094", 1, 1, script, true, 10)
        wait(2)
        p_u_79:CreateSound("rbxassetid://72483809453170", 1.25 + 0.25 * math.random(), 0.9 + 0.2 * math.random(), script, true, 10)
        p_u_79:CreateSound("rbxassetid://129922197154277", 1.25 + 0.25 * math.random(), 0.9 + 0.2 * math.random(), script, true, 10)
        p_u_79:CreateSound("rbxassetid://113975047764762", 1.25 + 0.25 * math.random(), 0.9 + 0.2 * math.random(), script, true, 10)
        wait(1.8)
        p_u_79:CreateSound("rbxassetid://121368500414901", 1.5, 0.875, script, true, 10)
    end)
    p_u_79:_LoadAnimation(v83, p_u_79._cutscene_camera_animation, function(_)
        local v86 = 0
        for v87, v88 in pairs(v_u_18) do
            local v89 = v_u_18
            local v90 = v87 - 1
            local v91 = v89[math.max(1, v90)][2]
            local _, v92, v93 = table.unpack(v88)
            local v94 = v88[1] - v86
            if v93 then
                v86 = v86 + wait(v94)
                v_u_85 = v92
            else
                local v95 = tick()
                while tick() < v95 + v94 do
                    local v96
                    if v94 == 0 then
                        v96 = v92
                    else
                        v96 = v91 + (v92 - v91) * v_u_4:GetValue((tick() - v95) / v94, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
                    end
                    v_u_85 = v96
                    v86 = v86 + v_u_6.RenderStepped:Wait()
                    if p_u_79._cutscene_hash ~= v_u_84 then
                        return
                    end
                end
            end
        end
    end)
    local v97 = v83.Parent.HumanoidRootPart.CFrame
    local v_u_98 = v_u_85
    local v99 = {}
    for _, v100 in pairs(p_u_79.ClientDuel.Duelers) do
        if v100.ClientFighter then
            v100.ClientFighter:SetReplicate("IsHiddenByCutscene", true)
            p_u_79._cutscene_hidden_duelers[v100.ClientFighter] = true
            if v100.ClientFighter:IsAlive() then
                table.insert(v99, v100)
                if #v99 >= #v_u_17 then
                    break
                end
            end
        end
    end
    table.sort(v99, function(p101, p102)
        return p101.Player.UserId < p102.Player.UserId
    end)
    local v_u_103 = {}
    for v_u_104, v105 in pairs(v99) do
        local v_u_106 = v105:GetCharacterModelForCutscene()
        v_u_106.Name = "CutscenePlayer" .. v_u_104
        v_u_106:SetPrimaryPartCFrame(v97)
        v_u_106.Parent = v83.Parent.Parent
        local v107 = p_u_79._cutscene_cleanup
        table.insert(v107, v_u_106)
        local v108 = v105.ClientFighter.EquippedItem
        if v108 then
            v108 = v105.ClientFighter.EquippedItem:GetViewModelDetails()
        end
        local v109
        if v108 then
            v109 = v_u_13.new(v108.ViewModelName)
        else
            v109 = v108
        end
        if v109 and v109:HasGripAttachment() then
            v109:DeleteAnimationContextSubModels()
            v109:SetWrap(v108.Wrap)
            v109:SetCharm(v108.Charm)
            v109:ScaleTo(v_u_104 == 1 and 1.5 or 1.25)
            v109:InitializeGrip()
            v109:SetParent(v_u_106)
            local v110 = p_u_79._cutscene_cleanup
            table.insert(v110, v109)
            v_u_103[v109] = v_u_106
        elseif v109 then
            v109:Destroy()
        end
        local v113, v114 = pcall(function()
            local v111 = v_u_106.Humanoid:LoadAnimation(p_u_79._cutscene_player_animations[v_u_104])
            v111:Play(0)
            local v112 = p_u_79._cutscene_animation_tracks
            table.insert(v112, v111)
        end)
        if not v113 then
            warn("Player " .. v_u_104 .. " failed to animate, error:", v114)
            v_u_106.Parent = nil
        end
    end
    local v_u_115 = v83.Parent:FindFirstChild("Cam")
    v_u_6:BindToRenderStep(p_u_79._cutscene_renderstep_id, v_u_11:GetRenderstepPriority() + 1, function(_)
        if v_u_115 and p_u_79.ClientDuel:Get("IsSpectating") then
            v_u_2.MouseIconEnabled = true
            v_u_2.MouseBehavior = Enum.MouseBehavior.Default
            workspace.CurrentCamera.FieldOfView = v_u_98
            workspace.CurrentCamera.CFrame = v_u_115.CFrame
            for v116, v117 in pairs(v_u_103) do
                v116:GripPivotTo(v117)
            end
        end
    end)
    wait(p82)
    p_u_79:_StopCutscene()
end
function v_u_19._UpdateLadderGuide(_) end
function v_u_19._UpdateLightingChange(p118)
    local v119 = false
    for _, v120 in pairs(p118.Model.BossFight.LightingParts:GetChildren()) do
        v119 = v119 or v_u_10:IsWithinPart(v120, workspace.CurrentCamera.CFrame.Position)
    end
    local v121 = v119 and "Zombie Tower - FinalFloor" or nil
    if v121 ~= p118:Get("LightingProfileOverride") then
        p118:SetReplicate("LightingProfileOverride", v121)
    end
end
function v_u_19._SetupLightingChange(p_u_122)
    if p_u_122._spectating_thread then
        task.cancel(p_u_122._spectating_thread)
        p_u_122._spectating_thread = nil
    end
    if p_u_122.ClientDuel:Get("IsSpectating") then
        p_u_122._spectating_thread = task.spawn(function()
            while true do
                p_u_122:_UpdateLightingChange()
                p_u_122:_UpdateLadderGuide()
                wait(1)
            end
        end)
    end
end
function v_u_19._Setup(p123)
    p123._cutscene_boss_animation.AnimationId = "rbxassetid://80790358034810"
    p123._cutscene_camera_animation.AnimationId = "rbxassetid://85660296117721"
    local v124 = { p123._cutscene_boss_animation, p123._cutscene_camera_animation }
    for _, v125 in pairs(v_u_17) do
        local v126 = Instance.new("Animation")
        v126.AnimationId = v125
        local v127 = p123._cutscene_player_animations
        table.insert(v127, v126)
        table.insert(v124, v126)
    end
    task.spawn(pcall, v_u_3.PreloadAsync, v_u_3, v124)
end
function v_u_19._Init(p_u_128)
    p_u_128._floors_folder.ChildAdded:Connect(function(p129)
        p_u_128:_FloorAdded(p129)
    end)
    local v130 = p_u_128._connections
    local v131 = p_u_128.ClientDuel:GetDataChangedSignal("IsSpectating")
    table.insert(v130, v131:Connect(function()
        task.spawn(p_u_128._SetupLightingChange, p_u_128)
        p_u_128:_UpdateSpectating()
    end))
    for _, v132 in pairs(p_u_128._floors_folder:GetChildren()) do
        task.spawn(p_u_128._FloorAdded, p_u_128, v132)
    end
    p_u_128:_Setup()
    p_u_128:_UpdateSpectating()
    task.spawn(p_u_128._SetupLightingChange, p_u_128)
    p_u_128.ClientDuel:SetReplicate("DuelMusic", "ZombieTower")
end
return v_u_19