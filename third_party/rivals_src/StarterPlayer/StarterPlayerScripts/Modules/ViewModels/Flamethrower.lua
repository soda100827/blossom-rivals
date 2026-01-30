local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.BetterDebris)
local v_u_4 = require(v1.Modules.Utility)
local v_u_5 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("ClientReplicatedClasses"):WaitForChild("ClientFighter"):WaitForChild("ClientItem"):WaitForChild("ClientViewModel"))
local v_u_6 = v2.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild("FlamethrowerAirblasts")
local v_u_7 = v2.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild("FlamethrowerFlames")
local v_u_8 = setmetatable({}, v_u_5)
v_u_8.__index = v_u_8
function v_u_8.new(...)
    local v9 = v_u_5.new(...)
    local v10 = v_u_8
    local v11 = setmetatable(v9, v10)
    v11._flame_particles = {}
    v11._flame_particles_hash = 0
    v11._flame_sounds = nil
    v11:_Init()
    return v11
end
function v_u_8.SetFlameParticlesEnabled(p_u_12, p13)
    p_u_12._flame_particles_hash = p_u_12._flame_particles_hash + 1
    local v_u_14 = p_u_12._flame_particles_hash
    for _, v_u_15 in pairs(p_u_12._flame_particles) do
        if v_u_15:IsA("ParticleEmitter") then
            v_u_15.Enabled = p13
        elseif v_u_15:IsA("Light") then
            if p13 then
                v_u_15.Brightness = 10
            else
                task.spawn(v_u_4.RenderstepForLoop, v_u_4, 0, 100, 10, function(p16)
                    if v_u_14 ~= p_u_12._flame_particles_hash then
                        return true
                    end
                    v_u_15.Brightness = 20 * (1 - p16 / 100)
                end)
            end
        end
    end
    if p13 then
        p_u_12:PlayFlameSoundEffect()
    else
        p_u_12:StopFlameSoundEffect()
    end
end
function v_u_8.PlayFlameSoundEffect(p17, _)
    p17:StopFlameSoundEffect(false)
    p17._flame_sounds = p17._flame_sounds or p17:_CreateFlameSoundEffects()
    for _, v18 in pairs(p17._flame_sounds) do
        v18.Looped = true
    end
end
function v_u_8.StopFlameSoundEffect(p19, _)
    local v_u_20 = p19._flame_sounds
    if v_u_20 then
        v_u_20 = v_u_4:CloneTable(p19._flame_sounds)
    end
    p19._flame_sounds = nil
    if v_u_20 and #v_u_20 ~= 0 then
        local v_u_21 = {}
        for _, v22 in pairs(v_u_20) do
            v_u_21[v22] = v22.Volume
        end
        task.spawn(v_u_4.RenderstepForLoop, v_u_4, 0, 100, 4, function(p23)
            for _, v24 in pairs(v_u_20) do
                v24.Volume = v_u_21[v24] * (1 - p23 / 100)
            end
        end)
    end
end
function v_u_8.PlayAirblastSoundEffect(p25)
    p25:CreateSound("rbxassetid://17209245422", 1, 1, true, 5)
end
function v_u_8.AirblastEffect(p26)
    local v27 = (v_u_6:FindFirstChild(p26.Name) or v_u_6.Default).Attachment:Clone()
    v27.CFrame = p26._muzzle_attachments[1].CFrame
    v27.Parent = p26._muzzle_attachments[1].Parent
    v_u_3:AddItem(v27, 5)
    v_u_4:PlayParticles(v27)
    p26:PlayAirblastSoundEffect()
end
function v_u_8._CreateFlameSoundEffects(p28)
    return { p28:CreateSound("rbxassetid://17209245734", 1.5, 1, true) }
end
function v_u_8._Setup(p29)
    for _, v30 in pairs((v_u_7:FindFirstChild(p29.Name) or v_u_7.Default).Attachment:GetChildren()) do
        local v31 = v30:Clone()
        v31.Parent = p29._muzzle_attachments[1]
        local v32 = p29._flame_particles
        table.insert(v32, v31)
    end
end
function v_u_8._Init(p33)
    p33:_Setup()
end
return v_u_8