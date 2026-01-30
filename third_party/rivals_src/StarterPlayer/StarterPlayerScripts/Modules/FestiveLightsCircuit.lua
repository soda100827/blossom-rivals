local v_u_1 = {}
v_u_1.__index = v_u_1
function v_u_1.new(p2, ...)
    local v3 = v_u_1
    local v4 = setmetatable({}, v3)
    v4._interval = p2
    v4._references = { ... }
    v4._connections = {}
    v4._colors = {}
    v4._formatted = {}
    v4._next_update = 0
    v4._offset = 0
    v4:_Init()
    return v4
end
function v_u_1.Update(p5, _)
    if tick() >= p5._next_update then
        p5._next_update = tick() + p5._interval
        p5._offset = p5._offset + 1
        for v6, v7 in pairs(p5._formatted) do
            v7.Reference.Transparency = 1
            v7.Visual.Transparency = 0
            v7.Visual.Color = p5._colors[(v6 + p5._offset) % #p5._colors + 1]
        end
    end
end
function v_u_1.Destroy(p8)
    for _, v9 in pairs(p8._connections) do
        v9:Disconnect()
    end
    p8._connections = {}
    p8._references = {}
    p8._formatted = {}
end
function v_u_1._UpdateColors(p10)
    p10._colors = {}
    p10._next_update = 0
    for _, v11 in pairs(p10._references) do
        local v12 = p10._colors
        local v13 = v11.Color
        table.insert(v12, v13)
    end
    p10:Update(0)
end
function v_u_1._Setup(p_u_14)
    for _, v15 in pairs(p_u_14._references) do
        local v16 = p_u_14._connections
        local v17 = v15:GetPropertyChangedSignal("Color")
        table.insert(v16, v17:Connect(function()
            p_u_14:_UpdateColors()
        end))
        local v18 = p_u_14._formatted
        local v19 = {
            ["Reference"] = v15,
            ["Visual"] = v15:WaitForChild("Visual")
        }
        table.insert(v18, v19)
    end
end
function v_u_1._Init(p20)
    p20:_Setup()
    p20:_UpdateColors()
end
return v_u_1