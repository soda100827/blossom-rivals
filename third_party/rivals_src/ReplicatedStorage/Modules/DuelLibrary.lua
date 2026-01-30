local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = require(v1.Modules.CONSTANTS)
local v3 = require(v1.Modules.SeasonLibrary)
require(v1.Modules.EventLibrary)
local v_u_4 = require(v1.Modules.ServerOsTime)
local v_u_5 = require(v1.Modules.Utility)
local v_u_6 = {
    Color3.fromRGB(255, 50, 50),
    Color3.fromRGB(255, 150, 0),
    Color3.fromRGB(255, 215, 0),
    Color3.fromRGB(100, 255, 50),
    Color3.fromRGB(0, 150, 255),
    Color3.fromRGB(161, 53, 255),
    Color3.fromRGB(255, 140, 244)
}
local v_u_35 = {
    ["MAX_TEAMS"] = 0,
    ["EMPTY_TEAM_COLOR"] = Color3.fromRGB(127, 127, 127),
    ["APRIL_FOOLS_QUEUES"] = { "ltm_easyexploits_3v3" },
    ["NEW_MAP_RELEASE_DURATION"] = 1209600,
    ["Teams"] = {},
    ["TeamsByID"] = {},
    ["MapDifficulties"] = {},
    ["Maps"] = {},
    ["MapOrder"] = {},
    ["HiddenMapOrder"] = {},
    ["PlaySourceTypes"] = {},
    ["PlaySources"] = {},
    ["PlaySourceOrder"] = {},
    ["MatchmakingQueues"] = {},
    ["MatchmakingQueueOrder"] = {},
    ["ArcadeModes"] = {},
    ["ArcadeModeOrder"] = {},
    ["ArcadeModeByPlaceID"] = {},
    ["_assigned_color_count"] = 0,
    ["GetTeamColor"] = function(p7, p8, p9)
        return p8 and p7.TeamsByID[p8] and p7.TeamsByID[p8].Color or (p9 or p7.EMPTY_TEAM_COLOR)
    end,
    ["GetMaps"] = function(p10, p11, p12, p13, p14)
        local v15 = p10.PlaySources[p13]
        local v16
        if v15 then
            v16 = v15.MapPool
        else
            v16 = v15
        end
        if p14 then
            local v17
            if v15 then
                v17 = v15.IsRigidMapPool
            else
                v17 = v15
            end
            p14 = not v17
        end
        if not p14 and v16 then
            return v_u_5:CloneTable(v16)
        end
        local v18 = {}
        for v19, v20 in pairs(p10.Maps) do
            local v21
            if p14 then
                v21 = p14
            elseif v20.MinimumPlayersRequired <= p11 then
                v21 = not v20.DontAutomaticallyAddToMapPools
            else
                v21 = false
            end
            if v21 and (p12 <= v20.MaximumTeamsSupported and ((not v15 or (v15.Type ~= "ArcadeMode" and true or v20.SupportsArcadeMode)) and not v20.IsHidden)) then
                table.insert(v18, v19)
            end
        end
        for _, v22 in pairs(v16 or {}) do
            if not table.find(v18, v22) then
                table.insert(v18, v22)
            end
        end
        return v18
    end,
    ["GetFirstQueueNameByDuelLogic"] = function(p23, p24)
        for _, v25 in pairs(p23.PlaySourceOrder) do
            if p23.PlaySources[v25].DuelLogic == p24 then
                return v25
            end
        end
    end,
    ["SortMaps"] = function(p26, p27, p28)
        local v29 = v_u_4:Get() < p26.Maps[p27].ReleaseTime + p26.NEW_MAP_RELEASE_DURATION
        local v30 = v_u_4:Get() < p26.Maps[p27].ReleaseTime + p26.NEW_MAP_RELEASE_DURATION
        local v31 = not v29 and -1 or p26.Maps[p27].ReleaseTime
        local v32 = not v30 and -1 or p26.Maps[p28].ReleaseTime
        if v31 == v32 then
            local v33 = p26.MapDifficulties[p26.Maps[p27].Difficulty].Value
            local v34 = p26.MapDifficulties[p26.Maps[p28].Difficulty].Value
            if v33 == v34 then
                return v_u_5:StringLessThan(p27, p28)
            else
                return v33 < v34
            end
        else
            return v32 < v31
        end
    end
}
local function v44(p36, p37, p38, p39, p40, p41)
    local v42 = {
        ["TeamIndex"] = p36,
        ["TeamID"] = utf8.char(p36),
        ["TeamName"] = p37,
        ["Logo"] = p38 or "",
        ["Color"] = p39,
        ["PadColor"] = p40,
        ["PadColor2"] = p41
    }
    v_u_35.Teams[v42.TeamIndex] = v42
    v_u_35.TeamsByID[v42.TeamID] = v42
    local v43 = v_u_35
    v43.MAX_TEAMS = v43.MAX_TEAMS + 1
end
v44(1, "Sensei & Co.", "rbxassetid://18226913133", Color3.fromRGB(255, 215, 0), Color3.fromRGB(163, 135, 51), Color3.fromRGB(194, 161, 61))
v44(2, "Nosniy Inc.", "rbxassetid://114213660098262", Color3.fromRGB(116, 61, 255), Color3.fromRGB(125, 74, 162), Color3.fromRGB(180, 115, 255))
v44(3, "Neko Labs", "rbxassetid://126657764282293", Color3.fromRGB(0, 150, 255), Color3.fromRGB(74, 112, 161), Color3.fromRGB(0, 115, 191))
local v45 = {
    ["Value"] = 0,
    ["Color"] = Color3.fromRGB(60, 60, 60)
}
v_u_35.MapDifficulties.None = v45
local v46 = {
    ["Value"] = 1,
    ["Color"] = Color3.fromRGB(100, 255, 50)
}
v_u_35.MapDifficulties.Easy = v46
local v47 = {
    ["Value"] = 2,
    ["Color"] = Color3.fromRGB(255, 215, 0)
}
v_u_35.MapDifficulties.Medium = v47
local v48 = {
    ["Value"] = 3,
    ["Color"] = Color3.fromRGB(255, 50, 50)
}
v_u_35.MapDifficulties.Hard = v48
local v49 = {
    ["Value"] = 4,
    ["Color"] = Color3.fromRGB(255, 255, 255)
}
v_u_35.MapDifficulties.Secret = v49
local function v65(p50, p51, p52, p53, p54, _, p55, p56, p57, p58, p59, p60, p61)
    local v62 = {
        ["IsHidden"] = p50,
        ["ReleaseTime"] = p51 or 0,
        ["Image"] = p53,
        ["Description"] = p61,
        ["Difficulty"] = p54,
        ["MinimumPlayersRequired"] = 1,
        ["MaximumTeamsSupported"] = p55,
        ["ShuffleSpawnsUniversally"] = p56,
        ["DontAutomaticallyAddToMapPools"] = p57,
        ["SupportsArcadeMode"] = p58,
        ["Creators"] = p59 or {},
        ["Contributors"] = p60 or {},
        ["PlaySources"] = {}
    }
    v_u_35.Maps[p52] = v62
    local v63 = v_u_35.HiddenMapOrder
    table.insert(v63, p52)
    if not v62.IsHidden or v_u_2.IS_TESTING_SERVER then
        local v64 = v_u_35.MapOrder
        table.insert(v64, p52)
    end
end
v65(nil, 1766548800, "Village", "rbxassetid://78458667507109", "Easy", 1, 2, nil, nil, nil, { "GreatGuyBoom" }, nil)
v65(nil, 1766548800, "Iceberg", "rbxassetid://110713820813038", "Medium", 1, 2, nil, nil, nil, { "Nosniy" }, nil)
v65(nil, nil, "Backrooms", "rbxassetid://78425568447137", "Easy", 1, 2, nil, nil, nil, { "Nosniy" }, nil)
v65(nil, nil, "Arena", "rbxassetid://108088064658436", "Easy", 1, 2, nil, nil, nil, { "Nosniy" }, nil)
v65(nil, nil, "Dimension", "rbxassetid://78851598956506", "Hard", 1, 2, nil, nil, nil, { "GreatGuyBoom" }, nil)
v65(nil, nil, "Bridge", "rbxassetid://110835255645526", "Easy", 1, 2, nil, nil, nil, { "GreatGuyBoom" }, nil)
v65(nil, nil, "Graveyard", "rbxassetid://129215409539945", "Medium", 1, 2, nil, nil, nil, { "GreatGuyBoom" }, nil)
v65(nil, nil, "Playground", "rbxassetid://133164748672681", "Easy", 1, 2, nil, nil, nil, { "Nosniy" }, nil)
v65(nil, nil, "Splash", "rbxassetid://73768743857232", "Medium", 1, 2, nil, nil, nil, { "Nosniy" }, nil)
v65(nil, nil, "Construction", "rbxassetid://92127692376940", "Hard", 1, 2, nil, nil, nil, { "Nosniy" }, nil)
v65(nil, nil, "Station", "rbxassetid://79991881563784", "Medium", 1, 2, nil, nil, true, { "Nosniy" }, { "GreatGuyBoom" })
v65(nil, nil, "Onyx", "rbxassetid://103965007372841", "Hard", 1, 3, nil, nil, nil, { "ShadowTrojan" }, nil)
v65(nil, nil, "Crossroads", "rbxassetid://137051465958454", "Medium", 1, 3, true, nil, nil, { "ShadowTrojan" }, nil)
v65(nil, nil, "Docks", "rbxassetid://118450909242865", "Medium", 1, 2, nil, nil, true, { "Nosniy" }, nil)
v65(nil, nil, "Big Arena", "rbxassetid://86783307295205", "Easy", 5, 3, nil, nil, true, { "Nosniy" }, nil)
v65(nil, nil, "Big Onyx", "rbxassetid://102960591046810", "Hard", 5, 3, nil, nil, nil, { "ShadowTrojan" }, nil)
v65(nil, nil, "Big Splash", "rbxassetid://129106276364955", "Medium", 5, 3, nil, nil, true, { "Nosniy" }, nil)
v65(nil, nil, "Big Backrooms", "rbxassetid://70941797176675", "Easy", 5, 3, nil, nil, true, { "Nosniy" }, nil)
v65(nil, nil, "Big Crossroads", "rbxassetid://73141606762048", "Medium", 5, 3, true, nil, true, { "ShadowTrojan" }, nil)
v65(nil, nil, "Big Graveyard", "rbxassetid://93673011647821", "Medium", 5, 3, true, nil, true, { "GreatGuyBoom" }, nil)
v65(nil, nil, "Shooting Range", "rbxassetid://80094199312443", "Easy", 9, 2, nil, nil, true, { "Nosniy" }, nil)
v65(nil, nil, "Battleground", "rbxassetid://102473488579867", "Easy", 1, 2, nil, nil, nil, { "GreatGuyBoom" }, { "ShadowTrojan" })
v65(nil, nil, "Legacy Backrooms", "rbxassetid://16780257607", "Secret", 1, 2, nil, true, nil, { "Nosniy" }, nil)
v65(nil, nil, "Legacy Big Splash", "rbxassetid://112550674762781", "Secret", 1, 2, nil, true, true, { "Nosniy" }, nil)
v65(nil, nil, "Legacy Splash", "rbxassetid://77611360382000", "Secret", 1, 2, nil, true, nil, { "Nosniy" }, nil)
v65(nil, nil, "Legacy Docks", "rbxassetid://17619338260", "Secret", 1, 2, nil, true, true, { "Nosniy" }, nil)
v65(nil, nil, "Legacy Onyx", "rbxassetid://73585862572119", "Secret", 1, 2, nil, true, nil, { "ShadowTrojan" }, nil)
v65(nil, nil, "Legacy Crossroads", "rbxassetid://75089226416040", "Secret", 1, 2, nil, true, nil, { "ShadowTrojan" }, nil)
v65(nil, nil, "Legacy Battleground", "rbxassetid://92092855485574", "Secret", 1, 2, nil, true, nil, { "ShadowTrojan" }, nil)
v65(nil, nil, "Baseplate", "rbxassetid://70533987337950", "Secret", 1, 3, nil, true, nil, nil, nil)
v65(true, nil, "Boss Arena", "rbxassetid://17528193900", "Secret", 1, 3, nil, true, nil, { "Nosniy" }, nil)
v65(true, nil, "Obby", "rbxassetid://84725536967912", "Secret", 1, 3, nil, true, nil, { "Nosniy" }, nil)
v65(true, nil, "Zombie Tower", "rbxassetid://129926572026365", "Secret", 1, 1, nil, true, nil, { "Nosniy" }, nil)
if v_u_2.IS_TESTING_SERVER then
    v65(nil, nil, "Factory", "rbxassetid://110072622389604", "None", 1, 3, nil, nil, nil, nil)
    v65(nil, nil, "Gate", "rbxassetid://110072622389604", "None", 1, 3, nil, nil, nil, nil)
    v65(nil, nil, "RENAME_ME", "rbxassetid://110072622389604", "None", 1, 3, nil, nil, nil, nil)
    v65(nil, nil, "Front", "rbxassetid://110072622389604", "None", 1, 3, nil, nil, nil, nil)
    v65(nil, nil, "Westown", "rbxassetid://110072622389604", "None", 1, 3, nil, nil, nil, nil)
    v65(nil, nil, "Chess", "rbxassetid://88015580366583", "None", 1, 3, nil, nil, nil, nil)
end
v_u_35.PlaySourceTypes.MatchmakingQueue = {}
v_u_35.PlaySourceTypes.ArcadeMode = {}
local function v_u_68(p66)
    if p66 then
        for v67 = #p66, 1, -1 do
            if not v_u_35.Maps[p66[v67]] then
                table.remove(p66, v67)
            end
        end
        return p66
    end
end
local function v_u_83(p69, p70, p71, p72, p73, p74, p75)
    local v76 = v_u_35.PlaySourceTypes[p69]
    assert(v76)
    local v77 = not v_u_35.PlaySourceTypes[p70]
    assert(v77)
    v_u_35._assigned_color_count = v_u_35._assigned_color_count % #v_u_6 + 1
    local v78 = {
        ["Type"] = p69,
        ["DisplayName"] = p72,
        ["DuelLogic"] = p71,
        ["DatabaseInfo"] = p73,
        ["IsRigidMapPool"] = p74,
        ["MapPool"] = v_u_68(p75),
        ["AssignedColor"] = v_u_6[v_u_35._assigned_color_count]
    }
    v_u_35.PlaySources[p70] = v78
    local v79 = v_u_35.PlaySourceOrder
    table.insert(v79, p70)
    if v78.Type ~= "MatchmakingQueue" or v78.DatabaseInfo.CanBeStartedFromClient then
        local v80
        if v78.Type == "MatchmakingQueue" then
            v80 = v_u_35:GetMaps(v78.DatabaseInfo.NumTeams * v78.DatabaseInfo.PlayersPerTeam, v78.DatabaseInfo.NumTeams, p70)
        elseif v78.Type == "ArcadeMode" then
            v80 = v_u_35:GetMaps(nil, nil, p70)
        else
            v80 = assert(false, "???")
        end
        for _, v81 in pairs(v80 or {}) do
            local v82 = v_u_35.Maps[v81].PlaySources
            table.insert(v82, p70)
        end
    end
end
local function v104(p84, p85, p86, p87, p88, p89, p_u_90, p91, p_u_92, p93, p94, p95, p96, p97, p98, p99)
    local v100 = p84 and p84 < 0 and (1 / 0) or p84
    local v102 = {
        ["TerminalsReleaseTime"] = v_u_2.IS_TESTING_SERVER and (not v100 or v100 < (1 / 0)) and 0 or (v100 or 0),
        ["NumTeams"] = p87,
        ["PlayersPerTeam"] = p88,
        ["CanBeStartedFromClient"] = p89,
        ["AreStreaksDisabled"] = function()
            local v101 = not p_u_90 and v_u_5:IsAprilFools()
            if v101 then
                v101 = not p_u_92
            end
            return v101
        end,
        ["StatisticsDisabled"] = p91,
        ["IsSafeFromAprilFools"] = p_u_92,
        ["DisplayName"] = p93 or "???",
        ["TitleName"] = p94,
        ["Image"] = p95 or "rbxassetid://18523763487",
        ["Thumbnail"] = p96 or "rbxassetid://117875704523935",
        ["Description"] = p97 or ""
    }
    v_u_35.MatchmakingQueues[p85] = v102
    local v103 = v_u_35.MatchmakingQueueOrder
    table.insert(v103, p85)
    v_u_83("MatchmakingQueue", p85, p86, p93, v102, p98, p99)
end
v104(-1, "2v2_beginner", nil, 2, 1, true, nil, nil, nil, "Beginner 2v2", "Beginner", nil, "rbxassetid://110648887575668", nil, nil, { "Arena", "Battleground" })
v104(nil, "1v1", nil, 2, 1, true, nil, nil, nil, "1v1", nil, "rbxassetid://18525954682", "rbxassetid://110648887575668", nil, nil, {
    "Arena",
    "Backrooms",
    "Crossroads",
    "Docks",
    "Splash",
    "Station",
    "Construction",
    "Onyx",
    "Bridge",
    "Playground",
    "Graveyard",
    "Dimension",
    "Village"
})
v104(nil, "2v2", nil, 2, 2, true, nil, nil, nil, "2v2", nil, "rbxassetid://18525954682", "rbxassetid://75765063500610", nil, nil, {
    "Arena",
    "Backrooms",
    "Crossroads",
    "Docks",
    "Splash",
    "Station",
    "Construction",
    "Onyx",
    "Bridge",
    "Playground",
    "Graveyard",
    "Battleground",
    "Dimension",
    "Village"
})
v104(nil, "3v3", nil, 2, 3, true, nil, nil, nil, "3v3", nil, "rbxassetid://18525954682", "rbxassetid://115188828715635", nil, nil, {
    "Big Arena",
    "Backrooms",
    "Crossroads",
    "Big Crossroads",
    "Docks",
    "Splash",
    "Station",
    "Construction",
    "Onyx",
    "Bridge",
    "Playground",
    "Graveyard",
    "Battleground",
    "Village",
    "Iceberg"
})
v104(nil, "4v4", nil, 2, 4, true, nil, nil, nil, "4v4", nil, "rbxassetid://18525954682", "rbxassetid://78144981625266", nil, nil, {
    "Big Arena",
    "Big Backrooms",
    "Big Crossroads",
    "Docks",
    "Big Onyx",
    "Big Splash",
    "Station",
    "Big Graveyard",
    "Battleground",
    "Iceberg"
})
v104(nil, "5v5", nil, 2, 5, true, nil, nil, nil, "5v5", nil, "rbxassetid://18525954682", "rbxassetid://100769223566900", nil, nil, {
    "Big Arena",
    "Big Backrooms",
    "Big Crossroads",
    "Docks",
    "Big Onyx",
    "Big Splash",
    "Station",
    "Big Graveyard",
    "Shooting Range",
    "Iceberg"
})
v104(nil, "ranked_1v1", "Ranked", 2, 1, true, true, nil, true, "Ranked 1v1", "Ranked", "rbxassetid://117835427046796", v3.CurrentSeason.ThumbnailRanked1v1, nil, nil, {
    "Arena",
    "Crossroads",
    "Docks",
    "Splash",
    "Station",
    "Construction",
    "Onyx",
    "Bridge",
    "Playground",
    "Dimension",
    "Village"
})
v104(nil, "ranked_2v2", "Ranked", 2, 2, true, true, nil, true, "Ranked 2v2", "Ranked", "rbxassetid://117835427046796", v3.CurrentSeason.ThumbnailRanked2v2, nil, nil, {
    "Arena",
    "Crossroads",
    "Docks",
    "Splash",
    "Station",
    "Construction",
    "Onyx",
    "Bridge",
    "Playground",
    "Battleground",
    "Dimension",
    "Village"
})
v104(nil, "ranked_3v3", "Ranked", 2, 3, true, true, nil, true, "Ranked 3v3", "Ranked", "rbxassetid://117835427046796", v3.CurrentSeason.ThumbnailRanked3v3, nil, nil, {
    "Crossroads",
    "Docks",
    "Splash",
    "Station",
    "Construction",
    "Onyx",
    "Bridge",
    "Playground",
    "Battleground",
    "Big Arena",
    "Iceberg"
})
v104(nil, "ltm_doubletrouble_1v1", "Double Trouble", 2, 1, nil, true, nil, nil, "Double Trouble 1v1", "Double Trouble", "rbxassetid://132073690319347", "rbxassetid://137424181577897", "Dual wield your favorite weapons!", nil, {
    "Arena",
    "Backrooms",
    "Crossroads",
    "Docks",
    "Splash",
    "Station",
    "Construction",
    "Onyx",
    "Bridge",
    "Playground",
    "Graveyard",
    "Dimension",
    "Village",
    "Iceberg"
})
v104(nil, "ltm_doubletrouble", "Double Trouble", 2, 2, nil, true, nil, nil, "Double Trouble 2v2", "Double Trouble", "rbxassetid://132073690319347", "rbxassetid://137424181577897", "Dual wield your favorite weapons!", nil, {
    "Arena",
    "Backrooms",
    "Crossroads",
    "Docks",
    "Splash",
    "Station",
    "Construction",
    "Onyx",
    "Bridge",
    "Playground",
    "Graveyard",
    "Battleground",
    "Dimension",
    "Village"
})
v104(nil, "ltm_doubletrouble_3v3", "Double Trouble", 2, 3, nil, true, nil, nil, "Double Trouble 3v3", "Double Trouble", "rbxassetid://132073690319347", "rbxassetid://137424181577897", "Dual wield your favorite weapons!", nil, {
    "Big Arena",
    "Backrooms",
    "Crossroads",
    "Big Crossroads",
    "Docks",
    "Splash",
    "Station",
    "Construction",
    "Onyx",
    "Bridge",
    "Playground",
    "Graveyard",
    "Battleground",
    "Village",
    "Iceberg"
})
v104(nil, "ltm_mirrormatchup_1v1", "Mirror Matchup", 2, 1, nil, true, nil, nil, "Mirror Matchup 1v1", "Mirror Matchup", "rbxassetid://132073690319347", "rbxassetid://105092869907244", "Everyone has to use the same random weapons!", nil, {
    "Arena",
    "Backrooms",
    "Crossroads",
    "Docks",
    "Splash",
    "Station",
    "Construction",
    "Onyx",
    "Bridge",
    "Playground",
    "Graveyard",
    "Dimension",
    "Village"
})
v104(nil, "ltm_mirrormatchup_2v2", "Mirror Matchup", 2, 2, nil, true, nil, nil, "Mirror Matchup 2v2", "Mirror Matchup", "rbxassetid://132073690319347", "rbxassetid://105092869907244", "Everyone has to use the same random weapons!", nil, {
    "Arena",
    "Backrooms",
    "Crossroads",
    "Docks",
    "Splash",
    "Station",
    "Construction",
    "Onyx",
    "Bridge",
    "Playground",
    "Graveyard",
    "Battleground",
    "Dimension",
    "Village"
})
v104(nil, "ltm_mirrormatchup_3v3", "Mirror Matchup", 2, 3, nil, true, nil, nil, "Mirror Matchup 3v3", "Mirror Matchup", "rbxassetid://132073690319347", "rbxassetid://105092869907244", "Everyone has to use the same random weapons!", nil, {
    "Big Arena",
    "Backrooms",
    "Crossroads",
    "Big Crossroads",
    "Docks",
    "Splash",
    "Station",
    "Construction",
    "Onyx",
    "Bridge",
    "Playground",
    "Graveyard",
    "Battleground",
    "Village",
    "Iceberg"
})
v104(nil, "ltm_easyexploits_2v2", "Easy Exploits", 2, 2, nil, true, nil, nil, "Easy Exploits 2v2", "Easy Exploits", "rbxassetid://132073690319347", "rbxassetid://131530572287607", "Fake cheating \226\128\148 actual cheaters get banned!", nil, {
    "Arena",
    "Backrooms",
    "Crossroads",
    "Docks",
    "Splash",
    "Station",
    "Construction",
    "Onyx",
    "Bridge",
    "Playground",
    "Graveyard",
    "Battleground",
    "Dimension",
    "Village"
})
v104(nil, "ltm_easyexploits_3v3", "Easy Exploits", 2, 3, nil, true, nil, nil, "Easy Exploits 3v3", "Easy Exploits", "rbxassetid://132073690319347", "rbxassetid://131530572287607", "Fake cheating \226\128\148 actual cheaters get banned!", nil, {
    "Big Arena",
    "Backrooms",
    "Crossroads",
    "Big Crossroads",
    "Docks",
    "Splash",
    "Station",
    "Construction",
    "Onyx",
    "Bridge",
    "Playground",
    "Graveyard",
    "Battleground",
    "Village",
    "Iceberg"
})
v104(nil, "ltm_limitlessloadout_1v1", "Limitless Loadout", 2, 1, nil, true, nil, nil, "Limitless Loadout 1v1", "Limitless Loadout", "rbxassetid://132073690319347", "rbxassetid://132019868240159", "Equip any weapon in any slot!", nil, {
    "Arena",
    "Backrooms",
    "Crossroads",
    "Docks",
    "Splash",
    "Station",
    "Construction",
    "Onyx",
    "Bridge",
    "Playground",
    "Graveyard",
    "Dimension",
    "Village"
})
v104(nil, "ltm_limitlessloadout_2v2", "Limitless Loadout", 2, 2, nil, true, nil, nil, "Limitless Loadout 2v2", "Limitless Loadout", "rbxassetid://132073690319347", "rbxassetid://132019868240159", "Equip any weapon in any slot!", nil, {
    "Arena",
    "Backrooms",
    "Crossroads",
    "Docks",
    "Splash",
    "Station",
    "Construction",
    "Onyx",
    "Bridge",
    "Playground",
    "Graveyard",
    "Battleground",
    "Dimension",
    "Village"
})
v104(nil, "ltm_limitlessloadout_3v3", "Limitless Loadout", 2, 3, nil, true, nil, nil, "Limitless Loadout 3v3", "Limitless Loadout", "rbxassetid://132073690319347", "rbxassetid://132019868240159", "Equip any weapon in any slot!", nil, {
    "Big Arena",
    "Backrooms",
    "Crossroads",
    "Big Crossroads",
    "Docks",
    "Splash",
    "Station",
    "Construction",
    "Onyx",
    "Bridge",
    "Playground",
    "Graveyard",
    "Battleground",
    "Village",
    "Iceberg"
})
v104(1749182400, "ltm_juggernaut_1v7", "Juggernaut", 2, 4, nil, true, nil, nil, "Juggernaut 1v7", "Juggernaut", "rbxassetid://132073690319347", "rbxassetid://111131964001261", "Will you be the raid boss?", nil, {
    "Big Arena",
    "Backrooms",
    "Bridge",
    "Graveyard",
    "Playground",
    "Construction",
    "Onyx",
    "Dimension",
    "Iceberg"
})
v104(1749787200, "ltm_swiftstandoff_1v1", "Swift Standoff", 2, 1, nil, true, nil, nil, "Swift Standoff 1v1", "Swift Standoff", "rbxassetid://132073690319347", "rbxassetid://97275583028575", "Slash & dash with just 1 bullet in the chamber!", nil, {
    "Arena",
    "Backrooms",
    "Crossroads",
    "Docks",
    "Splash",
    "Station",
    "Construction",
    "Onyx",
    "Bridge",
    "Playground",
    "Graveyard",
    "Dimension",
    "Village"
})
v104(1749787200, "ltm_swiftstandoff_2v2", "Swift Standoff", 2, 2, nil, true, nil, nil, "Swift Standoff 2v2", "Swift Standoff", "rbxassetid://132073690319347", "rbxassetid://97275583028575", "Slash & dash with just 1 bullet in the chamber!", nil, {
    "Arena",
    "Backrooms",
    "Crossroads",
    "Docks",
    "Splash",
    "Station",
    "Construction",
    "Onyx",
    "Bridge",
    "Playground",
    "Graveyard",
    "Battleground",
    "Dimension",
    "Village"
})
v104(1749787200, "ltm_swiftstandoff_3v3", "Swift Standoff", 2, 3, nil, true, nil, nil, "Swift Standoff 3v3", "Swift Standoff", "rbxassetid://132073690319347", "rbxassetid://97275583028575", "Slash & dash with just 1 bullet in the chamber!", nil, {
    "Big Arena",
    "Backrooms",
    "Crossroads",
    "Big Crossroads",
    "Docks",
    "Splash",
    "Station",
    "Construction",
    "Onyx",
    "Bridge",
    "Playground",
    "Graveyard",
    "Battleground",
    "Village",
    "Iceberg"
})
v104(1750392000, "ltm_defaultduel_1v1", "Default Duel", 2, 1, nil, nil, nil, nil, "Default Duel 1v1", "Default Duel", "rbxassetid://132073690319347", "rbxassetid://97514791083427", "A true test of skill \226\128\148 default weapons only!", nil, {
    "Arena",
    "Backrooms",
    "Crossroads",
    "Docks",
    "Splash",
    "Station",
    "Construction",
    "Onyx",
    "Bridge",
    "Playground",
    "Graveyard",
    "Dimension",
    "Village"
})
v104(1750392000, "ltm_defaultduel_2v2", "Default Duel", 2, 2, nil, nil, nil, nil, "Default Duel 2v2", "Default Duel", "rbxassetid://132073690319347", "rbxassetid://97514791083427", "A true test of skill \226\128\148 default weapons only!", nil, {
    "Arena",
    "Backrooms",
    "Crossroads",
    "Docks",
    "Splash",
    "Station",
    "Construction",
    "Onyx",
    "Bridge",
    "Playground",
    "Graveyard",
    "Battleground",
    "Dimension",
    "Village"
})
v104(1750392000, "ltm_bunnysniping_2v2", "Bunny Sniping", 2, 2, nil, true, nil, nil, "Bunny Sniping 2v2", "Bunny Sniping", "rbxassetid://132073690319347", "rbxassetid://111836104944441", "Snipe enemies in low gravity!", nil, {
    "Arena",
    "Crossroads",
    "Docks",
    "Splash",
    "Station",
    "Construction",
    "Onyx",
    "Bridge",
    "Playground",
    "Graveyard",
    "Dimension",
    "Village",
    "Iceberg"
})
v104(1750392000, "ltm_bunnysniping_3v3", "Bunny Sniping", 2, 3, nil, true, nil, nil, "Bunny Sniping 3v3", "Bunny Sniping", "rbxassetid://132073690319347", "rbxassetid://81786315504458", "Snipe enemies in low gravity!", nil, {
    "Arena",
    "Big Crossroads",
    "Docks",
    "Splash",
    "Station",
    "Construction",
    "Onyx",
    "Bridge",
    "Playground",
    "Graveyard",
    "Battleground",
    "Dimension",
    "Village",
    "Iceberg"
})
v104(1750996800, "ltm_tagteam_3v3", "Tag Team", 2, 3, nil, true, nil, nil, "Tag Team 3v3", "Tag Team", "rbxassetid://132073690319347", "rbxassetid://98049823970129", "Sweep the enemy team as your teammates watch you!", nil, {
    "Arena",
    "Backrooms",
    "Crossroads",
    "Docks",
    "Splash",
    "Station",
    "Construction",
    "Onyx",
    "Bridge",
    "Playground",
    "Graveyard",
    "Dimension",
    "Village",
    "Iceberg"
})
v104(1750996800, "ltm_tagteam_5v5", "Tag Team", 2, 5, nil, true, nil, nil, "Tag Team 5v5", "Tag Team", "rbxassetid://132073690319347", "rbxassetid://98049823970129", "Sweep the enemy team as your teammates watch you!", nil, {
    "Arena",
    "Backrooms",
    "Crossroads",
    "Docks",
    "Splash",
    "Station",
    "Construction",
    "Onyx",
    "Bridge",
    "Playground",
    "Graveyard",
    "Dimension",
    "Iceberg"
})
v104(1751601600, "ltm_chickengames_1v1", "Chicken Game", 2, 1, nil, true, nil, nil, "Chicken Game 1v1", "Chicken Game", "rbxassetid://132073690319347", "rbxassetid://130631351253585", "Red Light \240\159\154\166 Green Light", nil, {
    "Arena",
    "Backrooms",
    "Crossroads",
    "Docks",
    "Splash",
    "Station",
    "Construction",
    "Onyx",
    "Bridge",
    "Playground",
    "Graveyard",
    "Dimension",
    "Village"
})
v104(1751601600, "ltm_chickengames_2v2", "Chicken Game", 2, 2, nil, true, nil, nil, "Chicken Game 2v2", "Chicken Game", "rbxassetid://132073690319347", "rbxassetid://130631351253585", "Red Light \240\159\154\166 Green Light", nil, {
    "Arena",
    "Backrooms",
    "Crossroads",
    "Docks",
    "Splash",
    "Station",
    "Construction",
    "Onyx",
    "Bridge",
    "Playground",
    "Graveyard",
    "Battleground",
    "Dimension",
    "Village"
})
v104(1751601600, "ltm_chickengames_3v3", "Chicken Game", 2, 3, nil, true, nil, nil, "Chicken Game 3v3", "Chicken Game", "rbxassetid://132073690319347", "rbxassetid://130631351253585", "Red Light \240\159\154\166 Green Light", nil, {
    "Big Arena",
    "Backrooms",
    "Crossroads",
    "Big Crossroads",
    "Docks",
    "Splash",
    "Station",
    "Construction",
    "Onyx",
    "Bridge",
    "Playground",
    "Graveyard",
    "Battleground",
    "Village",
    "Iceberg"
})
v104(1751601600, "ltm_chickengames_4v4", "Chicken Game", 2, 4, nil, true, nil, nil, "Chicken Game 4v4", "Chicken Game", "rbxassetid://132073690319347", "rbxassetid://130631351253585", "Red Light \240\159\154\166 Green Light", nil, {
    "Big Arena",
    "Big Backrooms",
    "Big Crossroads",
    "Docks",
    "Big Onyx",
    "Big Splash",
    "Station",
    "Big Graveyard",
    "Battleground",
    "Iceberg"
})
v104(1752206400, "ltm_rivalsrng_1v1", "RIVALS RNG", 2, 1, nil, true, nil, nil, "RIVALS RNG 1v1", "RIVALS RNG", "rbxassetid://132073690319347", "rbxassetid://77265684173552", "Roll for a random weapon!", nil, {
    "Arena",
    "Backrooms",
    "Crossroads",
    "Docks",
    "Splash",
    "Station",
    "Construction",
    "Onyx",
    "Bridge",
    "Playground",
    "Graveyard",
    "Dimension",
    "Village"
})
v104(1752206400, "ltm_rivalsrng_2v2", "RIVALS RNG", 2, 2, nil, true, nil, nil, "RIVALS RNG 2v2", "RIVALS RNG", "rbxassetid://132073690319347", "rbxassetid://77265684173552", "Roll for a random weapon!", nil, {
    "Arena",
    "Backrooms",
    "Crossroads",
    "Docks",
    "Splash",
    "Station",
    "Construction",
    "Onyx",
    "Bridge",
    "Playground",
    "Graveyard",
    "Battleground",
    "Dimension",
    "Village"
})
v104(1752206400, "ltm_rivalsrng_3v3", "RIVALS RNG", 2, 3, nil, true, nil, nil, "RIVALS RNG 3v3", "RIVALS RNG", "rbxassetid://132073690319347", "rbxassetid://77265684173552", "Roll for a random weapon!", nil, {
    "Big Arena",
    "Backrooms",
    "Crossroads",
    "Big Crossroads",
    "Docks",
    "Splash",
    "Station",
    "Construction",
    "Onyx",
    "Bridge",
    "Playground",
    "Graveyard",
    "Battleground",
    "Village",
    "Iceberg"
})
v104(1752811200, "ltm_headhoncho_3v3", "Head Honcho", 2, 3, nil, true, nil, nil, "Head Honcho 3v3", "Head Honcho", "rbxassetid://132073690319347", "rbxassetid://129701707427431", "Assassinate the rival company\'s leader!", nil, {
    "Big Arena",
    "Backrooms",
    "Crossroads",
    "Big Crossroads",
    "Docks",
    "Splash",
    "Station",
    "Construction",
    "Onyx",
    "Bridge",
    "Playground",
    "Graveyard",
    "Battleground",
    "Village",
    "Iceberg"
})
v104(1752811200, "ltm_headhoncho_4v4", "Head Honcho", 2, 4, nil, true, nil, nil, "Head Honcho 4v4", "Head Honcho", "rbxassetid://132073690319347", "rbxassetid://129701707427431", "Assassinate the rival company\'s leader!", nil, {
    "Big Arena",
    "Big Backrooms",
    "Big Crossroads",
    "Docks",
    "Big Onyx",
    "Big Splash",
    "Station",
    "Big Graveyard",
    "Battleground",
    "Iceberg"
})
v104(1752811200, "ltm_headhoncho_5v5", "Head Honcho", 2, 5, nil, true, nil, nil, "Head Honcho 5v5", "Head Honcho", "rbxassetid://132073690319347", "rbxassetid://111031080770975", "Assassinate the rival company\'s leader!", nil, {
    "Big Arena",
    "Big Backrooms",
    "Big Crossroads",
    "Docks",
    "Big Onyx",
    "Big Splash",
    "Station",
    "Big Graveyard",
    "Shooting Range",
    "Iceberg"
})
v104(1753416000, "ltm_hardcoreparkour_1v1", "Hardcore Parkour", 2, 1, nil, true, nil, nil, "Hardcore Parkour 1v1", "Hardcore Parkour", "rbxassetid://132073690319347", "rbxassetid://104911032041491", "Obby but you\'re in RIVALS!", true, { "Obby" })
v104(1753416000, "ltm_hardcoreparkour_2v2", "Hardcore Parkour", 2, 2, nil, true, nil, nil, "Hardcore Parkour 2v2", "Hardcore Parkour", "rbxassetid://132073690319347", "rbxassetid://104911032041491", "Obby but you\'re in RIVALS!", true, { "Obby" })
v104(1753416000, "ltm_hardcoreparkour_5v5", "Hardcore Parkour", 2, 5, nil, true, nil, nil, "Hardcore Parkour 5v5", "Hardcore Parkour", "rbxassetid://132073690319347", "rbxassetid://104911032041491", "Obby but you\'re in RIVALS!", true, { "Obby" })
v104(nil, "1v1v1", nil, 3, 1, nil, true, nil, nil, "1v1v1", nil, "rbxassetid://18526010596", "rbxassetid://105588944981527", "Classic duels but with 3 teams!", nil, {
    "Big Arena",
    "Big Backrooms",
    "Big Crossroads",
    "Shooting Range",
    "Onyx",
    "Big Graveyard",
    "Station",
    "Docks",
    "Crossroads",
    "Big Onyx",
    "Iceberg"
})
v104(nil, "2v2v2", nil, 3, 2, nil, true, nil, nil, "2v2v2", nil, "rbxassetid://18526010596", "rbxassetid://105588944981527", "Classic duels but with 3 teams!", nil, {
    "Big Arena",
    "Big Backrooms",
    "Big Crossroads",
    "Shooting Range",
    "Oynx",
    "Big Graveyard",
    "Station",
    "Docks",
    "Crossroads",
    "Big Onyx",
    "Iceberg"
})
v104(nil, "3v3v3", nil, 3, 3, nil, true, nil, nil, "3v3v3", nil, "rbxassetid://18526010596", "rbxassetid://105588944981527", "Classic duels but with 3 teams!", nil, {
    "Big Arena",
    "Big Backrooms",
    "Big Crossroads",
    "Shooting Range",
    "Oynx",
    "Big Graveyard",
    "Station",
    "Docks",
    "Crossroads",
    "Big Onyx",
    "Iceberg"
})
v104(-1, "ltm_zombietower", "Zombie Tower", 1, 5, nil, true, true, nil, "Zombie Tower", "Zombie Tower", "rbxassetid://132073690319347", "rbxassetid://79328971751595", "Can you reach the top?", true, { "Zombie Tower" })
v104(-1, "ltm_zombietower_solo", "Zombie Tower", 1, 1, nil, true, true, nil, "Zombie Tower Solo", "Zombie Tower", "rbxassetid://132073690319347", "rbxassetid://72764838190885", "Can you reach the top.. by yourself?", true, { "Zombie Tower" })
v104(-1, "evt_senseibot", "Boss Battle", 1, 1, nil, true, true, true, "Sensei Bot", "Sensei Bot", "rbxassetid://132073690319347", "rbxassetid://110648887575668", nil, true, { "Boss Arena" })
v104(-1, "evt_nosniybot", "Boss Battle", 1, 1, nil, true, true, true, "Nosniy Bot", "Nosniy Bot", "rbxassetid://132073690319347", "rbxassetid://110648887575668", nil, true, { "Boss Arena" })
local function v116(p105, p106, p107, p108, p109, p110, p111)
    local v112 = {
        ["Name"] = p105,
        ["DisplayName"] = p107,
        ["Thumbnail"] = p108,
        ["Description"] = p109,
        ["PlaceID"] = p110
    }
    v_u_35.ArcadeModes[p105] = v112
    local v113 = v_u_35.ArcadeModeByPlaceID
    local v114 = v112.PlaceID
    v113[tostring(v114)] = v112
    local v115 = v_u_35.ArcadeModeOrder
    table.insert(v115, p105)
    v_u_83("ArcadeMode", p105, p106, p107, v112, true, p111)
end
v116("arc_gungame", "Gun Game", "Gun Game", "rbxassetid://126712308378143", "Race to the final weapon to win!", v_u_2.ARCADE_GUNGAME_PLACE_ID, {
    "Big Crossroads",
    "Shooting Range",
    "Station",
    "Big Arena",
    "Big Backrooms",
    "Big Graveyard",
    "Big Splash",
    "Docks",
    "Iceberg"
})
v116("arc_teamdeathmatch", "Deathmatch", "Team Deathmatch", "rbxassetid://117499628913182", "The team with the most points wins!", v_u_2.ARCADE_TEAMDEATHMATCH_PLACE_ID, {
    "Big Crossroads",
    "Shooting Range",
    "Station",
    "Big Arena",
    "Big Backrooms",
    "Big Graveyard",
    "Big Splash",
    "Docks",
    "Iceberg"
})
v116("arc_freeforall", "Deathmatch", "Free For All", "rbxassetid://86903206151694", "The player with the most points wins!", v_u_2.ARCADE_FREEFORALL_PLACE_ID, {
    "Big Crossroads",
    "Shooting Range",
    "Station",
    "Big Arena",
    "Big Backrooms",
    "Big Graveyard",
    "Big Splash",
    "Docks",
    "Iceberg"
})
return v_u_35