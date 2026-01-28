return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 2.7 / p3) then
        p1:CreateSound("rbxassetid://13158735106", 0.25, 1.5, true, 10)
        if p1:_AnimationWait(script.Name, p2, 0.25 / p3) then
            p1:CreateSound("rbxassetid://13158735106", 0.125, 1.25, true, 10)
            if p1:_AnimationWait(script.Name, p2, 1 / p3) then
                p1:CreateSound("rbxassetid://17640978498", 0.75, 1.3, true, 10)
                if p1:_AnimationWait(script.Name, p2, 0.4 / p3) then
                    p1:CreateSound("rbxassetid://17640978498", 0.625, 1.35, true, 10)
                    if p1:_AnimationWait(script.Name, p2, 0.35 / p3) then
                        p1:CreateSound("rbxassetid://17640978498", 0.4, 1.4, true, 10)
                        if p1:_AnimationWait(script.Name, p2, 0.45 / p3) then
                            p1:CreateSound("rbxassetid://17640978498", 1, 1, true, 10)
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