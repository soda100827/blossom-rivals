local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.BetterDebris)
local v_u_4 = require(v1.Modules.Utility)
local v_u_5 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("ClientReplicatedClasses"):WaitForChild("ClientFighter"):WaitForChild("ClientItem"):WaitForChild("ClientViewModel"))
local v_u_6 = v2.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild("ExogunExplosionParticles")
local v_u_7 = ColorSequence.new(Color3.fromRGB(131, 255, 117))
local v_u_8 = setmetatable({}, v_u_5)
v_u_8.__index = v_u_8
function v_u_8.new(...)
    local v9 = v_u_5.new(...)
    local v10 = v_u_8
    local v11 = setmetatable(v9, v10)
    v11._reload_attachment = v11.Model:FindFirstChild("_exogun_reload", true)
    v11:_Init()
    return v11
end
function v_u_8.GetFriendlyTracerColor(_)
    return v_u_7
end
function v_u_8.ExplosionEffect(_, p12, p13, p14, _)
    local v15 = (p14 or v_u_6):Clone()
    v15.CFrame = CFrame.new(p12)
    v15.Parent = workspace
    v_u_3:AddItem(v15, 5)
    v_u_4:CreateSound("rbxassetid://17245106793", 0.375, 1 + 0.5 * math.random(), v15, true, 10)
    for _, v16 in pairs(v15.Attachment:GetChildren()) do
        if v16:IsA("ParticleEmitter") then
            v_u_4:ScaleParticleEmitter(v16, p13 / 8)
        end
    end
    v_u_4:PlayParticles(v15.Attachment)
end
function v_u_8.PlayReloadParticles(p17)
    for _, v18 in pairs(p17._reload_attachment:GetChildren()) do
        v18:Emit(20)
    end
end
function v_u_8._Init(_) end
return v_u_8