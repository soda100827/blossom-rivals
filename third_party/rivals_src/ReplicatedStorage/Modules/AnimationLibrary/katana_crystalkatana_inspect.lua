return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 2.2 / p3) then
        p1:CreateSound("rbxassetid://13158735106", 0.25, 1.5, true, 10)
        if p1:_AnimationWait(script.Name, p2, 2.65 / p3) then
            p1:CreateSound("rbxassetid://134472359434980", 0.5, 1, true, 10)
            if p1:_AnimationWait(script.Name, p2, 0.65 / p3) then
                p1:CreateSound("rbxassetid://108380234827963", 0.5, 1.75 + 0.25 * math.random(), true, 10)
            end
        else
            return
        end
    else
        return
    end
end