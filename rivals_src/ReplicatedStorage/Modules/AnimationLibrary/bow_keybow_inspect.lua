return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 0.4 / p3) then
        p1:CreateSound("rbxassetid://110122962237431", 0.75, 1.25 + 0.25 * math.random(), true, 5)
        if p1:_AnimationWait(script.Name, p2, 0.6 / p3) then
            p1:CreateSound("rbxassetid://71387264231358", 1.25, 1.5, true, 10)
            p1:CreateSound("rbxassetid://13483008798", 0.5, 2, true, 10)
            if p1:_AnimationWait(script.Name, p2, 1.1 / p3) then
                p1:CreateSound("rbxassetid://71387264231358", 1.25, 1, true, 10)
                p1:CreateSound("rbxassetid://13483008798", 0.5, 1.75, true, 10)
                if p1:_AnimationWait(script.Name, p2, 1.45 / p3) then
                    p1:CreateSound("rbxassetid://13158735106", 0.25, 1.5, true, 10)
                    p1:CreateSound("rbxassetid://71387264231358", 1, 1, true, 10)
                    if p1:_AnimationWait(script.Name, p2, 1.45 / p3) then
                        p1:CreateSound("rbxassetid://13158735106", 0.25, 1.5, true, 10)
                        p1:CreateSound("rbxassetid://71387264231358", 1, 0.875, true, 10)
                        if p1:_AnimationWait(script.Name, p2, 0.3 / p3) then
                            p1:CreateSound("rbxassetid://71387264231358", 0.75, 1, true, 10)
                            if p1:_AnimationWait(script.Name, p2, 0.2 / p3) then
                                p1:CreateSound("rbxassetid://71387264231358", 0.5, 1.125, true, 10)
                                if p1:_AnimationWait(script.Name, p2, 0.4 / p3) then
                                    p1:CreateSound("rbxassetid://110122962237431", 0.5, 1 + 0.25 * math.random(), true, 5)
                                    if p1:_AnimationWait(script.Name, p2, 0.45 / p3) then
                                        p1:CreateSound("rbxassetid://13158735106", 0.25, 1.5, true, 10)
                                        if p1:_AnimationWait(script.Name, p2, 1.9 / p3) then
                                            p1:CreateSound("rbxassetid://13158735106", 0.25, 1.5, true, 10)
                                            p1:CreateSound("rbxassetid://71387264231358", 1, 0.75, true, 10)
                                            if p1:_AnimationWait(script.Name, p2, 0.35 / p3) then
                                                p1:CreateSound("rbxassetid://71387264231358", 0.75, 0.875, true, 10)
                                                if p1:_AnimationWait(script.Name, p2, 0.8 / p3) then
                                                    p1:CreateSound("rbxassetid://110122962237431", 0.75, 1 + 0.1 * math.random(), true, 5)
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