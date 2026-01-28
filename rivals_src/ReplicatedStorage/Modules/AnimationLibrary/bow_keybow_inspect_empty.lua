return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 1.05 / p3) then
        p1:CreateSound("rbxassetid://71387264231358", 1.25, 1.5, true, 10)
        p1:CreateSound("rbxassetid://13483008798", 0.5, 2, true, 10)
        if p1:_AnimationWait(script.Name, p2, 1 / p3) then
            p1:CreateSound("rbxassetid://71387264231358", 1.25, 1, true, 10)
            p1:CreateSound("rbxassetid://13483008798", 0.5, 1.75, true, 10)
        end
    else
        return
    end
end