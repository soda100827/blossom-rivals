local v1 = game:GetService("ReplicatedStorage")
local v2 = require(v1.Modules.CONSTANTS)
local v3 = require(v1.Modules.SeasonLibrary)
require(v1.Modules.Utility)
local v_u_4 = {
    ["REFRESH_TIME"] = 60,
    ["Info"] = {},
    ["Order"] = {},
    ["DisplayInfo"] = {}
}
local v5 = {
    ["Name"] = "Highest ELO",
    ["DataStoreKey"] = "HighestELO3_" .. v3.CurrentSeason.Version,
    ["NumPlayers"] = 250,
    ["IsAscending"] = false,
    ["UpdateCycle"] = nil,
    ["HiddenFromClient"] = nil,
    ["IsReadOnly"] = nil
}
v_u_4.Info[v5.Name] = v5
local v6 = v_u_4.Order
local v7 = v5.Name
table.insert(v6, v7)
local v8 = "HighestELO3_" .. v3.CurrentSeason.Version - 1
if not v2.IS_CLIENT then
    local v9 = {
        ["Name"] = "Highest ELO Last Season",
        ["DataStoreKey"] = v8,
        ["NumPlayers"] = 250,
        ["IsAscending"] = false,
        ["UpdateCycle"] = nil,
        ["HiddenFromClient"] = true,
        ["IsReadOnly"] = true
    }
    v_u_4.Info[v9.Name] = v9
    local v10 = v_u_4.Order
    local v11 = v9.Name
    table.insert(v10, v11)
end
if not v2.IS_CLIENT then
    local v12 = {
        ["Name"] = "Top Players Before Season 0 Reset",
        ["DataStoreKey"] = "HighestELO_0",
        ["NumPlayers"] = 100,
        ["IsAscending"] = false,
        ["UpdateCycle"] = nil,
        ["HiddenFromClient"] = true,
        ["IsReadOnly"] = true
    }
    v_u_4.Info[v12.Name] = v12
    local v13 = v_u_4.Order
    local v14 = v12.Name
    table.insert(v13, v14)
end
local v15 = {
    ["Name"] = "Current Highest Win Streak",
    ["DataStoreKey"] = "WinStreakCurrent_1",
    ["NumPlayers"] = 100,
    ["IsAscending"] = false,
    ["UpdateCycle"] = 86400,
    ["HiddenFromClient"] = nil,
    ["IsReadOnly"] = nil
}
v_u_4.Info[v15.Name] = v15
local v16 = v_u_4.Order
local v17 = v15.Name
table.insert(v16, v17)
local v18 = {
    ["Name"] = "Most Eliminations",
    ["DataStoreKey"] = "Eliminations_1",
    ["NumPlayers"] = 100,
    ["IsAscending"] = false,
    ["UpdateCycle"] = nil,
    ["HiddenFromClient"] = nil,
    ["IsReadOnly"] = nil
}
v_u_4.Info[v18.Name] = v18
local v19 = v_u_4.Order
local v20 = v18.Name
table.insert(v19, v20)
local v21 = {
    ["Name"] = "Most Wins",
    ["DataStoreKey"] = "Wins_1",
    ["NumPlayers"] = 100,
    ["IsAscending"] = false,
    ["UpdateCycle"] = nil,
    ["HiddenFromClient"] = nil,
    ["IsReadOnly"] = nil
}
v_u_4.Info[v21.Name] = v21
local v22 = v_u_4.Order
local v23 = v21.Name
table.insert(v22, v23)
local v24 = {
    ["Name"] = "Highest Level",
    ["DataStoreKey"] = "Level_1",
    ["NumPlayers"] = 100,
    ["IsAscending"] = false,
    ["UpdateCycle"] = nil,
    ["HiddenFromClient"] = nil,
    ["IsReadOnly"] = nil
}
v_u_4.Info[v24.Name] = v24
local v25 = v_u_4.Order
local v26 = v24.Name
table.insert(v25, v26)
if not v2.IS_CLIENT then
    local v27 = {
        ["Name"] = "Highest Win Streak Ever",
        ["DataStoreKey"] = "WinStreakHighest_1",
        ["NumPlayers"] = 100,
        ["IsAscending"] = false,
        ["UpdateCycle"] = nil,
        ["HiddenFromClient"] = true,
        ["IsReadOnly"] = nil
    }
    v_u_4.Info[v27.Name] = v27
    local v28 = v_u_4.Order
    local v29 = v27.Name
    table.insert(v28, v29)
end
if not v2.IS_CLIENT then
    local v30 = {
        ["Name"] = "Current Highest True Streak",
        ["DataStoreKey"] = "TrueStreakCurrent_1",
        ["NumPlayers"] = 100,
        ["IsAscending"] = false,
        ["UpdateCycle"] = nil,
        ["HiddenFromClient"] = true,
        ["IsReadOnly"] = nil
    }
    v_u_4.Info[v30.Name] = v30
    local v31 = v_u_4.Order
    local v32 = v30.Name
    table.insert(v31, v32)
end
if not v2.IS_CLIENT then
    local v33 = {
        ["Name"] = "Most Robux Spent",
        ["DataStoreKey"] = "RobuxSpent_1",
        ["NumPlayers"] = 100,
        ["IsAscending"] = false,
        ["UpdateCycle"] = nil,
        ["HiddenFromClient"] = true,
        ["IsReadOnly"] = nil
    }
    v_u_4.Info[v33.Name] = v33
    local v34 = v_u_4.Order
    local v35 = v33.Name
    table.insert(v34, v35)
end
local v36 = "RankedWins_" .. v3.CurrentSeason.Version
if not v2.IS_CLIENT then
    local v37 = {
        ["Name"] = "Most Ranked Wins",
        ["DataStoreKey"] = v36,
        ["NumPlayers"] = 100,
        ["IsAscending"] = false,
        ["UpdateCycle"] = nil,
        ["HiddenFromClient"] = true,
        ["IsReadOnly"] = nil
    }
    v_u_4.Info[v37.Name] = v37
    local v38 = v_u_4.Order
    local v39 = v37.Name
    table.insert(v38, v39)
end
local v40 = "RankedWinPercent_" .. v3.CurrentSeason.Version
if not v2.IS_CLIENT then
    local v41 = {
        ["Name"] = "Highest Ranked Win Percent",
        ["DataStoreKey"] = v40,
        ["NumPlayers"] = 100,
        ["IsAscending"] = false,
        ["UpdateCycle"] = nil,
        ["HiddenFromClient"] = true,
        ["IsReadOnly"] = nil
    }
    v_u_4.Info[v41.Name] = v41
    local v42 = v_u_4.Order
    local v43 = v41.Name
    table.insert(v42, v43)
end
local function v62(p44, p45, p46, p47, p48, p49, p50, p51, p52)
    local v53 = {
        ["Name"] = p44,
        ["DisplayID"] = p45,
        ["DisplayName"] = p46,
        ["Icon"] = p47,
        ["IconFilled"] = p48,
        ["SanitizeUsernames"] = p49,
        ["LiveDisplayEnabled"] = p50,
        ["TextPosition"] = p51 or UDim2.new(0.5, 0, 0.5, 0),
        ["ColorSequence"] = p52 or ColorSequence.new(Color3.fromRGB(255, 255, 255)),
        ["DarkColorSequence"] = nil
    }
    v_u_4.DisplayInfo[p44] = v53
    local v54 = {}
    for _, v55 in pairs(v53.ColorSequence.Keypoints) do
        local v56 = ColorSequenceKeypoint.new
        local v57 = v55.Time
        local v58 = Color3.new
        local v59 = v55.Value.R * 0.75
        local v60 = v55.Value.G * 0.75
        local v61 = v55.Value.B * 0.75
        table.insert(v54, v56(v57, v58(v59, v60, v61)))
    end
    v53.DarkColorSequence = ColorSequence.new(v54)
end
v62("Current Highest Win Streak", nil, "Win Streaks                   ", "rbxassetid://17175092502", "rbxassetid://17175117593", nil, true, UDim2.new(0.5, 0, 0.65, 0), ColorSequence.new(Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 157, 0)))
v62("Most Eliminations", nil, "Most Eliminations", "rbxassetid://17736782213", "rbxassetid://17736752966", nil, nil, UDim2.new(0.5, 0, 0.5, 0), ColorSequence.new(Color3.fromRGB(106, 22, 22), Color3.fromRGB(255, 51, 51)))
v62("Most Wins", nil, "Most Wins", "rbxassetid://17175095665", "rbxassetid://17175117401", nil, nil, UDim2.new(0.5, 0, 0.4, 0), ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 204, 0)),
    ColorSequenceKeypoint.new(0.542, Color3.fromRGB(255, 209, 27)),
    ColorSequenceKeypoint.new(0.856, Color3.fromRGB(255, 229, 131)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
}))
v62("Highest Level", nil, "Highest Level", "rbxassetid://18270680538", "rbxassetid://18371471156", nil, nil, UDim2.new(0.5, 0, 0.55, 0), ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 89, 255)), ColorSequenceKeypoint.new(0.342, Color3.fromRGB(2, 173, 253)), ColorSequenceKeypoint.new(1, Color3.fromRGB(151, 250, 255)) }))
v62("Highest Win Streak Ever", nil, "Best Win Streaks", "rbxassetid://17175092502", "rbxassetid://17175117593", nil, nil, UDim2.new(0.5, 0, 0.65, 0), ColorSequence.new(Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 157, 0)))
v62("Highest ELO", "RankedLB", "Ranked                             ", "rbxassetid://117835427046796", "rbxassetid://89838302386905", true, true)
return v_u_4