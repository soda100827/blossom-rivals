return function(p1, p2, p3)
    p1:CreateSound("rbxassetid://14427935597", 0.75, 1.125, true, 10)
    if p1:_AnimationWait(script.Name, p2, 0.4666666666666667 / p3) then
        p1:CreateSound("rbxassetid://13160326139", 1, 1.25, true, 10)
    end
end