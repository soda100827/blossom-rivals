local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.BetterDebris)
local v_u_4 = require(v1.Modules.Utility)
local v_u_5 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("ClientReplicatedClasses"):WaitForChild("ClientFighter"):WaitForChild("ClientItem"):WaitForChild("ClientViewModel"))
local v_u_6 = v2.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild("ScepterExplosionParticles"):WaitForChild("Attachment")
local v_u_7 = v2.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild("ScepterTransformParticles"):WaitForChild("Attachment")
local v_u_8 = v2.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild("ScepterCastParticles"):WaitForChild("Attachment")
local v_u_9 = setmetatable({}, v_u_5)
v_u_9.__index = v_u_9
function v_u_9.new(...)
    local v10 = v_u_5.new(...)
    local v11 = v_u_9
    local v12 = setmetatable(v10, v11)
    v12._cast_attachment = v12.ItemModel:FindFirstChild("_scepter_cast", true)
    v12:_Init()
    return v12
end
function v_u_9.ExplosionEffect(_, p13, p14)
    local v15 = Instance.new("Part")
    v15.CanCollide = false
    v15.CanQuery = false
    v15.Anchored = true
    v15.CanTouch = false
    v15.Transparency = 1
    v15.CFrame = CFrame.new(p13)
    v15.Parent = workspace
    v_u_3:AddItem(v15, 5)
    v_u_4:CreateSound("rbxassetid://104637136404553", 1, 2 + 0.5 * math.random(), v15, true, 10)
    local v16 = v_u_6:Clone()
    for _, v17 in pairs(v16:GetChildren()) do
        if v17:IsA("ParticleEmitter") then
            v_u_4:ScaleParticleEmitter(v17, p14 / 4)
        end
    end
    v16.PointLight.Range = p14 * 2
    v16.Parent = v15
    v_u_4:PlayParticles(v16)
end
function v_u_9.PlayCastParticles(p18, p19, p20)
    local v21 = p18._cast_attachment
    if p19 then
        v21 = Instance.new("Part")
        v21.CanCollide = false
        v21.CanQuery = false
        v21.CanTouch = false
        v21.Anchored = true
        v21.Transparency = 1
        v21.CFrame = CFrame.new(p19)
        v21.Parent = workspace
        v_u_3:AddItem(v21, 5)
    end
    local v22 = v_u_8:Clone()
    v22.Parent = v21
    v_u_3:AddItem(v22, 5)
    if p20 then
        for _, v23 in pairs(v22:GetDescendants()) do
            if v23:IsA("ParticleEmitter") then
                v_u_4:ScaleParticleEmitter(v23, p20)
            end
        end
    end
    v_u_4:PlayParticles(v22)
end
function v_u_9.TransformProjectile(_, p24, p25)
    if p24 and p25 then
        v_u_4:CreateSound("rbxassetid://81429998577064", 1, 1.5 + 0.5 * math.random(), p24, true, 10)
        p25.Part.Normal:Destroy()
        for _, v26 in pairs(p25.Part.Transformed:GetDescendants()) do
            if v26:IsA("Trail") or v26:IsA("ParticleEmitter") then
                v26.Enabled = true
            end
        end
        local v27 = v_u_7:Clone()
        v27.Parent = p25.Part
        v_u_4:PlayParticles(v27)
    end
end
function v_u_9._Init(p_u_28)
    task.defer(function()
        p_u_28.ClientItem.ProjectileShot:Connect(function()
            p_u_28:PlayCastParticles()
        end)
    end)
end
return v_u_9