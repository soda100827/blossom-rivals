local v_u_1 = {}
v_u_1.__index = v_u_1
function v_u_1.new(p2, p3)
    local v4 = v_u_1
    local v5 = setmetatable({}, v4)
    v5.DisplayName = p2
    v5.Image = p3
    v5:_Init()
    return v5
end
function v_u_1._Init(_) end
return v_u_1