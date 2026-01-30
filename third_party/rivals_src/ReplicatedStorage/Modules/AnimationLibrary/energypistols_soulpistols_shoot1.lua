return function(p1, _, _)
    if tick() >= p1.EnergyPistolsShootSoundCooldown then
        p1.EnergyPistolsShootSoundCooldown = tick() + 0.05
        p1:CreateSound("rbxassetid://120386834342865", 0.625, 1 + 0.2 * math.random(), true, 1)
        p1:CreateSound("rbxassetid://132138482130551", 0.625, 1 + 0.2 * math.random(), true, 1)
    end
end