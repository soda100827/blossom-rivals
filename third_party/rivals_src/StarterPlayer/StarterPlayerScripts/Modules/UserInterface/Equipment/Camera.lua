local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("UserInputService")
local v_u_3 = game:GetService("GuiService")
local v4 = game:GetService("Players")
local v_u_5 = require(v1.Modules.Utility)
local v_u_6 = require(v1.Modules.Signal)
local v_u_7 = require(v1.Modules.Spring)
local v_u_8 = require(v4.LocalPlayer.PlayerScripts.Controllers.ControlsController)
local v_u_9 = require(v4.LocalPlayer.PlayerScripts.Controllers.CameraController)
local v_u_10 = require(v4.LocalPlayer.PlayerScripts.Modules.UserInterface.Pages)
local v_u_11 = require(v4.LocalPlayer.PlayerScripts.Modules.UILibrary)
local v_u_12 = CFrame.new(0, 0, 35)
local v_u_13 = CFrame.new(0, -2, 0)
local v_u_14 = UDim2.new(0.5, 0, -2.5, 0)
local v_u_15 = UDim2.new(0.5, 0, 3.5, 0)
local v_u_16 = {}
v_u_16.__index = v_u_16
function v_u_16.new(p17)
    local v18 = v_u_16
    local v19 = setmetatable({}, v18)
    v19.FinishedOpenEffect = v_u_6.new()
    v19.Equipment = p17
    v19._frame = v_u_11:GetTo("MainFrame", "Equipment", "CameraFade")
    v19._look_at_attachment = nil
    v19._look_at_offset = Vector3.new(0, 0, 0)
    v19._fov_spring = v_u_7.new(15, 0.875, 5)
    v19._equipment_open_hash = 0
    v19._equipment_open_start_cframe = CFrame.identity
    v19._equipment_open_start = 0
    v19._equipment_open_finished = true
    v19._equipment_open_is_closing = false
    v19._controls_connections = {}
    v19._scroll_fov_spring = v_u_7.new(0, 1, 20)
    v19._fov_zoom_direction = Vector2.zero
    v19:_Init()
    return v19
end
function v_u_16.IsOpenEffectDone(p20)
    return p20._equipment_open_finished
end
function v_u_16.IsClosing(p21)
    return p21._equipment_open_is_closing
end
function v_u_16.SetFocus(p22, p23, p24, p25, p26)
    p22._look_at_attachment = p23 or nil
    p22._look_at_offset = p24 or Vector3.new(0, 0, 0)
    p22._fov_spring.Target = p25 or 15
    p22._fov_spring.Speed = p26 or 5
end
function v_u_16.Update(p27, p28)
    workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
    p27:_IncrementFOVSpringFromInput((p27._fov_zoom_direction.X - p27._fov_zoom_direction.Y) * p28 * 60 * 0.25)
    local v29 = (tick() - p27._equipment_open_start) / 0.375
    local v30 = math.clamp(v29, 0, 1)
    if v30 < 1 then
        local v31 = v30 ^ 2
        if p27._equipment_open_is_closing then
            workspace.CurrentCamera.CFrame = p27._equipment_open_start_cframe * CFrame.identity:Lerp(v_u_13, v31)
        else
            workspace.CurrentCamera.CFrame = p27._equipment_open_start_cframe * CFrame.new(0, v31 * 25, 0)
        end
    else
        local v32 = p27.Equipment:GetCustomizingType()
        local v33 = v32 == "Finisher" and true or v32 == "Emote"
        local v34 = p27.Equipment.Scene:GetCFrame() * v_u_12
        local v35
        if p27._equipment_open_finished then
            v35 = workspace.CurrentCamera.CFrame
        else
            v35 = v34 * (p27:_IsOpenEffectDisabled() and CFrame.identity or v_u_13)
        end
        if v33 then
            v34 = CFrame.new(v34.Position + Vector3.new(0, 5, 0), p27.Equipment.Scene:GetHumanoidCFrame().Position)
        elseif p27._look_at_attachment then
            v34 = CFrame.new(v34.Position, p27._look_at_attachment.WorldPosition + p27._look_at_offset)
        end
        local v36 = CFrame.Angles
        local v37 = tick() * 0.23983 % 6.283185307179586
        local v38 = math.sin(v37) * 0.00017453292519943296
        local v39 = tick() * 0.372721 % 6.283185307179586
        local v40 = math.sin(v39) * 0.00017453292519943296
        local v41 = tick() * 0.43123 % 6.283185307179586
        local v42 = v36(v38, v40, math.sin(v41) * 0.00017453292519943296)
        local v43 = p27.Equipment:IsCustomizing() and 0.025 or 0.05
        workspace.CurrentCamera.FieldOfView = p27._fov_spring.Value + p27._scroll_fov_spring.Value + v_u_9:GetExternalFOVOffset()
        workspace.CurrentCamera.CFrame = CFrame.new(v35.Position:Lerp(v34.Position, 0.1)) * v35.Rotation:Lerp(v34.Rotation, v43) * v42
        if not p27._equipment_open_finished then
            p27._equipment_open_finished = true
            p27.FinishedOpenEffect:Fire()
        end
        return
    end
end
function v_u_16.OnStateChanged(p44)
    p44.Equipment:IsCustomizing()
end
function v_u_16.OnOpen(p45)
    task.spawn(v_u_9.CameraState.SetCustomFreecamEnabled, v_u_9.CameraState, false)
    v_u_9:Freeze(p45.Equipment.IsOpen)
    p45:_VerifyControls()
    if p45.Equipment.IsOpen then
        p45._scroll_fov_spring.Target = 0
        p45._scroll_fov_spring.Value = 0
        if p45:_IsOpenEffectDisabled() then
            p45._equipment_open_hash = p45._equipment_open_hash + 1
            p45._equipment_open_is_closing = false
            p45._equipment_open_start_cframe = CFrame.identity
            p45._equipment_open_start = 0
            p45._equipment_open_finished = false
            p45.FinishedOpenEffect:Fire()
            return
        end
        p45._equipment_open_hash = p45._equipment_open_hash + 1
        p45._equipment_open_is_closing = false
        p45._equipment_open_start_cframe = workspace.CurrentCamera.CFrame
        p45._equipment_open_start = tick()
        p45._equipment_open_finished = false
        p45.FinishedOpenEffect:Fire()
        p45._frame.Position = v_u_14
        p45._frame:TweenPosition(v_u_15, "InOut", "Quint", 0.9375, true)
        v_u_5:CreateSound("rbxassetid://106551800007995", 1.5, 1 + 0.2 * math.random(), script, true, 5)
    end
end
function v_u_16.CloseEffect(p46)
    if p46:_IsOpenEffectDisabled() then
        p46._equipment_open_hash = p46._equipment_open_hash + 1
        p46._equipment_open_is_closing = true
        p46._equipment_open_start_cframe = CFrame.identity
        p46._equipment_open_start = 0
        p46._equipment_open_finished = true
        p46.FinishedOpenEffect:Fire()
        return
    else
        p46._equipment_open_hash = p46._equipment_open_hash + 1
        p46._equipment_open_is_closing = true
        p46._equipment_open_start_cframe = workspace.CurrentCamera.CFrame
        p46._equipment_open_start = tick()
        p46._equipment_open_finished = false
        p46.FinishedOpenEffect:Fire()
        p46._frame.Position = v_u_15
        p46._frame:TweenPosition(v_u_14, "InOut", "Quint", 0.75, true)
        v_u_5:CreateSound("rbxassetid://106551800007995", 1.25, 0.8 + 0.2 * math.random(), script, true, 5)
        local v47 = p46._equipment_open_hash
        wait(0.375)
        if v47 == p46._equipment_open_hash then
            if not p46._equipment_open_finished then
                p46._equipment_open_finished = true
                p46.FinishedOpenEffect:Fire()
            end
        end
    end
end
function v_u_16._IsOpenEffectDisabled(_)
    return v_u_3.ReducedMotionEnabled
end
function v_u_16._IncrementFOVSpringFromInput(p48, p49)
    local v50 = p48._scroll_fov_spring
    local v51 = p48._scroll_fov_spring.Target + p49
    v50.Target = math.clamp(v51, -10, 10)
end
function v_u_16._VerifyControls(p_u_52)
    for _, v53 in pairs(p_u_52._controls_connections) do
        v53:Disconnect()
    end
    p_u_52._controls_connections = {}
    p_u_52._fov_zoom_direction = Vector2.zero
    if p_u_52.Equipment.IsOpen then
        local v54 = p_u_52._controls_connections
        local v55 = v_u_2.TouchPinch
        table.insert(v54, v55:Connect(function(_, _, p56, _, p57)
            if not p57 then
                p_u_52:_IncrementFOVSpringFromInput(p56 * -0.25)
            end
        end))
        local v58 = p_u_52._controls_connections
        local v59 = v_u_8.InputChanged
        local function v61(p60, _)
            if v_u_10.PageSystem.CurrentPage or p60.UserInputType ~= Enum.UserInputType.MouseWheel then
                return
            elseif v_u_11:IsMouseWithinBounds(p_u_52.Equipment.Interface.Left.Frame.AbsolutePosition, p_u_52.Equipment.Interface.Left.Frame.AbsoluteSize) then
                return
            elseif v_u_11:IsMouseWithinBounds(p_u_52.Equipment.Interface.Right.Frame.AbsolutePosition, p_u_52.Equipment.Interface.Right.Frame.AbsoluteSize) then
                return
            elseif not v_u_11:IsMouseWithinBounds(p_u_52.Equipment.Interface.Customize.Cosmetics.List.AbsolutePosition, p_u_52.Equipment.Interface.Customize.Cosmetics.List.AbsoluteSize) then
                p_u_52:_IncrementFOVSpringFromInput(p60.Position.Z * -1)
            end
        end
        table.insert(v58, v59:Connect(v61))
        local v62 = p_u_52._controls_connections
        local v63 = v_u_8.InputBegan
        table.insert(v62, v63:Connect(function(p64, _)
            if p64.KeyCode == Enum.KeyCode.ButtonL2 then
                p_u_52._fov_zoom_direction = Vector2.new(1, p_u_52._fov_zoom_direction.Y)
            elseif p64.KeyCode == Enum.KeyCode.ButtonR2 then
                p_u_52._fov_zoom_direction = Vector2.new(p_u_52._fov_zoom_direction.X, 1)
            end
        end))
        local v65 = p_u_52._controls_connections
        local v66 = v_u_8.InputEnded
        table.insert(v65, v66:Connect(function(p67, _)
            if p67.KeyCode == Enum.KeyCode.ButtonL2 then
                p_u_52._fov_zoom_direction = Vector2.new(0, p_u_52._fov_zoom_direction.Y)
            elseif p67.KeyCode == Enum.KeyCode.ButtonR2 then
                p_u_52._fov_zoom_direction = Vector2.new(p_u_52._fov_zoom_direction.X, 0)
            end
        end))
    end
end
function v_u_16._UpdateFocus(p68)
    local v69 = p68.Equipment:GetCustomizingType()
    p68._look_at_offset = v69 == "Charm" and Vector3.new(0, -0.075, 0) or Vector3.new(0, 0, 0)
    local v70
    if v69 == "Charm" and p68.Equipment.FloatingModel then
        v70 = p68.Equipment.FloatingModel:GetCharmPivotAttachment() or nil
    else
        v70 = nil
    end
    p68._look_at_attachment = v70
    p68._fov_spring.Speed = v_u_10.PageSystem.CurrentPage and 15 or 5
    p68._fov_spring.Target = v69 == "Finisher" and 40 or (v69 == "Emote" and 25 or (v69 == "Charm" and 5 or (v69 and 12.5 or (v_u_10.PageSystem.CurrentPage and 20 or 15))))
end
function v_u_16._Setup(p71)
    p71._frame.Parent = v_u_11.MainGui
end
function v_u_16._Init(p_u_72)
    p_u_72.Equipment.CustomizingChanged:Connect(function()
        p_u_72:_UpdateFocus()
    end)
    p_u_72.Equipment.CharmAttachmentVisibleChanged:Connect(function()
        p_u_72:_UpdateFocus()
    end)
    v_u_10.PageSystem.PagesActivity:Connect(function()
        p_u_72:_UpdateFocus()
    end)
    p_u_72:_Setup()
    p_u_72:_UpdateFocus()
end
return v_u_16