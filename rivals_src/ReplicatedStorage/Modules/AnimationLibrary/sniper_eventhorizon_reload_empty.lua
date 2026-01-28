return function(p1, p2, p3)
    p1:CreateSound("rbxassetid://113227486192611", 0.875, 0.7 + 0.1 * math.random(), true, 10)
    p1:CreateSound("rbxassetid://122971606160018", 0.875, 0.7 + 0.1 * math.random(), true, 10)
    if p1:_AnimationWait(script.Name, p2, 1.38 / p3) then
        if p1.PlayReloadStartParticles then
            p1:PlayReloadStartParticles()
        end
        if p1:_AnimationWait(script.Name, p2, 0.75 / p3) then
            if p1.PlayReloadFinishParticles then
                p1:PlayReloadFinishParticles()
            end
            p1:CreateSound("rbxassetid://17672502879", 0.875, 0.875, true, 10)
            if p1:_AnimationWait(script.Name, p2, 0.62 / p3) then
                p1:CreateSound("rbxassetid://17672502879", 0.5, 3, true, 10)
            end
        else
            return
        end
    else
        return
    end
end