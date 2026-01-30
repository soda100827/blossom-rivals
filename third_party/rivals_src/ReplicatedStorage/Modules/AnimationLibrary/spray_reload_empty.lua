return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 0.45 / p3) then
        p1:CreateSound("rbxassetid://13158330555", 1, 1.25, true, 10)
        if p1:_AnimationWait(script.Name, p2, 0.35 / p3) then
            p1:CreateSound("rbxassetid://13456860578", 1, 1.25, true, 0.45 / p3)
            if p1:_AnimationWait(script.Name, p2, 0.7 / p3) then
                p1:CreateSound("rbxassetid://84163808107137", 1, 1, true, 10)
                if p1:_AnimationWait(script.Name, p2, 0.25 / p3) then
                    p1:CreateSound("rbxassetid://82721606455832", 1, 1, true, 10)
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