local v1 = {}
local v2 = {
    ["CURRENCY_NAME"] = "Candy",
    ["CURRENCY_NAME_PLURAL"] = "Candy",
    ["CURRENCY_IMAGE"] = "rbxassetid://139984992207621",
    ["CURRENCY_IMAGE_FLAT"] = "rbxassetid://105505748492292",
    ["CURRENCY_IMAGE_FLAT_OUTLINE"] = "rbxassetid://90825880394324",
    ["CURRENCY_COLOR"] = Color3.fromRGB(255, 127, 0),
    ["CURRENCY_COLOR_GRADIENT"] = nil,
    ["BUNDLE_BACKGROUND_IMAGES"] = {
        [1] = "rbxassetid://140701532981455",
        [5] = "rbxassetid://121767138688269"
    },
    ["OVERVIEW_BANNER_IMAGE"] = "rbxassetid://139741589762862",
    ["OVERVIEW_BUTTON_IMAGE"] = "rbxassetid://80974689450076",
    ["LOADING_SCREEN_LOGO"] = "rbxassetid://120926957566724",
    ["LOBBY_MUSIC"] = "Spooky",
    ["LOBBY_MUSIC_MUFFLED"] = "SpookyMuffled",
    ["LOBBY_LIGHTING_PROFILE"] = "LobbySpooky",
    ["EQUIPMENT_LIGHTING_PROFILE"] = "LobbySpooky",
    ["LTM_HEADER_ICON"] = "rbxassetid://78136793834272"
}
v1.Spooky = v2
local v3 = {
    ["CURRENCY_NAME"] = "Crystal",
    ["CURRENCY_NAME_PLURAL"] = "Crystals",
    ["CURRENCY_IMAGE"] = "rbxassetid://134934134842764",
    ["CURRENCY_IMAGE_FLAT"] = "rbxassetid://116178247622565",
    ["CURRENCY_IMAGE_FLAT_OUTLINE"] = "rbxassetid://89625231758124",
    ["CURRENCY_COLOR"] = Color3.fromRGB(48, 221, 255),
    ["CURRENCY_COLOR_GRADIENT"] = nil,
    ["BUNDLE_BACKGROUND_IMAGES"] = {
        [1] = "rbxassetid://135222754688862",
        [5] = "rbxassetid://93388902108383"
    },
    ["OVERVIEW_BANNER_IMAGE"] = "rbxassetid://109554184678249",
    ["OVERVIEW_BUTTON_IMAGE"] = "rbxassetid://134934134842764",
    ["LOADING_SCREEN_LOGO"] = "rbxassetid://101362140024495",
    ["LOBBY_MUSIC"] = "Festive",
    ["LOBBY_MUSIC_MUFFLED"] = "FestiveMuffled",
    ["LOBBY_LIGHTING_PROFILE"] = "LobbyFestive",
    ["EQUIPMENT_LIGHTING_PROFILE"] = "LobbyFestive",
    ["LTM_HEADER_ICON"] = "rbxassetid://78136793834272"
}
v1.Festive = v3
local v_u_4 = {
    ["IS_ACTIVE"] = true,
    ["NUM_GAMES_NEEDED_TO_PARTICIPATE"] = 15,
    ["RESET_CURRENCY_COUNTER"] = 5,
    ["RESET_CURRENCY_COMPENSATION_MILESTONE"] = 30,
    ["RESET_CURRENCY_COMPENSATION_REWARDS"] = {
        {
            ["Name"] = "Haunted Chest",
            ["Quantity"] = 1,
            ["Weapon"] = "IsRandom"
        }
    },
    ["RESET_CURRENCY_COMPENSATION_REWARDS_CAN_MULTIPLY_QUANTITY"] = true,
    ["LAST_EVENT_NAME"] = "Spooky",
    ["EVENT_NAME"] = "Festive",
    ["EVENT_TASK_NAMES"] = { "EventDuelRoundPlayed", "EventEliminations", "EventDuelWon" },
    ["CURRENCY_RUSH_DAILY_LIMIT"] = 250,
    ["CURRENCY_RUSH_MULTIPLIER"] = 5,
    ["LTM_QUEUENAMES"] = {},
    ["UNIVERSAL_SHOP_CHARM"] = "Penguin",
    ["UNIVERSAL_SHOP_WRAP"] = "Stocking Fur",
    ["UNIVERSAL_SHOP_FINISHER"] = "Sleigh Away",
    ["UNIVERSAL_SHOP_EMOTE"] = "Sleigh Ride",
    ["SPECIAL_LOOTBOX_SKINS"] = "Festive Skin Case",
    ["SPECIAL_LOOTBOX_VARIETY"] = "Jolly Chest",
    ["CURRENCY_BUNDLE_CHARM"] = "Mini Snowglobe",
    ["CURRENCY_BUNDLE_WRAP"] = "Crystallized",
    ["CURRENCY_BUNDLE_FINISHER"] = "Giant Ice Spike",
    ["CURRENCY_BUNDLE_SKIN"] = "Crystal Katana",
    ["EVENT_GIFT_REWARD"] = nil,
    ["EVENT_GIFT_COOLDOWN"] = 3600,
    ["SHOP_ENTRIES_OVERVIEW"] = {}
}
v_u_4.EVENT_DETAILS = v1[v_u_4.EVENT_NAME]
v_u_4.LAST_EVENT_DETAILS = v1[v_u_4.LAST_EVENT_NAME];
(function()
    if v_u_4.SPECIAL_LOOTBOX_SKINS then
        local v5 = v_u_4.SHOP_ENTRIES_OVERVIEW
        local v6 = "lootbox_" .. v_u_4.SPECIAL_LOOTBOX_SKINS
        table.insert(v5, v6)
    end
    if v_u_4.SPECIAL_LOOTBOX_VARIETY then
        local v7 = v_u_4.SHOP_ENTRIES_OVERVIEW
        local v8 = "lootbox_" .. v_u_4.SPECIAL_LOOTBOX_VARIETY
        table.insert(v7, v8)
    end
    local v9 = v_u_4.SHOP_ENTRIES_OVERVIEW
    table.insert(v9, "lootbox_Festive Wrap Box 2")
    if v_u_4.UNIVERSAL_SHOP_CHARM then
        local v10 = v_u_4.SHOP_ENTRIES_OVERVIEW
        local v11 = "loose_" .. v_u_4.UNIVERSAL_SHOP_CHARM
        table.insert(v10, v11)
    end
    if v_u_4.UNIVERSAL_SHOP_WRAP then
        local v12 = v_u_4.SHOP_ENTRIES_OVERVIEW
        local v13 = "loose_" .. v_u_4.UNIVERSAL_SHOP_WRAP
        table.insert(v12, v13)
    end
    if v_u_4.UNIVERSAL_SHOP_FINISHER then
        local v14 = v_u_4.SHOP_ENTRIES_OVERVIEW
        local v15 = "loose_" .. v_u_4.UNIVERSAL_SHOP_FINISHER
        table.insert(v14, v15)
    end
    if v_u_4.UNIVERSAL_SHOP_EMOTE then
        local v16 = v_u_4.SHOP_ENTRIES_OVERVIEW
        local v17 = "loose_" .. v_u_4.UNIVERSAL_SHOP_EMOTE
        table.insert(v16, v17)
    end
end)()
return v_u_4