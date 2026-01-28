return function(p1, _, _)
    local v2, _, _ = workspace.CurrentCamera.CFrame:ToEulerAnglesYXZ()
    local v3 = v2 / 1.3962634015954636
    local v4 = math.clamp(v3, -1, 1)
    p1:CreateSound("rbxassetid://77594993345414", 0.875, v4 * 0.4 + 0.8, true, 5)
    p1:CreateSound("rbxassetid://132970131270232", 0.875, v4 * 0.2 + 0.9, true, 5)
end