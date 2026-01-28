local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
require(v1.Modules.Utility)
local v_u_3 = require(v2.LocalPlayer.PlayerScripts.Controllers.FunctionsController)
local v_u_4 = require(v2.LocalPlayer.PlayerScripts.Modules.ViewModels["Subspace Tripmine"])
local v_u_5 = setmetatable({}, v_u_4)
v_u_5.__index = v_u_5
function v_u_5.new(...)
    local v6 = v_u_4.new(...)
    local v7 = v_u_5
    local v8 = setmetatable(v6, v7)
    v8:_Init()
    return v8
end
function v_u_5.ExplosionEffect(p9, p10)
    for v11 = 1, 3 do
        local v12 = 10 * (math.random() - 0.5)
        local v13 = v11 ^ 2
        local v14 = 10 * (math.random() - 0.5)
        local v15 = p10 + Vector3.new(v12, v13, v14)
        local v16 = p9.ClientItem.Info.ExplosionRadius * (1 + 1 * math.random())
        v_u_3:FireAsync(p9:ToEnum("ExplosionEffect"), v15, v16, 1 + 0.25 * (v11 - 1))
        wait(0.1)
    end
end
function v_u_5._Init(_) end
return v_u_5