local v_u_1 = { "rbxassetid://116197718267373", "rbxassetid://70565429278087", "rbxassetid://134615455726492" }
return function(p2, _, _)
    p2:CreateSound(v_u_1[math.random(#v_u_1)], 1, 1 + 0.1 * math.random(), true, 10)
end