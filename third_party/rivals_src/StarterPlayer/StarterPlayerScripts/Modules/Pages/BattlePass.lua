local v_u_1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("UserInputService")
local v_u_3 = game:GetService("TweenService")
local v4 = game:GetService("Players")
local v_u_5 = require(v_u_1.Modules.MonetizationLibrary)
local v_u_6 = require(v_u_1.Modules.CosmeticLibrary)
local v_u_7 = require(v_u_1.Modules.SeasonLibrary)
local v_u_8 = require(v_u_1.Modules.ItemLibrary)
local v_u_9 = require(v_u_1.Modules.Utility)
local v_u_10 = require(v4.LocalPlayer.PlayerScripts.Controllers:WaitForChild("MonetizationController"))
local v_u_11 = require(v4.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController"))
local v_u_12 = require(v4.LocalPlayer.PlayerScripts.Controllers:WaitForChild("SeasonController"))
local v_u_13 = require(v4.LocalPlayer.PlayerScripts.Modules:WaitForChild("WeaponStatusHandler"))
local v_u_14 = require(v4.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect"))
local v_u_15 = require(v4.LocalPlayer.PlayerScripts.Modules:WaitForChild("PromptSystem"))
local v_u_16 = require(v4.LocalPlayer.PlayerScripts.Modules:WaitForChild("BundleSlot"))
local v_u_17 = require(v4.LocalPlayer.PlayerScripts.Modules:WaitForChild("RewardSlot"))
local v_u_18 = require(v4.LocalPlayer.PlayerScripts.Modules:WaitForChild("Page"))
local v_u_19 = v4.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("BattlePassFooterSlot")
local v_u_20 = v4.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("BattlePassRewardSlot")
local v_u_21 = v4.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("BattlePassTrackSlot")
local v_u_22 = TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local v_u_23 = setmetatable({}, v_u_18)
v_u_23.__index = v_u_23
function v_u_23._new()
    local v24 = v_u_18.new(script.Name)
    local v25 = v_u_23
    local v26 = setmetatable(v24, v25)
    v26.CloseButton = v26.PageFrame:WaitForChild("TopRight"):WaitForChild("Close")
    v26.PromptsFrame = v26.PageFrame:WaitForChild("Prompts")
    v26.BackgroundFrame = v26.PageFrame:WaitForChild("Background")
    v26.List = v26.PageFrame:WaitForChild("List")
    v26.Container = v26.List:WaitForChild("Container")
    v26.Layout = v26.Container:WaitForChild("Layout")
    v26.RewardsFrame = v26.Container:WaitForChild("Rewards")
    v26.TracksFrame = v26.RewardsFrame:WaitForChild("Tracks")
    v26.FooterFrame = v26.TracksFrame:WaitForChild("Footer")
    v26.FooterBackground = v26.FooterFrame:WaitForChild("Background")
    v26.FooterSlotsFrame = v26.FooterFrame:WaitForChild("Slots")
    v26.FooterSlotsLayout = v26.FooterSlotsFrame:WaitForChild("Layout")
    v26.HeaderFrame = v26.TracksFrame:WaitForChild("Header")
    v26.HeaderContainer = v26.HeaderFrame:WaitForChild("Container")
    v26.HeaderLevelText = v26.HeaderContainer:WaitForChild("Value")
    v26.HeaderXPFrame = v26.HeaderContainer:WaitForChild("XP")
    v26.HeaderXPBarFrame = v26.HeaderXPFrame:WaitForChild("Bar")
    v26.HeaderNextLevelText = v26.HeaderXPBarFrame:WaitForChild("NextLevel")
    v26.HeaderXPBarContainer = v26.HeaderXPBarFrame:WaitForChild("Container")
    v26.HeaderXPBar = v26.HeaderXPBarContainer:WaitForChild("Bar")
    v26.HeaderBubbleFrame = v26.HeaderContainer:WaitForChild("Bubble")
    v26.HeaderBubbleArrow = v26.HeaderBubbleFrame:WaitForChild("Arrow")
    v26.HeaderBubbleTitle = v26.HeaderBubbleFrame:WaitForChild("Title")
    v26.HeaderBubbleBackground = v26.HeaderBubbleFrame:WaitForChild("Background")
    v26.NextButton = v26.HeaderContainer:WaitForChild("Next")
    v26.NextBackground = v26.NextButton:WaitForChild("Background")
    v26.NextIcon = v26.NextButton:WaitForChild("Icon")
    v26.PreviousButton = v26.HeaderContainer:WaitForChild("Previous")
    v26.PreviousBackground = v26.PreviousButton:WaitForChild("Background")
    v26.PreviousIcon = v26.PreviousButton:WaitForChild("Icon")
    v26.PreviewFrame = v26.Container:WaitForChild("Preview")
    v26.PreviewContainer = v26.PreviewFrame:WaitForChild("Container")
    v26.PreviewRewardContainer = v26.PreviewContainer:WaitForChild("RewardContainer")
    v26.PreviewDetailsFrame = v26.PreviewFrame:WaitForChild("Details")
    v26.PreviewDetailsClaimed = v26.PreviewDetailsFrame:WaitForChild("Claimed")
    v26.PreviewDetailsTitle = v26.PreviewDetailsFrame:WaitForChild("Title")
    v26.PreviewDetailsDescription = v26.PreviewDetailsFrame:WaitForChild("Description")
    v26.PreviewClaimFrame = v26.PreviewFrame:WaitForChild("Claim")
    v26.PreviewClaimButton = v26.PreviewClaimFrame:WaitForChild("Button")
    v26.PreviewUnlockFrame = v26.PreviewFrame:WaitForChild("Unlock")
    v26.PreviewUnlockContainer = v26.PreviewUnlockFrame:WaitForChild("Container")
    v26.PreviewUnlockDetailsFrame = v26.PreviewUnlockContainer:WaitForChild("Details")
    v26.PreviewUnlockTiersText = v26.PreviewUnlockDetailsFrame:WaitForChild("Tiers")
    v26.PreviewUnlockButton = v26.PreviewUnlockContainer:WaitForChild("Buy")
    v26.PreviewUnlockButtonTitle = v26.PreviewUnlockButton:WaitForChild("Title")
    v26.PreviewUnlockViewContentsButton = v26.PreviewUnlockContainer:WaitForChild("ViewContents")
    v26.BundlesFrame = v26.Container:WaitForChild("Bundles")
    v26.PrimeSeasonBundleFrame = v26.BundlesFrame:WaitForChild("primeseason_bundle")
    v26.PrimeSeasonBundleContainer = v26.PrimeSeasonBundleFrame:WaitForChild("Container")
    v26.ContrabandSeasonBundleFrame = v26.BundlesFrame:WaitForChild("contrabandseason_bundle")
    v26.ContrabandSeasonBundleContainer = v26.ContrabandSeasonBundleFrame:WaitForChild("Container")
    v26.EndingSoonFrame = v26.Container:WaitForChild("EndingSoon")
    v26.EndingSoonTitle = v26.EndingSoonFrame:WaitForChild("Title")
    v26.HidePartyDisplay = true
    v26.PromptSystem = v_u_15.new(v26.PromptsFrame)
    v26.PrimeSeasonBundleSlot = v_u_16.new(v26.PrimeSeasonBundleFrame, "primeseason_bundle")
    v26.ContrabandSeasonBundleSlot = v_u_16.new(v26.ContrabandSeasonBundleFrame, "contrabandseason_bundle")
    v26._current_page = 1
    v26._footer_slots = {}
    v26._track_slots = {}
    v26._xp_slots = {}
    v26._reward_slots = {}
    v26._preview_data = nil
    v26._scroll_delta = 0
    v26._refreshed_input_tags = false
    v26._completed_all_tasks_thread = nil
    v26:_Init()
    return v26
end
function v_u_23.GetLightingTintColor(_)
    return Color3.fromRGB(32, 32, 32)
end
function v_u_23.GetLightingContrast(_)
    return 4
end
function v_u_23.InspectBundle(p27, p28)
    local v29
    if p28 == p27.PrimeSeasonBundleSlot.Name then
        v29 = p27.PrimeSeasonBundleSlot
    elseif p28 == p27.ContrabandSeasonBundleSlot.Name then
        v29 = p27.ContrabandSeasonBundleSlot
    else
        v29 = nil
    end
    p27.PromptSystem:Open("InspectBundle", p28, v29)
end
function v_u_23.UnlockNow(p30)
    if p30._preview_data then
        local v31 = p30:_GetUnlockNowProductInfo(p30._preview_data.Tier, p30._preview_data.PassTrackNum)
        if v31 then
            v_u_10:PromptProductPurchase(v31.ProductID)
        end
    end
end
function v_u_23.Preview(p32, p33, p34)
    local v35 = v_u_7.CurrentSeason.BattlePassRewards[p33]
    if v35 then
        v35 = v_u_7.CurrentSeason.BattlePassRewards[p33][p34]
    end
    if p32._preview_data and p32._preview_data.RewardSlot then
        p32._preview_data.RewardSlot:Destroy()
        p32._preview_data.RewardSlot = nil
    end
    p32._preview_data = nil
    p32.PreviewDetailsTitle.Text = ""
    p32.PreviewDetailsDescription.Text = ""
    v_u_13:ClearStatusElements(p32.PreviewDetailsTitle)
    v_u_13:ClearStatusElements(p32.PreviewDetailsDescription)
    v_u_13:ClearStatusElements(p32.PreviewUnlockTiersText)
    v_u_3:Create(p32.BackgroundFrame, v_u_22, {
        ["BackgroundColor3"] = (v_u_8.StatusByPassTrackNum[p34] or v_u_8.Statuses.Standard).Color
    }):Play()
    v_u_3:Create(p32.List, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        ["CanvasPosition"] = Vector2.zero
    }):Play()
    if v35 and (p33 and p34) then
        local v36 = task.defer
        local v37 = p32._SetPage
        local v38 = p33 / 7
        v36(v37, p32, (math.ceil(v38)))
        p32._preview_data = {
            ["RewardData"] = v35,
            ["Tier"] = p33,
            ["PassTrackNum"] = p34,
            ["RewardSlot"] = nil
        }
        local v39 = v_u_11:Get("Seasons")[v_u_7.CurrentSeason.Name]
        if v39 then
            v39 = v39.BattlePass
        end
        local v40 = v39 and (v39.PassLevel or 0) or 0
        local v41 = v39 and (v39.MaxPassTrackNum or 0) or 0
        local v42
        if p33 <= v40 then
            v42 = p34 <= v41
        else
            v42 = false
        end
        local v43 = v39 and v39.RewardsClaimed[tostring(p33)]
        if v43 then
            v43 = v39.RewardsClaimed[tostring(p33)][tostring(p34)]
        end
        local v44 = p32:_GetUnlockNowProductInfo(p33, p34)
        local v45 = v_u_17.new(v35)
        v45:SetNameText("")
        v45:OnClick(function() end)
        v45:SetInteractable(false)
        v45:HideWeaponVisual()
        v45:UseHighResolutionImage()
        v45.Frame.Parent = p32.PreviewRewardContainer
        p32._preview_data.RewardSlot = v45
        p32.PreviewDetailsClaimed.Visible = v43
        p32.PreviewDetailsTitle.Text = v45:GetRewardBubbleTitle()
        p32.PreviewDetailsDescription.Text = v45:GetRewardBubbleDescription()
        if v_u_8.Items[v35.Name] then
            local v46 = v_u_8.Items[v35.Name].Status
            v_u_13:ApplyItemStatusToText(p32.PreviewDetailsTitle, v46)
            v_u_13:ApplyItemStatusToText(p32.PreviewDetailsDescription, v46)
        elseif v_u_8.Items[v35.Weapon] then
            local v47 = v_u_13
            local v48 = p32.PreviewDetailsDescription
            local v49 = v_u_8.Items[v35.Weapon]
            if v49 then
                v49 = v_u_8.Items[v35.Weapon].Status
            end
            v47:ApplyItemStatusToText(v48, v49)
        end
        local v50 = p32.PreviewClaimFrame
        if v42 then
            v42 = not v43
        end
        v50.Visible = v42
        local v51 = p32.PreviewUnlockFrame
        local v52
        if v44 then
            v52 = not v43
        else
            v52 = v44
        end
        v51.Visible = v52
        local v53 = p32.PreviewUnlockTiersText
        local v54
        if v44 and v44.BattlePassLevelIncrement then
            v54 = string.format("+%s Level%s", v_u_9:PrettyNumber(v44.BattlePassLevelIncrement), v44.BattlePassLevelIncrement == 1 and "" or "s")
        else
            v54 = not (v44 and (v44.BattlePassMaxPassTrackNum and v44.UnlockNowDisplayName)) and "" or v44.UnlockNowDisplayName
        end
        v53.Text = v54
        local v55 = p32.PreviewUnlockViewContentsButton
        local v56 = v_u_6.Rewards[v35.Name]
        if v56 then
            v56 = v_u_6.Rewards[v35.Name].Type == "Lootbox"
        end
        v55.Visible = v56
        if v44 then
            v_u_10:SetRobuxText(p32.PreviewUnlockButtonTitle, v44.ProductID, Enum.InfoType.Product)
            if v44.BattlePassMaxPassTrackNum and v44.UnlockNowWeaponStatusUIEffect then
                v_u_13:ApplyItemStatusToText(p32.PreviewUnlockTiersText, v44.UnlockNowWeaponStatusUIEffect)
            end
        end
        local v57 = v43 and 0.2 or 0
        p32.PreviewDetailsTitle.Position = UDim2.new(0.5 + v57, 0, 0.775, 0)
        p32.PreviewDetailsDescription.Position = UDim2.new(0.5 + v57, 0, 0.9, 0)
        v45.Frame.Position = UDim2.new(0.5, 0, 0.75, 0)
        p32.PreviewDetailsTitle:TweenPosition(UDim2.new(0.15 + v57, 0, 0.775, 0), "Out", "Quint", 0.5, true)
        p32.PreviewDetailsDescription:TweenPosition(UDim2.new(0.15 + v57, 0, 0.9, 0), "Out", "Quint", 0.625, true)
        v45.Frame:TweenPosition(UDim2.new(0.5, 0, 0.5, 0), "Out", "Quint", 0.375, true)
        p32.PreviewFrame.Visible = true
        p32.PreviewFrame:TweenSize(UDim2.new(1, 0, 0.3, 0), "Out", "Quint", 0.25, true)
    else
        p32.PreviewFrame.Visible = false
        p32.PreviewFrame.Size = UDim2.new(1, 0, 0, 0)
    end
end
function v_u_23.Open(p_u_58, ...)
    v_u_18.Open(p_u_58, ...)
    local v59 = p_u_58._open_connections
    local v60 = v_u_11:GetDataChangedSignal("Seasons")
    table.insert(v59, v60:Connect(function()
        p_u_58:_Update()
        if p_u_58._preview_data then
            p_u_58:Preview(p_u_58._preview_data.Tier, p_u_58._preview_data.PassTrackNum)
        end
    end))
    local v61 = p_u_58._open_connections
    local v62 = v_u_2.InputBegan
    table.insert(v61, v62:Connect(function(p63, p64)
        if p64 then
            return
        elseif p63.KeyCode == Enum.KeyCode.ButtonL1 then
            p_u_58:_SetPage(p_u_58._current_page - 1)
        elseif p63.KeyCode == Enum.KeyCode.ButtonR1 then
            p_u_58:_SetPage(p_u_58._current_page + 1)
        end
    end))
    local v65 = p_u_58._open_connections
    local v66 = v_u_2.InputChanged
    table.insert(v65, v66:Connect(function(_, _) end))
    local v67 = p_u_58._open_threads
    local v68 = task.spawn
    table.insert(v67, v68(function()
        while true do
            p_u_58:_UpdateEndingSoon()
            wait(1)
        end
    end))
    if not p_u_58._refreshed_input_tags then
        p_u_58._refreshed_input_tags = true
        for _, v69 in pairs({ p_u_58.NextButton, p_u_58.PreviousButton }) do
            local v70 = v69:WaitForChild("Inputs")
            v70.Parent = nil
            v70.Parent = v69
        end
    end
    p_u_58.PrimeSeasonBundleContainer.Position = UDim2.new(0.5, 0, 4, 0)
    p_u_58.ContrabandSeasonBundleContainer.Position = UDim2.new(0.5, 0, 4, 0)
    p_u_58.PrimeSeasonBundleContainer:TweenPosition(UDim2.new(0.5, 0, 0.5, 0), "Out", "Quint", 1, true)
    p_u_58.ContrabandSeasonBundleContainer:TweenPosition(UDim2.new(0.5, 0, 0.5, 0), "Out", "Quint", 1.5, true)
    p_u_58:Preview(nil)
    p_u_58:_SetPage(1)
    p_u_58:_Update()
end
function v_u_23.Close(p71, ...)
    p71:_Clear()
    v_u_18.Close(p71, ...)
end
function v_u_23._UpdateEndingSoon(p72)
    p72.EndingSoonFrame.Visible = v_u_12:GetTimeRemaining() ~= nil
    p72.EndingSoonTitle.Text = (v_u_12:GetCountdownText() or "") .. " \226\128\148 Complete the Season Pass and collect your rewards before they\'re gone forever!"
end
function v_u_23._UpdateVisuals(p73)
    local v74 = p73.HeaderXPBar.AbsolutePosition.X + p73.HeaderXPBar.AbsoluteSize.X - p73.HeaderBubbleFrame.AbsolutePosition.X
    local v75 = math.abs(v74)
    local v76 = p73.HeaderBubbleFrame.AbsoluteSize.X / 2 - p73.HeaderBubbleArrow.AbsoluteSize.X - 8
    local v77 = math.min(v75, v76) * math.sign(v74)
    p73.HeaderBubbleArrow.Position = UDim2.new(0, v77, 1, -2)
    p73.HeaderBubbleBackground.Size = UDim2.new(0.05, p73.HeaderBubbleTitle.TextBounds.X, 1, 0)
    p73.List.CanvasSize = UDim2.new(0, 0, 0, p73.Layout.AbsoluteContentSize.Y)
    p73.FooterBackground.Size = UDim2.new(0, (p73.FooterSlotsLayout.AbsoluteContentSize.X + p73.FooterSlotsLayout.Padding.Scale * p73.FooterSlotsFrame.AbsoluteSize.X) * 1.00878, 1, 0)
end
function v_u_23._UpdateListVisibility(p78)
    p78.List.Visible = not p78.PromptSystem.CurrentPrompt
end
function v_u_23._GetUnlockNowProductInfo(_, p79, p80)
    local v81 = v_u_11:Get("Seasons")[v_u_7.CurrentSeason.Name]
    if v81 then
        v81 = v81.BattlePass
    end
    if (v81 and (v81.MaxPassTrackNum or 0) or 0) < p80 then
        return v_u_5.Bundles.primeseason_bundle
    end
    local v82 = p79 - (v81 and v81.PassLevel or 0)
    if v82 > 0 then
        for _, v83 in pairs(v_u_5.BATTLE_PASS_LEVELS) do
            local v84 = v_u_5.Products[v83]
            if v82 <= v84.BattlePassLevelIncrement then
                return v84
            end
        end
        return nil
    end
end
function v_u_23._GetMaxPage(_)
    local v85 = v_u_7.CurrentSeason.NumBattlePassTiers / 7
    return math.ceil(v85)
end
function v_u_23._SetPage(p86, p87)
    local v88 = p86._current_page
    local v89 = p86:_GetMaxPage()
    p86._current_page = math.clamp(p87, 1, v89)
    if v88 ~= p86._current_page then
        local v90 = p86._current_page - v88
        local v91 = math.sign(v90)
        if v91 == 0 then
            v91 = nil
        end
        p86:_Update(v91)
    end
end
function v_u_23._Clear(p92)
    for _, v93 in pairs(p92._reward_slots) do
        v93:Destroy()
    end
    for _, v94 in pairs(p92._track_slots) do
        v94:Destroy()
    end
    for _, v95 in pairs(p92._footer_slots) do
        v95:Destroy()
    end
    for _, v96 in pairs(p92._xp_slots) do
        v96:Destroy()
    end
    p92._reward_slots = {}
    p92._track_slots = {}
    p92._footer_slots = {}
    p92._xp_slots = {}
    if p92._completed_all_tasks_thread then
        task.cancel(p92._completed_all_tasks_thread)
        p92._completed_all_tasks_thread = nil
    end
end
function v_u_23._Update(p_u_97, p98)
    p_u_97:_Clear()
    for v99 = 1, v_u_7.CurrentSeason.NumBattlePassTracks do
        local v100 = v_u_21:Clone()
        v100.Side.Background.ImageColor3 = v_u_8.StatusByPassTrackNum[v99].PassColor
        v100.Side["Icon" .. v99].Visible = true
        v100.LayoutOrder = v99
        v100.Parent = p_u_97.TracksFrame
        p_u_97._track_slots[v99] = v100
    end
    local v101 = v_u_11:Get("Seasons")[v_u_7.CurrentSeason.Name]
    if v101 then
        v101 = v101.BattlePass
    end
    local v102 = v101 and (v101.PassLevel or 0) or 0
    local v103 = v101 and (v101.MaxPassTrackNum or 0) or 0
    p_u_97.HeaderLevelText.Text = v102
    p_u_97.HeaderNextLevelText.Text = "Level " .. v102 + 1
    local v104 = false
    for v105 = 1, 7 do
        local v_u_106 = (p_u_97._current_page - 1) * 7 + v105
        if v_u_7.CurrentSeason.NumBattlePassTiers >= v_u_106 then
            local v107 = v_u_106 <= v102
            local v108 = v_u_19:Clone()
            v108.Tier.Text = v_u_106
            v108.LayoutOrder = v105
            v108.Bar.BackgroundColor3 = v107 and Color3.fromRGB(100, 255, 50) or Color3.fromRGB(255, 255, 255)
            v108.Bar.BackgroundTransparency = v107 and 0 or 0.75
            v108.Parent = p_u_97.FooterSlotsFrame
            local v109 = p_u_97._footer_slots
            table.insert(v109, v108)
            for v_u_110 = 1, v_u_7.CurrentSeason.NumBattlePassTracks do
                local v111 = v_u_7.CurrentSeason.BattlePassRewards[v_u_106]
                if v111 then
                    v111 = v_u_7.CurrentSeason.BattlePassRewards[v_u_106][v_u_110]
                end
                local v112 = v_u_8.StatusByPassTrackNum[v_u_110]
                local v113 = v101 and v101.RewardsClaimed[tostring(v_u_106)]
                if v113 then
                    v113 = v101.RewardsClaimed[tostring(v_u_106)][tostring(v_u_110)]
                end
                local v114
                if v113 then
                    v114 = v113
                elseif v107 then
                    v114 = v_u_110 <= v103
                else
                    v114 = v107
                end
                local v115 = v_u_20:Clone()
                v115.Container.Claimed.Visible = v114
                v115.Container.Unclaimed.Visible = not v114
                v115.Container.Unclaimed.Status.ImageColor3 = v112.PassColor
                v115.Container.Unclaimed.Background.ImageColor3 = v112.DarkPassColor
                v115.Container.Claimed.Status.ImageColor3 = v112.DarkPassColor
                v115.Container.Claimed.Claimed.Visible = v113 and v111
                v115.Container.Claimed.Background.ImageColor3 = v112.DarkPassColor
                v115.Container.Claimed.Container.GroupTransparency = v113 and 0.75 or 0
                local v116 = v115.Container.Claimed.ClaimNowBubble
                local v117
                if v111 then
                    v117 = not v113
                else
                    v117 = v111
                end
                v116.Visible = v117
                v115.LayoutOrder = v105
                v115.Parent = p_u_97._track_slots[v_u_110]
                if v111 then
                    local v118 = v_u_17.new(v111)
                    v118.Frame.Parent = v114 and v115.Container.Claimed.Container or v115.Container.Unclaimed.Container
                    local v119 = p_u_97._reward_slots
                    table.insert(v119, v118)
                    v118:OnClick(function()
                        p_u_97:Preview(v_u_106, v_u_110)
                    end)
                    local v120 = (v111.Quantity or 1) == 1
                    local v121 = v_u_6.Cosmetics[v111.Name]
                    local v122 = v_u_8.Items[v111.Name]
                    local v123 = v_u_6.Rewards[v111.Name]
                    if v123 then
                        v123 = v_u_6.Rewards[v111.Name].Type == "Currency"
                    end
                    if v120 and not (v121 or (v122 or v123)) then
                        v118:SetNameText("")
                    end
                end
                if p98 then
                    local v124 = (v105 + v_u_110 - 1) / 7
                    if p98 < 0 then
                        v124 = 1 - v124
                    end
                    v115.Container.Position = UDim2.new(0.5 + 0.5 * p98, 0, 0.5, 0)
                    v115.Container:TweenPosition(UDim2.new(0.5, 0, 0.5, 0), "Out", "Quint", 0.25 + 0.5 * v124, true)
                end
                if not v104 and (v_u_110 == 1 and v111) then
                    v104 = true
                end
            end
        end
    end
    local v125 = v101 and (v101.NumPassTasksCompleted or 0) or 0
    local v_u_126 = v101 and v101.PassTaskProgress and (v101.PassTaskProgress.RoundsWon or 0) or 0
    local v_u_127 = v101 and (v101.PassTaskProgress and v101.PassTaskProgress.Playtime) or 0
    local v_u_128 = v_u_7:GetCurrentSeasonWeek() * v_u_7.CurrentSeason.BattlePassTasksPerWeek <= v125
    local v129 = v_u_126 / v_u_7.CurrentSeason.BattlePassTaskRequirements.RoundsWon
    local v130 = v_u_127 / v_u_7.CurrentSeason.BattlePassTaskRequirements.Playtime
    local v131 = math.max(v129, v130)
    p_u_97.HeaderXPBar.Size = UDim2.new(math.clamp(v131, 0, 1), 0, 1, 0)
    local function v_u_137()
        if v_u_128 then
            local v132 = p_u_97.HeaderBubbleTitle
            local v133 = string.format
            local v134 = v_u_9
            local v135 = v_u_7:GetTimeUntilNextSeasonWeek()
            v132.Text = v133("All done! You can level up again in <font transparency=\"0\" weight=\"800\">%s</font>", v134:TimeFormat2((math.ceil(v135))))
        else
            local v136 = string.format("%.1f", v_u_127 / 60)
            p_u_97.HeaderBubbleTitle.Text = string.format("Win (<font transparency=\"0\" weight=\"800\">%s</font> / %s) rounds in duels or play for (<font transparency=\"0\" weight=\"800\">%s</font> / %s) minutes to level up", v_u_126, v_u_7.CurrentSeason.BattlePassTaskRequirements.RoundsWon, v136 == "0.0" and "0" or v136, string.format("%.0f", v_u_7.CurrentSeason.BattlePassTaskRequirements.Playtime / 60))
        end
    end
    v_u_137()
    if v_u_128 then
        p_u_97._completed_all_tasks_thread = task.spawn(function()
            while true do
                wait(1)
                v_u_137()
            end
        end)
    end
    local v138 = p_u_97._current_page < p_u_97:_GetMaxPage()
    local v139 = p_u_97._current_page > 1
    p_u_97.NextBackground.BackgroundTransparency = v138 and 0 or 0.75
    p_u_97.NextIcon.ImageTransparency = v138 and 0 or 0.75
    p_u_97.PreviousBackground.BackgroundTransparency = v139 and 0 or 0.75
    p_u_97.PreviousIcon.ImageTransparency = v139 and 0 or 0.75
end
function v_u_23._Init(p_u_140)
    p_u_140.CloseButton.MouseButton1Click:Connect(function()
        p_u_140:CloseRequest()
    end)
    p_u_140.PromptSystem.PromptAdded:Connect(function()
        p_u_140:_UpdateListVisibility()
    end)
    p_u_140.PromptSystem.PromptRemoved:Connect(function()
        p_u_140:_UpdateListVisibility()
    end)
    p_u_140.NextButton.MouseButton1Click:Connect(function()
        p_u_140:_SetPage(p_u_140._current_page + 1)
    end)
    p_u_140.PreviousButton.MouseButton1Click:Connect(function()
        p_u_140:_SetPage(p_u_140._current_page - 1)
    end)
    p_u_140.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p_u_140:_UpdateVisuals()
    end)
    p_u_140.FooterSlotsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p_u_140:_UpdateVisuals()
    end)
    p_u_140.HeaderBubbleTitle:GetPropertyChangedSignal("TextBounds"):Connect(function()
        p_u_140:_UpdateVisuals()
    end)
    p_u_140.HeaderXPBar:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
        p_u_140:_UpdateVisuals()
    end)
    p_u_140.HeaderXPBar:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        p_u_140:_UpdateVisuals()
    end)
    p_u_140.HeaderBubbleFrame:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
        p_u_140:_UpdateVisuals()
    end)
    p_u_140.HeaderBubbleFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        p_u_140:_UpdateVisuals()
    end)
    p_u_140.HeaderBubbleArrow:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        p_u_140:_UpdateVisuals()
    end)
    p_u_140.PreviewClaimButton.MouseButton1Click:Connect(function()
        v_u_1.Remotes.Data.ClaimBattlePassReward:FireServer(p_u_140._preview_data.Tier, p_u_140._preview_data.PassTrackNum)
    end)
    p_u_140.PreviewUnlockButton.MouseButton1Click:Connect(function()
        p_u_140:UnlockNow()
    end)
    p_u_140.PreviewUnlockViewContentsButton.MouseButton1Click:Connect(function()
        p_u_140.PromptSystem:Open("InspectLootbox", p_u_140._preview_data.RewardData.Name, p_u_140._preview_data.RewardData.Weapon)
    end)
    p_u_140.PrimeSeasonBundleSlot.Tapped:Connect(function()
        p_u_140:InspectBundle(p_u_140.PrimeSeasonBundleSlot.Name)
    end)
    p_u_140.ContrabandSeasonBundleSlot.Tapped:Connect(function()
        p_u_140:InspectBundle(p_u_140.ContrabandSeasonBundleSlot.Name)
    end)
    p_u_140:_UpdateVisuals()
    v_u_14:Add(p_u_140.CloseButton)
    v_u_14:Add(p_u_140.NextButton)
    v_u_14:Add(p_u_140.PreviousButton)
    v_u_14:Add(p_u_140.PreviewClaimButton)
    v_u_14:Add(p_u_140.PreviewUnlockButton)
    v_u_14:Add(p_u_140.PreviewUnlockViewContentsButton)
end
return v_u_23._new()