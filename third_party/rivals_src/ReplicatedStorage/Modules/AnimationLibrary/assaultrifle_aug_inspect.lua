return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 1.1 / p3) then
        p1:CreateSound("rbxassetid://13236549929", 1, 0.875, true, 10)
        if p1:_AnimationWait(script.Name, p2, 2.05 / p3) then
            p1:CreateSound("rbxassetid://13236549929", 1, 1, true, 10)
            if p1:_AnimationWait(script.Name, p2, 0.7 / p3) then
                p1:CreateSound("rbxassetid://13455395017", 1, 0.75, true, 10)
                if p1:_AnimationWait(script.Name, p2, 0.7 / p3) then
                    p1:CreateSound("rbxassetid://13455395017", 1, 1.1, true, 10)
                end
            else
                return
            end
        else
            return
        end
    else
        return
    end
end