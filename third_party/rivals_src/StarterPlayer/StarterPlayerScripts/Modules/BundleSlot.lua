local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.MonetizationLibrary)
local v_u_4 = require(v1.Modules.CosmeticLibrary)
local v_u_5 = require(v1.Modules.SeasonLibrary)
local v_u_6 = require(v1.Modules.ShopLibrary)
local v_u_7 = require(v1.Modules.Utility)
local v_u_8 = require(v1.Modules.Signal)
local v_u_9 = require(v2.LocalPlayer.PlayerScripts.Controllers.MonetizationController)
local v_u_10 = require(v2.LocalPlayer.PlayerScripts.Controllers.ComplianceController)
local v_u_11 = require(v2.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
local v_u_12 = require(v2.LocalPlayer.PlayerScripts.Controllers.ControlsController)
local v_u_13 = require(v2.LocalPlayer.PlayerScripts.Modules.UserInterface.Spotlight)
local v_u_14 = require(v2.LocalPlayer.PlayerScripts.Modules.ButtonEffect)
local v_u_15 = require(v2.LocalPlayer.PlayerScripts.Modules.RewardSlot)
local v_u_16 = {}
v_u_16.__index = v_u_16
function v_u_16.new(p17, p18)
    local v19 = v_u_16
    local v20 = setmetatable({}, v19)
    v20.Tapped = v_u_8.new()
    v20.Name = p18
    v20.Info = v_u_3.Bundles[v20.Name]
    v20.Frame = p17
    v20._original_template = p17:Clone()
    v20._is_currency_bundle = v20.Info.Type == "Currency"
    v20._is_gamepass_bundle = v20.Info.Type == "Gamepass"
    v20._is_purchaseable_callback = nil
    v20:_Init()
    return v20
end
function v_u_16.GetOriginalTemplate(p21)
    return p21._original_template
end
function v_u_16.SetIsPurchaseableCallback(p22, p23)
    p22._is_purchaseable_callback = p23
end
function v_u_16.SetIsOwned(p24, p25)
    p24.Frame.Container.Button.Visible = not p25
    p24.Frame.Container.Claimed.Visible = p25
end
function v_u_16.Destroy(p26)
    p26.Frame:Destroy()
    p26.Tapped:Destroy()
end
function v_u_16._IsPrimeSeasonBundleOwned(_)
    local v27 = v_u_11:Get("Seasons")[v_u_5.CurrentSeason.Name]
    if v27 then
        v27 = v27.BattlePass
    end
    return (v27 and v27.MaxPassTrackNum or 0) >= 2
end
function v_u_16._IsContrabandSeasonBundleOwned(_)
    local v28 = v_u_11:Get("Seasons")[v_u_5.CurrentSeason.Name]
    if v28 then
        v28 = v28.BattlePass
    end
    if v28 then
        v28 = v28.SeasonPassBundleOwned
    end
    return v28
end
function v_u_16._SetupSpotlight(p_u_29)
    local function v30()
        v_u_13:ChangeSubject(p_u_29.Frame.Container.Background)
        p_u_29.Frame.Container.Icon.ImageColor3 = Color3.fromRGB(32, 32, 32)
        p_u_29.Frame.Container.Icon.ImageTransparency = 0.75
        p_u_29.Frame.Container.Rewards.Visible = true
        p_u_29.Frame.Container.Button.BubbleContainer.Visible = false
    end
    local function v31()
        v_u_13:ChangeSubject(nil, p_u_29.Frame.Container.Background)
        p_u_29.Frame.Container.Icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
        p_u_29.Frame.Container.Icon.ImageTransparency = 0.25
        p_u_29.Frame.Container.Rewards.Visible = false
        p_u_29.Frame.Container.Button.BubbleContainer.Visible = true
    end
    p_u_29.Frame.Container.MouseEnter:Connect(v30)
    p_u_29.Frame.Container.MouseLeave:Connect(v31)
    v31()
end
function v_u_16._SetupStandardWeaponsBundle(p32)
    for v33, v34 in pairs(v_u_3:GetStandardWeaponBundleWeapons()) do
        local v35 = not v_u_6:IsWeaponReleased(v34)
        local v36 = v_u_15.new({
            ["Name"] = v34
        })
        v36.Frame.LayoutOrder = -#v_u_6.OwnableWeaponsAlphabetized + v33 + (v35 and -999999999 or 0)
        v36:SetInteractable(v_u_12.CurrentControls ~= "Touch")
        v36:SetParent(p32.Frame.Container.Rewards)
        if v35 then
            v36:SetNameText("???")
            v36:LockedImage()
        end
    end
end
function v_u_16._SetupCurrencyVisuals(p_u_37)
    p_u_37.Frame.Container.Value.Text = "+ " .. v_u_7:PrettyNumber(p_u_37.Info.Rewards[1].Quantity)
    p_u_37.Frame.Container.Rewards:GetPropertyChangedSignal("Visible"):Connect(function()
        p_u_37.Frame.Container.Value.Visible = not p_u_37.Frame.Container.Rewards.Visible
    end)
    p_u_37.Frame.Container.Value.Visible = not p_u_37.Frame.Container.Rewards.Visible
end
function v_u_16._SetupGamepassVisuals(p_u_38)
    local function v39()
        p_u_38:SetIsOwned(v_u_11:Get("GamepassBundlesClaimed")[p_u_38.Info.GamepassName])
    end
    v_u_11:GetDataChangedSignal("GamepassBundlesClaimed"):Connect(v39)
    p_u_38:SetIsOwned(v_u_11:Get("GamepassBundlesClaimed")[p_u_38.Info.GamepassName])
end
function v_u_16._SetupContrabandSeasonBundle(p_u_40)
    p_u_40:SetIsPurchaseableCallback(function()
        return not p_u_40:_IsContrabandSeasonBundleOwned()
    end)
    v_u_11:GetDataChangedSignal("Seasons"):Connect(function()
        p_u_40:SetIsOwned(p_u_40:_IsContrabandSeasonBundleOwned())
    end)
    p_u_40:SetIsOwned(p_u_40:_IsContrabandSeasonBundleOwned())
end
function v_u_16._SetupPrimeSeasonBundle(p_u_41)
    p_u_41:SetIsPurchaseableCallback(function()
        return not p_u_41:_IsPrimeSeasonBundleOwned()
    end)
    v_u_11:GetDataChangedSignal("Seasons"):Connect(function()
        p_u_41:SetIsOwned(p_u_41:_IsPrimeSeasonBundleOwned())
    end)
    p_u_41:SetIsOwned(p_u_41:_IsPrimeSeasonBundleOwned())
end
function v_u_16._SetupRewards(p42)
    for v43, v44 in pairs(p42.Info.Rewards) do
        local v45 = v_u_4.Rewards[v44.Name]
        if not v45 or (v45.Type ~= "Lootbox" or not v_u_10:ArePaidRandomItemsRestricted()) then
            local v46 = v_u_15.new(v44)
            v46.Frame.LayoutOrder = v43
            v46:SetInteractable(v_u_12.CurrentControls ~= "Touch")
            v46:SetParent(p42.Frame.Container.Rewards)
        end
    end
end
function v_u_16._Setup(p47)
    p47.Frame.Container.Title.Text = p47.Info.DisplayName
    p47.Frame.Container.Button.BubbleContainer.Bubble.Title.RichText = true
    p47.Frame.Container.Button.BubbleContainer.Bubble.Title.Text = p47.Info.BubbleText or ""
    p47.Frame.Container.Button.BubbleContainer.Bubble.Visible = p47.Frame.Container.Button.BubbleContainer.Bubble.Title.Text ~= ""
    v_u_9:SetRobuxText(p47.Frame.Container.Button.Title, p47._is_gamepass_bundle and v_u_3.Gamepasses[p47.Info.GamepassName].GamepassID or p47.Info.ProductID, p47._is_gamepass_bundle and Enum.InfoType.GamePass or Enum.InfoType.Product)
    if p47._is_currency_bundle then
        p47:_SetupCurrencyVisuals()
    end
    if p47._is_gamepass_bundle then
        p47:_SetupGamepassVisuals()
    end
    if p47.Name == "standardweapons_bundle" then
        p47:_SetupStandardWeaponsBundle()
    elseif p47.Name == "contrabandseason_bundle" then
        p47:_SetupContrabandSeasonBundle()
    elseif p47.Name == "primeseason_bundle" then
        p47:_SetupPrimeSeasonBundle()
    end
    p47:_SetupRewards()
    p47:_SetupSpotlight()
end
function v_u_16._Init(p_u_48)
    p_u_48.Frame.Container.MouseButton1Click:Connect(function()
        if v_u_12.CurrentControls == "Touch" then
            p_u_48.Tapped:Fire()
            return
        elseif p_u_48._is_purchaseable_callback and not p_u_48._is_purchaseable_callback() then
            return
        elseif p_u_48._is_gamepass_bundle then
            v_u_9:PromptGamePassPurchase(v_u_3.Gamepasses[p_u_48.Info.GamepassName].GamepassID)
        else
            v_u_9:PromptProductPurchase(p_u_48.Info.ProductID)
        end
    end)
    p_u_48:_Setup()
    v_u_14:Add(p_u_48.Frame.Container, nil, {
        ["HoverRatio"] = 1.025,
        ["ReleaseRatio"] = 1.025
    })
end
return v_u_16