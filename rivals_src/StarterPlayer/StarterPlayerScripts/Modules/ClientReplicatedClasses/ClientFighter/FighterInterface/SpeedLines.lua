local v_u_1 = {}
v_u_1.__index = v_u_1
function v_u_1.new(p2)
    local v3 = v_u_1
    local v4 = setmetatable({}, v3)
    v4.FighterInterface = p2
    v4.SpeedLinesThin = v4.FighterInterface.Frame:WaitForChild("SpeedLinesThin")
    v4.SpeedLinesThick = v4.FighterInterface.Frame:WaitForChild("SpeedLinesThick")
    v4._next_speedlines_update = 0
    v4:_Init()
    return v4
end
function v_u_1.Update(p5, _, p6)
    local v7 = p5.FighterInterface.ClientFighter.Entity and (p5.FighterInterface.ClientFighter.Entity:GetBoost("Speed") or 0) or 0
    local v8 = v7 > 0
    p5.SpeedLinesThin.Visible = v8
    p5.SpeedLinesThick.Visible = v8
    if v8 and tick() >= p5._next_speedlines_update then
        p5._next_speedlines_update = tick() + 0.03
        local v9 = p5.FighterInterface.Frame.AbsoluteSize.X ^ 2 + p5.FighterInterface.Frame.AbsoluteSize.Y ^ 2
        local v10 = math.sqrt(v9)
        local v11 = p6.MoveSpeed <= 1 and 1 or 1 - math.clamp(v7, 0, 1) * 1
        local v12 = math.min(0.9, v11)
        p5.SpeedLinesThin.Rotation = (p5.SpeedLinesThin.Rotation + (math.random() - 0.5) * 72) % 360
        p5.SpeedLinesThin.Size = UDim2.new(0, v10, 0, v10)
        p5.SpeedLinesThick.Rotation = (p5.SpeedLinesThick.Rotation + (math.random() - 0.5) * 72) % 360
        p5.SpeedLinesThick.Size = p5.SpeedLinesThin.Size
        p5.SpeedLinesThin.ImageTransparency = v12
        p5.SpeedLinesThick.ImageTransparency = v12
    end
end
function v_u_1.Destroy(_) end
function v_u_1._Init(_) end
return v_u_1