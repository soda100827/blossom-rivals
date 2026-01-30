local v1 = game:GetService("Players")
local v_u_2 = require(v1.LocalPlayer.PlayerScripts.Controllers.FunctionsController)
local v_u_3 = require(v1.LocalPlayer.PlayerScripts.Modules.ViewModels.BaseRPG)
local v_u_4 = setmetatable({}, v_u_3)
v_u_4.__index = v_u_4
function v_u_4.new(...)
    local v5 = v_u_3.new(...)
    local v6 = v_u_4
    local v7 = setmetatable(v5, v6)
    v7:_Init()
    return v7
end
function v_u_4.ExplosionEffect(p8, p9, p10)
    v_u_2:FireAsync(p8:ToEnum("NukeEffect"), p9, p10, nil, true)
end
function v_u_4._Init(p11)
    p11:_RegisterAmmoVisual(p11.ItemModel:WaitForChild("Rocket"):WaitForChild("Head"))
    p11:_RegisterAmmoVisual(p11.ItemModel:WaitForChild("Rocket"):WaitForChild("Neck"))
end
return v_u_4