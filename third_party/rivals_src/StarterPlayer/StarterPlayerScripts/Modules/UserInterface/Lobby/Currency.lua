local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("GuiService")
local v_u_3 = game:GetService("Players")
require(v1.Modules.CONSTANTS)
local v_u_4 = require(v1.Modules.CurrencyLibrary)
local v_u_5 = require(v1.Modules.EventLibrary)
require(v1.Modules.ItemLibrary)
local v_u_6 = require(v1.Modules.TaskLibrary)
local v7 = require(v1.Modules.TestLibrary)
local v_u_8 = require(v1.Modules.Utility)
local v_u_9 = require(v_u_3.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController"))
local v_u_10 = require(v_u_3.LocalPlayer.PlayerScripts.Modules.UserInterface.Lobby:WaitForChild("Matchmaking"))
local v_u_11 = require(v_u_3.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("MobileButtons"))
local v_u_12 = require(v_u_3.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Teleporting"))
local v_u_13 = require(v_u_3.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Equipment"))
local v_u_14 = require(v_u_3.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Queue"))
local v_u_15 = require(v_u_3.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Pages"))
local v_u_16 = require(v_u_3.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect"))
local v_u_17 = require(v_u_3.LocalPlayer.PlayerScripts.Modules:WaitForChild("UILibrary"))
local v_u_18 = v7:GetTestAttribute("StudioSkipOnboarding")
local v_u_19 = v_u_3.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("CurrencySlot")
local v_u_20 = {
    ["Shop"] = true,
    ["EventOverview"] = true,
    ["StreakRecovery"] = true
}
local v_u_21 = {}
v_u_21.__index = v_u_21
function v_u_21._new()
    local v22 = v_u_21
    local v23 = setmetatable({}, v22)
    v23.Frame = v_u_17:GetTo("MainFrame", "Lobby", "Currency")
    v23.Container = v23.Frame:WaitForChild("Container")
    v23._is_open = false
    v23._is_shrinked = false
    v23._currency_slots = {}
    v23._setup_update_slots_logic = false
    v23._scrolled_up_hooked = {}
    v23._scrolled_up = {}
    v23._keys_bubble = nil
    v23._keys_bubble_hash = 0
    v23:_Init()
    return v23
end
function v_u_21._UpdateOnboardingBubble(p_u_24)
    if p_u_24._keys_bubble and not v_u_18 then
        local v25 = v_u_9:Get("BeginnerTasksCompleted") >= v_u_6.NUM_BEGINNER_TASKS
        local v26 = p_u_24._keys_bubble
        local v27 = p_u_24._is_open and not (p_u_24._is_shrinked or v25)
        if v27 then
            v27 = v_u_9:GetStatistic("StatisticDuelsPlayed") >= 2
        end
        v26.Visible = v27
        p_u_24._keys_bubble_hash = p_u_24._keys_bubble_hash + 1
        local v_u_28 = p_u_24._keys_bubble_hash
        if p_u_24._keys_bubble.Visible then
            task.spawn(function()
                while v_u_28 == p_u_24._keys_bubble_hash do
                    if p_u_24._keys_bubble:IsDescendantOf(v_u_3) then
                        p_u_24._keys_bubble:TweenPosition(UDim2.new(0.5, 0, 1, 0), "Out", "Sine", 0.5, true)
                    end
                    wait(0.5)
                    if v_u_28 ~= p_u_24._keys_bubble_hash then
                        return
                    end
                    if p_u_24._keys_bubble:IsDescendantOf(v_u_3) then
                        p_u_24._keys_bubble:TweenPosition(UDim2.new(0.5, 0, 0.875, 0), "In", "Sine", 0.5, true)
                    end
                    wait(0.5)
                end
            end)
        end
    else
        return
    end
end
function v_u_21._IsScrolledUp(p29)
    for _, v30 in pairs(p29._scrolled_up) do
        if v30 then
            return true
        end
    end
end
function v_u_21._UpdateVisibility(p31)
    local v32 = ((not v_u_15.PageSystem.CurrentPage or v_u_15.PageSystem.CurrentPage.Name == "StreakRecovery") and true or false or v_u_20[v_u_15.PageSystem.CurrentPage.Name]) and (not (v_u_10:IsVisible() or v_u_13:IsUnlocking()) and (not v_u_13:IsCustomizing() and (not v_u_13.IsOpen or v_u_13:IsOpenEffectDone())) and not (v_u_14:IsVisible() or v_u_12.Enabled or (v_u_11.EditorEnabled or v_u_2.MenuIsOpen)))
    if v32 then
        v32 = not p31:_IsScrolledUp()
    end
    p31._is_open = v32
    p31._is_shrinked = false
    p31.Container:TweenPosition(p31._is_open and UDim2.new(0.5, 0, 0, 0) or UDim2.new(0.5, 0, -0.15, -30), "Out", "Quint", 0.25, true)
    p31.Container:TweenSize(p31._is_shrinked and UDim2.new(0.0375, 20, 0.0375, 20) or UDim2.new(0.075, 40, 0.075, 40), "Out", "Quint", 0.25, true)
    p31:_UpdateOnboardingBubble()
end
function v_u_21._UpdateSlots(p33)
    local v34 = v_u_15.PageSystem:GetPage("Shop")
    local v35
    if v34 then
        v35 = v34:IsOpen()
    else
        v35 = v34
    end
    local v36
    if v35 then
        v36 = v34.CurrentPage == "Ranked"
    else
        v36 = v35
    end
    local v37 = v_u_15.PageSystem:GetPage("EventOverview")
    if v37 then
        v37 = v37:IsOpen()
    end
    for v38, v39 in pairs(p33._currency_slots) do
        local v40 = v_u_4.Info[v38]
        local v41 = v_u_9:Get(v40.DataName) or 0
        local v42 = ((not v40.OnlyDisplayAboveZeroBalance or v41 > 0) and true or false) and (v38 == "Glory" and v36 or v38 ~= "Glory" and not v36)
        if v42 then
            if v35 then
                v42 = v35
            elseif v38 == "WeaponKeys" then
                v42 = true
            elseif v38 == "EventCurrency" then
                v42 = v37
            else
                v42 = false
            end
        end
        v39.Visible = v42
        v39.Title.Text = v_u_8:PrettyNumber(v41)
    end
end
function v_u_21._SetupUpdateSlotsLogic(p_u_43)
    if not p_u_43._setup_update_slots_logic then
        p_u_43._setup_update_slots_logic = true
        task.spawn(function()
            v_u_15.PageSystem:WaitForPage("EventOverview").OpenChanged:Connect(function()
                p_u_43:_UpdateSlots()
            end)
            p_u_43:_UpdateSlots()
        end)
        task.spawn(function()
            local v44 = v_u_15.PageSystem:WaitForPage("Shop")
            v44.OpenChanged:Connect(function()
                p_u_43:_UpdateSlots()
            end)
            v44.CurrentPageChanged:Connect(function()
                p_u_43:_UpdateSlots()
            end)
            p_u_43:_UpdateSlots()
        end)
    end
end
function v_u_21._SetupScrollUpLogic(p_u_45, p_u_46)
    if not p_u_45._scrolled_up_hooked[p_u_46] then
        p_u_45._scrolled_up_hooked[p_u_46] = true
        local v_u_47 = v_u_15.PageSystem:WaitForPage(p_u_46)
        v_u_47.OpenChanged:Connect(function()
            if not v_u_47:IsOpen() then
                p_u_45._scrolled_up[p_u_46] = false
            end
        end)
        v_u_47.List:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
            if v_u_47:IsOpen() and (v_u_47.List.CanvasPosition.Y <= 10 or not p_u_45._scrolled_up[p_u_46]) and (v_u_47.List.CanvasPosition.Y > 10 or p_u_45._scrolled_up[p_u_46]) then
                p_u_45._scrolled_up[p_u_46] = v_u_47.List.CanvasPosition.Y > 10
                p_u_45:_UpdateVisibility()
            end
        end)
        p_u_45:_UpdateVisibility()
    end
end
function v_u_21._Setup(p_u_48)
    for v49, v50 in pairs(v_u_4.Order) do
        local v51 = v_u_4.Info[v50]
        if not v51.IsHidden and (v50 ~= "EventCurrency" or v_u_5.IS_ACTIVE) then
            local v52 = v_u_19:Clone()
            v52.LayoutOrder = v49
            v52.Icon.Icon.Image = v51.Image
            v52.Buy.Visible = v51.CanBePurchasedWithRobux
            v52.Parent = p_u_48.Container
            p_u_48._currency_slots[v50] = v52
            v_u_9:GetDataChangedSignal(v51.DataName):Connect(function()
                p_u_48:_UpdateSlots()
            end)
            v52.Buy.MouseButton1Click:Connect(function()
                v_u_15.PageSystem:OpenPage("Shop", true)
                v_u_15.PageSystem:WaitForPage("Shop"):SetPage("Currency")
            end)
            v_u_16:Add(v52.Buy)
            if v50 == "WeaponKeys" then
                p_u_48._keys_bubble = v52.Icon.Bubble
                v52.Icon.MouseButton1Click:Connect(function()
                    v_u_15.PageSystem:OpenPage("Tasks", true)
                end)
                v_u_16:Add(v52.Icon)
            end
        end
    end
end
function v_u_21._Init(p_u_53)
    v_u_13.UnlockingChanged:Connect(function()
        p_u_53:_UpdateVisibility()
    end)
    v_u_13.Opened:Connect(function()
        p_u_53:_UpdateVisibility()
    end)
    v_u_13.SelectedWeaponChanged:Connect(function()
        p_u_53:_UpdateVisibility()
    end)
    v_u_13.CustomizingChanged:Connect(function()
        p_u_53:_UpdateVisibility()
    end)
    v_u_13.FinishedOpenEffect:Connect(function()
        p_u_53:_UpdateVisibility()
    end)
    v_u_15.PageSystem.PageOpened:Connect(function(p54)
        if v_u_20[p54.Name] then
            task.spawn(p_u_53._SetupScrollUpLogic, p_u_53, p54.Name)
            task.spawn(p_u_53._SetupUpdateSlotsLogic, p_u_53)
        end
        p_u_53:_UpdateVisibility()
    end)
    v_u_15.PageSystem.PageClosed:Connect(function()
        p_u_53:_UpdateVisibility()
    end)
    v_u_14.VisibilityChanged:Connect(function()
        p_u_53:_UpdateVisibility()
    end)
    v_u_12.EnabledChanged:Connect(function()
        p_u_53:_UpdateVisibility()
    end)
    v_u_11.EditorEnabledChanged:Connect(function()
        p_u_53:_UpdateVisibility()
    end)
    v_u_10.VisibilityChanged:Connect(function()
        p_u_53:_UpdateVisibility()
    end)
    v_u_9:GetDataChangedSignal("BeginnerTasksCompleted"):Connect(function()
        p_u_53:_UpdateOnboardingBubble()
    end)
    v_u_9:GetDataChangedSignal("StatisticDuelsPlayed"):Connect(function()
        p_u_53:_UpdateOnboardingBubble()
        p_u_53:_UpdateSlots()
    end)
    v_u_2:GetPropertyChangedSignal("MenuIsOpen"):Connect(function()
        p_u_53:_UpdateVisibility()
    end)
    p_u_53:_Setup()
    p_u_53:_UpdateSlots()
    p_u_53:_UpdateVisibility()
    p_u_53:_UpdateOnboardingBubble()
end
return v_u_21._new()