local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.BetterDebris)
local v_u_4 = require(v1.Modules.Utility)
local v_u_5 = require(v2.LocalPlayer.PlayerScripts.Modules.ViewModels["Grenade Launcher"])
local v_u_6 = v2.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild("SkullLauncherExplosionEffect")
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
    v_u_4:CreateSound("rbxassetid://13455969017", 0.25, 0.75 + 0.15 * math.random(), v13, true, 10)
    v_u_4:CreateSound("rbxassetid://117341396180451", 0.625, 0.9 + 0.1 * math.random(), v13, true, 10)
    for _, v14 in pairs(v_u_6:GetChildren()) do
        v14:Clone().Parent = v13
    end
    for _, v15 in pairs(v13:GetDescendants()) do
        if v15:IsA("ParticleEmitter") then
            v_u_4:ScaleParticleEmitter(v15, p12 / 24)
        end
    end
    v_u_4:PlayParticles(v13)
end
function v_u_7._Init(_) end
return v_u_7