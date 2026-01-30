local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.BetterDebris)
local v_u_4 = require(v1.Modules.Utility)
local v_u_5 = require(v2.LocalPlayer.PlayerScripts.Modules.ViewModels["Subspace Tripmine"])
local v_u_6 = v2.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild("SpringExplosionEffect")
local v_u_7 = setmetatable({}, v_u_5)
v_u_7.__index = v_u_7
function v_u_7.new(...)
    local v8 = v_u_5.new(...)
    local v9 = v_u_7
    local v10 = setmetatable(v8, v9)
    v10:_Init()
    return v10
end
function v_u_7.ExplosionEffect(_, p11)
    v_u_4:CreateSound("rbxassetid://18763806953", 1.75, 0.9 + 0.2 * math.random(), p11, true, 10)
    v_u_4:CreateSound("rbxassetid://105724753475729", 1.5, 0.9 + 0.2 * math.random(), p11, true, 10)
    local v12 = v_u_6:Clone()
    v12.CFrame = CFrame.new(p11)
    v12.Parent = workspace
    v_u_3:AddItem(v12, 5)
    v_u_4:PlayParticles(v12)
end
function v_u_7._Init(_) end
return v_u_7