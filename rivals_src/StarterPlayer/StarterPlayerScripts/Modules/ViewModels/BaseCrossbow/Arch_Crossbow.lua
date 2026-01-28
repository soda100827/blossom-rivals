local v1 = game:GetService("Players")
local v_u_2 = require(v1.LocalPlayer.PlayerScripts.Modules.ViewModels.BaseCrossbow)
local v_u_3 = ColorSequence.new(Color3.fromRGB(8, 255, 152))
local v_u_4 = setmetatable({}, v_u_2)
v_u_4.__index = v_u_4
function v_u_4.new(...)
    local v5 = v_u_2.new(...)
    local v6 = v_u_4
    local v7 = setmetatable(v5, v6)
    v7.ShouldPlayReloadAnimationInstantly = true
    v7._is_empty = nil
    v7:_Init()
    return v7
end
function v_u_4.GetFriendlyTracerColor(_)
    return v_u_3
end
function v_u_4._UpdateDefaultAnimationsFromAmmo(p8)
    local v9 = p8.ClientItem:Get("Ammo")
    p8.ClientItem:Get("AmmoReserve")
    local v10 = v9 <= 0
    if v10 ~= p8._is_empty then
        p8._is_empty = v10
        p8:ChangeInspectAnimation("Inspect" .. (p8._is_empty and "Empty" or ""))
    end
end
function v_u_4._Init(p_u_11)
    p_u_11.ClientItem:GetDataChangedSignal("AmmoReserve"):Connect(function()
        p_u_11:_UpdateDefaultAnimationsFromAmmo()
    end)
    p_u_11.ClientItem:GetDataChangedSignal("Ammo"):Connect(function()
        p_u_11:_UpdateDefaultAnimationsFromAmmo()
    end)
    p_u_11:_UpdateDefaultAnimationsFromAmmo()
    p_u_11:_RegisterAmmoVisual(p_u_11.ItemModel:WaitForChild("Arrow"):WaitForChild("MeshPart"))
    p_u_11:_RegisterAmmoVisual(p_u_11.ItemModel:WaitForChild("Arrow"):WaitForChild("MeshPart"):WaitForChild("Attachment"):WaitForChild("arrow"))
end
return v_u_4