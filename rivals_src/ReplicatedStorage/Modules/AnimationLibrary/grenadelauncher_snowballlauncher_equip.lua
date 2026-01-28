return function(p1, p2, p3)
    p1:CreateSound("rbxassetid://18429138544", 0.5, 1, true, 10)
    if p1:_AnimationWait(script.Name, p2, 0.3 / p3) then
        p1:CreateSound("rbxassetid://17274369044", 0.375, 1, true, 10)
    end
end