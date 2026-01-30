return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 0.3 / p3) then
        p1:CreateSound("rbxassetid://13455229044", 1, 1.1, true, 10)
        if p1:_AnimationWait(script.Name, p2, 1.1666666666666667 / p3) then
            p1:CreateSound("rbxassetid://13455229188", 1, 1.1, true, 10)
            if p1:_AnimationWait(script.Name, p2, 0.7166666666666667 / p3) then
                p1:CreateSound("rbxassetid://13455395017", 1, 2, true, 10)
                if p1:_AnimationWait(script.Name, p2, 0.18333333333333332 / p3) then
                    p1:CreateSound("rbxassetid://13455395017", 1, 1, true, 10)
                    if p1:_AnimationWait(script.Name, p2, 1.2166666666666666 / p3) then
                        p1:CreateSound("rbxassetid://13455394948", 1, 1, true, 10)
                        if p1:_AnimationWait(script.Name, p2, 0.23333333333333334 / p3) then
                            p1:CreateSound("rbxassetid://13455394948", 1, 2, true, 10)
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