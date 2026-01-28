return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 0.5 / p3) then
        p1:CreateSound("rbxassetid://118906938239363", 1, 0.9 + 0.2 * math.random(), true, 10)
    end
end