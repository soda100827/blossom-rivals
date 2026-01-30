local v1 = game:GetService("ReplicatedStorage")
game:GetService("RunService")
local v2 = game:GetService("Players")
require(v1.Modules.GameplayUtility)
local v_u_3 = require(v2.LocalPlayer.PlayerScripts.Modules.ItemTypes.Custom)
local v_u_4 = setmetatable({}, v_u_3)
v_u_4.__index = v_u_4
function v_u_4.new(...)
    local v5 = v_u_3.new(...)
    local v6 = v_u_4
    local v7 = setmetatable(v5, v6)
    v7._use_cooldown = 0
    v7._preview_connection = nil
    v7._preview_model = nil
    v7:_Init()
    return v7
end
function v_u_4.GetAutoShootReactionTime(_)
    return nil
end
function v_u_4.CanQuickAttack(p8)
    local v9
    if tick() > p8._use_cooldown and (p8:Get("Ammo") or (1 / 0)) > 0 then
        v9 = not p8:IsEquipping()
    else
        v9 = false
    end
    return v9
end
function v_u_4.StartShooting(p10, p11)
    if not p11 and (tick() < p10._use_cooldown or ((p10:Get("Ammo") or (1 / 0)) <= 0 or p10:IsEquipping())) then
        return false
    end
    p10._use_cooldown = tick() + p10.Info.Cooldown
    p10.ViewModel:PlayAnimation("Use")
    if p10.ItemInterface then
        p10.ItemInterface:CooldownEffect("rbxassetid://17156089790", p10.Info.Cooldown, "Use")
    end
    return true, "StartShooting", p10:_GetPlacementPosition()
end
function v_u_4.Equip(p12, ...)
    v_u_3.Equip(p12, ...)
    p12:_StartPlacementPreview()
end
function v_u_4.Unequip(p13, ...)
    p13:_StopPlacementPreview()
    v_u_3.Unequip(p13, ...)
end
function v_u_4.ReplicateFromServer(p14, p15, ...)
    if p15 == "MineExplosion" then
        if p14:IsRendered() then
            p14.ViewModel:ExplosionEffect(...)
        end
    else
        v_u_3.ReplicateFromServer(p14, p15, ...)
        return
    end
end
function v_u_4.Destroy(p16)
    p16:_StopPlacementPreview()
    v_u_3.Destroy(p16)
end
function v_u_4._GetPlacementPosition(p17)
    local _, v18 = p17.ClientFighter:GetCameraData()
    return v18.Position
end
function v_u_4._StopPlacementPreview(p19)
    if p19._preview_connection then
        p19._preview_connection:Disconnect()
        p19._preview_connection = nil
    end
    if p19._preview_model then
        p19._preview_model:Destroy()
        p19._preview_model = nil
    end
end
function v_u_4._StartPlacementPreview(p20)
    p20:_StopPlacementPreview()
    if not p20.ClientFighter.IsLocalPlayer then
    end
end
function v_u_4._Init(_) end
return v_u_4