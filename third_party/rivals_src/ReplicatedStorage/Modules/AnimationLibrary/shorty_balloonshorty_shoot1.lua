return function(p_u_1, p_u_2, p_u_3)
    for v_u_4 = 1, 5 do
        task.spawn(function()
            if p_u_1:_AnimationWait(script.Name, p_u_2, 0.1 / p_u_3 * v_u_4 / 5) then
                p_u_1:CreateSound("rbxassetid://17803308936", 1 + 0.25 * math.random(), 1 + 0.3 * math.random(), true, 10)
            end
        end)
    end
end