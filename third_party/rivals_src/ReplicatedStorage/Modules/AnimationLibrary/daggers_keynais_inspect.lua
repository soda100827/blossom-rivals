return function(p1, p2, p3)
    p1:CreateSound("rbxassetid://71387264231358", 1.25, 1, true, 10)
    if p1:_AnimationWait(script.Name, p2, 0.6 / p3) then
        p1:CreateSound("rbxassetid://13160326139", 0.375, 1.5, true, 10)
        if p1:_AnimationWait(script.Name, p2, 0.35 / p3) then
            p1:CreateSound("rbxassetid://13158735106", 0.25, 1.5, true, 10)
            if p1:_AnimationWait(script.Name, p2, 3.2 / p3) then
                p1:CreateSound("rbxassetid://96253147006478", 0.6, 1.25, true, 10)
                if p1:_AnimationWait(script.Name, p2, 0.25 / p3) then
                    p1:CreateSound("rbxassetid://96253147006478", 0.6, 1.5, true, 10)
                    if p1:_AnimationWait(script.Name, p2, 0.5 / p3) then
                        p1:CreateSound("rbxassetid://96253147006478", 0.6, 1.25, true, 10)
                        if p1:_AnimationWait(script.Name, p2, 0.35 / p3) then
                            p1:CreateSound("rbxassetid://96253147006478", 0.6, 1, true, 10)
                            if p1:_AnimationWait(script.Name, p2, 0.45 / p3) then
                                p1:CreateSound("rbxassetid://93178963908825", 1, 1 + 0.25 * math.random(), true, 10)
                                p1:CreateSound("rbxassetid://96253147006478", 0.625, 1.75 + 0.5 * math.random(), true, 10)
                                if p1:_AnimationWait(script.Name, p2, 1.9 / p3) then
                                    p1:CreateSound("rbxassetid://71387264231358", 1.25, 1, true, 10)
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