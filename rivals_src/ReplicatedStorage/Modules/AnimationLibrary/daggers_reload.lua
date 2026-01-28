return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 0.1 / p3) then
        p1:CreateSound("rbxassetid://99837158417289", 0.875, 1.25, true, 10)
        if p1:_AnimationWait(script.Name, p2, 0.1 / p3) then
            p1:CreateSound("rbxassetid://99837158417289", 0.5, 1.5, true, 10)
        end
    else
        return
    end
end