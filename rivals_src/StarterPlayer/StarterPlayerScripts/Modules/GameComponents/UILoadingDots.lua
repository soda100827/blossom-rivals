local v_u_1 = game:GetService("CollectionService")
local v_u_2 = {}
v_u_2.__index = v_u_2
function v_u_2._new()
    local v3 = v_u_2
    local v4 = setmetatable({}, v3)
    v4:_Init()
    return v4
end
function v_u_2.Update(_, _)
    for _, v5 in pairs(v_u_1:GetTagged("UILoadingDots")) do
        for v6 = 1, 3 do
            local v7 = (tick() * -4 + v6 / 3 * 3.141592653589793 * 2 * 0.15) % 6.283185307179586
            local v8 = math.sin(v7)
            local v9 = math.abs(v8)
            local v10 = math.max(0.5, v9) * 0.3333333333333333
            v5[v6].Size = UDim2.new(v10, 0, v10, 0)
        end
    end
end
function v_u_2._Init(_) end
return v_u_2._new()