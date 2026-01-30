return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 0.15 / p3) then
        p1:CreateSound("rbxassetid://112097244349559", 1, 1, true, 10)
        if p1:_AnimationWait(script.Name, p2, 1.25 / p3) then
            p1:CreateSound("rbxassetid://13158735106", 0.25, 1.5, true, 10)
            if p1:_AnimationWait(script.Name, p2, 1.3 / p3) then
                p1:CreateSound("rbxassetid://13158735106", 0.2, 1.375, true, 10)
                if p1:_AnimationWait(script.Name, p2, 1.3 / p3) then
                    p1:CreateSound("rbxassetid://13158735106", 0.15, 1.25, true, 10)
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