return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 3.6 / p3) then
        p1:CreateSound("rbxassetid://106485622539697", 1, 1 + 0.1 * math.random(), true, 5)
    end
end