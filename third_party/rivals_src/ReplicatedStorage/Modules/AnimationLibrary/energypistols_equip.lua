return function(p1, p2, p3)
    p1:CreateSound("rbxassetid://13456860578", 1.25, 1.5, true, 0.5 / p3)
    if p1:_AnimationWait(script.Name, p2, 0.5 / p3) then
        p1:CreateSound("rbxassetid://13483008798", 1, 2, true, 10)
    end
end