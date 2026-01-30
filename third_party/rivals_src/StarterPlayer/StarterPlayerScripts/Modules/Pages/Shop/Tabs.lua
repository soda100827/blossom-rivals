local v_u_1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
require(v_u_1.Modules.CONSTANTS)
require(v_u_1.Modules.SeasonLibrary)
local v_u_3 = require(v_u_1.Modules.EventLibrary)
local v_u_4 = require(v2.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
local v_u_5 = require(v2.LocalPlayer.PlayerScripts.Controllers.FighterController)
local v_u_6 = require(v2.LocalPlayer.PlayerScripts.Controllers.SeasonController)
local v_u_7 = require(v2.LocalPlayer.PlayerScripts.Controllers.ShopController)
local v_u_8 = require(v2.LocalPlayer.PlayerScripts.Modules.ButtonEffect)
local v_u_9 = UDim2.new(0.125, 0, 0.875, 0)
local v_u_10 = {}
v_u_10.__index = v_u_10
function v_u_10.new(p11)
    local v12 = v_u_10
    local v13 = setmetatable({}, v12)
    v13.Shop = p11
    v13.Frame = v13.Shop.Container:WaitForChild("Tabs")
    v13.CloseButton = v13.Frame:WaitForChild("Close")
    v13.RankedButton = v13.Frame:WaitForChild("Ranked")
    v13.CurrencyButton = v13.Frame:WaitForChild("Currency")
    v13.CurrencyIcon = v13.CurrencyButton:WaitForChild("Icon")
    v13.CurrencyEventIcon = v13.CurrencyButton:WaitForChild("EventIcon")
    v13.WeaponsButton = v13.Frame:WaitForChild("Weapons")
    v13.GiftingButton = v13.Frame:WaitForChild("Gifting")
    v13.RewardsButton = v13.Frame:WaitForChild("Rewards")
    v13.MoreButton = v13.Frame:WaitForChild("More")
    v13.LessButton = v13.Frame:WaitForChild("Less")
    v13._buttons = {}
    v13._more_buttons_visible = false
    v13:_Init()
    return v13
end
function v_u_10.Open(p14)
    p14:_CloseMoreTabs()
end
function v_u_10.Close(p15)
    p15:_CloseMoreTabs()
end
function v_u_10.Setup(p16)
    p16:_CloseMoreTabs()
end
function v_u_10._OpenMoreTabs(p17)
    p17._more_buttons_visible = true
    for _, v18 in pairs(p17._buttons) do
        v18.Visible = false
    end
    p17.MoreButton.Visible = false
    p17.LessButton.Visible = true
    for _, v19 in pairs({ p17.WeaponsButton, p17.GiftingButton, p17.RewardsButton }) do
        v19.Size = UDim2.new(v_u_9.X.Scale * 0.5, 0, v_u_9.Y.Scale * 0.5, 0)
        v19:TweenSize(v_u_9, "Out", "Quint", 0.25, true)
        v19.Visible = true
    end
    p17:_UpdateVisibility()
end
function v_u_10._CloseMoreTabs(p20)
    p20._more_buttons_visible = false
    for _, v21 in pairs(p20._buttons) do
        v21.Size = UDim2.new(v_u_9.X.Scale * 0.5, 0, v_u_9.Y.Scale * 0.5, 0)
        v21:TweenSize(v_u_9, "Out", "Quint", 0.25, true)
        v21.Visible = true
    end
    p20.MoreButton.Visible = true
    p20.LessButton.Visible = false
    p20.WeaponsButton.Visible = false
    p20.GiftingButton.Visible = false
    p20.RewardsButton.Visible = false
    p20:_UpdateVisibility()
end
function v_u_10._UpdateEvent(p22)
    local v23 = v_u_3.IS_ACTIVE
    if v23 then
        v23 = v_u_4:GetStatistic("StatisticDuelsPlayed") >= v_u_3.NUM_GAMES_NEEDED_TO_PARTICIPATE
    end
    p22.CurrencyEventIcon.Visible = v23
    p22.CurrencyEventIcon.Image = v_u_3.EVENT_DETAILS.CURRENCY_IMAGE
    p22.CurrencyIcon.Position = v23 and UDim2.new(0.4, 0, 0.5, 0) or UDim2.new(0.5, 0, 0.5, 0)
end
function v_u_10._UpdateVisibility(p24)
    local v25 = p24.RankedButton
    local v26 = not p24._more_buttons_visible
    if v26 then
        v26 = v_u_6:IsRankedUnlocked()
    end
    v25.Visible = v26
    local v27 = p24.WeaponsButton
    local v28 = p24._more_buttons_visible and (p24.LocalFighter and not p24.LocalFighter:Get("IsInShootingRange"))
    if v28 then
        v28 = not p24.LocalFighter:Get("IsInDuel")
    end
    v27.Visible = v28
end
function v_u_10._Update(p29)
    for _, v30 in pairs(p29.Shop.PAGE_NAMES) do
        local v31 = v30 == p29.Shop.CurrentPage
        local v32 = p29.Frame:WaitForChild(v30)
        local v33 = v32:WaitForChild("Background")
        local v34 = v32:WaitForChild("Title")
        local v35 = v34:WaitForChild("UIStroke")
        v34.TextColor3 = v31 and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
        v35.Color = v31 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
        v35.Transparency = v31 and 0 or 0.75
        v33.ImageColor3 = v31 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
        v33.ImageTransparency = v31 and 0 or 0.25
        v33:WaitForChild("UIGradient").Enabled = not v31
    end
    if p29.Shop.CurrentPage == "Daily" and v_u_4:Get("LastDailyShopSeen") ~= v_u_7.DailyShopDay then
        v_u_1.Remotes.Misc.ViewedDailyShop:FireServer()
    end
end
function v_u_10._HookLocalFighter(p_u_36)
    p_u_36.LocalFighter = v_u_5:WaitForLocalFighter()
    p_u_36.LocalFighter:GetDataChangedSignal("IsInShootingRange"):Connect(function()
        p_u_36:_UpdateVisibility()
    end)
    p_u_36.LocalFighter:GetDataChangedSignal("IsInDuel"):Connect(function()
        p_u_36:_UpdateVisibility()
    end)
    p_u_36:_UpdateVisibility()
end
function v_u_10._Setup(p_u_37)
    for _, v_u_38 in pairs(p_u_37.Shop.PAGE_NAMES) do
        local v_u_39 = p_u_37.Frame:WaitForChild(v_u_38)
        p_u_37._buttons[v_u_38] = v_u_39
        v_u_39.MouseButton1Click:Connect(function()
            p_u_37.Shop:SetPage(v_u_38)
        end)
        v_u_8:Add(v_u_39)
        if v_u_38 == "Daily" then
            local function v42()
                local v40 = v_u_39.NotificationBubble
                local v41
                if v_u_4:Get("LastDailyShopSeen") == v_u_7.DailyShopDay then
                    v41 = false
                else
                    v41 = v_u_4:GetStatistic("StatisticDuelsPlayed") > 3
                end
                v40.Visible = v41
            end
            v_u_4:GetDataChangedSignal("StatisticDuelsPlayed"):Connect(v42)
            v_u_4:GetDataChangedSignal("LastDailyShopSeen"):Connect(v42)
            v_u_7.DailyShopRefreshed:Connect(v42)
            local v43 = v_u_39.NotificationBubble
            local v44
            if v_u_4:Get("LastDailyShopSeen") == v_u_7.DailyShopDay then
                v44 = false
            else
                v44 = v_u_4:GetStatistic("StatisticDuelsPlayed") > 3
            end
            v43.Visible = v44
        end
    end
end
function v_u_10._Init(p_u_45)
    p_u_45.CloseButton.MouseButton1Click:Connect(function()
        p_u_45.Shop:CloseRequest()
    end)
    p_u_45.Shop.CurrentPageChanged:Connect(function()
        p_u_45:_Update()
    end)
    p_u_45.MoreButton.MouseButton1Click:Connect(function()
        p_u_45:_OpenMoreTabs()
    end)
    p_u_45.LessButton.MouseButton1Click:Connect(function()
        p_u_45:_CloseMoreTabs()
    end)
    v_u_4:GetDataChangedSignal("StatisticDuelsPlayed"):Connect(function()
        p_u_45:_UpdateEvent()
    end)
    p_u_45:_Setup()
    p_u_45:_UpdateEvent()
    p_u_45:_UpdateVisibility()
    task.defer(p_u_45._HookLocalFighter, p_u_45)
    v_u_8:Add(p_u_45.CloseButton)
    v_u_8:Add(p_u_45.MoreButton)
    v_u_8:Add(p_u_45.LessButton)
end
return v_u_10