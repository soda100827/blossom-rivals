local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
require(v1.Modules.CONSTANTS)
local v_u_3 = require(v1.Modules.MonetizationLibrary)
local v_u_4 = require(v1.Modules.CosmeticLibrary)
local v_u_5 = require(v1.Modules.SeasonLibrary)
require(v1.Modules.ItemLibrary)
local v_u_6 = require(v1.Modules.ShopLibrary)
local v_u_7 = require(v2.LocalPlayer.PlayerScripts.Controllers:WaitForChild("MonetizationController"))
local v_u_8 = require(v2.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController"))
local v_u_9 = require(v2.LocalPlayer.PlayerScripts.Controllers:WaitForChild("ComplianceController"))
local v_u_10 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect"))
local v_u_11 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("RewardSlot"))
local v_u_12 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("Prompt"))
local v_u_13 = setmetatable({}, v_u_12)
v_u_13.__index = v_u_13
function v_u_13.new(p14, p15, p16)
    local v17 = v_u_12.new(script.Name)
    local v18 = v_u_13
    local v19 = setmetatable(v17, v18)
    v19.Container = v19.PromptFrame:WaitForChild("Container")
    v19.ButtonsFrame = v19.PromptFrame:WaitForChild("Buttons")
    v19.CloseButton = v19.ButtonsFrame:WaitForChild("Close")
    v19.BuyButton = v19.ButtonsFrame:WaitForChild("Buy")
    v19.BuyButtonOwnedFrame = v19.BuyButton:WaitForChild("Owned")
    v19.BuyButtonReadyFrame = v19.BuyButton:WaitForChild("Ready")
    v19.BuyButtonReadyText = v19.BuyButtonReadyFrame:WaitForChild("Title")
    v19.BuyButtonReadyBubbleFrame = v19.BuyButtonReadyFrame:WaitForChild("Bubble")
    v19.BuyButtonReadyBubbleText = v19.BuyButtonReadyBubbleFrame:WaitForChild("Title")
    v19.Name = p14
    v19.Info = v_u_3.Bundles[v19.Name]
    v19._is_gamepass_bundle = v19.Info.Type == "Gamepass"
    v19._template = p15:GetOriginalTemplate():Clone()
    v19._reference = p16
    v19._reward_slots = {}
    v19:_Init()
    return v19
end
function v_u_13.Buy(p20)
    if p20.BuyButtonReadyFrame.Visible then
        if p20._is_gamepass_bundle then
            v_u_7:PromptGamePassPurchase(v_u_3.Gamepasses[p20.Info.GamepassName].GamepassID)
        else
            v_u_7:PromptProductPurchase(p20.Info.ProductID)
        end
    else
        return
    end
end
function v_u_13.Destroy(p21)
    for _, v22 in pairs(p21._reward_slots) do
        v22:Destroy()
    end
    v_u_12.Destroy(p21)
end
function v_u_13._IsPrimeSeasonBundleOwned(_)
    local v23 = v_u_8:Get("Seasons")[v_u_5.CurrentSeason.Name]
    if v23 then
        v23 = v23.BattlePass
    end
    return (v23 and v23.MaxPassTrackNum or 0) >= 2
end
function v_u_13._IsContrabandSeasonBundleOwned(_)
    local v24 = v_u_8:Get("Seasons")[v_u_5.CurrentSeason.Name]
    if v24 then
        v24 = v24.BattlePass
    end
    if v24 then
        v24 = v24.SeasonPassBundleOwned
    end
    return v24
end
function v_u_13._Update(p25)
    local v26
    if p25._is_gamepass_bundle then
        v26 = v_u_8:Get("GamepassBundlesClaimed")[p25.Info.GamepassName]
    elseif p25.Name == "contrabandseason_bundle" then
        v26 = p25:_IsContrabandSeasonBundleOwned()
    elseif p25.Name == "primeseason_bundle" then
        v26 = p25:_IsPrimeSeasonBundleOwned()
    else
        v26 = false
    end
    if v26 then
        p25.BuyButtonReadyFrame.Visible = false
        p25.BuyButtonOwnedFrame.Visible = true
    else
        p25.BuyButtonReadyFrame.Visible = true
        p25.BuyButtonOwnedFrame.Visible = false
    end
end
function v_u_13._Setup(p27)
    if p27.Name == "standardweapons_bundle" then
        for v28, v29 in pairs(v_u_3:GetStandardWeaponBundleWeapons()) do
            local v30 = not v_u_6:IsWeaponReleased(v29)
            local v31 = v_u_11.new({
                ["Name"] = v29
            })
            v31.Frame.LayoutOrder = -#v_u_6.OwnableWeaponsAlphabetized + v28 + (v30 and -999999999 or 0)
            v31:SetParent(p27._template.Container.Rewards)
            local v32 = p27._reward_slots
            table.insert(v32, v31)
            if v30 then
                v31:SetNameText("???")
                v31:LockedImage()
            end
        end
    end
    for v33, v34 in pairs(p27.Info.Rewards) do
        local v35 = v_u_4.Rewards[v34.Name]
        if not v35 or (v35.Type ~= "Lootbox" or not v_u_9:ArePaidRandomItemsRestricted()) then
            local v36 = v_u_11.new(v34)
            v36.Frame.LayoutOrder = v33
            v36:SetParent(p27._template.Container.Rewards)
            local v37 = p27._reward_slots
            table.insert(v37, v36)
        end
    end
    if not p27._template:FindFirstChildOfClass("UIAspectRatioConstraint") then
        if p27._template and p27._template:FindFirstChildOfClass("UIAspectRatioConstraint") then
            local _ = p27._template:FindFirstChildOfClass("UIAspectRatioConstraint").AspectRatio
        end
        local v38 = p27._template
        if v38 then
            v38 = p27._template.AbsoluteSize.X / p27._template.AbsoluteSize.Y
        end
        if p27._reference and p27._reference:FindFirstChildOfClass("UIAspectRatioConstraint") then
            local _ = p27._reference:FindFirstChildOfClass("UIAspectRatioConstraint").AspectRatio
        end
        local v39 = p27._reference
        if v39 then
            v39 = p27._reference.AbsoluteSize.X / p27._reference.AbsoluteSize.Y
        end
        if not v38 or v38 ~= v38 then
            v38 = (not v39 or v39 ~= v39) and 1 or v39
        end
        local v40 = (not v38 or v38 ~= v38) and 1 or v38
        local v41 = Instance.new("UIAspectRatioConstraint")
        v41.AspectRatio = v40
        v41.Parent = p27._template
    end
    p27._template.Container.Title.Text = p27.Info.DisplayName
    p27._template.AnchorPoint = Vector2.new(0.5, 0.5)
    p27._template.Position = UDim2.new(0.5, 0, 0.5, 0)
    p27._template.Size = UDim2.new(1, 0, 1, 0)
    p27._template.Container.Button.Visible = false
    p27._template.Container.Icon.ImageColor3 = Color3.fromRGB(32, 32, 32)
    p27._template.Container.Icon.ImageTransparency = 0.75
    p27._template.Container.Rewards.Visible = true
    p27._template.Visible = true
    p27._template.Parent = p27.Container
    p27.BuyButtonReadyBubbleText.RichText = true
    p27.BuyButtonReadyBubbleText.Text = p27.Info.BubbleText or ""
    p27.BuyButtonReadyBubbleFrame.Visible = p27.BuyButtonReadyBubbleText.Text ~= ""
    v_u_7:SetRobuxText(p27.BuyButtonReadyText, p27._is_gamepass_bundle and v_u_3.Gamepasses[p27.Info.GamepassName].GamepassID or p27.Info.ProductID, p27._is_gamepass_bundle and Enum.InfoType.GamePass or Enum.InfoType.Product)
end
function v_u_13._Init(p_u_42)
    p_u_42.CloseButton.MouseButton1Click:Connect(function()
        p_u_42:CloseRequest()
    end)
    p_u_42._template.Container.MouseButton1Click:Connect(function()
        p_u_42:Buy()
    end)
    p_u_42.BuyButton.MouseButton1Click:Connect(function()
        p_u_42:Buy()
    end)
    local v43 = p_u_42._connections
    local v44 = v_u_8:GetDataChangedSignal("GamepassBundlesClaimed")
    table.insert(v43, v44:Connect(function()
        p_u_42:_Update()
    end))
    local v45 = p_u_42._connections
    local v46 = v_u_8:GetDataChangedSignal("Seasons")
    table.insert(v45, v46:Connect(function()
        p_u_42:_Update()
    end))
    p_u_42:_Setup()
    p_u_42:_Update()
    v_u_10:Add(p_u_42._template.Container, nil, {
        ["HoverRatio"] = 1.025,
        ["ReleaseRatio"] = 1.025
    })
    v_u_10:Add(p_u_42.BuyButton)
    v_u_10:Add(p_u_42.CloseButton)
end
return v_u_13