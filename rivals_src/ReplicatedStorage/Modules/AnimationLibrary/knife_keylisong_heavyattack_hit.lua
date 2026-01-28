return function(p1, p2, p3)
    p1:CreateSound("rbxassetid://14241444681", 1.5, 1, true, 10)
    p1:CreateSound("rbxassetid://110122962237431", 1.75, 1.25 + 0.25 * math.random(), true, 5)
    if p1:_AnimationWait(script.Name, p2, 0.55 / p3) then
        p1:CreateSpectatorSound("rbxassetid://113941779770778", 1, 1 + 0.1 * math.random(), true, 10)
        p1:CreateSpectatorSound("rbxassetid://110122962237431", 0.5, 1 + 0.5 * math.random(), true, 5)
        if p1:_AnimationWait(script.Name, p2, 0.3 / p3) then
            p1:CreateSpectatorSound("rbxassetid://108891371725091", 1, 1 + 0.1 * math.random(), true, 10)
            p1:CreateSpectatorSound("rbxassetid://76064160033456", 1, 1 + 0.1 * math.random(), true, 10)
            p1:CreateSpectatorSound("rbxassetid://110122962237431", 0.5, 1 + 0.5 * math.random(), true, 5)
            if p1:_AnimationWait(script.Name, p2, 0.55 / p3) then
                p1:CreateSpectatorSound("rbxassetid://108891371725091", 1, 1 + 0.1 * math.random(), true, 10)
                p1:CreateSpectatorSound("rbxassetid://110122962237431", 0.5, 1 + 0.5 * math.random(), true, 5)
                if p1:_AnimationWait(script.Name, p2, 0.15 / p3) then
                    p1:CreateSpectatorSound("rbxassetid://106430462780583", 1, 1.5 + 0.2 * math.random(), true, 10)
                    p1:CreateSpectatorSound("rbxassetid://110122962237431", 0.5, 1 + 0.5 * math.random(), true, 5)
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