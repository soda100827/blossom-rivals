return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 0.35 / p3) then
        p1:CreateSound("rbxassetid://13483008798", 1.25, 2.5, true, 10)
        p1:CreateSound("rbxassetid://90757583550672", 0.625, 1.25 + 0.25 * math.random(), true, 5)
        if p1:_AnimationWait(script.Name, p2, 0.5 / p3) then
            p1:CreateSound("rbxassetid://13456860578", 0.25, 2, true, 10)
            p1:CreateSound("rbxassetid://100664516053133", 0.25, 1.5, true, 10)
            if p1:_AnimationWait(script.Name, p2, 0.25 / p3) then
                p1:CreateSound("rbxassetid://71387264231358", 1.25, 1, true, 10)
                if p1:_AnimationWait(script.Name, p2, 0.4 / p3) then
                    p1:CreateSound("rbxassetid://14241444681", 1, 1.125, true, 10)
                    p1:CreateSound("rbxassetid://110122962237431", 1.25, 1.25 + 0.25 * math.random() + 0.125, true, 5)
                end
            else
                return
            end
        else
            return
        end
    else
        return
    end
end