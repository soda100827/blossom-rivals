local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.CosmeticLibrary)
local v_u_4 = require(v1.Modules.EventLibrary)
local v_u_5 = require(v1.Modules.Utility)
local v_u_6 = require(v1.Modules.Signal)
local v_u_7 = require(v2.LocalPlayer.PlayerScripts.Controllers:WaitForChild("ComplianceController"))
local v_u_8 = require(v2.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController"))
local v_u_9 = require(v2.LocalPlayer.PlayerScripts.Controllers:WaitForChild("ShopController"))
local v_u_10 = require(v2.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Equipment"))
local v_u_11 = require(v2.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Spotlight"))
local v_u_12 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("BaseShopSlot"):WaitForChild("ShopSlot"))
local v_u_13 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("PromptSystem"))
local v_u_14 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("BundleSlot"))
local v_u_15 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("Page"))
local v_u_16 = require(script:WaitForChild("BottomTabs"))
local v_u_17 = require(script:WaitForChild("Pages"))
local v_u_18 = require(script:WaitForChild("Tabs"))
local v_u_19 = {
    "rpg_bundle",
    "energy_bundle",
    "pixel_bundle",
    "starter_bundle",
    "medkit_bundle",
    "exogun_bundle",
    "heavyduty_bundle",
    "classic_bundle",
    "standardweapons_bundle"
}
local v_u_20 = {
    "Home",
    "Bundles",
    "Daily",
    "Currency",
    "Ranked",
    "Weapons",
    "Gifting",
    "Rewards"
}
local v_u_21 = setmetatable({}, v_u_15)
v_u_21.__index = v_u_21
function v_u_21._new()
    local v22 = v_u_15.new(script.Name)
    local v23 = v_u_21
    local v24 = setmetatable(v22, v23)
    v24.CurrentPageChanged = v_u_6.new()
    v24.PromptsFrame = v24.PageFrame:WaitForChild("Prompts")
    v24.WaitingFrame = v24.PageFrame:WaitForChild("Waiting")
    v24.DotsFrame = v24.WaitingFrame:WaitForChild("Dots")
    v24.List = v24.PageFrame:WaitForChild("List")
    v24.Container = v24.List:WaitForChild("Container")
    v24.BUNDLE_NAMES = v_u_19
    v24.PAGE_NAMES = v_u_20
    v24.HidePartyDisplay = true
    v24.CurrentPage = nil
    v24.PromptSystem = v_u_13.new(v24.PromptsFrame)
    v24.Tabs = v_u_18.new(v24)
    v24.Pages = v_u_17.new(v24)
    v24.BottomTabs = v_u_16.new(v24)
    v24._open_animation_disabled = true
    v24._setup_finished = false
    v24._setup_finished_event_internal = v_u_6.new()
    v24._bundle_slots = {}
    v24:_Init()
    return v24
end
function v_u_21.SetPage(p25, p26)
    v_u_11:ChangeSubject(nil)
    if p26 == "Weapons" then
        v_u_10:Open(true)
        p25:CloseRequest()
        return
    elseif p26 == "Gifting" then
        p25.OpenPage:Fire("Gifting")
        return
    elseif p26 == "Rewards" then
        p25.OpenPage:Fire("Rewards")
        return
    elseif p26 == "BattlePass" then
        p25.OpenPage:Fire("BattlePass")
    else
        p25.CurrentPage = p26
        p25.CurrentPageChanged:Fire(p25.CurrentPage)
    end
end
function v_u_21.InspectShopEntry(p27, p28)
    if p28 then
        p27.PromptSystem:Open("InspectShopEntry", p28)
    end
end
function v_u_21.InspectBundle(p_u_29, p_u_30, p_u_31)
    if p_u_30 then
        task.defer(function()
            if not p_u_29._setup_finished then
                p_u_29._setup_finished_event_internal:Wait()
            end
            p_u_29.PromptSystem:Open("InspectBundle", p_u_30, p_u_29._bundle_slots[p_u_30], p_u_31)
        end)
    end
end
function v_u_21.CreateShopSlot(p_u_32, p33, p34, p35, ...)
    local v36 = v_u_5:CloneTable(v_u_9:GetShopEntry(p35))
    local v37 = p33 or v_u_12
    if p34 then
        p34.BackgroundTransparency = 1
    end
    for _, v38 in pairs(v36.Rewards) do
        local v39 = v_u_3.Rewards[v38.Name]
        if v39 and v39.Type == "Lootbox" then
            v_u_7:ArePaidRandomItemsRestricted()
        end
    end
    local v_u_40 = v37.new(v36, ...)
    v_u_40.Frame.Parent = p34
    v_u_40:OnClick(function()
        if not (v_u_40.IsLocked or v_u_40.IsOwned) then
            p_u_32:InspectShopEntry(v_u_40.ShopEntry.EntryName)
        end
    end)
    return v_u_40
end
function v_u_21.CreateBundleSlot(p_u_41, p42, p43)
    local v_u_44 = v_u_14.new(p42, p43)
    p_u_41._bundle_slots[p43] = v_u_44
    v_u_44.Tapped:Connect(function()
        p_u_41:InspectBundle(v_u_44.Name, v_u_44.Frame)
    end)
end
function v_u_21.Open(p45, ...)
    v_u_15.Open(p45, ...)
    p45.Tabs:Open()
    p45.Pages:Open()
    p45.BottomTabs:Open()
    v_u_5:CreateSound("rbxassetid://18100002432", 1.25, 1, script, true, 5)
end
function v_u_21.Close(p46, ...)
    v_u_15.Close(p46, ...)
    p46.Tabs:Close()
    p46.Pages:Close()
    p46.BottomTabs:Close()
end
function v_u_21._UpdatePromptContext(p47)
    p47.List.Visible = not p47.PromptSystem.CurrentPrompt
end
function v_u_21._UpdateScale(p48)
    local v49 = p48.CurrentPage == "Home" and 0.9 or 1
    p48.List.Size = UDim2.new(1 / v49, 18, 1, 0)
    p48.Container.Size = UDim2.new(v49 * 1, -8, v49 * 1, -8)
end
function v_u_21._UpdateCanvasSize(p50)
    local v51 = p50.Pages.Frame.AbsolutePosition.Y - p50.PageFrame.AbsolutePosition.Y
    local v52 = v_u_4.IS_ACTIVE
    if v52 then
        v52 = v_u_8:GetStatistic("StatisticDuelsPlayed") >= v_u_4.NUM_GAMES_NEEDED_TO_PARTICIPATE
    end
    local v53
    if p50.CurrentPage == "Daily" then
        v53 = UDim2.new(0, 0, 0, p50.Pages.DailyShop.Layout.AbsoluteContentSize.Y + v51)
    elseif p50.CurrentPage == "Currency" and v52 then
        v53 = UDim2.new(0, 0, 1.75, v51)
    elseif p50.CurrentPage == "Bundles" then
        v53 = UDim2.new(0, 0, 1.75, v51)
    elseif p50.CurrentPage == "Home" then
        v53 = UDim2.new(0, 0, 0, p50.Pages.Home.Frame.AbsoluteSize.Y + v51)
    else
        v53 = UDim2.new(0, 0, 0.75, v51)
    end
    p50.List.CanvasSize = v53 + UDim2.new(0, 0, 0, p50.BottomTabs.Frame.AbsoluteSize.Y * 3)
end
function v_u_21._Setup(p_u_54)
    p_u_54.DotsFrame:AddTag("UILoadingDots")
    p_u_54.WaitingFrame.Visible = true
    p_u_54.Tabs.Frame.Visible = false
    p_u_54.Pages.Frame.Visible = false
    p_u_54.BottomTabs.Frame.Visible = false
    task.delay(0.25, function()
        p_u_54.DotsFrame:RemoveTag("UILoadingDots")
        p_u_54.WaitingFrame.Visible = false
        p_u_54.Tabs.Frame.Visible = true
        p_u_54.Pages.Frame.Visible = true
        p_u_54.BottomTabs.Frame.Visible = true
        p_u_54.Tabs:Setup()
        p_u_54.Pages:Setup()
        p_u_54.BottomTabs:Setup()
        p_u_54:SetPage(p_u_54.CurrentPage or "Home")
        p_u_54._setup_finished = true
        p_u_54._setup_finished_event_internal:Fire()
    end)
end
function v_u_21._Init(p_u_55)
    p_u_55.PromptSystem.PromptAdded:Connect(function(p56)
        p_u_55.List.CanvasPosition = Vector2.new(0, 0)
        p_u_55:_UpdatePromptContext()
        if p56.InspectCurrencyPage then
            p56.InspectCurrencyPage:Connect(function()
                p_u_55:SetPage("Currency")
            end)
        end
    end)
    p_u_55.PromptSystem.PromptRemoved:Connect(function()
        p_u_55:_UpdatePromptContext()
    end)
    p_u_55.OpenChanged:Connect(function()
        v_u_11:ChangeSubject(nil)
    end)
    p_u_55.CurrentPageChanged:Connect(function()
        p_u_55:_UpdateCanvasSize()
        p_u_55:_UpdateScale()
    end)
    p_u_55.Pages.DailyShop.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p_u_55:_UpdateCanvasSize()
    end)
    p_u_55.BottomTabs.Frame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        p_u_55:_UpdateCanvasSize()
    end)
    p_u_55.Pages.Home.Frame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        p_u_55:_UpdateCanvasSize()
    end)
    v_u_8:GetDataChangedSignal("StatisticDuelsPlayed"):Connect(function()
        p_u_55:_UpdateCanvasSize()
    end)
    p_u_55:_Setup()
    p_u_55:_UpdateScale()
    p_u_55:_UpdateCanvasSize()
    p_u_55:_UpdatePromptContext()
end
return v_u_21._new()