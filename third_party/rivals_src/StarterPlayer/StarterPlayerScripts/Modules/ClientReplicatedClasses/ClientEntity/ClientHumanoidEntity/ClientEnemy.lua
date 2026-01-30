local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.BetterDebris)
require(v1.Modules.SoundLibrary)
local v_u_4 = require(v1.Modules.Utility)
local v_u_5 = require(v2.LocalPlayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientEntity.ClientHumanoidEntity)
local v_u_6 = v2.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild("ZombieSpawnEffect"):WaitForChild("Particles")
local v_u_7 = setmetatable({}, v_u_5)
v_u_7.__index = v_u_7
function v_u_7.new(...)
    local v8 = v_u_5.new(...)
    local v9 = v_u_7
    local v10 = setmetatable(v8, v9)
    v10._run_track = nil
    v10._idle_track = nil
    v10._death_animation_override = false
    v10._death_sound_override = false
    v10:_Init()
    return v10
end
function v_u_7.ReplicateFromServer(p11, p12, ...)
    if p12 == "ZombieSpawn" then
        p11:_PlayAnimation("ZombieSpawn")
        p11:_CreateSound("rbxassetid://109012456164853", 0.5 + 1 * math.random(), 0.875 + 0.25 * math.random())
        local v13 = v_u_6:Clone()
        v13.Parent = p11.Model:FindFirstChild("Head") or (p11.Model:FindFirstChild("UpperTorso") or p11.RootPart)
        v_u_3:AddItem(v13, 10)
        v_u_4:PlayParticles(v13)
        wait(0.5)
        v13.LockedToPart = false
    else
        v_u_5.ReplicateFromServer(p11, p12, ...)
    end
end
function v_u_7._DelayedVisibility(p14)
    local v15 = {}
    for _, v16 in pairs(p14.Model:GetDescendants()) do
        if v16:IsA("BasePart") or (v16:IsA("Decal") or v16:IsA("Texture")) then
            table.insert(v15, v16)
        end
    end
    for _, v17 in pairs(v15) do
        v17.LocalTransparencyModifier = 1
    end
    wait(0.2)
    for _, v18 in pairs(v15) do
        v18.LocalTransparencyModifier = 0
    end
end
function v_u_7._LoadAnimation(p19, p20)
    if p20 then
        return p19.Humanoid:LoadAnimation(p19:_CreateAnimation(p20))
    else
        return nil
    end
end
function v_u_7._SetupTracks(p_u_21)
    p_u_21._run_track = p_u_21:_LoadAnimation(p_u_21:Get("RunAnimation"))
    p_u_21._idle_track = p_u_21:_LoadAnimation(p_u_21:Get("IdleAnimation"))
    if p_u_21._idle_track then
        p_u_21._idle_track:Play()
    end
    if p_u_21._run_track then
        p_u_21._run_track:AdjustWeight(0, 0)
        p_u_21.Humanoid.Running:Connect(function(p22)
            if p_u_21:IsAlive() then
                if not p_u_21._run_track.IsPlaying then
                    p_u_21._run_track:Play()
                end
                p_u_21._run_track:AdjustWeight(p22 >= 0.5 and 1 or 0)
                p_u_21._run_track:AdjustSpeed(p22 * 1.25 / 16 / (p_u_21.RootPart.Size.Y / 2))
            end
        end)
    end
end
function v_u_7._Init(p_u_23)
    p_u_23.Died:Connect(function()
        if p_u_23._idle_track then
            p_u_23._idle_track:Stop(0)
            p_u_23._idle_track:Play()
            p_u_23._idle_track = nil
        end
        if p_u_23._run_track then
            p_u_23._run_track:Stop(0)
            p_u_23._run_track:Destroy()
            p_u_23._run_track = nil
        end
        local _ = p_u_23._death_sound_override
        local _ = p_u_23._death_animation_override
    end)
    pcall(p_u_23._SetupTracks, p_u_23)
    task.defer(p_u_23._DelayedVisibility, p_u_23)
end
return v_u_7