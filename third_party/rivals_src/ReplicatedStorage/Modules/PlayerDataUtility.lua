local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = require(v1.Modules.CONSTANTS)
local v_u_3 = require(v1.Modules.StatisticsLibrary)
local v_u_4 = require(v1.Modules.SeasonLibrary)
local v_u_5 = {}
v_u_5.__index = v_u_5
function v_u_5._new()
    local v6 = v_u_5
    local v7 = setmetatable({}, v6)
    v7:_Init()
    return v7
end
function v_u_5.IsNosniyGamesTeamMemberRaw(_, p8)
    if p8 then
        p8 = v_u_2.TEAM_MEMBER_RANK <= p8
    end
    return p8
end
function v_u_5.IsNosniyGamesTeamMember(p9, p10)
    return p9:IsNosniyGamesTeamMemberRaw(p10:Get("GroupRank"))
end
function v_u_5.GetWeaponData(_, p11, p12)
    for v13, v14 in pairs(p11:Get("WeaponInventory")) do
        if v14.Name == p12 then
            return v14, v13
        end
    end
end
function v_u_5.HasGamepass(_, p15, p16)
    return p15:Get("Gamepasses")[p16]
end
function v_u_5.AreTasksCompleted(_, p17, p18)
    for _, v19 in pairs(p17:Get(p18 or "Tasks")) do
        if not v19.Completed then
            return false
        end
    end
    return true
end
function v_u_5.GetUnlockedWeapons(_, p20, p21)
    local v22 = {}
    for _, v23 in pairs(p20:Get("WeaponInventory")) do
        v22[v23.Name] = true
    end
    if not p21 then
        for v24 in pairs(p20:Get("FreeWeaponUnlockCheck")) do
            v22[v24] = true
        end
    end
    return v22
end
function v_u_5.GetStatistic(_, p25, p26)
    local v27 = v_u_3.Info[p26]
    local v28 = v27 ~= nil
    assert(v28, p26)
    return p25:Get(p26) or v27.DefaultValue
end
function v_u_5.GetDirectoryStatistic(_, p29, p30, p31, p32, p33)
    local v34 = v_u_3.Info[p32]
    local v35 = v34 ~= nil
    assert(v35, p32)
    local v36 = 0
    local v37 = p29:Get(p30)
    local v38 = v37[p31] and v37[p31][p32] or v34.DefaultValue
    local v39
    if v34.ValueType == "number" then
        v36 = v36 + v38
        v39 = v36
    else
        v36 = v38
        v39 = v36
    end
    for _, v40 in pairs(p33 or {}) do
        local v41 = p29:Get(p30)
        local v42 = v41[p31] and v41[p31][v40] or v34.DefaultValue
        if v34.ValueType == "number" then
            v36 = v39 + v42
            v39 = v36
        else
            v36 = v42
            v39 = v36
        end
    end
    return v39
end
function v_u_5.GetSeasonInfo(_, p43, p44)
    local v45 = p43:Get("Seasons")[p44]
    if v45 then
        v45 = v45.RankedPerformances[v_u_4.UNIVERSAL_ELO_NAME]
    end
    local v46
    if v45 then
        v46 = v45.CurrentELO
    else
        v46 = v45
    end
    local v47 = v45 and v45.Metadata
    if v47 then
        v47 = v45.Metadata.FinalLeaderboardRank
    end
    return v46, v47
end
function v_u_5.GetWeaponStatistic(p48, p49, ...)
    return p48:GetDirectoryStatistic(p49, "WeaponStatistics", ...)
end
function v_u_5.GetMapStatistic(p50, p51, ...)
    return p50:GetDirectoryStatistic(p51, "MapStatistics", ...)
end
function v_u_5._Init(_) end
return v_u_5._new()