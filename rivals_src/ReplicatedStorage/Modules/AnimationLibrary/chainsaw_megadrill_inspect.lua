return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 0.6 / p3) then
        p1:CreateSound("rbxassetid://17247639614", 0.875, 1 + 0.1 * math.random(), true, 10)
        if p1:_AnimationWait(script.Name, p2, 2.9 / p3) then
            p1:CreateSound("rbxassetid://17247639614", 0.75, 0.8 + 0.1 * math.random(), true, 10)
        end
    else
        return
    end
end