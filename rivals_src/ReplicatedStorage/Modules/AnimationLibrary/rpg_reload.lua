return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 0.666 / p3) then
        p1:CreateSound("rbxassetid://13456746131", 0.75, 1.25, true, 10)
        if p1:_AnimationWait(script.Name, p2, 0.6 / p3) then
            p1:CreateSound("rbxassetid://13456746075", 1, 1, true, 10)
        end
    else
        return
    end
end