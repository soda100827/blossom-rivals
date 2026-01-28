return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 0.5 / p3) then
        p1:CreateSound("rbxassetid://107901458751913", 1.5, 2, true, 10)
        if p1:_AnimationWait(script.Name, p2, 0.75 / p3) then
            p1:CreateSound("rbxassetid://71608982627584", 1, 1, true, 10)
            if p1:_AnimationWait(script.Name, p2, 9.1 / p3) then
                p1:CreateSound("rbxassetid://107901458751913", 1.5, 1.5, true, 10)
            end
        else
            return
        end
    else
        return
    end
end