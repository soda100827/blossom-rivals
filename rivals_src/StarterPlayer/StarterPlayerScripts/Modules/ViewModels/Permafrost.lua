local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.BetterDebris)
local v_u_4 = require(v1.Modules.Utility)
local v_u_5 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("ClientReplicatedClasses"):WaitForChild("ClientFighter"):WaitForChild("ClientItem"):WaitForChild("ClientViewModel"))
local v_u_6 = v2.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild("FreezeRayExplosionEffect")
local v_u_7 = ColorSequence.new(Color3.fromRGB(30, 225, 255))
local v_u_8 = setmetatable({}, v_u_5)
v_u_8.__index = v_u_8
function v_u_8.new(...)
    local v9 = v_u_5.new(...)
    local v10 = v_u_8
    local v11 = setmetatable(v9, v10)
    v11._gauge_tickers = {}
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
    v_u_4:CreateSound("rbxassetid://18429092842", 0.4, 1 + 0.2 * math.random(), v14, true, 10)
    for _, v15 in pairs(v14.Attachment:GetChildren()) do
        if v15:IsA("ParticleEmitter") then
            v_u_4:ScaleParticleEmitter(v15, p13 / 4)
        end
    end
    v_u_4:PlayParticles(v14.Attachment)
end
function v_u_8._UpdateGaugeTickers(p16)
    local v17 = -45 - 270 * (1 - p16.ClientItem:Get("Ammo") / p16.ClientItem.Info.MaxAmmo)
    for _, v18 in pairs(p16._gauge_tickers) do
        v18.Rotation = v17
    end
end
function v_u_8._Setup(p19)
    for _, v20 in pairs(p19.ItemModel:GetDescendants()) do
        if v20:HasTag("PermafrostGaugeTicker") then
            local v21 = p19._gauge_tickers
            table.insert(v21, v20)
        end
    end
end
function v_u_8._Init(p_u_22)
    p_u_22.ClientItem:GetDataChangedSignal("MaxAmmo"):Connect(function()
        p_u_22:_UpdateGaugeTickers()
    end)
    p_u_22.ClientItem:GetDataChangedSignal("Ammo"):Connect(function()
        p_u_22:_UpdateGaugeTickers()
    end)
    p_u_22:_Setup()
    p_u_22:_UpdateGaugeTickers()
end
return v_u_8