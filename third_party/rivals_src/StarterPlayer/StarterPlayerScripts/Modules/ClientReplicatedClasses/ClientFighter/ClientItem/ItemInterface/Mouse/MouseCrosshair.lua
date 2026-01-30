local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.CONSTANTS)
local v_u_4 = require(v1.Modules.Utility)
local v_u_5 = require(v1.Modules.Spring)
local v_u_6 = require(v2.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
local v_u_7 = require(v2.LocalPlayer.PlayerScripts.Modules.Crosshair)
local v_u_8 = {}
v_u_8.__index = v_u_8
function v_u_8.new(p9)
    local v10 = v_u_8
    local v11 = setmetatable({}, v10)
    v11.Mouse = p9
    v11.Crosshair = v_u_7.new()
    v11._crouch_spring = v_u_5.new(0, 0.875, 20)
    v11._speed_spring = v_u_5.new(0, 0.875, 20)
    v11._jump_spring = v_u_5.new(0, 0.875, 20)
    v11:_Init()
    return v11
end
function v_u_8.Refresh(p12)
    if p12.Mouse.ItemInterface.ClientItem.ClientFighter.IsLocalPlayer then
        p12.Crosshair:SetAppearance(v_u_4:GenerateCrosshairAppearance(v_u_6))
        p12.Mouse:Refresh()
    else
        local v13 = p12.Mouse.ItemInterface.ClientItem.ClientFighter:Get("CompressedCrosshairAppearance")
        if v13 then
            p12.Crosshair:SetAppearance(v_u_4:DecodeCrosshairAppearance(v13))
            p12.Mouse:Refresh()
        end
    end
end
function v_u_8.Update(p14, _, p15, _)
    if p14.Crosshair.Info.DotEnabled or p14.Crosshair.Info.BarsEnabled then
        local v16 = p14.Mouse.ItemInterface.ClientItem.ViewModel.CurrentAimValue
        local v17 = p14.Mouse.ItemInterface.ClientItem.ViewModel.CurrentRecoilValue
        local v18 = p14.Mouse.ItemInterface.ClientItem.Info.ShootAccuracy or 1
        local v19 = p14.Mouse.ItemInterface.ClientItem.ViewModel.AimingAnimationEnabled
        p14._speed_spring.Target = p15.MoveSpeed > 4 and (p15.MoveSpeed or 0) or 0
        p14._jump_spring.Target = p15.IsGrounded and 0 or 1
        p14._crouch_spring.Target = p15.IsCrouching and 0.25 or 1
        for _, v20 in pairs({ p14._speed_spring, p14._jump_spring, p14._crouch_spring }) do
            v20.Value = v20.Target > v20.Value and v20.Target or v20.Value
        end
        local v21 = p14._crouch_spring.Value
        local v22 = p14._speed_spring.Value * 0.75
        local v23 = p14._jump_spring.Value
        local v24 = not p14.Mouse.Scope:IsActive() and p14.Crosshair:ShowWhileAiming() and 1 or 1 - v16
        local v25 = (p14.Crosshair:GetAppearanceSpacing() + 8 * (v22 / v_u_3.BASE_WALKSPEED) ^ 2 + 32 * v23 + 100 * v17.Magnitude / v18) * v21 / v18
        local v26 = p15.IsFirstPerson and (p14.Mouse.ItemInterface.ClientItem.Name ~= "Minigun" and v19) and (1 - v24 or 0) or 0
        p14.Crosshair:SetSpacing(v25, v24)
        p14.Crosshair:SetTransparency(v26)
    end
end
function v_u_8.Destroy(p27)
    p27.Crosshair:Destroy()
end
function v_u_8._Setup(p28)
    p28.Crosshair:SetType(p28.Mouse.ItemInterface.ClientItem.Info.CrosshairType)
    p28.Crosshair:SetParent(p28.Mouse.Frame)
end
function v_u_8._Init(p29)
    p29:_Setup()
end
return v_u_8