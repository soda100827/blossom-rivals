local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = require(v1.Modules.CONSTANTS)
local v3 = require(v1.Modules.DuelLibrary)
local v_u_4 = require(v1.Modules.ShopLibrary)
local v5 = require(v1.Modules.ItemLibrary)
local v_u_6 = require(v1.Modules.Utility)
local v_u_7 = {
    ["Info"] = {},
    ["Order"] = {},
    ["Items"] = {},
    ["Maps"] = {},
    ["CareerStatistics"] = {}
}
v_u_7.STATISTICS_DIRECTORY_INFO = {
    { "WeaponStatistics", v_u_7.Items },
    { "MapStatistics", v_u_7.Maps }
}
function v_u_7.GetStatisticsDirectoryInfo(p8, p9)
    for v10, v11 in pairs(p8.STATISTICS_DIRECTORY_INFO) do
        local v12, _ = table.unpack(v11)
        if v12 == p9 then
            return v11, v10
        end
    end
end
function v_u_7.GetPercent(_, p13, p14)
    return p13 == 0 and -1 or p14 / p13
end
function v_u_7.GetCareerStatistics(_, p15)
    local v16 = {}
    local v17 = {}
    local v18 = {}
    for v19, v20 in pairs(v_u_7.Items) do
        for _, v21 in pairs(v20.DataNames) do
            v16[v21] = true
            v17[v21] = v17[v21] or (p15[v19] or nil)
        end
    end
    for v22, _ in pairs(v_u_7.Info) do
        if not v16[v22] then
            v18[v22] = true
        end
    end
    local v23 = {}
    for v24 in pairs(v17) do
        table.insert(v23, v24)
    end
    for v25 in pairs(v18) do
        table.insert(v23, v25)
    end
    for v26 = #v23, 1, -1 do
        if not v_u_7.Info[v23[v26]].IsCareerStatistic then
            table.remove(v23, v26)
        end
    end
    table.sort(v23, function(p27, p28)
        return v_u_7.Info[p27].Index < v_u_7.Info[p28].Index
    end)
    return v23
end
local function v32(p29)
    local v30 = v_u_6
    local v31 = p29 + 0.5
    return v30:PrettyNumber((math.floor(v31)))
end
local function v35(p33)
    if p33 == -1 then
        return "N/A"
    end
    local v34 = p33 * 1000
    return math.floor(v34) / 10 .. "%"
end
local function v39(p36)
    local v37 = v_u_6
    if p36 >= 60 or not p36 then
        local v38 = p36 / 60
        p36 = math.floor(v38) * 60
    end
    return v37:TimeFormat2(p36, nil, true)
end
local v40 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticPlaytime",
    ["DisplayName"] = "Playtime",
    ["FullDisplayName"] = "Playtime",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = nil,
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v39 or v32,
    ["Image"] = "rbxassetid://17156089790"
}
v_u_7.Info[v40.DataName] = v40
local v41 = v_u_7.Order
local v42 = v40.DataName
table.insert(v41, v42)
local v43 = v_u_7.Info.StatisticPlaytime
local v44 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = nil,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticPlaytimeUnequipped",
    ["DisplayName"] = "while unequipped",
    ["FullDisplayName"] = (v43 and (v43.FullDisplayName .. " " or "") or "") .. "while unequipped",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = "StatisticPlaytime",
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v39 or v32,
    ["Image"] = v43 and v43.Image or ""
}
v_u_7.Info[v44.DataName] = v44
local v45 = v_u_7.Order
local v46 = v44.DataName
table.insert(v45, v46)
local v47 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticTasksCompleted",
    ["DisplayName"] = "Tasks Completed",
    ["FullDisplayName"] = "Tasks Completed",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = nil,
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = ""
}
v_u_7.Info[v47.DataName] = v47
local v48 = v_u_7.Order
local v49 = v47.DataName
table.insert(v48, v49)
local v50 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticContractsCompleted",
    ["DisplayName"] = "Contracts Completed",
    ["FullDisplayName"] = "Contracts Completed",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = nil,
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = ""
}
v_u_7.Info[v50.DataName] = v50
local v51 = v_u_7.Order
local v52 = v50.DataName
table.insert(v51, v52)
local v54 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticFavoriteWeapon",
    ["DisplayName"] = "Most Played Weapon",
    ["FullDisplayName"] = "Most Played Weapon",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = nil,
    ["DefaultValue"] = "N/A",
    ["ValueType"] = "string",
    ["TostringFunction"] = function(p53)
        return p53
    end or v32,
    ["Image"] = ""
}
v_u_7.Info[v54.DataName] = v54
local v55 = v_u_7.Order
local v56 = v54.DataName
table.insert(v55, v56)
local v57 = v_u_7.Info.StatisticFavoriteWeapon
local v59 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticFavoriteWeaponPrimary",
    ["DisplayName"] = "primary",
    ["FullDisplayName"] = (v57 and (v57.FullDisplayName .. " " or "") or "") .. "primary",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = "StatisticFavoriteWeapon",
    ["DefaultValue"] = "N/A",
    ["ValueType"] = "string",
    ["TostringFunction"] = function(p58)
        return p58
    end or v32,
    ["Image"] = v57 and v57.Image or ""
}
v_u_7.Info[v59.DataName] = v59
local v60 = v_u_7.Order
local v61 = v59.DataName
table.insert(v60, v61)
local v62 = v_u_7.Info.StatisticFavoriteWeapon
local v64 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticFavoriteWeaponSecondary",
    ["DisplayName"] = "secondary",
    ["FullDisplayName"] = (v62 and (v62.FullDisplayName .. " " or "") or "") .. "secondary",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = "StatisticFavoriteWeapon",
    ["DefaultValue"] = "N/A",
    ["ValueType"] = "string",
    ["TostringFunction"] = function(p63)
        return p63
    end or v32,
    ["Image"] = v62 and v62.Image or ""
}
v_u_7.Info[v64.DataName] = v64
local v65 = v_u_7.Order
local v66 = v64.DataName
table.insert(v65, v66)
local v67 = v_u_7.Info.StatisticFavoriteWeapon
local v69 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticFavoriteWeaponMelee",
    ["DisplayName"] = "melee",
    ["FullDisplayName"] = (v67 and (v67.FullDisplayName .. " " or "") or "") .. "melee",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = "StatisticFavoriteWeapon",
    ["DefaultValue"] = "N/A",
    ["ValueType"] = "string",
    ["TostringFunction"] = function(p68)
        return p68
    end or v32,
    ["Image"] = v67 and v67.Image or ""
}
v_u_7.Info[v69.DataName] = v69
local v70 = v_u_7.Order
local v71 = v69.DataName
table.insert(v70, v71)
local v72 = v_u_7.Info.StatisticFavoriteWeapon
local v74 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticFavoriteWeaponUtility",
    ["DisplayName"] = "utility",
    ["FullDisplayName"] = (v72 and (v72.FullDisplayName .. " " or "") or "") .. "utility",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = "StatisticFavoriteWeapon",
    ["DefaultValue"] = "N/A",
    ["ValueType"] = "string",
    ["TostringFunction"] = function(p73)
        return p73
    end or v32,
    ["Image"] = v72 and v72.Image or ""
}
v_u_7.Info[v74.DataName] = v74
local v75 = v_u_7.Order
local v76 = v74.DataName
table.insert(v75, v76)
local v78 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticFavoriteMap",
    ["DisplayName"] = "Favorite Map",
    ["FullDisplayName"] = "Favorite Map",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = nil,
    ["DefaultValue"] = "N/A",
    ["ValueType"] = "string",
    ["TostringFunction"] = function(p77)
        return p77
    end or v32,
    ["Image"] = ""
}
v_u_7.Info[v78.DataName] = v78
local v79 = v_u_7.Order
local v80 = v78.DataName
table.insert(v79, v80)
local v81 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticDuelsPlayed",
    ["DisplayName"] = "Duels Played",
    ["FullDisplayName"] = "Duels Played",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = nil,
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = ""
}
v_u_7.Info[v81.DataName] = v81
local v82 = v_u_7.Order
local v83 = v81.DataName
table.insert(v82, v83)
local v84 = v_u_7.Info.StatisticDuelsPlayed
local v85 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticDuelsWon",
    ["DisplayName"] = "wins",
    ["FullDisplayName"] = (v84 and (v84.FullDisplayName .. " " or "") or "") .. "wins",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = "StatisticDuelsPlayed",
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = v84 and v84.Image or ""
}
v_u_7.Info[v85.DataName] = v85
local v86 = v_u_7.Order
local v87 = v85.DataName
table.insert(v86, v87)
local v88 = v_u_7.Info.StatisticDuelsPlayed
local v89 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticDuelsLost",
    ["DisplayName"] = "losses",
    ["FullDisplayName"] = (v88 and (v88.FullDisplayName .. " " or "") or "") .. "losses",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = "StatisticDuelsPlayed",
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = v88 and v88.Image or ""
}
v_u_7.Info[v89.DataName] = v89
local v90 = v_u_7.Order
local v91 = v89.DataName
table.insert(v90, v91)
local v92 = v_u_7.Info.StatisticDuelsPlayed
local v93 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticDuelsWinPercent",
    ["DisplayName"] = "win %",
    ["FullDisplayName"] = (v92 and (v92.FullDisplayName .. " " or "") or "") .. "win %",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = "StatisticDuelsPlayed",
    ["DefaultValue"] = -1,
    ["ValueType"] = "number",
    ["TostringFunction"] = v35 or v32,
    ["Image"] = v92 and v92.Image or ""
}
v_u_7.Info[v93.DataName] = v93
local v94 = v_u_7.Order
local v95 = v93.DataName
table.insert(v94, v95)
local v96 = v_u_7.Info.StatisticDuelsPlayed
local v97 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticDuelsWonFlawless",
    ["DisplayName"] = "flawless wins",
    ["FullDisplayName"] = (v96 and (v96.FullDisplayName .. " " or "") or "") .. "flawless wins",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = "StatisticDuelsPlayed",
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = v96 and v96.Image or ""
}
v_u_7.Info[v97.DataName] = v97
local v98 = v_u_7.Order
local v99 = v97.DataName
table.insert(v98, v99)
local v100 = v_u_7.Info.StatisticDuelsPlayed
local v101 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticDuelsLostFlawless",
    ["DisplayName"] = "flawless losses",
    ["FullDisplayName"] = (v100 and (v100.FullDisplayName .. " " or "") or "") .. "flawless losses",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = "StatisticDuelsPlayed",
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = v100 and v100.Image or ""
}
v_u_7.Info[v101.DataName] = v101
local v102 = v_u_7.Order
local v103 = v101.DataName
table.insert(v102, v103)
local v104 = v_u_7.Info.StatisticDuelsPlayed
local v105 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticDuelsWonSuddenDeath",
    ["DisplayName"] = "sudden death wins",
    ["FullDisplayName"] = (v104 and (v104.FullDisplayName .. " " or "") or "") .. "sudden death wins",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = "StatisticDuelsPlayed",
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = v104 and v104.Image or ""
}
v_u_7.Info[v105.DataName] = v105
local v106 = v_u_7.Order
local v107 = v105.DataName
table.insert(v106, v107)
local v108 = v_u_7.Info.StatisticDuelsPlayed
local v109 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticDuelsLostSuddenDeath",
    ["DisplayName"] = "sudden death losses",
    ["FullDisplayName"] = (v108 and (v108.FullDisplayName .. " " or "") or "") .. "sudden death losses",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = "StatisticDuelsPlayed",
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = v108 and v108.Image or ""
}
v_u_7.Info[v109.DataName] = v109
local v110 = v_u_7.Order
local v111 = v109.DataName
table.insert(v110, v111)
local v112 = v_u_7.Info.StatisticDuelsPlayed
local v113 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticDuelsWinStreak",
    ["DisplayName"] = "current win streak",
    ["FullDisplayName"] = (v112 and (v112.FullDisplayName .. " " or "") or "") .. "current win streak",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = "StatisticDuelsPlayed",
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = v112 and v112.Image or ""
}
v_u_7.Info[v113.DataName] = v113
local v114 = v_u_7.Order
local v115 = v113.DataName
table.insert(v114, v115)
local v116 = v_u_7.Info.StatisticDuelsPlayed
local v117 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticDuelsWinStreakHighest",
    ["DisplayName"] = "highest ever win streak",
    ["FullDisplayName"] = (v116 and (v116.FullDisplayName .. " " or "") or "") .. "highest ever win streak",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = "StatisticDuelsPlayed",
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = v116 and v116.Image or ""
}
v_u_7.Info[v117.DataName] = v117
local v118 = v_u_7.Order
local v119 = v117.DataName
table.insert(v118, v119)
local v120 = v_u_7.Info.StatisticDuelsPlayed
local v121 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticDuelsWinStreaksTaken",
    ["DisplayName"] = "highest win streak ended",
    ["FullDisplayName"] = (v120 and (v120.FullDisplayName .. " " or "") or "") .. "highest win streak ended",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = "StatisticDuelsPlayed",
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = v120 and v120.Image or ""
}
v_u_7.Info[v121.DataName] = v121
local v122 = v_u_7.Order
local v123 = v121.DataName
table.insert(v122, v123)
local v124 = v_u_7.Info.StatisticDuelsPlayed
local v125 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticDuelsWinStreaksTakenTotal",
    ["DisplayName"] = "total win streaks ended",
    ["FullDisplayName"] = (v124 and (v124.FullDisplayName .. " " or "") or "") .. "total win streaks ended",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = "StatisticDuelsPlayed",
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = v124 and v124.Image or ""
}
v_u_7.Info[v125.DataName] = v125
local v126 = v_u_7.Order
local v127 = v125.DataName
table.insert(v126, v127)
local v128 = v_u_7.Info.StatisticDuelsPlayed
local v129 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticDuelsMVPs",
    ["DisplayName"] = "MVPs",
    ["FullDisplayName"] = (v128 and (v128.FullDisplayName .. " " or "") or "") .. "MVPs",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = "StatisticDuelsPlayed",
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = v128 and v128.Image or ""
}
v_u_7.Info[v129.DataName] = v129
local v130 = v_u_7.Order
local v131 = v129.DataName
table.insert(v130, v131)
local v132 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticRoundsPlayed",
    ["DisplayName"] = "Rounds Played",
    ["FullDisplayName"] = "Rounds Played",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = nil,
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = ""
}
v_u_7.Info[v132.DataName] = v132
local v133 = v_u_7.Order
local v134 = v132.DataName
table.insert(v133, v134)
local _ = v_u_7.Info.StatisticRoundsPlayed
local v135 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticRoundsWon",
    ["DisplayName"] = "wins",
    ["FullDisplayName"] = "Rounds Won",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = "StatisticRoundsPlayed",
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = "rbxassetid://100786023219923"
}
v_u_7.Info[v135.DataName] = v135
local v136 = v_u_7.Order
local v137 = v135.DataName
table.insert(v136, v137)
local v138 = v_u_7.Info.StatisticRoundsPlayed
local v139 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticRoundsLost",
    ["DisplayName"] = "losses",
    ["FullDisplayName"] = (v138 and (v138.FullDisplayName .. " " or "") or "") .. "losses",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = "StatisticRoundsPlayed",
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = v138 and v138.Image or ""
}
v_u_7.Info[v139.DataName] = v139
local v140 = v_u_7.Order
local v141 = v139.DataName
table.insert(v140, v141)
local v142 = v_u_7.Info.StatisticRoundsPlayed
local v143 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticRoundsWinPercent",
    ["DisplayName"] = "win %",
    ["FullDisplayName"] = (v142 and (v142.FullDisplayName .. " " or "") or "") .. "win %",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = "StatisticRoundsPlayed",
    ["DefaultValue"] = -1,
    ["ValueType"] = "number",
    ["TostringFunction"] = v35 or v32,
    ["Image"] = v142 and v142.Image or ""
}
v_u_7.Info[v143.DataName] = v143
local v144 = v_u_7.Order
local v145 = v143.DataName
table.insert(v144, v145)
local v146 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticRankedDuelsPlayed",
    ["DisplayName"] = "Ranked Duels Played",
    ["FullDisplayName"] = "Ranked Duels Played",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = nil,
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = ""
}
v_u_7.Info[v146.DataName] = v146
local v147 = v_u_7.Order
local v148 = v146.DataName
table.insert(v147, v148)
local v149 = v_u_7.Info.StatisticRankedDuelsPlayed
local v150 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticRankedDuelsWon",
    ["DisplayName"] = "ranked wins",
    ["FullDisplayName"] = (v149 and (v149.FullDisplayName .. " " or "") or "") .. "ranked wins",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = "StatisticRankedDuelsPlayed",
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = v149 and v149.Image or ""
}
v_u_7.Info[v150.DataName] = v150
local v151 = v_u_7.Order
local v152 = v150.DataName
table.insert(v151, v152)
local v153 = v_u_7.Info.StatisticRankedDuelsPlayed
local v154 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticRankedDuelsLost",
    ["DisplayName"] = "ranked losses",
    ["FullDisplayName"] = (v153 and (v153.FullDisplayName .. " " or "") or "") .. "ranked losses",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = "StatisticRankedDuelsPlayed",
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = v153 and v153.Image or ""
}
v_u_7.Info[v154.DataName] = v154
local v155 = v_u_7.Order
local v156 = v154.DataName
table.insert(v155, v156)
local v157 = v_u_7.Info.StatisticRankedDuelsPlayed
local v158 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticRankedDuelsWinPercent",
    ["DisplayName"] = "ranked win %",
    ["FullDisplayName"] = (v157 and (v157.FullDisplayName .. " " or "") or "") .. "ranked win %",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = "StatisticRankedDuelsPlayed",
    ["DefaultValue"] = -1,
    ["ValueType"] = "number",
    ["TostringFunction"] = v35 or v32,
    ["Image"] = v157 and v157.Image or ""
}
v_u_7.Info[v158.DataName] = v158
local v159 = v_u_7.Order
local v160 = v158.DataName
table.insert(v159, v160)
local v161 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticRankedRoundsPlayed",
    ["DisplayName"] = "Ranked Rounds Played",
    ["FullDisplayName"] = "Ranked Rounds Played",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = nil,
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = ""
}
v_u_7.Info[v161.DataName] = v161
local v162 = v_u_7.Order
local v163 = v161.DataName
table.insert(v162, v163)
local v164 = v_u_7.Info.StatisticRankedRoundsPlayed
local v165 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticRankedRoundsWon",
    ["DisplayName"] = "ranked wins",
    ["FullDisplayName"] = "Ranked Rounds Won",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = "StatisticRankedRoundsPlayed",
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = v164 and v164.Image or ""
}
v_u_7.Info[v165.DataName] = v165
local v166 = v_u_7.Order
local v167 = v165.DataName
table.insert(v166, v167)
local v168 = v_u_7.Info.StatisticRankedRoundsPlayed
local v169 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticRankedRoundsLost",
    ["DisplayName"] = "ranked losses",
    ["FullDisplayName"] = (v168 and (v168.FullDisplayName .. " " or "") or "") .. "ranked losses",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = "StatisticRankedRoundsPlayed",
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = v168 and v168.Image or ""
}
v_u_7.Info[v169.DataName] = v169
local v170 = v_u_7.Order
local v171 = v169.DataName
table.insert(v170, v171)
local v172 = v_u_7.Info.StatisticRankedRoundsPlayed
local v173 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticRankedRoundsWinPercent",
    ["DisplayName"] = "ranked win %",
    ["FullDisplayName"] = (v172 and (v172.FullDisplayName .. " " or "") or "") .. "ranked win %",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = "StatisticRankedRoundsPlayed",
    ["DefaultValue"] = -1,
    ["ValueType"] = "number",
    ["TostringFunction"] = v35 or v32,
    ["Image"] = v172 and v172.Image or ""
}
v_u_7.Info[v173.DataName] = v173
local v174 = v_u_7.Order
local v175 = v173.DataName
table.insert(v174, v175)
local v176 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticDamageDealt",
    ["DisplayName"] = "Damage Dealt",
    ["FullDisplayName"] = "Damage Dealt",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = nil,
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = "rbxassetid://18404346057"
}
v_u_7.Info[v176.DataName] = v176
local v177 = v_u_7.Order
local v178 = v176.DataName
table.insert(v177, v178)
local v179 = v_u_7.Info.StatisticDamageDealt
local v180 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticDamageDealtSliding",
    ["DisplayName"] = "while sliding",
    ["FullDisplayName"] = (v179 and (v179.FullDisplayName .. " " or "") or "") .. "while sliding",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = "StatisticDamageDealt",
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = v179 and v179.Image or ""
}
v_u_7.Info[v180.DataName] = v180
local v181 = v_u_7.Order
local v182 = v180.DataName
table.insert(v181, v182)
local v183 = v_u_7.Info.StatisticDamageDealt
local v184 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticDamageDealtCrouching",
    ["DisplayName"] = "while crouching",
    ["FullDisplayName"] = (v183 and (v183.FullDisplayName .. " " or "") or "") .. "while crouching",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = "StatisticDamageDealt",
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = v183 and v183.Image or ""
}
v_u_7.Info[v184.DataName] = v184
local v185 = v_u_7.Order
local v186 = v184.DataName
table.insert(v185, v186)
local v187 = v_u_7.Info.StatisticDamageDealt
local v188 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticDamageDealtAirborne",
    ["DisplayName"] = "while airborne",
    ["FullDisplayName"] = (v187 and (v187.FullDisplayName .. " " or "") or "") .. "while airborne",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = "StatisticDamageDealt",
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = v187 and v187.Image or ""
}
v_u_7.Info[v188.DataName] = v188
local v189 = v_u_7.Order
local v190 = v188.DataName
table.insert(v189, v190)
local v191 = v_u_7.Info.StatisticDamageDealt
local v192 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticDamageDealtBlinded",
    ["DisplayName"] = "while blinded",
    ["FullDisplayName"] = (v191 and (v191.FullDisplayName .. " " or "") or "") .. "while blinded",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = "StatisticDamageDealt",
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = v191 and v191.Image or ""
}
v_u_7.Info[v192.DataName] = v192
local v193 = v_u_7.Order
local v194 = v192.DataName
table.insert(v193, v194)
local v195 = v_u_7.Info.StatisticDamageDealt
local v196 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticDamageDealtDead",
    ["DisplayName"] = "while dead",
    ["FullDisplayName"] = (v195 and (v195.FullDisplayName .. " " or "") or "") .. "while dead",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = "StatisticDamageDealt",
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = v195 and v195.Image or ""
}
v_u_7.Info[v196.DataName] = v196
local v197 = v_u_7.Order
local v198 = v196.DataName
table.insert(v197, v198)
local v199 = v_u_7.Info.StatisticDamageDealt
local v200 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticDamageDealtNoscope",
    ["DisplayName"] = "while noscoping",
    ["FullDisplayName"] = (v199 and (v199.FullDisplayName .. " " or "") or "") .. "while noscoping",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = "StatisticDamageDealt",
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = v199 and v199.Image or ""
}
v_u_7.Info[v200.DataName] = v200
local v201 = v_u_7.Order
local v202 = v200.DataName
table.insert(v201, v202)
local v203 = v_u_7.Info.StatisticDamageDealt
local v204 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticDamageDealtDashing",
    ["DisplayName"] = "while dashing",
    ["FullDisplayName"] = (v203 and (v203.FullDisplayName .. " " or "") or "") .. "while dashing",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = "StatisticDamageDealt",
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = v203 and v203.Image or ""
}
v_u_7.Info[v204.DataName] = v204
local v205 = v_u_7.Order
local v206 = v204.DataName
table.insert(v205, v206)
local v207 = v_u_7.Info.StatisticDamageDealt
local v208 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticDamageDealtDeflecting",
    ["DisplayName"] = "from deflecting",
    ["FullDisplayName"] = (v207 and (v207.FullDisplayName .. " " or "") or "") .. "from deflecting",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = "StatisticDamageDealt",
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = v207 and v207.Image or ""
}
v_u_7.Info[v208.DataName] = v208
local v209 = v_u_7.Order
local v210 = v208.DataName
table.insert(v209, v210)
local v211 = v_u_7.Info.StatisticDamageDealt
local v212 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticDamageDealtBouncing",
    ["DisplayName"] = "after a bounce",
    ["FullDisplayName"] = (v211 and (v211.FullDisplayName .. " " or "") or "") .. "after a bounce",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = "StatisticDamageDealt",
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = v211 and v211.Image or ""
}
v_u_7.Info[v212.DataName] = v212
local v213 = v_u_7.Order
local v214 = v212.DataName
table.insert(v213, v214)
local v215 = v_u_7.Info.StatisticDamageDealt
local v216 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticDamageDealtGunMode",
    ["DisplayName"] = "in gun mode",
    ["FullDisplayName"] = (v215 and (v215.FullDisplayName .. " " or "") or "") .. "in gun mode",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = "StatisticDamageDealt",
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = v215 and v215.Image or ""
}
v_u_7.Info[v216.DataName] = v216
local v217 = v_u_7.Order
local v218 = v216.DataName
table.insert(v217, v218)
local v219 = v_u_7.Info.StatisticDamageDealt
local v220 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticDamageDealtBladeMode",
    ["DisplayName"] = "in blade mode",
    ["FullDisplayName"] = (v219 and (v219.FullDisplayName .. " " or "") or "") .. "in blade mode",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = "StatisticDamageDealt",
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = v219 and v219.Image or ""
}
v_u_7.Info[v220.DataName] = v220
local v221 = v_u_7.Order
local v222 = v220.DataName
table.insert(v221, v222)
local v223 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticEliminations",
    ["DisplayName"] = "Eliminations",
    ["FullDisplayName"] = "Eliminations",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = nil,
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = "rbxassetid://17736790660"
}
v_u_7.Info[v223.DataName] = v223
local v224 = v_u_7.Order
local v225 = v223.DataName
table.insert(v224, v225)
local v226 = v_u_7.Info.StatisticEliminations
local v227 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticEliminationsSliding",
    ["DisplayName"] = "while sliding",
    ["FullDisplayName"] = (v226 and (v226.FullDisplayName .. " " or "") or "") .. "while sliding",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = "StatisticEliminations",
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = v226 and v226.Image or ""
}
v_u_7.Info[v227.DataName] = v227
local v228 = v_u_7.Order
local v229 = v227.DataName
table.insert(v228, v229)
local v230 = v_u_7.Info.StatisticEliminations
local v231 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticEliminationsCrouching",
    ["DisplayName"] = "while crouching",
    ["FullDisplayName"] = (v230 and (v230.FullDisplayName .. " " or "") or "") .. "while crouching",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = "StatisticEliminations",
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = v230 and v230.Image or ""
}
v_u_7.Info[v231.DataName] = v231
local v232 = v_u_7.Order
local v233 = v231.DataName
table.insert(v232, v233)
local v234 = v_u_7.Info.StatisticEliminations
local v235 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticEliminationsAirborne",
    ["DisplayName"] = "while airborne",
    ["FullDisplayName"] = (v234 and (v234.FullDisplayName .. " " or "") or "") .. "while airborne",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = "StatisticEliminations",
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = v234 and v234.Image or ""
}
v_u_7.Info[v235.DataName] = v235
local v236 = v_u_7.Order
local v237 = v235.DataName
table.insert(v236, v237)
local v238 = v_u_7.Info.StatisticEliminations
local v239 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticEliminationsBlinded",
    ["DisplayName"] = "while blinded",
    ["FullDisplayName"] = (v238 and (v238.FullDisplayName .. " " or "") or "") .. "while blinded",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = "StatisticEliminations",
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = v238 and v238.Image or ""
}
v_u_7.Info[v239.DataName] = v239
local v240 = v_u_7.Order
local v241 = v239.DataName
table.insert(v240, v241)
local v242 = v_u_7.Info.StatisticEliminations
local v243 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticEliminationsDead",
    ["DisplayName"] = "while dead",
    ["FullDisplayName"] = (v242 and (v242.FullDisplayName .. " " or "") or "") .. "while dead",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = "StatisticEliminations",
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = v242 and v242.Image or ""
}
v_u_7.Info[v243.DataName] = v243
local v244 = v_u_7.Order
local v245 = v243.DataName
table.insert(v244, v245)
local v246 = v_u_7.Info.StatisticEliminations
local v247 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticEliminationsNoscope",
    ["DisplayName"] = "while noscoping",
    ["FullDisplayName"] = (v246 and (v246.FullDisplayName .. " " or "") or "") .. "while noscoping",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = "StatisticEliminations",
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = v246 and v246.Image or ""
}
v_u_7.Info[v247.DataName] = v247
local v248 = v_u_7.Order
local v249 = v247.DataName
table.insert(v248, v249)
local v250 = v_u_7.Info.StatisticEliminations
local v251 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticEliminationsDashing",
    ["DisplayName"] = "while dashing",
    ["FullDisplayName"] = (v250 and (v250.FullDisplayName .. " " or "") or "") .. "while dashing",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = "StatisticEliminations",
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = v250 and v250.Image or ""
}
v_u_7.Info[v251.DataName] = v251
local v252 = v_u_7.Order
local v253 = v251.DataName
table.insert(v252, v253)
local v254 = v_u_7.Info.StatisticEliminations
local v255 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticEliminationsDeflecting",
    ["DisplayName"] = "from deflecting",
    ["FullDisplayName"] = (v254 and (v254.FullDisplayName .. " " or "") or "") .. "from deflecting",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = "StatisticEliminations",
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = v254 and v254.Image or ""
}
v_u_7.Info[v255.DataName] = v255
local v256 = v_u_7.Order
local v257 = v255.DataName
table.insert(v256, v257)
local v258 = v_u_7.Info.StatisticEliminations
local v259 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticEliminationsBouncing",
    ["DisplayName"] = "after a bounce",
    ["FullDisplayName"] = (v258 and (v258.FullDisplayName .. " " or "") or "") .. "after a bounce",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = "StatisticEliminations",
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = v258 and v258.Image or ""
}
v_u_7.Info[v259.DataName] = v259
local v260 = v_u_7.Order
local v261 = v259.DataName
table.insert(v260, v261)
local v262 = v_u_7.Info.StatisticEliminations
local v263 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticEliminationsGunMode",
    ["DisplayName"] = "in gun mode",
    ["FullDisplayName"] = (v262 and (v262.FullDisplayName .. " " or "") or "") .. "in gun mode",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = "StatisticEliminations",
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = v262 and v262.Image or ""
}
v_u_7.Info[v263.DataName] = v263
local v264 = v_u_7.Order
local v265 = v263.DataName
table.insert(v264, v265)
local v266 = v_u_7.Info.StatisticEliminations
local v267 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticEliminationsBladeMode",
    ["DisplayName"] = "in blade mode",
    ["FullDisplayName"] = (v266 and (v266.FullDisplayName .. " " or "") or "") .. "in blade mode",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = "StatisticEliminations",
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = v266 and v266.Image or ""
}
v_u_7.Info[v267.DataName] = v267
local v268 = v_u_7.Order
local v269 = v267.DataName
table.insert(v268, v269)
local v270 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticDeaths",
    ["DisplayName"] = "Deaths",
    ["FullDisplayName"] = "Deaths",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = nil,
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = ""
}
v_u_7.Info[v270.DataName] = v270
local v271 = v_u_7.Order
local v272 = v270.DataName
table.insert(v271, v272)
local v273 = v_u_7.Info.StatisticDeaths
local v275 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticDeathsRatio",
    ["DisplayName"] = "eliminations ratio",
    ["FullDisplayName"] = (v273 and (v273.FullDisplayName .. " " or "") or "") .. "eliminations ratio",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = "StatisticDeaths",
    ["DefaultValue"] = -1,
    ["ValueType"] = "number",
    ["TostringFunction"] = function(p274)
        return p274 == -1 and "N/A" or string.format("%.2f", p274)
    end or v32,
    ["Image"] = v273 and v273.Image or ""
}
v_u_7.Info[v275.DataName] = v275
local v276 = v_u_7.Order
local v277 = v275.DataName
table.insert(v276, v277)
local v278 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticAssists",
    ["DisplayName"] = "Assists",
    ["FullDisplayName"] = "Assists",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = nil,
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = ""
}
v_u_7.Info[v278.DataName] = v278
local v279 = v_u_7.Order
local v280 = v278.DataName
table.insert(v279, v280)
local v281 = v_u_7.Info.StatisticAssists
local v282 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticAssistsDead",
    ["DisplayName"] = "while dead",
    ["FullDisplayName"] = (v281 and (v281.FullDisplayName .. " " or "") or "") .. "while dead",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = "StatisticAssists",
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = v281 and v281.Image or ""
}
v_u_7.Info[v282.DataName] = v282
local v283 = v_u_7.Order
local v284 = v282.DataName
table.insert(v283, v284)
local v285 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticDamageReceived",
    ["DisplayName"] = "Damage Received",
    ["FullDisplayName"] = "Damage Received",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = nil,
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = ""
}
v_u_7.Info[v285.DataName] = v285
local v286 = v_u_7.Order
local v287 = v285.DataName
table.insert(v286, v287)
local v288 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticHealsReceived",
    ["DisplayName"] = "Heals Received",
    ["FullDisplayName"] = "Heals Received",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = nil,
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = ""
}
v_u_7.Info[v288.DataName] = v288
local v289 = v_u_7.Order
local v290 = v288.DataName
table.insert(v289, v290)
local v291 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticHealsGiven",
    ["DisplayName"] = "Heals Given",
    ["FullDisplayName"] = "Heals Given",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = nil,
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = ""
}
v_u_7.Info[v291.DataName] = v291
local v292 = v_u_7.Order
local v293 = v291.DataName
table.insert(v292, v293)
local v294 = v_u_7.Info.StatisticHealsGiven
local v295 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticHealsGivenTeammates",
    ["DisplayName"] = "to teammates",
    ["FullDisplayName"] = (v294 and (v294.FullDisplayName .. " " or "") or "") .. "to teammates",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = "StatisticHealsGiven",
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = v294 and v294.Image or ""
}
v_u_7.Info[v295.DataName] = v295
local v296 = v_u_7.Order
local v297 = v295.DataName
table.insert(v296, v297)
local v298 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticUses",
    ["DisplayName"] = "Uses",
    ["FullDisplayName"] = "Uses",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = nil,
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = ""
}
v_u_7.Info[v298.DataName] = v298
local v299 = v_u_7.Order
local v300 = v298.DataName
table.insert(v299, v300)
local v301 = v_u_7.Info.StatisticUses
local v302 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticUsesQuick",
    ["DisplayName"] = "quick uses",
    ["FullDisplayName"] = (v301 and (v301.FullDisplayName .. " " or "") or "") .. "quick uses",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = "StatisticUses",
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = v301 and v301.Image or ""
}
v_u_7.Info[v302.DataName] = v302
local v303 = v_u_7.Order
local v304 = v302.DataName
table.insert(v303, v304)
local v305 = v_u_7.Info.StatisticUses
local v306 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticUsesHits",
    ["DisplayName"] = "hits",
    ["FullDisplayName"] = (v305 and (v305.FullDisplayName .. " " or "") or "") .. "hits",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = "StatisticUses",
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = v305 and v305.Image or ""
}
v_u_7.Info[v306.DataName] = v306
local v307 = v_u_7.Order
local v308 = v306.DataName
table.insert(v307, v308)
local v309 = v_u_7.Info.StatisticUses
local v310 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticUsesHitPercent",
    ["DisplayName"] = "hit %",
    ["FullDisplayName"] = (v309 and (v309.FullDisplayName .. " " or "") or "") .. "hit %",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = "StatisticUses",
    ["DefaultValue"] = -1,
    ["ValueType"] = "number",
    ["TostringFunction"] = v35 or v32,
    ["Image"] = v309 and v309.Image or ""
}
v_u_7.Info[v310.DataName] = v310
local v311 = v_u_7.Order
local v312 = v310.DataName
table.insert(v311, v312)
local v313 = v_u_7.Info.StatisticUses
local v314 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticUsesCriticalHits",
    ["DisplayName"] = "critical hits",
    ["FullDisplayName"] = (v313 and (v313.FullDisplayName .. " " or "") or "") .. "critical hits",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = "StatisticUses",
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = v313 and v313.Image or ""
}
v_u_7.Info[v314.DataName] = v314
local v315 = v_u_7.Order
local v316 = v314.DataName
table.insert(v315, v316)
local v317 = v_u_7.Info.StatisticUses
local v318 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticUsesCriticalHitPercent",
    ["DisplayName"] = "critical hit %",
    ["FullDisplayName"] = (v317 and (v317.FullDisplayName .. " " or "") or "") .. "critical hit %",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = "StatisticUses",
    ["DefaultValue"] = -1,
    ["ValueType"] = "number",
    ["TostringFunction"] = v35 or v32,
    ["Image"] = v317 and v317.Image or ""
}
v_u_7.Info[v318.DataName] = v318
local v319 = v_u_7.Order
local v320 = v318.DataName
table.insert(v319, v320)
local v321 = v_u_7.Info.StatisticUses
local v322 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticUsesHitsSelf",
    ["DisplayName"] = "self hits",
    ["FullDisplayName"] = (v321 and (v321.FullDisplayName .. " " or "") or "") .. "self hits",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = "StatisticUses",
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = v321 and v321.Image or ""
}
v_u_7.Info[v322.DataName] = v322
local v323 = v_u_7.Order
local v324 = v322.DataName
table.insert(v323, v324)
local v325 = v_u_7.Info.StatisticUses
local v326 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticUsesHitsDirect",
    ["DisplayName"] = "direct hits",
    ["FullDisplayName"] = (v325 and (v325.FullDisplayName .. " " or "") or "") .. "direct hits",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = "StatisticUses",
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = v325 and v325.Image or ""
}
v_u_7.Info[v326.DataName] = v326
local v327 = v_u_7.Order
local v328 = v326.DataName
table.insert(v327, v328)
local v329 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticInspects",
    ["DisplayName"] = "Inspects",
    ["FullDisplayName"] = "Inspects",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = nil,
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = ""
}
v_u_7.Info[v329.DataName] = v329
local v330 = v_u_7.Order
local v331 = v329.DataName
table.insert(v330, v331)
local v332 = v_u_7.Info.StatisticInspects
local v333 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticInspectsAfterElimination",
    ["DisplayName"] = "after an elimination",
    ["FullDisplayName"] = (v332 and (v332.FullDisplayName .. " " or "") or "") .. "after an elimination",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = "StatisticInspects",
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = v332 and v332.Image or ""
}
v_u_7.Info[v333.DataName] = v333
local v334 = v_u_7.Order
local v335 = v333.DataName
table.insert(v334, v335)
local v336 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticAmmoUsed",
    ["DisplayName"] = "Ammo Used",
    ["FullDisplayName"] = "Ammo Used",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = nil,
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = ""
}
v_u_7.Info[v336.DataName] = v336
local v337 = v_u_7.Order
local v338 = v336.DataName
table.insert(v337, v338)
local v339 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticReloads",
    ["DisplayName"] = "Reloads",
    ["FullDisplayName"] = "Reloads",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = nil,
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = ""
}
v_u_7.Info[v339.DataName] = v339
local v340 = v_u_7.Order
local v341 = v339.DataName
table.insert(v340, v341)
local v342 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticAirblasts",
    ["DisplayName"] = "Airblasts",
    ["FullDisplayName"] = "Airblasts",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = nil,
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = ""
}
v_u_7.Info[v342.DataName] = v342
local v343 = v_u_7.Order
local v344 = v342.DataName
table.insert(v343, v344)
local v345 = v_u_7.Info.StatisticAirblasts
local v346 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticAirblastsHits",
    ["DisplayName"] = "players blasted",
    ["FullDisplayName"] = (v345 and (v345.FullDisplayName .. " " or "") or "") .. "players blasted",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = "StatisticAirblasts",
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = v345 and v345.Image or ""
}
v_u_7.Info[v346.DataName] = v346
local v347 = v_u_7.Order
local v348 = v346.DataName
table.insert(v347, v348)
local v349 = v_u_7.Info.StatisticAirblasts
local v350 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticAirblastsSmokesCleared",
    ["DisplayName"] = "smokes blasted",
    ["FullDisplayName"] = (v349 and (v349.FullDisplayName .. " " or "") or "") .. "smokes blasted",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = "StatisticAirblasts",
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = v349 and v349.Image or ""
}
v_u_7.Info[v350.DataName] = v350
local v351 = v_u_7.Order
local v352 = v350.DataName
table.insert(v351, v352)
local v353 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticDashes",
    ["DisplayName"] = "Dashes",
    ["FullDisplayName"] = "Dashes",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = nil,
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = ""
}
v_u_7.Info[v353.DataName] = v353
local v354 = v_u_7.Order
local v355 = v353.DataName
table.insert(v354, v355)
local v356 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticWallsBuilt",
    ["DisplayName"] = "Walls Built",
    ["FullDisplayName"] = "Walls Built",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = nil,
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = ""
}
v_u_7.Info[v356.DataName] = v356
local v357 = v_u_7.Order
local v358 = v356.DataName
table.insert(v357, v358)
local v359 = v_u_7.Info.StatisticWallsBuilt
local v360 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticWallsBuiltBricksLayed",
    ["DisplayName"] = "bricks layed",
    ["FullDisplayName"] = (v359 and (v359.FullDisplayName .. " " or "") or "") .. "bricks layed",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = "StatisticWallsBuilt",
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = v359 and v359.Image or ""
}
v_u_7.Info[v360.DataName] = v360
local v361 = v_u_7.Order
local v362 = v360.DataName
table.insert(v361, v362)
local v363 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticDeflects",
    ["DisplayName"] = "Deflects",
    ["FullDisplayName"] = "Deflects",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = nil,
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = ""
}
v_u_7.Info[v363.DataName] = v363
local v364 = v_u_7.Order
local v365 = v363.DataName
table.insert(v364, v365)
local v366 = v_u_7.Info.StatisticDeflects
local v367 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticDeflectsHits",
    ["DisplayName"] = "hits",
    ["FullDisplayName"] = (v366 and (v366.FullDisplayName .. " " or "") or "") .. "hits",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = "StatisticDeflects",
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = v366 and v366.Image or ""
}
v_u_7.Info[v367.DataName] = v367
local v368 = v_u_7.Order
local v369 = v367.DataName
table.insert(v368, v369)
local v370 = v_u_7.Info.StatisticDeflects
local v371 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticDeflectsCriticalHits",
    ["DisplayName"] = "critical hits",
    ["FullDisplayName"] = (v370 and (v370.FullDisplayName .. " " or "") or "") .. "critical hits",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = "StatisticDeflects",
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = v370 and v370.Image or ""
}
v_u_7.Info[v371.DataName] = v371
local v372 = v_u_7.Order
local v373 = v371.DataName
table.insert(v372, v373)
local v374 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticExtinguishes",
    ["DisplayName"] = "Extinguishes",
    ["FullDisplayName"] = "Extinguishes",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = nil,
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = ""
}
v_u_7.Info[v374.DataName] = v374
local v375 = v_u_7.Order
local v376 = v374.DataName
table.insert(v375, v376)
local v377 = v_u_7.Info.StatisticExtinguishes
local v378 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticExtinguishesPlayers",
    ["DisplayName"] = "players",
    ["FullDisplayName"] = (v377 and (v377.FullDisplayName .. " " or "") or "") .. "players",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = "StatisticExtinguishes",
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = v377 and v377.Image or ""
}
v_u_7.Info[v378.DataName] = v378
local v379 = v_u_7.Order
local v380 = v378.DataName
table.insert(v379, v380)
local v381 = v_u_7.Info.StatisticExtinguishes
local v382 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticExtinguishesMolotovs",
    ["DisplayName"] = "molotovs",
    ["FullDisplayName"] = (v381 and (v381.FullDisplayName .. " " or "") or "") .. "molotovs",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = "StatisticExtinguishes",
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = v381 and v381.Image or ""
}
v_u_7.Info[v382.DataName] = v382
local v383 = v_u_7.Order
local v384 = v382.DataName
table.insert(v383, v384)
local v385 = v_u_7.Info.StatisticExtinguishes
local v386 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticExtinguishesFlareGuns",
    ["DisplayName"] = "flare guns",
    ["FullDisplayName"] = (v385 and (v385.FullDisplayName .. " " or "") or "") .. "flare guns",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = "StatisticExtinguishes",
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = v385 and v385.Image or ""
}
v_u_7.Info[v386.DataName] = v386
local v387 = v_u_7.Order
local v388 = v386.DataName
table.insert(v387, v388)
local v389 = v_u_7.Info.StatisticExtinguishes
local v390 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticExtinguishesFlamethrowers",
    ["DisplayName"] = "flamethrowers",
    ["FullDisplayName"] = (v389 and (v389.FullDisplayName .. " " or "") or "") .. "flamethrowers",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = "StatisticExtinguishes",
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = v389 and v389.Image or ""
}
v_u_7.Info[v390.DataName] = v390
local v391 = v_u_7.Order
local v392 = v390.DataName
table.insert(v391, v392)
local v393 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticBlinds",
    ["DisplayName"] = "Players Blinded",
    ["FullDisplayName"] = "Players Blinded",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = nil,
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = "rbxassetid://17814211801"
}
v_u_7.Info[v393.DataName] = v393
local v394 = v_u_7.Order
local v395 = v393.DataName
table.insert(v394, v395)
local v396 = v_u_7.Info.StatisticBlinds
local v397 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticBlindsSelf",
    ["DisplayName"] = "self blinded",
    ["FullDisplayName"] = (v396 and (v396.FullDisplayName .. " " or "") or "") .. "self blinded",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = "StatisticBlinds",
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = v396 and v396.Image or ""
}
v_u_7.Info[v397.DataName] = v397
local v398 = v_u_7.Order
local v399 = v397.DataName
table.insert(v398, v399)
local v400 = v_u_7.Info.StatisticBlinds
local v401 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticBlindsEnemies",
    ["DisplayName"] = "enemies blinded",
    ["FullDisplayName"] = "Enemies Blinded",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = "StatisticBlinds",
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = v400 and v400.Image or ""
}
v_u_7.Info[v401.DataName] = v401
local v402 = v_u_7.Order
local v403 = v401.DataName
table.insert(v402, v403)
local v404 = v_u_7.Info.StatisticBlinds
local v405 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticBlindsTeammates",
    ["DisplayName"] = "teammates blinded",
    ["FullDisplayName"] = (v404 and (v404.FullDisplayName .. " " or "") or "") .. "teammates blinded",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = "StatisticBlinds",
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = v404 and v404.Image or ""
}
v_u_7.Info[v405.DataName] = v405
local v406 = v_u_7.Order
local v407 = v405.DataName
table.insert(v406, v407)
local v408 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticSmokeds",
    ["DisplayName"] = "Players Smoked",
    ["FullDisplayName"] = "Players Smoked",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = nil,
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = "rbxassetid://18387088796"
}
v_u_7.Info[v408.DataName] = v408
local v409 = v_u_7.Order
local v410 = v408.DataName
table.insert(v409, v410)
local v411 = v_u_7.Info.StatisticSmokeds
local v412 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticSmokedsSelf",
    ["DisplayName"] = "self smoked",
    ["FullDisplayName"] = (v411 and (v411.FullDisplayName .. " " or "") or "") .. "self smoked",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = "StatisticSmokeds",
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = v411 and v411.Image or ""
}
v_u_7.Info[v412.DataName] = v412
local v413 = v_u_7.Order
local v414 = v412.DataName
table.insert(v413, v414)
local v415 = v_u_7.Info.StatisticSmokeds
local v416 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticSmokedsEnemies",
    ["DisplayName"] = "enemies smoked",
    ["FullDisplayName"] = "Enemies Smoked",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = "StatisticSmokeds",
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = v415 and v415.Image or ""
}
v_u_7.Info[v416.DataName] = v416
local v417 = v_u_7.Order
local v418 = v416.DataName
table.insert(v417, v418)
local v419 = v_u_7.Info.StatisticSmokeds
local v420 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticSmokedsTeammates",
    ["DisplayName"] = "teammates smoked",
    ["FullDisplayName"] = (v419 and (v419.FullDisplayName .. " " or "") or "") .. "teammates smoked",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = "StatisticSmokeds",
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = v419 and v419.Image or ""
}
v_u_7.Info[v420.DataName] = v420
local v421 = v_u_7.Order
local v422 = v420.DataName
table.insert(v421, v422)
local v423 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticFreezes",
    ["DisplayName"] = "Players Frozen",
    ["FullDisplayName"] = "Players Frozen",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = nil,
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = "rbxassetid://18428668944"
}
v_u_7.Info[v423.DataName] = v423
local v424 = v_u_7.Order
local v425 = v423.DataName
table.insert(v424, v425)
local v426 = v_u_7.Info.StatisticFreezes
local v427 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticFreezesSelf",
    ["DisplayName"] = "self freezes",
    ["FullDisplayName"] = (v426 and (v426.FullDisplayName .. " " or "") or "") .. "self freezes",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = "StatisticFreezes",
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = v426 and v426.Image or ""
}
v_u_7.Info[v427.DataName] = v427
local v428 = v_u_7.Order
local v429 = v427.DataName
table.insert(v428, v429)
local v430 = v_u_7.Info.StatisticFreezes
local v431 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticFreezesEnemies",
    ["DisplayName"] = "enemies frozen",
    ["FullDisplayName"] = "Enemies Frozen",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = "StatisticFreezes",
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = v430 and v430.Image or ""
}
v_u_7.Info[v431.DataName] = v431
local v432 = v_u_7.Order
local v433 = v431.DataName
table.insert(v432, v433)
local v434 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticEmpowers",
    ["DisplayName"] = "Players Empowered",
    ["FullDisplayName"] = "Players Empowered",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = nil,
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = "rbxassetid://86874311663826"
}
v_u_7.Info[v434.DataName] = v434
local v435 = v_u_7.Order
local v436 = v434.DataName
table.insert(v435, v436)
local v437 = v_u_7.Info.StatisticEmpowers
local v438 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticEmpowersSelf",
    ["DisplayName"] = "self empowers",
    ["FullDisplayName"] = (v437 and (v437.FullDisplayName .. " " or "") or "") .. "self empowers",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = "StatisticEmpowers",
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = v437 and v437.Image or ""
}
v_u_7.Info[v438.DataName] = v438
local v439 = v_u_7.Order
local v440 = v438.DataName
table.insert(v439, v440)
local v441 = v_u_7.Info.StatisticEmpowers
local v442 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticEmpowersTeammates",
    ["DisplayName"] = "teammates empowered",
    ["FullDisplayName"] = (v441 and (v441.FullDisplayName .. " " or "") or "") .. "teammates empowered",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = "StatisticEmpowers",
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = v441 and v441.Image or ""
}
v_u_7.Info[v442.DataName] = v442
local v443 = v_u_7.Order
local v444 = v442.DataName
table.insert(v443, v444)
local v445 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticAbsorbs",
    ["DisplayName"] = "Damage Absorbed",
    ["FullDisplayName"] = "Damage Absorbed",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = nil,
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = ""
}
v_u_7.Info[v445.DataName] = v445
local v446 = v_u_7.Order
local v447 = v445.DataName
table.insert(v446, v447)
local v448 = v_u_7.Info.StatisticAbsorbs
local v449 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticAbsorbsBehind",
    ["DisplayName"] = "from behind",
    ["FullDisplayName"] = (v448 and (v448.FullDisplayName .. " " or "") or "") .. "from behind",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = "StatisticAbsorbs",
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = v448 and v448.Image or ""
}
v_u_7.Info[v449.DataName] = v449
local v450 = v_u_7.Order
local v451 = v449.DataName
table.insert(v450, v451)
local v452 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticBounces",
    ["DisplayName"] = "Players Bounced",
    ["FullDisplayName"] = "Players Bounced",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = nil,
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = "rbxassetid://18436038478"
}
v_u_7.Info[v452.DataName] = v452
local v453 = v_u_7.Order
local v454 = v452.DataName
table.insert(v453, v454)
local v455 = v_u_7.Info.StatisticBounces
local v456 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticBouncesSelf",
    ["DisplayName"] = "self bounces",
    ["FullDisplayName"] = (v455 and (v455.FullDisplayName .. " " or "") or "") .. "self bounces",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = "StatisticBounces",
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = v455 and v455.Image or ""
}
v_u_7.Info[v456.DataName] = v456
local v457 = v_u_7.Order
local v458 = v456.DataName
table.insert(v457, v458)
local v459 = v_u_7.Info.StatisticBounces
local v460 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticBouncesTeammates",
    ["DisplayName"] = "teammates bounced",
    ["FullDisplayName"] = (v459 and (v459.FullDisplayName .. " " or "") or "") .. "teammates bounced",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = "StatisticBounces",
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = v459 and v459.Image or ""
}
v_u_7.Info[v460.DataName] = v460
local v461 = v_u_7.Order
local v462 = v460.DataName
table.insert(v461, v462)
local v463 = v_u_7.Info.StatisticBounces
local v464 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticBouncesEnemies",
    ["DisplayName"] = "enemies bounced",
    ["FullDisplayName"] = (v463 and (v463.FullDisplayName .. " " or "") or "") .. "enemies bounced",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = "StatisticBounces",
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = v463 and v463.Image or ""
}
v_u_7.Info[v464.DataName] = v464
local v465 = v_u_7.Order
local v466 = v464.DataName
table.insert(v465, v466)
local v467 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticVortexesSpawned",
    ["DisplayName"] = "Vortexes Spawned",
    ["FullDisplayName"] = "Vortexes Spawned",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = nil,
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = ""
}
v_u_7.Info[v467.DataName] = v467
local v468 = v_u_7.Order
local v469 = v467.DataName
table.insert(v468, v469)
local v470 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticPortalsSpawned",
    ["DisplayName"] = "Portals Spawned",
    ["FullDisplayName"] = "Portals Spawned",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = nil,
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = "rbxassetid://76793585944473"
}
v_u_7.Info[v470.DataName] = v470
local v471 = v_u_7.Order
local v472 = v470.DataName
table.insert(v471, v472)
local v473 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticWarps",
    ["DisplayName"] = "Warps",
    ["FullDisplayName"] = "Warps",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = nil,
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = "rbxassetid://17735783844"
}
v_u_7.Info[v473.DataName] = v473
local v474 = v_u_7.Order
local v475 = v473.DataName
table.insert(v474, v475)
local v476 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = nil,
    ["DataName"] = "StatisticZombies",
    ["DisplayName"] = "Zombies",
    ["FullDisplayName"] = "Zombies",
    ["IsStatisticFolder"] = true,
    ["ParentDataName"] = nil,
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = ""
}
v_u_7.Info[v476.DataName] = v476
local v477 = v_u_7.Order
local v478 = v476.DataName
table.insert(v477, v478)
local v479 = v_u_7.Info.StatisticZombies
local v480 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = true,
    ["DataName"] = "StatisticZombiesDamageDealt",
    ["DisplayName"] = "damage dealt",
    ["FullDisplayName"] = (v479 and (v479.FullDisplayName .. " " or "") or "") .. "damage dealt",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = "StatisticZombies",
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = v479 and v479.Image or ""
}
v_u_7.Info[v480.DataName] = v480
local v481 = v_u_7.Order
local v482 = v480.DataName
table.insert(v481, v482)
local v483 = v_u_7.Info.StatisticZombies
local v484 = {
    ["Index"] = #v_u_7.Order + 1,
    ["IsCareerStatistic"] = true,
    ["OnlyDisplayNonZero"] = true,
    ["DataName"] = "StatisticZombiesEliminations",
    ["DisplayName"] = "eliminations",
    ["FullDisplayName"] = (v483 and (v483.FullDisplayName .. " " or "") or "") .. "eliminations",
    ["IsStatisticFolder"] = false,
    ["ParentDataName"] = "StatisticZombies",
    ["DefaultValue"] = 0,
    ["ValueType"] = "number",
    ["TostringFunction"] = v32,
    ["Image"] = v483 and v483.Image or ""
}
v_u_7.Info[v484.DataName] = v484
local v485 = v_u_7.Order
local v486 = v484.DataName
table.insert(v485, v486)
local function v493(p487, p488, p489)
    local v490 = {}
    for _, v491 in pairs(p488) do
        local v492 = "Statistic" .. v491
        table.insert(v490, v492)
    end
    v_u_7.Items[p487] = {
        ["DataNames"] = v490,
        ["Descriptions"] = p489
    }
end
v493("MISSING_WEAPON", {
    "Playtime",
    "PlaytimeUnequipped",
    "RoundsPlayed",
    "RoundsWon",
    "RoundsLost",
    "RoundsWinPercent",
    "RankedRoundsPlayed",
    "RankedRoundsWon",
    "RankedRoundsLost",
    "RankedRoundsWinPercent",
    "DamageDealt",
    "DamageDealtSliding",
    "DamageDealtCrouching",
    "DamageDealtAirborne",
    "DamageDealtBlinded",
    "DamageDealtDead",
    "Eliminations",
    "EliminationsSliding",
    "EliminationsCrouching",
    "EliminationsAirborne",
    "EliminationsBlinded",
    "EliminationsDead",
    "Deaths",
    "DeathsRatio",
    "Assists",
    "AssistsDead",
    "Uses",
    "UsesHits",
    "UsesHitPercent",
    "UsesCriticalHits",
    "UsesCriticalHitPercent",
    "Inspects",
    "InspectsAfterElimination",
    "AmmoUsed",
    "Reloads",
    "Zombies",
    "ZombiesDamageDealt",
    "ZombiesEliminations"
}, {
    { 1, "Note to self" }
})
v493("Flare Gun", {
    "Playtime",
    "PlaytimeUnequipped",
    "RoundsPlayed",
    "RoundsWon",
    "RoundsLost",
    "RoundsWinPercent",
    "RankedRoundsPlayed",
    "RankedRoundsWon",
    "RankedRoundsLost",
    "RankedRoundsWinPercent",
    "DamageDealt",
    "DamageDealtSliding",
    "DamageDealtCrouching",
    "DamageDealtAirborne",
    "DamageDealtBlinded",
    "DamageDealtDead",
    "Eliminations",
    "EliminationsSliding",
    "EliminationsCrouching",
    "EliminationsAirborne",
    "EliminationsBlinded",
    "EliminationsDead",
    "Deaths",
    "DeathsRatio",
    "Assists",
    "AssistsDead",
    "Uses",
    "UsesHits",
    "UsesHitPercent",
    "Inspects",
    "InspectsAfterElimination",
    "AmmoUsed",
    "Zombies",
    "ZombiesDamageDealt",
    "ZombiesEliminations"
}, {
    { 2, "Shoots a fireball that constantly burns nearby enemies" }
})
v493("Assault Rifle", {
    "Playtime",
    "PlaytimeUnequipped",
    "RoundsPlayed",
    "RoundsWon",
    "RoundsLost",
    "RoundsWinPercent",
    "RankedRoundsPlayed",
    "RankedRoundsWon",
    "RankedRoundsLost",
    "RankedRoundsWinPercent",
    "DamageDealt",
    "DamageDealtSliding",
    "DamageDealtCrouching",
    "DamageDealtAirborne",
    "DamageDealtBlinded",
    "DamageDealtDead",
    "Eliminations",
    "EliminationsSliding",
    "EliminationsCrouching",
    "EliminationsAirborne",
    "EliminationsBlinded",
    "EliminationsDead",
    "Deaths",
    "DeathsRatio",
    "Assists",
    "AssistsDead",
    "Uses",
    "UsesHits",
    "UsesHitPercent",
    "UsesCriticalHits",
    "UsesCriticalHitPercent",
    "Inspects",
    "InspectsAfterElimination",
    "AmmoUsed",
    "Reloads",
    "Zombies",
    "ZombiesDamageDealt",
    "ZombiesEliminations"
}, {
    { 2, "A standard rifle useful in all scenarios" }
})
v493("Handgun", {
    "Playtime",
    "PlaytimeUnequipped",
    "RoundsPlayed",
    "RoundsWon",
    "RoundsLost",
    "RoundsWinPercent",
    "RankedRoundsPlayed",
    "RankedRoundsWon",
    "RankedRoundsLost",
    "RankedRoundsWinPercent",
    "DamageDealt",
    "DamageDealtSliding",
    "DamageDealtCrouching",
    "DamageDealtAirborne",
    "DamageDealtBlinded",
    "DamageDealtDead",
    "Eliminations",
    "EliminationsSliding",
    "EliminationsCrouching",
    "EliminationsAirborne",
    "EliminationsBlinded",
    "EliminationsDead",
    "Deaths",
    "DeathsRatio",
    "Assists",
    "AssistsDead",
    "Uses",
    "UsesHits",
    "UsesHitPercent",
    "UsesCriticalHits",
    "UsesCriticalHitPercent",
    "Inspects",
    "InspectsAfterElimination",
    "AmmoUsed",
    "Reloads",
    "Zombies",
    "ZombiesDamageDealt",
    "ZombiesEliminations"
}, {
    { 2, "A reliable sidearm useful in all scenarios" }
})
v493("Burst Rifle", {
    "Playtime",
    "PlaytimeUnequipped",
    "RoundsPlayed",
    "RoundsWon",
    "RoundsLost",
    "RoundsWinPercent",
    "RankedRoundsPlayed",
    "RankedRoundsWon",
    "RankedRoundsLost",
    "RankedRoundsWinPercent",
    "DamageDealt",
    "DamageDealtSliding",
    "DamageDealtCrouching",
    "DamageDealtAirborne",
    "DamageDealtBlinded",
    "DamageDealtDead",
    "Eliminations",
    "EliminationsSliding",
    "EliminationsCrouching",
    "EliminationsAirborne",
    "EliminationsBlinded",
    "EliminationsDead",
    "Deaths",
    "DeathsRatio",
    "Assists",
    "AssistsDead",
    "Uses",
    "UsesHits",
    "UsesHitPercent",
    "UsesCriticalHits",
    "UsesCriticalHitPercent",
    "Inspects",
    "InspectsAfterElimination",
    "AmmoUsed",
    "Reloads",
    "Zombies",
    "ZombiesDamageDealt",
    "ZombiesEliminations"
}, {
    { 2, "Hit and run with this three-round burst rifle" }
})
v493("Sniper", {
    "Playtime",
    "PlaytimeUnequipped",
    "RoundsPlayed",
    "RoundsWon",
    "RoundsLost",
    "RoundsWinPercent",
    "RankedRoundsPlayed",
    "RankedRoundsWon",
    "RankedRoundsLost",
    "RankedRoundsWinPercent",
    "DamageDealt",
    "DamageDealtSliding",
    "DamageDealtCrouching",
    "DamageDealtAirborne",
    "DamageDealtBlinded",
    "DamageDealtDead",
    "DamageDealtNoscope",
    "Eliminations",
    "EliminationsSliding",
    "EliminationsCrouching",
    "EliminationsAirborne",
    "EliminationsBlinded",
    "EliminationsDead",
    "EliminationsNoscope",
    "Deaths",
    "DeathsRatio",
    "Assists",
    "AssistsDead",
    "Uses",
    "UsesHits",
    "UsesHitPercent",
    "UsesCriticalHits",
    "UsesCriticalHitPercent",
    "Inspects",
    "InspectsAfterElimination",
    "AmmoUsed",
    "Reloads",
    "Zombies",
    "ZombiesDamageDealt",
    "ZombiesEliminations"
}, {
    { 2, "Long ranged rifle that can deal devastating damage" }
})
v493("RPG", {
    "Playtime",
    "PlaytimeUnequipped",
    "RoundsPlayed",
    "RoundsWon",
    "RoundsLost",
    "RoundsWinPercent",
    "RankedRoundsPlayed",
    "RankedRoundsWon",
    "RankedRoundsLost",
    "RankedRoundsWinPercent",
    "DamageDealt",
    "DamageDealtSliding",
    "DamageDealtCrouching",
    "DamageDealtAirborne",
    "DamageDealtBlinded",
    "DamageDealtDead",
    "Eliminations",
    "EliminationsSliding",
    "EliminationsCrouching",
    "EliminationsAirborne",
    "EliminationsBlinded",
    "EliminationsDead",
    "Deaths",
    "DeathsRatio",
    "Assists",
    "AssistsDead",
    "Uses",
    "UsesHitsSelf",
    "UsesHits",
    "UsesHitPercent",
    "UsesHitsDirect",
    "Inspects",
    "InspectsAfterElimination",
    "AmmoUsed",
    "Reloads",
    "Zombies",
    "ZombiesDamageDealt",
    "ZombiesEliminations"
}, {
    { 1, "A powerful explosive launcher" }
})
v493("Shorty", {
    "Playtime",
    "PlaytimeUnequipped",
    "RoundsPlayed",
    "RoundsWon",
    "RoundsLost",
    "RoundsWinPercent",
    "RankedRoundsPlayed",
    "RankedRoundsWon",
    "RankedRoundsLost",
    "RankedRoundsWinPercent",
    "DamageDealt",
    "DamageDealtSliding",
    "DamageDealtCrouching",
    "DamageDealtAirborne",
    "DamageDealtBlinded",
    "DamageDealtDead",
    "Eliminations",
    "EliminationsSliding",
    "EliminationsCrouching",
    "EliminationsAirborne",
    "EliminationsBlinded",
    "EliminationsDead",
    "Deaths",
    "DeathsRatio",
    "Assists",
    "AssistsDead",
    "Uses",
    "UsesHits",
    "UsesHitPercent",
    "UsesCriticalHits",
    "UsesCriticalHitPercent",
    "Inspects",
    "InspectsAfterElimination",
    "AmmoUsed",
    "Reloads",
    "Zombies",
    "ZombiesDamageDealt",
    "ZombiesEliminations"
}, {
    { 2, "A quick sidearm that can be deadly up close" }
})
v493("Shotgun", {
    "Playtime",
    "PlaytimeUnequipped",
    "RoundsPlayed",
    "RoundsWon",
    "RoundsLost",
    "RoundsWinPercent",
    "RankedRoundsPlayed",
    "RankedRoundsWon",
    "RankedRoundsLost",
    "RankedRoundsWinPercent",
    "DamageDealt",
    "DamageDealtSliding",
    "DamageDealtCrouching",
    "DamageDealtAirborne",
    "DamageDealtBlinded",
    "DamageDealtDead",
    "Eliminations",
    "EliminationsSliding",
    "EliminationsCrouching",
    "EliminationsAirborne",
    "EliminationsBlinded",
    "EliminationsDead",
    "Deaths",
    "DeathsRatio",
    "Assists",
    "AssistsDead",
    "Uses",
    "UsesHits",
    "UsesHitPercent",
    "UsesCriticalHits",
    "UsesCriticalHitPercent",
    "Inspects",
    "InspectsAfterElimination",
    "AmmoUsed",
    "Reloads",
    "Zombies",
    "ZombiesDamageDealt",
    "ZombiesEliminations"
}, {
    { 1, "Deadly up close" }
})
v493("Bow", {
    "Playtime",
    "PlaytimeUnequipped",
    "RoundsPlayed",
    "RoundsWon",
    "RoundsLost",
    "RoundsWinPercent",
    "RankedRoundsPlayed",
    "RankedRoundsWon",
    "RankedRoundsLost",
    "RankedRoundsWinPercent",
    "DamageDealt",
    "DamageDealtSliding",
    "DamageDealtCrouching",
    "DamageDealtAirborne",
    "DamageDealtBlinded",
    "DamageDealtDead",
    "Eliminations",
    "EliminationsSliding",
    "EliminationsCrouching",
    "EliminationsAirborne",
    "EliminationsBlinded",
    "EliminationsDead",
    "Deaths",
    "DeathsRatio",
    "Assists",
    "AssistsDead",
    "Uses",
    "UsesHits",
    "UsesHitPercent",
    "UsesCriticalHits",
    "UsesCriticalHitPercent",
    "Inspects",
    "InspectsAfterElimination",
    "AmmoUsed",
    "Reloads",
    "Zombies",
    "ZombiesDamageDealt",
    "ZombiesEliminations"
}, {
    { 2, "Projectile weapon that rewards accuracy" },
    { 2, "Charge up your arrows to deal heavy damage" },
    { 1, "Allows you to double jump" }
})
v493("Uzi", {
    "Playtime",
    "PlaytimeUnequipped",
    "RoundsPlayed",
    "RoundsWon",
    "RoundsLost",
    "RoundsWinPercent",
    "RankedRoundsPlayed",
    "RankedRoundsWon",
    "RankedRoundsLost",
    "RankedRoundsWinPercent",
    "DamageDealt",
    "DamageDealtSliding",
    "DamageDealtCrouching",
    "DamageDealtAirborne",
    "DamageDealtBlinded",
    "DamageDealtDead",
    "Eliminations",
    "EliminationsSliding",
    "EliminationsCrouching",
    "EliminationsAirborne",
    "EliminationsBlinded",
    "EliminationsDead",
    "Deaths",
    "DeathsRatio",
    "Assists",
    "AssistsDead",
    "Uses",
    "UsesHits",
    "UsesHitPercent",
    "UsesCriticalHits",
    "UsesCriticalHitPercent",
    "Inspects",
    "InspectsAfterElimination",
    "AmmoUsed",
    "Reloads",
    "Zombies",
    "ZombiesDamageDealt",
    "ZombiesEliminations"
}, {
    { 2, "Light enemies up with this automatic sidearm" },
    { 1, "Slightly inaccurate" }
})
v493("Revolver", {
    "Playtime",
    "PlaytimeUnequipped",
    "RoundsPlayed",
    "RoundsWon",
    "RoundsLost",
    "RoundsWinPercent",
    "RankedRoundsPlayed",
    "RankedRoundsWon",
    "RankedRoundsLost",
    "RankedRoundsWinPercent",
    "DamageDealt",
    "DamageDealtSliding",
    "DamageDealtCrouching",
    "DamageDealtAirborne",
    "DamageDealtBlinded",
    "DamageDealtDead",
    "Eliminations",
    "EliminationsSliding",
    "EliminationsCrouching",
    "EliminationsAirborne",
    "EliminationsBlinded",
    "EliminationsDead",
    "Deaths",
    "DeathsRatio",
    "Assists",
    "AssistsDead",
    "Uses",
    "UsesHits",
    "UsesHitPercent",
    "UsesCriticalHits",
    "UsesCriticalHitPercent",
    "Inspects",
    "InspectsAfterElimination",
    "AmmoUsed",
    "Reloads",
    "Zombies",
    "ZombiesDamageDealt",
    "ZombiesEliminations"
}, {
    { 1, "A slow but powerful handgun" },
    { 2, "Fan the hammer to unload the entire chamber" }
})
v493("Paintball Gun", {
    "Playtime",
    "PlaytimeUnequipped",
    "RoundsPlayed",
    "RoundsWon",
    "RoundsLost",
    "RoundsWinPercent",
    "RankedRoundsPlayed",
    "RankedRoundsWon",
    "RankedRoundsLost",
    "RankedRoundsWinPercent",
    "DamageDealt",
    "DamageDealtSliding",
    "DamageDealtCrouching",
    "DamageDealtAirborne",
    "DamageDealtBlinded",
    "DamageDealtDead",
    "Eliminations",
    "EliminationsSliding",
    "EliminationsCrouching",
    "EliminationsAirborne",
    "EliminationsBlinded",
    "EliminationsDead",
    "Deaths",
    "DeathsRatio",
    "Assists",
    "AssistsDead",
    "Uses",
    "UsesHits",
    "UsesHitPercent",
    "UsesCriticalHits",
    "UsesCriticalHitPercent",
    "Inspects",
    "InspectsAfterElimination",
    "AmmoUsed",
    "Reloads",
    "Zombies",
    "ZombiesDamageDealt",
    "ZombiesEliminations"
}, {
    { 2, "Splatter your enemies screens with this colorful rifle" }
})
v493("Slingshot", {
    "Playtime",
    "PlaytimeUnequipped",
    "RoundsPlayed",
    "RoundsWon",
    "RoundsLost",
    "RoundsWinPercent",
    "RankedRoundsPlayed",
    "RankedRoundsWon",
    "RankedRoundsLost",
    "RankedRoundsWinPercent",
    "DamageDealt",
    "DamageDealtSliding",
    "DamageDealtCrouching",
    "DamageDealtAirborne",
    "DamageDealtBlinded",
    "DamageDealtDead",
    "DamageDealtBouncing",
    "Eliminations",
    "EliminationsSliding",
    "EliminationsCrouching",
    "EliminationsAirborne",
    "EliminationsBlinded",
    "EliminationsDead",
    "EliminationsBouncing",
    "Deaths",
    "DeathsRatio",
    "Assists",
    "AssistsDead",
    "Uses",
    "UsesHits",
    "UsesHitPercent",
    "UsesCriticalHits",
    "UsesCriticalHitPercent",
    "Inspects",
    "InspectsAfterElimination",
    "AmmoUsed",
    "Zombies",
    "ZombiesDamageDealt",
    "ZombiesEliminations"
}, {
    { 1, "Unleash a barrage of bouncy balls" }
})
v493("Grenade Launcher", {
    "Playtime",
    "PlaytimeUnequipped",
    "RoundsPlayed",
    "RoundsWon",
    "RoundsLost",
    "RoundsWinPercent",
    "RankedRoundsPlayed",
    "RankedRoundsWon",
    "RankedRoundsLost",
    "RankedRoundsWinPercent",
    "DamageDealt",
    "DamageDealtSliding",
    "DamageDealtCrouching",
    "DamageDealtAirborne",
    "DamageDealtBlinded",
    "DamageDealtDead",
    "Eliminations",
    "EliminationsSliding",
    "EliminationsCrouching",
    "EliminationsAirborne",
    "EliminationsBlinded",
    "EliminationsDead",
    "Deaths",
    "DeathsRatio",
    "Assists",
    "AssistsDead",
    "Uses",
    "UsesHitsSelf",
    "UsesHits",
    "UsesHitPercent",
    "UsesHitsDirect",
    "Inspects",
    "InspectsAfterElimination",
    "AmmoUsed",
    "Reloads",
    "Zombies",
    "ZombiesDamageDealt",
    "ZombiesEliminations"
}, {
    { 2, "Quickly rain explosives on your enemies" }
})
v493("Minigun", {
    "Playtime",
    "PlaytimeUnequipped",
    "RoundsPlayed",
    "RoundsWon",
    "RoundsLost",
    "RoundsWinPercent",
    "RankedRoundsPlayed",
    "RankedRoundsWon",
    "RankedRoundsLost",
    "RankedRoundsWinPercent",
    "DamageDealt",
    "DamageDealtSliding",
    "DamageDealtCrouching",
    "DamageDealtAirborne",
    "DamageDealtBlinded",
    "DamageDealtDead",
    "Eliminations",
    "EliminationsSliding",
    "EliminationsCrouching",
    "EliminationsAirborne",
    "EliminationsBlinded",
    "EliminationsDead",
    "Deaths",
    "DeathsRatio",
    "Assists",
    "AssistsDead",
    "Uses",
    "UsesHits",
    "UsesHitPercent",
    "UsesCriticalHits",
    "UsesCriticalHitPercent",
    "Inspects",
    "InspectsAfterElimination",
    "AmmoUsed",
    "Zombies",
    "ZombiesDamageDealt",
    "ZombiesEliminations"
}, {
    { 1, "Probably dangerous" }
})
v493("Exogun", {
    "Playtime",
    "PlaytimeUnequipped",
    "RoundsPlayed",
    "RoundsWon",
    "RoundsLost",
    "RoundsWinPercent",
    "RankedRoundsPlayed",
    "RankedRoundsWon",
    "RankedRoundsLost",
    "RankedRoundsWinPercent",
    "DamageDealt",
    "DamageDealtSliding",
    "DamageDealtCrouching",
    "DamageDealtAirborne",
    "DamageDealtBlinded",
    "DamageDealtDead",
    "Eliminations",
    "EliminationsSliding",
    "EliminationsCrouching",
    "EliminationsAirborne",
    "EliminationsBlinded",
    "EliminationsDead",
    "Deaths",
    "DeathsRatio",
    "Assists",
    "AssistsDead",
    "Uses",
    "UsesHits",
    "UsesHitPercent",
    "Inspects",
    "InspectsAfterElimination",
    "AmmoUsed",
    "Reloads",
    "Zombies",
    "ZombiesDamageDealt",
    "ZombiesEliminations"
}, {
    { 1, "Pew pew pew" }
})
v493("Fists", {
    "Playtime",
    "PlaytimeUnequipped",
    "RoundsPlayed",
    "RoundsWon",
    "RoundsLost",
    "RoundsWinPercent",
    "RankedRoundsPlayed",
    "RankedRoundsWon",
    "RankedRoundsLost",
    "RankedRoundsWinPercent",
    "DamageDealt",
    "DamageDealtSliding",
    "DamageDealtCrouching",
    "DamageDealtAirborne",
    "DamageDealtBlinded",
    "DamageDealtDead",
    "Eliminations",
    "EliminationsSliding",
    "EliminationsCrouching",
    "EliminationsAirborne",
    "EliminationsBlinded",
    "EliminationsDead",
    "Deaths",
    "DeathsRatio",
    "Assists",
    "AssistsDead",
    "Uses",
    "UsesQuick",
    "UsesHits",
    "UsesHitPercent",
    "Inspects",
    "InspectsAfterElimination",
    "Zombies",
    "ZombiesDamageDealt",
    "ZombiesEliminations"
}, {
    { 1, "Allows you to double jump" }
})
v493("Knife", {
    "Playtime",
    "PlaytimeUnequipped",
    "RoundsPlayed",
    "RoundsWon",
    "RoundsLost",
    "RoundsWinPercent",
    "RankedRoundsPlayed",
    "RankedRoundsWon",
    "RankedRoundsLost",
    "RankedRoundsWinPercent",
    "DamageDealt",
    "DamageDealtSliding",
    "DamageDealtCrouching",
    "DamageDealtAirborne",
    "DamageDealtBlinded",
    "DamageDealtDead",
    "Eliminations",
    "EliminationsSliding",
    "EliminationsCrouching",
    "EliminationsAirborne",
    "EliminationsBlinded",
    "EliminationsDead",
    "Deaths",
    "DeathsRatio",
    "Assists",
    "AssistsDead",
    "Uses",
    "UsesQuick",
    "UsesHits",
    "UsesHitPercent",
    "UsesCriticalHits",
    "UsesCriticalHitPercent",
    "Inspects",
    "InspectsAfterElimination",
    "Zombies",
    "ZombiesDamageDealt",
    "ZombiesEliminations"
}, {
    { 2, "Backstab enemies for an instant elimination" }
})
v493("Chainsaw", {
    "Playtime",
    "PlaytimeUnequipped",
    "RoundsPlayed",
    "RoundsWon",
    "RoundsLost",
    "RoundsWinPercent",
    "RankedRoundsPlayed",
    "RankedRoundsWon",
    "RankedRoundsLost",
    "RankedRoundsWinPercent",
    "DamageDealt",
    "DamageDealtSliding",
    "DamageDealtCrouching",
    "DamageDealtAirborne",
    "DamageDealtBlinded",
    "DamageDealtDead",
    "Eliminations",
    "EliminationsSliding",
    "EliminationsCrouching",
    "EliminationsAirborne",
    "EliminationsBlinded",
    "EliminationsDead",
    "Deaths",
    "DeathsRatio",
    "Assists",
    "AssistsDead",
    "Uses",
    "UsesQuick",
    "UsesHits",
    "UsesHitPercent",
    "Inspects",
    "InspectsAfterElimination",
    "AmmoUsed",
    "Zombies",
    "ZombiesDamageDealt",
    "ZombiesEliminations"
}, {
    { 2, "Mow enemies down at frightening speeds" }
})
v493("Katana", {
    "Playtime",
    "PlaytimeUnequipped",
    "RoundsPlayed",
    "RoundsWon",
    "RoundsLost",
    "RoundsWinPercent",
    "RankedRoundsPlayed",
    "RankedRoundsWon",
    "RankedRoundsLost",
    "RankedRoundsWinPercent",
    "DamageDealt",
    "DamageDealtSliding",
    "DamageDealtCrouching",
    "DamageDealtAirborne",
    "DamageDealtBlinded",
    "DamageDealtDead",
    "DamageDealtDeflecting",
    "Eliminations",
    "EliminationsSliding",
    "EliminationsCrouching",
    "EliminationsAirborne",
    "EliminationsBlinded",
    "EliminationsDead",
    "EliminationsDeflecting",
    "Deaths",
    "DeathsRatio",
    "Assists",
    "AssistsDead",
    "Uses",
    "UsesQuick",
    "UsesHits",
    "UsesHitPercent",
    "Inspects",
    "InspectsAfterElimination",
    "Deflects",
    "DeflectsHits",
    "DeflectsCriticalHits",
    "Zombies",
    "ZombiesDamageDealt",
    "ZombiesEliminations"
}, {
    { 2, "Can deflect bullets back at enemies" }
})
v493("Scythe", {
    "Playtime",
    "PlaytimeUnequipped",
    "RoundsPlayed",
    "RoundsWon",
    "RoundsLost",
    "RoundsWinPercent",
    "RankedRoundsPlayed",
    "RankedRoundsWon",
    "RankedRoundsLost",
    "RankedRoundsWinPercent",
    "DamageDealt",
    "DamageDealtSliding",
    "DamageDealtCrouching",
    "DamageDealtAirborne",
    "DamageDealtBlinded",
    "DamageDealtDead",
    "DamageDealtDashing",
    "Eliminations",
    "EliminationsSliding",
    "EliminationsCrouching",
    "EliminationsAirborne",
    "EliminationsBlinded",
    "EliminationsDead",
    "EliminationsDashing",
    "Deaths",
    "DeathsRatio",
    "Assists",
    "AssistsDead",
    "Uses",
    "UsesQuick",
    "UsesHits",
    "UsesHitPercent",
    "Inspects",
    "InspectsAfterElimination",
    "Dashes",
    "Zombies",
    "ZombiesDamageDealt",
    "ZombiesEliminations"
}, {
    { 2, "Allows you to quickly dash in any direction" }
})
v493("Trowel", {
    "Playtime",
    "PlaytimeUnequipped",
    "RoundsPlayed",
    "RoundsWon",
    "RoundsLost",
    "RoundsWinPercent",
    "RankedRoundsPlayed",
    "RankedRoundsWon",
    "RankedRoundsLost",
    "RankedRoundsWinPercent",
    "DamageDealt",
    "DamageDealtSliding",
    "DamageDealtCrouching",
    "DamageDealtAirborne",
    "DamageDealtBlinded",
    "DamageDealtDead",
    "Eliminations",
    "EliminationsSliding",
    "EliminationsCrouching",
    "EliminationsAirborne",
    "EliminationsBlinded",
    "EliminationsDead",
    "Deaths",
    "DeathsRatio",
    "Assists",
    "AssistsDead",
    "Uses",
    "UsesQuick",
    "UsesHits",
    "UsesHitPercent",
    "Inspects",
    "InspectsAfterElimination",
    "WallsBuilt",
    "WallsBuiltBricksLayed",
    "Zombies",
    "ZombiesDamageDealt",
    "ZombiesEliminations"
}, {
    { 1, "Build walls to defend yourself" },
    { 2, "Send the bricks flying to harden them in place" }
})
v493("Grenade", {
    "Playtime",
    "PlaytimeUnequipped",
    "RoundsPlayed",
    "RoundsWon",
    "RoundsLost",
    "RoundsWinPercent",
    "RankedRoundsPlayed",
    "RankedRoundsWon",
    "RankedRoundsLost",
    "RankedRoundsWinPercent",
    "DamageDealt",
    "DamageDealtSliding",
    "DamageDealtCrouching",
    "DamageDealtAirborne",
    "DamageDealtBlinded",
    "DamageDealtDead",
    "Eliminations",
    "EliminationsSliding",
    "EliminationsCrouching",
    "EliminationsAirborne",
    "EliminationsBlinded",
    "EliminationsDead",
    "Deaths",
    "DeathsRatio",
    "Assists",
    "AssistsDead",
    "Uses",
    "UsesQuick",
    "UsesHitsSelf",
    "UsesHits",
    "UsesHitPercent",
    "UsesCriticalHits",
    "UsesCriticalHitPercent",
    "Inspects",
    "InspectsAfterElimination",
    "Zombies",
    "ZombiesDamageDealt",
    "ZombiesEliminations"
}, {
    { 1, "Quick & reliable explosive" }
})
v493("Molotov", {
    "Playtime",
    "PlaytimeUnequipped",
    "RoundsPlayed",
    "RoundsWon",
    "RoundsLost",
    "RoundsWinPercent",
    "RankedRoundsPlayed",
    "RankedRoundsWon",
    "RankedRoundsLost",
    "RankedRoundsWinPercent",
    "DamageDealt",
    "DamageDealtSliding",
    "DamageDealtCrouching",
    "DamageDealtAirborne",
    "DamageDealtBlinded",
    "DamageDealtDead",
    "Eliminations",
    "EliminationsSliding",
    "EliminationsCrouching",
    "EliminationsAirborne",
    "EliminationsBlinded",
    "EliminationsDead",
    "Deaths",
    "DeathsRatio",
    "Assists",
    "AssistsDead",
    "Uses",
    "UsesQuick",
    "UsesHits",
    "UsesHitPercent",
    "UsesCriticalHits",
    "UsesCriticalHitPercent",
    "Inspects",
    "InspectsAfterElimination",
    "Zombies",
    "ZombiesDamageDealt",
    "ZombiesEliminations"
}, {
    { 2, "An unethical way of setting your enemies on fire" }
})
v493("Flashbang", {
    "Playtime",
    "PlaytimeUnequipped",
    "RoundsPlayed",
    "RoundsWon",
    "RoundsLost",
    "RoundsWinPercent",
    "RankedRoundsPlayed",
    "RankedRoundsWon",
    "RankedRoundsLost",
    "RankedRoundsWinPercent",
    "DamageDealt",
    "DamageDealtSliding",
    "DamageDealtCrouching",
    "DamageDealtAirborne",
    "DamageDealtBlinded",
    "DamageDealtDead",
    "Eliminations",
    "EliminationsSliding",
    "EliminationsCrouching",
    "EliminationsAirborne",
    "EliminationsBlinded",
    "EliminationsDead",
    "Deaths",
    "DeathsRatio",
    "Assists",
    "AssistsDead",
    "Uses",
    "UsesQuick",
    "UsesHits",
    "UsesHitPercent",
    "UsesCriticalHits",
    "UsesCriticalHitPercent",
    "Inspects",
    "InspectsAfterElimination",
    "Blinds",
    "BlindsSelf",
    "BlindsEnemies",
    "BlindsTeammates",
    "Zombies",
    "ZombiesDamageDealt",
    "ZombiesEliminations"
}, {
    { 1, "Blinds enemies for a long time" }
})
v493("Smoke Grenade", {
    "Playtime",
    "PlaytimeUnequipped",
    "RoundsPlayed",
    "RoundsWon",
    "RoundsLost",
    "RoundsWinPercent",
    "RankedRoundsPlayed",
    "RankedRoundsWon",
    "RankedRoundsLost",
    "RankedRoundsWinPercent",
    "DamageDealt",
    "DamageDealtSliding",
    "DamageDealtCrouching",
    "DamageDealtAirborne",
    "DamageDealtBlinded",
    "DamageDealtDead",
    "Eliminations",
    "EliminationsSliding",
    "EliminationsCrouching",
    "EliminationsAirborne",
    "EliminationsBlinded",
    "EliminationsDead",
    "Deaths",
    "DeathsRatio",
    "Assists",
    "AssistsDead",
    "Uses",
    "UsesQuick",
    "UsesHits",
    "UsesHitPercent",
    "UsesCriticalHits",
    "UsesCriticalHitPercent",
    "Inspects",
    "InspectsAfterElimination",
    "Smokeds",
    "SmokedsSelf",
    "SmokedsEnemies",
    "SmokedsTeammates",
    "Extinguishes",
    "ExtinguishesPlayers",
    "ExtinguishesMolotovs",
    "ExtinguishesFlareGuns",
    "ExtinguishesFlamethrowers",
    "Zombies",
    "ZombiesDamageDealt",
    "ZombiesEliminations"
}, {
    { 3, "Creates a smoke cloud which obscures vision and extinguishes all flames" }
})
v493("Medkit", {
    "Playtime",
    "PlaytimeUnequipped",
    "RoundsPlayed",
    "RoundsWon",
    "RoundsLost",
    "RoundsWinPercent",
    "RankedRoundsPlayed",
    "RankedRoundsWon",
    "RankedRoundsLost",
    "RankedRoundsWinPercent",
    "Deaths",
    "Uses",
    "UsesQuick",
    "Inspects",
    "InspectsAfterElimination",
    "HealsGiven",
    "Zombies",
    "ZombiesDamageDealt",
    "ZombiesEliminations"
}, {
    { 2, "Allows you to heal in the midst of a battle" }
})
v493("Subspace Tripmine", {
    "Playtime",
    "PlaytimeUnequipped",
    "RoundsPlayed",
    "RoundsWon",
    "RoundsLost",
    "RoundsWinPercent",
    "RankedRoundsPlayed",
    "RankedRoundsWon",
    "RankedRoundsLost",
    "RankedRoundsWinPercent",
    "DamageDealt",
    "DamageDealtSliding",
    "DamageDealtCrouching",
    "DamageDealtAirborne",
    "DamageDealtBlinded",
    "DamageDealtDead",
    "Eliminations",
    "EliminationsSliding",
    "EliminationsCrouching",
    "EliminationsAirborne",
    "EliminationsBlinded",
    "EliminationsDead",
    "Deaths",
    "DeathsRatio",
    "Assists",
    "AssistsDead",
    "Uses",
    "UsesQuick",
    "UsesHitsSelf",
    "UsesHits",
    "UsesHitPercent",
    "Inspects",
    "InspectsAfterElimination",
    "Zombies",
    "ZombiesDamageDealt",
    "ZombiesEliminations"
}, {
    { 3, "An invisible explosive that deals heavy damage and sends enemies flying" }
})
v493("Flamethrower", {
    "Playtime",
    "PlaytimeUnequipped",
    "RoundsPlayed",
    "RoundsWon",
    "RoundsLost",
    "RoundsWinPercent",
    "RankedRoundsPlayed",
    "RankedRoundsWon",
    "RankedRoundsLost",
    "RankedRoundsWinPercent",
    "DamageDealt",
    "DamageDealtSliding",
    "DamageDealtCrouching",
    "DamageDealtAirborne",
    "DamageDealtBlinded",
    "DamageDealtDead",
    "Eliminations",
    "EliminationsSliding",
    "EliminationsCrouching",
    "EliminationsAirborne",
    "EliminationsBlinded",
    "EliminationsDead",
    "Deaths",
    "DeathsRatio",
    "Assists",
    "AssistsDead",
    "Uses",
    "UsesHits",
    "UsesHitPercent",
    "Inspects",
    "InspectsAfterElimination",
    "AmmoUsed",
    "Airblasts",
    "AirblastsHits",
    "AirblastsSmokesCleared",
    "Zombies",
    "ZombiesDamageDealt",
    "ZombiesEliminations"
}, {
    { 1, "Set your enemies on fire" },
    { 2, "Use the Airblast to push enemies & smoke clouds" }
})
v493("Freeze Ray", {
    "Playtime",
    "PlaytimeUnequipped",
    "RoundsPlayed",
    "RoundsWon",
    "RoundsLost",
    "RoundsWinPercent",
    "RankedRoundsPlayed",
    "RankedRoundsWon",
    "RankedRoundsLost",
    "RankedRoundsWinPercent",
    "Eliminations",
    "EliminationsSliding",
    "EliminationsCrouching",
    "EliminationsAirborne",
    "EliminationsBlinded",
    "EliminationsDead",
    "Deaths",
    "DeathsRatio",
    "Assists",
    "AssistsDead",
    "Uses",
    "UsesQuick",
    "UsesHits",
    "UsesHitPercent",
    "Inspects",
    "InspectsAfterElimination",
    "AmmoUsed",
    "Freezes",
    "FreezesSelf",
    "FreezesEnemies"
}, {
    { 2, "Freeze your enemies with this splash projectile weapon" }
})
v493("Elixir", {
    "Playtime",
    "PlaytimeUnequipped",
    "RoundsPlayed",
    "RoundsWon",
    "RoundsLost",
    "RoundsWinPercent",
    "RankedRoundsPlayed",
    "RankedRoundsWon",
    "RankedRoundsLost",
    "RankedRoundsWinPercent",
    "DamageDealt",
    "DamageDealtSliding",
    "DamageDealtCrouching",
    "DamageDealtAirborne",
    "DamageDealtBlinded",
    "DamageDealtDead",
    "Eliminations",
    "EliminationsSliding",
    "EliminationsCrouching",
    "EliminationsAirborne",
    "EliminationsBlinded",
    "EliminationsDead",
    "Deaths",
    "DeathsRatio",
    "Assists",
    "AssistsDead",
    "Uses",
    "UsesQuick",
    "UsesHitsSelf",
    "UsesHits",
    "UsesHitPercent",
    "UsesCriticalHits",
    "UsesCriticalHitPercent",
    "Inspects",
    "InspectsAfterElimination",
    "HealsGiven",
    "HealsGivenTeammates",
    "Zombies",
    "ZombiesDamageDealt",
    "ZombiesEliminations"
}, {
    { 2, "Splash your enemies to deal damage over time" },
    { 2, "Splash your teammates to heal over time" }
})
v493("War Horn", {
    "Playtime",
    "PlaytimeUnequipped",
    "RoundsPlayed",
    "RoundsWon",
    "RoundsLost",
    "RoundsWinPercent",
    "RankedRoundsPlayed",
    "RankedRoundsWon",
    "RankedRoundsLost",
    "RankedRoundsWinPercent",
    "Deaths",
    "Uses",
    "UsesQuick",
    "Inspects",
    "InspectsAfterElimination",
    "Empowers",
    "EmpowersSelf",
    "EmpowersTeammates"
}, {
    { 2, "Charge your team into battle with this global speed boost" }
})
v493("Satchel", {
    "Playtime",
    "PlaytimeUnequipped",
    "RoundsPlayed",
    "RoundsWon",
    "RoundsLost",
    "RoundsWinPercent",
    "RankedRoundsPlayed",
    "RankedRoundsWon",
    "RankedRoundsLost",
    "RankedRoundsWinPercent",
    "DamageDealt",
    "DamageDealtSliding",
    "DamageDealtCrouching",
    "DamageDealtAirborne",
    "DamageDealtBlinded",
    "DamageDealtDead",
    "Eliminations",
    "EliminationsSliding",
    "EliminationsCrouching",
    "EliminationsAirborne",
    "EliminationsBlinded",
    "EliminationsDead",
    "Deaths",
    "DeathsRatio",
    "Assists",
    "AssistsDead",
    "Uses",
    "UsesQuick",
    "UsesHitsSelf",
    "UsesHits",
    "UsesHitPercent",
    "Inspects",
    "InspectsAfterElimination",
    "Zombies",
    "ZombiesDamageDealt",
    "ZombiesEliminations"
}, {
    { 2, "Stick multiple explosive charges onto walls" },
    { 2, "Detonate or shoot the satchels to cause a chain explosion" },
    { 1, "Can stick to Riot Shields" }
})
v493("Battle Axe", {
    "Playtime",
    "PlaytimeUnequipped",
    "RoundsPlayed",
    "RoundsWon",
    "RoundsLost",
    "RoundsWinPercent",
    "RankedRoundsPlayed",
    "RankedRoundsWon",
    "RankedRoundsLost",
    "RankedRoundsWinPercent",
    "DamageDealt",
    "DamageDealtSliding",
    "DamageDealtCrouching",
    "DamageDealtAirborne",
    "DamageDealtBlinded",
    "DamageDealtDead",
    "DamageDealtDashing",
    "Eliminations",
    "EliminationsSliding",
    "EliminationsCrouching",
    "EliminationsAirborne",
    "EliminationsBlinded",
    "EliminationsDead",
    "EliminationsDashing",
    "Deaths",
    "DeathsRatio",
    "Assists",
    "AssistsDead",
    "Uses",
    "UsesQuick",
    "UsesHits",
    "UsesHitPercent",
    "Inspects",
    "InspectsAfterElimination",
    "Dashes",
    "Zombies",
    "ZombiesDamageDealt",
    "ZombiesEliminations"
}, {
    { 2, "Use the spin attack to slice through the competition" }
})
v493("Riot Shield", {
    "Playtime",
    "PlaytimeUnequipped",
    "RoundsPlayed",
    "RoundsWon",
    "RoundsLost",
    "RoundsWinPercent",
    "RankedRoundsPlayed",
    "RankedRoundsWon",
    "RankedRoundsLost",
    "RankedRoundsWinPercent",
    "DamageDealt",
    "DamageDealtSliding",
    "DamageDealtCrouching",
    "DamageDealtAirborne",
    "DamageDealtBlinded",
    "DamageDealtDead",
    "DamageDealtDeflecting",
    "Eliminations",
    "EliminationsSliding",
    "EliminationsCrouching",
    "EliminationsAirborne",
    "EliminationsBlinded",
    "EliminationsDead",
    "EliminationsDeflecting",
    "Deaths",
    "DeathsRatio",
    "Assists",
    "AssistsDead",
    "Uses",
    "UsesQuick",
    "UsesHits",
    "UsesHitPercent",
    "Inspects",
    "InspectsAfterElimination",
    "Absorbs",
    "AbsorbsBehind",
    "Zombies",
    "ZombiesDamageDealt",
    "ZombiesEliminations"
}, {
    { 2, "Shove your enemies out of the way" },
    { 1, "Absorbs most damage sources" },
    { 2, "Absorbs damage from behind while unequipped" }
})
v493("Scepter", {
    "Playtime",
    "PlaytimeUnequipped",
    "RoundsPlayed",
    "RoundsWon",
    "RoundsLost",
    "RoundsWinPercent",
    "RankedRoundsPlayed",
    "RankedRoundsWon",
    "RankedRoundsLost",
    "RankedRoundsWinPercent",
    "DamageDealt",
    "DamageDealtSliding",
    "DamageDealtCrouching",
    "DamageDealtAirborne",
    "DamageDealtBlinded",
    "DamageDealtDead",
    "Eliminations",
    "EliminationsSliding",
    "EliminationsCrouching",
    "EliminationsAirborne",
    "EliminationsBlinded",
    "EliminationsDead",
    "Deaths",
    "DeathsRatio",
    "Assists",
    "AssistsDead",
    "Uses",
    "UsesHits",
    "UsesHitPercent",
    "UsesCriticalHits",
    "UsesCriticalHitPercent",
    "Inspects",
    "InspectsAfterElimination",
    "AmmoUsed",
    "Zombies",
    "ZombiesDamageDealt",
    "ZombiesEliminations"
}, {
    { 2, "Casts a magic spell that grows in speed & power" }
})
v493("Daggers", {
    "Playtime",
    "PlaytimeUnequipped",
    "RoundsPlayed",
    "RoundsWon",
    "RoundsLost",
    "RoundsWinPercent",
    "RankedRoundsPlayed",
    "RankedRoundsWon",
    "RankedRoundsLost",
    "RankedRoundsWinPercent",
    "DamageDealt",
    "DamageDealtSliding",
    "DamageDealtCrouching",
    "DamageDealtAirborne",
    "DamageDealtBlinded",
    "DamageDealtDead",
    "Eliminations",
    "EliminationsSliding",
    "EliminationsCrouching",
    "EliminationsAirborne",
    "EliminationsBlinded",
    "EliminationsDead",
    "Deaths",
    "DeathsRatio",
    "Assists",
    "AssistsDead",
    "Uses",
    "UsesHits",
    "UsesHitPercent",
    "UsesCriticalHits",
    "UsesCriticalHitPercent",
    "Inspects",
    "InspectsAfterElimination",
    "AmmoUsed",
    "Reloads",
    "Zombies",
    "ZombiesDamageDealt",
    "ZombiesEliminations"
}, {
    { 2, "Burst your enemies down with these nimble projectiles" },
    { 1, "Allows you to double jump" }
})
v493("Energy Pistols", {
    "Playtime",
    "PlaytimeUnequipped",
    "RoundsPlayed",
    "RoundsWon",
    "RoundsLost",
    "RoundsWinPercent",
    "RankedRoundsPlayed",
    "RankedRoundsWon",
    "RankedRoundsLost",
    "RankedRoundsWinPercent",
    "DamageDealt",
    "DamageDealtSliding",
    "DamageDealtCrouching",
    "DamageDealtAirborne",
    "DamageDealtBlinded",
    "DamageDealtDead",
    "Eliminations",
    "EliminationsSliding",
    "EliminationsCrouching",
    "EliminationsAirborne",
    "EliminationsBlinded",
    "EliminationsDead",
    "Deaths",
    "DeathsRatio",
    "Assists",
    "AssistsDead",
    "Uses",
    "UsesHits",
    "UsesHitPercent",
    "UsesCriticalHits",
    "UsesCriticalHitPercent",
    "Inspects",
    "InspectsAfterElimination",
    "AmmoUsed",
    "Zombies",
    "ZombiesDamageDealt",
    "ZombiesEliminations"
}, {
    { 1, "Harness the power of laser beams" }
})
v493("Energy Rifle", {
    "Playtime",
    "PlaytimeUnequipped",
    "RoundsPlayed",
    "RoundsWon",
    "RoundsLost",
    "RoundsWinPercent",
    "RankedRoundsPlayed",
    "RankedRoundsWon",
    "RankedRoundsLost",
    "RankedRoundsWinPercent",
    "DamageDealt",
    "DamageDealtSliding",
    "DamageDealtCrouching",
    "DamageDealtAirborne",
    "DamageDealtBlinded",
    "DamageDealtDead",
    "DamageDealtBouncing",
    "Eliminations",
    "EliminationsSliding",
    "EliminationsCrouching",
    "EliminationsAirborne",
    "EliminationsBlinded",
    "EliminationsDead",
    "EliminationsBouncing",
    "Deaths",
    "DeathsRatio",
    "Assists",
    "AssistsDead",
    "Uses",
    "UsesHits",
    "UsesHitPercent",
    "UsesCriticalHits",
    "UsesCriticalHitPercent",
    "Inspects",
    "InspectsAfterElimination",
    "AmmoUsed",
    "Zombies",
    "ZombiesDamageDealt",
    "ZombiesEliminations"
}, {
    { 2, "Shoots a beam of energy that can bounce off walls" }
})
v493("Spray", {
    "Playtime",
    "PlaytimeUnequipped",
    "RoundsPlayed",
    "RoundsWon",
    "RoundsLost",
    "RoundsWinPercent",
    "RankedRoundsPlayed",
    "RankedRoundsWon",
    "RankedRoundsLost",
    "RankedRoundsWinPercent",
    "DamageDealt",
    "DamageDealtSliding",
    "DamageDealtCrouching",
    "DamageDealtAirborne",
    "DamageDealtBlinded",
    "DamageDealtDead",
    "Eliminations",
    "EliminationsSliding",
    "EliminationsCrouching",
    "EliminationsAirborne",
    "EliminationsBlinded",
    "EliminationsDead",
    "Deaths",
    "DeathsRatio",
    "Assists",
    "AssistsDead",
    "Uses",
    "UsesHits",
    "UsesHitPercent",
    "UsesCriticalHits",
    "UsesCriticalHitPercent",
    "Inspects",
    "InspectsAfterElimination",
    "AmmoUsed",
    "Reloads",
    "Zombies",
    "ZombiesDamageDealt",
    "ZombiesEliminations"
}, {
    { 2, "This five-round burst pistol might be illegal" },
    { 3, "Loaded with illegally-modified armor-piercing-rounds that break through shields & deflects" }
})
v493("Crossbow", {
    "Playtime",
    "PlaytimeUnequipped",
    "RoundsPlayed",
    "RoundsWon",
    "RoundsLost",
    "RoundsWinPercent",
    "RankedRoundsPlayed",
    "RankedRoundsWon",
    "RankedRoundsLost",
    "RankedRoundsWinPercent",
    "DamageDealt",
    "DamageDealtSliding",
    "DamageDealtCrouching",
    "DamageDealtAirborne",
    "DamageDealtBlinded",
    "DamageDealtDead",
    "Eliminations",
    "EliminationsSliding",
    "EliminationsCrouching",
    "EliminationsAirborne",
    "EliminationsBlinded",
    "EliminationsDead",
    "Deaths",
    "DeathsRatio",
    "Assists",
    "AssistsDead",
    "Uses",
    "UsesHits",
    "UsesHitPercent",
    "UsesCriticalHits",
    "UsesCriticalHitPercent",
    "Inspects",
    "InspectsAfterElimination",
    "AmmoUsed",
    "Reloads",
    "Zombies",
    "ZombiesDamageDealt",
    "ZombiesEliminations"
}, {
    { 1, "An agile, long-ranged weapon" }
})
v493("Gunblade", {
    "Playtime",
    "PlaytimeUnequipped",
    "RoundsPlayed",
    "RoundsWon",
    "RoundsLost",
    "RoundsWinPercent",
    "RankedRoundsPlayed",
    "RankedRoundsWon",
    "RankedRoundsLost",
    "RankedRoundsWinPercent",
    "DamageDealt",
    "DamageDealtSliding",
    "DamageDealtCrouching",
    "DamageDealtAirborne",
    "DamageDealtBlinded",
    "DamageDealtDead",
    "DamageDealtGunMode",
    "DamageDealtBladeMode",
    "Eliminations",
    "EliminationsSliding",
    "EliminationsCrouching",
    "EliminationsAirborne",
    "EliminationsBlinded",
    "EliminationsDead",
    "EliminationsGunMode",
    "EliminationsBladeMode",
    "Deaths",
    "DeathsRatio",
    "Assists",
    "AssistsDead",
    "Uses",
    "UsesHits",
    "UsesHitPercent",
    "UsesCriticalHits",
    "UsesCriticalHitPercent",
    "Inspects",
    "InspectsAfterElimination",
    "AmmoUsed",
    "Dashes",
    "Zombies",
    "ZombiesDamageDealt",
    "ZombiesEliminations"
}, {
    { 2, "Shoot an enemy to switch to Blade Mode" },
    { 2, "Slash an enemy to switch to Gun Mode" },
    { 1, "Aim while in Gun Mode" },
    { 1, "Dash while in Blade Mode" }
})
v493("Jump Pad", {
    "Playtime",
    "PlaytimeUnequipped",
    "RoundsPlayed",
    "RoundsWon",
    "RoundsLost",
    "RoundsWinPercent",
    "RankedRoundsPlayed",
    "RankedRoundsWon",
    "RankedRoundsLost",
    "RankedRoundsWinPercent",
    "Deaths",
    "Uses",
    "UsesQuick",
    "Inspects",
    "InspectsAfterElimination",
    "Bounces",
    "BouncesSelf",
    "BouncesTeammates",
    "BouncesEnemies"
}, {
    { 2, "Place down a jump pad for all players to use" }
})
v493("Glass Cannon", {
    "Playtime",
    "PlaytimeUnequipped",
    "RoundsPlayed",
    "RoundsWon",
    "RoundsLost",
    "RoundsWinPercent",
    "RankedRoundsPlayed",
    "RankedRoundsWon",
    "RankedRoundsLost",
    "RankedRoundsWinPercent",
    "DamageDealt",
    "DamageDealtSliding",
    "DamageDealtCrouching",
    "DamageDealtAirborne",
    "DamageDealtBlinded",
    "DamageDealtDead",
    "Eliminations",
    "EliminationsSliding",
    "EliminationsCrouching",
    "EliminationsAirborne",
    "EliminationsBlinded",
    "EliminationsDead",
    "Deaths",
    "DeathsRatio",
    "Assists",
    "AssistsDead",
    "Uses",
    "UsesHits",
    "UsesHitPercent",
    "UsesCriticalHits",
    "UsesCriticalHitPercent",
    "Inspects",
    "InspectsAfterElimination",
    "AmmoUsed",
    "Zombies",
    "ZombiesDamageDealt",
    "ZombiesEliminations"
}, {
    { 2, "The weakest yet strongest weapon" }
})
v493("Glast Shard", {
    "Playtime",
    "PlaytimeUnequipped",
    "RoundsPlayed",
    "RoundsWon",
    "RoundsLost",
    "RoundsWinPercent",
    "RankedRoundsPlayed",
    "RankedRoundsWon",
    "RankedRoundsLost",
    "RankedRoundsWinPercent",
    "DamageDealt",
    "DamageDealtSliding",
    "DamageDealtCrouching",
    "DamageDealtAirborne",
    "DamageDealtBlinded",
    "DamageDealtDead",
    "Eliminations",
    "EliminationsSliding",
    "EliminationsCrouching",
    "EliminationsAirborne",
    "EliminationsBlinded",
    "EliminationsDead",
    "Deaths",
    "DeathsRatio",
    "Assists",
    "AssistsDead",
    "Uses",
    "UsesQuick",
    "UsesHits",
    "UsesHitPercent",
    "UsesCriticalHits",
    "UsesCriticalHitPercent",
    "Inspects",
    "InspectsAfterElimination",
    "Zombies",
    "ZombiesDamageDealt",
    "ZombiesEliminations"
}, {
    { 2, "Literally a piece of glass" }
})
v493("RNG Dice", {
    "Playtime",
    "PlaytimeUnequipped",
    "RoundsPlayed",
    "RoundsWon",
    "RoundsLost",
    "RoundsWinPercent",
    "RankedRoundsPlayed",
    "RankedRoundsWon",
    "RankedRoundsLost",
    "RankedRoundsWinPercent",
    "Deaths",
    "Uses",
    "UsesQuick",
    "Inspects",
    "InspectsAfterElimination"
}, {
    { 2, "Is today your lucky day?" }
})
v493("Distortion", {
    "Playtime",
    "PlaytimeUnequipped",
    "RoundsPlayed",
    "RoundsWon",
    "RoundsLost",
    "RoundsWinPercent",
    "RankedRoundsPlayed",
    "RankedRoundsWon",
    "RankedRoundsLost",
    "RankedRoundsWinPercent",
    "DamageDealt",
    "DamageDealtSliding",
    "DamageDealtCrouching",
    "DamageDealtAirborne",
    "DamageDealtBlinded",
    "DamageDealtDead",
    "Eliminations",
    "EliminationsSliding",
    "EliminationsCrouching",
    "EliminationsAirborne",
    "EliminationsBlinded",
    "EliminationsDead",
    "Deaths",
    "DeathsRatio",
    "Assists",
    "AssistsDead",
    "Uses",
    "UsesHits",
    "UsesHitPercent",
    "Inspects",
    "InspectsAfterElimination",
    "VortexesSpawned",
    "Zombies",
    "ZombiesDamageDealt",
    "ZombiesEliminations"
}, {
    { 2, "Trap players inside a gravitational vortex" }
})
v493("Warper", {
    "Playtime",
    "PlaytimeUnequipped",
    "RoundsPlayed",
    "RoundsWon",
    "RoundsLost",
    "RoundsWinPercent",
    "RankedRoundsPlayed",
    "RankedRoundsWon",
    "RankedRoundsLost",
    "RankedRoundsWinPercent",
    "Deaths",
    "Uses",
    "Inspects",
    "InspectsAfterElimination",
    "PortalsSpawned"
}, {
    { 2, "Spawn two portals and instantly warp from one place to another" }
})
v493("Warpstone", {
    "Playtime",
    "PlaytimeUnequipped",
    "RoundsPlayed",
    "RoundsWon",
    "RoundsLost",
    "RoundsWinPercent",
    "RankedRoundsPlayed",
    "RankedRoundsWon",
    "RankedRoundsLost",
    "RankedRoundsWinPercent",
    "DamageDealt",
    "DamageDealtSliding",
    "DamageDealtCrouching",
    "DamageDealtAirborne",
    "DamageDealtBlinded",
    "DamageDealtDead",
    "Eliminations",
    "EliminationsSliding",
    "EliminationsCrouching",
    "EliminationsAirborne",
    "EliminationsBlinded",
    "EliminationsDead",
    "Deaths",
    "DeathsRatio",
    "Assists",
    "AssistsDead",
    "Uses",
    "UsesQuick",
    "UsesHits",
    "UsesHitPercent",
    "UsesCriticalHits",
    "UsesCriticalHitPercent",
    "Inspects",
    "InspectsAfterElimination",
    "Warps",
    "Zombies",
    "ZombiesDamageDealt",
    "ZombiesEliminations"
}, {
    { 2, "Throw this odd stone to instantly warp away from danger" }
})
v493("Maul", {
    "Playtime",
    "PlaytimeUnequipped",
    "RoundsPlayed",
    "RoundsWon",
    "RoundsLost",
    "RoundsWinPercent",
    "RankedRoundsPlayed",
    "RankedRoundsWon",
    "RankedRoundsLost",
    "RankedRoundsWinPercent",
    "DamageDealt",
    "DamageDealtSliding",
    "DamageDealtCrouching",
    "DamageDealtAirborne",
    "DamageDealtBlinded",
    "DamageDealtDead",
    "DamageDealtDashing",
    "Eliminations",
    "EliminationsSliding",
    "EliminationsCrouching",
    "EliminationsAirborne",
    "EliminationsBlinded",
    "EliminationsDead",
    "EliminationsDashing",
    "Deaths",
    "DeathsRatio",
    "Assists",
    "AssistsDead",
    "Uses",
    "UsesQuick",
    "UsesHits",
    "UsesHitPercent",
    "Inspects",
    "InspectsAfterElimination",
    "Dashes",
    "Zombies",
    "ZombiesDamageDealt",
    "ZombiesEliminations"
}, {
    { 2, "A slow, powerful weapon that stuns enemies" },
    { 2, "Charge up and release your hammer to send enemies & teammates flying" }
})
v493("Permafrost", {
    "Playtime",
    "PlaytimeUnequipped",
    "RoundsPlayed",
    "RoundsWon",
    "RoundsLost",
    "RoundsWinPercent",
    "RankedRoundsPlayed",
    "RankedRoundsWon",
    "RankedRoundsLost",
    "RankedRoundsWinPercent",
    "DamageDealt",
    "DamageDealtSliding",
    "DamageDealtCrouching",
    "DamageDealtAirborne",
    "DamageDealtBlinded",
    "DamageDealtDead",
    "Eliminations",
    "EliminationsSliding",
    "EliminationsCrouching",
    "EliminationsAirborne",
    "EliminationsBlinded",
    "EliminationsDead",
    "Deaths",
    "DeathsRatio",
    "Assists",
    "AssistsDead",
    "Uses",
    "UsesHits",
    "UsesHitPercent",
    "UsesCriticalHits",
    "UsesCriticalHitPercent",
    "Inspects",
    "InspectsAfterElimination",
    "AmmoUsed",
    "Reloads",
    "Freezes",
    "FreezesSelf",
    "FreezesEnemies",
    "Zombies",
    "ZombiesDamageDealt",
    "ZombiesEliminations"
}, {
    { 2, "Slow your enemies down with these chilled bullets" },
    { 2, "Throw whatever\'s left of your magazine to freeze your enemies" }
})
local function v501(p494, p495)
    local v496 = {
        "Playtime",
        "RoundsPlayed",
        "RoundsWon",
        "RoundsLost",
        "RoundsWinPercent",
        "RankedRoundsPlayed",
        "RankedRoundsWon",
        "RankedRoundsLost",
        "RankedRoundsWinPercent",
        "DamageDealt",
        "DamageDealtSliding",
        "DamageDealtCrouching",
        "DamageDealtAirborne",
        "DamageDealtBlinded",
        "DamageDealtDead",
        "Eliminations",
        "EliminationsSliding",
        "EliminationsCrouching",
        "EliminationsAirborne",
        "EliminationsBlinded",
        "EliminationsDead",
        "Deaths",
        "DeathsRatio",
        "Assists",
        "AssistsDead"
    }
    for _, v497 in pairs(p495 or {}) do
        table.insert(v496, v497)
    end
    local v498 = {}
    for _, v499 in pairs(v496) do
        local v500 = "Statistic" .. v499
        table.insert(v498, v500)
    end
    v_u_7.Maps[p494] = {
        ["DataNames"] = v498
    }
end
for v502, _ in pairs(v3.Maps) do
    v501(v502, v502 == "Zombie Tower" and {
        "Zombies",
        "ZombiesDamageDealt",
        "ZombiesEliminations",
        "ZombiesEliminations"
    } or nil)
end
(function()
    local v503 = {}
    for _, v504 in pairs(v_u_4:GetReleasedOwnableWeapons(v_u_2.WEAPON_EARLY_ACCESS_TIME_OFFSET)) do
        v503[v504] = true
    end
    v_u_7.CareerStatistics = v_u_7:GetCareerStatistics(v503)
end)()
for v505 in pairs(v5.Items) do
    local v506 = v_u_7.Items[v505]
    assert(v506, v505)
end
return v_u_7