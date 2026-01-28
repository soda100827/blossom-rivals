return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 0.2 / p3) then
        p1:CreateSound("rbxassetid://134160823775126", 1.25, 1.5, true, 10)
        if p1:_AnimationWait(script.Name, p2, 0.2 / p3) then
            p1:CreateSound("rbxassetid://85750875050391", 1.25, 1, true, 10)
        end
    else
        return
    end
end