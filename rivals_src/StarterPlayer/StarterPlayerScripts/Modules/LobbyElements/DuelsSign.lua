local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("CollectionService")
local v3 = game:GetService("Players")
local v_u_4 = require(v1.Modules.CONSTANTS)
local v_u_5 = require(v3.LocalPlayer.PlayerScripts.Modules.LobbyElement)
local v_u_6 = setmetatable({}, v_u_5)
v_u_6.__index = v_u_6
function v_u_6._new(...)
    local v7 = v_u_5.new(...)
    local v8 = v_u_6
    local v9 = setmetatable(v7, v8)
    v9:_Init()
    return v9
end
function v_u_6.Update(p10, _)
    for _, v11 in pairs(v_u_2:GetTagged("LobbyDuelsSign")) do
        local v12 = tick()
        local v13 = v11.Yellow
        local v14 = p10:_GetOriginalPivot(v11.Yellow)
        local v15 = math.cos(v12) ^ 3 - math.sin(v12) ^ 3
        v13:PivotTo(v14 + 0.5 * Vector3.new(0, v15, 0))
        local v16 = v11.Purple
        local v17 = p10:_GetOriginalPivot(v11.Purple)
        local v18 = v12 - 3.141592653589793
        local v19 = math.cos(v18) ^ 3
        local v20 = v12 - 3.141592653589793
        local v21 = v19 - math.sin(v20) ^ 3
        v16:PivotTo(v17 + 0.5 * Vector3.new(0, v21, 0))
    end
end
function v_u_6._Setup(_)
    local function v23(p22)
        p22:WaitForChild("Screen"):WaitForChild("Duels").Enabled = v_u_4.QUEUES_ACTIVE
        p22:WaitForChild("Screen"):WaitForChild("Play").Enabled = not v_u_4.QUEUES_ACTIVE
    end
    v_u_2:GetInstanceAddedSignal("LobbyDuelsSign"):Connect(v23)
    for _, v24 in pairs(v_u_2:GetTagged("LobbyDuelsSign")) do
        v24:WaitForChild("Screen"):WaitForChild("Duels").Enabled = v_u_4.QUEUES_ACTIVE
        v24:WaitForChild("Screen"):WaitForChild("Play").Enabled = not v_u_4.QUEUES_ACTIVE
    end
end
function v_u_6._Init(p25)
    p25:_Setup()
end
return v_u_6._new()