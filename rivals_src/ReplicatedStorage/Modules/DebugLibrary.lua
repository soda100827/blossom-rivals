local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v3 = require(v1.Modules.CONSTANTS)
local v4 = require(v1.Modules.CosmeticLibrary)
local v_u_5 = require(v1.Modules.SettingsInfo)
local v6 = require(v1.Modules.EventLibrary)
local v7 = require(v1.Modules.ItemLibrary)
local v_u_8 = v3.IS_STUDIO or v3.IS_TESTING_SERVER
local v_u_9 = {
    {
        v3.TEAM_MEMBER_RANK,
        { "GetMatchmakingData", "ExportServerLogs" }
    }
}
local _ = v3.IS_PRIVATE_HUB_SERVER
local v_u_30 = {
    ["DEBUG_WHITELIST_USERS"] = {
        ["15941965"] = true,
        ["20349956"] = true
    },
    ["Order"] = {},
    ["Info"] = {},
    ["GetWhitelistedCommands"] = function(p10, p11, p12)
        local v13 = {}
        local v14 = p10.DEBUG_WHITELIST_USERS[tostring(p11)]
        if typeof(v14) == "table" then
            for _, v15 in pairs(v14) do
                v13[v15] = true
            end
        end
        for _, v16 in pairs(v_u_9) do
            if p12 >= v16[1] then
                for _, v17 in pairs(v16[2]) do
                    v13[v17] = true
                end
            end
        end
        local v18 = {}
        for v19 in pairs(v13) do
            table.insert(v18, v19)
        end
        return v18
    end,
    ["HasTotalAccess"] = function(p20, p21, _)
        return v_u_8 and true or p20.DEBUG_WHITELIST_USERS[tostring(p21)] == true
    end,
    ["HasBasicAccess"] = function(p22, p23, p24)
        return v_u_8 and true or #p22:GetWhitelistedCommands(p23, p24) > 0
    end,
    ["HasAccessToCommand"] = function(p25, p26, p27, p28)
        if v_u_8 then
            return true
        end
        local v29 = not p25:HasTotalAccess(p26, p27) and p25:HasBasicAccess(p26, p27)
        if v29 then
            v29 = table.find(p25:GetWhitelistedCommands(p26, p27), p28) ~= nil
        end
        return v29
    end
}
local v31 = 0
local function v34(...)
    local v32 = v_u_5.new(...)
    v_u_30.Info[v32.Name] = v32
    local v33 = v_u_30.Order
    table.insert(v33, v32)
end
if v3.IS_CLIENT and not v_u_30:HasBasicAccess(v2.LocalPlayer.UserId, require(v2.LocalPlayer.PlayerScripts.Controllers.PlayerDataController):Get("GroupRank")) then
    return v_u_30
end
local v35 = "Fun"
local v36
if v35 == "" then
    v35 = string.rep(" ", v31)
    v31 = v31 + 1
    v36 = v31
else
    v36 = v31
end
local v37 = v_u_5.new("Debug", v35, "", "", "", "Divider")
local v38 = v_u_30.Order
table.insert(v38, v37)
v34("Debug", "OctoMode", "Octo Mode", "rbxassetid://18223601855", "Allows you to equip multiple weapons at once", "SliderConfirm", 4, 1, 4, 1)
v34("Debug", "OctoMode2", "Octo Mode 2", "rbxassetid://18223601855", "Equips ALL weapons at once", "ToggleConfirm", false)
v34("Debug", "OctoMode3", "Octo Mode 3", "rbxassetid://18223601855", "Equips ALL weapons + SKINS at once (very laggy)", "ToggleConfirm", false)
v34("Debug", "InfiniteAmmo", "Infinite Ammo", "rbxassetid://18223601855", "No need to worry about ammo anymore", "ToggleConfirm", false)
v34("Debug", "InfiniteAmmoReserve", "Infinite Ammo Reserve", "rbxassetid://18223601855", "Reloads for days", "ToggleConfirm", false)
v34("Debug", "Invincibility", "Invincibility", "rbxassetid://18223601855", "You can no longer die", "ToggleConfirm", false)
v34("Debug", "MaxInvincibility", "Max Invincibility", "rbxassetid://18223601855", "You can no longer die or be frozen or be affected by anything", "ToggleConfirm", false)
v34("Debug", "InfiniteDamage", "OHKO", "rbxassetid://18223601855", "Easy mode", "ToggleConfirm", false)
v34("Debug", "ExplosiveDamage", "Explosive Hands", "rbxassetid://18223601855", "Everything blows up", "ToggleConfirm", false)
v34("Debug", "ChangeMoveSpeed", "Move Speed Boost", "rbxassetid://18223601855", "Change how fast you run", "SliderConfirm", 0, 0, 10, 10)
v34("Debug", "SetHandicapsEnabled", "Handicaps", "rbxassetid://18223601855", "Enable/disable aim assist + autoshoot + third person", "ToggleConfirm", false)
v34("Debug", "EquipWeaponNow", "Equip Weapon Now", "rbxassetid://18223601855", "Equips a specific weapon, including unobtainable ones", "DropdownConfirm", "Assault Rifle", v7.ItemsAlphabetized)
v34("Debug", "DeleteWeapons", "Delete My Weapons", "rbxassetid://18223601855", "Clears your hotbar of weapons", "Confirm")
v34("Debug", "LeaveDuelNow", "Leave Current Duel", "rbxassetid://18223601855", "So that you don\'t have to rejoin the server", "Confirm")
local v39 = "Numbers"
if v39 == "" then
    v39 = string.rep(" ", v36)
    v31 = v36 + 1
    v36 = v31
end
local v40 = v_u_5.new("Debug", v39, "", "", "", "Divider")
local v41 = v_u_30.Order
table.insert(v41, v40)
v34("Debug", "SetLevel", "Level", "rbxassetid://18223601855", "Change your level", "SliderConfirm", 0, 0, 9999, 1)
v34("Debug", "SetKeys", "Keys", "rbxassetid://18223601855", "Change how many keys you have", "SliderConfirm", 0, 0, 9999, 1)
v34("Debug", "SetUnlockTokens", "Unlock Tokens", "rbxassetid://18223601855", "Change how many unlock tokens you have", "SliderConfirm", 0, 0, 9999, 1)
v34("Debug", "SetEventCurrency", v6.EVENT_DETAILS.CURRENCY_NAME_PLURAL, "rbxassetid://18223601855", "Change how much event currency you have", "SliderConfirm", 0, 0, 9999, 1)
v34("Debug", "SetDailyTaskStreak", "Daily Task Streak", "rbxassetid://18223601855", "Changes your daily task streak", "SliderConfirm", 0, 0, 100, 1)
v34("Debug", "SetGlory", "Glory", "rbxassetid://18223601855", "Change how much glory you have (ranked reward currency)", "SliderConfirm", 0, 0, 9999, 1)
v34("Debug", "SetSkinTickets", "Skin Tickets", "rbxassetid://18223601855", "Change how much skin tickets you have (free skin cases)", "SliderConfirm", 0, 0, 9999, 1)
v34("Debug", "SetWinStreak", "Win Streak", "rbxassetid://18223601855", "Change your current win streak", "SliderConfirm", 0, 0, 9999, 1)
v34("Debug", "SetDuelsPlayed", "Duels Played", "rbxassetid://18223601855", "To test out beginner notifications/features", "SliderConfirm", 0, 0, 100, 1)
v34("Debug", "SetDuelsWon", "Duels Won", "rbxassetid://18223601855", "To test out beginner notifications/features", "SliderConfirm", 0, 0, 100, 1)
v34("Debug", "SetDuelsLost", "Duels Lost", "rbxassetid://18223601855", "To test out beginner notifications/features", "SliderConfirm", 0, 0, 100, 1)
v34("Debug", "SetHealth", "Health", "rbxassetid://18223601855", "Changes your current health", "SliderConfirm", 0, 0, 150, 1)
v34("Debug", "SetGiftTickets", "Set Random Gift Tickets", "rbxassetid://18223601855", "Gives you a random amount of gift tickets", "Confirm", false)
local v42 = "Unlocks"
if v42 == "" then
    v42 = string.rep(" ", v36)
    v31 = v36 + 1
    v36 = v31
end
local v43 = v_u_5.new("Debug", v42, "", "", "", "Divider")
local v44 = v_u_30.Order
table.insert(v44, v43)
v34("Debug", "LockWeapons", "Lock All Weapons", "rbxassetid://18223601855", "Locks all weapons", "Confirm", false)
v34("Debug", "UnlockWeapons", "Unlock All Weapons", "rbxassetid://18223601855", "Unlocks all weapons", "Confirm", false)
v34("Debug", "UnlockSkins", "Unlock All Skins", "rbxassetid://18223601855", "Unlocks all skins", "Confirm", false)
v34("Debug", "UnlockWraps", "Unlock All Wraps", "rbxassetid://18223601855", "Unlocks all wraps for all weapons", "Confirm", false)
v34("Debug", "UnlockCharms", "Unlock All Charms", "rbxassetid://18223601855", "Unlocks all charms for all weapons", "Confirm", false)
v34("Debug", "UnlockFinishers", "Unlock All Finishers", "rbxassetid://18223601855", "Unlocks all finishers for all weapons", "Confirm", false)
v34("Debug", "UnlockEmotes", "Unlock All Emotes", "rbxassetid://18223601855", "Unlocks all emotes", "Confirm", false)
v34("Debug", "UnlockCosmeticsPartially", "Unlock All Cosmetics Partially", "rbxassetid://18223601855", "Randomly unlock half of all cosmetics (to test UI)", "Confirm", false)
v34("Debug", "UnlockAllCosmeticsForUnlockedWeapons", "Unlock Cosmetics (Owned Weapons)", "rbxassetid://18223601855", "For unlocked weapons only (to test out lootbox bug)", "Confirm", false)
v34("Debug", "EquipSkinsFromCase", "Equip Skins From Case", "rbxassetid://18223601855", "Quickly equip all skins from a specific case", "DropdownConfirm", "Skin Case", v4.LootboxOrder)
v34("Debug", "EquipCosmetics", "Equip Cosmetics", "rbxassetid://18223601855", "Quickly equip cosmetics in all slots for all weapons", "Confirm", false)
v34("Debug", "LockCosmetics", "Lock All Cosmetics", "rbxassetid://18223601855", "Lock all cosmetics for all weapons", "Confirm", false)
v34("Debug", "SetWeaponXP", "Weapon XP %", "rbxassetid://18223601855", "To test weapon XP bars & level up costs", "SliderConfirm", 0.5, 0, 1, 10)
local v45 = "Loot"
if v45 == "" then
    v45 = string.rep(" ", v36)
    v31 = v36 + 1
    v36 = v31
end
local v46 = v_u_5.new("Debug", v45, "", "", "", "Divider")
local v47 = v_u_30.Order
table.insert(v47, v46)
v34("Debug", "OpenLootboxes", "Open All Lootboxes", "rbxassetid://18223601855", "Opens 1 of every lootbox at the same time", "Confirm", false)
v34("Debug", "GiveLootboxes", "Give Lootboxes", "rbxassetid://18223601855", "Gives you 1 of every lootbox", "Confirm", false)
v34("Debug", "GiveGamepasses", "Give Gamepasses", "rbxassetid://18223601855", "Simulates purchasing all gamepasses", "Confirm", false)
v34("Debug", "GiveExpirableItem", "Give Expirable Item", "rbxassetid://18223601855", "Gives you a weapon crate that will expire in 30 seconds", "Confirm", false)
v34("Debug", "ClearBackpack", "Clear Backpack", "rbxassetid://18223601855", "Deletes any of your extra lootboxes, cosmetics, etc.", "Confirm", false)
local v48 = "Season"
if v48 == "" then
    v48 = string.rep(" ", v36)
    v31 = v36 + 1
    v36 = v31
end
local v49 = v_u_5.new("Debug", v48, "", "", "", "Divider")
local v50 = v_u_30.Order
table.insert(v50, v49)
v34("Debug", "SetELO", "ELO", "rbxassetid://18223601855", "Change your current ELO (placements have to be done)", "SliderConfirm", 0, 0, 9999, 1)
v34("Debug", "SetRankedDuelsWon", "Ranked Duels Won", "rbxassetid://18223601855", "Edit your # of ranked duels won (to test ranked contract)", "SliderConfirm", 0, 0, 9999, 1)
v34("Debug", "SetPlacements", "Ranked Placements Status", "rbxassetid://18223601855", "Will either clear your placements or place you at 1,000 ELO", "ToggleConfirm", false)
v34("Debug", "RemoveRankedTimeout", "Remove Ranked Timeout", "rbxassetid://18223601855", "Remove the ranked timeout you get from dodging", "Confirm", false)
v34("Debug", "SetBattlePassLevel", "Season Pass Level", "rbxassetid://18223601855", "Change your season pass level", "SliderConfirm", 0, 0, 100, 1)
v34("Debug", "SetBattlePassPrime", "Prime Season Pass", "rbxassetid://18223601855", "Upgrade/downgrade your season pass status", "ToggleConfirm", false)
v34("Debug", "ResetSeasonData", "Reset Season Data", "rbxassetid://18223601855", "Deletes your current season\'s ranked and season pass data", "Confirm", false)
v34("Debug", "SimulateELOForSeasonalCharm", "Simulate Last Season\'s ELO", "rbxassetid://18223601855", "To look at the different ranks for the Seasonal Charm", "SliderConfirm", 0, 0, 9999, 1)
v34("Debug", "SimulateTopRankForSeasonalCharm", "Simulate Last Season LB Spot", "rbxassetid://18223601855", "Turn this on to simulate you being #1 last season (archnem charm)", "ToggleConfirm", false)
local v51 = "Actions"
if v51 == "" then
    v51 = string.rep(" ", v36)
    v31 = v36 + 1
    v36 = v31
end
local v52 = v_u_5.new("Debug", v51, "", "", "", "Divider")
local v53 = v_u_30.Order
table.insert(v53, v52)
v34("Debug", "LevelUp", "Level Up", "rbxassetid://18223601855", "Levels your career level up by 1", "Confirm", false)
v34("Debug", "IncrementTasks", "Increment Tasks", "rbxassetid://18223601855", "Adds +1 progress to every task", "Confirm", false)
v34("Debug", "RefreshDailyTasks", "Refresh Daily Tasks", "rbxassetid://18223601855", "Refreshes your Daily Tasks", "Confirm", false)
v34("Debug", "CompleteNextWeaponContracts", "Complete Next Weapon Contracts", "rbxassetid://18223601855", "Completes the next contract milestone on all weapons", "Confirm", false)
v34("Debug", "RestartSpecialChallenges", "Restart Special Challenges", "rbxassetid://18223601855", "Clears your special challenges progress (if possible)", "Confirm", false)
v34("Debug", "EndWinStreak", "End Win Streak", "rbxassetid://18223601855", "Simulates you losing a win streak (for testing recoveries)", "Confirm", false)
v34("Debug", "TeleportRandomly", "Teleport To Random Player", "rbxassetid://18223601855", "Useful for seeing if the anticheat stops you from griefing", "Confirm", false)
local v54 = "Advanced"
if v54 == "" then
    v54 = string.rep(" ", v36)
    v31 = v36 + 1
    v36 = v31
end
local v55 = v_u_5.new("Debug", v54, "", "", "", "Divider")
local v56 = v_u_30.Order
table.insert(v56, v55)
v34("Debug", "ShutdownServer", "Shutdown Server", "rbxassetid://18223601855", "Kicks everyone in this server from the game", "Confirm", false)
v34("Debug", "SetHitboxesVisible", "Player Hitboxes Visible", "rbxassetid://18223601855", "Enables player hitboxes", "ToggleConfirm", false)
v34("Debug", "SetMapSpawnsVisible", "Set Map Spawns Visible", "rbxassetid://18223601855", "Shows where all the spawns are in maps", "ToggleConfirm", false)
v34("Debug", "SetOOBVisible", "Set OOB Parts Visible", "rbxassetid://18223601855", "Shows all out-of-bounds parts", "ToggleConfirm", false)
v34("Debug", "SetMapBarriersVisible", "Set Map Barriers Visible", "rbxassetid://18223601855", "Shows all invisible barriers in maps", "ToggleConfirm", false)
v34("Debug", "RevealShadyChickenRoom", "Reveal Shady Chicken Room", "rbxassetid://18223601855", "In the Shooting Range", "Confirm", false)
v34("Debug", "DisableTransparentHats", "Disable Transparent Hats", "rbxassetid://18223601855", "Turns off the transparent big hats restriction", "ToggleConfirm", false)
v34("Debug", "SetMaxDuelPadWinsToday", "Max Duel Pad Wins Today", "rbxassetid://18223601855", "If turned on, you will no longer be able to grind duel pads", "ToggleConfirm", false)
local v57 = "Internal"
if v57 == "" then
    v57 = string.rep(" ", v36)
    v31 = v36 + 1
    v36 = v31
end
local v58 = v_u_5.new("Debug", v57, "", "", "", "Divider")
local v59 = v_u_30.Order
table.insert(v59, v58)
v34("Debug", "ResetTheHunt", "Reset The Hunt Progress", "rbxassetid://18223601855", "Internal use only (rejoin after use)", "Confirm", false)
v34("Debug", "DisableDeviceAutoSwitch", "Disable Device Auto Switch", "rbxassetid://18223601855", "Switching control schemes wont be recognized once this is on", "ToggleConfirm", false)
v34("Debug", "EndCurrentArcadeDuel", "End Arcade Duel (TDM/FFA/etc)", "rbxassetid://18223601855", "This won\'t work for any normal duels/limited time modes", "Confirm", false)
v34("Debug", "SpectateNilDuel", "Unspectate Current Duel", "rbxassetid://18223601855", "Attempts to cause the \"map not loading\" bug", "Confirm", false)
v34("Debug", "DisableAntiNetLimiter", "Disable Anti-Net-Limiter", "rbxassetid://18223601855", "Allows you to use a net limiter without getting kicked", "ToggleConfirm", false)
v34("Debug", "GetMatchmakingData", "Get Matchmaking Data", "rbxassetid://18223601855", "Fetches getMatchData + country codes + latencies", "Confirm", false)
v34("Debug", "ShowClientEnvironment", "Show Client Environment", "rbxassetid://18223601855", "Internal use only", "Confirm", false)
v34("Debug", "RTEFlush", "Flush RTE Requests", "rbxassetid://18223601855", "Internal use only", "Confirm", false)
v34("Debug", "HighestELOLeaderboardELODecay", "Flush ELO Decayers", "rbxassetid://18223601855", "Kicks people off the ELO leaderboard if they\'ve decayed", "Confirm", false)
v34("Debug", "ExportServerLogs", "Export Server Logs", "rbxassetid://18223601855", "Sends hidden errors / useful info about this server to devs", "Confirm", false)
local v60 = "FFlags"
if v60 == "" then
    v60 = string.rep(" ", v36)
    v31 = v36 + 1
    v36 = v31
end
local v61 = v_u_5.new("Debug", v60, "", "", "", "Divider")
local v62 = v_u_30.Order
table.insert(v62, v61)
v34("Debug", "SetSpecialChallengesEnabled", "Special Challenges Enabled", "rbxassetid://18223601855", "Enable/disable the special challenges feature real-time", "ToggleConfirm", false)
v34("Debug", "SetEventEndTime", "Event End Time (-1 = Disabled)", "rbxassetid://18223601855", "Starts the event countdown, uses epoch time", "SliderConfirm", -1, -1, (1 / 0), 1)
v34("Debug", "SetSeasonEndTime", "Season End Time (-1 = Disabled)", "rbxassetid://18223601855", "Starts the season countdown, uses epoch time", "SliderConfirm", -1, -1, (1 / 0), 1)
v34("Debug", "SetFreeToUseStandardWeapons", "FREE Standard Weapons", "rbxassetid://18223601855", "Allows all players to use locked Standard weapons", "ToggleConfirm", false)
v34("Debug", "SetFreeToUsePrimeWeapons", "FREE Prime Weapons", "rbxassetid://18223601855", "Allows all players to use locked Prime weapons", "ToggleConfirm", false)
local v63 = "Last"
if v63 == "" then
    v63 = string.rep(" ", v36)
    v31 = v36 + 1
end
local v64 = v_u_5.new("Debug", v63, "", "", "", "Divider")
local v65 = v_u_30.Order
table.insert(v65, v64)
v34("Debug", "SendOfflineGiftRewards", "Send Offline Gift Rewards", "rbxassetid://18223601855", "To easily give out Net wraps and Bug Net skins", "Confirm", false)
return v_u_30