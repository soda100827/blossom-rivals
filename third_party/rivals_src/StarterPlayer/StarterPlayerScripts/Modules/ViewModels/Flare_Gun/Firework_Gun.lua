local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("RunService")
local v3 = game:GetService("Players")
local v_u_4 = require(v1.Modules.Utility)
local v_u_5 = require(v3.LocalPlayer.PlayerScripts.Modules.ViewModels["Flare Gun"])
local v_u_6 = setmetatable({}, v_u_5)
v_u_6.__index = v_u_6
function v_u_6.new(...)
    local v7 = v_u_5.new(...)
    local v8 = v_u_6
    local v9 = setmetatable(v7, v8)
    v9:_Init()
    return v9
end
function v_u_6._Init(p_u_10)
    task.defer(function()
        p_u_10.ClientItem.ProjectileShot:Connect(function(p11, _, p12)
            local v13 = p12.Primary
            local v14 = p12.Primary.explode
            v_u_4:CreateSound("rbxassetid://17684836623", 1.25, 1, v13, true, 5)
            local v15 = tick() + 0.5
            while not p_u_10._destroyed and (p12:IsDescendantOf(workspace) and (tick() < v15 or p11.Velocity.Y >= 0)) do
                v_u_2.RenderStepped:Wait()
            end
            v_u_4:PlayParticles(v14)
            v_u_4:CreateSound("rbxassetid://17684836889", 1.25, 1, v13, true, 5)
        end)
    end)
end
return v_u_6