local v_u_1 = {
    "rbxassetid://14417089307",
    "rbxassetid://14417089152",
    "rbxassetid://14417089046",
    "rbxassetid://14417088974"
}
return function(p2, _, _)
    p2:CreateSound(v_u_1[math.random(#v_u_1)], 1, 0.95 + 0.1 * math.random(), true, 10)
    p2:CreateSound("rbxassetid://104731232227748", 1, 0.95 + 0.1 * math.random(), true, 10)
end