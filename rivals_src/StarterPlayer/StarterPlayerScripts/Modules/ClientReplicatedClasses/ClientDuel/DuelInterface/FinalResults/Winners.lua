local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("UserInputService")
local v_u_3 = game:GetService("TweenService")
local v_u_4 = game:GetService("HttpService")
local v_u_5 = game:GetService("RunService")
local v6 = game:GetService("Players")
local v_u_7 = require(v1.Modules.CONSTANTS)
local v_u_8 = require(v1.Modules.DuelLibrary)
local v_u_9 = require(v1.Modules.Utility)
local v_u_10 = require(v1.Modules.Signal)
local v_u_11 = require(v6.LocalPlayer.PlayerScripts.Controllers.ComplianceController)
local v_u_12 = require(v6.LocalPlayer.PlayerScripts.Controllers.PreloadController)
local v_u_13 = require(v6.LocalPlayer.PlayerScripts.Controllers.CameraController)
local v_u_14 = require(v6.LocalPlayer.PlayerScripts.Modules.StaticModel.StaticViewModel)
local v_u_15 = require(v6.LocalPlayer.PlayerScripts.Modules.RankIcon)
local v_u_16 = v6.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild("FinalResultsCameraRig")
local v_u_17 = v6.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("FinalResultsPlayerSlot")
local v_u_18 = {
    ["ViewModelName"] = "Assault Rifle"
}
local v_u_19 = {}
v_u_19.__index = v_u_19
function v_u_19.new(p20)
    local v21 = v_u_19
    local v22 = setmetatable({}, v21)
    v22.Finished = v_u_10.new()
    v22.FinalResults = p20
    v22.TopFrame = v22.FinalResults.DuelInterface.Frame:WaitForChild("Top")
    v22.Frame = v22.FinalResults.Frame:WaitForChild("Winners")
    v22.PlayersFrame = v22.Frame:WaitForChild("Players")
    v22.TeamFrame = v22.Frame:WaitForChild("Team")
    v22.TeamText = v22.TeamFrame:WaitForChild("Team")
    v22.TeamShineFrame = v22.TeamFrame:WaitForChild("Shine"):WaitForChild("Frame")
    v22._destroyed = false
    v22._skipped = false
    v22._animation_cleanup = {}
    v22._static_viewmodels = {}
    v22._renderstep_id = nil
    v22._winning_dueler_ids = {}
    v22._displayed_duelers = {}
    v22._player_slots = {}
    v22._final_winning_animation_hash = 0
    v22._outro_sound = nil
    v22:_Init()
    return v22
end
function v_u_19.IsFinished(p23)
    return p23._skipped
end
function v_u_19.Skip(p24)
    p24._skipped = true
    p24.Finished:Fire()
end
function v_u_19.SetVisible(p_u_25, p26)
    p_u_25.Frame.Visible = p26
    task.spawn(p_u_25._PlayFinalWinningAnimation, p_u_25)
    if not p26 and (p_u_25._outro_sound and p_u_25._outro_sound.Volume >= 1.25) then
        task.spawn(v_u_9.RenderstepForLoop, v_u_9, 0, 100, 2, function(p27)
            local v28 = p27 / 100
            p_u_25._outro_sound.Volume = 1.25 + -0.75 * v28
        end)
    end
end
function v_u_19.Play(p_u_29, p30, p31, p32)
    p_u_29.TopFrame.Visible = false
    p_u_29._winning_dueler_ids = p31
    local v33 = Random.new(p30)
    local v34 = #p31 == 0 and "Tie" or (p_u_29.FinalResults.DuelInterface.ClientDuel.LocalDueler and (p_u_29.FinalResults.DuelInterface.ClientDuel.LocalDueler and table.find(p31, p_u_29.FinalResults.DuelInterface.ClientDuel.LocalDueler:Get("DuelerID")) and "Win" or "Lose") or "Win")
    for _, v35 in pairs({ p31, p32 }) do
        for _, v36 in pairs(v35) do
            for v37 in pairs(p_u_29.FinalResults.DuelInterface:GetLoggedClientDuelers()) do
                if v37:Get("DuelerID") == v36 then
                    local v38 = p_u_29._displayed_duelers
                    table.insert(v38, v37)
                    break
                end
            end
            if #p_u_29._displayed_duelers >= 5 then
                break
            end
        end
        if #p_u_29._displayed_duelers >= 5 then
            break
        end
    end
    local v39, v40 = p_u_29:_GetWinnersLocation()
    local v_u_41 = {}
    for v_u_42, v43 in pairs(p_u_29._displayed_duelers) do
        local v_u_44 = v43:GetCharacterModelForCutscene()
        v_u_44.Name = "Dueler" .. v_u_42
        v_u_44:SetPrimaryPartCFrame(v40)
        v_u_44.Parent = v39
        local v45 = p_u_29._animation_cleanup
        table.insert(v45, v_u_44)
        local v46 = v43:GetRandomPlayedViewModelDetails(v33) or v_u_18
        local v47 = v_u_14.new(v46.ViewModelName)
        if v47:HasGripAttachment() then
            v47:DeleteAnimationContextSubModels()
            v47:SetWrap(v46.Wrap)
            v47:SetCharm(v46.Charm)
            v47:ScaleTo(v_u_42 == 1 and 1.5 or 1.25)
            v47:InitializeGrip()
            v47:SetParent(v_u_44)
            p_u_29._static_viewmodels[v47] = v_u_44
        else
            v47:Destroy()
        end
        local v51, v52 = pcall(function()
            local v48 = v_u_44.Humanoid:LoadAnimation(v_u_12:GetPreloadedAnimation("FinalResultsPlayer" .. v_u_42))
            v48:Play(0)
            local v49 = v_u_41
            table.insert(v49, v48)
            local v50 = p_u_29._animation_cleanup
            table.insert(v50, v48)
        end)
        if not v51 then
            warn("Player " .. v_u_42 .. " failed to animate, error:", v52)
            v_u_44.Parent = nil
        end
    end
    local v_u_53 = v_u_16:Clone()
    v_u_53:PivotTo(v40)
    v_u_53.Parent = p_u_29.FinalResults.DuelInterface.ClientDuel.Map.Model:FindFirstChild("Winners")
    local v_u_54 = nil
    local v57, v58 = pcall(function()
        v_u_54 = v_u_53.AnimationController:LoadAnimation(v_u_12:GetPreloadedAnimation("FinalResultsCamera"))
        v_u_54:Play(0)
        local v55 = p_u_29._animation_cleanup
        local v56 = v_u_54
        table.insert(v55, v56)
    end)
    local v_u_59 = 40
    local v_u_60 = false
    local function v_u_66(p61, _, p62, p63, p64)
        if not v_u_60 then
            local v65 = tick()
            while tick() < v65 + p61 do
                v_u_59 = 40 + 30 * v_u_3:GetValue((tick() - v65) / p61, p63, p64)
                v_u_5.RenderStepped:Wait()
                if v_u_60 then
                    return
                end
            end
            v_u_59 = p62
        end
    end
    if v57 then
        if v_u_54 then
            v_u_54:GetMarkerReachedSignal("Start Sine-Out 70"):Connect(function()
                v_u_66(0.9666666666666667, 40, 70, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
            end)
            v_u_54:GetMarkerReachedSignal("Start Quad-Out 120"):Connect(function()
                v_u_66(0.75, 70, 120, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            end)
        end
    else
        warn("Camera failed to animate, error:", v58)
    end
    p_u_29._renderstep_id = "FinalResults" .. v_u_4:GenerateGUID(false)
    v_u_5:BindToRenderStep(p_u_29._renderstep_id, v_u_13:GetRenderstepPriority() + 1, function(_)
        if p_u_29.FinalResults.DuelInterface.ClientDuel:Get("IsSpectating") then
            local v67 = CFrame.Angles
            local v68 = tick() * 0.23983 % 6.283185307179586
            local v69 = math.sin(v68) * 0.017453292519943295
            local v70 = tick() * 0.372721 % 6.283185307179586
            local v71 = math.sin(v70) * 0.017453292519943295
            local v72 = tick() * 0.43123 % 6.283185307179586
            local v73 = v67(v69, v71, math.sin(v72) * 0.017453292519943295)
            v_u_2.MouseIconEnabled = true
            v_u_2.MouseBehavior = Enum.MouseBehavior.Default
            workspace.CurrentCamera.FieldOfView = v_u_59
            workspace.CurrentCamera.CFrame = v_u_53.Cam.CFrame * v73
            for v74, v75 in pairs(p_u_29._static_viewmodels) do
                v74:GripPivotTo(v75)
            end
        end
    end)
    task.delay(12, function()
        if not p_u_29._destroyed then
            if v_u_54 then
                v_u_54:AdjustSpeed(0)
            end
            for _, v76 in pairs(v_u_41) do
                v76:AdjustSpeed(0)
            end
        end
    end)
    local v77 = p_u_29.FinalResults.DuelInterface:CreateSound("rbxassetid://18221897857", 0, 1, script, true, 60)
    if v77 then
        v77.Looped = true
    end
    local v78 = p_u_29.FinalResults.DuelInterface
    local v79
    if v34 == "Win" then
        v79 = math.random() < 0.5 and "rbxassetid://18239670056" or "rbxassetid://18221725850"
    else
        v79 = math.random() < 0.5 and "rbxassetid://18239670367" or "rbxassetid://18221726246"
    end
    p_u_29._outro_sound = v78:RawCreateSound(v79, 1.25, 1, script, true, 15, nil, nil, "Music")
    p_u_29:_WaitWhileNotSkipped(1)
    if p_u_29._destroyed then
        return
    end
    p_u_29:_WaitWhileNotSkipped(5)
    if p_u_29._destroyed then
        return
    end
    if not p_u_29:IsFinished() then
        p_u_29.FinalResults.DuelInterface:CreateSound("rbxassetid://18129776757", 1.25, 1, script, true, 15)
    end
    p_u_29:_WaitWhileNotSkipped(0.45)
    if p_u_29._destroyed then
        return
    end
    if not p_u_29:IsFinished() then
        p_u_29.FinalResults.DuelInterface:CreateSound("rbxassetid://18221897857", 1.25, 1, script, true, 15)
    end
    p_u_29:_WaitWhileNotSkipped(3.6)
    if p_u_29._destroyed then
        return
    end
    if p_u_29:IsFinished() then
        v_u_60 = true
        v_u_59 = 120
        if v_u_54 then
            v_u_54.TimePosition = 12
            v_u_54:AdjustSpeed(0)
        end
        for _, v80 in pairs(v_u_41) do
            v80.TimePosition = 12
            v80:AdjustSpeed(0)
        end
    end
    local v81 = p_u_29.FinalResults.DuelInterface.ClientDuel:Get("ScoresBehavior")
    local v82 = p_u_29.FinalResults.DuelInterface.ClientDuel:Get("ArcadeMode")
    local v83 = not v82 or v81 == "Teams"
    local v84 = not v82
    for v85, v86 in pairs(p_u_29._displayed_duelers) do
        if not p_u_29.FinalResults.DuelInterface.ClientDuel.IsRanked then
            local _ = v86.Player:GetAttribute("StatisticDuelsWinStreak") or 0
        end
        local v87 = not p_u_29.FinalResults.DuelInterface.ClientDuel.IsRanked and (v86.Player:GetAttribute("Level") or 0) or nil
        local v88 = v_u_8:GetTeamColor(v86:Get("TeamID"))
        local v89 = v_u_9:SanitizeName(v86.Player.Name)
        local v90 = v_u_17:Clone()
        local v91 = v90.Placement
        local v92
        if v82 then
            v92 = v81 == "Duelers"
        else
            v92 = v82
        end
        v91.Visible = v92
        v90.Placement.Title.Text = "#" .. v85
        local v93 = v90.MVP
        local v94
        if v85 == 1 and #p31 > 1 then
            v94 = not v90.Placement.Visible
        else
            v94 = false
        end
        v93.Visible = v94
        v90.Background.ImageColor3 = v88
        v90.Player.Username.Text = v86.Player.DisplayName == v89 and "" or "@" .. v89
        v90.Player.Text = v_u_11:GetName(v86.Player)
        v90.Player.Position = v90.Player.Username.Text == "" and UDim2.new(0.5, 0, 0.5, 0) or UDim2.new(0.5, 0, 0.4, 0)
        v90.Controls.Image = v_u_7.CONTROLS_IMAGES[v86.ClientFighter:Get("Controls")] or ""
        local v95 = v90.Level
        local v96
        if v87 then
            v96 = v87 > 0
        else
            v96 = v87
        end
        v95.Visible = v96
        v90.Level.Value.Text = v87 and v_u_9:PrettyNumber(v87) or ""
        v90.Performance.Eliminations.Value.Text = v_u_9:PrettyNumber(v86:Get("Eliminations"))
        v90.Performance.Deaths.Value.Text = v_u_9:PrettyNumber(v86:Get("Deaths"))
        v90.Performance.Assists.Value.Text = v_u_9:PrettyNumber(v86:Get("Assists"))
        v90.Performance.DamageDealt.Position = v84 and UDim2.new(0.333, 0, 3.5, 0) or UDim2.new(0.5, 0, 3.5, 0)
        v90.Performance.DamageDealt.Title.Text = v83 and "Damage Dealt" or "Points"
        local v97 = v90.Performance.DamageDealt.Value
        if not v83 then
            ::l105::
            v100 = v81 == "Duelers" and (v_u_9:PrettyNumber(p_u_29.FinalResults.DuelInterface.ClientDuel:Get("Scores")[v86:Get("DuelerID")] or 0) or "???") or "???"
            goto l106
        end
        local v98 = v_u_9
        local v99 = v86:Get("Damage") + 0.5
        local v100 = v98:PrettyNumber((math.floor(v99)))
        if not v100 then
            goto l105
        end
        ::l106::
        v97.Text = v100
        v90.Performance.DamageTaken.Visible = v84
        local v101 = v90.Performance.DamageTaken.Value
        local v102 = v_u_9
        local v103 = v86:Get("DamageTaken") + 0.5
        v101.Text = v102:PrettyNumber((math.floor(v103)))
        local v104 = p_u_29._player_slots
        table.insert(v104, v90)
        if p_u_29.FinalResults.DuelInterface.ClientDuel.IsRanked then
            local v105
            if v86.IsLocalPlayer then
                v105 = p_u_29.FinalResults.Summary:GetLocalPlayerPreviousELO()
            else
                v105 = v86.Player:GetAttribute("DisplayELO")
            end
            v_u_15.new(v105, v86.Player.UserId):SetParent(v90.Rank)
        end
        local v_u_106 = v90.Player
        local v_u_107 = v_u_106.Username
        local v_u_108 = v90.Controls
        local v_u_109 = v90.Streak
        local v_u_110 = v90.Level
        local v_u_111 = v90.Rank
        local function v115()
            local v112 = v_u_106.TextBounds.X
            local v113 = v_u_107.TextBounds.X
            local v114 = math.max(v112, v113)
            v_u_108.Position = UDim2.new(0.5, v114 / 2, 0.5, 0)
            v_u_109.Position = UDim2.new(0.5, -v114 / 2, 0.5, 0)
            v_u_110.Position = UDim2.new(0.5, -v114 / 2, 0.5, 0)
            v_u_111.Position = UDim2.new(0.5, -v114 / 2, 0.5, 0)
        end
        v_u_106:GetPropertyChangedSignal("TextBounds"):Connect(v115)
        v_u_107:GetPropertyChangedSignal("TextBounds"):Connect(v115)
        v_u_106.AncestryChanged:Connect(v115)
        v_u_107.AncestryChanged:Connect(v115)
        v115()
    end
    p_u_29:Skip()
end
function v_u_19.Destroy(p116)
    p116._destroyed = true
    p116._final_winning_animation_hash = p116._final_winning_animation_hash + 1
    for _, v117 in pairs(p116._animation_cleanup) do
        v117:Destroy()
    end
    for _, v118 in pairs(p116._static_viewmodels) do
        v118:Destroy()
    end
    if p116._renderstep_id then
        v_u_5:UnbindFromRenderStep(p116._renderstep_id)
        p116._renderstep_id = nil
    end
    p116.Finished:Destroy()
end
function v_u_19._PlayFinalWinningAnimation(p119)
    if p119:IsFinished() then
        p119._final_winning_animation_hash = p119._final_winning_animation_hash + 1
        local v120 = p119._final_winning_animation_hash
        local v121 = #p119._winning_dueler_ids > 0 and p119.FinalResults.DuelInterface.ClientDuel:Get("ScoresBehavior") == "Teams" and p119._displayed_duelers[1]
        if v121 then
            v121 = p119._displayed_duelers[1]:Get("TeamID")
        end
        local v122 = v_u_8:GetTeamColor(v121)
        p119.TeamFrame.Background.ImageColor3 = v122
        p119.TeamFrame.Visible = v121
        p119.TeamFrame.Position = UDim2.new(0.5, 0, 0.16, 40)
        p119.TeamFrame:TweenPosition(UDim2.new(0.5, 0, 0.125, 30), "Out", "Quint", 0.25, true)
        p119.TeamText.Text = v121 and v_u_8.TeamsByID[v121].TeamName or ""
        p119.TeamShineFrame.Position = UDim2.new(-0.5, 0, 0.5, 0)
        p119.TeamShineFrame:TweenPosition(UDim2.new(1.5, 0, 0.5, 0), Enum.EasingDirection.In, Enum.EasingStyle.Quart, 1, true)
        for v123, v124 in pairs(p119._player_slots) do
            if p119._final_winning_animation_hash ~= v120 then
                return
            end
            v124.Parent = p119.PlayersFrame:FindFirstChild(v123)
            v124.Size = UDim2.new(0.45, 0, 0.075, 0)
            v124.Position = UDim2.new(0.5, 0, 0.4, 0)
            v124:TweenSizeAndPosition(UDim2.new(0.75, 0, 0.125, 0), UDim2.new(0.5, 0, 0.5, 0), "Out", "Quint", 0.25 * v123, true)
            wait(0.125)
        end
    end
end
function v_u_19._GetWinnersLocation(p125)
    local v126 = p125.FinalResults.DuelInterface.ClientDuel.Map.Model:FindFirstChild("Winners")
    return v126, v126 and v126:FindFirstChild("Primary") and v126.Primary.CFrame or CFrame.identity
end
function v_u_19._WaitWhileNotSkipped(p127, p128)
    local v129 = tick() + p128
    while tick() < v129 and not p127:IsFinished() do
        v_u_5.RenderStepped:Wait()
    end
end
function v_u_19._Init(p_u_130)
    p_u_130.Finished:Connect(function()
        p_u_130:_PlayFinalWinningAnimation()
    end)
end
return v_u_19