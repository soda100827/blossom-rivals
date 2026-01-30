local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = require(v1:WaitForChild("Modules"):WaitForChild("ReplicatedClass"))
local v_u_3 = setmetatable({}, v_u_2)
v_u_3.__index = v_u_3
function v_u_3.new(p4)
    local v5 = v_u_2.new(p4, true)
    local v6 = v_u_3
    local v7 = setmetatable(v5, v6)
    v7:_Init()
    return v7
end
function v_u_3._Init(_) end
return v_u_3