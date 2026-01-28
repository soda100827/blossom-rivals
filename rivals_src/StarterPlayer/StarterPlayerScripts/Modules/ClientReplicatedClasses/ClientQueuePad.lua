local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.ReplicatedClass.BaseQueuePad)
local v_u_4 = require(v1.Modules.Signal)
local v_u_5 = require(v_u_2.LocalPlayer.PlayerScripts.Controllers.FighterController)
local v_u_6 = require(script:WaitForChild("QueuePadTerminal"))
local v_u_7 = require(script:WaitForChild("QueuePadVisuals"))
local v_u_8 = {
    "Model",
    "CanSelfQueue",
    "NumTeams",
    "PlayersPerTeam",
    "InfinitePlayersPerTeam",
    "QueueName",
    "IsStarting",
    "IsLocked",
    "PlayersWaiting"
}
local v_u_9 = setmetatable({}, v_u_3)
v_u_9.__index = v_u_9
function v_u_9.new(p10)
    local v11 = v_u_3.new(p10)
    local v12 = v_u_9
    local v13 = setmetatable(v11, v12)
    v13.Activity = v_u_4.new()
    v13.LocalPlayerActivity = v_u_4.new()
    v13.Visuals = v_u_7.new(v13)
    v13.Terminal = v_u_6.new(v13)
    v13._was_local_player_here = nil
    v13:_Init()
    return v13
end
function v_u_9.GetClientFightersWaiting(p14)
    local v15 = {}
    for v16, v17 in pairs(p14:Get("PlayersWaiting")) do
        local v18 = {}
        for v19, _ in pairs(v17) do
            local v20 = v_u_5:GetFighter((tonumber(v19)))
            if v20 then
                table.insert(v18, v20)
            end
        end
        v15[v16] = v18
    end
    return v15
end
function v_u_9.GetTeleportPosition(p21)
    local v22 = {}
    for v23 = 1, p21:Get("NumTeams") do
        local v24 = { p21:Get("Model"):WaitForChild("Important"):WaitForChild("Team" .. v23).Position, (p21:CountTeam(v23)) }
        table.insert(v22, v24)
    end
    table.sort(v22, function(p25, p26)
        return p25[2] < p26[2]
    end)
    return v22[1][1]
end
function v_u_9.Destroy(p27)
    p27.Activity:Destroy()
    p27.LocalPlayerActivity:Destroy()
    p27.Visuals:Destroy()
    p27.Terminal:Destroy()
    v_u_3.Destroy(p27)
end
function v_u_9._DetectLocalPlayerActivity(p_u_28)
    for _, v_u_29 in pairs(v_u_8) do
        p_u_28:GetDataChangedSignal(v_u_29):Connect(function()
            local v30 = v_u_29
            p_u_28.Activity:Fire(v30)
            local v31 = p_u_28:IsInQueue(v_u_2.LocalPlayer) ~= nil
            if v31 or p_u_28._was_local_player_here then
                p_u_28.LocalPlayerActivity:Fire(v30)
            end
            p_u_28._was_local_player_here = v31
        end)
    end
    p_u_28.Activity:Fire(nil)
    local v32 = p_u_28:IsInQueue(v_u_2.LocalPlayer) ~= nil
    if v32 or p_u_28._was_local_player_here then
        p_u_28.LocalPlayerActivity:Fire(nil)
    end
    p_u_28._was_local_player_here = v32
end
function v_u_9._Init(p33)
    p33:_DetectLocalPlayerActivity()
end
return v_u_9