return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 0.8 / p3) then
        p1:CreateSound("rbxassetid://13158330666", 1, 1.4, true, 10)
        if p1:_AnimationWait(script.Name, p2, 1.63 / p3) then
            p1:CreateSound("rbxassetid://13158330666", 1, 1, true, 10)
            if p1:_AnimationWait(script.Name, p2, 1.03 / p3) then
                p1:CreateSound("rbxassetid://13907558696", 1, 1, true, 10)
                if p1:_AnimationWait(script.Name, p2, 0.66 / p3) then
                    p1:CreateSound("rbxassetid://13907558634", 1, 1, true, 10)
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