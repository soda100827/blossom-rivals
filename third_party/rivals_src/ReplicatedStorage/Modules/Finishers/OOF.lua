local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = require(v1.Modules.Finisher)
local v_u_3 = setmetatable({}, v_u_2)
v_u_3.__index = v_u_3
function v_u_3.new(...)
    local v4 = v_u_2.new(...)
    local v5 = v_u_3
    local v6 = setmetatable(v4, v5)
    v6:_Init()
    return v6
end
function v_u_3.PlayServer(p7)
    p7:_BreakJoints()
    p7:_InternalThread(task.delay, 0.25, p7._BreakJoints, p7)
    p7:_AnchorModel()
    for _, v8 in pairs(p7:_GetObjects()) do
        if v8:IsA("BasePart") then
            local v9 = v8.AssemblyLinearVelocity
            local v10 = math.random() - 0.5
            local v11 = math.random()
            local v12 = math.random() - 0.5
            v8.AssemblyLinearVelocity = v9 + Vector3.new(v10, v11, v12) * 10
        end
    end
end
function v_u_3.PlayClient(p13)
    p13:CreateSound("rbxassetid://79348298352567", 1.25, 1 + 0.1 * math.random(), nil, true)
end
function v_u_3._Init(_) end
return v_u_3