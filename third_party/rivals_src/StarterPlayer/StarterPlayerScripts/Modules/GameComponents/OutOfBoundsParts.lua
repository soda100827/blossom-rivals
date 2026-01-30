local v_u_1 = game:GetService("ReplicatedStorage")
local v_u_2 = require(v_u_1.Modules.OutOfBoundsMachine)
local v_u_3 = setmetatable({}, v_u_2)
v_u_3.__index = v_u_3
function v_u_3._new()
    local v4 = v_u_2.new(nil, nil)
    local v5 = v_u_3
    local v6 = setmetatable(v4, v5)
    v6:_Init()
    return v6
end
function v_u_3._Init(p7)
    p7.Kill:Connect(function(p8)
        v_u_1.Remotes.Replication.Fighter.OutOfBounds:FireServer(p8)
    end)
end
return v_u_3._new()