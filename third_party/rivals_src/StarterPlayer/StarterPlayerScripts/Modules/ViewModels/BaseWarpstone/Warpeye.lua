local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.Utility)
local v_u_4 = require(v2.LocalPlayer.PlayerScripts.Modules.ViewModels.BaseWarpstone)
local v_u_5 = setmetatable({}, v_u_4)
v_u_5.__index = v_u_5
function v_u_5.new(...)
    local v6 = v_u_4.new(...)
    local v7 = v_u_5
    local v8 = setmetatable(v6, v7)
    v8:_Init()
    return v8
end
function v_u_5._Init(p_u_9)
    task.defer(function()
        p_u_9.ClientItem.ProjectileThrown:Connect(function(p10, _)
            p_u_9:_PlayWarpstoneSounds(v_u_3:CreateSound("rbxassetid://132455961912409", 0.5, 0.9 + 0.2 * math.random(), p10, true))
        end)
    end)
end
return v_u_5