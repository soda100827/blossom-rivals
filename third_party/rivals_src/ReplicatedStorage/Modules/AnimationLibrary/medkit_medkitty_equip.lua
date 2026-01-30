return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 0.375 / p3) then
        p1:CreateSound("rbxassetid://134160823775126", 0.5, 1, true, 10)
        if p1:_AnimationWait(script.Name, p2, 0.75 / p3) then
            p1:CreateSound("rbxassetid://128990235337969", 0.75, 0.75, true, 10)
        end
    else
        return
    end
end