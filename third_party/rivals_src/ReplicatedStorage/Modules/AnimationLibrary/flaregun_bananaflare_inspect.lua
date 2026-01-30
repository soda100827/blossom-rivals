return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 2.4 / p3) then
        p1:CreateSound("rbxassetid://13456860578", 1, 1.5, true, 10)
        if p1:_AnimationWait(script.Name, p2, 0.5 / p3) then
            p1:CreateSound("rbxassetid://13160326139", 0.5, 1.5, true, 10)
        end
    else
        return
    end
end