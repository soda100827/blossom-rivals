local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.BetterDebris)
local v_u_4 = require(v1.Modules.Utility)
local v_u_5 = require(v2.LocalPlayer.PlayerScripts.Modules.ViewModels.BaseRPG)
local v_u_6 = v2.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild("RPKEYExplosionEffect"):WaitForChild("Attachment")
local v_u_7 = setmetatable({}, v_u_5)
v_u_7.__index = v_u_7
function v_u_7.new(...)
    local v8 = v_u_5.new(...)
    local v9 = v_u_7
    local v10 = setmetatable(v8, v9)
    v10:_Init()
    return v10
end
function v_u_7.PlayAimSound(p11, p12)
    p11:CreateSound("rbxassetid://96253147006478", 0.375, 2 + (p12 and 0.1 or 0), true, 5)
end
function v_u_7.ExplosionEffect(_, p13, p14)
    local v15 = Instance.new("Part")
    v15.CanCollide = false
    v15.CanQuery = false
    v15.Anchored = true
    v15.Transparency = 1
    v15.CFrame = CFrame.new(p13)
    v15.Parent = workspace
    v_u_3:AddItem(v15, 5)
    v_u_4:CreateSound("rbxassetid://13455969017", 0.5, 0.9 + 0.2 * math.random(), v15, true, 10)
    v_u_4:CreateSound("rbxassetid://18179281854", 2, 0.9 + 0.2 * math.random(), v15, true, 10)
    local v16 = v_u_6:Clone()
    for _, v17 in pairs(v16:GetChildren()) do
        if v17:IsA("ParticleEmitter") then
            v_u_4:ScaleParticleEmitter(v17, p14 / 20)
        end
    end
    v16.PointLight.Range = p14 * 2
    v16.Parent = v15
    v_u_4:PlayParticles(v16)
end
function v_u_7._Init(p18)
    p18:_RegisterAmmoVisual(p18.ItemModel:WaitForChild("Rocket"):WaitForChild("Head"))
end
return v_u_7