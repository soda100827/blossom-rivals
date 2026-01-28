local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("TweenService")
local v3 = game:GetService("Players")
local v_u_4 = require(v1.Modules.StatisticsLibrary)
local v_u_5 = require(v1.Modules.SeasonLibrary)
local v_u_6 = require(v3.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
local v_u_7 = require(v3.LocalPlayer.PlayerScripts.Modules.EquipmentMetricCard)
local v_u_8 = require(v3.LocalPlayer.PlayerScripts.Modules.UILibrary)
local v_u_9 = require(script:WaitForChild("SecondaryActions"))
local v_u_10 = require(script:WaitForChild("PrimaryActions"))
local v_u_11 = require(script:WaitForChild("LockedActions"))
local v_u_12 = require(script:WaitForChild("Performance"))
local v_u_13 = require(script:WaitForChild("Overview"))
local v_u_14 = require(script:WaitForChild("Details"))
local v_u_15 = require(script:WaitForChild("Level"))
local v_u_16 = UDim2.new(1.375, 0, 0.5, 0)
local v_u_17 = UDim2.new(1, 0, 0.5, 0)
local v_u_18 = {}
v_u_18.__index = v_u_18
function v_u_18.new(p19)
    local v20 = v_u_18
    local v21 = setmetatable({}, v20)
    v21.Interface = p19
    v21.Frame = v21.Interface.Frame:WaitForChild("Right")
    v21.List = v21.Frame:WaitForChild("List")
    v21.Container = v21.List:WaitForChild("Container")
    v21.Layout = v21.Container:WaitForChild("Layout")
    v21.TopBufferFrame = v21.Container:WaitForChild("TopBuffer")
    v21.SecondaryActions = v_u_9.new(v21)
    v21.PrimaryActions = v_u_10.new(v21)
    v21.LockedActions = v_u_11.new(v21)
    v21.Performance = v_u_12.new(v21)
    v21.Overview = v_u_13.new(v21)
    v21.Details = v_u_14.new(v21)
    v21.Level = v_u_15.new(v21)
    v21._is_visible = false
    v21._last_state = nil
    v21._metric_cards = {
        ["Performance"] = v21.Performance.MetricCard,
        ["Overview"] = v21.Overview.MetricCard
    }
    v21:_Init()
    return v21
end
function v_u_18.SetVisible(p22, p23)
    p22._is_visible = p23
    p22.Frame:TweenPosition(p22._is_visible and v_u_17 or v_u_16, "Out", "Quint", 0.25, true)
end
function v_u_18.SetMetricCardVisible(p24, p25, p26)
    p24._metric_cards[p25]:SetOpened(p26)
    p24.PrimaryActions:SetMetricActionVisible(p25, not p26)
    p24.SecondaryActions:SetMetricActionVisible(p25, not p26)
end
function v_u_18.ResetMetricCards(p27)
    for v28 in pairs(p27._metric_cards) do
        p27:SetMetricCardVisible(v28, false)
    end
end
function v_u_18.ScrollTo(p_u_29, p_u_30, p31)
    task.delay(p31 or 0, function()
        local v32 = p_u_29.List.AbsoluteCanvasSize.Y
        local v33 = p_u_30.AbsolutePosition.Y + v_u_8.MainGui.AbsolutePosition.Y * 2 - p_u_29.Container.AbsolutePosition.Y
        local v34 = math.min(v32, v33)
        v_u_2:Create(p_u_29.List, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            ["CanvasPosition"] = Vector2.new(0, v34)
        }):Play()
    end)
end
function v_u_18.OnStateChanged(p35, ...)
    p35.SecondaryActions:OnStateChanged(...)
    p35.PrimaryActions:OnStateChanged(...)
    p35.LockedActions:OnStateChanged(...)
    p35.Performance:OnStateChanged(...)
    p35.Overview:OnStateChanged(...)
    p35.Details:OnStateChanged(...)
    p35.Level:OnStateChanged(...)
    p35:_OpenEffect()
end
function v_u_18.OnOpen(p36, ...)
    p36.SecondaryActions:OnOpen(...)
    p36.PrimaryActions:OnOpen(...)
    p36.Performance:OnOpen(...)
    p36.Overview:OnOpen(...)
end
function v_u_18._OpenEffect(p37)
    local v38 = p37.Interface.Equipment:GetSelectedWeapon()
    local v39 = v_u_6:GetWeaponData(v38)
    if v38 then
        v38 = not v39
    end
    p37.List:TweenSize(v38 and UDim2.new(1, 0, 1, 0) or UDim2.new(0.7, 0, 1, 0), "Out", "Quint", 0.25, true)
    local v40 = p37.Interface.Equipment:GetStateID()
    if v40 ~= p37._last_state then
        p37._last_state = v40
        p37.Frame.Position = v_u_16
        p37:SetVisible(p37._is_visible)
    end
end
function v_u_18._Update(p41)
    local v42 = p41.TopBufferFrame
    local v43 = UDim2.new
    local v44 = p41.List.AbsoluteSize.Y * 0.375
    local v45 = p41.List.AbsoluteSize.Y - (p41.Layout.AbsoluteContentSize.Y - p41.TopBufferFrame.AbsoluteSize.Y)
    v42.Size = v43(1, 0, 0, (math.max(v44, v45)))
    p41.List.CanvasSize = UDim2.new(0, 0, 0, p41.Layout.AbsoluteContentSize.Y)
end
function v_u_18._SetupPreviousSeasons(p_u_46)
    local v47 = v_u_6:Get("Seasons")
    local v48 = {}
    for v49 in pairs(v_u_5.Seasons) do
        if v47[v49] then
            table.insert(v48, v49)
        end
    end
    table.sort(v48, function(p50, p51)
        return v_u_5.Seasons[p50].Version < v_u_5.Seasons[p51].Version
    end)
    for _, v52 in pairs(v48) do
        local v53 = v47[v52] and v47[v52].RankedPerformances
        if v53 then
            v53 = v47[v52].RankedPerformances[v_u_5.UNIVERSAL_ELO_NAME]
        end
        if v53 and (v53.DuelsPlayed or 0) > 0 then
            local v54 = v_u_5.Seasons[v52]
            local v_u_55 = "season_" .. v52
            local v56 = "Season " .. v54.Version
            local v57 = "The " .. v54.Name .. " Season"
            local v_u_58 = v_u_7.new(v56, "rbxassetid://117835427046796")
            v_u_58:SetParent(p_u_46.Container)
            p_u_46._metric_cards[v_u_55] = v_u_58
            v_u_58.Opened:Connect(function()
                p_u_46:ScrollTo(v_u_58:GetScrollToElement())
            end)
            v_u_58.Clicked:Connect(function()
                p_u_46:SetMetricCardVisible(v_u_55, false)
            end)
            if v53.DuelsPlayed then
                v_u_58:Add("Duels Played", v_u_4.Info.StatisticRankedDuelsPlayed.TostringFunction(v53.DuelsPlayed))
            end
            if v53.DuelsWon then
                v_u_58:Add("Duels Won", v_u_4.Info.StatisticRankedDuelsWon.TostringFunction(v53.DuelsWon))
            end
            if v53.DuelsLost then
                v_u_58:Add("Duels Lost", v_u_4.Info.StatisticRankedDuelsLost.TostringFunction(v53.DuelsLost))
            end
            if v53.DuelsWinPercent then
                v_u_58:Add("Duels Win %", v_u_4.Info.StatisticRankedDuelsWinPercent.TostringFunction(v53.DuelsWinPercent))
            end
            if v53.CurrentELO then
                v_u_58:Add("Final ELO", v_u_4.Info.StatisticRankedDuelsPlayed.TostringFunction(v53.CurrentELO))
            end
            if v53.HighestELO then
                v_u_58:Add("Highest ELO", v_u_4.Info.StatisticRankedDuelsPlayed.TostringFunction(v53.HighestELO))
            end
            if v53.LowestELO then
                v_u_58:Add("Lowest ELO", v_u_4.Info.StatisticRankedDuelsPlayed.TostringFunction(v53.LowestELO))
            end
            p_u_46.SecondaryActions:CreateMetricAction(v_u_55, "rbxassetid://117835427046796", v56, v57)
        end
    end
end
function v_u_18._Setup(p59)
    p59.Visible = true
end
function v_u_18._Init(p_u_60)
    p_u_60.List:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        p_u_60:_Update()
    end)
    p_u_60.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p_u_60:_Update()
    end)
    p_u_60.TopBufferFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        p_u_60:_Update()
    end)
    p_u_60.Performance.MetricCard.Opened:Connect(function()
        p_u_60:ScrollTo(p_u_60.Performance.MetricCard:GetScrollToElement())
    end)
    p_u_60.Overview.MetricCard.Opened:Connect(function()
        p_u_60:ScrollTo(p_u_60.Overview.MetricCard:GetScrollToElement())
    end)
    v_u_6:GetDataChangedSignal("WeaponInventory"):Connect(function()
        p_u_60:_OpenEffect()
    end)
    p_u_60:_Setup()
    p_u_60:_SetupPreviousSeasons()
    p_u_60:_Update()
end
return v_u_18