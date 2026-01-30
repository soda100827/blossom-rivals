local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = require(v1.Modules.Finisher)
local v_u_3 = v1.Modules.Finishers
local v_u_4 = setmetatable({}, v_u_2)
v_u_4.__index = v_u_4
function v_u_4.new(...)
    local v5 = v_u_2.new(...)
    local v6 = v_u_4
    local v7 = setmetatable(v5, v6)
    v7._finishers = {}
    v7:_Init()
    return v7
end
function v_u_4.PlayServer(p8)
    local v_u_9 = Instance.new("BindableEvent")
    local v10 = 0
    local v_u_11 = 0
    for _, v_u_12 in pairs(p8._finishers) do
        v10 = v10 + 1
        p8:_InternalThread(task.spawn, function()
            pcall(v_u_12.PlayServer, v_u_12)
            v_u_11 = v_u_11 + 1
            v_u_9:Fire()
        end)
    end
    while v_u_11 < v10 do
        v_u_9.Event:Wait()
    end
end
function v_u_4.PlayClient(p13)
    local v_u_14 = Instance.new("BindableEvent")
    local v15 = 0
    local v_u_16 = 0
    for _, v_u_17 in pairs(p13._finishers) do
        v15 = v15 + 1
        p13:_InternalThread(task.spawn, function()
            pcall(v_u_17.PlayClient, v_u_17)
            v_u_16 = v_u_16 + 1
            v_u_14:Fire()
        end)
    end
    while v_u_16 < v15 do
        v_u_14.Event:Wait()
    end
end
function v_u_4.Destroy(p18)
    for _, v19 in pairs(p18._finishers) do
        v19:Destroy()
    end
    v_u_2.Destroy(p18)
end
function v_u_4._Setup(p20)
    for _, v21 in pairs(v_u_3:GetChildren()) do
        if v21 ~= script then
            local v22 = p20._finishers
            local v23 = require(v21).new
            local v24 = p20._subject
            local v25 = p20._is_final_finisher
            local v26 = p20._eliminator
            table.insert(v22, v23(v24, v25, v26))
        end
    end
end
function v_u_4._Init(p27)
    p27:_Setup()
end
return v_u_4