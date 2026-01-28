return function(p1, _, _)
    if p1:IsA("BasePart") then
        local v2 = p1.Color
        local v3, v4, v5 = v2:ToHSV()
        p1.Color = v5 < (v4 > 0.5 and 0.1 or 0.35) and v2 and v2 or Color3.fromHSV(v3, v4, (math.max(0.75, v5)))
    elseif p1:IsA("Beam") or (p1:IsA("Trail") or p1:IsA("ParticleEmitter")) then
        local v6 = {}
        for _, v7 in pairs(p1.Color.Keypoints) do
            local v8 = ColorSequenceKeypoint.new
            local v9 = v7.Time
            local v10 = v7.Value
            local v11, v12, v13 = v10:ToHSV()
            local v14 = v13 < (v12 > 0.5 and 0.1 or 0.35) and v10 and v10 or Color3.fromHSV(v11, v12, (math.max(0.75, v13)))
            table.insert(v6, v8(v9, v14))
        end
        p1.Color = ColorSequence.new(v6)
    end
end