return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 0.1 / p3) then
        p1:CreateSound("rbxassetid://17803231630", 1, 1, true, 10)
        if p1:_AnimationWait(script.Name, p2, 0.1 / p3) then
            if p1:_AnimationWait(script.Name, p2, 0.95 / p3) then
                p1:CreateSound("rbxassetid://17803231954", 1, 1, true, 10)
                if p1:_AnimationWait(script.Name, p2, 0.39 / p3) then
                    p1:CreateSound("rbxassetid://13160326139", 0.75, 1, true, 10)
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