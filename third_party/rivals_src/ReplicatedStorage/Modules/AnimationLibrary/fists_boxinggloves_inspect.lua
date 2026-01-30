return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 0.45 / p3) then
        p1:CreateSound("rbxassetid://73893914300609", 1, 1, true, 5)
        if p1:_AnimationWait(script.Name, p2, 0.3 / p3) then
            p1:CreateSound("rbxassetid://73893914300609", 0.9, 1.1, true, 5)
        end
    else
        return
    end
end