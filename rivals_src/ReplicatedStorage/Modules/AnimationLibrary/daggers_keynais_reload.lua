return function(p1, p2, p3)
    p1:CreateSound("rbxassetid://96253147006478", 0.3, 2.5 + 0.5 * math.random(), true, 10)
    if p1:_AnimationWait(script.Name, p2, 0.1 / p3) then
        p1:CreateSound("rbxassetid://96253147006478", 0.3, 2.5 + 0.5 * math.random(), true, 10)
    end
end