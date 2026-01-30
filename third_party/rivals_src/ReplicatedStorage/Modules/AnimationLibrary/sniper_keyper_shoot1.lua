return function(p1, p2, p3)
    p1:CreateSound("rbxassetid://115657023572170", 0.875, 0.95 + 0.1 * math.random(), true, 10)
    p1:CreateSound("rbxassetid://13270206222", 0.875, 0.95 + 0.1 * math.random(), true, 10)
    p1:CreateSound("rbxassetid://13270206087", 0.875, 0.95 + 0.1 * math.random(), true, 10)
    if p1:_AnimationWait(script.Name, p2, 0.5 / p3) then
        p1:CreateSound("rbxassetid://13455395017", 1, 2, true, 10)
        if p1:_AnimationWait(script.Name, p2, 0.067 / p3) then
            p1:CreateSound("rbxassetid://13455395017", 1, 1, true, 10)
            if p1:_AnimationWait(script.Name, p2, 0.05 / p3) then
                p1:CreateSound("rbxassetid://13455394948", 1, 1, true, 10)
                if p1:_AnimationWait(script.Name, p2, 0.183 / p3) then
                    p1:CreateSound("rbxassetid://13455394948", 1, 2, true, 10)
                    if p1:_AnimationWait(script.Name, p2, 0.05 / p3) then
                        p1:CreateSound("rbxassetid://13455395090", 0.25, 0.75 + 0.25 * math.random(), true, 10)
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