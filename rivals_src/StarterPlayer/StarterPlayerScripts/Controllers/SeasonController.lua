local v_u_1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("Players")
local v_u_3 = require(v_u_1.Modules.CONSTANTS)
local v_u_4 = require(v_u_1.Modules.SeasonLibrary)
local v_u_5 = require(v_u_1.Modules.Utility)
local v_u_6 = require(v_u_2.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
local v_u_7 = {}
v_u_7.__index = v_u_7
function v_u_7._new()
    local v8 = v_u_7
    local v9 = setmetatable({}, v8)
    v9._last_update = -1
    v9._time_remaining = nil
    v9:_Init()
    return v9
end
function v_u_7.GetTimeRemaining(p10)
    if not p10._time_remaining then
        return nil
    end
    local v11 = p10._time_remaining - (tick() - p10._last_update)
    local v12 = math.ceil(v11)
    return math.max(0, v12)
end
function v_u_7.GetCountdownText(p13)
    local v14 = p13:GetTimeRemaining()
    if not v14 then
        return nil
    end
    local v15 = v14 <= 0 and "" or "in "
    local v16 = v14 <= 0 and "ANY SECOND NOW" or v_u_5:TimeFormat2((math.ceil(v14)))
    return string.format("Season %s ends %s<font color=\"rgb(255,50,50)\" weight=\"700\">%s</font>", v_u_4.CurrentSeason.Version, v15, v16)
end
function v_u_7.IsRankedUnlocked(_)
    local v17 = v_u_6:GetStatistic("StatisticDuelsWon")
    local v18 = v_u_6:Get("Level")
    local v19 = v_u_2.LocalPlayer.AccountAge
    local v20 = v_u_6:GetStatistic("StatisticTasksCompleted")
    local v21
    if v_u_3.BEGINNER_QUEUE_WINS <= v17 and (v_u_4.CurrentSeason.LevelRequirement <= v18 and v_u_4.CurrentSeason.AccountAgeRequirement <= v19) then
        v21 = v_u_4.CurrentSeason.TasksCompletedRequirement <= v20
    else
        v21 = false
    end
    return v21
end
function v_u_7._UpdateTimer(p22, p23)
    p22._last_update = tick()
    p22._time_remaining = p23
end
function v_u_7._Fetch(p24)
    p24:_UpdateTimer(v_u_1.Remotes.Misc.RequestSeasonTimer:InvokeServer())
end
function v_u_7._Init(p_u_25)
    v_u_1.Remotes.Misc.UpdateSeasonTimer.OnClientEvent:Connect(function(p26)
        p_u_25:_UpdateTimer(p26)
    end)
    task.defer(p_u_25._Fetch, p_u_25)
end
return v_u_7._new()