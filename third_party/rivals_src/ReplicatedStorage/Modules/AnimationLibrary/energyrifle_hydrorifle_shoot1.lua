return function(p1, p2, p3)
    p1:CreateSound("rbxassetid://73644074370077", 0.875, 1 + 0.2 * math.random(), true, 5)
    p1:CreateSound("rbxassetid://108166862465565", 0.75, 1 + 0.2 * math.random(), true, 5)
    for _ = 1, 3 do
        p1:CreateSound("rbxassetid://18763517194", 1, 1 + 0.25 * math.random(), true, 5)
        if not p1:_AnimationWait(script.Name, p2, 0.1 / p3) then
            return
        end
    end
end