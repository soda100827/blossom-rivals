return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 2 / p3) then
        p1:CreateSound("rbxassetid://71387264231358", 1.25, 1.5, true, 10)
        p1:CreateSound("rbxassetid://110122962237431", 0.5, 0.75 + 0.25 * math.random(), true, 5)
        if p1:_AnimationWait(script.Name, p2, 1.4 / p3) then
            p1:CreateSound("rbxassetid://75549206431714", 1, 1.25, true, 10)
            p1:CreateSound("rbxassetid://110122962237431", 0.5, 2 + 0.5 * math.random(), true, 5)
            p1:CreateSound("rbxassetid://110122962237431", 0.25, 0.75 + 0.25 * math.random(), true, 5)
            if p1:_AnimationWait(script.Name, p2, 0.3 / p3) then
                p1:CreateSound("rbxassetid://75549206431714", 1, 1, true, 10)
                p1:CreateSound("rbxassetid://110122962237431", 0.5, 2 + 0.5 * math.random(), true, 5)
                p1:CreateSound("rbxassetid://110122962237431", 0.25, 0.75 + 0.25 * math.random(), true, 5)
                if p1:_AnimationWait(script.Name, p2, 0.3 / p3) then
                    p1:CreateSound("rbxassetid://75549206431714", 1, 1.25, true, 10)
                    p1:CreateSound("rbxassetid://110122962237431", 0.5, 2 + 0.5 * math.random(), true, 5)
                    p1:CreateSound("rbxassetid://110122962237431", 0.25, 0.75 + 0.25 * math.random(), true, 5)
                    if p1:_AnimationWait(script.Name, p2, 0.4 / p3) then
                        p1:CreateSound("rbxassetid://75549206431714", 1, 1.15, true, 10)
                        p1:CreateSound("rbxassetid://110122962237431", 0.5, 2 + 0.5 * math.random(), true, 5)
                        p1:CreateSound("rbxassetid://110122962237431", 0.25, 0.75 + 0.25 * math.random(), true, 5)
                        if p1:_AnimationWait(script.Name, p2, 0.35 / p3) then
                            p1:CreateSound("rbxassetid://75549206431714", 1, 1.4, true, 10)
                            p1:CreateSound("rbxassetid://110122962237431", 0.5, 2 + 0.5 * math.random(), true, 5)
                            p1:CreateSound("rbxassetid://110122962237431", 0.25, 0.75 + 0.25 * math.random(), true, 5)
                            if p1:_AnimationWait(script.Name, p2, 0.2 / p3) then
                                if p1:_AnimationWait(script.Name, p2, 0.5 / p3) then
                                    p1:CreateSound("rbxassetid://75549206431714", 1, 1.25, true, 10)
                                    p1:CreateSound("rbxassetid://110122962237431", 0.5, 2 + 0.5 * math.random(), true, 5)
                                    p1:CreateSound("rbxassetid://110122962237431", 0.25, 0.75 + 0.25 * math.random(), true, 5)
                                    if p1:_AnimationWait(script.Name, p2, 0.3 / p3) then
                                        p1:CreateSound("rbxassetid://71387264231358", 1.25, 0.75, true, 10)
                                        p1:CreateSound("rbxassetid://110122962237431", 0.5, 0.75 + 0.25 * math.random(), true, 5)
                                        if p1:_AnimationWait(script.Name, p2, 1.3 / p3) then
                                            p1:CreateSound("rbxassetid://110122962237431", 0.75, 1.5 + 0.25 * math.random(), true, 5)
                                            if p1:_AnimationWait(script.Name, p2, 0.5 / p3) then
                                                p1:CreateSound("rbxassetid://13158735106", 0.25, 1.5, true, 10)
                                                if p1:_AnimationWait(script.Name, p2, 0.7 / p3) then
                                                    p1:CreateSound("rbxassetid://71387264231358", 1.25, 1.5, true, 10)
                                                    p1:CreateSound("rbxassetid://13483008798", 0.5, 2.25, true, 10)
                                                    if p1:_AnimationWait(script.Name, p2, 0.45 / p3) then
                                                        p1:CreateSound("rbxassetid://110122962237431", 0.5, 1.75 + 0.25 * math.random(), true, 5)
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