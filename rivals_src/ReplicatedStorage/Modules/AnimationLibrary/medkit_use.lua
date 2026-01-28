return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 0.4 / p3) then
        p1:CreateSound("rbxassetid://13236026280", 0.5, 1.5, true, 10)
        if p1:_AnimationWait(script.Name, p2, 0.48 / p3) then
            p1:CreateSound("rbxassetid://13160326139", 0.5, 1.25, true, 10)
            if p1:_AnimationWait(script.Name, p2, 1.22 / p3) then
                p1:CreateSound("rbxassetid://13505411336", 0.75, 3.1 * p3, true, 10)
                if p1:_AnimationWait(script.Name, p2, 1.2 / p3) then
                    p1:CreateSound("rbxassetid://13505411414", 0.75, 1.25, true, 10)
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