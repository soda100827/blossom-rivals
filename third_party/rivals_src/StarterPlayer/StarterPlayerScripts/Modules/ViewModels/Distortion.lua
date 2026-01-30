local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.BetterDebris)
local v_u_4 = require(v1.Modules.Utility)
local v_u_5 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("ClientReplicatedClasses"):WaitForChild("ClientFighter"):WaitForChild("ClientItem"):WaitForChild("ClientViewModel"))
local v_u_6 = v2.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild("DistortionExplosionParticles")
local v_u_7 = ColorSequence.new(Color3.fromRGB(0, 255, 149))
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
function v_u_8.ExplosionEffect(_, p_u_12, p_u_13, p_u_14)
    task.delay(math.random() * 0.2, function()
        local v15 = (p_u_14 or v_u_6):Clone()
        v15.CFrame = CFrame.new(p_u_12)
        v15.Parent = workspace
        v_u_3:AddItem(v15, 5)
        v_u_4:CreateSound("rbxassetid://97822830667649", 0.375, 0.75 + 1.25 * math.random(), v15, true, 10)
        for _, v16 in pairs(v15.Attachment:GetChildren()) do
            if v16:IsA("ParticleEmitter") then
                v_u_4:ScaleParticleEmitter(v16, p_u_13 / 4)
            end
        end
        v_u_4:PlayParticles(v15.Attachment)
    end)
end
function v_u_8._Init(_) end
return v_u_8