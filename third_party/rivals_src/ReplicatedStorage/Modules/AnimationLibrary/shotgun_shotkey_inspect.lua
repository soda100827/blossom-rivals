return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 1.85 / p3) then
        p1:CreateSound("rbxassetid://71387264231358", 2.5, 1.25, true, 10)
        if p1:_AnimationWait(script.Name, p2, 0.31 / p3) then
            p1:CreateSound("rbxassetid://13236026280", 0.625, 2, true, 10)
            if p1:_AnimationWait(script.Name, p2, 2.84 / p3) then
                p1:CreateSound("rbxassetid://71387264231358", 2.5, 0.875, true, 10)
                if p1:_AnimationWait(script.Name, p2, 0.4 / p3) then
                    p1:CreateSound("rbxassetid://13236026280", 0.5, 1.75, true, 10)
                end
            else
                return
            end
        else
            return
        end
    else
        return
    end
end