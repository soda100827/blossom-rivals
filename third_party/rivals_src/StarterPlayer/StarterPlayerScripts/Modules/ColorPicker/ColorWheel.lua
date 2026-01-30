local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("RunService")
local v3 = game:GetService("Players")
local v_u_4 = require(v1.Modules.CONSTANTS)
local v_u_5 = require(v1.Modules.Utility)
local v_u_6 = require(v3.LocalPlayer.PlayerScripts.Modules.ColorPicker)
local v_u_7 = require(v3.LocalPlayer.PlayerScripts.Modules.UILibrary)
local v_u_8 = setmetatable({}, v_u_6)
v_u_8.__index = v_u_8
function v_u_8.new(...)
    local v9 = v_u_6.new(...)
    local v10 = v_u_8
    local v11 = setmetatable(v9, v10)
    v11.ColorWheelFrame = v11.Frame:WaitForChild("ColorWheel")
    v11.Picture = v11.ColorWheelFrame:WaitForChild("Picture")
    v11.PictureIcon = v11.Picture:WaitForChild("Icon")
    v11.Cursor = v11.ColorWheelFrame:WaitForChild("Cursor")
    v11.ValueSliderFrame = v11.Frame:WaitForChild("ValueSlider")
    v11.ValueColor = v11.ValueSliderFrame:WaitForChild("Color")
    v11.Slider = v11.ValueSliderFrame:WaitForChild("Slider")
    v11._color_picker_connection = nil
    v11._ignore_next_cursor_and_slider_update = false
    v11:_Init()
    return v11
end
function v_u_8.Destroy(p12)
    p12:_ClearConnections()
    v_u_6.Destroy(p12)
end
function v_u_8._ClearConnections(p13)
    if p13._color_picker_connection then
        p13._color_picker_connection:Disconnect()
        p13._color_picker_connection = nil
    end
end
function v_u_8._UpdateValueColor(p14)
    local v15, v16, v17 = v_u_5:Color3FromHex(p14.Value):ToHSV()
    local v18 = Color3.fromHSV(v15, v16, 1)
    p14.ValueColor.BackgroundColor3 = v18
    p14.PictureIcon.ImageColor3 = Color3.new(v17, v17, v17)
end
function v_u_8._UpdateFromCursorAndSlider(p19)
    local v20 = p19.Cursor.AbsolutePosition + p19.Cursor.AbsoluteSize / 2 - (p19.Picture.AbsolutePosition + p19.Picture.AbsoluteSize / 2)
    local v21 = v20.Magnitude / (p19.Picture.AbsoluteSize.Y / 2)
    local v22 = v20.Y / v20.X
    local v23 = math.atan(v22) + (v20.X < 0 and 3.141592653589793 or 0)
    local v24 = v23 ~= v23 and 0 or (v23 + 1.5707963267948966) / 6.283185307179586
    local v25 = math.clamp(v24, 0, 1)
    local v26 = math.clamp(v21, 0, 1)
    local v27 = 1 - p19.Slider.Position.Y.Scale
    local v28 = math.clamp(v27, 0, 1)
    p19:SetColor(v_u_5:HexFromColor3((Color3.fromHSV(v25, v26, v28))), true)
end
function v_u_8._RepositionCursorAndSlider(p_u_29)
    if p_u_29._ignore_next_cursor_and_slider_update then
        task.defer(function()
            p_u_29._ignore_next_cursor_and_slider_update = false
        end)
    else
        local v30 = v_u_5:Color3FromHex(p_u_29.Value)
        local v31, v32, v33 = v30:ToHSV(v30)
        local v34 = v31 * 6.283185307179586 - 1.5707963267948966
        local v35 = v32 * (p_u_29.Picture.AbsoluteSize.Y / 2)
        local v36 = math.cos(v34) * v35 / p_u_29.Picture.AbsoluteSize.X
        local v37 = math.sin(v34) * v35 / p_u_29.Picture.AbsoluteSize.Y
        p_u_29.Slider.Position = UDim2.new(0.5, 0, 1 - v33, 0)
        p_u_29.Cursor.Position = UDim2.new(0.5 + v36, 0, 0.5 + v37, 0)
    end
end
function v_u_8._Setup(p_u_38)
    p_u_38.Cursor.Visible = true
    p_u_38.Slider.Visible = true
    if v_u_4.DEVICE ~= "Console" then
        p_u_38.ColorWheelFrame.InputBegan:Connect(function(p39)
            if p39.UserInputType == Enum.UserInputType.MouseButton1 or p39.UserInputType == Enum.UserInputType.Touch then
                p_u_38:_ClearConnections()
                p_u_38._color_picker_connection = v_u_2.RenderStepped:Connect(function()
                    local v40 = v_u_7:GetMouseLocation() - (p_u_38.Picture.AbsolutePosition + p_u_38.Picture.AbsoluteSize / 2)
                    local v41 = v40.Magnitude
                    local v42 = p_u_38.Picture.AbsoluteSize.Y / 2
                    local v43 = math.clamp(v41, 0, v42)
                    local v44 = v40.Y / v40.X
                    local v45 = math.atan(v44) + (v40.X < 0 and 3.141592653589793 or 0)
                    local v46 = math.cos(v45) * v43 / p_u_38.Picture.AbsoluteSize.X
                    local v47 = math.sin(v45) * v43 / p_u_38.Picture.AbsoluteSize.Y
                    p_u_38._ignore_next_cursor_and_slider_update = true
                    p_u_38.Cursor.Position = UDim2.new(0.5 + v46, 0, 0.5 + v47, 0)
                    p_u_38.Cursor.Visible = true
                    p_u_38:_UpdateFromCursorAndSlider()
                end)
            end
        end)
        p_u_38.ColorWheelFrame.InputEnded:Connect(function(p48)
            if p48.UserInputType == Enum.UserInputType.MouseButton1 or p48.UserInputType == Enum.UserInputType.Touch then
                p_u_38:_ClearConnections()
                p_u_38:SetColor(p_u_38.Value)
            end
        end)
        p_u_38.ValueSliderFrame.InputBegan:Connect(function(p49)
            if p49.UserInputType == Enum.UserInputType.MouseButton1 or p49.UserInputType == Enum.UserInputType.Touch then
                p_u_38:_ClearConnections()
                p_u_38._color_picker_connection = v_u_2.RenderStepped:Connect(function()
                    local v50 = (v_u_7:GetMouseLocation().Y - p_u_38.ValueSliderFrame.AbsolutePosition.Y) / p_u_38.ValueSliderFrame.AbsoluteSize.Y
                    local v51 = math.clamp(v50, 0, 1)
                    p_u_38._ignore_next_cursor_and_slider_update = true
                    p_u_38.Slider.Position = UDim2.new(0.5, 0, v51, 0)
                    p_u_38.Slider.Visible = true
                    p_u_38:_UpdateFromCursorAndSlider()
                end)
            end
        end)
        p_u_38.ValueSliderFrame.InputEnded:Connect(function(p52)
            if p52.UserInputType == Enum.UserInputType.MouseButton1 or p52.UserInputType == Enum.UserInputType.Touch then
                p_u_38:_ClearConnections()
                p_u_38:SetColor(p_u_38.Value)
            end
        end)
    end
end
function v_u_8._Init(p_u_53)
    p_u_53.Updated:Connect(function()
        p_u_53:_UpdateValueColor()
        p_u_53:_RepositionCursorAndSlider()
    end)
    p_u_53.Changed:Connect(function()
        p_u_53:_UpdateValueColor()
        p_u_53:_RepositionCursorAndSlider()
    end)
    p_u_53:_Setup()
    p_u_53:_RepositionCursorAndSlider()
end
return v_u_8