local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = require(v1.Modules.SettingsInfo)
local v3 = require(v1.Modules.DuelLibrary)
local v_u_4 = {
    ["Order"] = {},
    ["Info"] = {}
}
local function v7(...)
    local v5 = v_u_2.new(...)
    v_u_4.Info[v5.Name] = v5
    local v6 = v_u_4.Order
    table.insert(v6, v5)
end
v7("General", "Settings Map Voting Style", "Map Voting Style", "________________________", "Change the way map voting works", "Dropdown", "Weighted", { "Weighted Odds", "Majority Pick", "Elimination" })
v7("General", "Settings Rounds Behavior", "Rounds Behavior", "________________________", "Switch between duel-style rounds or deathmatch-style rounds", "Dropdown", "Duels", { "Duels", "Deathmatch" })
v7("General", "Settings Round Timer", "Round Timer", "________________________", "Set how long a single round lasts", "Slider", 90, 15, 12000, 1)
v7("General", "Settings Score Win Threshold", "Winning Score", "________________________", "How many points a player or team needs to win", "Slider", 90, 15, 12000, 1)
v7("General", "Settings Teams Enabled", "Teams Enabled", "________________________", "Turn this off for free-for-all style duels", "Toggle", false)
v7("General", "Settings Team Switching", "Team Switching", "________________________", "Allows players to switch teams at any time", "Toggle", false)
v7("General", "Settings Team Balancing", "Team Balancing", "________________________", "Prevents players from joining large teams", "Toggle", false)
for v8 = 1, v3.MAX_TEAMS do
    v7("General", "Settings Team " .. v8 .. " Enabled", "Team " .. v8 .. " Enabled", "________________________", "", "Toggle", v8 <= 2)
    v7("General", "Settings Team " .. v8 .. " Players", "Team " .. v8 .. " Max Players", "________________________", "", "Slider", 1, 0, 40, 1)
end
return v_u_4