local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.MonetizationLibrary)
require(v1.Modules.SeasonLibrary)
local v_u_4 = require(v1.Modules.EventLibrary)
require(v1.Modules.ShopLibrary)
local v_u_5 = require(v_u_2.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
local v_u_6 = require(v_u_2.LocalPlayer.PlayerScripts.Modules.UserInterface.Spotlight)
local v_u_7 = require(v_u_2.LocalPlayer.PlayerScripts.Modules.VideoAdRewards)
local v_u_8 = require(v_u_2.LocalPlayer.PlayerScripts.Modules.ButtonEffect)
local v_u_9 = {
    "lootbox_Skin Case",
    "lootbox_Skin Case 2",
    "lootbox_Skin Case 3",
    "lootbox_Wrap Box",
    "lootbox_Wrap Box 2",
    "lootbox_Wrap Box 3",
    "lootbox_Charm Capsule",
    "lootbox_Finisher Pack",
    "lootbox_Finisher Pack 2",
    "loose_arena",
    "loose_randomwrap",
    "loose_universalwrap"
}
local v_u_10 = {}
v_u_10.__index = v_u_10
function v_u_10.new(p11)
    local v12 = v_u_10
    local v13 = setmetatable({}, v12)
    v13.Pages = p11
    v13.Frame = v13.Pages.Frame:WaitForChild("Home")
    v13.Container = v13.Frame:WaitForChild("Container")
    v13.EventFrame = v13.Container:WaitForChild("Event")
    v13.OtherFrame = v13.Container:WaitForChild("Other")
    v13.LooseFrame = v13.OtherFrame:WaitForChild("Loose")
    v13.CarouselFrame = v13.OtherFrame:WaitForChild("Carousel")
    v13.CarouselContainer = v13.CarouselFrame:WaitForChild("Container")
    v13.VideoAdRewardsFrame = v13.CarouselContainer:WaitForChild("VideoAdRewards")
    v13.CarouselButtons = v13.CarouselFrame:WaitForChild("Buttons")
    v13.VideoAdRewardsButton = v13.CarouselButtons:WaitForChild("VideoAdRewards")
    v13.RedirectFrame = v13.OtherFrame:WaitForChild("Redirect")
    v13.RedirectDailyButton = v13.RedirectFrame:WaitForChild("Daily"):WaitForChild("Container")
    v13.RedirectWeaponsButton = v13.RedirectFrame:WaitForChild("Weapons"):WaitForChild("Container")
    v13.RedirectKeysButton = v13.RedirectFrame:WaitForChild("Keys"):WaitForChild("Container")
    v13.BattlePassFrame = v13.OtherFrame:WaitForChild("BattlePass")
    v13.BattlePassContainer = v13.BattlePassFrame:WaitForChild("Container")
    v13.BattlePassIsHoveringFrame = v13.BattlePassContainer:WaitForChild("IsHovering")
    v13.BattlePassNotHoveringFrame = v13.BattlePassContainer:WaitForChild("NotHovering")
    v13.VideoAdRewards = v_u_7.new(329421439571920)
    v13._is_open_hash = 0
    v13._current_carousel_index = 0
    v13._last_carousel_index_change_time = 0
    v13._shop_slots = {}
    v13._carousel_buttons = {}
    v13._pause_carousel_until = 0
    v13:_Init()
    return v13
end
function v_u_10.GetVisualIndex(p14)
    local v15 = 0
    for v16 = 1, p14._current_carousel_index do
        if p14._carousel_buttons[v16].Visible then
            v15 = v15 + 1
        end
    end
    return v15
end
function v_u_10.SetCarouselIndexByName(p17, p18)
    for v19, v20 in pairs(p17._carousel_buttons) do
        if v20.Name == p18 then
            p17:SetCarouselIndex(v19)
            return
        end
    end
end
function v_u_10.SetCarouselIndex(p21, p22)
    p21._current_carousel_index = (p22 - 1) % #p21._carousel_buttons + 1
    local v23 = UDim2.new(0.5 - 0.975 * (p21:GetVisualIndex() - 1), 0, -0.025, 0)
    if p21.CarouselContainer:IsDescendantOf(v_u_2) then
        p21.CarouselContainer:TweenPosition(v23, "Out", "Quint", 0.75, true)
    else
        p21.CarouselContainer.Position = v23
    end
    for v24, v25 in pairs(p21._carousel_buttons) do
        local v26 = v24 == p21._current_carousel_index
        v25.ImageLabel.Size = v26 and UDim2.new(0.75, 0, 0.75, 0) or UDim2.new(0.5, 0, 0.5, 0)
        v25.ImageLabel.ImageColor3 = v26 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
        v25.ImageLabel.ImageTransparency = v26 and 0 or 0.5
    end
    p21.VideoAdRewards:WeakUpdate()
end
function v_u_10.PauseCarousel(p27, p28)
    p27._pause_carousel_until = tick() + p28
end
function v_u_10.Open(p29)
    p29._is_open_hash = p29._is_open_hash + 1
    p29:_UpdateShopSlots()
    p29:_ScrollToDefault()
    task.spawn(p29._CarouselLoop, p29)
    p29.VideoAdRewards:Update()
end
function v_u_10.Close(p30)
    p30:_UpdateShopSlots()
    p30._is_open_hash = p30._is_open_hash + 1
end
function v_u_10.Setup(p31)
    local v32 = v_u_3.VIDEO_AD_REWARDS_ENABLED
    if v32 then
        v32 = #v_u_3.VideoAdRewards > 0
    end
    p31.VideoAdRewardsFrame.Visible = v32
    p31.VideoAdRewardsButton.Visible = v32
    task.defer(p31.VideoAdRewards.Update, p31.VideoAdRewards)
    p31:_SetupCarouselSlot("VideoAdRewards")
    for _, v33 in pairs(p31.Pages.Shop.BUNDLE_NAMES) do
        p31:_SetupCarouselSlot(v33, true)
    end
    p31:SetCarouselIndex(1)
    p31:_ScrollToDefault()
end
function v_u_10._SetupCarouselSlot(p_u_34, p_u_35, p36)
    local v_u_37 = p_u_34.CarouselButtons:WaitForChild(p_u_35)
    v_u_37.MouseButton1Click:Connect(function()
        p_u_34._last_carousel_index_change_time = tick()
        p_u_34:SetCarouselIndex(table.find(p_u_34._carousel_buttons, v_u_37))
    end)
    v_u_8:Add(v_u_37)
    local v38 = p_u_34._carousel_buttons
    table.insert(v38, v_u_37)
    if p36 then
        local v39 = v_u_3.Bundles[p_u_35]
        local v_u_40 = p_u_34.CarouselContainer:WaitForChild(p_u_35)
        local v41 = v_u_40:WaitForChild("Container")
        v41.MouseButton1Click:Connect(function()
            p_u_34.Pages.Shop:InspectBundle(p_u_35, v_u_40)
        end)
        v41.Button.Bubble.Title.RichText = true
        v41.Button.Bubble.Title.Text = v39.BubbleText or ""
        v41.Button.Bubble.Visible = v41.Button.Bubble.Title.Text ~= ""
        v_u_8:Add(v41, nil, {
            ["HoverRatio"] = 1.01,
            ["ReleaseRatio"] = 1.01
        })
    end
    table.sort(p_u_34._carousel_buttons, function(p42, p43)
        return p42.LayoutOrder < p43.LayoutOrder
    end)
end
function v_u_10._ScrollToDefault(p44)
    p44:SetCarouselIndexByName("VideoAdRewards")
end
function v_u_10._CarouselLoop(_) end
function v_u_10._UpdateShopSlots(p45)
    for _, v46 in pairs(p45._shop_slots) do
        v46:Destroy()
    end
    p45._shop_slots = {}
    if p45.Pages.Shop:IsOpen() then
        for v47, v48 in pairs({ v_u_9, v_u_4.IS_ACTIVE and v_u_4.SHOP_ENTRIES_OVERVIEW or nil }) do
            for _, v49 in pairs(v48) do
                local v50
                if v47 == 2 then
                    v50 = p45.EventFrame
                else
                    v50 = p45.LooseFrame
                end
                local v51 = p45.Pages.Shop:CreateShopSlot(nil, v50:WaitForChild(v49), v49)
                if v51 then
                    local v52 = p45._shop_slots
                    table.insert(v52, v51)
                end
            end
        end
    end
end
function v_u_10._Setup(p53)
    p53.VideoAdRewards.Frame.Parent = p53.VideoAdRewardsFrame
    local v54 = p53.EventFrame
    local v55 = v_u_4.IS_ACTIVE and v_u_4.SHOP_ENTRIES_OVERVIEW
    if v55 then
        v55 = #v_u_4.SHOP_ENTRIES_OVERVIEW > 0
    end
    v54.Visible = v55
    for v56, v57 in pairs(v_u_4.IS_ACTIVE and (v_u_4.SHOP_ENTRIES_OVERVIEW and v_u_4.SHOP_ENTRIES_OVERVIEW) or {}) do
        local v58 = Instance.new("Frame")
        v58.BackgroundTransparency = 1
        v58.Size = UDim2.new(1, 0, 1, 0)
        v58.LayoutOrder = v56
        v58.ZIndex = -v56
        v58.Name = v57
        v58.Parent = p53.EventFrame
    end
end
function v_u_10._Init(p_u_59)
    p_u_59.RedirectDailyButton.MouseButton1Click:Connect(function()
        p_u_59.Pages.Shop:SetPage("Daily")
    end)
    p_u_59.RedirectWeaponsButton.MouseButton1Click:Connect(function()
        p_u_59.Pages.Shop:SetPage("Weapons")
    end)
    p_u_59.RedirectKeysButton.MouseButton1Click:Connect(function()
        p_u_59.Pages.Shop:SetPage("Currency")
    end)
    p_u_59.BattlePassContainer.MouseButton1Click:Connect(function()
        p_u_59.Pages.Shop:SetPage("BattlePass")
    end)
    p_u_59.BattlePassContainer.MouseEnter:Connect(function()
        p_u_59.BattlePassIsHoveringFrame.Visible = true
        p_u_59.BattlePassNotHoveringFrame.Visible = false
        v_u_6:ChangeSubject(p_u_59.BattlePassContainer)
    end)
    p_u_59.BattlePassContainer.MouseLeave:Connect(function()
        p_u_59.BattlePassIsHoveringFrame.Visible = false
        p_u_59.BattlePassNotHoveringFrame.Visible = true
        v_u_6:ChangeSubject(nil, p_u_59.BattlePassContainer)
    end)
    p_u_59.VideoAdRewards.PlayedAd:Connect(function()
        p_u_59:PauseCarousel(25)
    end)
    v_u_5:GetDataChangedSignal("CosmeticInventory"):Connect(function()
        p_u_59:_UpdateShopSlots()
    end)
    v_u_5:GetDataChangedSignal("WeaponInventory"):Connect(function()
        p_u_59:_UpdateShopSlots()
    end)
    p_u_59:_Setup()
    v_u_8:Add(p_u_59.RedirectKeysButton)
    v_u_8:Add(p_u_59.RedirectDailyButton)
    v_u_8:Add(p_u_59.RedirectWeaponsButton)
    v_u_8:Add(p_u_59.BattlePassContainer, nil, {
        ["HoverRatio"] = 1.01,
        ["ReleaseRatio"] = 1.01
    })
end
return v_u_10