return function(p1, p2, p3)
    p1:CreateSound("rbxassetid://107901458751913", 1.5, 2, true, 10)
    if p1:_AnimationWait(script.Name, p2, 0.4 / p3) then
        p1:CreateSound("rbxassetid://134279576638277", 1.25, 2, true, 10)
    end
end