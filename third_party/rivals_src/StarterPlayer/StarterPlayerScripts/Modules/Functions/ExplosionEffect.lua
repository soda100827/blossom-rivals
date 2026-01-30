local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.BetterDebris)
local v_u_4 = require(v1.Modules.Utility)
local v_u_5 = v2.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild("ExplosionEffect"):WaitForChild("Attachment")
return function(p6, p7, p8)
    local v9 = Instance.new("Part")
    v9.CanCollide = false
    v9.CanQuery = false
    v9.Anchored = true
    v9.Transparency = 1
    v9.CFrame = CFrame.new(p6)
    v9.Parent = workspace
    v_u_3:AddItem(v9, 5)
    v_u_4:CreateSound("rbxassetid://13455969017", 1, p8 or 0.9 + 0.2 * math.random(), v9, true, 10)
    local v10 = v_u_5:Clone()
    for _, v11 in pairs(v10:GetChildren()) do
        if v11:IsA("ParticleEmitter") then
            v_u_4:ScaleParticleEmitter(v11, p7 / 24)
        end
    end
    v10.PointLight.Range = p7 * 2
    v10.Parent = v9
    v_u_4:PlayParticles(v10)
end