return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 0.15 / p3) then
        p1:CreateSound("rbxassetid://98906484629283", 1.5, 1 + 0.2 * math.random(), true, 5)
    end
end