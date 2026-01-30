return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 0.5 / p3) then
        p1:CreateSound("rbxassetid://17650945056", 1, 1.5, true, 10)
        if p1:_AnimationWait(script.Name, p2, 0.92 / p3) then
            p1:CreateSound("rbxassetid://17650945056", 1, 1, true, 10)
        end
    else
        return
    end
end