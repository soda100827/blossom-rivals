local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("TweenService")
local v_u_3 = game:GetService("Players")
local v_u_4 = require(v1.Modules.CONSTANTS)
local v_u_5 = require(v1.Modules.RotatingQueueLibrary)
local v_u_6 = require(v1.Modules.SeasonLibrary)
local v_u_7 = require(v1.Modules.EventLibrary)
local v_u_8 = require(v1.Modules.DuelLibrary)
local v_u_9 = require(v1.Modules.Utility)
require(v_u_3.LocalPlayer.PlayerScripts.Controllers:WaitForChild("MatchmakingController"))
local v_u_10 = require(v_u_3.LocalPlayer.PlayerScripts.Controllers:WaitForChild("LeaderboardController"))
local v_u_11 = require(v_u_3.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController"))
local v_u_12 = require(v_u_3.LocalPlayer.PlayerScripts.Controllers:WaitForChild("ArcadeController"))
local v_u_13 = require(v_u_3.LocalPlayer.PlayerScripts.Modules:WaitForChild("BaseMatchmakingQueueSlot"):WaitForChild("MatchmakingQueueSlot"))
local v_u_14 = require(v_u_3.LocalPlayer.PlayerScripts.Modules:WaitForChild("BaseMatchmakingQueueSlot"))
local v_u_15 = require(v_u_3.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect"))
local v_u_16 = require(v_u_3.LocalPlayer.PlayerScripts.Modules:WaitForChild("PromptSystem"))
local v_u_17 = require(v_u_3.LocalPlayer.PlayerScripts.Modules:WaitForChild("RankIcon"))
local v_u_18 = require(v_u_3.LocalPlayer.PlayerScripts.Modules:WaitForChild("Page"))
v_u_3.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("MatchmakingQueueSlot")
local v_u_19 = setmetatable({}, v_u_18)
v_u_19.__index = v_u_19
function v_u_19._new()
    local v20 = v_u_18.new(script.Name)
    local v21 = v_u_19
    local v22 = setmetatable(v20, v21)
    v22.PromptsFrame = v22.PageFrame:WaitForChild("Prompts")
    v22.PageContainer = v22.PageFrame:WaitForChild("Container")
    v22.CloseButton = v22.PageContainer:WaitForChild("Close")
    v22.List = v22.PageContainer:WaitForChild("List")
    v22.Container = v22.List:WaitForChild("Container")
    v22.Layout = v22.Container:WaitForChild("Layout")
    v22.CenterDuelsFrame = v22.Container:WaitForChild("CenterDuels")
    v22.DuelsFrame = v22.Container:WaitForChild("Duels")
    v22.DuelsContainer = v22.DuelsFrame:WaitForChild("Container")
    v22.QueuesFrame = v22.DuelsContainer:WaitForChild("Queues")
    v22.RankedFrame = v22.DuelsContainer:WaitForChild("Ranked")
    v22.RankedButton = v22.RankedFrame:WaitForChild("Button")
    v22.RankedThumbnail = v22.RankedButton:WaitForChild("Thumbnail")
    v22.RankedLockedFrame = v22.RankedButton:WaitForChild("Locked")
    v22.RankedLockedText = v22.RankedLockedFrame:WaitForChild("Description")
    v22.RankedUnlockedFrame = v22.RankedButton:WaitForChild("Unlocked")
    v22.RankedIconContainer = v22.RankedUnlockedFrame:WaitForChild("IconContainer")
    v22.RankedSeasonText = v22.RankedUnlockedFrame:WaitForChild("Season")
    v22.RankedRankText = v22.RankedUnlockedFrame:WaitForChild("Rank")
    v22.RankedELOText = v22.RankedUnlockedFrame:WaitForChild("ELO")
    v22.AprilFoolsFrame = v22.Container:WaitForChild("AprilFools")
    v22.AprilFoolsContainer = v22.AprilFoolsFrame:WaitForChild("Container")
    v22.AprilFoolsSlotsFrame = v22.AprilFoolsContainer:WaitForChild("Slots")
    v22.AprilFoolsSlotsLayout = v22.AprilFoolsSlotsFrame:WaitForChild("Layout")
    v22.ArcadeServersFrame = v22.Container:WaitForChild("ArcadeServers")
    v22.ArcadeServersContainer = v22.ArcadeServersFrame:WaitForChild("Container")
    v22.RotatingFrame = v22.Container:WaitForChild("Rotating")
    v22.RotatingContainer = v22.RotatingFrame:WaitForChild("Container")
    v22.RotatingHeaderFrame = v22.RotatingContainer:WaitForChild("Header")
    v22.RotatingHeaderTitle = v22.RotatingHeaderFrame:WaitForChild("Title")
    v22.RotatingSlotsFrame = v22.RotatingContainer:WaitForChild("Slots")
    v22.RotatingSlotsLayout = v22.RotatingSlotsFrame:WaitForChild("Layout")
    v22.EventFrame = v22.Container:WaitForChild("Event")
    v22.EventContainer = v22.EventFrame:WaitForChild("Container")
    v22.EventHeaderFrame = v22.EventContainer:WaitForChild("Header")
    v22.EventHeaderIcon = v22.EventHeaderFrame:WaitForChild("Icon")
    v22.EventSlotsFrame = v22.EventContainer:WaitForChild("Slots")
    v22.EventSlotsLayout = v22.EventSlotsFrame:WaitForChild("Layout")
    v22.PromptSystem = v_u_16.new(v22.PromptsFrame)
    v22.RankedSlot = v_u_14.new(v22.RankedFrame)
    v22._matchmaking_queue_slots = {}
    v22._rotating_matchmaking_queue_slots = {}
    v22._rotating_batch_containers = {}
    v22._rank_icon = nil
    v22:_Init()
    return v22
end
function v_u_19.ScrollTo(p_u_23, p24, p25)
    local v_u_26
    if p24 == "Arcade" then
        v_u_26 = p_u_23.ArcadeServersFrame
    elseif p24 == "Rotating" then
        v_u_26 = p_u_23.RotatingFrame
    else
        v_u_26 = nil
    end
    if v_u_26 then
        task.delay(p25 or 0, function()
            v_u_2:Create(p_u_23.List, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                ["CanvasPosition"] = Vector2.new(0, v_u_26.AbsolutePosition.Y - p_u_23.Container.AbsolutePosition.Y)
            }):Play()
        end)
    end
end
function v_u_19.Open(p27, ...)
    v_u_18.Open(p27, ...)
    p27.List.CanvasPosition = Vector2.zero
    task.defer(p27._GenerateRotatingLoop, p27)
end
function v_u_19._UpdateLayouts(p28)
    p28.RotatingFrame.Size = UDim2.new(1, 0, 0.1, p28.RotatingSlotsLayout.AbsoluteContentSize.Y)
    p28.EventFrame.Size = UDim2.new(1, 0, 0.1, p28.EventSlotsLayout.AbsoluteContentSize.Y)
    p28.AprilFoolsFrame.Size = UDim2.new(1, 0, 0.1, p28.AprilFoolsSlotsLayout.AbsoluteContentSize.Y)
end
function v_u_19._UpdateLocked(p29)
    local v30 = v_u_11:Get("Level") < v_u_6.CurrentSeason.LevelRequirement
    p29.RankedLockedFrame.Visible = v30
    p29.RankedUnlockedFrame.Visible = not v30
end
function v_u_19._UpdateELO(p31)
    if p31._rank_icon then
        p31._rank_icon:Destroy()
        p31._rank_icon = nil
    end
    local _ = v_u_6.CurrentSeason.RankProfile
    local v32 = v_u_11:Get("Seasons")[v_u_6.CurrentSeason.Name]
    if v32 then
        v32 = v32.RankedPerformances[v_u_6.UNIVERSAL_ELO_NAME]
    end
    if v32 then
        local v33 = v_u_6:GetRank(v32.CurrentELO, v_u_3.LocalPlayer.UserId)
        p31.RankedRankText.Text = v33
        local v34 = p31.RankedELOText
        local v35
        if v32.CurrentELO then
            v35 = v_u_9:PrettyNumber(v32.CurrentELO) .. " ELO"
        else
            v35 = v32.DuelsPlayed .. " / " .. v_u_6.CurrentSeason.RankProfile.NumPlacementDuels
        end
        v34.Text = v35
        if v32.CurrentELO then
            p31._rank_icon = v_u_17.new(v32.CurrentELO, v_u_3.LocalPlayer.UserId)
            p31._rank_icon:SetParent(p31.RankedIconContainer)
        end
    end
end
function v_u_19._UpdateList(p36)
    p36.CloseButton.Position = UDim2.new(0.975, 0, 0.0225, p36.PageFrame.AbsoluteSize.Y * 0.125)
    p36.List.Position = UDim2.new(0.5, 9, 0, p36.PageFrame.AbsoluteSize.Y * 0.125)
    p36.List.Size = UDim2.new(0.85, 0, 0, p36.PageFrame.AbsoluteSize.Y * 0.75)
    p36.List.CanvasSize = UDim2.new(0, 0, 0, p36.Layout.AbsoluteContentSize.Y)
end
function v_u_19._UpdateOnboarding(p37)
    local v38 = v_u_11:GetStatistic("StatisticDuelsPlayed")
    p37.CenterDuelsFrame.Visible = v38 < 3
    p37.RotatingFrame.Visible = v38 >= 3
    p37.ArcadeServersFrame.Visible = v38 >= 4
    local v39 = p37.AprilFoolsFrame
    local v40 = v38 >= 10 and (v_u_9:IsAprilFools() and v_u_8.APRIL_FOOLS_QUEUES)
    if v40 then
        v40 = #v_u_8.APRIL_FOOLS_QUEUES > 0
    end
    v39.Visible = v40
end
function v_u_19._UpdateBeginnerQueue(p41)
    local v42 = p41._matchmaking_queue_slots[v_u_4.BEGINNER_QUEUE_NAME]
    if v42 then
        local v43 = v_u_11:GetStatistic("StatisticDuelsWon") < v_u_4.BEGINNER_QUEUE_WINS
        v42.Frame.Visible = v43
        p41.RankedFrame.Visible = not v43
        p41.QueuesFrame.Position = not v43 and UDim2.new(0.7, 0, 0.2, 0) or UDim2.new(1, 0, 0.2, 0)
    else
        p41.RankedFrame.Visible = true
    end
end
function v_u_19._RespondToQueueStatus(p44, p45)
    if p45 == "Success" then
        p44.Closed:Fire()
    else
        p44.PromptSystem:Open("ErrorMessage", "Woops!", p45 or "Server failed to respond, please try again")
    end
end
function v_u_19._GenerateQueues(p_u_46, p47, p48, p49, p50)
    if p49 then
        for _, v51 in pairs(p49) do
            v51:Destroy()
        end
        table.clear(p49)
    end
    local v52 = #p48 / 2
    local v53 = p49 or {}
    for v54 = 1, math.ceil(v52) do
        local v55 = Instance.new("Frame")
        v55.AnchorPoint = Vector2.new(0.5, 0.5)
        v55.Size = UDim2.new(1, 0, 1, 0)
        v55.BackgroundTransparency = 1
        v55.Parent = p47
        table.insert(v53, v55)
        local v56 = Instance.new("UIListLayout")
        v56.Padding = UDim.new(0.005, 0)
        v56.HorizontalAlignment = Enum.HorizontalAlignment.Center
        v56.FillDirection = Enum.FillDirection.Horizontal
        v56.VerticalAlignment = Enum.VerticalAlignment.Top
        v56.Parent = v55
        local v57 = p48[1 + 2 * (v54 - 1) + 1] and 2 or 1
        for v58 = 1, v57 do
            local v59 = p48[2 * (v54 - 1) + v58]
            local v60 = Instance.new("Frame")
            v60.AnchorPoint = Vector2.new(0.5, 0.5)
            v60.Size = UDim2.new(1 / v57 - v56.Padding.Scale / 2 * (v57 - 1), 0, v54 > 1 and v57 == 1 and 0.75 or 1, 0)
            v60.BackgroundTransparency = 1
            v60.Parent = v55
            local v61 = v_u_13.new(v59, v60)
            v61.QueueStatus:Connect(function(p62)
                p_u_46:_RespondToQueueStatus(p62)
            end)
            p_u_46._matchmaking_queue_slots[v59] = v61
            if p50 then
                p50(v59, v60, v61)
            end
        end
    end
end
function v_u_19._GenerateRotating(p_u_63)
    for _, v64 in pairs(p_u_63._rotating_matchmaking_queue_slots) do
        v64.Container:Destroy()
        v64.MatchmakingQueueSlot:Destroy()
    end
    p_u_63:_GenerateQueues(p_u_63.RotatingSlotsFrame, v_u_5:GetCurrent().QueueNames, p_u_63._rotating_batch_containers, function(p65, p66, p67)
        p_u_63._rotating_matchmaking_queue_slots[p65] = {
            ["Container"] = p66,
            ["MatchmakingQueueSlot"] = p67
        }
    end)
end
function v_u_19._GenerateRotatingLoop(p68)
    local v69 = p68._is_open_hash
    local v70 = nil
    while p68._is_open and v69 == p68._is_open_hash do
        local v71 = v_u_5:GetCycle()
        if v71 == v70 then
            v71 = v70
        else
            p68:_GenerateRotating()
        end
        local v72 = p68.RotatingHeaderTitle
        local v73 = v_u_9
        local v74 = v_u_5:GetTimeUntilNext()
        v72.Text = "New gamemodes in " .. v73:TimeFormat2((math.ceil(v74)))
        wait(1)
        v70 = v71
    end
end
function v_u_19._GenerateQueueSlot(p_u_75, p76)
    local v77 = v_u_9:WaitForChildRecursive(p_u_75.Container, p76, 2)
    if v77 then
        local v78 = v_u_13.new(p76, v77)
        v78.QueueStatus:Connect(function(p79)
            p_u_75:_RespondToQueueStatus(p79)
        end)
        p_u_75._matchmaking_queue_slots[p76] = v78
        if p76 == v_u_4.BEGINNER_QUEUE_NAME then
            p_u_75:_UpdateBeginnerQueue()
        end
    end
end
function v_u_19._Setup(p80)
    p80.RankedLockedText.Text = "Unlocked at\nLevel " .. v_u_6.CurrentSeason.LevelRequirement
    p80.RankedSeasonText.Text = "Season " .. v_u_6.CurrentSeason.Version
    p80.RankedThumbnail.Image = v_u_6.CurrentSeason.ThumbnailRankedCoverPhoto
    p80.EventHeaderIcon.Image = v_u_7.EVENT_DETAILS and v_u_7.EVENT_DETAILS.LTM_HEADER_ICON or p80.EventHeaderIcon.Image
    for _, v81 in pairs(v_u_8.MatchmakingQueueOrder) do
        task.defer(p80._GenerateQueueSlot, p80, v81)
    end
    if v_u_8.APRIL_FOOLS_QUEUES and #v_u_8.APRIL_FOOLS_QUEUES > 0 then
        p80:_GenerateQueues(p80.AprilFoolsSlotsFrame, v_u_8.APRIL_FOOLS_QUEUES)
    end
    local v82 = p80.EventFrame
    local v83 = v_u_7.IS_ACTIVE and v_u_7.LTM_QUEUENAMES
    if v83 then
        v83 = #v_u_7.LTM_QUEUENAMES > 0
    end
    v82.Visible = v83
    if p80.EventFrame.Visible then
        p80:_GenerateQueues(p80.EventSlotsFrame, v_u_7.LTM_QUEUENAMES)
    end
    for _, v_u_84 in pairs(v_u_8.ArcadeModeOrder) do
        local v85 = v_u_8.ArcadeModes[v_u_84]
        local v86 = p80.ArcadeServersContainer:WaitForChild(v_u_84)
        v86:WaitForChild("Button"):WaitForChild("Title").Text = v85.DisplayName
        v86:WaitForChild("Button"):WaitForChild("Description").Text = v85.Description
        v86:WaitForChild("Button"):WaitForChild("Thumbnail").Image = v85.Thumbnail
        v_u_14.new(v86).Clicked:Connect(function()
            v_u_12:ToArcadeServer(v_u_84)
        end)
    end
end
function v_u_19._Init(p_u_87)
    p_u_87.CloseButton.MouseButton1Click:Connect(function()
        p_u_87:CloseRequest()
    end)
    p_u_87.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p_u_87:_UpdateList()
    end)
    p_u_87.PageFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        p_u_87:_UpdateList()
    end)
    p_u_87.RankedSlot.Clicked:Connect(function()
        if v_u_11:Get("Level") >= v_u_6.CurrentSeason.LevelRequirement then
            p_u_87.OpenPage:Fire("Ranked")
        else
            v_u_9:CreateSound("rbxassetid://17153811469", 2, 1, script, true, 5)
        end
    end)
    p_u_87.RotatingSlotsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p_u_87:_UpdateLayouts()
    end)
    p_u_87.EventSlotsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p_u_87:_UpdateLayouts()
    end)
    p_u_87.AprilFoolsSlotsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p_u_87:_UpdateLayouts()
    end)
    v_u_11:GetDataChangedSignal("StatisticDuelsPlayed"):Connect(function()
        p_u_87:_UpdateOnboarding()
    end)
    v_u_11:GetDataChangedSignal("StatisticDuelsWon"):Connect(function()
        p_u_87:_UpdateBeginnerQueue()
    end)
    v_u_11:GetDataChangedSignal("Level"):Connect(function()
        p_u_87:_UpdateLocked()
    end)
    v_u_11:GetDataChangedSignal("Seasons"):Connect(function()
        p_u_87:_UpdateELO()
    end)
    v_u_10:GetLeaderboardRefreshedSignal("Highest ELO"):Connect(function()
        p_u_87:_UpdateELO()
    end)
    p_u_87:_Setup()
    p_u_87:_UpdateList()
    p_u_87:_UpdateOnboarding()
    p_u_87:_UpdateELO()
    p_u_87:_UpdateLocked()
    p_u_87:_UpdateLayouts()
    v_u_15:Add(p_u_87.CloseButton)
end
return v_u_19._new()