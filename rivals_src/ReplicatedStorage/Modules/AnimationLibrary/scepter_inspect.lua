return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 2.35 / p3) then
        p1:CreateSound("rbxassetid://13158735106", 0.25, 1.5, true, 10)
        if p1:_AnimationWait(script.Name, p2, 1.7 / p3) then
            p1:CreateSound("rbxassetid://13158735106", 0.25, 1.25, true, 10)
        end
    else
        return
    end
end