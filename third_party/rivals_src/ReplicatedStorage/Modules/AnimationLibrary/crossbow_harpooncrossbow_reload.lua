return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 0.78 / p3) then
        p1:CreateSound("rbxassetid://13456746131", 0.75, 2, true, 10)
        if p1:_AnimationWait(script.Name, p2, 0.25 / p3) then
            p1:CreateSound("rbxassetid://13456746075", 1, 1.75, true, 10)
        end
    else
        return
    end
end