return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 0.38 / p3) then
        p1:CreateSound("rbxassetid://96886470957330", 0.875, 1.25 + 0.125 * math.random(), true, 5)
    end
end