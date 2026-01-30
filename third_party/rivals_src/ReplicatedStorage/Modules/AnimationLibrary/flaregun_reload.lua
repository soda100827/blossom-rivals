return function(p1, p2, p3)
    p1:CreateSound("rbxassetid://13456860578", 1.5, 1.5, true, 10)
    if p1:_AnimationWait(script.Name, p2, 0.35 / p3) then
        p1:CreateSound("rbxassetid://13236026280", 1, 1, true, 10)
        if p1:_AnimationWait(script.Name, p2, 0.4 / p3) then
            p1:CreateSound("rbxassetid://13235979356", 1, 1.25, true, 10)
            if p1:_AnimationWait(script.Name, p2, 0.3 / p3) then
                p1:CreateSound("rbxassetid://13158330383", 1, 0.75, true, 10)
                if p1:_AnimationWait(script.Name, p2, 0.25 / p3) then
                    p1:CreateSound("rbxassetid://13158330383", 1, 1, true, 10)
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