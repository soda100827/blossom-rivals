local v_u_1 = { "rbxassetid://13677205703", "rbxassetid://13677205578", "rbxassetid://13677205647" }
return function(p2, p3, p4)
    p2:CreateSound(v_u_1[math.random(#v_u_1)], 3, 0.95 + 0.1 * math.random(), true, 10)
    p2:CreateSound("rbxassetid://82249006680828", 0.375, 0.95 + 0.25 * math.random(), true, 10)
    if p2:_AnimationWait(script.Name, p3, 0.5 / p4) then
        p2:CreateSound("rbxassetid://13682183816", 0.5, 0.95 + 0.1 * math.random(), true, 10)
    end
end