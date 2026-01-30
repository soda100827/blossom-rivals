local v1 = game:GetService("Players")
local v_u_2 = require(v1.LocalPlayer.PlayerScripts.Modules.ViewModels.Shotgun)
local v_u_3 = ColorSequence.new(Color3.fromRGB(255, 218, 155))
local v_u_4 = setmetatable({}, v_u_2)
v_u_4.__index = v_u_4
function v_u_4.new(...)
    local v5 = v_u_2.new(...)
    local v6 = v_u_4
    local v7 = setmetatable(v5, v6)
    v7._ammo_visuals = {}
    v7:_Init()
    return v7
end
function v_u_4.GetFriendlyTracerColor(_)
    return v_u_3
end
function v_u_4._UpdateAmmoVisuals(p8)
    local v9 = p8.ClientItem:Get("Ammo")
    for v10, v11 in pairs(p8._ammo_visuals) do
        local v12
        if v10 <= v9 then
            v12 = true
        elseif v10 == 1 then
            v12 = p8:IsAnimationPlaying("EmptyReloadStart")
        else
            v12 = false
        end
        for _, v13 in pairs(v11) do
            p8:_LocalTransparencyModifier(v13, "AmmoVisual", v12 and 0 or 1)
        end
    end
    task.defer(p8.ChangeInspectAnimation, p8, v9 <= 3 and "EmptyInspect" or "Inspect")
end
function v_u_4._Setup(p14)
    for v15 = 1, 7 do
        p14._ammo_visuals[v15] = { p14.ItemModel:WaitForChild("Shell" .. v15):WaitForChild("Black"), p14.ItemModel:WaitForChild("Shell" .. v15):WaitForChild("Metal") }
    end
end
function v_u_4._Init(p_u_16)
    p_u_16.ClientItem:GetDataChangedSignal("Ammo"):Connect(function()
        p_u_16:_UpdateAmmoVisuals()
    end)
    p_u_16.AnimationPlayed:Connect(function()
        p_u_16:_UpdateAmmoVisuals()
    end)
    p_u_16.AnimationStopped:Connect(function()
        p_u_16:_UpdateAmmoVisuals()
    end)
    p_u_16:_Setup()
    task.defer(p_u_16._UpdateAmmoVisuals, p_u_16)
end
return v_u_4