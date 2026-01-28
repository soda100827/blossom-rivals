return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 0.85 / p3) then
        p1:CreateSound("rbxassetid://17650837861", 0.75, 0.5, true, 10)
        if p1:_AnimationWait(script.Name, p2, 1.4 / p3) then
            p1:CreateSound("rbxassetid://84676580117737", 0.5, 0.625, true, 10)
        end
    else
        return
    end
end