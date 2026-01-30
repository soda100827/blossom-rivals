return function(p1, p2, p3)
    local v4 = p1:CreateSound("rbxassetid://13456860578", 1.25, 1.25, true, 10)
    if p1:_AnimationWait(script.Name, p2, 0.4 / p3) then
        if v4 then
            v4:Destroy()
        end
        p1:CreateSound("rbxassetid://13483008798", 1, 2, true, 10)
    end
end