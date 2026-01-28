local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.BetterDebris)
local v_u_4 = require(v1.Modules.Utility)
local v_u_5 = require(v2.LocalPlayer.PlayerScripts.Modules.ViewModels["Freeze Ray"])
local v_u_6 = v2.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild("BubbleRayExplosionEffect")
local v_u_7 = {
    "rbxassetid://6928709440",
    "rbxassetid://6928709814",
    "rbxassetid://6928710129",
    "rbxassetid://6928710411",
    "rbxassetid://6928710904",
    "rbxassetid://6928711244"
}
local v_u_8 = setmetatable({}, v_u_5)
v_u_8.__index = v_u_8
function v_u_8.new(...)
    local v9 = v_u_5.new(...)
    local v10 = v_u_8
    local v11 = setmetatable(v9, v10)
    v11:_Init()
    return v11
end
function v_u_8.ExplosionEffect(_, p12, p13)
    local v14 = v_u_6:Clone()
    v14.CFrame = CFrame.new(p12)
    v14.Parent = workspace
    v_u_3:AddItem(v14, 5)
    for _ = 1, 8 do
        v_u_4:CreateSound(v_u_7[math.random(#v_u_7)], 0.75, 1 + 0.2 * math.random(), v14, true, 10)
    end
    for _, v15 in pairs(v14.Attachment:GetChildren()) do
        if v15:IsA("ParticleEmitter") then
            v_u_4:ScaleParticleEmitter(v15, p13 / 8)
        end
    end
    v_u_4:PlayParticles(v14.Attachment)
end
function v_u_8._Init(_) end
return v_u_8