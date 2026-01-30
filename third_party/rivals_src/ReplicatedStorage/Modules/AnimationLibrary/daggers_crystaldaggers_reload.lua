return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 0.1 / p3) then
        p1:CreateSound("rbxassetid://72570123237418", 0.875, 4, true, 10)
        if p1:_AnimationWait(script.Name, p2, 0.1 / p3) then
            p1:CreateSound("rbxassetid://72570123237418", 0.5, 6, true, 10)
        end
    else
        return
    end
end