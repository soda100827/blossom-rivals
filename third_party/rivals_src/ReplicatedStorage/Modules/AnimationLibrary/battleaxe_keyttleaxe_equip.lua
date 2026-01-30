return function(p1, p2, p3)
    p1:CreateSound("rbxassetid://100664516053133", 0.25, 1.5, true, 10)
    if p1:_AnimationWait(script.Name, p2, 0.85 / p3) then
        p1:CreateSound("rbxassetid://110122962237431", 1.25, 1 + 0.1 * math.random(), true, 5)
        p1:CreateSound("rbxassetid://71387264231358", 0.75, 1, true, 10)
        if p1:_AnimationWait(script.Name, p2, 0.7 / p3) then
            p1:CreateSound("rbxassetid://96253147006478", 0.5, 0.8, true, 10)
            if p1:_AnimationWait(script.Name, p2, 0.5 / p3) then
                p1:CreateSound("rbxassetid://110122962237431", 1.25, 1 + 0.1 * math.random(), true, 5)
                p1:CreateSound("rbxassetid://71387264231358", 0.75, 1, true, 10)
            end
        else
            return
        end
    else
        return
    end
end