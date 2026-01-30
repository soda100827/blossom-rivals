return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 0.3 / p3) then
        if p1:_AnimationWait(script.Name, p2, 0.3 / p3) then
            p1:CreateSound("rbxassetid://17092564046", 0.5, 1.75, true, 10)
            if p1:_AnimationWait(script.Name, p2, 0.6 / p3) then
                p1:CreateSound("rbxassetid://14427935597", 0.5, 0.75, true, 10)
                p1:CreateSound("rbxassetid://13456860578", 1.25, 1.25, true, 10)
                if p1:_AnimationWait(script.Name, p2, 0.95 / p3) then
                    p1:CreateSound("rbxassetid://17092564046", 0.75, 1, true, 10)
                    if not p1:_AnimationWait(script.Name, p2, 0.2 / p3) then
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
    else
        return
    end
end