return function(p1, p2, p3)
    p1:CreateSound("rbxassetid://13158735106", 0.25, 0.5, true, 10)
    if p1:_AnimationWait(script.Name, p2, 0.4 / p3) then
        p1:CreateSound("rbxassetid://13236549929", 1, 0.75, true, 10)
        if p1:_AnimationWait(script.Name, p2, 0.8 / p3) then
            p1:CreateSound("rbxassetid://13236549962", 1, 0.875, true, 10)
        end
    else
        return
    end
end