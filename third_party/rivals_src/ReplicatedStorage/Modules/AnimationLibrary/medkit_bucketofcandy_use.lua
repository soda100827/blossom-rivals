return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 0.35 / p3) then
        p1:CreateSound("rbxassetid://125248293081026", 1, 1, true, 10)
        if p1:_AnimationWait(script.Name, p2, 1.3 / p3) then
            p1:CreateSound("rbxassetid://110013540349061", 1, 1, true, 10)
            if p1:_AnimationWait(script.Name, p2, 0.7 / p3) then
                p1:CreateSound("rbxassetid://125248293081026", 1, 1, true, 10)
                if p1:_AnimationWait(script.Name, p2, 0.75 / p3) then
                    p1:CreateSound("rbxassetid://96411310492226", 1, 1, true, 10)
                    if p1:_AnimationWait(script.Name, p2, 1 / p3) then
                        p1:CreateSound("rbxassetid://92333760834779", 0.5, 1, true, 10)
                        if p1:_AnimationWait(script.Name, p2, 0.25 / p3) then
                            p1:CreateSound("rbxassetid://127123065378139", 1, 1, true, 10)
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