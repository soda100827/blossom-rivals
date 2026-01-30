return function(p1, p2, p3)
    p1:CreateSound("rbxassetid://13158735106", 0.25, 1.75, true, 10)
    if p1:_AnimationWait(script.Name, p2, 0.35 / p3) then
        p1:CreateSound("rbxassetid://17123622923", 2, 1, true, 10)
    end
end