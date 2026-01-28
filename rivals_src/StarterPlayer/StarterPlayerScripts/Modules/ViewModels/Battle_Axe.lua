local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.BetterDebris)
local v_u_4 = require(v1.Modules.Utility)
local v_u_5 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("ClientReplicatedClasses"):WaitForChild("ClientFighter"):WaitForChild("ClientItem"):WaitForChild("ClientViewModel"))
local v_u_6 = v2.LocalPlayer.PlayerScripts.Assets.Misc.BattleAxeSpinParticles.Attachment
local v_u_7 = setmetatable({}, v_u_5)
v_u_7.__index = v_u_7
function v_u_7.new(...)
    local v8 = v_u_5.new(...)
    local v9 = v_u_7
    local v10 = setmetatable(v8, v9)
    v10:_Init()
    return v10
end
function v_u_7.PlaySpinParticles(p11)
    local v12 = v_u_6:Clone()
    v12.Parent = p11.ClientItem.ClientFighter.Entity.RootPart
    v_u_3:AddItem(v12, 3)
    v_u_4:PlayParticles(v12)
    for _, v13 in pairs(v12:GetChildren()) do
        if v13:IsA("ParticleEmitter") then
            v13:SetAttribute("IgnoreVisibilityCheck", true)
            v_u_4:ScaleParticleEmitter(v13, p11.ClientItem.Info.SpinRadius / 3)
        end
    end
end
function v_u_7._Init(_) end
return v_u_7