local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.BetterDebris)
local v_u_4 = require(v1.Modules.Utility)
local v_u_5 = require(v2.LocalPlayer.PlayerScripts.Modules.ViewModels.Exogun)
local v_u_6 = v2.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild("RepulsorExplosionParticles")
local v_u_7 = ColorSequence.new(Color3.fromRGB(55, 218, 255))
local v_u_8 = setmetatable({}, v_u_5)
v_u_8.__index = v_u_8
function v_u_8.new(...)
    local v9 = v_u_5.new(...)
    local v10 = v_u_8
    local v11 = setmetatable(v9, v10)
    v11:_Init()
    return v11
end
function v_u_8.GetFriendlyTracerColor(_)
    return v_u_7
end
function v_u_8.ExplosionEffect(_, p12, p13)
    local v14 = v_u_6:Clone()
    v14.CFrame = CFrame.new(p12)
    v14.Parent = workspace
    v_u_3:AddItem(v14, 5)
    v_u_4:CreateSound("rbxassetid://17245106793", 0.125, 1 + 0.5 * math.random(), v14, true, 10)
    v_u_4:CreateSound("rbxassetid://103974521039631", 0.375, 1 + 0.25 * math.random(), v14, true, 10)
    for _, v15 in pairs(v14.Attachment:GetChildren()) do
        if v15:IsA("ParticleEmitter") then
            v_u_4:ScaleParticleEmitter(v15, p13 / 6)
        end
    end
    v_u_4:PlayParticles(v14.Attachment)
end
function v_u_8.PlayReloadParticles(_) end
function v_u_8._Init(p_u_16)
    p_u_16.AnimationPlayed:Connect(function(p17)
        if p17 == "Reload" then
            v_u_4:PlayParticles(p_u_16._reload_attachment.Parent)
        end
    end)
end
return v_u_8