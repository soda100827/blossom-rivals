return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 0.175 / p3) then
        p1:CreateSound("rbxassetid://14522189766", 2, 1 + 0.25 * math.random(), true, 10)
        p1:CreateSound("rbxassetid://96253147006478", 0.6, 1.75, true, 10)
    end
end