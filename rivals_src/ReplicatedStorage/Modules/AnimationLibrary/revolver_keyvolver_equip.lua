return function(p1, p2, p3)
    p1:CreateSound("rbxassetid://100664516053133", 0.25, 1.5, true, 10)
    if p1:_AnimationWait(script.Name, p2, 0.5 / p3) then
        p1:CreateSound("rbxassetid://13483008798", 0.5, 2, true, 10)
        p1:CreateSound("rbxassetid://110122962237431", 0.375, 1.5 + 0.5 * math.random(), true, 5)
    end
end