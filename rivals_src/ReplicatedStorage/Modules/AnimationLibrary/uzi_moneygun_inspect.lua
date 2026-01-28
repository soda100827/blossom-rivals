return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 1.25 / p3) then
        p1:CreateSound("rbxassetid://13158735106", 0.25, 1.5, true, 10)
        if p1:_AnimationWait(script.Name, p2, 1.4 / p3) then
            p1:CreateSound("rbxassetid://13236026280", 0.5, 1.5, true, 10)
            if p1:_AnimationWait(script.Name, p2, 2.1 / p3) then
                p1:CreateSound("rbxassetid://13236026280", 0.5, 1, true, 10)
                if p1:_AnimationWait(script.Name, p2, 0.6 / p3) then
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