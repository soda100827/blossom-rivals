local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = require(v1.Modules.CONSTANTS)
local v_u_3 = {}
v_u_3.__index = v_u_3
function v_u_3._new()
    local v4 = v_u_3
    local v5 = setmetatable({}, v4)
    v5._last_fetch = tick()
    v5._last_server_time = workspace:GetServerTimeNow()
    v5:_Init()
    return v5
end
function v_u_3.Get(p6)
    if v_u_2.IS_SERVER then
        return os.time()
    else
        return p6._last_server_time + (tick() - p6._last_fetch)
    end
end
function v_u_3.GetRounded(p7)
    if v_u_2.IS_SERVER then
        return os.time()
    end
    local v8 = p7:Get() + 0.5
    return math.floor(v8)
end
function v_u_3.WaitUntil(p9, p10)
    wait(p10 - p9:Get())
end
function v_u_3._Init(_) end
return v_u_3._new()