return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 2.05 / p3) then
        p1:CreateSound("rbxassetid://96253147006478", 0.5, 0.8, true, 10)
        if p1:_AnimationWait(script.Name, p2, 1.05 / p3) then
            p1:CreateSound("rbxassetid://96253147006478", 0.625, 0.9, true, 10)
            if p1:_AnimationWait(script.Name, p2, 1.2 / p3) then
                p1:CreateSound("rbxassetid://96253147006478", 0.75, 1.25, true, 10)
                if p1:_AnimationWait(script.Name, p2, 0.25 / p3) then
                    p1:CreateSound("rbxassetid://96253147006478", 0.5, 1.375, true, 10)
                    if p1:_AnimationWait(script.Name, p2, 0.25 / p3) then
                        p1:CreateSound("rbxassetid://96253147006478", 0.25, 1.5, true, 10)
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