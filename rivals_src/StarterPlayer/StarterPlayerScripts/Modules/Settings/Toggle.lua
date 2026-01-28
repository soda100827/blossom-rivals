local v1 = game:GetService("Players")
local v_u_2 = require(v1.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect"))
local v_u_3 = require(v1.LocalPlayer.PlayerScripts.Modules:WaitForChild("Setting"))
local v_u_4 = Color3.fromRGB(0, 0, 0)
local v_u_5 = Color3.fromRGB(255, 255, 255)
local v_u_6 = Color3.fromRGB(100, 255, 50)
local v_u_7 = setmetatable({}, v_u_3)
v_u_7.__index = v_u_7
function v_u_7.new(...)
    local v8 = v_u_3.new(...)
    local v9 = v_u_7
    local v10 = setmetatable(v8, v9)
    v10.ToggleContainer = v10.BaseContainer:WaitForChild("Container")
    v10.Background = v10.ToggleContainer:WaitForChild("Background")
    v10.Button = v10.ToggleContainer:WaitForChild("Button")
    v10.Slider = v10.Button:WaitForChild("Slider")
    v10._custom_value_set = false
    v10:_Init()
    return v10
end
function v_u_7.GetSelection(p11)
    return p11.Button
end
function v_u_7.InputValue(p12, p13)
    if p12._custom_value_set then
        p12:StoreValue(p13)
    else
        p12:SetValue(p13)
    end
end
function v_u_7._Update(p14)
    local v15 = p14.Value and UDim2.new(0.75, 0, 0.5, 0) or UDim2.new(0.25, 0, 0.5, 0)
    if p14.Slider:IsDescendantOf(game) then
        p14.Slider:TweenPosition(v15, "Out", "Quint", 0.5, true)
    else
        p14.Slider.Position = v15
    end
end
function v_u_7._Toggle(p16)
    p16:InputValue(not p16.Value)
end
function v_u_7._Setup(p17)
    p17.Button.NextSelectionRight = p17.Button
    p17.Button.NextSelectionLeft = p17.Button
end
function v_u_7._Init(p_u_18)
    p_u_18.Changed:Connect(function()
        p_u_18:_Update()
    end)
    p_u_18.Button.MouseButton1Click:Connect(function()
        p_u_18:_Toggle()
    end)
    p_u_18.Slider:GetPropertyChangedSignal("Position"):Connect(function()
        local v19 = (p_u_18.Slider.Position.X.Scale - 0.25) / 0.5
        p_u_18.Slider.ImageColor3 = v_u_4:Lerp(v_u_4, v19)
        p_u_18.Background.ImageColor3 = v_u_5:Lerp(v_u_6, v19)
    end)
    p_u_18:_Setup()
    p_u_18:_Update()
    v_u_2:Add(p_u_18.Button, nil, {
        ["ReleaseRatio"] = 0.95,
        ["HoverRatio"] = 0.95
    })
end
return v_u_7