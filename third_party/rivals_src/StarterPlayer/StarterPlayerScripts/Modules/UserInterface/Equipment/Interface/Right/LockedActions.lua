local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.CONSTANTS)
local v_u_4 = require(v1.Modules.MonetizationLibrary)
local v_u_5 = require(v1.Modules.CurrencyLibrary)
local v_u_6 = require(v1.Modules.SeasonLibrary)
local v_u_7 = require(v1.Modules.ShopLibrary)
local v_u_8 = require(v1.Modules.Utility)
local v_u_9 = require(v2.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
local v_u_10 = require(v2.LocalPlayer.PlayerScripts.Modules.ButtonEffect)
local v_u_11 = require(v2.LocalPlayer.PlayerScripts.Modules.UserInterface.Pages)
local v_u_12 = {}
v_u_12.__index = v_u_12
function v_u_12.new(p13)
    local v14 = v_u_12
    local v15 = setmetatable({}, v14)
    v15.Right = p13
    v15.Frame = v15.Right.Container:WaitForChild("LockedActions")
    v15.Container = v15.Frame:WaitForChild("Container")
    v15.Layout = v15.Container:WaitForChild("Layout")
    v15.TryWeaponFrame = v15.Container:WaitForChild("TryWeapon")
    v15.TryWeaponButton = v15.TryWeaponFrame:WaitForChild("Button")
    v15.SpecialOfferFrame = v15.Container:WaitForChild("SpecialOffer")
    v15.SpecialOfferDescription = v15.SpecialOfferFrame:WaitForChild("Description")
    v15.SpecialOfferCountdown = v15.SpecialOfferFrame:WaitForChild("Countdown")
    v15.SpecialOfferButton = v15.SpecialOfferFrame:WaitForChild("Button")
    v15.SpecialOfferButtonLockedFrame = v15.SpecialOfferButton:WaitForChild("Locked")
    v15.SpecialOfferButtonUnlockedFrame = v15.SpecialOfferButton:WaitForChild("Unlocked")
    v15.BuyFrame = v15.Container:WaitForChild("Buy")
    v15.BuyDescription = v15.BuyFrame:WaitForChild("Description")
    v15.BuyCountdown = v15.BuyFrame:WaitForChild("Countdown")
    v15.BuyButton = v15.BuyFrame:WaitForChild("Button")
    v15.BuyButtonLockedFrame = v15.BuyButton:WaitForChild("Locked")
    v15.BuyButtonFreeFrame = v15.BuyButton:WaitForChild("Free")
    v15.BuyButtonKeysFrame = v15.BuyButton:WaitForChild("Keys")
    v15.BuyButtonKeysPrice = v15.BuyButtonKeysFrame:WaitForChild("Price")
    v15.BuyButtonKeysPriceIconOutline = v15.BuyButtonKeysPrice:WaitForChild("Icon")
    v15.BuyButtonKeysPriceIcon = v15.BuyButtonKeysPriceIconOutline:WaitForChild("ImageLabel")
    v15:_Init()
    return v15
end
function v_u_12.OnStateChanged(p16)
    p16:_UpdateInformation()
end
function v_u_12._InteractSpecialOffer(p17)
    local v18 = p17.Right.Interface.Equipment:GetSelectedWeapon()
    local v19, v20 = v_u_6:GetRewardSeasonPassPosition(v18)
    local v_u_21 = p17.SpecialOfferDescription.Text == "Early access!" and "standardweapons_bundle" or v_u_4:GetBundleContainingReward(v18)
    if v19 and v20 then
        v_u_11.PageSystem:OpenPage("BattlePass", true)
        v_u_11.PageSystem:WaitForPage("BattlePass"):Preview(v19, v20)
        return
    elseif v_u_21 == "contrabandseason_bundle" or v_u_21 == "primeseason_bundle" then
        v_u_11.PageSystem:OpenPage("BattlePass", true)
        v_u_11.PageSystem:WaitForPage("BattlePass"):InspectBundle(v_u_21)
    elseif v_u_21 then
        v_u_11.PageSystem:OpenPage("Shop", true)
        v_u_11.PageSystem:WaitForPage("Shop"):SetPage("Bundles")
        task.delay(0.1, function()
            v_u_11.PageSystem:WaitForPage("Shop"):InspectBundle(v_u_21)
        end)
    end
end
function v_u_12._UpdateInformation(p22)
    local v23 = p22.Right.Interface.Equipment:GetSelectedWeapon()
    local v24 = v_u_9:GetWeaponData(v23)
    local v25
    if v23 then
        v25 = not v24
    else
        v25 = v23
    end
    p22.Frame.Visible = v25
    if v25 then
        local v26, _, v27, _ = v_u_7:GetWeaponKeyPriceInfo(v23, v_u_9:Get("UnlockTokens"), v_u_9:Get("FreeWeaponUnlockCheck"))
        local v28 = v_u_4:GetBundleContainingReward(v23)
        local v29, _ = v_u_6:GetRewardSeasonPassPosition(v23)
        local v30 = v_u_7:GetTimeUntilWeaponRelease(v23)
        local v31 = not v27
        if v31 then
            v31 = v30 > 0
        end
        local v32
        if v31 then
            v32 = v30 <= v_u_3.WEAPON_REVEAL_TIME_OFFSET
        else
            v32 = v31
        end
        local v33
        if v32 then
            v33 = v30 <= v_u_3.WEAPON_EARLY_ACCESS_TIME_OFFSET
        else
            v33 = v32
        end
        p22.BuyFrame.Visible = v33 or v26 < (1 / 0)
        p22.BuyButtonLockedFrame.Visible = v31
        local v34 = p22.BuyButtonFreeFrame
        local v35 = not v31
        if v35 then
            v35 = v26 <= 0
        end
        v34.Visible = v35
        local v36 = p22.BuyButtonKeysFrame
        local v37 = not v31
        if v37 then
            v37 = v26 > 0
        end
        v36.Visible = v37
        p22.BuyButtonKeysPrice.Text = v31 and "" or v_u_8:PrettyNumber(v26)
        local v38 = p22.BuyDescription
        local v39
        if v31 then
            v39 = UDim2.new(0.175, 0, 0.35, 0)
        else
            v39 = UDim2.new(0.175, 0, 0.5, 0)
        end
        v38.Position = v39
        p22.BuyDescription.Text = v31 and "Coming soon!" or "Unlock now!"
        p22.BuyCountdown.Text = not v31 and "" or "in " .. v_u_8:TimeFormat2(v30, 2)
        local v40 = p22.TryWeaponFrame
        local v41 = not (v27 or v31)
        if v41 then
            v41 = table.find(v_u_7.OwnableWeapons, v23)
        end
        v40.Visible = v41
        local v42 = p22.SpecialOfferFrame
        local v43 = not v27
        if v43 then
            v43 = v28 or (v32 or v29)
        end
        v42.Visible = v43
        local v44 = p22.SpecialOfferButtonLockedFrame
        local v45
        if v32 then
            v45 = not v33
        else
            v45 = v32
        end
        v44.Visible = v45
        p22.SpecialOfferButtonUnlockedFrame.Visible = not v32 or v33
        local v46 = p22.SpecialOfferDescription
        local v47
        if v32 and not v33 then
            v47 = UDim2.new(0.175, 0, 0.35, 0)
        else
            v47 = UDim2.new(0.175, 0, 0.5, 0)
        end
        v46.Position = v47
        p22.SpecialOfferDescription.Text = v32 and "Early access!" or "Special offer!"
        p22.SpecialOfferCountdown.Text = (not v32 or v33) and "" or "in " .. v_u_8:TimeFormat2(v30 - v_u_3.WEAPON_EARLY_ACCESS_TIME_OFFSET, 2)
    end
end
function v_u_12._Update(p48)
    p48.Frame.Size = UDim2.new(1, 0, 0, p48.Layout.AbsoluteContentSize.Y)
    p48.BuyButtonKeysPrice.Position = UDim2.new(0.5, -p48.BuyButtonKeysPriceIconOutline.AbsoluteSize.X / 2, 0.5, 0)
    p48.BuyButtonKeysPriceIconOutline.Position = UDim2.new(0.5, p48.BuyButtonKeysPrice.TextBounds.X / 2, 0.5, 0)
end
function v_u_12._Setup(p49)
    p49.BuyButtonKeysPriceIconOutline.Image = v_u_5.Info.WeaponKeys.ImageFlatOutline
    p49.BuyButtonKeysPriceIcon.Image = v_u_5.Info.WeaponKeys.ImageFlat
end
function v_u_12._Init(p_u_50)
    p_u_50.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p_u_50:_Update()
    end)
    p_u_50.BuyButtonKeysPrice:GetPropertyChangedSignal("TextBounds"):Connect(function()
        p_u_50:_Update()
    end)
    p_u_50.BuyButtonKeysPriceIconOutline:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        p_u_50:_Update()
    end)
    p_u_50.BuyButton.MouseButton1Click:Connect(function()
        p_u_50.Right.Interface.Equipment:UnlockWeapon()
    end)
    p_u_50.TryWeaponButton.MouseButton1Click:Connect(function()
        p_u_50.Right.Interface.Equipment:TryWeapon()
    end)
    p_u_50.SpecialOfferButton.MouseButton1Click:Connect(function()
        p_u_50:_InteractSpecialOffer()
    end)
    v_u_9:GetDataChangedSignal("WeaponInventory"):Connect(function()
        p_u_50:_UpdateInformation()
    end)
    v_u_9:GetDataChangedSignal("UnlockTokens"):Connect(function()
        p_u_50:_UpdateInformation()
    end)
    v_u_9:GetDataChangedSignal("FreeWeaponUnlockCheck"):Connect(function()
        p_u_50:_UpdateInformation()
    end)
    p_u_50:_Setup()
    p_u_50:_Update()
    v_u_10:Add(p_u_50.BuyButton, nil, {
        ["HoverRatio"] = UDim2.new(0, 10, 0, 10),
        ["ReleaseRatio"] = UDim2.new(0, 10, 0, 10)
    })
    v_u_10:Add(p_u_50.TryWeaponButton, nil, {
        ["HoverRatio"] = UDim2.new(0, 10, 0, 10),
        ["ReleaseRatio"] = UDim2.new(0, 10, 0, 10)
    })
    v_u_10:Add(p_u_50.SpecialOfferButton, nil, {
        ["HoverRatio"] = UDim2.new(0, 10, 0, 10),
        ["ReleaseRatio"] = UDim2.new(0, 10, 0, 10)
    })
end
return v_u_12