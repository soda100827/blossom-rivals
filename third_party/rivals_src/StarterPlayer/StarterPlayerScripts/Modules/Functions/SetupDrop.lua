local v_u_1 = game:GetService("Players").LocalPlayer.PlayerScripts.Assets.Drops
local function v_u_5(p2, p3)
    for _, v4 in pairs(p2:GetDescendants()) do
        if v4:IsA("BasePart") or v4:IsA("ParticleEmitter") then
            v4.LocalTransparencyModifier = p3
        end
    end
end
return function(p6, p7, p8)
    local v9 = Instance.new("Attachment")
    v9.Parent = p6
    local v10 = v_u_1[p7]:Clone()
    v10.PrimaryPart = v10.Primary
    v10:PivotTo(p6.CFrame * CFrame.Angles(math.random() * 3.141592653589793 * 2, math.random() * 3.141592653589793 * 2, math.random() * 3.141592653589793 * 2))
    for _, v11 in pairs(v10:GetDescendants()) do
        if v11:IsA("BasePart") then
            local v12 = v11 == v10.PrimaryPart
            v11.CanCollide = false
            v11.CanTouch = false
            v11.CanQuery = false
            v11.Massless = true
            v11.Anchored = v12
            if not v12 then
                local v13 = Instance.new("WeldConstraint")
                v13.Part0 = v10.Primary
                v13.Part1 = v11
                v13.Parent = v11
            end
        end
    end
    v10.PrimaryPart.Anchored = false
    v10.Parent = p6
    local v14 = Instance.new("Attachment")
    v14.Parent = v10.PrimaryPart
    local v15 = Instance.new("AngularVelocity")
    v15.MaxTorque = 1000000
    local v16 = math.random() - 0.5
    v15.AngularVelocity = Vector3.new(0, 2, 0) * math.sign(v16)
    v15.RelativeTo = Enum.ActuatorRelativeTo.World
    v15.Attachment0 = v14
    v15.Parent = v10.PrimaryPart
    local v17 = Instance.new("AlignPosition")
    v17.RigidityEnabled = true
    v17.Attachment0 = v14
    v17.Attachment1 = v9
    v17.Parent = v10.PrimaryPart
    if p8 < (1 / 0) then
        wait(p8 - 4)
        for _ = 1, 20 do
            v_u_5(p6, 1)
            wait(0.07500000000000001)
            v_u_5(p6, 0)
            wait(0.125)
        end
    end
end