return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 0.2 / p3) then
        p1:CreateSound("rbxassetid://18128895977", 1, 1, true, 10)
        if p1:_AnimationWait(script.Name, p2, 0.4 / p3) then
            p1:CreateSound("rbxassetid://18128896325", 1.25, 1, true, 10)
        end
    else
        return
    end
end