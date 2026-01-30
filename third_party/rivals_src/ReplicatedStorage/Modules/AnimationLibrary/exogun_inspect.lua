return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 1 / p3) then
        p1:CreateSound("rbxassetid://13158735106", 0.15, 1.5, true, 10)
        if p1:_AnimationWait(script.Name, p2, 1.8 / p3) then
            p1:CreateSound("rbxassetid://13158735106", 0.1, 1.25, true, 10)
        end
    else
        return
    end
end