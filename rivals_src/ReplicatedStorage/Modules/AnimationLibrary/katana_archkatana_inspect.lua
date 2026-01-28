return function(p1, p2, p3)
    p1:CreateSound("rbxassetid://137232955524669", 1, 1 + 0.1 * math.random(), true, 10)
    if p1:_AnimationWait(script.Name, p2, 4.55 / p3) then
        p1:CreateSound("rbxassetid://13158735106", 0.75, 1.75, true, 10)
        if p1:_AnimationWait(script.Name, p2, 1.4 / p3) then
            p1:CreateSound("rbxassetid://13158735106", 0.75, 1.25, true, 10)
        end
    else
        return
    end
end