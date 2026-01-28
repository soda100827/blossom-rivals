return function(p1, p2, p3)
    p1:CreateSound("rbxassetid://80245415527547", 0.75, 1 + 0.1 * math.random(), true, 5)
    p1:CreateSound("rbxassetid://94519339983000", 0.75, 1 + 0.1 * math.random(), true, 5)
    if p1:_AnimationWait(script.Name, p2, 0.4 / p3) then
        p1:CreateSound("rbxassetid://86450952337176", 0.75, 1 + 0.1 * math.random(), true, 5)
    end
end