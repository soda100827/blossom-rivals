local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.BetterDebris)
local v_u_4 = require(v1.Modules.Utility)
local v_u_5 = require(v2.LocalPlayer.PlayerScripts.Modules.ViewModels.BaseRPG)
local v_u_6 = v2.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild("PumpkinLauncherExplosionEffect"):WaitForChild("Attachment")
local v_u_7 = setmetatable({}, v_u_5)
v_u_7.__index = v_u_7
function v_u_7.new(...)
    local v8 = v_u_5.new(...)
    local v9 = v_u_7
    local v10 = setmetatable(v8, v9)
    v10:_Init()
    return v10
end
function v_u_7.ExplosionEffect(_, p11, p12)
    local v13 = Instance.new("Part")
    v13.CanCollide = false
    v13.CanQuery = false
    v13.Anchored = true
    v13.Transparency = 1
    v13.CFrame = CFrame.new(p11)
    v13.Parent = workspace
    v_u_3:AddItem(v13, 5)
    v_u_4:CreateSound("rbxassetid://13455969017", 0.5, 0.9 + 0.2 * math.random(), v13, true, 10)
    v_u_4:CreateSound("rbxassetid://88695956388556", 1, 1 + 0.25 * math.random(), v13, true, 10)
    local v14 = v_u_6:Clone()
    for _, v15 in pairs(v14:GetChildren()) do
        if v15:IsA("ParticleEmitter") then
            v_u_4:ScaleParticleEmitter(v15, p12 / 16)
        end
    end
    v14.PointLight.Range = p12 * 2
    v14.Parent = v13
    v_u_4:PlayParticles(v14)
end
function v_u_7._Init(p_u_16)
    task.defer(function()
        p_u_16.ClientItem.ProjectileShot:Connect(function(_, _, p17)
            local v18 = v_u_4:CreateSound("rbxassetid://140716912879767", 0.25, 1, p17.Pumpkin, true)
            p17:GetAttributeChangedSignal("Destroying"):Wait()
            v18:Destroy()
        end)
    end)
    p_u_16:_RegisterAmmoVisual(p_u_16.ItemModel:WaitForChild("Rocket"):WaitForChild("Neck"))
    p_u_16:_RegisterAmmoVisual(p_u_16.ItemModel:WaitForChild("Rocket"):WaitForChild("Neon"))
    p_u_16:_RegisterAmmoVisual(p_u_16.ItemModel:WaitForChild("Rocket"):WaitForChild("Pumpkin"))
    p_u_16:_RegisterAmmoVisual(p_u_16.ItemModel:WaitForChild("Rocket"):WaitForChild("Stem"))
end
return v_u_7