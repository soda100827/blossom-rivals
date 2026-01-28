local v1 = game:GetService("Players")
local v_u_2 = require(v1.LocalPlayer.PlayerScripts.Modules.ViewModels.BaseBow)
local v_u_3 = setmetatable({}, v_u_2)
v_u_3.__index = v_u_3
function v_u_3.new(...)
    local v4 = v_u_2.new(...)
    local v5 = v_u_3
    local v6 = setmetatable(v4, v5)
    v6:_Init()
    return v6
end
function v_u_3.PlayChargeSound(p7, p8)
    v_u_2.PlayChargeSound(p7, p8)
    p7:CreateSound("rbxassetid://117872201487330", 0.5, 0.5 + 0.1 * p8, true, 10)
end
function v_u_3._Init(p9)
    p9:_RegisterAmmoVisual(p9.ItemModel:WaitForChild("Arrow"):WaitForChild("Feather"))
    p9:_RegisterAmmoVisual(p9.ItemModel:WaitForChild("Arrow"):WaitForChild("Stick"))
    p9:_RegisterAmmoVisual(p9.ItemModel:WaitForChild("Arrow"):WaitForChild("Tip"))
end
return v_u_3