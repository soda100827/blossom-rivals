return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 0.2 / p3) then
        p1:CreateSound("rbxassetid://71387264231358", 2.5, 1, true, 10)
        if p1:_AnimationWait(script.Name, p2, 0.2 / p3) then
            p1:CreateSound("rbxassetid://71387264231358", 1.5, 0.875, true, 10)
            if p1:_AnimationWait(script.Name, p2, 0.5 / p3) then
                p1:CreateSound("rbxassetid://13515046872", 0.75, 1, true, 10)
                p1:CreateSound("rbxassetid://90757583550672", 0.5, 3 + 0.25 * math.random(), true, 5)
            end
        else
            return
        end
    else
        return
    end
end