local v_u_1 = { "rbxassetid://137835445333923" }
local v_u_2 = { "rbxassetid://111635700014206", "rbxassetid://71082815960227", "rbxassetid://102452124576950" }
return function(p3, _, _)
    p3:CreateSound(v_u_1[math.random(#v_u_1)], 1, 1.25 + 0.25 * math.random(), true, 10)
    p3:CreateSound(v_u_2[math.random(#v_u_2)], 1, 0.95 + 0.1 * math.random(), true, 10)
end