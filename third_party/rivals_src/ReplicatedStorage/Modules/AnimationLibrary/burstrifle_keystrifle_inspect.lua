return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 2.4 / p3) then
        p1:CreateSound("rbxassetid://13158735106", 0.25, 1.5, true, 10)
        if p1:_AnimationWait(script.Name, p2, 0.45 / p3) then
            p1:CreateSound("rbxassetid://110122962237431", 1.25, 1 + 0.1 * math.random(), true, 5)
            p1:CreateSound("rbxassetid://71387264231358", 0.75, 1 + 0.1 * math.random(), true, 10)
            if p1:_AnimationWait(script.Name, p2, 0.55 / p3) then
                p1:CreateSound("rbxassetid://71387264231358", 0.75, 0.75, true, 10)
                if p1:_AnimationWait(script.Name, p2, 1.8 / p3) then
                    p1:CreateSound("rbxassetid://110122962237431", 1.25, 1 + 0.1 * math.random(), true, 5)
                    p1:CreateSound("rbxassetid://71387264231358", 0.75, 1 + 0.1 * math.random(), true, 10)
                    if p1:_AnimationWait(script.Name, p2, 0.45 / p3) then
                        p1:CreateSound("rbxassetid://13158735106", 0.25, 1.5, true, 10)
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
    else
        return
    end
end