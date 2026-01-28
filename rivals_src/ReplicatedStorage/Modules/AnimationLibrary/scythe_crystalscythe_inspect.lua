return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 1.95 / p3) then
        p1:CreateSound("rbxassetid://13158735106", 0.25, 1.5, true, 10)
        if p1:_AnimationWait(script.Name, p2, 1.1 / p3) then
            p1:CreateSound("rbxassetid://13158735106", 0.25, 1.5, true, 10)
            if p1:_AnimationWait(script.Name, p2, 0.9 / p3) then
                p1:CreateSound("rbxassetid://13158735106", 0.25, 1.5, true, 10)
                if p1:_AnimationWait(script.Name, p2, 0.35 / p3) then
                    p1:CreateSound("rbxassetid://134472359434980", 0.5, 1, true, 10)
                    if p1:_AnimationWait(script.Name, p2, 0.5 / p3) then
                        p1:CreateSound("rbxassetid://134472359434980", 0.4, 1.25, true, 10)
                        if p1:_AnimationWait(script.Name, p2, 0.375 / p3) then
                            p1:CreateSound("rbxassetid://134472359434980", 0.3, 1.5, true, 10)
                            if p1:_AnimationWait(script.Name, p2, 0.775 / p3) then
                                p1:CreateSound("rbxassetid://13160326139", 0.375, 1, true, 10)
                                if p1:_AnimationWait(script.Name, p2, 0.7 / p3) then
                                    p1:CreateSound("rbxassetid://108380234827963", 0.5, 1.75 + 0.25 * math.random(), true, 10)
                                    if p1:_AnimationWait(script.Name, p2, 0.75 / p3) then
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