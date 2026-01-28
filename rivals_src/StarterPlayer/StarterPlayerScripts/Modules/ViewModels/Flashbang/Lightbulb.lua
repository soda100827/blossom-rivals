local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("RunService")
local v3 = game:GetService("Players")
local v_u_4 = require(v1.Modules.Utility)
local v_u_5 = require(v3.LocalPlayer.PlayerScripts.Modules.ViewModels.Flashbang)
local v_u_6 = setmetatable({}, v_u_5)
v_u_6.__index = v_u_6
function v_u_6.new(...)
    local v7 = v_u_5.new(...)
    local v8 = v_u_6
    local v9 = setmetatable(v7, v8)
    v9:_Init()
    return v9
end
function v_u_6.PlayFlashSound(p10, p11)
    v_u_5.PlayFlashSound(p10, p11)
    v_u_4:CreateSound("rbxassetid://137109782386847", 2, 1, p11, true, 10)
end
function v_u_6._Init(p_u_12)
    task.defer(function()
        local v13 = p_u_12._connections
        local v14 = p_u_12.ClientItem.ProjectileThrown
        local function v20(p15, p16)
            local v17 = p16.Neon
            local v18 = tick()
            while p15:IsDescendantOf(workspace) do
                local v19 = (tick() - v18) / p_u_12.ClientItem.Info.DetonateDelay
                v17.Transparency = 1 - math.min(1, v19) ^ 4
                v_u_2.RenderStepped:Wait()
            end
        end
        table.insert(v13, v14:Connect(v20))
    end)
end
return v_u_6