return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 2.6 / p3) then
        p1:CreateSound("rbxassetid://14427935597", 0.5, 1.25, true, 10)
        if p1:_AnimationWait(script.Name, p2, 0.58 / p3) then
            p1:CreateSound("rbxassetid://13160326139", 0.75, 1.5, true, 10)
        end
    else
        return
    end
end