local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.CONSTANTS)
local v_u_4 = require(v1.Modules.MonetizationLibrary)
local v_u_5 = require(v1.Modules.StatisticsLibrary)
local v_u_6 = require(v1.Modules.ContractsLibrary)
local v_u_7 = require(v1.Modules.EventLibrary)
local v_u_8 = require(v1.Modules.ItemLibrary)
local v_u_9 = require(v1.Modules.TaskLibrary)
local v_u_10 = require(v1.Modules.Utility)
local v_u_11 = require(v2.LocalPlayer.PlayerScripts.Controllers.ShootingRangeController)
local v_u_12 = require(v2.LocalPlayer.PlayerScripts.Controllers.MonetizationController)
local v_u_13 = require(v2.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
local v_u_14 = require(v2.LocalPlayer.PlayerScripts.Controllers.LobbyController)
local v_u_15 = require(v2.LocalPlayer.PlayerScripts.Controllers.TimerController)
local v_u_16 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("AdventCalendarSlot"))
local v_u_17 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect"))
local v_u_18 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("RewardSlot"))
local v_u_19 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("TaskSlot"))
local v_u_20 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("Page"))
local v_u_21 = v2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("DailyTaskStreakMilestoneRewardClaimed")
local v_u_22 = v2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("DailyTaskStreakMilestoneReward")
local v_u_23 = v2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("DailyTaskStreakSlot")
local v_u_24 = v2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("ContractTaskSlot")
local v_u_25 = v2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("TaskContainer")
local v_u_26 = {
    {
        "Tasks",
        "Daily Tasks",
        "rbxassetid://17653923757",
        UDim2.new(2, 0, 1.5, 0)
    },
    {
        "SpecialChallenges",
        "Special Challenge" .. (#(v_u_9.SPECIAL_CHALLENGES or {}) == 1 and "" or "s") .. "!",
        "rbxassetid://17860673529",
        UDim2.new(2, 0, 2, 0),
        "Limited time only!"
    },
    {
        "EventTasks",
        "Earn " .. v_u_7.EVENT_DETAILS.CURRENCY_NAME_PLURAL .. "!",
        v_u_7.EVENT_DETAILS.CURRENCY_IMAGE,
        UDim2.new(2.25, 0, 2.25, 0),
        "Limited time only!"
    },
    {
        "BonusTasks",
        "Bonus Tasks",
        "rbxassetid://17653923757",
        UDim2.new(2, 0, 1.5, 0)
    }
}
local v_u_27 = setmetatable({}, v_u_20)
v_u_27.__index = v_u_27
function v_u_27._new()
    local v28 = v_u_20.new(script.Name)
    local v29 = v_u_27
    local v30 = setmetatable(v28, v29)
    v30.CloseButton = v30.PageFrame:WaitForChild("Close")
    v30.List = v30.PageFrame:WaitForChild("List")
    v30.Container = v30.List:WaitForChild("Container")
    v30.Layout = v30.Container:WaitForChild("Layout")
    v30.ToShootingRangeButton = v30.Container:WaitForChild("ToShootingRange")
    v30.ToDuelsButton = v30.Container:WaitForChild("ToDuels")
    v30.TasksCompletedFrame = v30.Container:WaitForChild("TasksCompleted")
    v30.TasksCompletedContainer = v30.TasksCompletedFrame:WaitForChild("Container")
    v30.TasksCompletedTimerText = v30.TasksCompletedContainer:WaitForChild("Timer")
    v30.TasksCompletedContentsFrame = v30.TasksCompletedContainer:WaitForChild("Contents")
    v30.TasksCompletedContentsLayout = v30.TasksCompletedContentsFrame:WaitForChild("Layout")
    v30.TasksCompletedRefreshFrame = v30.TasksCompletedContentsFrame:WaitForChild("Refresh")
    v30.TasksCompletedRefreshRewardsFrame = v30.TasksCompletedRefreshFrame:WaitForChild("Rewards")
    v30.TasksCompletedRefreshButton = v30.TasksCompletedRefreshFrame:WaitForChild("Button")
    v30.TasksCompletedRefreshButtonText = v30.TasksCompletedRefreshButton:WaitForChild("Price")
    v30.ContractsFrame = v30.Container:WaitForChild("Contracts")
    v30.ContractsContainer = v30.ContractsFrame:WaitForChild("Container")
    v30.ContractsSlots = v30.ContractsContainer:WaitForChild("Slots")
    v30.ContractsLayout = v30.ContractsSlots:WaitForChild("Layout")
    v30.AdventCalendarFrame = v30.Container:WaitForChild("AdventCalendar")
    v30.AdventCalendarSlot = v_u_16.new(v30.AdventCalendarFrame)
    v30._task_containers = {}
    v30._task_slots = {}
    v30._contract_slots = {}
    v30._daily_task_streak_cleanup = {}
    v30._daily_task_streak_update_callbacks = {}
    v30:_Init()
    return v30
end
function v_u_27.Open(p_u_31, ...)
    v_u_20.Open(p_u_31, ...)
    p_u_31.AdventCalendarSlot:SetEnabled(true)
    local v32 = p_u_31._open_connections
    local v33 = v_u_13:GetDataChangedSignal("Tasks")
    table.insert(v32, v33:Connect(function()
        p_u_31:_Generate()
    end))
    local v34 = p_u_31._open_connections
    local v35 = v_u_13:GetDataChangedSignal("BonusTasks")
    table.insert(v34, v35:Connect(function()
        p_u_31:_Generate()
    end))
    local v36 = p_u_31._open_connections
    local v37 = v_u_13:GetDataChangedSignal("StatisticDuelsPlayed")
    table.insert(v36, v37:Connect(function()
        p_u_31:_Generate()
    end))
    local v38 = p_u_31._open_connections
    local v39 = v_u_13:GetDataChangedSignal("SpecialChallenges")
    table.insert(v38, v39:Connect(function()
        p_u_31:_Generate()
    end))
    local v40 = p_u_31._open_connections
    local v41 = v_u_13:GetDataChangedSignal("BeginnerTasksCompleted")
    table.insert(v40, v41:Connect(function()
        p_u_31:_Generate()
    end))
    local v42 = p_u_31._open_connections
    local v43 = v_u_13:GetDataChangedSignal("DailyTaskStreak")
    table.insert(v42, v43:Connect(function()
        p_u_31:_Generate()
    end))
    local v44 = p_u_31._open_connections
    local v45 = v_u_15.TimerUpdated
    table.insert(v44, v45:Connect(function()
        p_u_31:_Generate()
    end))
    p_u_31:_Generate()
end
function v_u_27.Close(p46, ...)
    v_u_15:OnStep("TaskPage", nil, nil)
    p46.AdventCalendarSlot:SetEnabled(false)
    v_u_20.Close(p46, ...)
end
function v_u_27._CreateDailyTaskStreakSlot(p_u_47, p48)
    local v_u_49 = p48 or false
    local v_u_50 = v_u_23:Clone()
    local function v70(p51, p52)
        local v53 = v_u_13:Get("DailyTaskStreak")
        if v53 > 0 then
            if p51 then
                p51 = v_u_49 == p52
            end
        else
            p51 = false
        end
        v_u_50.Container.StreakContainer.Streak.Value.Text = v_u_10:PrettyNumber(v53)
        v_u_50.Container.StreakContainer.Streak.Visible = v53 > 0
        v_u_50.Container.StreakContainer.StreakZero.Visible = v53 == 0
        v_u_50.Visible = p51
        if p51 then
            local v54 = (v53 - 1) / v_u_9.NUM_DAILY_TASK_STREAK_REWARD_MILESTONES
            local v55 = math.floor(v54) * v_u_9.NUM_DAILY_TASK_STREAK_REWARD_MILESTONES + 1
            for v56 = v55, v55 + v_u_9.NUM_DAILY_TASK_STREAK_REWARD_MILESTONES - 1 do
                local v57 = v_u_9.DailyTaskStreakRewards[(v56 - 1) % v_u_9.NUM_DAILY_TASK_STREAK_REWARD_MILESTONES + 1]
                local v58
                if v57.CanMultiplyRewards then
                    local v59 = v_u_9.DAILY_TASK_STREAK_REWARD_MAX_MULTIPLIER
                    local v60 = v56 / v_u_9.NUM_DAILY_TASK_STREAK_REWARD_MILESTONES
                    local v61 = math.ceil(v60)
                    v58 = math.min(v59, v61)
                else
                    v58 = 1
                end
                if v56 < v53 then
                    local v62 = v_u_21:Clone()
                    v62.LayoutOrder = v56
                    v62.Parent = v_u_50.Container.Milestones
                    local v63 = p_u_47._daily_task_streak_cleanup
                    table.insert(v63, v62)
                else
                    local v64 = v_u_22:Clone()
                    v64.LayoutOrder = v56
                    v64.NextRewardBackground.Visible = false
                    v64.Streak.Value.Text = v_u_10:PrettyNumber(v56)
                    v64.Streak.Visible = false
                    v64.Parent = v_u_50.Container.Milestones
                    local v65 = p_u_47._daily_task_streak_cleanup
                    table.insert(v65, v64)
                    for _, v66 in pairs(v57.Rewards or {}) do
                        local v67 = v_u_10:CloneTable(v66)
                        v67.Quantity = (v67.Quantity or 1) * v58
                        local v68 = v_u_18.new(v67)
                        v68:SetParent(v64)
                        local v69 = p_u_47._daily_task_streak_cleanup
                        table.insert(v69, v68)
                    end
                end
            end
        end
    end
    local v71 = p_u_47._daily_task_streak_update_callbacks
    table.insert(v71, v70)
    v70()
    return v_u_50
end
function v_u_27._UpdateDailyTaskStreak(p72, ...)
    for _, v73 in pairs(p72._daily_task_streak_cleanup) do
        v73:Destroy()
    end
    p72._daily_task_streak_cleanup = {}
    for _, v74 in pairs(p72._daily_task_streak_update_callbacks) do
        v74(...)
    end
end
function v_u_27._Generate(p_u_75)
    for _, v76 in pairs(p_u_75._task_slots) do
        v76:Destroy()
    end
    for _, v77 in pairs(p_u_75._contract_slots) do
        v77:Destroy()
    end
    p_u_75._task_slots = {}
    p_u_75._contract_slots = {}
    local v78 = v_u_13:Get("BeginnerTasksCompleted")
    local v79 = v_u_9.NUM_BEGINNER_TASKS <= v78
    local v80 = v_u_13:AreTasksCompleted()
    local v81 = v_u_7.IS_ACTIVE
    if v81 then
        v81 = v_u_13:GetStatistic("StatisticDuelsPlayed") >= v_u_7.NUM_GAMES_NEEDED_TO_PARTICIPATE
    end
    p_u_75.TasksCompletedFrame.Visible = v80
    local v82 = p_u_75.ToShootingRangeButton
    local v83 = v_u_3.SHOOTING_RANGE_ACTIVE
    if v83 then
        v83 = v78 <= v_u_9.NUM_BEGINNER_TASKS - 2
    end
    v82.Visible = v83
    local v84 = p_u_75.ToDuelsButton
    local v85 = v_u_3.QUEUES_ACTIVE
    if v85 then
        v85 = v_u_9.NUM_BEGINNER_TASKS - 1 <= v78
    end
    v84.Visible = v85
    p_u_75.ContractsFrame.Visible = v79
    local v86 = p_u_75._task_containers.SpecialChallenges
    local v87
    if v_u_13:Get("SpecialChallenges") == nil then
        v87 = false
    else
        v87 = not v_u_13:AreTasksCompleted("SpecialChallenges")
    end
    v86.Visible = v87
    p_u_75._task_containers.EventTasks.Visible = v80 and v81
    p_u_75._task_containers.BonusTasks.Visible = v80
    p_u_75._task_containers.Tasks.Visible = not v80
    p_u_75._task_containers.Tasks.Container.Title.Text = v79 and "Daily Tasks" or "Beginner Tasks   [" .. v78 + 1 .. " / " .. v_u_9.NUM_BEGINNER_TASKS .. "]"
    v_u_15:OnStep("TaskPageTaskRefresh", "TaskRefresh", v80 and function(_, p88)
        p_u_75.TasksCompletedTimerText.Text = "new tasks in " .. p88
    end or nil)
    p_u_75:_GenerateTasks(v80, v79, v81)
    if v79 then
        p_u_75:_GenerateContracts()
    end
end
function v_u_27._GenerateTasks(p89, p90, p91, p92)
    local v93 = p90 and { "BonusTasks" } or { "Tasks" }
    if p90 and p92 then
        table.insert(v93, "EventTasks")
    end
    if v_u_9.SPECIAL_CHALLENGES then
        table.insert(v93, "SpecialChallenges")
    end
    for _, v94 in pairs(v93) do
        local v95 = p89._task_containers[v94]
        local v96 = v_u_13:Get(v94)
        if v96 then
            local v97
            if v94 == "SpecialChallenges" then
                v97 = v_u_9.SPECIAL_CHALLENGES_MUST_BE_COMPLETED_IN_ORDER
            else
                v97 = false
            end
            for v98, v99 in pairs(v96) do
                local v100 = v_u_19.new(v99)
                v100:ShowNotification(v94 == "Tasks")
                local v101
                if v97 then
                    if v98 > 1 then
                        v101 = not v96[v98 - 1].Completed
                    else
                        v101 = false
                    end
                else
                    v101 = v97
                end
                v100:SetLocked(v101)
                v100:SetParent(v95.Container.Contents.Slots.Container)
                local v102 = p89._task_slots
                table.insert(v102, v100)
            end
        end
    end
    p89:_UpdateDailyTaskStreak(p91, p90)
end
function v_u_27._GenerateContracts(p103)
    for v104, v105 in pairs({
        "StatisticFavoriteWeaponPrimary",
        "StatisticFavoriteWeaponSecondary",
        "StatisticFavoriteWeaponMelee",
        "StatisticFavoriteWeaponUtility"
    }) do
        local v106 = v_u_13:GetStatistic(v105)
        if v106 == "N/A" then
            v106 = v_u_3.DEFAULT_WEAPONS[v104] or v106
        end
        local v107 = v_u_6:GetWeaponContracts(v106)
        if v107 then
            for _, v108 in pairs(v107) do
                local v109 = v_u_6.Contracts[v108]
                local v110 = v_u_5.Info[v109.StatisticName]
                local v111 = v_u_13:GetWeaponStatistic(v109.Identifier, v109.StatisticName, v109.ExtraStatisticNames)
                for _, v112 in pairs(v109.Milestones) do
                    local v113, v114 = table.unpack(v112)
                    local v115 = v113 <= v111
                    if not v115 then
                        local v116 = v_u_24:Clone()
                        local v117 = v116.Progress.Bar
                        local v118 = UDim2.new
                        local v119 = v111 / v113
                        v117.Size = v118(math.clamp(v119, 0, 1), 0, 1, 2)
                        v116.Progress.Bar.BackgroundColor3 = v115 and Color3.fromRGB(100, 255, 50) or Color3.fromRGB(0, 190, 255)
                        v116.Progress.Completed.Visible = v115
                        v116.Progress.Title.Text = v110.TostringFunction(v111) .. " / " .. v110.TostringFunction(v113)
                        v116.Progress.Title.Visible = not v115
                        v116.Title.Text = v110.FullDisplayName
                        v116.Title.Icon.Image = v110.Image
                        v116.Icon.Image = v_u_8.Items[v106].Image
                        v116.Parent = p103.ContractsSlots
                        local v120 = p103._contract_slots
                        table.insert(v120, v116)
                        if v114 then
                            v_u_18.new(v114):SetParent(v116.Reward)
                        end
                        local v_u_121 = v116.Title
                        local v_u_122 = v116.Title.Icon
                        v_u_121:GetPropertyChangedSignal("TextBounds"):Connect(function()
                            v_u_122.Position = UDim2.new(0.5, -v_u_121.TextBounds.X / 2, 0.5, 0)
                        end)
                        v_u_122.Position = UDim2.new(0.5, -v_u_121.TextBounds.X / 2, 0.5, 0)
                        break
                    end
                end
            end
        end
    end
end
function v_u_27._Setup(p123)
    for v124, v125 in pairs(v_u_26) do
        local v126, v127, v128, v129, v130 = table.unpack(v125)
        local v_u_131 = v_u_25:Clone()
        v_u_131.Container.Title.Text = v127 or ""
        v_u_131.Container.Title.ImageLabel.Image = v128 or ""
        v_u_131.Container.Title.ImageLabel.Size = v129 or UDim2.new(1.5, 0, 1, 0)
        v_u_131.Container.Description.Text = v130 or ""
        v_u_131.LayoutOrder = -999 + v124
        v_u_131.Parent = p123.Container
        p123._task_containers[v126] = v_u_131
        v_u_131.Container.Contents.Slots.Container.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            v_u_131.Container.Contents.Slots.Size = UDim2.new(1, 0, 0, v_u_131.Container.Contents.Slots.Container.Layout.AbsoluteContentSize.Y)
        end)
        v_u_131.Container.Contents.Slots.Size = UDim2.new(1, 0, 0, v_u_131.Container.Contents.Slots.Container.Layout.AbsoluteContentSize.Y)
        local function v132()
            v_u_131.Size = UDim2.new(1, 0, 0, v_u_131.Container.AbsoluteSize.Y * 0.2 + v_u_131.Container.Contents.Layout.AbsoluteContentSize.Y)
            v_u_131.Visible = v_u_131.Container.Contents.Layout.AbsoluteContentSize.Y > 1
        end
        v_u_131.Container.Contents.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(v132)
        v_u_131.Container:GetPropertyChangedSignal("AbsoluteSize"):Connect(v132)
        v_u_131.Size = UDim2.new(1, 0, 0, v_u_131.Container.AbsoluteSize.Y * 0.2 + v_u_131.Container.Contents.Layout.AbsoluteContentSize.Y)
        v_u_131.Visible = v_u_131.Container.Contents.Layout.AbsoluteContentSize.Y > 1
        if v126 == "Tasks" then
            p123:_CreateDailyTaskStreakSlot(false).Parent = v_u_131.Container.Contents
        end
    end
    p123:_CreateDailyTaskStreakSlot(true).Parent = p123.TasksCompletedContentsFrame
    v_u_18.new({
        ["Name"] = "Key",
        ["Quantity"] = v_u_9.Info.Core1.Rewards[1].Quantity + v_u_9.Info.Core2.Rewards[1].Quantity + v_u_9.Info.Core3.Rewards[1].Quantity
    }):SetParent(p123.TasksCompletedRefreshRewardsFrame)
    local v133 = v_u_18.new({
        ["Name"] = v_u_9.DAILY_TASKS_RARE_REWARD,
        ["Weapon"] = "IsRandom"
    })
    v133.CosmeticSlot.Frame.Button.Title.Size = UDim2.new(0.9, 0, 0.4, 0)
    local v134 = v133.CosmeticSlot.Frame.Button.Title
    local v135 = v_u_9.DAILY_TASKS_RARE_REWARD_CHANCE * 1000
    v134.Text = math.floor(v135) / 10 .. "%"
    v133:SetParent(p123.TasksCompletedRefreshRewardsFrame)
    local v136 = v_u_18.new({
        ["Name"] = v_u_9.DAILY_TASKS_LEGENDARY_REWARD,
        ["Weapon"] = "IsRandom"
    })
    v136.CosmeticSlot.Frame.Button.Title.Size = UDim2.new(0.9, 0, 0.4, 0)
    local v137 = v136.CosmeticSlot.Frame.Button.Title
    local v138 = v_u_9.DAILY_TASKS_LEGENDARY_REWARD_CHANCE * 1000
    v137.Text = math.floor(v138) / 10 .. "%"
    v136:SetParent(p123.TasksCompletedRefreshRewardsFrame)
    v_u_12:SetRobuxText(p123.TasksCompletedRefreshButtonText, v_u_4.Products.RefreshTasks.ProductID)
end
function v_u_27._Init(p_u_139)
    p_u_139.CloseButton.MouseButton1Click:Connect(function()
        p_u_139:CloseRequest()
    end)
    p_u_139.ToShootingRangeButton.MouseButton1Click:Connect(function()
        p_u_139:CloseRequest()
        v_u_11:Enter(true)
    end)
    p_u_139.ToDuelsButton.MouseButton1Click:Connect(function()
        p_u_139:CloseRequest()
        v_u_14:ToDuels()
    end)
    p_u_139.TasksCompletedRefreshButton.MouseButton1Click:Connect(function()
        v_u_12:PromptProductPurchase(v_u_4.Products.RefreshTasks.ProductID)
    end)
    p_u_139.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p_u_139.List.CanvasSize = UDim2.new(0, 0, 0, p_u_139.Layout.AbsoluteContentSize.Y)
        p_u_139.List.Active = p_u_139.List.CanvasSize.Y.Offset > p_u_139.List.AbsoluteSize.Y
        p_u_139.List.Position = p_u_139.List.Active and UDim2.new(0.5, 0, 0, 0) or UDim2.new(0.5, 0, 0.2, 0)
        p_u_139.CloseButton.Position = p_u_139.List.Active and UDim2.new(1.075, 16, 0.0375, 0) or UDim2.new(1.075, 16, 0.2375, 0)
    end)
    p_u_139.TasksCompletedContentsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p_u_139.TasksCompletedFrame.Size = UDim2.new(1, 0, 0, p_u_139.TasksCompletedContentsLayout.AbsoluteContentSize.Y)
    end)
    p_u_139.ContractsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p_u_139.ContractsFrame.Size = UDim2.new(1, 0, 0, p_u_139.ContractsContainer.AbsoluteSize.Y * 0.2 + p_u_139.ContractsLayout.AbsoluteContentSize.Y)
    end)
    p_u_139:_Setup()
    v_u_17:Add(p_u_139.CloseButton)
    v_u_17:Add(p_u_139.ToDuelsButton)
    v_u_17:Add(p_u_139.ToShootingRangeButton)
    v_u_17:Add(p_u_139.TasksCompletedRefreshButton, nil, {
        ["HoverRatio"] = UDim2.new(0, 8, 0, 8),
        ["ReleaseRatio"] = UDim2.new(0, 8, 0, 8)
    })
end
return v_u_27._new()