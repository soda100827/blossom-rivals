local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.SeasonLibrary)
local v_u_4 = require(v1.Modules.Utility)
local v_u_5 = require(v_u_2.LocalPlayer.PlayerScripts.Modules.RankIcon)
local v_u_6 = require(v_u_2.LocalPlayer.PlayerScripts.Modules.ELOBar)
local v_u_7 = UDim2.new(0.8, 0, 0.8, 0)
local v_u_8 = UDim2.new(0.5, 0, 0.5, 0)
local v_u_9 = UDim2.new(0.5, 0, 0.5, 0)
local v_u_10 = UDim2.new(0.5, 0, 0.375, 0)
local v_u_11 = {}
v_u_11.__index = v_u_11
function v_u_11.new(p12)
    local v13 = v_u_11
    local v14 = setmetatable({}, v13)
    v14.FinalResults = p12
    v14.ELOBar = v_u_6.new()
    v14.Frame = v14.FinalResults.Frame:WaitForChild("Summary")
    v14.Container = v14.Frame:WaitForChild("Container")
    v14.CardFrame = v14.Container:WaitForChild("Card")
    v14.BarContainer = v14.CardFrame:WaitForChild("BarContainer")
    v14.RankFrame = v14.CardFrame:WaitForChild("Rank")
    v14.RankHeaderFrame = v14.RankFrame:WaitForChild("Header")
    v14.RankHeaderText = v14.RankHeaderFrame:WaitForChild("Title")
    v14.RankHeaderTextLeftIcon = v14.RankHeaderText:WaitForChild("Left")
    v14.RankHeaderTextRightIcon = v14.RankHeaderText:WaitForChild("Right")
    v14.RankHeaderBackground = v14.RankHeaderFrame:WaitForChild("Background")
    v14._last_rank_icon = nil
    v14._summary_details_hash = 0
    v14._summary_details = nil
    v14:_Init()
    return v14
end
function v_u_11.GetLocalPlayerPreviousELO(p15)
    if p15._summary_details then
        if p15._summary_details.SummaryType == "RankedELOChanged" then
            return p15._summary_details.PreviousELO
        else
            return nil
        end
    else
        return v_u_2.LocalPlayer:GetAttribute("DisplayELO")
    end
end
function v_u_11.HasDetailsReady(p16)
    return p16._summary_details ~= nil
end
function v_u_11.SetDetails(p17, p18)
    p17._summary_details = p18
    p17._summary_details_hash = p17._summary_details_hash + 1
end
function v_u_11.SetVisible(p19, p20)
    p19.Frame.Visible = p20
    p19._summary_details_hash = p19._summary_details_hash + 1
    if p20 then
        p19:DisplaySummaryDetails()
    end
end
function v_u_11.DisplaySummaryDetails(p_u_21)
    p_u_21._summary_details_hash = p_u_21._summary_details_hash + 1
    local v_u_22 = p_u_21._summary_details_hash
    p_u_21:_PlayCountingSound(0)
    p_u_21:_PlayPromoteSound(0)
    p_u_21:_PlayDemoteSound(0)
    p_u_21:_PlayShieldSound(0)
    p_u_21.BarContainer.Visible = false
    p_u_21.RankFrame.Size = UDim2.new(0, 0, 0, 0)
    p_u_21.RankFrame.Position = UDim2.new(0.5, 0, 1, 0)
    p_u_21.RankFrame:TweenSizeAndPosition(v_u_7, v_u_8, "Out", "Quint", 0.5, true)
    p_u_21.RankHeaderText.Text = ""
    p_u_21.RankHeaderTextLeftIcon.Visible = false
    p_u_21.RankHeaderTextRightIcon.Visible = false
    if p_u_21._summary_details.SummaryType == "RankedPlacementsProgress" then
        p_u_21:_CreateRankIcon(nil):SetParent(p_u_21.RankFrame)
        wait(0.5)
        if v_u_22 ~= p_u_21._summary_details_hash then
            return
        end
    elseif p_u_21._summary_details.SummaryType == "RankedPlacementsComplete" then
        local v_u_23 = p_u_21:_CreateRankIcon(nil)
        v_u_23:SetLabelFromELOEvent(nil, nil, 0)
        v_u_23:SetParent(p_u_21.RankFrame)
        wait(0.5)
        if v_u_22 ~= p_u_21._summary_details_hash then
            return
        end
        p_u_21:_PlayCountingSound()
        v_u_4:RenderstepForLoop(0, 100, 2, function(p24)
            if v_u_22 ~= p_u_21._summary_details_hash then
                return true
            end
            local v25 = p24 / 100
            local v26 = v_u_23
            local v27 = v_u_3.CurrentSeason.RankProfile.NumPlacementDuels * v25
            v26:SetLabelFromELOEvent(nil, nil, (math.floor(v27)))
        end)
        if v_u_22 ~= p_u_21._summary_details_hash then
            return
        end
        wait(1)
        if v_u_22 ~= p_u_21._summary_details_hash then
            return
        end
        p_u_21.RankHeaderText.Text = "Congratulations! You\'ve placed " .. v_u_3:GetRank(p_u_21._summary_details.PlacementELO, v_u_2.LocalPlayer.UserId)
        p_u_21:_PlayPromoteSound()
        p_u_21:_CreateRankIcon(p_u_21._summary_details.PlacementELO):SetParent(p_u_21.RankFrame)
        p_u_21.RankFrame.Size = v_u_7 + UDim2.new(0.4, 0, 0.4, 0)
        p_u_21.RankFrame:TweenSize(v_u_7, "Out", "Back", 0.25, true)
        wait(1)
        if v_u_22 ~= p_u_21._summary_details_hash then
            return
        end
    elseif p_u_21._summary_details.SummaryType == "RankedELOChanged" then
        local v_u_28 = p_u_21:_CreateRankIcon(p_u_21._summary_details.PreviousELO)
        v_u_28:SetParent(p_u_21.RankFrame)
        wait(0.5)
        if v_u_22 ~= p_u_21._summary_details_hash then
            return
        end
        p_u_21:_PlayCountingSound()
        local v29 = p_u_21._summary_details.CurrentELO - p_u_21._summary_details.PreviousELO
        local v_u_30 = p_u_21._summary_details.ELOSaved or v29
        v_u_4:RenderstepForLoop(0, 100, 2, function(p31)
            if v_u_22 ~= p_u_21._summary_details_hash then
                return true
            end
            local v32 = v_u_28
            local v33 = v_u_30 * (p31 / 100)
            v32:SetLabelFromELOEvent(math.floor(v33), p_u_21._summary_details.PreviousELO, v_u_3.CurrentSeason.RankProfile.NumPlacementDuels)
        end)
        if v_u_22 ~= p_u_21._summary_details_hash then
            return
        end
        wait(1)
        if v_u_22 ~= p_u_21._summary_details_hash then
            return
        end
        local v34 = v_u_3:GetRank(p_u_21._summary_details.PreviousELO, v_u_2.LocalPlayer.UserId)
        local v35 = v_u_3:GetRank(p_u_21._summary_details.CurrentELO, v_u_2.LocalPlayer.UserId)
        if p_u_21._summary_details.ELOSaved then
            v_u_28:SetLabelFromELOEvent(v29, p_u_21._summary_details.PreviousELO, v_u_3.CurrentSeason.RankProfile.NumPlacementDuels)
            p_u_21.RankFrame.Position = v_u_8 + UDim2.new(0, 0, 0.15, 0)
            p_u_21.RankFrame:TweenPosition(v_u_8, "Out", "Quint", 0.25, true)
            p_u_21.RankHeaderText.Text = string.format("Your ELO Shield saved you from <font color=\"rgb(255,50,50)\">%s ELO</font>", p_u_21._summary_details.ELOSaved)
            p_u_21.RankHeaderTextLeftIcon.Visible = true
            p_u_21.RankHeaderTextRightIcon.Visible = true
            p_u_21.RankHeaderTextLeftIcon.Image = "rbxassetid://118920750856778"
            p_u_21.RankHeaderTextRightIcon.Image = "rbxassetid://118920750856778"
            p_u_21:_PlayShieldSound()
            wait(1)
            if v_u_22 ~= p_u_21._summary_details_hash then
                return
            end
        elseif v34 ~= v35 then
            local v36 = p_u_21:_CreateRankIcon(p_u_21._summary_details.CurrentELO)
            v36:SetLabelFromELOEvent(v_u_30, p_u_21._summary_details.CurrentELO, v_u_3.CurrentSeason.RankProfile.NumPlacementDuels)
            v36:SetParent(p_u_21.RankFrame)
            p_u_21.RankFrame.Size = v_u_7 + UDim2.new(0.4, 0, 0.4, 0)
            p_u_21.RankFrame:TweenSize(v_u_7, "Out", "Back", 0.25, true)
            if p_u_21._summary_details.CurrentELO > p_u_21._summary_details.PreviousELO then
                p_u_21.RankHeaderText.Text = "Congratulations! You\'ve promoted to " .. v35
                p_u_21:_PlayPromoteSound()
            else
                p_u_21.RankHeaderText.Text = "You\'ve demoted to " .. v35
                p_u_21:_PlayDemoteSound()
            end
            wait(1)
            if v_u_22 ~= p_u_21._summary_details_hash then
                return
            end
        end
    else
        local v37 = p_u_21._summary_details.SummaryType
        assert(false, v37)
    end
    p_u_21.RankFrame:TweenSizeAndPosition(v_u_9, v_u_10, "Out", "Quint", 0.5, true)
    wait(0.1)
    if v_u_22 == p_u_21._summary_details_hash then
        p_u_21.BarContainer.Visible = true
        p_u_21.ELOBar:Update(true)
    end
end
function v_u_11.Destroy(p38)
    p38._summary_details_hash = p38._summary_details_hash + 1
    p38.ELOBar:Destroy()
end
function v_u_11._PlayCountingSound(p39, p40)
    p39.FinalResults.DuelInterface:CreateSound("rbxassetid://99054764924747", 1 * (p40 or 1), 1, script, true, 10)
end
function v_u_11._PlayPromoteSound(p41, p42)
    local v43 = p42 or 1
    p41.FinalResults.DuelInterface:CreateSound("rbxassetid://138975587469438", 1 * v43, 1, script, true, 10)
    task.delay(0.125, p41.FinalResults.DuelInterface.CreateSound, p41.FinalResults.DuelInterface, "rbxassetid://70643163489676", 1 * v43, 1, script, true, 10)
end
function v_u_11._PlayDemoteSound(p44, p45)
    local v46 = p45 or 1
    p44.FinalResults.DuelInterface:CreateSound("rbxassetid://70643163489676", 1 * v46, 0.75, script, true, 10)
    p44.FinalResults.DuelInterface:CreateSound("rbxassetid://91547731028928", 1 * v46, 1, script, true, 10)
end
function v_u_11._PlayShieldSound(p47, p48)
    local v49 = p48 or 1
    p47.FinalResults.DuelInterface:CreateSound("rbxassetid://132313563275913", 0.75 * v49, 2, script, true, 10)
    p47.FinalResults.DuelInterface:CreateSound("rbxassetid://128864122802098", 1 * v49, 1.5, script, true, 10)
end
function v_u_11._CreateRankIcon(p50, p51)
    if p50._last_rank_icon then
        p50._last_rank_icon:Destroy()
        p50._last_rank_icon = nil
    end
    p50._last_rank_icon = v_u_5.new(p51, v_u_2.LocalPlayer.UserId)
    return p50._last_rank_icon
end
function v_u_11._UpdateHeader(p52)
    local v53 = not (p52.RankHeaderTextLeftIcon.Visible or p52.RankHeaderTextRightIcon.Visible) and 0 or p52.RankHeaderTextLeftIcon.AbsoluteSize.X + p52.RankHeaderTextRightIcon.AbsoluteSize.X
    p52.RankHeaderBackground.Size = UDim2.new(0, p52.RankHeaderText.TextBounds.X + p52.RankHeaderText.TextBounds.Y * 1.5 + v53, 1, 0)
    p52.RankHeaderBackground.Visible = p52.RankHeaderText.TextBounds.X > 0
    p52.RankHeaderTextLeftIcon.Position = UDim2.new(0.5, -p52.RankHeaderText.TextBounds.X / 2, 0.5, 0)
    p52.RankHeaderTextRightIcon.Position = UDim2.new(0.5, p52.RankHeaderText.TextBounds.X / 2, 0.5, 0)
end
function v_u_11._Setup(p54)
    p54.ELOBar:SetParent(p54.BarContainer)
end
function v_u_11._Init(p_u_55)
    p_u_55.RankHeaderText:GetPropertyChangedSignal("TextBounds"):Connect(function()
        p_u_55:_UpdateHeader()
    end)
    p_u_55.RankHeaderTextLeftIcon:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        p_u_55:_UpdateHeader()
    end)
    p_u_55.RankHeaderTextLeftIcon:GetPropertyChangedSignal("Visible"):Connect(function()
        p_u_55:_UpdateHeader()
    end)
    p_u_55.RankHeaderTextRightIcon:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        p_u_55:_UpdateHeader()
    end)
    p_u_55.RankHeaderTextRightIcon:GetPropertyChangedSignal("Visible"):Connect(function()
        p_u_55:_UpdateHeader()
    end)
    p_u_55:_Setup()
    p_u_55:_UpdateHeader()
end
return v_u_11