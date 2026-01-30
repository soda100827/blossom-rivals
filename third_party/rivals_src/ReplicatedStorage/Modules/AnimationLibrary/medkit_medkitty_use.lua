return function(p1, p2, p3)
    p1:CreateSound("rbxassetid://128632959026124", 1.5, 1, true, 10)
    if p1:_AnimationWait(script.Name, p2, 0.7 / p3) then
        p1:CreateSound("rbxassetid://106320000244648", 1.5, 1, true, 10)
        if p1:_AnimationWait(script.Name, p2, 0.8 / p3) then
            p1:CreateSound("rbxassetid://103145233607638", 1.5, 0.875, true, 10)
            if p1:_AnimationWait(script.Name, p2, 1 / p3) then
                p1:CreateSound("rbxassetid://103145233607638", 1.35, 0.9, true, 10)
                if p1:_AnimationWait(script.Name, p2, 0.75 / p3) then
                    p1:CreateSound("rbxassetid://103145233607638", 1.2, 0.925, true, 10)
                    if p1:_AnimationWait(script.Name, p2, 1 / p3) then
                        p1:CreateSound("rbxassetid://103145233607638", 1, 0.95, true, 10)
                        if p1:_AnimationWait(script.Name, p2, 0.25 / p3) then
                            p1:CreateSound("rbxassetid://81623846775515", 0.75, 2.25, true, 10)
                            if p1:_AnimationWait(script.Name, p2, 0.375 / p3) then
                                p1:CreateSound("rbxassetid://128990235337969", 1.5, 1, true, 10)
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