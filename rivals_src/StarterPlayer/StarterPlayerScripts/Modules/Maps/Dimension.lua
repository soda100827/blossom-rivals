local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.Utility)
local v_u_4 = require(v_u_2.LocalPlayer.PlayerScripts.Controllers.FighterController)
local v_u_5 = require(v_u_2.LocalPlayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientDuel.ClientMap)
local v_u_6 = setmetatable({}, v_u_5)
v_u_6.__index = v_u_6
function v_u_6.new(...)
    local v7 = v_u_5.new(...)
    local v8 = v_u_6
    local v9 = setmetatable(v7, v8)
    v9.Entrance = v9.Model:WaitForChild("Portals"):WaitForChild("Entrance"):WaitForChild("Hitbox")
    v9.Exit = v9.Model:WaitForChild("Portals"):WaitForChild("Exit"):WaitForChild("Hitbox")
    v9._teleport_cooldown = 0
    v9:_Init()
    return v9
end
function v_u_6._Init(p_u_10)
    p_u_10.Entrance.Touched:Connect(function(p11)
        if tick() < p_u_10._teleport_cooldown then
            return
        elseif p11.Parent == v_u_2.LocalPlayer.Character then
            if v_u_4.LocalFighter and v_u_4.LocalFighter:IsAlive() then
                p_u_10._teleport_cooldown = tick() + 1
                v_u_4.LocalFighter.Entity:WarpTo(p_u_10.Exit.CFrame)
                v_u_3:CreateSound("rbxassetid://86785771664692", 0.5, 1 + 0.1 * math.random(), p_u_10.Entrance, true, 10)
                v_u_3:CreateSound("rbxassetid://81610952487049", 1, 1 + 0.1 * math.random(), p_u_10.Exit, true, 10)
            end
        else
            return
        end
    end)
end
return v_u_6