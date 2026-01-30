local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.BetterDebris)
local v_u_4 = require(v1.Modules.Utility)
local v_u_5 = require(v2.LocalPlayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientEntity.ClientHumanoidEntity.ClientEnemy)
local v_u_6 = v2.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild("ExplosiveZombieExplosionEffect")
local v_u_7 = setmetatable({}, v_u_5)
v_u_7.__index = v_u_7
function v_u_7.new(...)
    local v8 = v_u_5.new(...)
    local v9 = v_u_7
    local v10 = setmetatable(v8, v9)
    v10:_Init()
    return v10
end
function v_u_7.ReplicateFromServer(p11, p12, ...)
    if p12 == "ZombieExplosionEffect" then
        if p11:IsRendered() then
            local v13, v14 = ...
            local v15 = v_u_6:Clone()
            v15.CFrame = CFrame.new(v13)
            v15.Parent = p11.Model
            v_u_3:AddItem(v15, 10)
            v_u_4:CreateSound("rbxassetid://13455969017", 0.5, 0.75, v15, true, 10)
            v_u_4:CreateSound("rbxassetid://103343386215625", 1, 0.95 + 0.1 * math.random(), v15, true, 10)
            for _, v16 in pairs(v15:GetDescendants()) do
                if v16:IsA("ParticleEmitter") then
                    v_u_4:ScaleParticleEmitter(v16, v14 / 3)
                end
            end
            v_u_4:PlayParticles(v15)
        end
    else
        v_u_5.ReplicateFromServer(p11, p12, ...)
        return
    end
end
function v_u_7._Init(_) end
return v_u_7