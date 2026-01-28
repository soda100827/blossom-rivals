return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 1.4 / p3) then
        p1:CreateSound("rbxassetid://13158735106", 0.25, 1.5, true, 10)
        if p1:_AnimationWait(script.Name, p2, 1.5 / p3) then
            p1:CreateSound("rbxassetid://13456860578", 1, 2, true, 10)
            p1:CreateSound("rbxassetid://100664516053133", 0.25, 1.5, true, 10)
            if p1:_AnimationWait(script.Name, p2, 0.35 / p3) then
                p1:CreateSound("rbxassetid://13456860578", 1, 2.5, true, 10)
                p1:CreateSound("rbxassetid://100664516053133", 0.25, 1.75, true, 10)
                if p1:_AnimationWait(script.Name, p2, 0.5 / p3) then
                    p1:CreateSound("rbxassetid://13483008798", 1, 2, true, 10)
                    p1:CreateSound("rbxassetid://110122962237431", 1.25, 1 + 0.1 * math.random(), true, 5)
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