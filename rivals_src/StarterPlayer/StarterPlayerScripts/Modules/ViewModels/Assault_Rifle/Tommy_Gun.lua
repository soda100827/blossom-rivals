local v1 = game:GetService("Players")
local v_u_2 = require(v1.LocalPlayer.PlayerScripts.Modules.ViewModels["Assault Rifle"])
local v_u_3 = setmetatable({}, v_u_2)
v_u_3.__index = v_u_3
function v_u_3.new(...)
    local v4 = v_u_2.new(...)
    local v5 = v_u_3
    local v6 = setmetatable(v4, v5)
    v6:_Init()
    return v6
end
function v_u_3._UpdateDefaultAnimationsFromAmmo(p7)
    local v8 = p7.ClientItem:Get("Ammo")
    p7.ClientItem:Get("AmmoReserve")
    local v9 = v8 <= 0
    if v9 ~= p7._is_empty then
        p7._is_empty = v9
        local v10 = p7._is_empty and "Empty" or ""
        p7:ChangeEquipAnimation("Equip" .. v10)
        p7:ChangeIdleAnimation("Idle" .. v10)
        p7:ChangeSprintAnimation("Sprint" .. v10)
        p7:ChangeInspectAnimation("Inspect" .. v10)
    end
end
function v_u_3._Init(p_u_11)
    p_u_11.ClientItem:GetDataChangedSignal("AmmoReserve"):Connect(function()
        p_u_11:_UpdateDefaultAnimationsFromAmmo()
    end)
    p_u_11.ClientItem:GetDataChangedSignal("Ammo"):Connect(function()
        p_u_11:_UpdateDefaultAnimationsFromAmmo()
    end)
    p_u_11:_UpdateDefaultAnimationsFromAmmo()
end
return v_u_3