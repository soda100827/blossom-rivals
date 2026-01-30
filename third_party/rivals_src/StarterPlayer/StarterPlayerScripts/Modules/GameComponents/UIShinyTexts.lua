local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("CollectionService")
local v_u_3 = require(v1.Modules.Utility)
local v_u_4 = {}
v_u_4.__index = v_u_4
function v_u_4._new()
    local v5 = v_u_4
    local v6 = setmetatable({}, v5)
    v6._objects = {}
    v6:_Init()
    return v6
end
function v_u_4.Update(p7, _)
    for v8, v9 in pairs(p7._objects) do
        if v_u_3:IsUIElementVisible(v8) then
            local v10
            if v9.IsDoubleFlash then
                v10 = tick() * 0.25 * 8 % 6
                if v10 >= 1 then
                    v10 = v10 >= 2 and 0 or v10 - 1
                end
            else
                v10 = tick() * 0.25 % 1
            end
            local v11 = 6.283185307179586 * (v10 - 0.5)
            local v12 = (math.sin(v11) + 6.283185307179586 * (v10 - 0.5)) / 6.283185307179586 + 0.5
            v9.Gradient.Offset = Vector2.new((v12 - 0.5) * 2, 0)
        end
    end
end
function v_u_4._ObjectRemoved(p13, p14)
    if p13._objects[p14] then
        p13._objects[p14] = nil
    end
end
function v_u_4._ObjectAdded(p15, p16)
    p15:_ObjectRemoved(p16)
    p15._objects[p16] = {
        ["Gradient"] = p16:WaitForChild("UIGradient"),
        ["IsDoubleFlash"] = p16:GetAttribute("IsDoubleFlash")
    }
end
function v_u_4._Init(p_u_17)
    v_u_2:GetInstanceRemovedSignal("UIShinyText"):Connect(function(p18)
        p_u_17:_ObjectRemoved(p18)
    end)
    v_u_2:GetInstanceAddedSignal("UIShinyText"):Connect(function(p19)
        p_u_17:_ObjectAdded(p19)
    end)
    for _, v20 in pairs(v_u_2:GetTagged("UIShinyText")) do
        task.spawn(p_u_17._ObjectAdded, p_u_17, v20)
    end
end
return v_u_4._new()