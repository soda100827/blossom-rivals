return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 0.15 / p3) then
        p1:CreateSound("rbxassetid://13682183816", 0.5, 2 + 0.5 * math.random(), true, 10)
        p1:CreateSound("rbxassetid://110122962237431", 0.5, 1.5 + 0.25 * math.random(), true, 5)
        p1:CreateSound("rbxassetid://71387264231358", 0.375, 1, true, 10)
    end
end