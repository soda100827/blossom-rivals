return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 0.65 / p3) then
        p1:CreateSound("rbxassetid://13455395017", 1, 2, true, 10)
        p1:CreateSound("rbxassetid://13455395017", 1, 1, true, 10)
        if p1:_AnimationWait(script.Name, p2, 0.233 / p3) then
            p1:CreateSound("rbxassetid://13455395090", 0.25, 0.75 + 0.25 * math.random(), true, 10)
            if p1:_AnimationWait(script.Name, p2, 0.2 / p3) then
                p1:CreateSound("rbxassetid://13455229044", 1, 1.1, true, 10)
                if p1:_AnimationWait(script.Name, p2, 0.85 / p3) then
                    p1:CreateSound("rbxassetid://13455229188", 1, 1.1, true, 10)
                    if p1:_AnimationWait(script.Name, p2, 0.78 / p3) then
                        p1:CreateSound("rbxassetid://13455394948", 1, 1, true, 10)
                        if p1:_AnimationWait(script.Name, p2, 0.25 / p3) then
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