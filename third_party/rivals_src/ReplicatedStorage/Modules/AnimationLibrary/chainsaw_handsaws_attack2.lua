return function(p1, p2, p3)
    p1:CreateSound("rbxassetid://13682898881", 1, 0.95 + 0.1 * math.random(), true, 10)
    p1:CreateSound("rbxassetid://13682223944", 0.75, 1 + 0.5 * math.random(), true, 10)
    if p1:_AnimationWait(script.Name, p2, 0.25 / p3) then
        p1:CreateSound("rbxassetid://13682898881", 1, 0.95 + 0.1 * math.random(), true, 10)
        p1:CreateSound("rbxassetid://13682223944", 0.75, 1 + 0.5 * math.random(), true, 10)
    end
end