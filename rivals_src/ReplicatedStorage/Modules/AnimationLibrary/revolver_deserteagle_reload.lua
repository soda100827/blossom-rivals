return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 0.13333333333333333 / p3) then
        p1:CreateSound("rbxassetid://13158330555", 1, 1, true, 10)
        if p1:_AnimationWait(script.Name, p2, 0.9166666666666666 / p3) then
            p1:CreateSound("rbxassetid://13158330666", 1, 1, true, 10)
            if p1:_AnimationWait(script.Name, p2, 0.5166666666666667 / p3) then
                p1:CreateSound("rbxassetid://13158330383", 1, 1, true, 10)
            end
        else
            return
        end
    else
        return
    end
end