local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("UserInputService")
local v3 = game:GetService("Players")
local v_u_4 = require(v1.Modules.Utility)
local v_u_5 = require(v1.Modules.Signal)
local v_u_6 = require(v3.LocalPlayer.PlayerScripts.Modules:WaitForChild("ColorPicker"):WaitForChild("ColorWheel"))
local v_u_7 = require(v3.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect"))
local v_u_8 = require(v3.LocalPlayer.PlayerScripts.Modules:WaitForChild("UILibrary"))
local v_u_9 = require(v3.LocalPlayer.PlayerScripts.Modules:WaitForChild("Setting"))
local v_u_10 = setmetatable({}, v_u_9)
v_u_10.__index = v_u_10
function v_u_10.new(...)
    local v11 = v_u_9.new(...)
    local v12 = v_u_10
    local v13 = setmetatable(v11, v12)
    v13.SliderChanged = v_u_5.new()
    v13.EditButton = v13.BaseContainer:WaitForChild("Edit")
    v13.ColorFrame = v13.EditButton:WaitForChild("Color")
    v13.EditButtonBackground = v13.EditButton:WaitForChild("Background")
    v13.ColorWheel = v_u_6.new(v13.ColorFrame)
    v13._close_connection = nil
    v13._open_time = 0
    v13._is_open = false
    v13:_Init()
    return v13
end
function v_u_10.GetSelection(p14)
    return p14.ColorFrame
end
function v_u_10.SetOpen(p_u_15, p16)
    local v17 = typeof(p16) == "boolean"
    assert(v17, "Argument 1 invalid, expected a boolean")
    p_u_15._is_open = p16
    p_u_15.ColorFrame.Visible = p_u_15._is_open
    p_u_15.SettingFrame.ZIndex = p_u_15._is_open and 999 or 1
    if p_u_15._close_connection then
        p_u_15._close_connection:Disconnect()
        p_u_15._close_connection = nil
    end
    if p_u_15._is_open then
        p_u_15._open_time = tick()
        p_u_15._close_connection = v_u_2.InputEnded:Connect(function(p18, _)
            if tick() - p_u_15._open_time >= 0.25 and (p18.UserInputType == Enum.UserInputType.MouseButton1 or (p18.UserInputType == Enum.UserInputType.Touch or p18.KeyCode == Enum.KeyCode.ButtonA)) then
                if not v_u_8:IsMouseWithinBounds(p_u_15.ColorFrame.AbsolutePosition, p_u_15.ColorFrame.AbsoluteSize) then
                    p_u_15:SetOpen(false)
                end
            end
        end)
    end
end
function v_u_10.SetAlwaysOpen(p19)
    p19:SetOpen(true)
    p19.ColorFrame.Position = UDim2.new(0.325, 0, 0, 0)
end
function v_u_10.Destroy(p20)
    p20.ColorWheel:Destroy()
    p20.SliderChanged:Destroy()
    v_u_9.Destroy(p20)
end
function v_u_10._Update(p21)
    p21.ColorWheel:SetStartingColor(p21.Value)
    p21.EditButtonBackground.ImageColor3 = v_u_4:Color3FromHex(p21.Value)
end
function v_u_10._Init(p_u_22)
    p_u_22.Changed:Connect(function()
        p_u_22:_Update()
    end)
    p_u_22.ColorWheel.Updated:Connect(function(p23, p24)
        if p24 then
            p_u_22:StoreValue(p23)
        else
            p_u_22:SetValue(p23)
        end
        p_u_22.SliderChanged:Fire(p23)
    end)
    p_u_22.EditButton.MouseButton1Click:Connect(function()
        p_u_22:SetOpen(not p_u_22._is_open)
    end)
    p_u_22:_Update()
    v_u_7:Add(p_u_22.EditButton, nil, {
        ["HoverRatio"] = 1,
        ["ReleaseRatio"] = 1
    })
end
return v_u_10