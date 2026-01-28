return function(p_u_1, p_u_2, p_u_3)
    for v_u_4 = 1, 5 do
        task.spawn(function()
            if p_u_1:_AnimationWait(script.Name, p_u_2, 0.15 / p_u_3 * v_u_4 / 5) then
                p_u_1:CreateSound("rbxassetid://17803308936", 1 + 0.25 * math.random(), 1 + 0.3 * math.random(), true, 10)
            end
        end)
    end
    if p_u_1:_AnimationWait(script.Name, p_u_2, 0.35 / p_u_3) then
        p_u_1:CreateSound("rbxassetid://17803360572", 1, 2, true, 10)
        if p_u_1:_AnimationWait(script.Name, p_u_2, 0.15 / p_u_3) then
            p_u_1:CreateSound("rbxassetid://17803360572", 1, 1.25, true, 10)
            if p_u_1:_AnimationWait(script.Name, p_u_2, 0.1 / p_u_3) then
                p_u_1:CreateSound("rbxassetid://17803368105", 0.5, 0.75 + 0.25 * math.random(), true, 10)
            end
        else
            return
        end
    else
        return
    end
end