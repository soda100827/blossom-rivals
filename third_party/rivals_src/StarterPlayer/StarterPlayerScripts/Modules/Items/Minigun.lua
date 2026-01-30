local v1 = game:GetService("Players")
local v_u_2 = require(v1.LocalPlayer.PlayerScripts.Modules.ItemTypes.Gun)
local v_u_3 = setmetatable({}, v_u_2)
v_u_3.__index = v_u_3
function v_u_3.new(...)
    local v4 = v_u_2.new(...)
    local v5 = v_u_3
    local v6 = setmetatable(v4, v5)
    v6._is_decreasing_move_speed = false
    v6:_Init()
    return v6
end
function v_u_3.CanQuickAttack(_)
    return false
end
function v_u_3._ChargingMoveSpeed(p7)
    if not p7._is_decreasing_move_speed then
        p7._is_decreasing_move_speed = true
        local v8 = p7._equip_hash
        while not p7._destroyed and (v8 == p7._equip_hash and p7.ClientFighter:IsAlive()) do
            p7.ClientFighter.Entity:SetBoost("Speed", "MinigunCharge", 0.5, p7:Get("IsAiming") and (p7.Info.ChargingSpeedBoost or 0) or 0)
            wait(0.25)
        end
        p7._is_decreasing_move_speed = false
    end
end
function v_u_3._Init(p_u_9)
    p_u_9:GetDataChangedSignal("IsAiming"):Connect(function()
        if p_u_9.ClientFighter.IsLocalPlayer then
            p_u_9:_ChargingMoveSpeed()
        end
    end)
end
return v_u_3