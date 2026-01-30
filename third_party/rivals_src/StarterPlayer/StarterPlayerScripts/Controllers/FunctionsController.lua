local v_u_1 = game:GetService("ReplicatedStorage")
game:GetService("TeleportService")
local v2 = game:GetService("Players")
local v_u_3 = require(v_u_1.Modules.EnumLibrary)
local v_u_4 = v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("Functions")
local v_u_5 = {}
v_u_5.__index = v_u_5
function v_u_5._new()
    local v6 = v_u_5
    local v7 = setmetatable({}, v6)
    v7:_Init()
    return v7
end
function v_u_5.FireAsync(_, p8, ...)
    require(v_u_4[v_u_3:FromEnum(p8)])(...)
end
function v_u_5.FireSync(p9, ...)
    task.spawn(p9.FireAsync, p9, ...)
end
function v_u_5._Init(p_u_10)
    v_u_1.Remotes.Misc.TeleportFailed.OnClientEvent:Connect(function(p11)
        local v12 = {
            ["Text"] = "[SERVER] Teleport failed, please try again. Error: " .. tostring(p11),
            ["Color"] = Color3.fromRGB(255, 50, 50)
        }
        p_u_10:FireAsync(v_u_3:ToEnum("SendChat"), v12)
    end)
    v_u_1.Remotes.Misc.Functions.OnClientEvent:Connect(function(...)
        p_u_10:FireAsync(...)
    end)
    v_u_1.Remotes.Misc.FunctionsUnreliable.OnClientEvent:Connect(function(...)
        p_u_10:FireAsync(...)
    end)
end
return v_u_5._new()