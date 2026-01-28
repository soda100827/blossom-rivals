local v_u_1 = game:GetService("ReplicatedStorage")
local v_u_2 = require(v_u_1.Modules.Signal)
local v_u_3 = {}
v_u_3.__index = v_u_3
function v_u_3._new()
    local v4 = v_u_3
    local v5 = setmetatable({}, v4)
    v5.Refreshed = v_u_2.new()
    v5.LeaderboardSerials = {}
    v5._leaderboard_refreshed_signals = {}
    v5:_Init()
    return v5
end
function v_u_3.GetLeaderboardRefreshedSignal(p6, p7)
    if not p6._leaderboard_refreshed_signals[p7] then
        p6._leaderboard_refreshed_signals[p7] = v_u_2.new()
    end
    return p6._leaderboard_refreshed_signals[p7]
end
function v_u_3.GetRankingByUserID(p8, p9, p10)
    local v11 = p8.LeaderboardSerials[p9]
    if v11 then
        local v12 = tostring(p10)
        for v13, v14 in pairs(v11.Players) do
            if v12 == v14.key then
                return v13
            end
        end
    end
end
function v_u_3.GetRankingByValue(p15, p16, p17)
    local v18 = p15.LeaderboardSerials[p16]
    if v18 then
        for v19, v20 in pairs(v18.Players) do
            if v20.value <= p17 then
                return v19
            end
        end
    end
end
function v_u_3._Setup(_)
    v_u_1.Remotes.Misc.RequestLeaderboards:FireServer()
end
function v_u_3._Init(p_u_21)
    p_u_21.Refreshed:Connect(function(p22)
        if p_u_21._leaderboard_refreshed_signals[p22] then
            p_u_21._leaderboard_refreshed_signals[p22]:Fire()
        end
    end)
    v_u_1.Remotes.Misc.LeaderboardRefreshed.OnClientEvent:Connect(function(p23)
        p_u_21.LeaderboardSerials[p23.Name] = p23
        p_u_21.Refreshed:Fire(p23.Name)
    end)
    p_u_21:_Setup()
end
return v_u_3._new()