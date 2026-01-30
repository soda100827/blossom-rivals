return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 0.05 / p3) then
        p1:CreateSound("rbxassetid://13515046921", 1, 1.25, true, 10)
        if p1:_AnimationWait(script.Name, p2, 0.85 / p3) then
            p1:CreateSound("rbxassetid://13515046872", 1, 1, true, 10)
            if p1:_AnimationWait(script.Name, p2, 0.55 / p3) then
                p1:CreateSound("rbxassetid://13515046988", 1, 1.25, true, 10)
            end
        else
            return
        end
    else
        return
    end
end