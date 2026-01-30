return function(p1, p2, p3)
    p1:CreateSound("rbxassetid://13158735106", 0.25, 0.5, true, 10)
    if p1:_AnimationWait(script.Name, p2, 0.94 / p3) then
        p1:CreateSound("rbxassetid://13236549929", 1, 0.875, true, 10)
        if p1:_AnimationWait(script.Name, p2, 0.86 / p3) then
            p1:CreateSound("rbxassetid://13236549962", 1, 1, true, 10)
            if p1:_AnimationWait(script.Name, p2, 0.87 / p3) then
                p1:CreateSound("rbxassetid://13455395017", 1, 0.75, true, 10)
                if p1:_AnimationWait(script.Name, p2, 0.3 / p3) then
                    p1:CreateSound("rbxassetid://13455395017", 1, 1, true, 10)
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