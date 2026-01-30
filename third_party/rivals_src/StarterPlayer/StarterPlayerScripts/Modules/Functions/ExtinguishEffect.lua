local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.BetterDebris)
local v_u_4 = require(v1.Modules.Utility)
local v_u_5 = v2.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild("ExtinguishParticles")
return function(p6)
    local v7 = v_u_5:Clone()
    v7.CFrame = p6
    v7.Parent = workspace
    v_u_3:AddItem(v7, 10)
    v_u_4:CreateSound("rbxassetid://16812185839", 0.75, 1.3 + 0.2 * math.random(), v7, true)
    v_u_4:CreateSound("rbxassetid://16812389263", 0.75, 1.3 + 0.2 * math.random(), v7, true)
    v_u_4:PlayParticles(v7.Attachment)
end