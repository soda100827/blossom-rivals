local v_u_1 = game:GetService("RunService")
return function(p2, p3, p4)
    if p2:_AnimationWait(script.Name, p3, 0.75 / p4) then
        local v5 = p2:CreateSound("rbxassetid://135262581066376", 1, 1, true, 10)
        while p2.Animator:IsAnimationHashValid("battleaxe_theshred_inspect", p3) do
            v_u_1.RenderStepped:Wait()
        end
        if v5 then
            v5:Destroy()
        end
    end
end