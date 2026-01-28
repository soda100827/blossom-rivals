local v_u_1 = { "rbxassetid://13110197302", "rbxassetid://13110197220" }
return function(p2, _, _)
    p2:CreateSound(v_u_1[math.random(#v_u_1)], 0.875, 1 + 0.2 * math.random(), true, 5)
end