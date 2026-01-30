return function(p1, p2, p3)
    p1:CreateSound("rbxassetid://130860307965581", 1, 1 + 0.1 * math.random(), true, 10)
    if p1:_AnimationWait(script.Name, p2, 7.15 / p3) then
        p1:CreateSound("rbxassetid://114610550422028", 1, 1 + 0.25 * math.random(), true, 10)
    end
end