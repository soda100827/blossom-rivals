return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 1.3 / p3) then
        p1:CreateSound("rbxassetid://13169152449", 0.5, 1.5, true, 10)
        if p1:_AnimationWait(script.Name, p2, 1 / p3) then
            p1:CreateSound("rbxassetid://13158735106", 0.25, 1.5, true, 10)
            if p1:_AnimationWait(script.Name, p2, 0.6 / p3) then
                p1:CreateSound("rbxassetid://13158735106", 0.25, 1.25, true, 10)
                if p1:_AnimationWait(script.Name, p2, 0.45 / p3) then
                    p1:CreateSound("rbxassetid://13160400937", 1, 1.4 + 0.2 * math.random(), true, 10)
                    if p1:_AnimationWait(script.Name, p2, 1.25 / p3) then
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
end