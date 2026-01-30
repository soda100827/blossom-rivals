return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 0.35 / p3) then
        p1:CreateSound("rbxassetid://127707586685295", 1, 1 + 0.2 * math.random(), true, 5)
    end
end