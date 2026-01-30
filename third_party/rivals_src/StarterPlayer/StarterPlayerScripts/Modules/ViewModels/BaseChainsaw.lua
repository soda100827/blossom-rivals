local v1 = game:GetService("Players")
local v_u_2 = require(v1.LocalPlayer.PlayerScripts.Modules:WaitForChild("ClientReplicatedClasses"):WaitForChild("ClientFighter"):WaitForChild("ClientItem"):WaitForChild("ClientViewModel"))
local v_u_3 = v1.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild("ChainsawParticles")
local v_u_4 = setmetatable({}, v_u_2)
v_u_4.__index = v_u_4
function v_u_4.new(...)
    local v5 = v_u_2.new(...)
    local v6 = v_u_4
    local v7 = setmetatable(v5, v6)
    v7._spike_toggle = false
    v7._spike_parts = {}
    v7._next_toggle = 0
    v7._hold_particles = {}
    v7._idle_sound_hash = 0
    v7:_Init()
    return v7
end
function v_u_4.CreateHoldSounds(p8)
    return { p8:CreateSound("rbxassetid://16359327230", 0.5, 1, true) }
end
function v_u_4.PlayStartingHoldSounds(_) end
function v_u_4.EnableParticles(p9, p10)
    for _, v11 in pairs(p9._hold_particles) do
        v11.Enabled = p10
    end
end
function v_u_4.Update(p12, p13, p14, p15)
    v_u_2.Update(p12, p13, p14, p15)
    if p15.IsActive then
        if tick() >= p12._next_toggle then
            p12._next_toggle = tick() + 0.03
            p12._spike_toggle = not p12._spike_toggle
            for v16, v17 in pairs(p12._spike_parts) do
                p12:_LocalTransparencyModifier(v16, "Update", v17 == p12._spike_toggle and 0 or 1)
            end
        end
    else
        return
    end
end
function v_u_4._PlayIdleSound(p18, p19, p20)
    local v21 = p20 or 0.2
    if v21 > 0 then
        wait(v21)
        if p19 ~= p18._idle_sound_hash then
            return
        end
    end
    local v22 = p18:CreateSound("rbxassetid://13645858587", 0.375, 1, true)
    if v22 then
        v22.Looped = true
    end
    local v23 = p18:CreateSound("rbxassetid://13646484249", 0.375, 1, true)
    if v23 then
        v23.Looped = true
    end
    local v24 = p18:CreateSound("rbxassetid://13646484113", 0.25, 1, true)
    if v24 then
        v24.Looped = true
    end
end
function v_u_4._RegisterSpikesPart(p25, p26, p27)
    p25._spike_parts[p26] = p27
end
function v_u_4._RegisterBlade(p28, p29)
    for _, v30 in pairs((v_u_3:FindFirstChild(p28.Name) or v_u_3.Default):GetChildren()) do
        local v31 = v30:Clone()
        v31.Parent = p29
        local v32 = p28._hold_particles
        table.insert(v32, v31)
    end
end
function v_u_4._Init(p_u_33)
    p_u_33.Equipped:Connect(function()
        local v34 = p_u_33
        v34._idle_sound_hash = v34._idle_sound_hash + 1
        p_u_33:_PlayIdleSound(p_u_33._idle_sound_hash)
    end)
    p_u_33.Unequipped:Connect(function()
        local v35 = p_u_33
        v35._idle_sound_hash = v35._idle_sound_hash + 1
    end)
end
return v_u_4