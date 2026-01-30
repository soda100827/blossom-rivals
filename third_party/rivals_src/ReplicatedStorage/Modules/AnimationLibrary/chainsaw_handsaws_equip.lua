return function(p1, p2, p3)
    p1:CreateSound("rbxassetid://13645858977", 1, 1.25, true, 10)
    if p1:_AnimationWait(script.Name, p2, 0.1 / p3) then
        p1:CreateSound("rbxassetid://13645858977", 1, 1.375, true, 10)
    end
end