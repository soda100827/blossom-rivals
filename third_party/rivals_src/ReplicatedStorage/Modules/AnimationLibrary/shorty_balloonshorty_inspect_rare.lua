return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 2.5 / p3) then
        p1:CreateSound("rbxassetid://13158735106", 0.75, 2, true, 10)
        if p1:_AnimationWait(script.Name, p2, 1.1666666666666667 / p3) then
            p1:CreateSound("rbxassetid://13456860578", 1.5, 1.5, true, 10)
            if p1:_AnimationWait(script.Name, p2, 0.75 / p3) then
                p1:CreateSound("rbxassetid://17803360572", 1, 2, true, 10)
            end
        else
            return
        end
    else
        return
    end
end