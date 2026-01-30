local v_u_1 = game:GetService("CollectionService")
local v2 = game:GetService("Players")
local v_u_3 = require(v2.LocalPlayer.PlayerScripts.Controllers.FighterController)
local v_u_4 = require(v2.LocalPlayer.PlayerScripts.Modules.Tightrope)
local v_u_5 = {}
v_u_5.__index = v_u_5
function v_u_5._new()
    local v6 = v_u_5
    local v7 = setmetatable({}, v6)
    v7.Tightropes = {}
    v7:_Init()
    return v7
end
function v_u_5.GetTightrope(p8, p9)
    for v10, v11 in pairs(p8.Tightropes) do
        if v11.Part == p9 then
            return v11, v10
        end
    end
end
function v_u_5.JumpOff(p12)
    for _, v13 in pairs(p12.Tightropes) do
        v13:JumpOff()
    end
end
function v_u_5._ObjectAdded(p14, p15)
    local v16 = v_u_4.new(p15)
    local v17 = p14.Tightropes
    table.insert(v17, v16)
end
function v_u_5._ObjectRemoved(p18, p19)
    local v20, v21 = p18:GetTightrope(p19)
    if v20 then
        v20:Destroy()
        table.remove(p18.Tightropes, v21)
    end
end
function v_u_5._HookLocalFighter(p_u_22)
    local v23 = v_u_3:WaitForLocalFighter()
    v23.EntityAdded:Connect(function(p_u_24)
        p_u_24.AirborneLocallyChanged:Connect(function()
            if p_u_24.IsAirborneLocally then
                p_u_22:JumpOff()
            end
        end)
    end)
    if v23.Entity then
        local v_u_25 = v23.Entity
        v_u_25.AirborneLocallyChanged:Connect(function()
            if v_u_25.IsAirborneLocally then
                p_u_22:JumpOff()
            end
        end)
    end
end
function v_u_5._Init(p_u_26)
    v_u_1:GetInstanceAddedSignal("Tightrope"):Connect(function(p27)
        p_u_26:_ObjectAdded(p27)
    end)
    v_u_1:GetInstanceRemovedSignal("Tightrope"):Connect(function(p28)
        p_u_26:_ObjectRemoved(p28)
    end)
    for _, v29 in pairs(v_u_1:GetTagged("Tightrope")) do
        task.defer(p_u_26._ObjectAdded, p_u_26, v29)
    end
    task.defer(p_u_26._HookLocalFighter, p_u_26)
end
return v_u_5._new()