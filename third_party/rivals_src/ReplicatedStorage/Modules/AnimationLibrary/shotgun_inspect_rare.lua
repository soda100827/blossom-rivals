return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 1 / p3) then
        p1:CreateSound("rbxassetid://13515046921", 1, 1.25, true, 10)
        p1:CreateSound("rbxassetid://13236026280", 1, 1, true, 10)
        if p1:_AnimationWait(script.Name, p2, 0.717 / p3) then
            p1:CreateSound("rbxassetid://13160326139", 1, 1.25, true, 10)
            if p1:_AnimationWait(script.Name, p2, 2.783 / p3) then
                p1:CreateSound("rbxassetid://13160326139", 0.5, 1.75, true, 10)
                if p1:_AnimationWait(script.Name, p2, 0.6 / p3) then
                    p1:CreateSound("rbxassetid://13235979356", 1, 1, true, 10)
                    if p1:_AnimationWait(script.Name, p2, 0.15 / p3) then
                        p1:CreateSound("rbxassetid://13515046988", 1, 1.25, true, 10)
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