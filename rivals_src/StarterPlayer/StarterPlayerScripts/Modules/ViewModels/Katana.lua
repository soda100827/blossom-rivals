local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.Utility)
local v_u_4 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("ClientReplicatedClasses"):WaitForChild("ClientFighter"):WaitForChild("ClientItem"):WaitForChild("ClientViewModel"))
local v_u_5 = v2.LocalPlayer.PlayerScripts.Assets.Misc.DeflectActiveEffects
local v_u_6 = v2.LocalPlayer.PlayerScripts.Assets.Misc.DeflectHitEffects
local v_u_7 = setmetatable({}, v_u_4)
v_u_7.__index = v_u_7
function v_u_7.new(...)
    local v8 = v_u_4.new(...)
    local v9 = v_u_7
    local v10 = setmetatable(v8, v9)
    v10._deflect_hit_attachment = nil
    v10._deflect_active_attachment = nil
    v10._deflect_active_attachment_not_local = nil
    v10:_Init()
    return v10
end
function v_u_7.PlayDeflectActiveParticles(p11)
    v_u_3:PlayParticles(p11._deflect_active_attachment)
    if not p11.ClientItem.ClientFighter:Get("IsSpectating") then
        local v12 = p11._deflect_active_attachment_not_local
        local v13
        if p11.ClientItem.ClientFighter.Entity then
            v13 = p11.ClientItem.ClientFighter.Entity.RootPart or nil
        else
            v13 = nil
        end
        v12.Parent = v13
        v_u_3:PlayParticles(p11._deflect_active_attachment_not_local)
    end
end
function v_u_7.PlayDeflectHitParticles(p14)
    v_u_3:PlayParticles(p14._deflect_hit_attachment)
end
function v_u_7.PlayDeflectHitSounds(p15)
    p15:CreateSound("rbxassetid://14776414133", 1.25, 1.5 + 0.5 * math.random(), true, 5)
    p15:CreateSound("rbxassetid://14776437962", 1, 0.9 + 0.2 * math.random(), true, 5)
end
function v_u_7.ClearDeflectActiveParticles(p16)
    for _, v17 in pairs(p16._deflect_active_attachment_not_local:GetDescendants()) do
        if v17:IsA("ParticleEmitter") then
            v17:Clear()
        end
    end
end
function v_u_7.Destroy(p18)
    p18._deflect_active_attachment_not_local:Destroy()
    v_u_4.Destroy(p18)
end
function v_u_7._Setup(p19)
    p19._deflect_hit_attachment = p19.ItemModel:FindFirstChild("_katana_deflect_hit", true)
    p19._deflect_active_attachment = p19.ItemModel:FindFirstChild("_katana_deflect_active", true)
    if p19._deflect_hit_attachment then
        for _, v20 in pairs((v_u_6:FindFirstChild(p19.Name) or v_u_6.Default).Attachment:GetChildren()) do
            v20:Clone().Parent = p19._deflect_hit_attachment
        end
    end
    if p19._deflect_active_attachment then
        local v21 = v_u_5:FindFirstChild(p19.Name) or v_u_5.Default
        for _, v22 in pairs(v21.Attachment:GetChildren()) do
            v22:Clone().Parent = p19._deflect_active_attachment
        end
        p19._deflect_active_attachment_not_local = Instance.new("Attachment")
        p19._deflect_active_attachment_not_local.Name = "_katana_deflect_active_not_local"
        for _, v23 in pairs(v21.NotLocal:GetChildren()) do
            v23:Clone().Parent = p19._deflect_active_attachment_not_local
        end
    end
end
function v_u_7._Init(p24)
    p24:_Setup()
end
return v_u_7