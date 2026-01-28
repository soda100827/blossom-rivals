return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 1.9 / p3) then
        p1:CreateSound("rbxassetid://13456860578", 0.25, 2, true, 10)
        p1:CreateSound("rbxassetid://14427935597", 0.375, 1, true, 10)
        if p1:_AnimationWait(script.Name, p2, 0.4 / p3) then
            p1:CreateSound("rbxassetid://13160326139", 0.75, 1.25, true, 10)
        end
    else
        return
    end
end