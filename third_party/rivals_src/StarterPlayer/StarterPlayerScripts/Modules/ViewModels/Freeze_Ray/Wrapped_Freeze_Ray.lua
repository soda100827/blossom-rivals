local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.BetterDebris)
local v_u_4 = require(v1.Modules.Utility)
local v_u_5 = require(v2.LocalPlayer.PlayerScripts.Modules.ViewModels["Freeze Ray"])
local v_u_6 = v2.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild("WrappedFreezeRayExplosionEffect")
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
    local v13 = v_u_6:Clone()
    v13.CFrame = CFrame.new(p11)
    v13.Parent = workspace
    v_u_3:AddItem(v13, 5)
    v_u_4:CreateSound("rbxassetid://18429092842", 0.4, 1 + 0.2 * math.random(), v13, true, 10)
    for _, v14 in pairs(v13.Attachment:GetChildren()) do
        if v14:IsA("ParticleEmitter") then
            v_u_4:ScaleParticleEmitter(v14, p12 / 4)
        end
    end
    v_u_4:PlayParticles(v13.Attachment)
end
function v_u_7._Init(_) end
return v_u_7