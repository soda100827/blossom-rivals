local v_u_1 = { "rbxassetid://16526185100", "rbxassetid://16526184479", "rbxassetid://16526184730" }
local v_u_2 = { "rbxassetid://88544860864804", "rbxassetid://129694620679651", "rbxassetid://102804344908530" }
return function(p3, _, _)
    p3:CreateSound(v_u_1[math.random(#v_u_1)], 0.5, 0.75 + 0.5 * math.random(), true, 5)
    p3:CreateSound("rbxassetid://16397424081", 0.2, 4 + 0.5 * math.random(), true, 5)
    p3:CreateSound("rbxassetid://16526184265", 0.5, 2 + 0.5 * math.random(), true, 5)
    p3:CreateSound(v_u_2[math.random(#v_u_2)], 0.875, 1 + 0.2 * math.random(), true, 10)
    p3:CreateSound("rbxassetid://76983701785959", 1.5, 1, true, 5)
end