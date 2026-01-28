return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 0.2 / p3) then
        p1:CreateSound("rbxassetid://111876623538044", 1, 1 + 0.1 * math.random(), true, 10)
    end
end