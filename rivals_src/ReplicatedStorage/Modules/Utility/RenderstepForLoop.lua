local v_u_1 = game:GetService("RunService")
return function(p2, p3, p4, p5, p6, p7)
    local v8 = typeof(p2) == "number"
    local v9 = "Argument 1 invalid, expected a number, got " .. tostring(p2)
    assert(v8, v9)
    local v10 = typeof(p3) == "number"
    local v11 = "Argument 2 invalid, expected a number, got " .. tostring(p3)
    assert(v10, v11)
    local v12 = typeof(p4) == "number" and true or typeof(p4) == "function"
    local v13 = "Argument 3 invalid, expected a number or function, got " .. tostring(p4)
    assert(v12, v13)
    local v14 = typeof(p5) == "function"
    local v15 = "Argument 4 invalid, expected a function, got " .. tostring(p5)
    assert(v14, v15)
    local v16 = not p6 or typeof(p6) == "boolean"
    local v17 = "Argument 5 invalid, expected a boolean or nil, got " .. tostring(p6)
    assert(v16, v17)
    local v18 = not p7 or typeof(p7) == "number"
    local v19 = "Argument 6 invalid, expected a number or nil, got " .. tostring(p7)
    assert(v18, v19)
    local v20 = typeof(p4) == "function"
    local v21 = p7 or 1
    while true do
        local v22
        if v20 then
            v22 = p4() or p4
        else
            v22 = p4
        end
        if v22 > 0 and p3 < p2 or v22 < 0 and p2 < p3 then
            if not p6 then
                p5(p3)
            end
            return
        end
        if p5(p2) then
            return
        end
        local v23 = tick()
        for _ = 1, v21 do
            v_u_1.Heartbeat:Wait()
        end
        p2 = p2 + v22 * (tick() - v23) * 60 / v21
    end
end