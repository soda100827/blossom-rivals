local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("Players")
require(v1.Modules.DuelLibrary)
local v_u_3 = require(v1.Modules.Utility)
local v_u_4 = require(v_u_2.LocalPlayer.PlayerScripts.Modules:WaitForChild("ClientReplicatedClasses"):WaitForChild("ClientFighter"):WaitForChild("ClientItem"):WaitForChild("ClientViewModel"))
local _ = {
    Color3.fromRGB(255, 50, 0),
    Color3.fromRGB(255, 100, 0),
    Color3.fromRGB(255, 200, 0),
    Color3.fromRGB(100, 255, 0),
    Color3.fromRGB(0, 50, 255),
    Color3.fromRGB(100, 0, 255)
}
local v_u_5 = setmetatable({}, v_u_4)
v_u_5.__index = v_u_5
function v_u_5.new(...)
    local v6 = v_u_4.new(...)
    local v7 = v_u_5
    local v8 = setmetatable(v6, v7)
    v8.ShellSubModel = v8.ItemModel:WaitForChild("Shell")
    v8:_Init()
    return v8
end
function v_u_5._UpdateAmmoVisual(p9)
    local v10 = p9.ClientItem:Get("Ammo") > 0 and 0 or 1
    for _, v11 in pairs(p9.ShellSubModel:GetChildren()) do
        if v11:IsA("BasePart") then
            p9:_LocalTransparencyModifier(v11, "AmmoVisual", v10)
        end
    end
end
function v_u_5._Init(p_u_12)
    p_u_12.ClientItem:GetDataChangedSignal("Ammo"):Connect(function()
        p_u_12:_UpdateAmmoVisual()
    end)
    task.defer(function()
        p_u_12.ClientItem.ProjectileShot:Connect(function(_, _, p13)
            local v14 = p_u_12.ClientItem.ClientFighter.Player:GetAttribute("TeamID")
            local v15 = not p_u_12.ClientItem.ClientFighter.IsLocalPlayer
            if v15 then
                v15 = not v14 or v14 ~= v_u_2.LocalPlayer:GetAttribute("TeamID")
            end
            local v16 = v15 and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(47, 255, 0)
            local v17, v18, v19 = v16:ToHSV()
            local v20 = Color3.fromHSV(v17, v18 * 0.875, v19)
            for _, v21 in pairs(p13:GetDescendants()) do
                if not v21:GetAttribute("IgnoreRecolor") then
                    local v22 = v21:GetAttribute("IsDangerParticle") and v16 and v16 or v20
                    if v21:IsA("ParticleEmitter") or v21:IsA("Trail") then
                        v21.Color = ColorSequence.new(v22)
                    elseif v21:IsA("Light") then
                        v21.Color = v22
                    end
                end
            end
            v_u_3:CreateSound("rbxassetid://17331783148", 1.25, 1, p13.Primary, true).Looped = true
        end)
    end)
    p_u_12:_UpdateAmmoVisual()
end
return v_u_5