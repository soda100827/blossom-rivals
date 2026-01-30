local v_u_1 = game:GetService("ReplicatedStorage")
local v_u_2 = {}
v_u_2.__index = v_u_2
function v_u_2._new()
    local v3 = v_u_2
    local v4 = setmetatable({}, v3)
    v4._last_update = -1
    v4._time_remaining = nil
    v4:_Init()
    return v4
end
function v_u_2.GetTimeRemaining(p5)
    if p5._time_remaining then
        local v6 = p5._time_remaining - (tick() - p5._last_update)
        local v7 = math.ceil(v6)
        return math.max(0, v7)
    end
end
function v_u_2._UpdateTimer(p8, p9)
    p8._last_update = tick()
    p8._time_remaining = p9
end
function v_u_2._Fetch(p10)
    p10:_UpdateTimer(v_u_1.Remotes.Misc.RequestEventTimer:InvokeServer())
end
function v_u_2._Init(p_u_11)
    v_u_1.Remotes.Misc.UpdateEventTimer.OnClientEvent:Connect(function(p12)
        p_u_11:_UpdateTimer(p12)
    end)
    task.defer(p_u_11._Fetch, p_u_11)
end
return v_u_2._new()