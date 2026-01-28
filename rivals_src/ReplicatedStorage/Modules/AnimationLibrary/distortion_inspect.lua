return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 2.2 / p3) then
        p1:CreateSound("rbxassetid://139955889483895", 0.75, 1.25, true, 10)
        if p1:_AnimationWait(script.Name, p2, 2.45 / p3) then
            p1:CreateSound("rbxassetid://139955889483895", 0.75, 1, true, 10)
            if p1:_AnimationWait(script.Name, p2, 0.1 / p3) then
                p1:CreateSound("rbxassetid://132926867312544", 0.25, 1.25, true, 10)
                if p1:_AnimationWait(script.Name, p2, 1 / p3) then
                    p1:CreateSound("rbxassetid://13158735106", 0.25, 1.5, true, 10)
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