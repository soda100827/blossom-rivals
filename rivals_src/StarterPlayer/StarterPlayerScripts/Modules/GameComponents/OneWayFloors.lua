local v_u_1 = game:GetService("CollectionService")
local v2 = game:GetService("Players")
local v_u_3 = require(v2.LocalPlayer.PlayerScripts.Controllers.SpectateController)
local v_u_4 = {}
v_u_4.__index = v_u_4
function v_u_4._new()
    local v5 = v_u_4
    local v6 = setmetatable({}, v5)
    v6._one_way_floors = {}
    v6._enabled = false
    v6:_Init()
    return v6
end
function v_u_4.Update(p7, _)
    if p7._enabled then
        local v8 = v_u_3.CurrentSubject and (v_u_3.CurrentSubject.Entity and v_u_3.CurrentSubject.Entity.RootPart)
        if v8 then
            v8 = v_u_3.CurrentSubject.Entity.RootPart.Position
        end
        for v9 in pairs(p7._one_way_floors) do
            local v10
            if v8 then
                v10 = v8.Y < v9.Position.Y + 2
            else
                v10 = v8
            end
            v9.LocalTransparencyModifier = v10 and 1 or 0
            v9.CanCollide = not v10
        end
    end
end
function v_u_4._CheckEnabled(p11)
    p11._enabled = next(p11._one_way_floors) ~= nil
end
function v_u_4._ObjectRemoved(p12, p13)
    p12._one_way_floors[p13] = nil
    p12:_CheckEnabled()
end
function v_u_4._ObjectAdded(p14, p15)
    p14._one_way_floors[p15] = true
    p14:_CheckEnabled()
end
function v_u_4._Init(p_u_16)
    v_u_1:GetInstanceRemovedSignal("OneWayFloor"):Connect(function(p17)
        p_u_16:_ObjectRemoved(p17)
    end)
    v_u_1:GetInstanceAddedSignal("OneWayFloor"):Connect(function(p18)
        p_u_16:_ObjectAdded(p18)
    end)
    for _, v19 in pairs(v_u_1:GetTagged("OneWayFloor")) do
        task.spawn(p_u_16._ObjectAdded, p_u_16, v19)
    end
end
return v_u_4._new()