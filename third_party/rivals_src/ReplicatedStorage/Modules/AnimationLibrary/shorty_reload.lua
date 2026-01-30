return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 0.2833333333333333 / p3) then
        p1:CreateSound("rbxassetid://13483008798", 1, 1.25, true, 10)
        if p1:_AnimationWait(script.Name, p2, 0.3 / p3) then
            p1:CreateSound("rbxassetid://13236026280", 0.5, 1, true, 10)
            if p1:_AnimationWait(script.Name, p2, 1.1 / p3) then
                p1:CreateSound("rbxassetid://13235979356", 1, 1, true, 10)
                if p1:_AnimationWait(script.Name, p2, 0.6166666666666667 / p3) then
                    p1:CreateSound("rbxassetid://13483008798", 1, 1, true, 10)
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