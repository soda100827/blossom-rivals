local v_u_1 = game:GetService("CollectionService")
local v_u_2 = game:GetService("Players")
local v_u_3 = {}
v_u_3.__index = v_u_3
function v_u_3._new()
    local v4 = v_u_3
    local v5 = setmetatable({}, v4)
    v5:_Init()
    return v5
end
function v_u_3._Parse(_, p6)
    local v7 = ""
    local v8 = {}
    for v9 = 1, #p6 do
        local v10 = string.sub(p6, v9, v9)
        if v10 == "," or v9 == #p6 then
            if v9 == #p6 then
                v7 = v7 .. v10
            end
            local v11 = tonumber(v7)
            table.insert(v8, v11)
            v7 = ""
        else
            v7 = v7 .. v10
        end
    end
    return v8
end
function v_u_3._ObjectAdded(p12, p13)
    if not table.find(p12:_Parse(p13:GetAttribute("UserIDs")), v_u_2.LocalPlayer.UserId) then
        task.defer(p13.Destroy, p13)
    end
end
function v_u_3._Init(p_u_14)
    v_u_1:GetInstanceAddedSignal("UserIDsShow"):Connect(function(p15)
        p_u_14:_ObjectAdded(p15)
    end)
    for _, v16 in pairs(v_u_1:GetTagged("UserIDsShow")) do
        task.defer(p_u_14._ObjectAdded, p_u_14, v16)
    end
end
return v_u_3._new()