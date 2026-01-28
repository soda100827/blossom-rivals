return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 2.7 / p3) then
        p1:CreateSound("rbxassetid://13158735106", 0.25, 1.5, true, 10)
        if p1:_AnimationWait(script.Name, p2, 0.25 / p3) then
            p1:CreateSound("rbxassetid://13158735106", 0.125, 1.25, true, 10)
            if p1:_AnimationWait(script.Name, p2, 1 / p3) then
                p1:CreateSound("rbxassetid://106994976644858", 0.75, 2, true, 10)
                if p1:_AnimationWait(script.Name, p2, 0.4 / p3) then
                    p1:CreateSound("rbxassetid://106994976644858", 0.625, 2.25, true, 10)
                    if p1:_AnimationWait(script.Name, p2, 0.35 / p3) then
                        p1:CreateSound("rbxassetid://106994976644858", 0.5, 2.5, true, 10)
                        if p1:_AnimationWait(script.Name, p2, 0.45 / p3) then
                            p1:CreateSound("rbxassetid://106994976644858", 0.75, 1.5, true, 10)
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
        else
            return
        end
    else
        return
    end
end