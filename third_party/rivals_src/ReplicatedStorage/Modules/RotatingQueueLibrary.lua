local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = require(v1.Modules.CONSTANTS)
local v_u_3 = require(v1.Modules.ServerOsTime)
local v_u_4 = require(v1.Modules.DuelLibrary)
local _ = v_u_2.IS_TESTING_SERVER
local v_u_5 = nil
local v_u_6 = v_u_5 or 86400
local v7 = 1755837328 / v_u_6
local v_u_8 = math.floor(v7)
local v_u_19 = {
    ["Info"] = {},
    ["Order"] = {},
    ["GetOsTime"] = function(_)
        return v_u_3:Get() - -590400
    end,
    ["GetCycle"] = function(p9)
        local v10 = p9:GetOsTime() / v_u_6
        return math.floor(v10)
    end,
    ["GetTimeUntilNext"] = function(p11)
        return (p11:GetCycle() + 1) * v_u_6 - p11:GetOsTime()
    end,
    ["GetCurrent"] = function(p12)
        local v13 = v_u_2.IS_STUDIO and not v_u_5 and 0 or (-1 / 0)
        local v14 = p12:GetCycle() - v_u_8
        local v15 = math.max(v13, v14)
        local v16 = v_u_19.Order[v15 % #v_u_19.Order + 1]
        return v_u_19.Info[v16]
    end,
    ["IsValidQueueName"] = function(p17, p18)
        return table.find(p17:GetCurrent().QueueNames, p18)
    end
}
local function v25(p20, ...)
    local v21 = {
        ["Name"] = p20,
        ["QueueNames"] = { ... }
    }
    v_u_19.Info[p20] = v21
    local v22 = v_u_19.Order
    table.insert(v22, p20)
    for _, v23 in pairs(v21.QueueNames) do
        local v24 = v_u_4.MatchmakingQueues[v23] ~= nil
        assert(v24, v23)
    end
end
v25("juggernaut", "ltm_juggernaut_1v7")
v25("swiftstandoff", "ltm_swiftstandoff_1v1", "ltm_swiftstandoff_2v2", "ltm_swiftstandoff_3v3")
v25("defaultduel_bunnysniping", "ltm_defaultduel_1v1", "ltm_defaultduel_2v2", "ltm_bunnysniping_2v2", "ltm_bunnysniping_3v3")
v25("tagteam", "ltm_tagteam_3v3", "ltm_tagteam_5v5")
v25("chickengame", "ltm_chickengames_1v1", "ltm_chickengames_2v2", "ltm_chickengames_3v3", "ltm_chickengames_4v4")
v25("rivalsrng", "ltm_rivalsrng_1v1", "ltm_rivalsrng_2v2", "ltm_rivalsrng_3v3")
v25("headhoncho", "ltm_headhoncho_3v3", "ltm_headhoncho_4v4", "ltm_headhoncho_5v5")
v25("hardcoreparkour", "ltm_hardcoreparkour_1v1", "ltm_hardcoreparkour_2v2", "ltm_hardcoreparkour_5v5")
v25("doubletrouble", "ltm_doubletrouble_1v1", "ltm_doubletrouble", "ltm_doubletrouble_3v3")
v25("mirrormatchup", "ltm_mirrormatchup_1v1", "ltm_mirrormatchup_2v2", "ltm_mirrormatchup_3v3")
v25("limitlessloadout", "ltm_limitlessloadout_1v1", "ltm_limitlessloadout_2v2", "ltm_limitlessloadout_3v3")
v25("threeteams", "1v1v1", "2v2v2", "3v3v3")
return v_u_19