return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 0.3333333333333333 / p3) then
        p1:CreateSound("rbxassetid://13160489311", 1, 1, true, 10)
        if p1:_AnimationWait(script.Name, p2, 0.55 / p3) then
            p1:CreateSound("rbxassetid://13160489311", 0.5, 0.75, true, 10)
        end
    else
        return
    end
end