return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 1.1 / p3) then
        p1:CreateSound("rbxassetid://13456860578", 1, 1, true, 10)
        p1:CreateSound("rbxassetid://13160326139", 0.25, 1, true, 10)
        if p1:_AnimationWait(script.Name, p2, 1.01 / p3) then
            p1:CreateSound("rbxassetid://13456860532", 1, 1.1, true, 10)
            p1:CreateSound("rbxassetid://13160326139", 0.25, 1, true, 10)
            if p1:_AnimationWait(script.Name, p2, 0.4 / p3) then
                p1:CreateSound("rbxassetid://13160326139", 0.125, 1, true, 10)
            end
        else
            return
        end
    else
        return
    end
end