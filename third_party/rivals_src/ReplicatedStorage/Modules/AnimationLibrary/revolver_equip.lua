return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 0.25 / p3) then
        p1:CreateSound("rbxassetid://13483008798", 0.5, 2, true, 10)
    end
end