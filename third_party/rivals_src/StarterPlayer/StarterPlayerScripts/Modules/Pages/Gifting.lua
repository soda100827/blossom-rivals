local v_u_1 = game:GetService("MarketplaceService")
local v_u_2 = game:GetService("ReplicatedStorage")
game:GetService("GuiService")
local v_u_3 = game:GetService("Players")
local v_u_4 = require(v_u_2.Modules.CONSTANTS)
local v_u_5 = require(v_u_2.Modules.MonetizationLibrary)
local v_u_6 = require(v_u_2.Modules.SeasonLibrary)
local v_u_7 = require(v_u_2.Modules.Utility)
local v_u_8 = require(v_u_3.LocalPlayer.PlayerScripts.Controllers:WaitForChild("MonetizationController"))
local v_u_9 = require(v_u_3.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController"))
require(v_u_3.LocalPlayer.PlayerScripts.Controllers:WaitForChild("ComplianceController"))
local v_u_10 = require(v_u_3.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect"))
local v_u_11 = require(v_u_3.LocalPlayer.PlayerScripts.Modules:WaitForChild("PromptSystem"))
local v_u_12 = require(v_u_3.LocalPlayer.PlayerScripts.Modules:WaitForChild("DropdownSlot"))
local v_u_13 = require(v_u_3.LocalPlayer.PlayerScripts.Modules:WaitForChild("RewardSlot"))
local v_u_14 = require(v_u_3.LocalPlayer.PlayerScripts.Modules:WaitForChild("Page"))
local v_u_15 = v_u_3.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("GiftPlayerEmptySlot")
local v_u_16 = v_u_3.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("GiftProductSlot")
local v_u_17 = v_u_3.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("GiftPlayerSlot")
local v_u_18 = {
    "None",
    "Enjoy!",
    "Thanks!",
    "Surprise!",
    "I appreciate you!",
    "You\'re the best!",
    "Thanks for everything!",
    "You played well!",
    "You owe me!",
    "Happy birthday!",
    "Merry Christmas!",
    "Happy holidays!",
    "Congratulations!",
    "Custom"
}
local v_u_19 = setmetatable({}, v_u_14)
v_u_19.__index = v_u_19
function v_u_19._new()
    local v20 = v_u_14.new(script.Name)
    local v21 = v_u_19
    local v22 = setmetatable(v20, v21)
    v22.CloseButton = v22.PageFrame:WaitForChild("Close")
    v22.PromptsFrame = v22.PageFrame:WaitForChild("Prompts")
    v22.BackButton = v22.PageFrame:WaitForChild("Back")
    v22.Container = v22.PageFrame:WaitForChild("Container")
    v22.SelectPlayerFrame = v22.Container:WaitForChild("SelectPlayer")
    v22.PlayersList = v22.SelectPlayerFrame:WaitForChild("List")
    v22.PlayersContainer = v22.PlayersList:WaitForChild("Container")
    v22.PlayersLayout = v22.PlayersContainer:WaitForChild("Layout")
    v22.PlayersGiftRewardFrame = v22.PlayersContainer:WaitForChild("GiftReward")
    v22.PlayersGiftRewardProgressBar = v22.PlayersGiftRewardFrame:WaitForChild("Progress"):WaitForChild("Bar")
    v22.PlayersGiftRewardContainer = v22.PlayersGiftRewardFrame:WaitForChild("Container")
    v22.PlayersGiftRewardGoalText = v22.PlayersGiftRewardFrame:WaitForChild("Goal")
    v22.PlayersOfflineGiftFrame = v22.PlayersContainer:WaitForChild("OfflineGift")
    v22.PlayersOfflineGiftBox = v22.PlayersOfflineGiftFrame:WaitForChild("Input"):WaitForChild("Box")
    v22.PlayersOfflineGiftButton = v22.PlayersOfflineGiftFrame:WaitForChild("Button")
    v22.PlayersOfflineGiftButtonOn = v22.PlayersOfflineGiftButton:WaitForChild("On")
    v22.PlayersOfflineGiftButtonOff = v22.PlayersOfflineGiftButton:WaitForChild("Off")
    v22.PlayersOfflineGiftButtonIcon = v22.PlayersOfflineGiftButton:WaitForChild("Icon")
    v22.PlayersOfflineGiftButtonCountdown = v22.PlayersOfflineGiftButton:WaitForChild("Countdown")
    v22.SelectProductFrame = v22.Container:WaitForChild("SelectProduct")
    v22.ProductsEmptyFrame = v22.SelectProductFrame:WaitForChild("Empty")
    v22.ProductsDotsFrame = v22.SelectProductFrame:WaitForChild("Dots")
    v22.ProductsList = v22.SelectProductFrame:WaitForChild("List")
    v22.ProductsContainer = v22.ProductsList:WaitForChild("Container")
    v22.ProductsLayout = v22.ProductsContainer:WaitForChild("Layout")
    v22.ProductsPlayerFrame = v22.ProductsContainer:WaitForChild("Player")
    v22.ProductsPlayerPicture = v22.ProductsPlayerFrame:WaitForChild("Picture")
    v22.ProductsPlayerUsernameText = v22.ProductsPlayerFrame:WaitForChild("Username")
    v22.ProductsPlayerDisplayNameText = v22.ProductsPlayerFrame:WaitForChild("DisplayName")
    v22.ConfirmPurchaseFrame = v22.Container:WaitForChild("ConfirmPurchase")
    v22.ConfirmPurchaseDotsFrame = v22.ConfirmPurchaseFrame:WaitForChild("Dots")
    v22.ConfirmPurchaseList = v22.ConfirmPurchaseFrame:WaitForChild("List")
    v22.ConfirmPurchaseContainer = v22.ConfirmPurchaseList:WaitForChild("Container")
    v22.ConfirmPurchaseLayout = v22.ConfirmPurchaseContainer:WaitForChild("Layout")
    v22.ConfirmPurchasePlayerFrame = v22.ConfirmPurchaseContainer:WaitForChild("Player")
    v22.ConfirmPurchasePlayerPicture = v22.ConfirmPurchasePlayerFrame:WaitForChild("Picture")
    v22.ConfirmPurchasePlayerUsernameText = v22.ConfirmPurchasePlayerFrame:WaitForChild("Username")
    v22.ConfirmPurchasePlayerDisplayNameText = v22.ConfirmPurchasePlayerFrame:WaitForChild("DisplayName")
    v22.ConfirmPurchaseProductFrame = v22.ConfirmPurchaseContainer:WaitForChild("Product")
    v22.ConfirmPurchaseProductIcon = v22.ConfirmPurchaseProductFrame:WaitForChild("Icon")
    v22.ConfirmPurchaseProductTitleText = v22.ConfirmPurchaseProductFrame:WaitForChild("DisplayName")
    v22.ConfirmPurchaseWarningsFrame = v22.ConfirmPurchaseContainer:WaitForChild("Warnings")
    v22.ConfirmPurchaseWarningsGiftTicketsFrame = v22.ConfirmPurchaseWarningsFrame:WaitForChild("GiftTickets")
    v22.ConfirmPurchaseWarningsGiftTicketsText = v22.ConfirmPurchaseWarningsGiftTicketsFrame:WaitForChild("Icon"):WaitForChild("Quantity")
    v22.ConfirmPurchaseWarningsOfflineGiftingFrame = v22.ConfirmPurchaseWarningsFrame:WaitForChild("OfflineGifting")
    v22.ConfirmPurchaseBuyFrame = v22.ConfirmPurchaseContainer:WaitForChild("Buy")
    v22.ConfirmPurchaseBuyButton = v22.ConfirmPurchaseBuyFrame:WaitForChild("Button")
    v22.ConfirmPurchaseBuyButtonGiftTicketIcon = v22.ConfirmPurchaseBuyButton:WaitForChild("GiftTicket")
    v22.ConfirmPurchaseBuyButtonRobuxPrice = v22.ConfirmPurchaseBuyButton:WaitForChild("Robux")
    v22.ConfirmPurchaseSettingsFrame = v22.ConfirmPurchaseContainer:WaitForChild("Settings")
    v22.ConfirmPurchaseSettingsContainer = v22.ConfirmPurchaseSettingsFrame:WaitForChild("Container")
    v22.ConfirmPurchaseSettingsLayout = v22.ConfirmPurchaseSettingsContainer:WaitForChild("Layout")
    v22.ConfirmPurchaseSettingsNoteFrame = v22.ConfirmPurchaseSettingsContainer:WaitForChild("Note")
    v22.ConfirmPurchaseSettingsNoteDropdownFrame = v22.ConfirmPurchaseSettingsNoteFrame:WaitForChild("Dropdown")
    v22.ConfirmPurchaseSettingsNoteDropdownButton = v22.ConfirmPurchaseSettingsNoteDropdownFrame:WaitForChild("Button")
    v22.ConfirmPurchaseSettingsNoteDropdownButtonTitle = v22.ConfirmPurchaseSettingsNoteDropdownButton:WaitForChild("Title")
    v22.ConfirmPurchaseSettingsCustomNoteFrame = v22.ConfirmPurchaseSettingsContainer:WaitForChild("CustomNote")
    v22.ConfirmPurchaseSettingsCustomNoteContainer = v22.ConfirmPurchaseSettingsCustomNoteFrame:WaitForChild("Container")
    v22.ConfirmPurchaseSettingsCustomNoteLockedFrame = v22.ConfirmPurchaseSettingsCustomNoteContainer:WaitForChild("Locked")
    v22.ConfirmPurchaseSettingsCustomNoteUnlockedFrame = v22.ConfirmPurchaseSettingsCustomNoteContainer:WaitForChild("Unlocked")
    v22.ConfirmPurchaseSettingsCustomNoteBox = v22.ConfirmPurchaseSettingsCustomNoteUnlockedFrame:WaitForChild("Box")
    v22.ConfirmPurchaseSettingsCustomNoteCount = v22.ConfirmPurchaseSettingsCustomNoteUnlockedFrame:WaitForChild("Count")
    v22.ConfirmPurchaseSettingsAnonymousFrame = v22.ConfirmPurchaseSettingsContainer:WaitForChild("Anonymous")
    v22.ConfirmPurchaseSettingsAnonymousTitle = v22.ConfirmPurchaseSettingsAnonymousFrame:WaitForChild("Title")
    v22.ConfirmPurchaseSettingsAnonymousButton = v22.ConfirmPurchaseSettingsAnonymousFrame:WaitForChild("Button")
    v22.ConfirmPurchaseSettingsAnonymousEmpty = v22.ConfirmPurchaseSettingsAnonymousButton:WaitForChild("Empty")
    v22.ConfirmPurchaseSettingsAnonymousFilled = v22.ConfirmPurchaseSettingsAnonymousButton:WaitForChild("Filled")
    v22.PromptSystem = v_u_11.new(v22.PromptsFrame)
    v22._selected_player_input = nil
    v22._selected_product_id = nil
    v22._selected_player_lookup = nil
    v22._player_slots = {}
    v22._gift_slots = {}
    v22._fetch_player_data_hash = 0
    v22._generate_hash = 0
    v22._dont_redirect = nil
    v22:_Init()
    return v22
end
function v_u_19.CloseRequest(p23)
    if p23._dont_redirect then
        p23._dont_redirect = nil
        v_u_14.CloseRequest(p23)
    else
        p23.OpenPage:Fire("Shop", true)
    end
end
function v_u_19.Open(p24, ...)
    v_u_14.Open(p24, ...)
    p24:SelectPlayer(nil)
    task.spawn(p24._FetchGiftImages, p24)
    task.spawn(p24._GeneratePlayers, p24)
end
function v_u_19.Close(p25, ...)
    p25:SelectPlayer(nil)
    p25:_StopNoteDropdown()
    v_u_14.Close(p25, ...)
end
function v_u_19.DontRedirect(p26)
    p26._dont_redirect = true
end
function v_u_19.SelectPlayer(p27, p28)
    local v29 = not p28
    if not v29 then
        if typeof(p28) == "string" then
            v29 = true
        elseif typeof(p28) == "Instance" then
            v29 = p28:IsA("Player")
        else
            v29 = false
        end
    end
    local v30 = "Argument 1 invalid, expected a Player or string or nil, got " .. tostring(p28)
    assert(v29, v30)
    p27._fetch_player_data_hash = p27._fetch_player_data_hash + 1
    p27._selected_player_input = p28
    p27._selected_player_lookup = nil
    p27:_UpdateFrameVisibility()
    if p27._selected_player_input then
        task.spawn(p27._FetchSelectedPlayerData, p27)
    else
        p27:SelectProduct(nil)
    end
    task.spawn(p27._GeneratePlayers, p27)
end
function v_u_19.SelectProduct(p31, p32)
    local v33 = not p32 or typeof(p32) == "number"
    local v34 = "Argument 1 invalid, expected a number or nil, got " .. tostring(p32)
    assert(v33, v34)
    p31._fetch_player_data_hash = p31._fetch_player_data_hash + 1
    p31._selected_product_id = p32
    p31:_UpdateFrameVisibility()
end
function v_u_19.ConfirmPurchase(p35)
    if p35._selected_player_input and p35._selected_product_id then
        p35.ConfirmPurchaseList.Visible = false
        p35.ConfirmPurchaseDotsFrame.Visible = true
        p35.ConfirmPurchaseDotsFrame:AddTag("UILoadingDots")
        v_u_2.Remotes.Misc.PromptGiftProductPurchase:InvokeServer(p35._selected_product_id, p35._selected_player_lookup.UserID, p35._selected_player_lookup.IsOfflineGift, p35:_GetGiftNote(), p35.ConfirmPurchaseSettingsAnonymousFilled.Visible)
        p35.ConfirmPurchaseList.Visible = true
        p35.ConfirmPurchaseDotsFrame.Visible = false
        p35.ConfirmPurchaseDotsFrame:RemoveTag("UILoadingDots")
        p35:SelectPlayer(nil)
    end
end
function v_u_19._StopNoteDropdown(p36)
    if p36._note_dropdown_slot then
        p36._note_dropdown_slot:Cancel()
        p36._note_dropdown_slot = nil
    end
    p36.ConfirmPurchaseSettingsNoteDropdownButton.Visible = true
end
function v_u_19._StartNoteDropdown(p_u_37)
    p_u_37:_StopNoteDropdown()
    p_u_37.ConfirmPurchaseSettingsNoteDropdownButton.Visible = false
    p_u_37._note_dropdown_slot = v_u_12.new(p_u_37.ConfirmPurchaseSettingsNoteDropdownFrame, v_u_18)
    p_u_37._note_dropdown_slot.Selected:Connect(function(p38)
        if p38 then
            p_u_37.ConfirmPurchaseSettingsNoteDropdownButtonTitle.Text = p38
        end
        p_u_37:_StopNoteDropdown()
    end)
end
function v_u_19._GetGiftNote(p39)
    local v40 = p39.ConfirmPurchaseSettingsNoteDropdownButtonTitle.Text
    if v40 == "None" then
        return ""
    elseif v40 == "Custom" then
        return not p39.ConfirmPurchaseSettingsCustomNoteUnlockedFrame.Visible and "" or p39.ConfirmPurchaseSettingsCustomNoteBox.Text
    else
        return v40
    end
end
function v_u_19._VerifyNote(p41)
    p41.ConfirmPurchaseSettingsCustomNoteBox.Text = v_u_5:SanitizeGiftNote(p41.ConfirmPurchaseSettingsCustomNoteBox.Text) or ""
    p41.ConfirmPurchaseSettingsCustomNoteCount.Text = #p41.ConfirmPurchaseSettingsCustomNoteBox.Text .. " / " .. v_u_5.MAX_GIFTING_NOTE_CHARACTER_COUNT
    p41.ConfirmPurchaseSettingsCustomNoteCount.TextColor3 = #p41.ConfirmPurchaseSettingsCustomNoteBox.Text >= v_u_5.MAX_GIFTING_NOTE_CHARACTER_COUNT and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(255, 255, 255)
    p41.ConfirmPurchaseSettingsCustomNoteCount.TextTransparency = #p41.ConfirmPurchaseSettingsCustomNoteBox.Text >= v_u_5.MAX_GIFTING_NOTE_CHARACTER_COUNT and 0 or 0.5
end
function v_u_19._UpdateGiftReward(p42)
    local v43 = v_u_9:Get("GiftRobuxSpentProgress")
    local v44 = v_u_5:GetGiftRewardRobuxSpentRequirement(v_u_9:Get("GiftRobuxSpentRewardsClaimed"))
    local v45 = p42.PlayersGiftRewardProgressBar
    local v46 = UDim2.new
    local v47 = v43 / v44
    v45.Size = v46(math.clamp(v47, 0, 1), 0, 1, 2)
    p42.PlayersGiftRewardGoalText.Text = v_u_7:PrettyNumber(v43) .. " / " .. v_u_7:PrettyNumber(v44) .. " points"
end
function v_u_19._OfflineGiftingCooldown(p48)
    p48.PlayersOfflineGiftButtonCountdown.Visible = true
    p48.PlayersOfflineGiftButtonIcon.Visible = false
    for v49 = 15, 1, -1 do
        p48.PlayersOfflineGiftButtonCountdown.Text = v49
        wait(1)
    end
    p48.PlayersOfflineGiftButtonCountdown.Visible = false
    p48.PlayersOfflineGiftButtonIcon.Visible = true
end
function v_u_19._UpdateOfflineGiftingButton(p50)
    local v51 = p50.PlayersOfflineGiftButtonOn
    local v52 = p50.PlayersOfflineGiftButtonIcon.Visible
    if v52 then
        if p50.PlayersOfflineGiftBox.Text == "" then
            v52 = false
        else
            v52 = string.lower(p50.PlayersOfflineGiftBox.Text) ~= string.lower(v_u_3.LocalPlayer.Name) and true or v_u_4.IS_STUDIO
        end
    end
    v51.Visible = v52
    p50.PlayersOfflineGiftButtonOff.Visible = not p50.PlayersOfflineGiftButtonOn.Visible
end
function v_u_19._FetchGiftImages(p_u_53)
    for v_u_54, v_u_55 in pairs(v_u_5.Gifts) do
        if not v_u_55.ImageID then
            task.spawn(function()
                local v56, v57 = pcall(v_u_1.GetProductInfo, v_u_1, v_u_55.ProductID, Enum.InfoType.Product)
                if v_u_55.ImageID then
                    return
                elseif v56 then
                    v_u_55.ImageID = "rbxassetid://" .. v57.IconImageAssetId
                    p_u_53._gift_slots[v_u_54].Slot.Icon.Image = v_u_55.ImageID
                else
                    warn("Failed to fetch gamepass info:", v57)
                end
            end)
        end
    end
end
function v_u_19._FetchSelectedPlayerData(p58)
    p58._fetch_player_data_hash = p58._fetch_player_data_hash + 1
    local v59 = p58._fetch_player_data_hash
    p58.ProductsDotsFrame.Visible = true
    p58.ProductsDotsFrame:AddTag("UILoadingDots")
    p58.ProductsList.Visible = false
    p58._selected_player_lookup = nil
    wait(0.25)
    if p58._fetch_player_data_hash == v59 then
        local v60, v61 = v_u_2.Remotes.Misc.RequestGiftingDetails:InvokeServer(p58._selected_player_input)
        if p58._fetch_player_data_hash == v59 then
            p58.ProductsDotsFrame:RemoveTag("UILoadingDots")
            p58.ProductsDotsFrame.Visible = false
            p58.ProductsList.Visible = true
            if v60 and v61 then
                p58._selected_player_lookup = v61
            else
                if v61 then
                    p58.PromptSystem:Open("ErrorMessage", "Woops!", v61)
                end
                p58:SelectPlayer(nil)
            end
            p58:_UpdateProducts()
        end
    else
        return
    end
end
function v_u_19._UpdateConfirmPurchasePage(p62)
    if p62._selected_player_input and p62._selected_product_id then
        local v63 = v_u_5.Gifts
        local v64 = p62._selected_product_id
        local v65 = v63[tostring(v64)]
        local v66 = v_u_9:Get("GiftTickets")
        local v67 = p62._selected_product_id
        local v68 = v66[tostring(v67)] or 0
        local v69 = p62._selected_player_input
        local v70 = typeof(v69) == "string"
        p62.ConfirmPurchasePlayerPicture.Image = string.format(v_u_4.HEADSHOT_IMAGE, p62._selected_player_lookup.UserID)
        p62.ConfirmPurchasePlayerUsernameText.Text = not p62._selected_player_lookup.DisplayName and "" or (p62._selected_player_lookup.DisplayName == p62._selected_player_lookup.Name and "" or "@" .. p62._selected_player_lookup.Name)
        p62.ConfirmPurchasePlayerDisplayNameText.Text = p62._selected_player_lookup.DisplayName or "@" .. p62._selected_player_lookup.Name
        p62.ConfirmPurchasePlayerDisplayNameText.Position = p62.ConfirmPurchasePlayerUsernameText.Text == "" and UDim2.new(0.15, 0, 0.5, 0) or UDim2.new(0.15, 0, 0.4, 0)
        p62.ConfirmPurchaseProductIcon.Image = v65.ImageID or ""
        p62.ConfirmPurchaseProductTitleText.Text = v65.DisplayName
        p62.ConfirmPurchaseSettingsAnonymousTitle.Text = "Hide my name from " .. (p62._selected_player_lookup.DisplayName or p62._selected_player_lookup.Name)
        p62.ConfirmPurchaseSettingsCustomNoteLockedFrame.Visible = v70
        p62.ConfirmPurchaseSettingsCustomNoteUnlockedFrame.Visible = not v70
        p62.ConfirmPurchaseWarningsGiftTicketsFrame.Visible = v68 > 0
        p62.ConfirmPurchaseWarningsGiftTicketsText.Text = "\195\151" .. v68
        p62.ConfirmPurchaseBuyButtonGiftTicketIcon.Visible = v68 > 0
        p62.ConfirmPurchaseBuyButtonRobuxPrice.Visible = v68 <= 0
        p62.ConfirmPurchaseWarningsOfflineGiftingFrame.Visible = v70
        v_u_8:SetRobuxText(p62.ConfirmPurchaseBuyButtonRobuxPrice, p62._selected_product_id, Enum.InfoType.Product)
    end
end
function v_u_19._UpdateFrameVisibility(p71)
    p71.BackButton.Visible = p71._selected_player_input ~= nil
    p71.SelectPlayerFrame.Visible = not p71._selected_player_input
    local v72 = p71.SelectProductFrame
    local v73 = p71._selected_player_input
    if v73 then
        v73 = not p71._selected_product_id
    end
    v72.Visible = v73
    local v74 = p71.ConfirmPurchaseFrame
    local v75 = p71._selected_player_input
    if v75 then
        v75 = p71._selected_product_id
    end
    v74.Visible = v75
    p71.PlayersList.CanvasPosition = Vector2.new(0, 0)
    p71.ProductsList.CanvasPosition = Vector2.new(0, 0)
    p71.ConfirmPurchaseSettingsAnonymousFilled.Visible = false
    p71.ConfirmPurchaseSettingsAnonymousEmpty.Visible = true
    p71.ConfirmPurchaseSettingsCustomNoteBox.Text = ""
    p71.ConfirmPurchaseSettingsNoteDropdownButtonTitle.Text = "Surprise!"
    p71:_UpdateProducts()
    p71:_UpdateConfirmPurchasePage()
end
function v_u_19._UpdateProducts(p76)
    if p76._selected_player_input and not p76._selected_product_id then
        local v77 = v_u_9:Get("GiftTickets")
        for v78, v79 in pairs(p76._gift_slots) do
            local v80 = v77[v78] or 0
            v79.Slot.Button.GiftTicket.Visible = v80 > 0
            v79.Slot.Button.GiftTicket.Quantity.Text = "\195\151" .. v80
            local v81 = v79.Slot
            local v82 = p76._selected_player_lookup and (p76._selected_player_lookup.Data["Settings Receive Gifts"] and (v79.Info.GiftType ~= "Gamepass" or not p76._selected_player_lookup.Data.Gamepasses[v79.Info.GiftName]))
            if v82 then
                if v79.Info.GiftName == "BattlePassLevels10" and p76._selected_player_lookup.CurrentSeasonPassLevel >= v_u_6.CurrentSeason.NumBattlePassTiers or v79.Info.GiftName == "primeseason_bundle" and p76._selected_player_lookup.CurrentSeasonMaxPassTrackNum >= v_u_5.Bundles.primeseason_bundle.BattlePassMaxPassTrackNum then
                    v82 = false
                else
                    v82 = v79.Info.GiftName ~= "contrabandseason_bundle" and true or not p76._selected_player_lookup.CurrentSeasonSeasonPassBundleOwned
                end
            end
            v81.Visible = v82
        end
        local v83 = p76.ProductsEmptyFrame
        local v84 = p76._selected_player_lookup
        if v84 then
            v84 = not p76._selected_player_lookup.Data["Settings Receive Gifts"]
        end
        v83.Visible = v84
        p76.ProductsPlayerFrame.Visible = not p76.ProductsEmptyFrame.Visible
        p76.ProductsPlayerPicture.Image = not p76._selected_player_lookup and "" or string.format(v_u_4.HEADSHOT_IMAGE, p76._selected_player_lookup.UserID)
        p76.ProductsPlayerUsernameText.Text = not p76._selected_player_lookup and "" or (not p76._selected_player_lookup.DisplayName and "" or (p76._selected_player_lookup.DisplayName == p76._selected_player_lookup.Name and "" or "@" .. p76._selected_player_lookup.Name))
        p76.ProductsPlayerDisplayNameText.Text = not p76._selected_player_lookup and "" or (p76._selected_player_lookup.DisplayName or "@" .. p76._selected_player_lookup.Name)
        p76.ProductsPlayerDisplayNameText.Position = p76.ProductsPlayerUsernameText.Text == "" and UDim2.new(0.15, 0, 0.5, 0) or UDim2.new(0.15, 0, 0.4, 0)
    end
end
function v_u_19._GeneratePlayers(p_u_85)
    for _, v86 in pairs(p_u_85._player_slots) do
        v86:Destroy()
    end
    p_u_85._player_slots = {}
    p_u_85._generate_hash = p_u_85._generate_hash + 1
    local v87 = p_u_85._generate_hash
    local v88 = v_u_3:GetPlayers()
    table.sort(v88, function(p89, p90)
        return v_u_7:StringLessThan(p89.DisplayName, p90.DisplayName)
    end)
    local v91 = table.find(v88, v_u_3.LocalPlayer)
    if v91 then
        table.remove(v88, v91)
    end
    local v92 = v_u_3.LocalPlayer
    table.insert(v88, 1, v92)
    for v93, v_u_94 in pairs(v88) do
        if v_u_94 ~= v_u_3.LocalPlayer or v_u_4.IS_STUDIO then
            local v95 = v_u_17:Clone()
            v95.Username.Text = v_u_94.DisplayName == v_u_94.Name and "" or "@" .. v_u_94.Name
            v95.DisplayName.Text = v_u_94.DisplayName
            v95.DisplayName.Position = v95.Username.Text == "" and UDim2.new(0.175, 0, 0.5, 0) or UDim2.new(0.175, 0, 0.4, 0)
            v95.Icon.Image = string.format(v_u_4.HEADSHOT_IMAGE, v_u_94.UserId)
            v95.LayoutOrder = v93
            v95.Parent = p_u_85.PlayersContainer
            v_u_10:Add(v95.Button)
            local v96 = p_u_85._player_slots
            table.insert(v96, v95)
            v95.Button.MouseButton1Click:Connect(function()
                p_u_85:SelectPlayer(v_u_94)
            end)
            if v87 ~= p_u_85._generate_hash then
                return
            end
        end
    end
    for _ = #p_u_85._player_slots + 1, 6 do
        local v97 = v_u_15:Clone()
        v97.Parent = p_u_85.PlayersContainer
        local v98 = p_u_85._player_slots
        table.insert(v98, v97)
        if v87 ~= p_u_85._generate_hash then
            return
        end
    end
    local v99 = p_u_85._selected_player_input
    if typeof(v99) == "Instance" and p_u_85._selected_player_input.Parent ~= v_u_3 then
        p_u_85:SelectPlayer(nil)
    end
end
function v_u_19._Setup(p_u_100)
    for v101, v102 in pairs(v_u_5.GiftOrder) do
        local v_u_103 = v_u_5.Gifts[v102]
        local v104 = v_u_16:Clone()
        v104.Icon.Image = ""
        v104.DisplayName.Text = v_u_103.DisplayName
        v104.LayoutOrder = v101
        v104.Parent = p_u_100.ProductsContainer
        v_u_10:Add(v104.Button)
        v104.Button.MouseButton1Click:Connect(function()
            p_u_100:SelectProduct(v_u_103.ProductID)
        end)
        p_u_100._gift_slots[v102] = {
            ["Slot"] = v104,
            ["Info"] = v_u_103
        }
    end
    v_u_13.new({
        ["Name"] = v_u_5.GIFT_REWARD_DATA,
        ["Quantity"] = 1,
        ["Weapon"] = "IsRandom"
    }):SetParent(p_u_100.PlayersGiftRewardContainer)
end
function v_u_19._Init(p_u_105)
    p_u_105.CloseButton.MouseButton1Click:Connect(function()
        p_u_105:CloseRequest()
    end)
    p_u_105.BackButton.MouseButton1Click:Connect(function()
        if p_u_105._selected_product_id then
            p_u_105:SelectProduct(nil)
        elseif p_u_105._selected_player_input then
            p_u_105:SelectPlayer(nil)
        end
    end)
    p_u_105.ConfirmPurchaseBuyButton.MouseButton1Click:Connect(function()
        p_u_105:ConfirmPurchase()
    end)
    p_u_105.ConfirmPurchaseSettingsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p_u_105.ConfirmPurchaseSettingsFrame.Size = UDim2.new(1, 0, 0, p_u_105.ConfirmPurchaseSettingsLayout.AbsoluteContentSize.Y)
    end)
    p_u_105.PlayersLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p_u_105.PlayersList.CanvasSize = UDim2.new(0, 0, 0, p_u_105.PlayersLayout.AbsoluteContentSize.Y)
    end)
    p_u_105.ProductsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p_u_105.ProductsList.CanvasSize = UDim2.new(0, 0, 0, p_u_105.ProductsLayout.AbsoluteContentSize.Y)
    end)
    p_u_105.ConfirmPurchaseLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p_u_105.ConfirmPurchaseList.CanvasSize = UDim2.new(0, 0, 0, p_u_105.ConfirmPurchaseLayout.AbsoluteContentSize.Y)
    end)
    p_u_105.ConfirmPurchaseSettingsNoteDropdownButtonTitle:GetPropertyChangedSignal("Text"):Connect(function()
        p_u_105.ConfirmPurchaseSettingsCustomNoteFrame.Visible = p_u_105.ConfirmPurchaseSettingsNoteDropdownButtonTitle.Text == "Custom"
    end)
    p_u_105.PlayersOfflineGiftBox:GetPropertyChangedSignal("Text"):Connect(function()
        p_u_105:_UpdateOfflineGiftingButton()
    end)
    p_u_105.PlayersOfflineGiftButtonIcon:GetPropertyChangedSignal("Visible"):Connect(function()
        p_u_105:_UpdateOfflineGiftingButton()
    end)
    p_u_105.PlayersOfflineGiftButton.MouseButton1Click:Connect(function()
        if p_u_105.PlayersOfflineGiftButtonOn.Visible and p_u_105.PlayersOfflineGiftButtonIcon.Visible then
            local v106 = p_u_105.PlayersOfflineGiftBox.Text
            task.defer(p_u_105._OfflineGiftingCooldown, p_u_105)
            p_u_105.PlayersOfflineGiftBox.Text = ""
            p_u_105:SelectPlayer(v106)
        end
    end)
    p_u_105.ConfirmPurchaseSettingsCustomNoteBox:GetPropertyChangedSignal("Text"):Connect(function()
        p_u_105:_VerifyNote()
    end)
    p_u_105.ConfirmPurchaseSettingsAnonymousButton.MouseButton1Click:Connect(function()
        p_u_105.ConfirmPurchaseSettingsAnonymousEmpty.Visible = not p_u_105.ConfirmPurchaseSettingsAnonymousEmpty.Visible
        p_u_105.ConfirmPurchaseSettingsAnonymousFilled.Visible = not p_u_105.ConfirmPurchaseSettingsAnonymousEmpty.Visible
    end)
    p_u_105.ConfirmPurchaseSettingsNoteDropdownButton.MouseButton1Click:Connect(function()
        p_u_105:_StartNoteDropdown()
    end)
    v_u_9:GetDataChangedSignal("GiftTickets"):Connect(function()
        p_u_105:_UpdateProducts()
    end)
    v_u_9:GetDataChangedSignal("GiftRobuxSpentProgress"):Connect(function()
        p_u_105:_UpdateGiftReward()
    end)
    v_u_9:GetDataChangedSignal("GiftRobuxSpentRewardsClaimed"):Connect(function()
        p_u_105:_UpdateGiftReward()
    end)
    v_u_8.PurchaseFinished:Connect(function()
        p_u_105:SelectPlayer(nil)
    end)
    p_u_105:_Setup()
    p_u_105:SelectPlayer(nil)
    p_u_105:_UpdateGiftReward()
    v_u_10:Add(p_u_105.BackButton)
    v_u_10:Add(p_u_105.CloseButton)
    v_u_10:Add(p_u_105.PlayersOfflineGiftButton)
    v_u_10:Add(p_u_105.ConfirmPurchaseSettingsAnonymousButton)
    v_u_10:Add(p_u_105.ConfirmPurchaseBuyButton, nil, {
        ["HoverRatio"] = UDim2.new(0, 10, 0, 10),
        ["ReleaseRatio"] = UDim2.new(0, 10, 0, 10)
    })
    v_u_10:Add(p_u_105.ConfirmPurchaseSettingsNoteDropdownButton, nil, {
        ["ReleaseRatio"] = 1.025,
        ["HoverRatio"] = 1.025
    })
end
return v_u_19._new()