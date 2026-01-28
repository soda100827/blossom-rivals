local v_u_1 = game:GetService("RunService")
local v_u_2 = {}
v_u_2.__index = v_u_2
function v_u_2._new()
    local v3 = v_u_2
    local v4 = setmetatable({}, v3)
    v4._items = {}
    v4:_Init()
    return v4
end
function v_u_2.AddItem(p5, p6, p7)
    if p6 then
        p5._items[p6] = tick() + p7
    end
end
function v_u_2._Init(p_u_8)
    v_u_1.Heartbeat:Connect(function()
        local v9 = {}
        for v10, v11 in pairs(p_u_8._items) do
            if v11 < tick() then
                v10:Destroy()
                v9[v10] = true
            end
        end
        for v12 in pairs(v9) do
            p_u_8._items[v12] = nil
        end
    end)
end
return v_u_2._new()