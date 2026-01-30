return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 0.56 / p3) then
        p1:CreateSound("rbxassetid://17803360572", 1, 2, true, 10)
        if p1:_AnimationWait(script.Name, p2, 0.19 / p3) then
            p1:CreateSound("rbxassetid://17803360572", 1, 1.25, true, 10)
        end
    else
        return
    end
end