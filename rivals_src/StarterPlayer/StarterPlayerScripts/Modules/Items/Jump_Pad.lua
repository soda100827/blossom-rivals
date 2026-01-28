local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("RunService")
local v3 = game:GetService("Players")
local v_u_4 = require(v1.Modules.GameplayUtility)
require(v1.Modules.Utility)
require(v3.LocalPlayer.PlayerScripts.Controllers.WrapController)
local v_u_5 = require(v3.LocalPlayer.PlayerScripts.Modules.GameComponents.JumpPads)
local v_u_6 = require(v3.LocalPlayer.PlayerScripts.Modules.ItemTypes.Custom)
local v_u_7 = setmetatable({}, v_u_6)
v_u_7.__index = v_u_7
function v_u_7.new(...)
    local v8 = v_u_6.new(...)
    local v9 = v_u_7
    local v10 = setmetatable(v8, v9)
    v10._use_cooldown = 0
    v10._preview_connection = nil
    v10._preview_model = nil
    v10:_Init()
    return v10
end
function v_u_7.GetAutoShootReactionTime(_)
    return nil
end
function v_u_7.CanQuickAttack(p11)
    local v12 = tick() > p11._use_cooldown and ((p11:Get("Ammo") or (1 / 0)) > 0 and not p11:IsEquipping())
    if v12 then
        v12 = p11:_GetPlacementData().Instance
    end
    return v12
end
function v_u_7.StartShooting(p13, p14)
    if not p14 and (tick() < p13._use_cooldown or ((p13:Get("Ammo") or (1 / 0)) <= 0 or (p13:IsEquipping() or not p13:_GetPlacementData().Instance))) then
        return false
    end
    p13._use_cooldown = tick() + p13.Info.Cooldown
    p13.ViewModel:PlayAnimation("Use")
    if p13.ItemInterface then
        p13.ItemInterface:CooldownEffect("rbxassetid://17156089790", p13.Info.Cooldown, "Use")
    end
    return true, "StartShooting", p13.ClientFighter:GetCameraData()
end
function v_u_7.Equip(p15, ...)
    v_u_6.Equip(p15, ...)
    p15:_StartPlacementPreview()
end
function v_u_7.Unequip(p16, ...)
    p16:_StopPlacementPreview()
    v_u_6.Unequip(p16, ...)
end
function v_u_7.Destroy(p17)
    p17:_StopPlacementPreview()
    v_u_6.Destroy(p17)
end
function v_u_7._GetPlacementData(p18)
    local v19 = p18.ClientFighter:GetCameraData(nil, nil, true)
    local v20, v21 = v_u_4:GetJumpPadPlacement(p18.ClientFighter:Get("EnvironmentID"), p18.Info.MaxReach, v19[utf8.char(0)], v19[utf8.char(1)], v19[utf8.char(2)], v19[utf8.char(3)])
    return v20, v21
end
function v_u_7._StopPlacementPreview(p22)
    if p22._preview_connection then
        p22._preview_connection:Disconnect()
        p22._preview_connection = nil
    end
    if p22._preview_model then
        p22._preview_model:Destroy()
        p22._preview_model = nil
    end
end
function v_u_7._StartPlacementPreview(p_u_23)
    p_u_23:_StopPlacementPreview()
    if p_u_23.ClientFighter.IsLocalPlayer then
        local v_u_24 = v_u_5:CreateJumpPadVisual(p_u_23.ViewModel.Name, p_u_23.Info.HitboxSize)
        for _, v25 in pairs(v_u_24:GetDescendants()) do
            if v25:IsA("BasePart") then
                v25.Material = Enum.Material.ForceField
                v25.Color = Color3.fromRGB(0, 200, 255)
                v25.CastShadow = false
            end
        end
        local function v28()
            if tick() > p_u_23._use_cooldown and (p_u_23:Get("Ammo") or (1 / 0)) > 0 then
                local v26, v27 = p_u_23:_GetPlacementData()
                if v26.Instance and v27 then
                    v_u_24.Parent = workspace
                    v_u_24:PivotTo(v27)
                else
                    v_u_24.Parent = nil
                end
            else
                v_u_24.Parent = nil
                return
            end
        end
        p_u_23._preview_connection = v_u_2.RenderStepped:Connect(v28)
        v28()
        p_u_23._preview_model = v_u_24
    end
end
function v_u_7._Init(_) end
return v_u_7