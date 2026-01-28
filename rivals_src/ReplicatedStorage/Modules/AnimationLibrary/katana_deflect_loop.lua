local v_u_1 = { "rbxassetid://14000023581", "rbxassetid://14000023392" }
return function(p2, p3, p4)
    for _ = 1, 15 do
        p2:CreateSound(v_u_1[math.random(#v_u_1)], 0.75 + 0.5 * math.random(), 2 + 0.5 * math.random(), true, 10)
        p2:CreateSound("rbxassetid://13455968853", 0.375, 1.25 + 0.25 * math.random(), true, 10)
        if not p2:_AnimationWait(script.Name, p3, 0.06666666666666667 / p4) then
            return
        end
    end
end