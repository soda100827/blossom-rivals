local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.BetterDebris)
local v_u_4 = require(v1.Modules.Utility)
local v_u_5 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("ClientReplicatedClasses"):WaitForChild("ClientFighter"):WaitForChild("ClientItem"):WaitForChild("ClientViewModel"))
local v_u_6 = v2.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild("MolotovExplosionEffects")
local v_u_7 = setmetatable({}, v_u_5)
v_u_7.__index = v_u_7
function v_u_7.new(...)
    local v8 = v_u_5.new(...)
    local v9 = v_u_7
    local v10 = setmetatable(v8, v9)
    v10:_Init()
    return v10
end
function v_u_7.ExplosionEffect(p11, p12, p13)
    local v14 = (v_u_6:FindFirstChild(p11.Name) or v_u_6.Default):Clone()
    v14.CFrame = CFrame.new(p12, p12 + Vector3.new(0, 1, 0))
    v14.Parent = workspace
    v_u_3:AddItem(v14, 5)
    v_u_4:CreateSound("rbxassetid://17167035482", 0.25, 1.5 + 0.25 * math.random(), v14, true, 10)
    for _, v15 in pairs(v14.Attachment:GetChildren()) do
        if v15:IsA("ParticleEmitter") then
            v_u_4:ScaleParticleEmitter(v15, p13 / 16)
        end
    end
    v_u_4:PlayParticles(v14.Attachment)
    v_u_4:PlayParticles(v14.Attachment)
    return v14
end
function v_u_7._Init(_) end
return v_u_7