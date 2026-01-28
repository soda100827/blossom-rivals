return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 1.6 / p3) then
        p1:CreateSound("rbxassetid://14427935597", 0.5, 1, true, 10)
        if p1:_AnimationWait(script.Name, p2, 0.28 / p3) then
            p1:CreateSound("rbxassetid://14427935597", 0.5, 1.125, true, 10)
            if p1:_AnimationWait(script.Name, p2, 0.42 / p3) then
                p1:CreateSound("rbxassetid://14427935597", 0.5, 1.25, true, 10)
                if p1:_AnimationWait(script.Name, p2, 0.4 / p3) then
                    p1:CreateSound("rbxassetid://17640978498", 0.5, 1, true, 10)
                    p1:CreateSound("rbxassetid://14427782350", 1, 1, true, 10)
                    if p1:_AnimationWait(script.Name, p2, 0.35 / p3) then
                        p1:CreateSound("rbxassetid://17640978271", 0.5, 1, true, 10)
                        p1:CreateSound("rbxassetid://14427782350", 1, 1, true, 10)
                        if p1:_AnimationWait(script.Name, p2, 0.58 / p3) then
                            p1:CreateSound("rbxassetid://17640978498", 0.5, 1, true, 10)
                            p1:CreateSound("rbxassetid://14427782350", 1, 1, true, 10)
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
    else
        return
    end
end