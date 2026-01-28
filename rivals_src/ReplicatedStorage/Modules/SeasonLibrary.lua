local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("ServerStorage")
local v_u_3 = game:GetService("Players")
local v_u_4 = require(v1.Modules.CONSTANTS)
local v_u_5 = require(v1.Modules.CosmeticLibrary)
local v_u_6 = require(v1.Modules.ServerOsTime)
local v7 = {
    { "ranked_1v1", "ranked" },
    { "ranked_2v2", "ranked" },
    { "ranked_3v3", "ranked" }
}
local v8 = {
    {
        1000,
        {
            ["Name"] = "Phoenix Rifle",
            ["Weapon"] = "Assault Rifle"
        }
    }
}
local v9 = {
    {
        50,
        {
            ["Name"] = "Mini Unstable Portal",
            ["Weapon"] = "IsUniversal"
        }
    },
    {
        100,
        {
            ["Name"] = "Glory",
            ["Quantity"] = 100
        }
    },
    {
        200,
        {
            ["Name"] = "Spiral",
            ["Weapon"] = "IsUniversal"
        }
    },
    {
        300,
        {
            ["Name"] = "Glory",
            ["Quantity"] = 150
        }
    },
    {
        500,
        {
            ["Name"] = "Warped Away",
            ["Weapon"] = "IsUniversal"
        }
    },
    {
        750,
        {
            ["Name"] = "Glory",
            ["Quantity"] = 250
        }
    },
    {
        1000,
        {
            ["Name"] = "Warp Handgun",
            ["Weapon"] = "Handgun"
        }
    }
}
local v10 = {
    {
        50,
        {
            ["Name"] = "Snowman",
            ["Weapon"] = "IsUniversal"
        }
    },
    {
        100,
        {
            ["Name"] = "Glory",
            ["Quantity"] = 100
        }
    },
    {
        200,
        {
            ["Name"] = "Tusky",
            ["Weapon"] = "IsUniversal"
        }
    },
    {
        300,
        {
            ["Name"] = "Glory",
            ["Quantity"] = 150
        }
    },
    {
        500,
        {
            ["Name"] = "Northern Light Show",
            ["Weapon"] = "IsUniversal"
        }
    },
    {
        750,
        {
            ["Name"] = "Glory",
            ["Quantity"] = 250
        }
    },
    {
        1000,
        {
            ["Name"] = "Frozen Grenade",
            ["Weapon"] = "Grenade"
        }
    }
}
local v_u_70 = {
    ["UNIVERSAL_ELO_NAME"] = "ranked",
    ["PASS_TRACK_IMAGES"] = { "rbxassetid://81577092220450", "rbxassetid://74965952714478" },
    ["SEASON_PASS_LEVELS_IN_SEASON_BUNDLE"] = 20,
    ["PASS_XP_PER_LEVEL_VISUAL"] = 10,
    ["Seasons"] = {},
    ["SeasonsByVersion"] = {},
    ["CurrentSeason"] = nil,
    ["RankProfiles"] = {},
    ["IsRankedQueue"] = function(p11, p12, p13)
        local v14 = p13 or p11.CurrentSeason.Name
        for _, v15 in pairs(p11.Seasons[v14].RankedQueues) do
            if v15[1] == p12 then
                return v15[2]
            end
        end
    end,
    ["GetCurrentSeasonWeek"] = function(_)
        local v16 = (v_u_6:Get() - v_u_70.CurrentSeason.StartTime) / 604800
        return math.ceil(v16)
    end,
    ["GetTimeUntilNextSeasonWeek"] = function(_)
        local v17 = (v_u_6:Get() - v_u_70.CurrentSeason.StartTime) / 604800
        return math.ceil(v17) * 7 * 24 * 60 * 60 + v_u_70.CurrentSeason.StartTime - v_u_6:Get()
    end,
    ["GetHighestELOLeaderboardRanking"] = function(_, p18, p19)
        local v20
        if v_u_4.IS_SERVER then
            v20 = require(v_u_2.Services.LeaderboardService)
        else
            v20 = require(v_u_3.LocalPlayer.PlayerScripts.Controllers.LeaderboardController)
        end
        if p19 then
            return v20:GetRankingByUserID("Highest ELO", p19)
        end
        if p18 then
            return v20:GetRankingByValue("Highest ELO", p18)
        end
    end,
    ["GetRank"] = function(p21, p22, p23, p24, p25)
        if not p22 then
            return "Unranked"
        end
        local v26 = p25 or p21.CurrentSeason.RankProfile.Name
        local v27 = p21.RankProfiles[v26]
        local v28 = v27 ~= nil
        assert(v28)
        local v29 = nil
        for v30, v31 in pairs(v27.RanksOrder) do
            local v32 = v27.Ranks[v31]
            if p22 < v32.RequiredELO and not v32.RequiredELOLeaderboardRanking then
                v29 = v30 - 1
                break
            end
        end
        if not v29 then
            local v33 = p24 or p21:GetHighestELOLeaderboardRanking(p22, p23)
            for v34 = #v27.RanksOrder, 1, -1 do
                local v35 = v27.RanksOrder[v34]
                local v36 = v27.Ranks[v35]
                if not v36.RequiredELOLeaderboardRanking or v36.RequiredELO <= p22 and (v33 or (1 / 0)) <= v36.RequiredELOLeaderboardRanking then
                    v29 = v34
                    break
                end
            end
        end
        local v37 = v27.RanksOrder
        local v38 = #v27.RanksOrder
        return v37[math.clamp(v29, 1, v38)]
    end,
    ["GetGloryPayout"] = function(p39, p40, p41)
        local v42 = p39.Seasons[p40]
        local v43 = 0
        local v44 = 0
        for _, v45 in pairs(p41.RankedPerformances or {}) do
            v43 = v43 + 1
            if v45.CurrentELO then
                local v46 = v42.GloryPayoutWinsInfluence
                local v47 = v45.DuelsWon / v42.GloryPayoutMaxWins
                local v48 = v46 * math.clamp(v47, 0, 1)
                local v49 = v42.GloryPayoutELOInfluence
                local v50 = v45.CurrentELO / v42.GloryPayoutMaxELO
                local v51 = v49 * math.clamp(v50, 0, 1)
                v44 = v44 + v42.MaxGloryPayout * (v51 + v48)
            end
        end
        if v43 <= 0 then
            return 0
        end
        local v52 = v44 / v43
        local v53 = math.floor(v52)
        local v54 = math.sign(v44)
        local v55 = math.max(v54, v53)
        local v56 = v42.MaxGloryPayout
        return math.clamp(v55, 0, v56)
    end,
    ["GetRewardSeasonPassPosition"] = function(_, p57)
        for v58 = 1, v_u_70.CurrentSeason.NumBattlePassTiers do
            for v59 = 1, v_u_70.CurrentSeason.NumBattlePassTracks do
                local v60 = v_u_70.CurrentSeason.BattlePassRewards[v58]
                if v60 then
                    v60 = v_u_70.CurrentSeason.BattlePassRewards[v58][v59]
                end
                if v60 and v60.Name == p57 then
                    return v58, v59
                end
            end
        end
    end,
    ["FormatSeasonRankCharm"] = function(p61, p62, p63, p64, p65)
        assert(p63)
        local v66 = p65 and ("#" .. p65 or "") or ""
        local v67 = v_u_70:GetRank(p64, nil, p65 or (1 / 0), p61.Seasons[p63].RankProfile.Name)
        for _, v68 in pairs(p62:GetDescendants()) do
            if v68:HasTag("CharmLeaderboardRank") then
                v68.Text = v66
            end
        end
        if p62:FindFirstChild("Extra") then
            for _, v69 in pairs(p62.Extra:GetChildren()) do
                if v69.Name ~= v67 then
                    task.defer(v69.Destroy, v69)
                end
            end
        end
    end
}
(function(p71, p72, p73, p74)
    v_u_70.RankProfiles[p71] = {
        ["Name"] = p71,
        ["NumPlacementDuels"] = p72,
        ["PlacementELOMin"] = p73,
        ["PlacementELOMax"] = p74,
        ["LowestRankELO"] = (1 / 0),
        ["HighestRankELO"] = (-1 / 0),
        ["Ranks"] = {},
        ["RanksOrder"] = {},
        ["Groups"] = {},
        ["GroupsOrder"] = {}
    }
end)("ranks_version1", 10, 100, 2500)
local function v82(p75, p76, p77, p78, p79)
    local v80 = {
        ["Name"] = p76,
        ["Color"] = p77,
        ["Image"] = p78,
        ["SecondaryColor"] = p79 or Color3.fromRGB(0, 0, 0),
        ["Ranks"] = {}
    }
    v_u_70.RankProfiles[p75].Groups[p76] = v80
    local v81 = v_u_70.RankProfiles[p75].GroupsOrder
    table.insert(v81, p76)
end
v82("ranks_version1", "Unranked", Color3.fromRGB(255, 255, 255), "rbxassetid://111599878354131")
v82("ranks_version1", "Bronze", Color3.fromRGB(184, 117, 69), "rbxassetid://73543520622815")
v82("ranks_version1", "Silver", Color3.fromRGB(200, 200, 200), "rbxassetid://107898816876115")
v82("ranks_version1", "Gold", Color3.fromRGB(255, 215, 0), "rbxassetid://90039594400813")
v82("ranks_version1", "Platinum", Color3.fromRGB(65, 255, 248), "rbxassetid://73345783863790")
v82("ranks_version1", "Diamond", Color3.fromRGB(50, 159, 255), "rbxassetid://112183171942172")
v82("ranks_version1", "Onyx", Color3.fromRGB(255, 114, 0), "rbxassetid://127982903682334")
v82("ranks_version1", "Nemesis", Color3.fromRGB(191, 0, 255), "rbxassetid://116941545385923")
v82("ranks_version1", "Archnemesis", Color3.fromRGB(0, 0, 0), "rbxassetid://133793956251748", Color3.fromRGB(31, 81, 78))
local function v98(p83, p84, p85, p86, p87, p88, p89)
    local v90 = v_u_70.RankProfiles[p83]
    local v91 = {
        ["RankGroupName"] = p84,
        ["DisplayName"] = p85,
        ["RequiredELO"] = p86,
        ["RequiredELOLeaderboardRanking"] = p89,
        ["Image"] = p87
    }
    v90.Ranks[p85] = v91
    local v92 = v90.RanksOrder
    table.insert(v92, p85)
    if not p88 then
        local v93 = v90.LowestRankELO
        local v94 = v91.RequiredELO
        v90.LowestRankELO = math.min(v93, v94)
        local v95 = v90.HighestRankELO
        local v96 = v91.RequiredELO
        v90.HighestRankELO = math.max(v95, v96)
    end
    if v91.RankGroupName then
        local v97 = v90.Groups[v91.RankGroupName].Ranks
        table.insert(v97, p85)
    end
end
local v99 = v_u_70.RankProfiles.ranks_version1
local v100 = {
    ["RankGroupName"] = "Unranked",
    ["DisplayName"] = "Unranked",
    ["RequiredELO"] = -1,
    ["RequiredELOLeaderboardRanking"] = nil,
    ["Image"] = "rbxassetid://111599878354131"
}
v99.Ranks.Unranked = v100
local v101 = v99.RanksOrder
table.insert(v101, "Unranked")
if v100.RankGroupName then
    local v102 = v99.Groups[v100.RankGroupName].Ranks
    table.insert(v102, "Unranked")
end
v98("ranks_version1", "Bronze", "Bronze 1", 0, "rbxassetid://106623367501544")
v98("ranks_version1", "Bronze", "Bronze 2", 200, "rbxassetid://131795064007344")
v98("ranks_version1", "Bronze", "Bronze 3", 400, "rbxassetid://73543520622815")
v98("ranks_version1", "Silver", "Silver 1", 600, "rbxassetid://80716950169934")
v98("ranks_version1", "Silver", "Silver 2", 800, "rbxassetid://136100661820261")
v98("ranks_version1", "Silver", "Silver 3", 1000, "rbxassetid://107898816876115")
v98("ranks_version1", "Gold", "Gold 1", 1200, "rbxassetid://134520747948636")
v98("ranks_version1", "Gold", "Gold 2", 1400, "rbxassetid://114166096331502")
v98("ranks_version1", "Gold", "Gold 3", 1600, "rbxassetid://90039594400813")
v98("ranks_version1", "Platinum", "Platinum 1", 1800, "rbxassetid://133903971285645")
v98("ranks_version1", "Platinum", "Platinum 2", 2000, "rbxassetid://82834564754747")
v98("ranks_version1", "Platinum", "Platinum 3", 2200, "rbxassetid://73345783863790")
v98("ranks_version1", "Diamond", "Diamond 1", 2400, "rbxassetid://113997689031026")
v98("ranks_version1", "Diamond", "Diamond 2", 2600, "rbxassetid://88059506918419")
v98("ranks_version1", "Diamond", "Diamond 3", 2800, "rbxassetid://112183171942172")
v98("ranks_version1", "Onyx", "Onyx 1", 3000, "rbxassetid://104871954739030")
v98("ranks_version1", "Onyx", "Onyx 2", 3200, "rbxassetid://109012386782238")
v98("ranks_version1", "Onyx", "Onyx 3", 3400, "rbxassetid://127982903682334")
local v103 = v_u_70.RankProfiles.ranks_version1
local v104 = {
    ["RankGroupName"] = "Nemesis",
    ["DisplayName"] = "Nemesis",
    ["RequiredELO"] = 3600,
    ["RequiredELOLeaderboardRanking"] = nil,
    ["Image"] = "rbxassetid://116941545385923"
}
v103.Ranks.Nemesis = v104
local v105 = v103.RanksOrder
table.insert(v105, "Nemesis")
if v104.RankGroupName then
    local v106 = v103.Groups[v104.RankGroupName].Ranks
    table.insert(v106, "Nemesis")
end
local v107 = v_u_70.RankProfiles.ranks_version1
local v108 = {
    ["RankGroupName"] = "Archnemesis",
    ["DisplayName"] = "Archnemesis",
    ["RequiredELO"] = 3600,
    ["RequiredELOLeaderboardRanking"] = 200,
    ["Image"] = "rbxassetid://133793956251748"
}
v107.Ranks.Archnemesis = v108
local v109 = v107.RanksOrder
table.insert(v109, "Archnemesis")
if v108.RankGroupName then
    local v110 = v107.Groups[v108.RankGroupName].Ranks
    table.insert(v110, "Archnemesis")
end
local function v118(p111, p112, p113, p114, p115)
    local v116 = {
        ["ResetCounter"] = p112,
        ["Name"] = p113,
        ["Version"] = p114
    }
    if v_u_6:Get() < p115 then
        p115 = p115 - 604800
    end
    v116.StartTime = p115
    v116.AccountAgeRequirement = nil
    v116.LevelRequirement = nil
    v116.MaximumPartyELODifference = nil
    v116.DailyELOShields = nil
    v116.ELOShieldMaxELOAllowed = nil
    v116.ELODecayThreshold = nil
    v116.ELODecayPerInactiveDay = nil
    v116.ELODecayInactivePeriodDays = nil
    v116.ParticipationPrizes = nil
    v116.ParticipationPointsPerWin = nil
    v116.ParticipationPointsPerLoss = nil
    v116.GloryPayoutMaxWins = nil
    v116.GloryPayoutWinsInfluence = nil
    v116.GloryPayoutMaxELO = nil
    v116.GloryPayoutELOInfluence = nil
    v116.MaxGloryPayout = nil
    v116.TopPlayerRewardSkinName = nil
    v116.TopPlayerLeaderboardRank = nil
    v116.ThumbnailRankedCoverPhoto = nil
    v116.ThumbnailRanked1v1 = nil
    v116.ThumbnailRanked2v2 = nil
    v116.ThumbnailRanked3v3 = nil
    v116.RankProfile = nil
    v116.RankedQueues = nil
    v116.BattlePassActive = false
    v116.BattlePassTasksPerWeek = nil
    v116.BattlePassTaskRequirements = nil
    v116.BattlePassRewards = nil
    v116.NumBattlePassTiers = nil
    v116.NumBattlePassTracks = nil
    v116.ContrabandBundleSkinName = nil
    v116.ContrabandBundleFinisherName = nil
    v116.ContrabandBundleWrapName = nil
    v116.ContrabandBundleCharmName = nil
    v116.ContrabandBundleEmoteName = nil
    v_u_70.Seasons[p113] = v116
    v_u_70.SeasonsByVersion[p114] = v116
    if p111 then
        local v117 = not v_u_70.CurrentSeason
        assert(v117)
        v_u_70.CurrentSeason = v116
    end
end
v118(false, 5, "Zero", 0, 1740718800)
v118(false, 0, "Warp", 1, 1758859200)
v118(true, 0, "Polar", 2, 1765515600)
local function v149(p119, p120, p121, p122, p123, p124, p125, p126, p127, p128, p129, p130, p131, p132, p133, p134, p135, p136, p137, p138, p139, p140, p141, p142, p143, p144)
    local v145 = v_u_70.Seasons[p119]
    for _, v146 in pairs(p133) do
        local v147 = v146[2].Name
        local v148 = v_u_5.Cosmetics[v147]
        if v148 and not v_u_5.Types[v148.Type].NotCosmetic then
            v_u_5:ExternallySetCosmeticDescription(v147, "Earned by playing Ranked Season " .. v145.Version)
        end
    end
    v145.AccountAgeRequirement = p122
    v145.LevelRequirement = p123
    v145.TasksCompletedRequirement = p124
    v145.MaximumPartyELODifference = p125
    v145.DailyELOShields = p126
    v145.ELOShieldMaxELOAllowed = p127
    v145.ELODecayThreshold = p128
    v145.ELODecayPerInactiveDay = p129
    v145.ELODecayInactivePeriodDays = p130
    v145.ParticipationPrizes = p133
    v145.ParticipationPointsPerWin = p131
    v145.ParticipationPointsPerLoss = p132
    v145.GloryPayoutMaxWins = p134
    v145.GloryPayoutWinsInfluence = p135
    v145.GloryPayoutMaxELO = p136
    v145.GloryPayoutELOInfluence = p137
    v145.MaxGloryPayout = p138
    v145.TopPlayerRewardSkinName = p139
    v145.TopPlayerLeaderboardRank = p140
    v145.ThumbnailRankedCoverPhoto = p141
    v145.ThumbnailRanked1v1 = p142
    v145.ThumbnailRanked2v2 = p143
    v145.ThumbnailRanked3v3 = p144
    v145.RankProfile = v_u_70.RankProfiles[p120]
    v145.RankedQueues = p121
end
v149("Zero", "ranks_version1", v7, 14, 30, 0, 800, 1, 1800, 3000, 100, 7, 5, 0, v8, 250, 0.5, 3600, 0.5, 2500, "Arch Katana", 200, "rbxassetid://103123155567436", "rbxassetid://103123155567436", "rbxassetid://94210614848859", "rbxassetid://136241323883086")
v149("Warp", "ranks_version1", v7, 14, 30, 0, 800, 1, 1800, 3000, 100, 7, 5, 0, v9, 250, 0.5, 3600, 0.5, 2500, "Arch Crossbow", 200, "rbxassetid://108294156233914", "rbxassetid://108294156233914", "rbxassetid://74079396411050", "rbxassetid://131383109536840")
v149("Polar", "ranks_version1", v7, 14, 50, 30, 800, 1, 1800, 3000, 100, 7, 5, 0, v10, 250, 0.5, 3600, 0.5, 2500, nil, 200, "rbxassetid://76786660109423", "rbxassetid://77500396480714", "rbxassetid://76786660109423", "rbxassetid://103544907023810")
local function v185(p150, p151, p152, p153, p154, p155, p156, p157, p158)
    local v159 = v_u_70.Seasons[p150]
    local v160 = require(script:WaitForChild("BattlePasses"):WaitForChild(p150))
    local v_u_161 = v160.JunkRewards
    local v162 = v160.RawRewards
    for _, v163 in pairs(v_u_161) do
        table.sort(v163, function(p164, p165)
            return p164.Chance < p165.Chance
        end)
    end
    local v_u_166 = 0
    local function v172(p167)
        v_u_166 = v_u_166 + 1
        local v168 = Random.new(v_u_166):NextNumber()
        local v169 = v_u_161[p167]
        local v170 = v169[#v169]
        for _, v171 in pairs(v169) do
            if v168 <= v171.Chance then
                v170 = v171
                break
            end
        end
        return table.clone(v170.RewardData)
    end
    local v173 = 0
    local v174 = 0
    for v175, v176 in pairs(v162) do
        v173 = math.max(v173, v175)
        for v177 in pairs(v176) do
            v174 = math.max(v174, v177)
        end
    end
    for v178 = 1, v173 do
        v162[v178] = v162[v178] or {}
        for v179 = 1, v174 do
            if v178 ~= 1 or v179 ~= 1 then
                v162[v178][v179] = v162[v178][v179] or v172(v179)
            end
        end
    end
    for _, v180 in pairs({
        p154,
        p155,
        p156,
        p157,
        p158
    }) do
        v_u_5:ExternallySetCosmeticDescription(v180, "Included in the Contraband Bundle from Season " .. v159.Version)
    end
    for v181 = 1, v173 do
        for v182 = 1, v174 do
            local v183 = v162[v181][v182]
            local v184
            if v183 then
                v184 = v_u_5.Cosmetics[v183.Name]
            else
                v184 = v183
            end
            if v184 and not (v184.Description or v184.DescriptionSpecific) then
                v_u_5:ExternallySetCosmeticDescription(v183.Name, "Earned from the Season Pass during Season " .. v159.Version)
            end
        end
    end
    v159.BattlePassActive = true
    v159.BattlePassTasksPerWeek = p151
    v159.BattlePassTaskRequirements = {
        ["RoundsWon"] = p152,
        ["Playtime"] = p153
    }
    v159.BattlePassRewards = v162
    v159.NumBattlePassTiers = v173
    v159.NumBattlePassTracks = v174
    v159.ContrabandBundleSkinName = p154
    v159.ContrabandBundleFinisherName = p155
    v159.ContrabandBundleWrapName = p156
    v159.ContrabandBundleCharmName = p157
    v159.ContrabandBundleEmoteName = p158
end
v185("Warp", 7, 25, 1200, "Electropunk Warper", "Spaghettified", "Encroached", "Warp Disc", "Portal Glitch")
v185("Polar", 7, 25, 1200, nil, "Giant Snowball", "Ice Queen", "Cryo Capsule", "It\'s Time")
return v_u_70