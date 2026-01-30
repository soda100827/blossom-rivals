local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.AnimationLibrary)
local v_u_4 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("ClientReplicatedClasses"):WaitForChild("ClientFighter"):WaitForChild("ClientItem"):WaitForChild("ClientViewModel"))
local v_u_5 = v2.LocalPlayer.PlayerScripts.Assets.Misc.WarHornEffects
local v_u_6 = setmetatable({}, v_u_4)
v_u_6.__index = v_u_6
function v_u_6.new(...)
    local v7 = v_u_4.new(...)
    local v8 = v_u_6
    local v9 = setmetatable(v7, v8)
    v9._horn_particles = {}
    v9._horn_particles_active = 0
    v9._use_effect_attachment = v9.Model:FindFirstChild("_warhorn_use", true)
    v9:_Init()
    return v9
end
function v_u_6.PlayHornEffect(p10)
    p10:_IncrementParticlesActive(1)
    task.delay(v_u_3.Info[p10.Info.Animations.Use].ActionTimestamp, p10._IncrementParticlesActive, p10, -1)
end
function v_u_6._IncrementParticlesActive(p11, p12)
    p11._horn_particles_active = p11._horn_particles_active + p12
    for _, v13 in pairs(p11._horn_particles) do
        v13.Enabled = p11._horn_particles_active > 0
    end
end
function v_u_6._Setup(p14)
    for _, v15 in pairs((v_u_5:FindFirstChild(p14.Name) or v_u_5.Default).Attachment:GetChildren()) do
        local v16 = v15:Clone()
        v16.Parent = p14._use_effect_attachment
        local v17 = p14._horn_particles
        table.insert(v17, v16)
    end
end
function v_u_6._Init(p18)
    p18:_Setup()
end
return v_u_6