local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("GuiService")
local v3 = game:GetService("Players")
local v_u_4 = require(v1.Modules.CONSTANTS)
local v_u_5 = require(v1.Modules.StatisticsLibrary)
local v_u_6 = require(v1.Modules.ContractsLibrary)
local v_u_7 = require(v1.Modules.TaskLibrary)
local v_u_8 = require(v1.Modules.ItemLibrary)
local v_u_9 = require(v3.LocalPlayer.PlayerScripts.Controllers:WaitForChild("ShootingRangeController"))
local v_u_10 = require(v3.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController"))
local v_u_11 = require(v3.LocalPlayer.PlayerScripts.Controllers:WaitForChild("SpectateController"))
local v_u_12 = require(v3.LocalPlayer.PlayerScripts.Controllers:WaitForChild("FighterController"))
local v_u_13 = require(v3.LocalPlayer.PlayerScripts.Controllers:WaitForChild("LobbyController"))
local v_u_14 = require(v3.LocalPlayer.PlayerScripts.Controllers:WaitForChild("TimerController"))
local v_u_15 = require(v3.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("MobileButtons"))
local v_u_16 = require(v3.LocalPlayer.PlayerScripts.Modules:WaitForChild("WeaponStatusHandler"))
local v_u_17 = require(v3.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Teleporting"))
local v_u_18 = require(v3.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Equipment"))
local v_u_19 = require(v3.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Pages"))
local v_u_20 = require(v3.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Queue"))
local v_u_21 = require(v3.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect"))
local v_u_22 = require(v3.LocalPlayer.PlayerScripts.Modules:WaitForChild("RewardSlot"))
local v_u_23 = require(v3.LocalPlayer.PlayerScripts.Modules:WaitForChild("UILibrary"))
local v_u_24 = v3.LocalPlayer.PlayerScripts:WaitForChild("UserInterface"):WaitForChild("ContractSideSlot")
local v_u_25 = v3.LocalPlayer.PlayerScripts:WaitForChild("UserInterface"):WaitForChild("TaskSideSlot")
local v_u_26 = {}
v_u_26.__index = v_u_26
function v_u_26._new()
    local v27 = v_u_26
    local v28 = setmetatable({}, v27)
    v28.Frame = v_u_23:GetTo("MainFrame", "SideTasks")
    v28.LocalFighter = nil
    v28._side_slots = {}
    v28._duel_connections = {}
    v28._teleport_cooldown = 0
    v28._generate_queued = false
    v28:_Init()
    return v28
end
function v_u_26._UpdateBackground(p29)
    local v30 = p29.Frame.Container.Slots.Position.Y.Scale - p29.Frame.Container.Background.Position.Y.Scale
    local v31 = p29.Frame.Container.Slots.Layout.AbsoluteContentSize.Y + (not p29.Frame.Container.Slots.ButtonsBuffer.Visible and 0 or -p29.Frame.Container.Slots.ButtonsBuffer.AbsoluteSize.Y) + (not p29.Frame.Container.Slots.ToDuels.Visible and 0 or -p29.Frame.Container.Slots.ToDuels.AbsoluteSize.Y) + (not p29.Frame.Container.Slots.ToShootingRange.Visible and 0 or -p29.Frame.Container.Slots.ToShootingRange.AbsoluteSize.Y)
    p29.Frame.Container.Background.Size = UDim2.new(1, 0, v30, v31)
end
function v_u_26._Generate(p_u_32)
    for _, v33 in pairs(p_u_32._side_slots) do
        v33:Destroy()
    end
    p_u_32._side_slots = {}
    v_u_16:ClearStatusElements(p_u_32.Frame.Container.Title)
    p_u_32._generate_cooldown = tick() + 0.2
    local v34 = v_u_10:GetStatistic("StatisticFavoriteWeapon")
    local v35 = p_u_32.LocalFighter and p_u_32.LocalFighter.EquippedItem and p_u_32.LocalFighter.EquippedItem.Name or ((v34 == "N/A" or not v34) and "Assault Rifle" or v34)
    local v36 = v_u_10:Get("BeginnerTasksCompleted")
    local v37 = v_u_7.NUM_BEGINNER_TASKS <= v36
    local v38 = p_u_32.LocalFighter and not (v_u_19.PageSystem.CurrentPage or v_u_18.IsOpen) and not (v_u_20:IsVisible() or v_u_17.Enabled or (v_u_15.EditorEnabled or v_u_2.MenuIsOpen)) and (((not v_u_10:Get("Settings Hide Tasks In Duels") or (not v_u_11.CurrentDuelSubject or v_u_11.CurrentDuelSubject:Get("Status") == "RoundStarting")) and true or false) and ((not v_u_11.CurrentDuelSubject or v_u_11.CurrentDuelSubject.LocalDueler and (v_u_11.CurrentDuelSubject:Get("Status") ~= "GameOver" and not v_u_11.CurrentDuelSubject.DuelInterface.Voting:IsOpen() and not (v_u_11.CurrentDuelSubject.DuelInterface.Scoreboard:IsOpen() or v_u_11.CurrentDuelSubject:Get("HideMostDuelInterfaceElements")))) and (not v_u_10:Get("Settings Hide HUD") and (v_u_10:GetStatistic("StatisticDuelsPlayed") < 2 and p_u_32.LocalFighter))))
    if v38 then
        v38 = p_u_32.LocalFighter:Get("IsInShootingRange")
    end
    local v39
    if v38 then
        v39 = v_u_10:Get("TasksInterfaceOverride") ~= nil
    else
        v39 = v38
    end
    local v40 = not v39
    if v40 then
        if v38 then
            v40 = not v_u_10:AreTasksCompleted()
        else
            v40 = v38
        end
    end
    local v41 = not (v39 or v40)
    if v41 then
        if v38 then
            v38 = #v_u_6:GetWeaponContracts(v35) > 0
        end
    else
        v38 = v41
    end
    local v42 = v39 or (v40 or v38)
    local v43 = p_u_32.Frame.Container.Slots.ToShootingRange
    local v44 = v_u_4.SHOOTING_RANGE_ACTIVE and (v40 and (v36 <= v_u_7.NUM_BEGINNER_TASKS - 2 and (p_u_32.LocalFighter and not p_u_32.LocalFighter:Get("IsInShootingRange"))))
    if v44 then
        v44 = not v_u_11.CurrentDuelSubject
    end
    v43.Visible = v44
    local v45 = p_u_32.Frame.Container.Slots.ToDuels
    local v46 = v_u_4.QUEUES_ACTIVE and not (v39 or p_u_32.Frame.Container.Slots.ToShootingRange.Visible)
    if v46 then
        v46 = not v_u_11.CurrentDuelSubject
    end
    v45.Visible = v46
    p_u_32.Frame.Container.Title.Text = v39 and "Special Mission" or (v38 and v35 and v35 or (v40 and (v37 and "Daily Tasks" or ("Beginner Tasks   [" .. v36 + 1 .. " / " .. v_u_7.NUM_BEGINNER_TASKS .. "]" or "")) or ""))
    p_u_32.Frame.Container.Title.Icon.Image = v38 and (v_u_8.ViewModels[v35].Image or "rbxassetid://17653923757") or "rbxassetid://17653923757"
    p_u_32.Frame.Container.Title.Icon.Size = v38 and UDim2.new(6, 0, 4.5, 0) or UDim2.new(2, 0, 1.5, 0)
    if not v39 and v38 then
        v_u_16:ApplyItemStatusToText(p_u_32.Frame.Container.Title, v_u_8.Items[v35].Status)
    end
    local function v60(p47, p48)
        local v49 = p48.TaskInfo or v_u_7.Info[p48.Name]
        local v50 = p48.Goal or v49.Goal
        local v51 = v50 <= p48.Progress
        local v52 = v_u_25:Clone()
        v52.LayoutOrder = p47
        local v53 = v52.Container.Progress.Bar
        local v54 = UDim2.new
        local v55 = p48.Progress / v50
        v53.Size = v54(math.clamp(v55, 0, 1), 0, 1, 2)
        v52.Container.Progress.Bar.BackgroundColor3 = v51 and Color3.fromRGB(100, 255, 50) or Color3.fromRGB(0, 190, 255)
        v52.Container.Title.Text = v49.Title
        v52.Container.Goal.Text = p48.Progress .. " / " .. v50
        v52.Container.Goal.Visible = not v51
        v52.Container.Icon.Image = v49.Icon
        v52.Completed.Visible = v51
        v52.Parent = p_u_32.Frame.Container.Slots
        local v56 = p_u_32._side_slots
        table.insert(v56, v52)
        if not v51 then
            for _, v57 in pairs({ v49.Rewards, p48.BonusRewards or {} }) do
                for _, v58 in pairs(v57) do
                    local v59 = v_u_22.new(v58)
                    v59:SetBubbleAutoCloseDelay(3)
                    v59:SetParent(v52.Reward)
                end
            end
        end
    end
    if v39 then
        for v61, v62 in pairs(v_u_10:Get("TasksInterfaceOverride")) do
            v60(v61, v62)
        end
    end
    if v40 then
        for v63, v64 in pairs(v_u_10:Get("Tasks")) do
            v60(v63, v64)
        end
    end
    local v65
    if v38 then
        v65 = true
        for v66, v67 in pairs(v_u_6:GetWeaponContracts(v35)) do
            local v68 = v_u_6.Contracts[v67]
            local v69 = v_u_5.Info[v68.StatisticName]
            local v70 = v_u_10:GetWeaponStatistic(v68.Identifier, v68.StatisticName, v68.ExtraStatisticNames)
            for _, v71 in pairs(v68.Milestones) do
                local v72, v73 = table.unpack(v71)
                if v72 > v70 then
                    v65 = false
                    local v74 = v_u_24:Clone()
                    v74.LayoutOrder = v66
                    local v75 = v74.Container.Progress.Bar
                    local v76 = UDim2.new
                    local v77 = v70 / v72
                    v75.Size = v76(math.clamp(v77, 0, 1), 0, 1, 2)
                    v74.Container.Goal.Text = v69.TostringFunction(v70) .. " / " .. v69.TostringFunction(v72)
                    v74.Container.Title.Text = v68.FullDisplayName
                    v74.Parent = p_u_32.Frame.Container.Slots
                    local v78 = p_u_32._side_slots
                    table.insert(v78, v74)
                    if v73 then
                        local v79 = v_u_22.new(v73)
                        v79:SetBubbleAutoCloseDelay(3)
                        v79.Frame.Parent = v74.Reward
                    end
                    break
                end
            end
        end
    else
        v65 = false
    end
    p_u_32.Frame.Container.Slots.ContractsCompleted.Visible = v65
    p_u_32.Frame.Container.Slots.ContractsCompleted.Title.Text = "Congratulations! You\'ve completed all " .. v35 .. " contracts!"
    v_u_14:OnStep("LobbyTasks", "TaskRefresh", v40 and (v37 and v_u_10:AreTasksCompleted()) and function(_, p80)
        p_u_32.Frame.Container.Title.Text = "New tasks in " .. p80
    end or nil)
    p_u_32.Frame.Container:TweenPosition(v42 and UDim2.new(0, 10, 0.5, 0) or UDim2.new(-1, -10, 0.5, 0), "Out", "Quint", v42 and 0.25 or 1.25, true)
    p_u_32:_UpdateBackground()
end
function v_u_26._GenerateThrottled(p_u_81)
    if tick() > p_u_81._generate_cooldown then
        p_u_81:_Generate()
        return
    elseif not p_u_81._generate_queued then
        p_u_81._generate_queued = true
        task.delay(p_u_81._generate_cooldown - tick(), function()
            p_u_81._generate_queued = false
            p_u_81:_Generate()
        end)
    end
end
function v_u_26._UpdateCurrentDuelSubject(p_u_82)
    for _, v83 in pairs(p_u_82._duel_connections) do
        v83:Disconnect()
    end
    p_u_82._duel_connections = {}
    if v_u_11.CurrentDuelSubject then
        local v84 = p_u_82._duel_connections
        local v85 = v_u_11.CurrentDuelSubject:GetDataChangedSignal("Status")
        table.insert(v84, v85:Connect(function()
            p_u_82:_Generate()
        end))
        local v86 = p_u_82._duel_connections
        local v87 = v_u_11.CurrentDuelSubject:GetDataChangedSignal("HideMostDuelInterfaceElements")
        table.insert(v86, v87:Connect(function()
            p_u_82:_Generate()
        end))
        local v88 = p_u_82._duel_connections
        local v89 = v_u_11.CurrentDuelSubject.DuelInterface.Voting.VisibilityChanged
        table.insert(v88, v89:Connect(function()
            p_u_82:_Generate()
        end))
        local v90 = p_u_82._duel_connections
        local v91 = v_u_11.CurrentDuelSubject.DuelInterface.Scoreboard.VisibilityChanged
        table.insert(v90, v91:Connect(function()
            p_u_82:_Generate()
        end))
        p_u_82:_Generate()
    else
        p_u_82:_Generate()
    end
end
function v_u_26._HookLocalFighter(p_u_92)
    p_u_92.LocalFighter = v_u_12:WaitForLocalFighter()
    p_u_92.LocalFighter:GetDataChangedSignal("IsInShootingRange"):Connect(function()
        p_u_92:_Generate()
    end)
    p_u_92.LocalFighter:GetDataChangedSignal("IsInDuel"):Connect(function()
        p_u_92:_Generate()
    end)
    p_u_92.LocalFighter.EquippedItemChanged:Connect(function()
        p_u_92:_GenerateThrottled()
    end)
    p_u_92:_Generate()
end
function v_u_26._Init(p_u_93)
    p_u_93.Frame.Container.Slots.ToShootingRange.MouseButton1Click:Connect(function()
        if tick() >= p_u_93._teleport_cooldown then
            p_u_93._teleport_cooldown = tick() + 1
            v_u_9:Enter(true)
        end
    end)
    p_u_93.Frame.Container.Slots.ToDuels.MouseButton1Click:Connect(function()
        if tick() >= p_u_93._teleport_cooldown then
            p_u_93._teleport_cooldown = tick() + 1
            v_u_13:ToDuels()
        end
    end)
    p_u_93.Frame.Container.Slots.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p_u_93:_UpdateBackground()
    end)
    p_u_93.Frame.Container.Slots:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        p_u_93:_UpdateBackground()
    end)
    v_u_10:GetDataChangedSignal("BeginnerTasksCompleted"):Connect(function()
        p_u_93:_Generate()
    end)
    v_u_10:GetDataChangedSignal("Tasks"):Connect(function()
        p_u_93:_Generate()
    end)
    v_u_10:GetDataChangedSignal("Settings Hide Tasks In Duels"):Connect(function()
        p_u_93:_Generate()
    end)
    v_u_10:GetDataChangedSignal("Settings Hide HUD"):Connect(function()
        p_u_93:_Generate()
    end)
    v_u_10:GetDataChangedSignal("StatisticDuelsPlayed"):Connect(function()
        p_u_93:_Generate()
    end)
    v_u_10:GetDataChangedSignal("TasksInterfaceOverride"):Connect(function()
        p_u_93:_Generate()
    end)
    v_u_10.StatisticsUpdated:Connect(function()
        p_u_93:_Generate()
    end)
    v_u_18.Opened:Connect(function()
        p_u_93:_Generate()
    end)
    v_u_19.PageSystem.PageOpened:Connect(function()
        p_u_93:_Generate()
    end)
    v_u_19.PageSystem.PageClosed:Connect(function()
        p_u_93:_Generate()
    end)
    v_u_20.VisibilityChanged:Connect(function()
        p_u_93:_Generate()
    end)
    v_u_17.EnabledChanged:Connect(function()
        p_u_93:_Generate()
    end)
    v_u_15.EditorEnabledChanged:Connect(function()
        p_u_93:_Generate()
    end)
    v_u_11.DuelSubjectChanged:Connect(function()
        p_u_93:_UpdateCurrentDuelSubject()
    end)
    v_u_2:GetPropertyChangedSignal("MenuIsOpen"):Connect(function()
        p_u_93:_Generate()
    end)
    p_u_93:_Generate()
    p_u_93:_UpdateCurrentDuelSubject()
    p_u_93:_UpdateBackground()
    task.spawn(p_u_93._HookLocalFighter, p_u_93)
    v_u_21:Add(p_u_93.Frame.Container.Slots.ToDuels)
    v_u_21:Add(p_u_93.Frame.Container.Slots.ToShootingRange)
end
return v_u_26._new()