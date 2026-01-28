return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 0.2 / p3) then
        p1:CreateSound("rbxassetid://13483008798", 1, 2, true, 10)
        p1:CreateSound("rbxassetid://14240943641", 1, 1, true, 10)
        if p1:_AnimationWait(script.Name, p2, 0.55 / p3) then
            p1:CreateSound("rbxassetid://14240944488", 0.75, 1, true, 10)
            if p1:_AnimationWait(script.Name, p2, 1.1 / p3) then
                p1:CreateSound("rbxassetid://14240944327", 1, 1, true, 10)
                if p1:_AnimationWait(script.Name, p2, 0.7 / p3) then
                    p1:CreateSound("rbxassetid://13483008798", 1, 1.5, true, 10)
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