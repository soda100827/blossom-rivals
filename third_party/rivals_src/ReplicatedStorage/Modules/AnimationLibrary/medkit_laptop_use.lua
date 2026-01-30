return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 0.5 / p3) then
        p1:CreateSound("rbxassetid://107901458751913", 1.5, 2, true, 10)
        if p1:_AnimationWait(script.Name, p2, 1.5 / p3) then
            p1:CreateSound("rbxassetid://92573395473684", 1.25, 1, true, 10)
        end
    else
        return
    end
end