return function(p1, _, _)
    local v2 = p1:CreateSound("rbxassetid://73325703605178", 0.5, 1, true, 5, 100, 400)
    if v2 then
        v2:SetAttribute("DontClearSound", true)
    end
    local v3 = p1:CreateSound("rbxassetid://94406584083681", 0.5, 1, true, 5, 100, 400)
    if v3 then
        v3:SetAttribute("DontClearSound", true)
    end
    local v4 = p1:CreateSound("rbxassetid://101461584188367", 1, 1, true, 5, 100, 400)
    if v4 then
        v4:SetAttribute("DontClearSound", true)
    end
end