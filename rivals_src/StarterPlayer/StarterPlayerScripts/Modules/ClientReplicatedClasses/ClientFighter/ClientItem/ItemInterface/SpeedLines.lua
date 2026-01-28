local v_u_1 = {}
v_u_1.__index = v_u_1
function v_u_1.new(p2)
    local v3 = v_u_1
    local v4 = setmetatable({}, v3)
    v4.ItemInterface = p2
    v4.SpeedLinesThin = v4.ItemInterface.Frame:WaitForChild("SpeedLinesThin")
    v4.SpeedLinesThick = v4.ItemInterface.Frame:WaitForChild("SpeedLinesThick")
    v4._destroyed = false
    v4._speed_lines_end = 0
    v4._next_speedlines_update = 0
    v4:_Init()
    return v4
end
function v_u_1.Create(p5, p6)
    local v7
    if p6 == -1 then
        v7 = 0
    else
        local v8 = p5._speed_lines_end
        local v9 = tick() + p6
        v7 = math.max(v8, v9)
    end
    p5._speed_lines_end = v7
end
function v_u_1.Update(p10, _, _)
    local v11 = tick() < p10._speed_lines_end
    p10.SpeedLinesThin.Visible = v11
    p10.SpeedLinesThick.Visible = v11
    if v11 and tick() >= p10._next_speedlines_update then
        p10._next_speedlines_update = tick() + 0.03
        local v12 = p10.ItemInterface.Frame.AbsoluteSize.X / p10.ItemInterface.Frame.AbsoluteSize.Y
        p10.SpeedLinesThin.Rotation = (p10.SpeedLinesThin.Rotation + (math.random() - 0.5) * 72) % 360
        p10.SpeedLinesThin.Size = UDim2.new(v12, 0, v12, 0)
        p10.SpeedLinesThick.Rotation = (p10.SpeedLinesThick.Rotation + (math.random() - 0.5) * 72) % 360
        p10.SpeedLinesThick.Size = p10.SpeedLinesThin.Size
    end
end
function v_u_1.Destroy(p13)
    p13._destroyed = true
end
function v_u_1._Init(_) end
return v_u_1