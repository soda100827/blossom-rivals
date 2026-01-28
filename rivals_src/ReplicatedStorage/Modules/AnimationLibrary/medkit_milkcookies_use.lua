return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 1.4 / p3) then
        p1:CreateSound("rbxassetid://92914419322840", 1, 1 + 0.1 * math.random(), true, 10)
        if p1:_AnimationWait(script.Name, p2, 0.3 / p3) then
            p1:CreateSound("rbxassetid://92914419322840", 0.875, 1 + 0.1 * math.random(), true, 10)
            if p1:_AnimationWait(script.Name, p2, 1.1 / p3) then
                p1:CreateSound("rbxassetid://18128896162", 1, 1 + 0.25 * math.random(), true, 10)
                if p1:_AnimationWait(script.Name, p2, 0.4 / p3) then
                    p1:CreateSound("rbxassetid://78700624599503", 1.25, 1 + 0.1 * math.random(), true, 10)
                    if p1:_AnimationWait(script.Name, p2, 1 / p3) then
                        for v4 = 1, 5 do
                            p1:CreateSound("rbxassetid://18128896325", 1 - 0.15 * v4, 1 + 0.1 * v4, true, 10)
                            if not p1:_AnimationWait(script.Name, p2, 0.1 / p3) then
                                return
                            end
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