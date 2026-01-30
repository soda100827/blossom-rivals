return function(p1, p2, p3)
    p1:CreateSound("rbxassetid://18763645670", 1.125, 0.95 + 0.1 * math.random(), true, 10)
    if p1:_AnimationWait(script.Name, p2, 0.35 / p3) then
        p1:CreateSound("rbxassetid://13515046921", 1, 1.25, true, 10)
        if p1:_AnimationWait(script.Name, p2, 0.15 / p3) then
            p1:CreateSound("rbxassetid://13515046988", 1, 1.25, true, 10)
            if p1:_AnimationWait(script.Name, p2, 0.1 / p3) then
                p1:CreateSound("rbxassetid://13531443905", 0.125, 0.75 + 0.25 * math.random(), true, 10)
            end
        else
            return
        end
    else
        return
    end
end