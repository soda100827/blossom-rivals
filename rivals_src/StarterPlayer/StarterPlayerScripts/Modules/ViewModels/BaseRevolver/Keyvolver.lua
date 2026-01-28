local v1 = game:GetService("Players")
local v_u_2 = require(v1.LocalPlayer.PlayerScripts.Modules.ViewModels.BaseRevolver)
local v_u_3 = ColorSequence.new(Color3.fromRGB(255, 218, 155))
local v_u_4 = setmetatable({}, v_u_2)
v_u_4.__index = v_u_4
function v_u_4.new(...)
    local v5 = v_u_2.new(...)
    local v6 = v_u_4
    local v7 = setmetatable(v5, v6)
    v7._is_empty = false
    v7._keyvolver_bullets = {}
    v7:_Init()
    return v7
end
function v_u_4.GetFriendlyTracerColor(_)
    return v_u_3
end
function v_u_4._UpdateAmmoContext(p8)
    local v9 = p8.ClientItem:Get("Ammo")
    local v10 = p8.ClientItem:Get("AmmoReserve")
    for v11, v12 in pairs(p8._keyvolver_bullets.Bullets) do
        p8:_LocalTransparencyModifier(v12, "AmmoVisual", v11 <= v9 and 0 or 1)
    end
    for v13, v14 in pairs(p8._keyvolver_bullets.ReloadBullets) do
        p8:_LocalTransparencyModifier(v14, "AmmoVisual", v9 < v13 and v13 <= v9 + v10 and 0 or 1)
    end
    local v15 = v9 <= 0
    if v15 ~= p8._is_empty then
        p8._is_empty = v15
        local v16 = p8._is_empty and "Empty" or ""
        p8:ChangeEquipAnimation("Equip" .. v16)
        p8:ChangeIdleAnimation("Idle" .. v16)
        p8:ChangeSprintAnimation("Sprint" .. v16)
        p8:ChangeInspectAnimation("Inspect" .. v16)
    end
end
function v_u_4._Setup(p17)
    for _, v18 in pairs({ "Bullets", "ReloadBullets" }) do
        p17._keyvolver_bullets[v18] = {}
        for v19 = 1, 6 do
            p17._keyvolver_bullets[v18][v19] = p17.ItemModel:WaitForChild(v18 .. v19):WaitForChild("Bullet")
        end
    end
end
function v_u_4._Init(p_u_20)
    p_u_20.ClientItem:GetDataChangedSignal("AmmoReserve"):Connect(function()
        p_u_20:_UpdateAmmoContext()
    end)
    p_u_20.ClientItem:GetDataChangedSignal("Ammo"):Connect(function()
        p_u_20:_UpdateAmmoContext()
    end)
    p_u_20:_Setup()
    p_u_20:_UpdateAmmoContext()
end
return v_u_4