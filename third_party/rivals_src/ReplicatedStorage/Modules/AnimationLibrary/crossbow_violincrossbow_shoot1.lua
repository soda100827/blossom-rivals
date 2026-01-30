return function(p1, _, _)
    local v2, _, _ = workspace.CurrentCamera.CFrame:ToEulerAnglesYXZ()
    local v3 = v2 / 1.3962634015954636
    local v4 = math.clamp(v3, -1, 1)
    p1:CreateSound("rbxassetid://82715240396507", 1, 1, true, 10)
    p1:CreateSound("rbxassetid://100943371677728", 1, v4 * 0.5 + 1, true, 10)
end