return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 0.4 / p3) then
        p1:CreateSound("rbxassetid://13236549962", 1, 1.25, true, 10)
        if p1:_AnimationWait(script.Name, p2, 0.8 / p3) then
            p1:CreateSound("rbxassetid://13236549962", 1, 1, true, 10)
            if p1:_AnimationWait(script.Name, p2, 0.35 / p3) then
                p1:CreateSound("rbxassetid://13455395017", 1, 1, true, 10)
                if p1:_AnimationWait(script.Name, p2, 0.217 / p3) then
                    p1:CreateSound("rbxassetid://13455395017", 1, 1.25, true, 10)
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