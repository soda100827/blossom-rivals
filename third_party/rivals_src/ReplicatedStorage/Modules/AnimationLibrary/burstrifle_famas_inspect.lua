return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 1.25 / p3) then
        p1:CreateSound("rbxassetid://13158735106", 0.25, 1.5, true, 10)
        if p1:_AnimationWait(script.Name, p2, 1.1 / p3) then
            p1:CreateSound("rbxassetid://13455395017", 1, 0.75, true, 10)
            if p1:_AnimationWait(script.Name, p2, 0.5 / p3) then
                p1:CreateSound("rbxassetid://13455395017", 1, 1, true, 10)
                if p1:_AnimationWait(script.Name, p2, 0.4 / p3) then
                    p1:CreateSound("rbxassetid://13158735106", 0.25, 1.25, true, 10)
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