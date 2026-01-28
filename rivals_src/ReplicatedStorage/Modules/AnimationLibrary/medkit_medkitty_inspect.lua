return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 0.65 / p3) then
        p1:CreateSound("rbxassetid://92941076104902", 1, 0.75, true, 10)
        if p1:_AnimationWait(script.Name, p2, 1.1 / p3) then
            p1:CreateSound("rbxassetid://128990235337969", 1.5, 1, true, 10)
        end
    else
        return
    end
end