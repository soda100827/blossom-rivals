return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 0.5 / p3) then
        p1:CreateSound("rbxassetid://17247639614", 0.25, 1 + 0.1 * math.random(), true, 10)
        if p1:_AnimationWait(script.Name, p2, 3.5 / p3) then
            p1:CreateSound("rbxassetid://17247639272", 0.2, 0.9 + 0.1 * math.random(), true, 10)
        end
    else
        return
    end
end