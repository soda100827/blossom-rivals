local v1 = game:GetService("Players")
local v_u_2 = require(v1.LocalPlayer.PlayerScripts.Modules.ItemTypes.Gun)
local v_u_3 = setmetatable({}, v_u_2)
v_u_3.__index = v_u_3
function v_u_3.new(...)
    local v4 = v_u_2.new(...)
    local v5 = v_u_3
    local v6 = setmetatable(v4, v5)
    v6.ToggleAimEnabled = nil
    v6:_Init()
    return v6
end
function v_u_3.StartAiming(_, _)
    return false
end
function v_u_3.FinishAiming(_, _)
    return false
end
function v_u_3._UpdateViewModelAnimations(p7)
    local v8
    if p7:Get("Ammo") <= 0 then
        v8 = p7:Get("AmmoReserve") <= 0
    else
        v8 = false
    end
    p7.ViewModel:ChangeEquipAnimation(v8 and "EmptyEquip" or "Equip")
    p7.ViewModel:ChangeIdleAnimation(v8 and "EmptyIdle" or "Idle")
    p7.ViewModel:ChangeInspectAnimation(v8 and "EmptyInspect" or "Inspect")
end
function v_u_3._Init(p_u_9)
    p_u_9:GetDataChangedSignal("Ammo"):Connect(function()
        p_u_9:_UpdateViewModelAnimations()
    end)
    task.defer(p_u_9._UpdateViewModelAnimations, p_u_9)
end
return v_u_3