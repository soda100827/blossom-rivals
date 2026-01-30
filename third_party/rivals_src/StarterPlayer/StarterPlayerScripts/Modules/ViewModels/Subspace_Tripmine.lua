local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.BetterDebris)
local v_u_4 = require(v1.Modules.Utility)
local v_u_5 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("ClientReplicatedClasses"):WaitForChild("ClientFighter"):WaitForChild("ClientItem"):WaitForChild("ClientViewModel"))
local v_u_6 = v2.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild("SubspaceTripmineExplosion")
local v_u_7 = setmetatable({}, v_u_5)
v_u_7.__index = v_u_7
function v_u_7.new(...)
    local v8 = v_u_5.new(...)
    local v9 = v_u_7
    local v10 = setmetatable(v8, v9)
    v10:_Init()
    return v10
end
function v_u_7.PlayHideMineSound(_, p11)
    v_u_4:CreateSound("rbxassetid://11956590", 1, 1, p11.Hitbox, true, 5)
end
function v_u_7.ExplosionEffect(p12, p13)
    v_u_4:CreateSound("rbxassetid://11984351", 0.5, 1, p13, true, 10)
    v_u_4:CreateSound("rbxassetid://11984254", 1, 0.75, p13, true, 10)
    local v14 = v_u_6:Clone()
    v14.CFrame = CFrame.new(p13)
    v14.PointLight.Range = p12.ClientItem.Info.ExplosionRadius * 3
    v14.Parent = workspace
    v_u_3:AddItem(v14, 5)
    wait(1)
    v14.Sparkles.Enabled = false
    local v_u_15 = v14.PointLight
    v_u_4:RenderstepForLoop(0, 100, 1, function(p16)
        v_u_15.Brightness = 40 * (1 - (p16 / 100) ^ 4)
    end)
end
function v_u_7._Init(_) end
return v_u_7