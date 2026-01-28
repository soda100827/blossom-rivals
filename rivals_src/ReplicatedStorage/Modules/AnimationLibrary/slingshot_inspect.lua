return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 2.5 / p3) then
        p1:CreateSound("rbxassetid://13682532502", 1, 1.5, true, 10)
        if p1:_AnimationWait(script.Name, p2, 0.5 / p3) then
            p1:CreateSound("rbxassetid://13682532502", 0.5, 2, true, 10)
        end
    else
        return
    end
end