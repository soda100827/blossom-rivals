return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 0.2 / p3) then
        p1:CreateSound("rbxassetid://13456860578", 1.5, 1.25, true, 10)
        if p1:_AnimationWait(script.Name, p2, 0.35 / p3) then
            p1:CreateSound("rbxassetid://13456860578", 1.25, 1.5, true, 10)
            if p1:_AnimationWait(script.Name, p2, 0.45 / p3) then
                p1:CreateSound("rbxassetid://13483008798", 1, 2, true, 10)
                if p1:_AnimationWait(script.Name, p2, 3.95 / p3) then
                    p1:CreateSound("rbxassetid://13456860578", 1.5, 1.5, true, 10)
                    if p1:_AnimationWait(script.Name, p2, 0.45 / p3) then
                        p1:CreateSound("rbxassetid://13483008798", 1.25, 2.5, true, 10)
                        if p1:_AnimationWait(script.Name, p2, 0.25 / p3) then
                            p1:CreateSound("rbxassetid://13456860578", 1.25, 1.25, true, 10)
                            if p1:_AnimationWait(script.Name, p2, 0.41 / p3) then
                                p1:CreateSound("rbxassetid://13483008798", 1, 2, true, 10)
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