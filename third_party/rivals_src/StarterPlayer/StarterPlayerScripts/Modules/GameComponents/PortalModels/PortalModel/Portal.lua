local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.GameplayUtility)
local v_u_4 = require(v1.Modules.Utility)
local v_u_5 = require(v1.Modules.Spring)
require(v1.Modules.Signal)
local v_u_6 = v_u_2.LocalPlayer.PlayerScripts.UserInterface.PortalKeybindGui
local v_u_7 = v_u_2.LocalPlayer.PlayerScripts.Assets.Misc.Portals
local v_u_8 = {}
v_u_8.__index = v_u_8
function v_u_8.new(p9)
    local v10 = v_u_8
    local v11 = setmetatable({}, v10)
    v11.Model = p9
    v11.Hitbox = v11.Model:WaitForChild("Hitbox")
    local v12 = v11.Model.Name
    v11.PortalNum = tonumber(v12)
    v11.Visual = v11:_GetPortalTemplate():Clone()
    v11.BigVisual = v11.Visual:WaitForChild("Big")
    v11.SmallVisual = v11.Visual:WaitForChild("Small")
    v11.Gui = v_u_6:Clone()
    v11._viewmodel_name = v11.Model:GetAttribute("ViewModelName")
    v11._owner_user_id = v11.Model:GetAttribute("OwnerUserID")
    v11._original_scale = v11.Visual:GetScale()
    v11._grow_start = nil
    v11._spawn_delay = nil
    v11._finished_growing = nil
    v11._is_enabled = false
    v11._established = false
    v11._pivot_offset_spring = v_u_5.new(Vector3.new(0, 0, 0), 0.5, 25)
    v11._opened_hotel_door = false
    v11:_Init()
    return v11
end
function v_u_8.IsGrown(p13)
    return p13._finished_growing
end
function v_u_8.GetTeleportCFrame(p14)
    local v15 = p14.Hitbox.CFrame
    local v16 = v15 * CFrame.new(0, 0, -4)
    local v17 = v_u_3:GetRaycastWhitelist(v_u_2.LocalPlayer:GetAttribute("EnvironmentID"))
    local v18 = v_u_4:Raycast(v15.Position, v16.Position, 4, v17, Enum.RaycastFilterType.Include)
    return CFrame.new(v18.Position) * v16.Rotation
end
function v_u_8.UpdateVisuals(p_u_19, p_u_20, p_u_21)
    task.defer(function()
        local v22 = p_u_20
        if v22 then
            v22 = p_u_19._finished_growing
        end
        local v23 = p_u_19
        local v24 = p_u_19.BigVisual
        local v25
        if v22 then
            v25 = p_u_19.Visual
        else
            v25 = nil
        end
        v23:_SafeParent(v24, v25)
        local v26 = p_u_19
        local v27 = p_u_19.SmallVisual
        local v28
        if v22 then
            v28 = nil
        else
            v28 = p_u_19.Visual
        end
        v26:_SafeParent(v27, v28)
        if v22 and (not p_u_19._opened_hotel_door and p_u_19._viewmodel_name == "Hotel Bell") then
            p_u_19._opened_hotel_door = true
            task.defer(function()
                p_u_19.BigVisual.Screen.SurfaceGui.MainFrame:TweenSize(UDim2.new(0.1, 0, 1, 0), "Out", "Quint", 0.5, true)
            end)
        end
        local v29 = not p_u_21 and (v22 and not p_u_19._is_enabled)
        if v29 then
            v29 = not p_u_19._established
        end
        if v29 then
            p_u_19._established = true
            if p_u_19._viewmodel_name == "Hotel Bell" then
                task.delay(0.1 + 0.1 * math.random(), v_u_4.CreateSound, v_u_4, "rbxassetid://109072275653492", 1, 1.25 + 0.25 * math.random(), p_u_19.Hitbox, true, 10)
                v_u_4:CreateSound("rbxassetid://119325209237441", 0.5, 1 + 0.1 * math.random(), p_u_19.Hitbox, true, 10)
            else
                v_u_4:CreateSound("rbxassetid://119325209237441", 0.75, 1 + 0.1 * math.random(), p_u_19.Hitbox, true, 10)
            end
        end
        p_u_19._is_enabled = p_u_20
        if not p_u_19._is_enabled then
            p_u_19:_ScaleTo(1)
        end
    end)
end
function v_u_8.Update(p30, p31)
    p30:_Pivot()
    if p30._viewmodel_name == "Hotel Bell" then
        local v32 = p30.BigVisual.Part.SurfaceGui1.CanvasGroup.Spin
        v32.Rotation = v32.Rotation + p31 * -90
        local v33 = p30.BigVisual.Part.SurfaceGui2.CanvasGroup.Spin
        v33.Rotation = v33.Rotation + p31 * -90
    end
    if p30._is_enabled and not p30._finished_growing then
        local v34
        if p30._spawn_delay <= 0 then
            v34 = 1
        else
            local v35 = (tick() - p30._grow_start) / p30._spawn_delay
            v34 = math.clamp(v35, 0, 1)
        end
        p30:_ScaleTo((v34 * 0.75 + 0.25) * (v34 < 1 and 3 or 1))
        if v34 >= 1 then
            p30._finished_growing = true
            local v36 = p30._spawn_delay <= 0.01
            if not v36 then
                p30._pivot_offset_spring.Value = Vector3.new(0, 0, -3)
            end
            p30:UpdateVisuals(p30._is_enabled, not v36)
        end
    else
        return
    end
end
function v_u_8.Destroy(p_u_37)
    pcall(function()
        p_u_37.Model:Destroy()
    end)
    pcall(function()
        p_u_37.Visual:Destroy()
    end)
end
function v_u_8._GetPortalTemplate(p38)
    return (v_u_7:FindFirstChild((p38.Model:GetAttribute("ViewModelName"))) or v_u_7.Default)[p38.PortalNum]
end
function v_u_8._Pivot(p39)
    p39.Visual:PivotTo(p39.Model:GetPivot() * CFrame.new(p39._pivot_offset_spring.Value))
end
function v_u_8._SafeParent(_, p_u_40, p_u_41)
    pcall(function()
        p_u_40.Parent = p_u_41
    end)
end
function v_u_8._ScaleTo(p42, p43)
    local v44 = p42.BigVisual.Parent
    local v45 = p42.SmallVisual.Parent
    p42:_SafeParent(p42.BigVisual, p42.Visual)
    p42:_SafeParent(p42.SmallVisual, p42.Visual)
    p42.Visual:ScaleTo(p42._original_scale * p43)
    p42:_SafeParent(p42.BigVisual, v44)
    p42:_SafeParent(p42.SmallVisual, v45)
end
function v_u_8._InitializeGrowing(p46)
    p46._grow_start = tick()
    p46._spawn_delay = p46.Model:GetAttribute("SpawnDelay") or 0
    p46._finished_growing = false
    p46:UpdateVisuals(p46._is_enabled)
end
function v_u_8._Setup(p47)
    for _, v48 in pairs(p47.Visual:GetDescendants()) do
        if v48:IsA("BasePart") then
            v48.CanCollide = false
            v48.CanQuery = false
            v48.CanTouch = false
        end
    end
    p47.Gui.Parent = p47.Visual.Primary
    if p47._owner_user_id == v_u_2.LocalPlayer.UserId then
        p47.Gui.CanvasGroup.Keybind:SetAttribute("InputName", p47.PortalNum == 1 and "Shoot" or "Aim")
        p47.Gui.CanvasGroup.Keybind:AddTag("UIKeybindContainer")
    end
    p47.Visual.PrimaryPart = p47.Visual.Primary
    p47.BigVisual.WorldPivot = p47.Visual.WorldPivot
    p47.SmallVisual.WorldPivot = p47.Visual.WorldPivot
    p47.Visual.Parent = p47.Model
    v_u_4:CreateSound("rbxassetid://114274252176516", 0.5, 0.95 + 0.1 * math.random(), p47.Visual.Primary, true).Looped = true
end
function v_u_8._Init(p_u_49)
    p_u_49.Model:GetAttributeChangedSignal("SpawnDelay"):Connect(function()
        p_u_49:_InitializeGrowing()
    end)
    p_u_49.Model:GetAttributeChangedSignal("RegrowHash"):Connect(function()
        p_u_49:_InitializeGrowing()
    end)
    p_u_49:_Setup()
    p_u_49:_Pivot()
    p_u_49:_InitializeGrowing()
end
return v_u_8