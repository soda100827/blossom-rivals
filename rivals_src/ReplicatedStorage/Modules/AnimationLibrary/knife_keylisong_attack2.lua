return function(p1, p2, p3)
    p1:CreateSound("rbxassetid://13455968789", 1, 1.5 + 0.5 * math.random(), true, 10)
    p1:CreateSound("rbxassetid://101733853413710", 1, 1 + 0.1 * math.random(), true, 10)
    p1:CreateSound("rbxassetid://96253147006478", 0.75, 1.75 + 0.5 * math.random(), true, 10)
    p1:CreateSpectatorSound("rbxassetid://110122962237431", 0.5, 1 + 0.5 * math.random(), true, 5)
    if p1:_AnimationWait(script.Name, p2, 0.95 / p3) then
        p1:CreateSpectatorSound("rbxassetid://108891371725091", 1, 1 + 0.1 * math.random(), true, 10)
        p1:CreateSpectatorSound("rbxassetid://76064160033456", 1, 1 + 0.1 * math.random(), true, 10)
        p1:CreateSpectatorSound("rbxassetid://110122962237431", 0.5, 1 + 0.5 * math.random(), true, 5)
        if p1:_AnimationWait(script.Name, p2, 0.65 / p3) then
            p1:CreateSpectatorSound("rbxassetid://14427935597", 0.5, 1.25, true, 10)
            p1:CreateSpectatorSound("rbxassetid://108891371725091", 1, 1.25 + 0.25 * math.random(), true, 10)
            p1:CreateSpectatorSound("rbxassetid://76064160033456", 1, 1.25 + 0.25 * math.random(), true, 10)
            p1:CreateSpectatorSound("rbxassetid://110122962237431", 0.5, 1 + 0.5 * math.random(), true, 5)
            if p1:_AnimationWait(script.Name, p2, 0.65 / p3) then
                p1:CreateSpectatorSound("rbxassetid://13160326139", 1, 1.25, true, 10)
                p1:CreateSpectatorSound("rbxassetid://108891371725091", 1, 1.25 + 0.25 * math.random(), true, 10)
                p1:CreateSpectatorSound("rbxassetid://110122962237431", 0.5, 1 + 0.5 * math.random(), true, 5)
            end
        else
            return
        end
    else
        return
    end
end