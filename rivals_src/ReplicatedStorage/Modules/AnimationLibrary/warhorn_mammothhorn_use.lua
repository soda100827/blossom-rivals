return function(p1, _, _)
    local v2 = p1:CreateSound("rbxassetid://116889597355364", 1, 1, true, 5, 100, 400)
    if v2 then
        v2:SetAttribute("DontClearSound", true)
    end
end