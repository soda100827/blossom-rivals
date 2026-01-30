return function(p1, p2, p3)
    p1:CreateSound("rbxassetid://100664516053133", 0.25, 1.5, true, 10)
    if p1:_AnimationWait(script.Name, p2, 0.75 / p3) then
        p1:CreateSound("rbxassetid://71387264231358", 1.25, 1.5, true, 10)
        p1:CreateSound("rbxassetid://13483008798", 0.5, 2.25, true, 10)
        if p1:_AnimationWait(script.Name, p2, 0.5 / p3) then
            p1:CreateSound("rbxassetid://110122962237431", 0.75, 1.5 + 0.25 * math.random(), true, 5)
        end
    else
        return
    end
end