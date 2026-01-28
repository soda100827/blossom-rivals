return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 0.125 / p3) then
        p1:CreateSound("rbxassetid://17803360572", 1, 3, true, 10)
    end
end