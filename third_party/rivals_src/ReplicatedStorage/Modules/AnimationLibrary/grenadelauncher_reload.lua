return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 0.45 / p3) then
        p1:CreateSound("rbxassetid://17274798693", 0.75, 1, true, 10)
        if p1:_AnimationWait(script.Name, p2, 1.3 / p3) then
            p1:CreateSound("rbxassetid://17274798406", 0.75, 1, true, 10)
            p1:CreateSound("rbxassetid://17274798198", 0.75, 1, true, 10)
            if p1:_AnimationWait(script.Name, p2, 0.6 / p3) then
                p1:CreateSound("rbxassetid://17274798538", 0.75, 1, true, 10)
            end
        else
            return
        end
    else
        return
    end
end