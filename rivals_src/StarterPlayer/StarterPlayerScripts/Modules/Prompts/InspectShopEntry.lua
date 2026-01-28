local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.CosmeticLibrary)
local v_u_4 = require(v1.Modules.CurrencyLibrary)
local v_u_5 = require(v1.Modules.Utility)
local v_u_6 = require(v1.Modules.Signal)
local v_u_7 = require(v2.LocalPlayer.PlayerScripts.Controllers:WaitForChild("MonetizationController"))
local v_u_8 = require(v2.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController"))
local v_u_9 = require(v2.LocalPlayer.PlayerScripts.Controllers:WaitForChild("ComplianceController"))
local v_u_10 = require(v2.LocalPlayer.PlayerScripts.Controllers:WaitForChild("ShopController"))
local v_u_11 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect"))
local v_u_12 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("RewardSlot"))
local v_u_13 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("Prompt"))
local v_u_14 = v2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("ShopEntryBuyButton")
local v_u_15 = setmetatable({}, v_u_13)
v_u_15.__index = v_u_15
function v_u_15.new(p16)
    local v17 = v_u_13.new(script.Name)
    local v18 = v_u_15
    local v19 = setmetatable(v17, v18)
    v19.InspectCurrencyPage = v_u_6.new()
    v19.Title = v19.PromptFrame:WaitForChild("Title")
    v19.LimitedFrame = v19.PromptFrame:WaitForChild("Limited")
    v19.Container = v19.PromptFrame:WaitForChild("Container")
    v19.LockedText = v19.PromptFrame:WaitForChild("Locked")
    v19.DisabledText = v19.PromptFrame:WaitForChild("Disabled")
    v19.CloseButton = v19.PromptFrame:WaitForChild("Close")
    v19.ViewContentsButton = v19.PromptFrame:WaitForChild("ViewContents")
    v19.ButtonsFrame = v19.PromptFrame:WaitForChild("Buttons")
    v19.BuyRobuxButton = v19.ButtonsFrame:WaitForChild("BuyRobux")
    v19.BuyRobuxButtonText = v19.BuyRobuxButton:WaitForChild("Value")
    v19.BuyRobuxTripleButton = v19.ButtonsFrame:WaitForChild("BuyRobuxTriple")
    v19.BuyRobuxTripleButtonText = v19.BuyRobuxTripleButton:WaitForChild("Value")
    v19.Name = p16
    v19.ShopEntry = v_u_10:GetShopEntry(p16)
    v19._close_on_purchase = v19.ShopEntry.EntryType == "Daily"
    v19._reward_slots = {}
    v19._update_text_bounds = {}
    v19:_Init()
    return v19
end
function v_u_15.Destroy(p20)
    for _, v21 in pairs(p20._reward_slots) do
        v21:Destroy()
    end
    p20.InspectCurrencyPage:Destroy()
    v_u_13.Destroy(p20)
end
function v_u_15._Update(p22)
    local v23 = v_u_8:Get("CosmeticInventory")
    local v24 = p22.ShopEntry.Rewards[1]
    local v25 = v_u_3.Cosmetics[v24.Name]
    local v26
    if v25 then
        v26 = v_u_3.Types[v25.Type]
    else
        v26 = v25
    end
    local v27 = v_u_3.Rewards[v24.Name]
    local v28 = v_u_3:OwnsCosmetic(v23, v24.Name, v24.Weapon)
    local v29 = v24.Weapon
    if v29 then
        if v24.Weapon == "IsRandom" or v24.Weapon == "IsUniversal" then
            v29 = false
        else
            v29 = not v_u_8:GetWeaponData(v24.Weapon)
        end
    end
    local v30 = p22.Title
    local v31
    if v26 and v26.IsWeaponCosmetic then
        v31 = (v24.Weapon == "IsRandom" and "Random" or (v24.Weapon == "IsUniversal" and "Universal" or v24.Weapon)) .. " " .. v25.Type
    elseif v25 then
        v31 = v25.Type
    else
        v31 = v24.Name
    end
    v30.Text = v31
    p22.LockedText.Visible = v28 or v29
    p22.LockedText.Text = v28 and "Unavailable\nYou already own this" or (v29 and "Unavailable\nYou don\'t own " .. (v24.Weapon or "") or "")
    local v32 = p22.DisabledText
    local v33 = not p22.LockedText.Visible
    if v33 then
        if v27 then
            if v27.Type == "Lootbox" then
                v33 = v_u_9:ArePaidRandomItemsRestricted()
            else
                v33 = false
            end
        else
            v33 = v27
        end
    end
    v32.Visible = v33
    local v34 = p22.ViewContentsButton
    if v27 then
        v27 = v27.Type == "Lootbox"
    end
    v34.Visible = v27
    local v35 = p22.ButtonsFrame
    local v36 = not p22.DisabledText.Visible
    if v36 then
        v36 = not p22.LockedText.Visible
    end
    v35.Visible = v36
    local v37 = p22.BuyRobuxButton
    local v38 = not (v28 or v29)
    if v38 then
        v38 = p22.ShopEntry.ProductID ~= nil
    end
    v37.Visible = v38
    local v39 = p22.BuyRobuxTripleButton
    local v40 = not (v28 or v29)
    if v40 then
        v40 = p22.ShopEntry.ProductIDTriple ~= nil
    end
    v39.Visible = v40
    if p22.ShopEntry.ProductID then
        v_u_7:SetRobuxText(p22.BuyRobuxButtonText, p22.ShopEntry.ProductID, Enum.InfoType.Product)
    end
    if p22.ShopEntry.ProductIDTriple then
        v_u_7:SetRobuxText(p22.BuyRobuxTripleButtonText, p22.ShopEntry.ProductIDTriple, Enum.InfoType.Product)
    end
end
function v_u_15._Setup(p_u_41)
    p_u_41.LimitedFrame.Visible = p_u_41.ShopEntry.IsLimited
    for v_u_42, v_u_43 in pairs(p_u_41.ShopEntry.Prices) do
        local v_u_44 = v_u_4.Info[v_u_42]
        if not v_u_44.OnlyDisplayBuyButtonAboveZeroBalance or v_u_8:Get(v_u_42) > 0 then
            local v45 = v_u_14:Clone()
            v45.LayoutOrder = v_u_44.OrderIndex
            v45.Free.Visible = v_u_43 == 0
            v45.Price.Visible = v_u_43 > 0
            v45.Price.Value.Text = v_u_5:PrettyNumber(v_u_43)
            v45.Price.Value.Icon.Image = v_u_44.ImageFlatOutline
            v45.Price.Value.Icon.ImageLabel.Image = v_u_44.ImageFlat
            v45.Price.Background.ImageColor3 = v_u_44.Color
            v45.Price.Background.UIGradient.Color = v_u_44.ColorGradient
            v45.Parent = p_u_41.ButtonsFrame
            v_u_11:Add(v45)
            v45.MouseButton1Click:Connect(function()
                if v_u_8:Get(v_u_44.DataName) < v_u_43 then
                    if v_u_7:PromptCurrencyBundlePurchase(v_u_43, v_u_42) then
                        p_u_41.InspectCurrencyPage:Fire()
                        p_u_41:CloseRequest()
                    else
                        v_u_5:CreateSound("rbxassetid://17153811469", 2, 1, script, true, 5)
                    end
                else
                    v_u_5:CreateSound("rbxassetid://18210861148", 1, 1, script, true, 5)
                    v_u_10:PurchaseShopEntry(p_u_41.Name, v_u_42)
                    if p_u_41._close_on_purchase then
                        p_u_41:CloseRequest()
                    end
                    return
                end
            end)
            local v_u_46 = v45.Price.Value
            local v_u_47 = v_u_46.Icon
            local function v48()
                v_u_47.Position = UDim2.new(0.5, v_u_46.TextBounds.X / 2, 0.5, 0)
            end
            v_u_46:GetPropertyChangedSignal("TextBounds"):Connect(v48)
            v45.AncestryChanged:Connect(v48)
            v_u_47.Position = UDim2.new(0.5, v_u_46.TextBounds.X / 2, 0.5, 0)
        end
    end
    for v49, v50 in pairs(p_u_41.ShopEntry.Rewards) do
        local v51 = v_u_12.new(v50)
        v51.Frame.LayoutOrder = v49
        v51:SetParent(p_u_41.Container)
        local v52 = p_u_41._reward_slots
        table.insert(v52, v51)
    end
end
function v_u_15._Init(p_u_53)
    p_u_53.CloseButton.MouseButton1Click:Connect(function()
        p_u_53:CloseRequest()
    end)
    p_u_53.BuyRobuxButton.MouseButton1Click:Connect(function()
        if p_u_53._close_on_purchase then
            p_u_53:CloseRequest()
        end
        v_u_10:PurchaseShopEntry(p_u_53.Name)
    end)
    p_u_53.BuyRobuxTripleButton.MouseButton1Click:Connect(function()
        if p_u_53._close_on_purchase then
            p_u_53:CloseRequest()
        end
        v_u_10:PurchaseShopEntry(p_u_53.Name, nil, true)
    end)
    p_u_53.ViewContentsButton.MouseButton1Click:Connect(function()
        p_u_53.OpenPrompt:Fire("InspectLootbox", p_u_53.ShopEntry.Rewards[1].Name, p_u_53.ShopEntry.Rewards[1].Weapon, "InspectShopEntry", p_u_53.Name)
    end)
    local v54 = p_u_53._connections
    local v55 = v_u_8:GetDataChangedSignal("CosmeticInventory")
    table.insert(v54, v55:Connect(function()
        p_u_53:_Update()
    end))
    local v56 = p_u_53._connections
    local v57 = v_u_8:GetDataChangedSignal("WeaponInventory")
    table.insert(v56, v57:Connect(function()
        p_u_53:_Update()
    end))
    p_u_53:_Setup()
    p_u_53:_Update()
    v_u_11:Add(p_u_53.CloseButton)
    v_u_11:Add(p_u_53.ViewContentsButton)
    v_u_11:Add(p_u_53.BuyRobuxButton)
    v_u_11:Add(p_u_53.BuyRobuxTripleButton)
end
return v_u_15