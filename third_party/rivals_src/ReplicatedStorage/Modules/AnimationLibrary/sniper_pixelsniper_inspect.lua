return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 0.2 / p3) then
        p1:CreateSound("rbxassetid://17650945056", 1, 1.5, true, 10)
        if p1:_AnimationWait(script.Name, p2, 1.1333333333333333 / p3) then
            p1:CreateSound("rbxassetid://17650945056", 1, 1, true, 10)
            if p1:_AnimationWait(script.Name, p2, 0.6666666666666666 / p3) then
                p1:CreateSound("rbxassetid://17650837861", 1, 3, true, 10)
                if p1:_AnimationWait(script.Name, p2, 0.2 / p3) then
                    p1:CreateSound("rbxassetid://17650837861", 1, 2, true, 10)
                    if p1:_AnimationWait(script.Name, p2, 0.7333333333333333 / p3) then
                        p1:CreateSound("rbxassetid://17650837861", 1, 2, true, 10)
                        if p1:_AnimationWait(script.Name, p2, 0.2 / p3) then
                            p1:CreateSound("rbxassetid://17650837861", 1, 3, true, 10)
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