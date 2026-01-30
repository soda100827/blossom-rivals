return function(p1, _, _)
    local v2, _, _ = workspace.CurrentCamera.CFrame:ToEulerAnglesYXZ()
    local v3 = v2 / 1.3962634015954636
    p1:CreateSound("rbxassetid://120936003285451", 0.875, math.clamp(v3, -1, 1) * 0.25 + 1, true, 5)
end