local v_u_1 = game:GetService("CollectionService")
local v_u_2 = require(script:WaitForChild("PortalModel"))
local v_u_3 = {}
v_u_3.__index = v_u_3
function v_u_3._new()
    local v4 = v_u_3
    local v5 = setmetatable({}, v4)
    v5._portal_models = {}
    v5:_Init()
    return v5
end
function v_u_3.Update(p6, p7)
    for _, v8 in pairs(p6._portal_models) do
        v8:Update(p7)
    end
end
function v_u_3._ObjectRemoved(p9, p10)
    if p9._portal_models[p10] then
        p9._portal_models[p10]:Destroy()
        p9._portal_models[p10] = nil
    end
end
function v_u_3._ObjectAdded(p11, p12)
    p11:_ObjectRemoved(p12)
    local v13 = v_u_2.new(p12)
    p11._portal_models[p12] = v13
end
function v_u_3._Init(p_u_14)
    v_u_1:GetInstanceRemovedSignal("PortalModel"):Connect(function(p15)
        p_u_14:_ObjectRemoved(p15)
    end)
    v_u_1:GetInstanceAddedSignal("PortalModel"):Connect(function(p16)
        p_u_14:_ObjectAdded(p16)
    end)
    for _, v17 in pairs(v_u_1:GetTagged("PortalModel")) do
        task.spawn(p_u_14._ObjectAdded, p_u_14, v17)
    end
end
return v_u_3._new()