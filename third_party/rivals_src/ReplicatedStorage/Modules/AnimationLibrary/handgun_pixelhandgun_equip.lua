return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 0.15 / p3) then
        p1:CreateSound("rbxassetid://17650837861", 1, 2, true, 10)
        if p1:_AnimationWait(script.Name, p2, 0.1 / p3) then
            p1:CreateSound("rbxassetid://17650837861", 1, 1, true, 10)
        end
    else
        return
    end
end