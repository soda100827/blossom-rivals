local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.BetterDebris)
local v_u_4 = require(v1.Modules.Utility)
local v_u_5 = v2.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild("CollectEffect"):WaitForChild("Attachment")
return function(p6, p7, p8, p9)
    local v10 = Instance.new("Part")
    v10.CanCollide = false
    v10.CanQuery = false
    v10.CanTouch = false
    v10.Anchored = true
    v10.Transparency = 1
    v10.CFrame = CFrame.new(p6)
    v10.Parent = workspace
    v_u_3:AddItem(v10, 5)
    local v11 = v_u_5:Clone()
    v11.Parent = v10
    v_u_3:AddItem(v11, 5)
    local v12 = p9 or 1
    for _, v13 in pairs(v11:GetDescendants()) do
        if v13:IsA("ParticleEmitter") then
            v_u_4:ScaleParticleEmitter(v13, 3 * v12)
            v13.Color = p7 and ColorSequence.new(p7) or v13.Color
        end
    end
    v_u_4:PlayParticles(v11)
    if p8 then
        v_u_4:CreateSound(p8, 1.5, 1, v10, true, 10)
    end
end