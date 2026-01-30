return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 1.75 / p3) then
        p1:CreateSound("rbxassetid://13158735106", 0.25, 1.5, true, 10)
        if p1:_AnimationWait(script.Name, p2, 0.5 / p3) then
            p1:CreateSound("rbxassetid://13515046921", 1, 1.25, true, 10)
            if p1:_AnimationWait(script.Name, p2, 1.25 / p3) then
                p1:CreateSound("rbxassetid://13515046988", 1, 1.25, true, 10)
                if p1:_AnimationWait(script.Name, p2, 0.6 / p3) then
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