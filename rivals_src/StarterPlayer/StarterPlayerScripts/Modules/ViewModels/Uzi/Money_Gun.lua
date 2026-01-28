local v1 = game:GetService("Players")
local v_u_2 = require(v1.LocalPlayer.PlayerScripts.Modules.ViewModels.Uzi)
local v_u_3 = ColorSequence.new(Color3.fromRGB(0, 255, 0))
local v_u_4 = setmetatable({}, v_u_2)
v_u_4.__index = v_u_4
function v_u_4.new(...)
    local v5 = v_u_2.new(...)
    local v6 = v_u_4
    local v7 = setmetatable(v5, v6)
    v7._body_money = v7.ItemModel:WaitForChild("Body"):WaitForChild("Money")
    v7._body_money_decal1 = v7._body_money:WaitForChild("Decal1")
    v7._body_money_decal2 = v7._body_money:WaitForChild("Decal2")
    v7._magazine_money = v7.ItemModel:WaitForChild("Magazine"):WaitForChild("Money")
    v7._magazine_money_decal1 = v7._magazine_money:WaitForChild("Decal1")
    v7._magazine_money_decal2 = v7._magazine_money:WaitForChild("Decal2")
    v7:_Init()
    return v7
end
function v_u_4.GetFriendlyTracerColor(_)
    return v_u_3
end
function v_u_4._UpdateAmmoVisual(p8)
    if not p8._destroyed then
        local v9 = p8.ClientItem:Get("Ammo")
        local v10 = v9 > 0 and 0 or 1
        local v11 = (v9 > 1 or p8:IsAnimationPlaying("Reload")) and 0 or 1
        p8:_LocalTransparencyModifier(p8._body_money, "AmmoVisual", v10)
        p8:_LocalTransparencyModifier(p8._body_money_decal1, "AmmoVisual", v10)
        p8:_LocalTransparencyModifier(p8._body_money_decal2, "AmmoVisual", v10)
        p8:_LocalTransparencyModifier(p8._magazine_money, "AmmoVisual", v11)
        p8:_LocalTransparencyModifier(p8._magazine_money_decal1, "AmmoVisual", v11)
        p8:_LocalTransparencyModifier(p8._magazine_money_decal2, "AmmoVisual", v11)
    end
end
function v_u_4._Init(p_u_12)
    p_u_12.ClientItem:GetDataChangedSignal("AmmoReserve"):Connect(function()
        p_u_12:_UpdateAmmoVisual()
    end)
    p_u_12.ClientItem:GetDataChangedSignal("Ammo"):Connect(function()
        p_u_12:_UpdateAmmoVisual()
    end)
    p_u_12.AnimationPlayed:Connect(function()
        p_u_12:_UpdateAmmoVisual()
    end)
    p_u_12.AnimationStopped:Connect(function()
        p_u_12:_UpdateAmmoVisual()
    end)
    task.defer(p_u_12._UpdateAmmoVisual, p_u_12)
end
return v_u_4