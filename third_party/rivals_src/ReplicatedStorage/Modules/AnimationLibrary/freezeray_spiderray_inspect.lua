return function(p1, p2, p3)
    p1:CreateSound("rbxassetid://119827986766384", 0.75, 1, true, 10)
    if p1:_AnimationWait(script.Name, p2, 1 / p3) then
        p1:CreateSound("rbxassetid://119827986766384", 0.5, 0.75, true, 10)
        if p1:_AnimationWait(script.Name, p2, 1 / p3) then
            p1:CreateSound("rbxassetid://119827986766384", 0.375, 0.5, true, 10)
        end
    else
        return
    end
end