return function(p1, p2, p3)
    if p1:_AnimationWait(script.Name, p2, 0.5 / p3) then
        p1:CreateSound("rbxassetid://136633555539199", 1, 0.75, true, 10)
    end
end