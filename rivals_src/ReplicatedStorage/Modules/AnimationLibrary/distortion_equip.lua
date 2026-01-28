return function(p1, p2, p3)
    p1:CreateSound("rbxassetid://73931497990415", 0.75, 1 + 0.1 * math.random(), true, 10)
    if p1:_AnimationWait(script.Name, p2, 0.9 / p3) then
        p1:CreateSound("rbxassetid://13158735106", 0.125, 1.5, true, 10)
    end
end