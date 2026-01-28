local v_u_1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v_u_1.Modules.BetterDebris)
local v_u_4 = require(v_u_1.Modules.Signal)
local v_u_5 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("NotificationSlot"))
local v_u_6 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("UILibrary"))
local v_u_7 = {}
v_u_7.__index = v_u_7
function v_u_7._new()
    local v8 = v_u_7
    local v9 = setmetatable({}, v8)
    v9.NotificationSent = v_u_4.new()
    v9.Frame = v_u_6:GetTo("MainFrame", "Notifications")
    v9._queue = {}
    v9._is_playing_queue = false
    v9:_Init()
    return v9
end
function v_u_7.Play(p10, p11, p12, p13, p14, p15, p16, p17)
    local v18
    if p17 then
        v18 = nil
    else
        v18 = v_u_5.new(p11, p12, p13, p14)
        v18:SetParent(p10.Frame.Container)
        v18:PlaySize(p15, 5)
        v18:PlaySound(p16)
        v18:PlayGlow()
        v_u_3:AddItem(v18, 10)
    end
    p10.NotificationSent:Fire(p11, p12, p13, p14)
    return v18
end
function v_u_7.Queue(p19, ...)
    local v20 = p19._queue
    table.insert(v20, { ... })
    p19:_PlayQueue()
end
function v_u_7._PlayQueue(p21)
    if not p21._is_playing_queue then
        p21._is_playing_queue = true
        local v22 = true
        while #p21._queue > 0 do
            if v22 then
                wait(0.25)
                v22 = false
            end
            local v23 = #p21._queue
            local v24 = 1 - (math.min(5, v23) - 1) * 0.1
            local v25 = 1
            while true do
                local v26 = v25 <= 5 and table.remove(p21._queue, 1)
                if not v26 then
                    break
                end
                local v27, v28, v29, v30, v31, v32 = table.unpack(v26)
                task.spawn(p21.Play, p21, v27, v28, v29, v30, (v31 or 1) * v24, nil, v32)
                if not v32 then
                    wait(0.1)
                    v25 = v25 + 1
                end
            end
            wait(5)
        end
        p21._is_playing_queue = false
    end
end
function v_u_7._Init(p_u_33)
    v_u_1.Remotes.Data.PlayNotification.OnClientEvent:Connect(function(...)
        p_u_33:Queue(...)
    end)
end
return v_u_7._new()