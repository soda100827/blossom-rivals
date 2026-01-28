local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.EventLibrary)
local v_u_4 = require(v1.Modules.Utility)
local v_u_5 = require(v2.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
local v_u_6 = require(v2.LocalPlayer.PlayerScripts.Controllers.EventController)
local v_u_7 = require(v2.LocalPlayer.PlayerScripts.Controllers.ShopController)
local v_u_8 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("BaseMatchmakingQueueSlot"):WaitForChild("MatchmakingQueueSlot"))
local v_u_9 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("BaseShopSlot"):WaitForChild("ShopSlot"))
local v_u_10 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("AdventCalendarSlot"))
local v_u_11 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("PromptSystem"))
local v_u_12 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect"))
local v_u_13 = require(v2.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Pages"))
local v_u_14 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("TaskSlot"))
local v_u_15 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("Page"))
local v_u_16 = setmetatable({}, v_u_15)
v_u_16.__index = v_u_16
function v_u_16._new()
    local v17 = v_u_15.new(script.Name)
    local v18 = v_u_16
    local v19 = setmetatable(v17, v18)
    v19.CloseButton = v19.PageFrame:WaitForChild("Close")
    v19.PromptsFrame = v19.PageFrame:WaitForChild("Prompts")
    v19.LockedFrame = v19.PageFrame:WaitForChild("Locked")
    v19.LockedDescriptionText = v19.LockedFrame:WaitForChild("Description")
    v19.List = v19.PageFrame:WaitForChild("List")
    v19.Container = v19.List:WaitForChild("Container")
    v19.Layout = v19.Container:WaitForChild("Layout")
    v19.HeaderFrame = v19.Container:WaitForChild("Header")
    v19.HeaderPicture = v19.HeaderFrame:WaitForChild("Picture")
    v19.HeaderTitleText = v19.HeaderFrame:WaitForChild("Title")
    v19.HeaderCountdownText = v19.HeaderFrame:WaitForChild("Countdown")
    v19.EventTasksFrame = v19.Container:WaitForChild("EventTasks")
    v19.EventTasksLockedFrame = v19.EventTasksFrame:WaitForChild("Locked")
    v19.EventTasksUnlockedFrame = v19.EventTasksFrame:WaitForChild("Unlocked")
    v19.EventTasksContainer = v19.EventTasksUnlockedFrame:WaitForChild("Container")
    v19.EventTasksTitleText = v19.EventTasksContainer:WaitForChild("Title")
    v19.EventTasksSlotsFrame = v19.EventTasksContainer:WaitForChild("Slots")
    v19.EventTasksSlotsLayout = v19.EventTasksSlotsFrame:WaitForChild("Layout")
    v19.RushFrame = v19.EventTasksUnlockedFrame:WaitForChild("Rush")
    v19.RushTitleText = v19.RushFrame:WaitForChild("Title")
    v19.RushProgressFrame = v19.RushFrame:WaitForChild("Progress")
    v19.RushProgressBar = v19.RushProgressFrame:WaitForChild("Bar")
    v19.RushProgressCompleted = v19.RushProgressFrame:WaitForChild("Completed")
    v19.RushProgressText = v19.RushProgressFrame:WaitForChild("Title")
    v19.ShopEntriesFrame = v19.Container:WaitForChild("ShopEntries")
    v19.ShopEntriesContainer = v19.ShopEntriesFrame:WaitForChild("Container")
    v19.ShopEntriesTitleText = v19.ShopEntriesContainer:WaitForChild("Title")
    v19.ShopEntriesSlotsFrame = v19.ShopEntriesContainer:WaitForChild("Slots")
    v19.ShopEntriesSlotsLayout = v19.ShopEntriesSlotsFrame:WaitForChild("Layout")
    v19.AdventCalendarFrame = v19.Container:WaitForChild("AdventCalendar")
    v19.PromptSystem = v_u_11.new(v19.PromptsFrame)
    v19.AdventCalendarSlot = v_u_10.new(v19.AdventCalendarFrame)
    v19._open_connections = {}
    v19._task_slots = {}
    v19._shop_slots = {}
    v19:_Init()
    return v19
end
function v_u_16.Open(p_u_20, ...)
    v_u_15.Open(p_u_20, ...)
    p_u_20.AdventCalendarSlot:SetEnabled(true)
    local v21 = p_u_20._open_connections
    local v22 = v_u_5:GetDataChangedSignal("Tasks")
    table.insert(v21, v22:Connect(function()
        p_u_20:_GenerateTasks()
    end))
    local v23 = p_u_20._open_connections
    local v24 = v_u_5:GetDataChangedSignal("EventTasks")
    table.insert(v23, v24:Connect(function()
        p_u_20:_GenerateTasks()
    end))
    local v25 = p_u_20._open_connections
    local v26 = v_u_5:GetDataChangedSignal("CosmeticInventory")
    table.insert(v25, v26:Connect(function()
        p_u_20:_GenerateShopEntries()
    end))
    local v27 = p_u_20._open_connections
    local v28 = v_u_5:GetDataChangedSignal("WeaponInventory")
    table.insert(v27, v28:Connect(function()
        p_u_20:_GenerateShopEntries()
    end))
    local v29 = p_u_20._open_connections
    local v30 = v_u_5:GetDataChangedSignal("EventCurrencyRushProgress")
    table.insert(v29, v30:Connect(function()
        p_u_20:_UpdateRush()
    end))
    local v31 = p_u_20._open_connections
    local v32 = v_u_5:GetDataChangedSignal("StatisticDuelsPlayed")
    table.insert(v31, v32:Connect(function()
        p_u_20:_UpdateLocked()
    end))
    task.spawn(function()
        local v33 = p_u_20._is_open_hash
        while v33 == p_u_20._is_open_hash do
            p_u_20:_UpdateCountdown()
            wait(1)
        end
    end)
    p_u_20:_UpdateRush()
    p_u_20:_UpdateCountdown()
    p_u_20:_UpdateLocked()
    p_u_20:_GenerateTasks()
    p_u_20:_GenerateShopEntries()
end
function v_u_16.Close(p34, ...)
    p34.AdventCalendarSlot:SetEnabled(false)
    v_u_15.Close(p34, ...)
end
function v_u_16._UpdateLocked(p35)
    local v36 = v_u_3.NUM_GAMES_NEEDED_TO_PARTICIPATE - v_u_5:GetStatistic("StatisticDuelsPlayed")
    p35.List.Visible = v36 <= 0
    p35.LockedFrame.Visible = v36 > 0
    p35.LockedDescriptionText.Text = "Play " .. v36 .. " more duels to gain access!"
end
function v_u_16._UpdateCountdown(p37)
    local v38 = v_u_6:GetTimeRemaining()
    p37.HeaderCountdownText.Text = v38 and v38 == 0 and "Ending any minute now!" or (v38 and (v38 > 0 and "Ending in " .. v_u_4:TimeFormat2(v38)) or "Here for a limited time only!")
end
function v_u_16._UpdateRush(p39)
    local v40 = v_u_5:Get("EventCurrencyRushProgress")
    local v41 = v40 / v_u_3.CURRENCY_RUSH_DAILY_LIMIT
    local v42 = math.clamp(v41, 0, 1)
    p39.RushProgressText.Text = v42 < 1 and v40 .. " / " .. v_u_3.CURRENCY_RUSH_DAILY_LIMIT or ""
    p39.RushProgressCompleted.Visible = v42 >= 1
    p39.RushProgressBar.Size = UDim2.new(v42, 0, 1, 2)
    p39.RushProgressBar.BackgroundColor3 = v42 < 1 and v_u_3.EVENT_DETAILS.CURRENCY_COLOR or Color3.fromRGB(100, 255, 50)
end
function v_u_16._GenerateTasks(p43, _)
    for _, v44 in pairs(p43._task_slots) do
        v44:Destroy()
    end
    p43._task_slots = {}
    p43.EventTasksLockedFrame.Visible = not v_u_5:AreTasksCompleted()
    p43.EventTasksUnlockedFrame.Visible = not p43.EventTasksLockedFrame.Visible
    local v45 = v_u_5:Get("EventTasks")
    for _, v46 in pairs(v45 or {}) do
        local v47 = v_u_14.new(v46)
        v47:SetParent(p43.EventTasksSlotsFrame)
        local v48 = p43._task_slots
        table.insert(v48, v47)
    end
end
function v_u_16._GenerateShopEntries(p_u_49)
    for _, v50 in pairs(p_u_49._shop_slots) do
        v50:Destroy()
    end
    p_u_49._shop_slots = {}
    for _, v51 in pairs(v_u_3.IS_ACTIVE and v_u_3.SHOP_ENTRIES_OVERVIEW or {}) do
        local v_u_52 = v_u_9.new(v_u_7:GetShopEntry(v51))
        v_u_52.Frame.Parent = p_u_49.ShopEntriesSlotsFrame
        local v53 = p_u_49._shop_slots
        table.insert(v53, v_u_52)
        v_u_52.RewardSlot:OnClick(function()
            if not (v_u_52.IsLocked or v_u_52.IsOwned) then
                p_u_49.PromptSystem:Open("InspectShopEntry", v_u_52.ShopEntry.EntryName)
            end
        end)
    end
end
function v_u_16._Setup(p_u_54)
    p_u_54.HeaderPicture.Image = v_u_3.EVENT_DETAILS.OVERVIEW_BANNER_IMAGE
    p_u_54.HeaderTitleText.Text = string.upper(v_u_3.EVENT_NAME or "???") .. " EVENT"
    p_u_54.EventTasksTitleText.Text = "Earn " .. v_u_3.EVENT_DETAILS.CURRENCY_NAME_PLURAL .. "!"
    p_u_54.ShopEntriesTitleText.Text = "Spend " .. v_u_3.EVENT_DETAILS.CURRENCY_NAME_PLURAL .. "!"
    p_u_54.RushTitleText.Text = string.upper(v_u_3.EVENT_DETAILS.CURRENCY_NAME) .. " RUSH \226\128\148 Earn \195\151" .. v_u_3.CURRENCY_RUSH_MULTIPLIER .. " " .. v_u_3.EVENT_DETAILS.CURRENCY_NAME_PLURAL .. " every day!"
    for v55, v56 in pairs(v_u_3.LTM_QUEUENAMES or {}) do
        local v57 = Instance.new("Frame")
        v57.Name = v56
        v57.AnchorPoint = Vector2.new(0.5, 0.5)
        v57.Size = UDim2.new(0.995, 0, 0.2, 0)
        v57.BackgroundTransparency = 1
        v57.LayoutOrder = 10 + v55
        v57.Parent = p_u_54.Container
        v_u_8.new(v56, v57).QueueStatus:Connect(function(p58)
            if p58 == "Success" then
                p_u_54:CloseRequest()
            else
                p_u_54.PromptSystem:Open("ErrorMessage", "Woops!", p58 or "Server failed to respond, please try again")
            end
        end)
    end
    v_u_7:GetDailyShop()
end
function v_u_16._Init(p_u_59)
    p_u_59.CloseButton.MouseButton1Click:Connect(function()
        p_u_59:CloseRequest()
    end)
    p_u_59.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p_u_59.List.CanvasSize = UDim2.new(0, 0, 0, p_u_59.Layout.AbsoluteContentSize.Y)
    end)
    p_u_59.EventTasksSlotsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p_u_59.EventTasksFrame.Size = UDim2.new(1, 0, 0, p_u_59.EventTasksContainer.AbsoluteSize.Y * 0.2 + p_u_59.EventTasksSlotsLayout.AbsoluteContentSize.Y + p_u_59.RushFrame.AbsoluteSize.Y)
    end)
    p_u_59.ShopEntriesSlotsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p_u_59.ShopEntriesFrame.Size = UDim2.new(1, 0, 0, p_u_59.ShopEntriesContainer.AbsoluteSize.Y * 0.3 + p_u_59.ShopEntriesSlotsLayout.AbsoluteContentSize.Y)
    end)
    p_u_59.PromptSystem.PromptAdded:Connect(function(p60)
        p_u_59.List.CanvasPosition = Vector2.new(0, 0)
        if p60.InspectCurrencyPage then
            p60.InspectCurrencyPage:Connect(function()
                v_u_13.PageSystem:OpenPage("Shop")
                v_u_13.PageSystem:WaitForPage("Shop"):SetPage("Currency")
            end)
        end
    end)
    p_u_59:_Setup()
    p_u_59:_UpdateRush()
    p_u_59:_UpdateCountdown()
    p_u_59:_UpdateLocked()
    p_u_59:_GenerateTasks()
    p_u_59:_GenerateShopEntries()
    v_u_12:Add(p_u_59.CloseButton)
end
return v_u_16._new()