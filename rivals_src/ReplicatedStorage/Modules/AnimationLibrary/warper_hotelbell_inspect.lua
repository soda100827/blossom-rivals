return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 1.1 / p3) then
        p1:CreateSound("rbxassetid://120936003285451", 0.5, 1, true, 5)
        if p1:_AnimationWait(script.Name, p2, 0.2 / p3) then
            p1:CreateSound("rbxassetid://120936003285451", 0.625, 1.125, true, 5)
        end
    else
        return
    end
end