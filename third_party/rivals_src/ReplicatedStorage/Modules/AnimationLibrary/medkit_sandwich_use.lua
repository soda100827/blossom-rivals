return function(p1, p2, p3)
    p1:CreateSound("rbxassetid://13158735106", 0.25, 1.5, true, 10)
    if p1:_AnimationWait(script.Name, p2, 1.4 / p3) then
        p1:CreateSound("rbxassetid://18128896162", 1, 1 + 0.25 * math.random(), true, 10)
        if p1:_AnimationWait(script.Name, p2, 0.95 / p3) then
            p1:CreateSound("rbxassetid://18128896162", 1, 1 + 0.25 * math.random(), true, 10)
            if p1:_AnimationWait(script.Name, p2, 0.56 / p3) then
                p1:CreateSound("rbxassetid://18128896162", 1, 1 + 0.25 * math.random(), true, 10)
                if p1:_AnimationWait(script.Name, p2, 0.29 / p3) then
                    p1:CreateSound("rbxassetid://18128896162", 0.5, 1 + 0.25 * math.random(), true, 10)
                    if p1:_AnimationWait(script.Name, p2, 0.8 / p3) then
                        if math.random() < 0.628 then
                            p1:CreateSound("rbxassetid://18128949754", 0.6, 1 + 0.1 * math.random(), true, 10)
                        end
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