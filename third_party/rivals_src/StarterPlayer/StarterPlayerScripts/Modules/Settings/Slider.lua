local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("UserInputService")
local v_u_3 = game:GetService("GuiService")
local v_u_4 = game:GetService("RunService")
local v5 = game:GetService("Players")
local v_u_6 = require(v1.Modules.CONSTANTS)
local v_u_7 = require(v1.Modules.Signal)
local v_u_8 = require(v5.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect"))
local v_u_9 = require(v5.LocalPlayer.PlayerScripts.Modules:WaitForChild("UILibrary"))
local v_u_10 = require(v5.LocalPlayer.PlayerScripts.Modules:WaitForChild("Setting"))
local v_u_11 = setmetatable({}, v_u_10)
v_u_11.__index = v_u_11
function v_u_11.new(...)
    local v12 = v_u_10.new(...)
    local v13 = v_u_11
    local v14 = setmetatable(v12, v13)
    v14.InputBox = v14.BaseContainer:WaitForChild("SliderInput"):WaitForChild("Box")
    v14.Slider = v14.SettingFrame:WaitForChild("Slider")
    v14.Dragger = v14.Slider:WaitForChild("Dragger")
    v14.IncreaseButton = v14.Slider:WaitForChild("Increase")
    v14.DecreaseButton = v14.Slider:WaitForChild("Decrease")
    v14.SliderChanged = v_u_7.new()
    v14._dragging = false
    v14._dragging_connection = nil
    v14._console_dragging_connection = nil
    v14._console_alpha = nil
    v14._console_drag_velocity = 0
    v14._custom_value_set = false
    v14:_Init()
    return v14
end
function v_u_11.GetSelection(p15)
    return p15.Dragger
end
function v_u_11.InputValue(p16, p17)
    if p16._custom_value_set then
        p16:StoreValue(p17)
    else
        p16:SetValue(p17)
    end
end
function v_u_11.IncreaseValue(p18, p19)
    local v20 = 1 / p18.SettingsInfo.Increment
    local v21 = (p18.SettingsInfo.Max - p18.SettingsInfo.Min) * 0.1
    local v22 = math.max(v20, v21)
    p18:InputValue((p18.SettingsInfo.VerifyInput(p18.Value + v22 * p19)))
end
function v_u_11.CancelInputs(p23)
    if v_u_6.DEVICE == "Console" then
        p23:_StopDraggingConsole()
    else
        p23:_StopDragging()
    end
end
function v_u_11.Destroy(p24)
    if p24._dragging_connection then
        p24._dragging_connection:Disconnect()
    end
    if p24._console_dragging_connection then
        p24._console_dragging_connection:Disconnect()
    end
    p24.SliderChanged:Destroy()
    v_u_10.Destroy(p24)
end
function v_u_11._Update(p25)
    local v26 = UDim2.new(p25:_GetAlphaFromValue(p25.Value), 0, 0.5, 0)
    p25.InputBox.Text = p25.Value
    if p25.Dragger:IsDescendantOf(game) then
        p25.Dragger:TweenPosition(v26, "Out", "Quint", 0.25, true)
    else
        p25.Dragger.Position = v26
    end
end
function v_u_11._VerifyInputBox(p27)
    local v28 = p27.InputBox.Text
    local v29 = tonumber(v28)
    local v30 = p27.SettingsInfo.VerifyInput(v29) or p27.Value
    p27.InputBox.Text = v30
    p27:InputValue(v30)
end
function v_u_11._GetAlphaFromValue(p31, p32)
    return (p32 - p31.SettingsInfo.Min) / (p31.SettingsInfo.Max - p31.SettingsInfo.Min)
end
function v_u_11._GetAlphaFromMouse(p33)
    local v34 = v_u_9:GetMouseLocation()
    local v35 = p33.Slider.AbsolutePosition.X
    local v36 = p33.Slider.AbsoluteSize.X
    local v37 = (v34.X - v35) / v36
    return math.clamp(v37, 0, 1)
end
function v_u_11._GetValueFromAlpha(p38, p39)
    local v40 = p38.SettingsInfo.Min + p39 * (p38.SettingsInfo.Max - p38.SettingsInfo.Min)
    return p38.SettingsInfo.VerifyInput(v40)
end
function v_u_11._GetValueFromMouse(p41)
    return p41:_GetValueFromAlpha(p41:_GetAlphaFromMouse())
end
function v_u_11._UpdateDrag(p42)
    local v43 = p42:_GetValueFromMouse()
    local v44 = p42:_GetAlphaFromMouse()
    local v45 = (v43 - p42.SettingsInfo.Min) / (p42.SettingsInfo.Max - p42.SettingsInfo.Min)
    local v46 = UDim2.new(v45 + (v44 - v45) * 0.5, 0, 0.5, 0)
    p42.Dragger:TweenPosition(v46, "Out", "Quint", 0.25, true)
    p42.InputBox.Text = v43
    p42.SliderChanged:Fire(v43)
end
function v_u_11._StartDragging(p_u_47)
    if not p_u_47._dragging and tick() >= p_u_47._value_change_cooldown then
        p_u_47._dragging = true
        p_u_47._dragging_connection = v_u_2.InputChanged:Connect(function()
            p_u_47:_UpdateDrag()
        end)
    end
end
function v_u_11._StopDragging(p48)
    if p48._dragging then
        p48._dragging = false
        if p48._dragging_connection then
            p48._dragging_connection:Disconnect()
        end
        p48:InputValue(p48:_GetValueFromMouse())
    end
end
function v_u_11._StartDraggingConsole(p_u_49)
    if not p_u_49._dragging and tick() >= p_u_49._value_change_cooldown then
        p_u_49._dragging = true
        p_u_49._console_alpha = p_u_49:_GetAlphaFromValue(p_u_49.Value)
        p_u_49._dragging_connection = v_u_2.InputChanged:Connect(function(p50)
            if p50.KeyCode == Enum.KeyCode.Thumbstick1 then
                local v51 = p50.Position.X
                if math.abs(v51) < 0.1 then
                    p_u_49._console_drag_velocity = 0
                else
                    p_u_49._console_drag_velocity = p50.Position.X * 0.01
                end
            else
                return
            end
        end)
        p_u_49._console_dragging_connection = v_u_4.RenderStepped:Connect(function(p52)
            local v53 = p_u_49
            local v54 = p_u_49._console_alpha + p_u_49._console_drag_velocity * p52 * 60
            v53._console_alpha = math.clamp(v54, 0, 1)
            local v55 = p_u_49:_GetValueFromAlpha(p_u_49._console_alpha)
            p_u_49.Dragger.Position = UDim2.new(p_u_49._console_alpha, 0, 0.5, 0)
            p_u_49.InputBox.Text = v55
            p_u_49.SliderChanged:Fire(v55)
        end)
    end
end
function v_u_11._StopDraggingConsole(p56)
    if p56._dragging then
        p56._dragging = false
        if p56._dragging_connection then
            p56._dragging_connection:Disconnect()
        end
        if p56._console_dragging_connection then
            p56._console_dragging_connection:Disconnect()
        end
        p56:InputValue(p56:_GetValueFromAlpha(p56._console_alpha))
        p56._console_alpha = nil
    end
end
function v_u_11._Setup(p_u_57)
    p_u_57.Dragger.NextSelectionRight = p_u_57.Dragger
    p_u_57.Dragger.NextSelectionLeft = p_u_57.Dragger
    if v_u_6.DEVICE == "Console" then
        v_u_3:GetPropertyChangedSignal("SelectedObject"):Connect(function()
            if v_u_3.SelectedObject == p_u_57.Dragger then
                p_u_57:_StartDraggingConsole()
            else
                p_u_57:_StopDraggingConsole()
            end
        end)
    else
        p_u_57.Dragger.MouseButton1Down:Connect(function()
            p_u_57:_StartDragging()
        end)
        v_u_2.InputEnded:Connect(function(p58)
            if p58.UserInputType == Enum.UserInputType.MouseButton1 or p58.UserInputType == Enum.UserInputType.Touch then
                p_u_57:_StopDragging()
            end
        end)
    end
end
function v_u_11._Init(p_u_59)
    p_u_59.Changed:Connect(function()
        p_u_59:_Update()
    end)
    p_u_59.InputBox.FocusLost:Connect(function()
        p_u_59:_VerifyInputBox()
    end)
    p_u_59.IncreaseButton.MouseButton1Click:Connect(function()
        p_u_59:IncreaseValue(1)
    end)
    p_u_59.DecreaseButton.MouseButton1Click:Connect(function()
        p_u_59:IncreaseValue(-1)
    end)
    p_u_59:_Setup()
    p_u_59:_Update()
    v_u_8:Add(p_u_59.Dragger)
    v_u_8:Add(p_u_59.IncreaseButton)
    v_u_8:Add(p_u_59.DecreaseButton)
end
return v_u_11