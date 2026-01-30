return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 1.55 / p3) then
        p1:CreateSound("rbxassetid://13456860578", 0.75, 1, true, 10)
        if p1:_AnimationWait(script.Name, p2, 0.4 / p3) then
            p1:CreateSound("rbxassetid://13160326139", 0.25, 1, true, 10)
            p1:CreateSound("rbxassetid://13456860578", 0.5, 1.25, true, 10)
            if p1:_AnimationWait(script.Name, p2, 1 / p3) then
                p1:CreateSound("rbxassetid://13456860578", 0.5, 1, true, 10)
                if p1:_AnimationWait(script.Name, p2, 0.58 / p3) then
                    p1:CreateSound("rbxassetid://13160326139", 0.175, 1, true, 10)
                    if p1:_AnimationWait(script.Name, p2, 0.42 / p3) then
                        p1:CreateSound("rbxassetid://13160326139", 0.125, 0.75, true, 10)
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