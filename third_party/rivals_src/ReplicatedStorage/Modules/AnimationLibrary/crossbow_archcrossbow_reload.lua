return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 1.15 / p3) then
        p1:CreateSound("rbxassetid://114610550422028", 1, 1 + 0.25 * math.random(), true, 10)
    end
end