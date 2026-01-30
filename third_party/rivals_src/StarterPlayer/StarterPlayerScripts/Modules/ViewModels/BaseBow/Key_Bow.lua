local v1 = game:GetService("Players")
local v_u_2 = require(v1.LocalPlayer.PlayerScripts.Modules.ViewModels.BaseBow)
local v_u_3 = {
    Color3.fromRGB(191, 191, 191),
    Color3.fromRGB(250, 228, 116),
    Color3.fromRGB(248, 214, 44),
    Color3.fromRGB(229, 192, 6)
}
local v_u_4 = setmetatable({}, v_u_2)
v_u_4.__index = v_u_4
function v_u_4.new(...)
    local v5 = v_u_2.new(...)
    local v6 = v_u_4
    local v7 = setmetatable(v5, v6)
    v7:_Init()
    return v7
end
function v_u_4.GetChargeColor(_, p8)
    return v_u_3[p8]
end
function v_u_4.PlayChargeSound(p9, p10)
    v_u_2.PlayChargeSound(p9, p10)
    p9:CreateSound("rbxassetid://90757583550672", 0.5, 1.25 + 0.25 * p10, true, 5)
    p9:CreateSound("rbxassetid://90757583550672", 0.125, 1, true, 5)
end
function v_u_4._UpdateAmmoContext(p11)
    local v12 = p11.ClientItem:Get("Ammo") <= 0
    if v12 ~= p11._is_empty then
        p11._is_empty = v12
        p11:ChangeInspectAnimation(p11._is_empty and "InspectEmpty" or "Inspect")
        p11.Animator:ChangeRareInspectAnimation(p11._is_empty and "nil" or "RareInspect")
    end
end
function v_u_4._Init(p_u_13)
    p_u_13.ClientItem:GetDataChangedSignal("AmmoReserve"):Connect(function()
        p_u_13:_UpdateAmmoContext()
    end)
    p_u_13.ClientItem:GetDataChangedSignal("Ammo"):Connect(function()
        p_u_13:_UpdateAmmoContext()
    end)
    p_u_13:_UpdateAmmoContext()
    p_u_13:_RegisterAmmoVisual(p_u_13.ItemModel:WaitForChild("Arrow"):WaitForChild("Stick"))
end
return v_u_4