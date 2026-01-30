return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 0.1 / p3) then
        p1:CreateSound("rbxassetid://17650945056", 1.25, 1.5, true, 10)
        p1:CreateSound("rbxassetid://17650837503", 1.25, 1, true, 10)
        if p1:_AnimationWait(script.Name, p2, 0.95 / p3) then
            p1:CreateSound("rbxassetid://17650945056", 1, 1, true, 10)
            p1:CreateSound("rbxassetid://17650837718", 1, 2, true, 10)
            if p1:_AnimationWait(script.Name, p2, 0.39 / p3) then
                p1:CreateSound("rbxassetid://17650838003", 2, 1.25, true, 10)
            end
        else
            return
        end
    else
        return
    end
end