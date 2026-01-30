return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 2.2 / p3) then
        p1:CreateSound("rbxassetid://17274387490", 0.375, 1, true, 10)
        if p1:_AnimationWait(script.Name, p2, 0.7 / p3) then
            p1:CreateSound("rbxassetid://17274387490", 0.25, 0.9, true, 10)
            if p1:_AnimationWait(script.Name, p2, 0.25 / p3) then
                p1:CreateSound("rbxassetid://13158735106", 0.25, 1.5, true, 10)
                if p1:_AnimationWait(script.Name, p2, 1.6 / p3) then
                    p1:CreateSound("rbxassetid://13158735106", 0.2, 1.25, true, 10)
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