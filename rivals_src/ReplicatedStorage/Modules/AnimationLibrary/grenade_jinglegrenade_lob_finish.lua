return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 0.125 / p3) then
        p1:CreateSound("rbxassetid://14522189766", 2, 1 + 0.25 * math.random(), true, 10)
        p1:CreateSound("rbxassetid://137900058595276", 1, 1.25, true, 10)
    end
end