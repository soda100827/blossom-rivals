return function(p1, p2, p3)
    local v4 = p1:CreateSound("rbxassetid://13645858587", 0.375, 1, true)
    if v4 then
        v4.Looped = true
    end
    local v5 = p1:CreateSound("rbxassetid://13646484249", 0.375, 1, true)
    if v5 then
        v5.Looped = true
    end
    local v6 = p1:CreateSound("rbxassetid://13646484113", 0.25, 1, true)
    if v6 then
        v6.Looped = true
    end
    if p1:_AnimationWait(script.Name, p2, 0.25 / p3) then
        p1:CreateSound("rbxassetid://17247639614", 0.75, 1 + 0.1 * math.random(), true, 10)
    end
end