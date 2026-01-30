local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.Signal)
local v_u_4 = require(script:WaitForChild("InsetBarButton"))
local v_u_5 = v_u_2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("InsetButtonsBar")
local v_u_6 = {}
v_u_6.__index = v_u_6
function v_u_6.new(p7, p8, p9, p10)
    local v11 = v_u_6
    local v12 = setmetatable({}, v11)
    v12.OpenedChanged = v_u_3.new()
    v12.Frame = v_u_5:Clone()
    v12.Container = v12.Frame:WaitForChild("Container")
    v12.Layout = v12.Container:WaitForChild("Layout")
    v12.IsOpen = nil
    v12.Buttons = {}
    v12._background_transparency = p7
    v12._background_color = p8
    v12._visual_color = p9
    v12._is_mirrored = p10
    v12._num_buttons_visible_while_closed = 1
    v12:_Init()
    return v12
end
function v_u_6.GetVisualColor(p13)
    return p13._visual_color
end
function v_u_6.GetBackgroundColor(p14)
    return p14._background_color
end
function v_u_6.GetNumVisibleButtons(p15)
    local v16 = 0
    for _, v17 in pairs(p15.Buttons) do
        if v17.Frame.Visible then
            v16 = v16 + 1
        end
    end
    return v16
end
function v_u_6.SetMirrored(p18, p19)
    if p19 ~= p18._is_mirrored then
        p18._is_mirrored = p19
        p18:_UpdateMirrored()
    end
end
function v_u_6.Toggle(p20, p21, _)
    if p21 == nil then
        p21 = not p20.IsOpen
    end
    p20.IsOpen = p21
    p20.OpenedChanged:Fire(p20.IsOpen)
end
function v_u_6.SetClosedButtonsVisible(p22, p23)
    p22._num_buttons_visible_while_closed = p23
    p22.OpenedChanged:Fire(p22.IsOpen)
end
function v_u_6.CreateButton(p_u_24, p25, p_u_26, p27, p28, p29, p30)
    local v31 = v_u_4.new(p_u_26, p27, p28, p29, p30, p_u_24._visual_color, p_u_24._is_mirrored)
    v31.Frame.LayoutOrder = p25 * (p_u_24._is_mirrored and -1 or 1)
    v31.Frame.Parent = p_u_24.Container
    v31.Frame:GetPropertyChangedSignal("Visible"):Connect(function()
        p_u_24:Toggle(p_u_24.IsOpen)
    end)
    v31.Entered:Connect(function()
        for v32, v33 in pairs(p_u_24.Buttons) do
            if v32 ~= p_u_26 then
                v33:PlayBubbleEffect(nil)
                v33:Leave()
            end
        end
    end)
    p_u_24.Buttons[v31.Name] = v31
    return v31
end
function v_u_6.RemoveButton(p34, p35)
    local v36 = p34.Buttons[p35]
    if v36 then
        p34.Buttons[p35] = nil
        v36:Destroy()
        p34:Toggle(p34.IsOpen)
    end
end
function v_u_6.Destroy(p37)
    for _, v38 in pairs(p37.Buttons) do
        v38:Destroy()
    end
    p37.Frame:Destroy()
    p37.OpenedChanged:Destroy()
end
function v_u_6._UpdateMirrored(p39)
    p39.Container.AnchorPoint = p39._is_mirrored and Vector2.new(1, 0) or Vector2.new(0, 0)
    p39.Container.Position = p39._is_mirrored and UDim2.new(1, 0, 0, 0) or UDim2.new(0, 0, 0, 0)
    p39.Layout.HorizontalAlignment = p39._is_mirrored and Enum.HorizontalAlignment.Right or Enum.HorizontalAlignment.Left
    for _, v40 in pairs(p39.Buttons) do
        local v41 = v40.Frame
        local v42 = v40.Frame.LayoutOrder
        v41.LayoutOrder = math.abs(v42) * (p39._is_mirrored and -1 or 1)
        v40:SetMirrored(p39._is_mirrored)
    end
end
function v_u_6._LeaveButtons(p43)
    for _, v44 in pairs(p43.Buttons) do
        v44:Leave()
    end
end
function v_u_6._UpdateSize(p45)
    local v46 = p45.IsOpen and UDim2.new(p45:GetNumVisibleButtons(), 0, 1, 0) or UDim2.new(p45._num_buttons_visible_while_closed, 0, 1, 0)
    if p45.Frame:IsDescendantOf(v_u_2) then
        p45.Frame:TweenSize(v46, "Out", "Quint", 0.25, true)
    else
        p45.Frame.Size = v46
    end
end
function v_u_6._Setup(p47)
    p47.Frame.BackgroundTransparency = p47._background_transparency
    p47.Frame.BackgroundColor3 = p47._background_color
    p47.Frame:AddTag("CoreGuiBackground")
end
function v_u_6._Init(p_u_48)
    p_u_48.OpenedChanged:Connect(function()
        p_u_48:_UpdateSize()
        p_u_48:_LeaveButtons()
    end)
    p_u_48:_Setup()
    p_u_48:_UpdateSize()
    p_u_48:_UpdateMirrored()
    p_u_48:Toggle(false)
end
return v_u_6