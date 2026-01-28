return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 0.85 / p3) then
        p1:CreateSound("rbxassetid://13682532502", 0.25, 1.5, true, 10)
        if p1:_AnimationWait(script.Name, p2, 1.4 / p3) then
            p1:CreateSound("rbxassetid://76155503538875", 0.375, 1.75, true, 10)
        end
    else
        return
    end
end