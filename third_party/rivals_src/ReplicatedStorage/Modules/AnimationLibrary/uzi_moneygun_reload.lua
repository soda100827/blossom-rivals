return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 0.1 / p3) then
        p1:CreateSound("rbxassetid://13236026280", 0.5, 1.5, true, 10)
        if p1:_AnimationWait(script.Name, p2, 0.25 / p3) then
            p1:CreateSound("rbxassetid://120574582651469", 0.5, 1, true, 10)
            if p1:_AnimationWait(script.Name, p2, 1.1 / p3) then
                p1:CreateSound("rbxassetid://76703369839400", 0.875, 1, true, 10)
                if p1:_AnimationWait(script.Name, p2, 0.5 / p3) then
                    p1:CreateSound("rbxassetid://13236026280", 0.5, 1, true, 10)
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