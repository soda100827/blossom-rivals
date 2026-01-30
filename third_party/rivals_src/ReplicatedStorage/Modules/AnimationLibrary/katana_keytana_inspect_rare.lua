local v_u_1 = { "rbxassetid://14000023581", "rbxassetid://14000023392" }
return function(p_u_2, p_u_3, p_u_4)
    if p_u_2:_AnimationWait(script.Name, p_u_3, 2 / p_u_4) then
        p_u_2:CreateSound("rbxassetid://14427935597", 0.5, 1.125, true, 10)
        p_u_2:CreateSound("rbxassetid://96253147006478", 0.75, 1.25, true, 10)
        if p_u_2:_AnimationWait(script.Name, p_u_3, 0.25 / p_u_4) then
            p_u_2:CreateSound("rbxassetid://96253147006478", 0.5, 1.375, true, 10)
            if p_u_2:_AnimationWait(script.Name, p_u_3, 0.25 / p_u_4) then
                p_u_2:CreateSound("rbxassetid://96253147006478", 0.25, 1.5, true, 10)
                if p_u_2:_AnimationWait(script.Name, p_u_3, 0.375 / p_u_4) then
                    for _ = 1, 15 do
                        p_u_2:CreateSound(v_u_1[math.random(#v_u_1)], 1, 1 + 0.25 * math.random(), true, 10)
                        p_u_2:CreateSound("rbxassetid://96253147006478", 0.375, 1 + 0.5 * math.random(), true, 10)
                        if not p_u_2:_AnimationWait(script.Name, p_u_3, 0.058333333333333334 / p_u_4) then
                            return
                        end
                    end
                    if p_u_2:_AnimationWait(script.Name, p_u_3, 0.15 / p_u_4) then
                        p_u_2:CreateSound("rbxassetid://96253147006478", 0.2, 1.25, true, 10)
                        if p_u_2:_AnimationWait(script.Name, p_u_3, 0.25 / p_u_4) then
                            p_u_2:CreateSound("rbxassetid://96253147006478", 0.1, 1.5, true, 10)
                            p_u_2:CreateSound("rbxassetid://89056031983351", 0.75, 1.117, true, 10)
                            if p_u_2:_AnimationWait(script.Name, p_u_3, 0.933 / p_u_4) then
                                p_u_2:CreateSound("rbxassetid://133090858473825", 0.75, 1, true, 10)
                                if p_u_2:_AnimationWait(script.Name, p_u_3, 0.5 / p_u_4) then
                                    p_u_2:CreateSound("rbxassetid://90757583550672", 0.75, 1 + 0.125 * math.random(), true, 5)
                                    for v5 = 1, 3 do
                                        p_u_2:CreateSound("rbxassetid://14427782350", 1, 1 + 0.25 * (v5 - 1), true, 10)
                                        if not p_u_2:_AnimationWait(script.Name, p_u_3, 0.05 / p_u_4) then
                                            return
                                        end
                                    end
                                    if p_u_2:_AnimationWait(script.Name, p_u_3, 0.5 / p_u_4) then
                                        p_u_2:CreateSound("rbxassetid://71387264231358", 1, 0.875, true, 10)
                                        if p_u_2:_AnimationWait(script.Name, p_u_3, 0.767 / p_u_4) then
                                            local v_u_6 = p_u_2:CreateSound("rbxassetid://82637145735352", 0.5, 1 + 0.1 * math.random(), true)
                                            task.spawn(function()
                                                if p_u_2:_AnimationWait(script.Name, p_u_3, 2.5 / p_u_4) then
                                                    if v_u_6 then
                                                        v_u_6:Destroy()
                                                    end
                                                end
                                            end)
                                            if p_u_2:_AnimationWait(script.Name, p_u_3, 1.45 / p_u_4) then
                                                for _ = 1, 5 do
                                                    p_u_2:CreateSound("rbxassetid://13160326139", 0.75, 1 + 0.25 * math.random(), true, 10)
                                                    if not p_u_2:_AnimationWait(script.Name, p_u_3, 0.2 / p_u_4) then
                                                        return
                                                    end
                                                end
                                            end
                                        else
                                            return
                                        end
                                    else
                                        return
                                    end
                                else
                                    return
                                end
                            else
                                return
                            end
                        else
                            return
                        end
                    else
                        return
                    end
                else
                    return
                end
            else
                return
            end
        else
            return
        end
    else
        return
    end
end