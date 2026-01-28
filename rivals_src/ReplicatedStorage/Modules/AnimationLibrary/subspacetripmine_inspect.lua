return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 2.05 / p3) then
        p1:CreateSound("rbxassetid://13158735106", 0.25, 1.5, true, 10)
        if p1:_AnimationWait(script.Name, p2, 1.95 / p3) then
            p1:CreateSound("rbxassetid://13158735106", 0.125, 1, true, 10)
            if p1:_AnimationWait(script.Name, p2, 0.6 / p3) then
                p1:CreateSound("rbxassetid://11956590", 0.375, 1.5, true, 10)
                if p1:_AnimationWait(script.Name, p2, 0.4 / p3) then
                    p1:CreateSound("rbxassetid://13158735106", 0.25, 1.5, true, 10)
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