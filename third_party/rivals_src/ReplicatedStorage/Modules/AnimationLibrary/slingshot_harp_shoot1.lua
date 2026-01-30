return function(p1, _, _)
    local v2, _, _ = workspace.CurrentCamera.CFrame:ToEulerAnglesYXZ()
    local v3 = v2 / 1.3962634015954636
    local v4 = math.clamp(v3, -1, 1)
    p1:CreateSound("rbxassetid://117069125273832", 0.75, v4 * 0.5 + 1.75, true, 5)
    p1:CreateSound("rbxassetid://127039236309973", 1, v4 * 0.25 + 1, true, 5)
end