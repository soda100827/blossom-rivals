return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 0.3 / p3) then
        p1:CreateSound("rbxassetid://97621886814272", 1, 3 + 0.25 * math.random(), true, 10)
        p1:CreateSound("rbxassetid://13160326139", 0.375, 1.5, true, 10)
        if p1:_AnimationWait(script.Name, p2, 0.2 / p3) then
            p1:CreateSound("rbxassetid://13236026280", 0.5, 2.25, true, 10)
            if p1:_AnimationWait(script.Name, p2, 1.2 / p3) then
                p1:CreateSound("rbxassetid://97621886814272", 1, 2.5 + 0.125 * math.random(), true, 10)
                p1:CreateSound("rbxassetid://13160326139", 0.375, 1.25, true, 10)
                if p1:_AnimationWait(script.Name, p2, 0.35 / p3) then
                    p1:CreateSound("rbxassetid://13236026280", 0.375, 1.75, true, 10)
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