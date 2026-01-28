local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.Utility)
local v_u_4 = require(v2.LocalPlayer.PlayerScripts.Modules.ViewModels.Medkit)
local v_u_5 = setmetatable({}, v_u_4)
v_u_5.__index = v_u_5
function v_u_5.new(...)
    local v6 = v_u_4.new(...)
    local v7 = v_u_5
    local v8 = setmetatable(v6, v7)
    v8.PlayEquipAnimationOnHeal = false
    v8._heal_particles_attachment = v8.ItemModel:WaitForChild("Head"):WaitForChild("Head"):WaitForChild("_medkitty_heal")
    v8:_Init()
    return v8
end
function v_u_5._Init(p_u_9)
    task.defer(function()
        local v10 = p_u_9._connections
        local v11 = p_u_9.ClientItem.AnimationReachedHealTimestamp
        local function v12()
            v_u_3:PlayParticles(p_u_9._heal_particles_attachment)
        end
        table.insert(v10, v11:Connect(v12))
    end)
end
return v_u_5