local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
require(v1.Modules.BetterDebris)
local v_u_3 = require(v1.Modules.Utility)
local v_u_4 = require(v2.LocalPlayer.PlayerScripts.Modules.ItemTypes.Custom)
local v_u_5 = setmetatable({}, v_u_4)
v_u_5.__index = v_u_5
function v_u_5.new(...)
    local v6 = v_u_4.new(...)
    local v7 = v_u_5
    local v8 = setmetatable(v6, v7)
    v8._is_using = false
    v8._airblast_cooldown = 0
    v8:_Init()
    return v8
end
function v_u_5.GetAutoShootReactionTime(_)
    return 0
end
function v_u_5.GetAutoShootReach(p9)
    return p9.Info.Reach
end
function v_u_5.CanQuickAttack(p10)
    local v11
    if tick() > p10._airblast_cooldown then
        v11 = not p10:IsEquipping()
    else
        v11 = false
    end
    return v11
end
function v_u_5.StartShooting(p12, p13)
    if not p13 and (p12._is_using or (p12:Get("Ammo") <= 0 or p12:IsEquipping())) then
        return false
    end
    p12._is_using = true
    p12.ViewModel:SetFlameParticlesEnabled(true)
    p12.ViewModel:SetCustomSprintingEnabled((1 / 0))
    return true, "StartShooting"
end
function v_u_5.FinishShooting(p14, p15)
    if not (p15 or p14._is_using) then
        return false
    end
    p14:_StopUsing()
    return true, "FinishShooting"
end
function v_u_5.StartAiming(p16, p17)
    if not p17 and (tick() < p16._airblast_cooldown or p16:IsEquipping()) then
        return false
    end
    p16._airblast_cooldown = tick() + p16.Info.AirblastCooldown
    p16.ViewModel:Impulse(Vector3.new(0, 0, 30), 0.5)
    p16.ViewModel:AirblastEffect()
    p16.ViewModel:StopAnimation("Inspect")
    p16.ViewModel:SetCustomSprintingEnabled(not p16._is_using and 0.5 or nil, true)
    p16:_Recoil(2)
    if p16.ItemInterface then
        p16.ItemInterface:CooldownEffect("rbxassetid://16828140099", p16.Info.AirblastCooldown, "Airblast")
    end
    local v18 = p16.ClientFighter:GetCameraData()
    if p16.ClientFighter.IsLocalPlayer then
        local v19 = p16.ClientFighter.Entity.RootPart
        local v20 = p16.ClientFighter.Entity.RootPart.Velocity * Vector3.new(1, 0, 1)
        local v21 = p16.ClientFighter.Entity.RootPart.Velocity.Y
        local v22 = math.max(0, v21)
        v19.Velocity = v20 + Vector3.new(0, v22, 0) + v_u_3:DecodeCFrame(v18[utf8.char(0)]).LookVector * Vector3.new(0, 1, 0) * -25 * p16.Info.AirblastRecoilKnockback
    end
    return true, "StartAiming", v18
end
function v_u_5.Equip(p23, ...)
    v_u_4.Equip(p23, ...)
    p23:_StopUsing()
end
function v_u_5.Unequip(p24, ...)
    p24:_StopUsing()
    v_u_4.Unequip(p24, ...)
end
function v_u_5.ReplicateFromServer(p25, p26, ...)
    if p26 == "StopUsing" then
        p25:_StopUsing()
    else
        v_u_4.ReplicateFromServer(p25, p26, ...)
    end
end
function v_u_5.Destroy(p27)
    p27:_StopUsing()
    v_u_4.Destroy(p27)
end
function v_u_5._StopUsing(p28)
    if p28._is_using then
        p28._is_using = false
        p28.ViewModel:SetFlameParticlesEnabled(false)
        p28.ViewModel:SetCustomSprintingEnabled(0)
    end
end
function v_u_5._Init(p_u_29)
    local v30 = p_u_29._connections
    local v31 = p_u_29.ClientFighter.Interrupted
    table.insert(v30, v31:Connect(function()
        p_u_29:_StopUsing()
    end))
end
return v_u_5