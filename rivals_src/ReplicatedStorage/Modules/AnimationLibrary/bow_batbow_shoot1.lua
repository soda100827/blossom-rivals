local v_u_1 = { "rbxassetid://13677205703", "rbxassetid://13677205578", "rbxassetid://13677205647" }
return function(p2, _, _)
    p2:CreateSound(v_u_1[math.random(#v_u_1)], 3, 0.95 + 0.1 * math.random(), true, 10)
    p2:CreateSound("rbxassetid://122106573913822", 1, 2 + 0.5 * math.random(), true, 10)
end