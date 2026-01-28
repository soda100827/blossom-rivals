return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 0.38 / p3) then
        p1:CreateSound("rbxassetid://82156077357708", 0.875, 1 + 0.2 * math.random(), true, 5)
        p1:CreateSound("rbxassetid://121373202237894", 0.875, 1 + 0.2 * math.random(), true, 5)
    end
end