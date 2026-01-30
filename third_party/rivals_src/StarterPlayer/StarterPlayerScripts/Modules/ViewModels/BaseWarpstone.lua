local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.Utility)
local v_u_4 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("ClientReplicatedClasses"):WaitForChild("ClientFighter"):WaitForChild("ClientItem"):WaitForChild("ClientViewModel"))
local v_u_5 = setmetatable({}, v_u_4)
v_u_5.__index = v_u_5
function v_u_5.new(...)
    local v6 = v_u_4.new(...)
    local v7 = v_u_5
    local v8 = setmetatable(v6, v7)
    v8:_Init()
    return v8
end
function v_u_5._PlayWarpstoneSounds(p_u_9, ...)
    local v_u_10 = {}
    for _, v11 in pairs({ ... }) do
        v_u_10[v11] = v11.Volume
        v11.Looped = true
    end
    v_u_3:RenderstepForLoop(0, 100, 2, function(p12)
        if p_u_9._destroyed then
            return true
        end
        local v13 = p12 / 100
        for v14, v15 in pairs(v_u_10) do
            v14.Volume = v15 * v13
        end
    end)
end
function v_u_5._Init(_) end
return v_u_5