return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 0.2 / p3) then
        p1:CreateSound("rbxassetid://134472359434980", 0.5, 1, true, 10)
        if p1:_AnimationWait(script.Name, p2, 0.5 / p3) then
            p1:CreateSound("rbxassetid://134472359434980", 0.4, 1.25, true, 10)
        end
    else
        return
    end
end