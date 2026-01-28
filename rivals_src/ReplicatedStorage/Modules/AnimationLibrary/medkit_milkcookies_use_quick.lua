return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 0.1 / p3) then
        p1:CreateSound("rbxassetid://78700624599503", 1, 1 + 0.1 * math.random(), true, 10)
        if p1:_AnimationWait(script.Name, p2, 0.45 / p3) then
            p1:CreateSound("rbxassetid://120187119176806", 1.5, 1 + 0.1 * math.random(), true, 10)
        end
    else
        return
    end
end