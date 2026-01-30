local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.CosmeticLibrary)
require(v1.Modules.CurrencyLibrary)
local v_u_4 = require(v1.Modules.EventLibrary)
local v_u_5 = require(v1.Modules.LootLibrary)
local v_u_6 = require(v1.Modules.Utility)
local v_u_7 = require(v2.LocalPlayer.PlayerScripts.Controllers.MonetizationController)
local v_u_8 = require(v2.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
local v_u_9 = require(v2.LocalPlayer.PlayerScripts.Modules.BaseShopSlot.BigShopSlot)
local v_u_10 = require(v2.LocalPlayer.PlayerScripts.Controllers.ShopController)
local v_u_11 = require(v2.LocalPlayer.PlayerScripts.Modules.BaseShopSlot.ShopSlot)
local v_u_12 = require(v2.LocalPlayer.PlayerScripts.Modules.ButtonEffect)
local v_u_13 = {}
v_u_13.__index = v_u_13
function v_u_13.new(p14)
    local v15 = v_u_13
    local v16 = setmetatable({}, v15)
    v16.Pages = p14
    v16.Frame = v16.Pages.Frame:WaitForChild("Daily")
    v16.Layout = v16.Frame:WaitForChild("Layout")
    v16.CountdownFrame = v16.Frame:WaitForChild("Countdown")
    v16.CountdownTimer = v16.CountdownFrame:WaitForChild("Timer")
    v16.CountdownRefreshButton = v16.CountdownFrame:WaitForChild("Refresh")
    v16.CountdownRefreshPrice = v16.CountdownRefreshButton:WaitForChild("Price")
    v16.CountdownRefreshPriceIcon = v16.CountdownRefreshPrice:WaitForChild("Icon")
    v16.SkinsFrame = v16.Frame:WaitForChild("Skins")
    v16.SkinsContainer = v16.SkinsFrame:WaitForChild("Container")
    v16.SkinsLayout = v16.SkinsContainer:WaitForChild("Layout")
    v16.FinishersFrame = v16.Frame:WaitForChild("Finishers")
    v16.FinishersContainer = v16.FinishersFrame:WaitForChild("Container")
    v16.FinishersSlotsFrame = v16.FinishersContainer:WaitForChild("Slots")
    v16.FinishersSlotsLayout = v16.FinishersSlotsFrame:WaitForChild("Layout")
    v16.WrapsFrame = v16.Frame:WaitForChild("Wraps")
    v16.WrapsContainer = v16.WrapsFrame:WaitForChild("Container")
    v16.WrapsSlotsFrame = v16.WrapsContainer:WaitForChild("Slots")
    v16.WrapsSlotsLayout = v16.WrapsSlotsFrame:WaitForChild("Layout")
    v16.CharmsFrame = v16.Frame:WaitForChild("Charms")
    v16.CharmsContainer = v16.CharmsFrame:WaitForChild("Container")
    v16.CharmsSlotsFrame = v16.CharmsContainer:WaitForChild("Slots")
    v16.CharmsSlotsLayout = v16.CharmsSlotsFrame:WaitForChild("Layout")
    v16._is_open_hash = 0
    v16._shop_slots = {}
    v16:_Init()
    return v16
end
function v_u_13.Generate(p17)
    for _, v18 in pairs(p17._shop_slots) do
        v18:Destroy()
    end
    p17._shop_slots = {}
    if p17.Pages.Shop:IsOpen() then
        local v19 = v_u_8:GetStatistic("StatisticDuelsPlayed") >= v_u_4.NUM_GAMES_NEEDED_TO_PARTICIPATE
        v_u_8:Get("CosmeticInventory")
        for v20, v21 in pairs(v_u_10:GetDailyShop()) do
            if not v21.Prices.EventCurrency or v19 then
                local v22 = v21.Rewards[1]
                local v23 = v_u_3.Cosmetics[v22.Name]
                local v24 = v23.Type == "Finisher" and p17.FinishersSlotsFrame or v23.Type == "Wrap" and p17.WrapsSlotsFrame or (v23.Type == "Charm" and p17.CharmsSlotsFrame or p17.SkinsContainer)
                local v25
                if v23.Type == "Skin" or v23.Type == "Emote" then
                    v25 = v_u_9
                else
                    v25 = v_u_11
                end
                local v26 = p17.Pages.Shop:CreateShopSlot(v25, nil, v21.EntryName)
                v26.Frame.LayoutOrder = v20
                v26.Frame.ZIndex = v20
                v26.Frame.Parent = v24
                local v27 = p17._shop_slots
                table.insert(v27, v26)
                if v23.Type == "Emote" and v23.EmoteDescription then
                    v26:SetDescription(v23.EmoteDescription)
                end
            end
        end
    end
end
function v_u_13.Open(p28)
    p28._is_open_hash = p28._is_open_hash + 1
    task.spawn(p28._CountdownLoop, p28)
    p28:Generate()
end
function v_u_13.Close(p29)
    p29._is_open_hash = p29._is_open_hash + 1
    p29:Generate()
end
function v_u_13.Setup(p30)
    p30:Generate()
end
function v_u_13._CountdownLoop(p31)
    p31._is_open_hash = p31._is_open_hash + 1
    local v32 = p31._is_open_hash
    while v32 == p31._is_open_hash do
        p31.CountdownTimer.Text = "<font transparency=\"0.5\" size=\"9\">shop will refresh in</font> " .. v_u_6:TimeFormat2(v_u_10:GetDailyShopRefreshTimeRemaining())
        wait(1)
    end
end
function v_u_13._UpdateRefreshText(p33)
    p33.CountdownRefreshPrice.Text = v_u_5:GetCostToRefreshDailyShop(v_u_8:Get("DailyShopRefreshesToday"))
end
function v_u_13._UpdateFrameSizes(p34)
    p34.SkinsFrame.Size = UDim2.new(1, 0, 0, p34.SkinsLayout.AbsoluteContentSize.Y + p34.SkinsFrame.AbsoluteSize.X * 440 / 1173 * 0.05)
    p34.FinishersFrame.Size = UDim2.new(1, 0, 0, p34.FinishersSlotsLayout.AbsoluteContentSize.Y + p34.FinishersSlotsFrame.AbsolutePosition.Y - p34.FinishersContainer.AbsolutePosition.Y + 0.05 * p34.FinishersContainer.AbsoluteSize.Y)
    p34.WrapsFrame.Size = UDim2.new(1, 0, 0, p34.WrapsSlotsLayout.AbsoluteContentSize.Y + p34.WrapsSlotsFrame.AbsolutePosition.Y - p34.WrapsContainer.AbsolutePosition.Y + 0.05 * p34.WrapsContainer.AbsoluteSize.Y)
    p34.CharmsFrame.Size = UDim2.new(1, 0, 0, p34.CharmsSlotsLayout.AbsoluteContentSize.Y + p34.CharmsSlotsFrame.AbsolutePosition.Y - p34.CharmsContainer.AbsolutePosition.Y + 0.05 * p34.CharmsContainer.AbsoluteSize.Y)
end
function v_u_13._Init(p_u_35)
    p_u_35.SkinsFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        p_u_35:_UpdateFrameSizes()
    end)
    p_u_35.SkinsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p_u_35:_UpdateFrameSizes()
    end)
    p_u_35.FinishersSlotsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p_u_35:_UpdateFrameSizes()
    end)
    p_u_35.WrapsSlotsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p_u_35:_UpdateFrameSizes()
    end)
    p_u_35.CharmsSlotsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p_u_35:_UpdateFrameSizes()
    end)
    p_u_35.CountdownRefreshPriceIcon:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        p_u_35.CountdownRefreshPrice.Position = UDim2.new(0.5, -p_u_35.CountdownRefreshPriceIcon.AbsoluteSize.X / 2, 0.5, 0)
        p_u_35.CountdownRefreshPriceIcon.Position = UDim2.new(0.5, p_u_35.CountdownRefreshPrice.TextBounds.X / 2, 0.5, 0)
    end)
    p_u_35.CountdownRefreshButton.MouseButton1Click:Connect(function()
        local v36 = v_u_5:GetCostToRefreshDailyShop(v_u_8:Get("DailyShopRefreshesToday"))
        if v_u_8:Get("WeaponKeys") < v36 then
            p_u_35.Pages.Shop:SetPage("Currency")
            v_u_7:PromptCurrencyBundlePurchase(v36, "WeaponKeys")
        else
            v_u_10:BuyDailyShopRefresh()
            v_u_6:CreateSound("rbxassetid://18100002432", 1.25, 1, script, true, 5)
        end
    end)
    v_u_8:GetDataChangedSignal("DailyShopRefreshesToday"):Connect(function()
        p_u_35:_UpdateRefreshText()
    end)
    v_u_8:GetDataChangedSignal("CosmeticInventory"):Connect(function()
        p_u_35:Generate()
    end)
    v_u_8:GetDataChangedSignal("WeaponInventory"):Connect(function()
        p_u_35:Generate()
    end)
    v_u_10.DailyShopRefreshed:Connect(function()
        p_u_35:Generate()
    end)
    p_u_35:_UpdateRefreshText()
    v_u_12:Add(p_u_35.CountdownRefreshButton)
end
return v_u_13