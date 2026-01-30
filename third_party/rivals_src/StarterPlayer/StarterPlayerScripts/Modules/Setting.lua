local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.Signal)
local v_u_4 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect"))
local v_u_5 = v2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("Settings")
local v_u_6 = {}
v_u_6.__index = v_u_6
function v_u_6.new(p7, p8)
    local v9 = typeof(p7) == "table"
    assert(v9, "Argument 1 invalid, expected a table")
    local v10 = not p8 or typeof(p8) == "Instance"
    assert(v10, "Argument 2 invalid, expected a Instance or nil")
    local v11 = v_u_6
    local v12 = setmetatable({}, v11)
    v12.SettingFrame = (p8 or v_u_5:WaitForChild(p7.InputType)):Clone()
    v12.BaseContainer = v12.SettingFrame:WaitForChild("Container")
    v12.TitleText = v12.BaseContainer:WaitForChild("Title")
    v12.DescriptionText = v12.BaseContainer:WaitForChild("Description")
    v12.Icon = v12.BaseContainer:WaitForChild("Icon")
    v12.ResetButton = v12.BaseContainer:WaitForChild("Reset")
    v12.SettingsInfo = p7
    v12.Value = p7.DefaultValue
    v12.Changed = v_u_3.new()
    v12.Replicate = v_u_3.new()
    v12._value_change_cooldown = 0
    v12:_Init()
    return v12
end
function v_u_6.SetValue(p13, p14, p15, p16)
    if (p13.SettingsInfo.InputType == "Hotkey" or p14 ~= nil) and (p16 or tick() >= p13._value_change_cooldown) then
        p13.Value = p14
        p13.Changed:Fire(p13.Value)
        if not p15 then
            p13._value_change_cooldown = tick() + 0.05
            p13.Replicate:Fire(p13.Value)
        end
    end
end
function v_u_6.StoreValue(p17, p18)
    p17.Value = p18
    p17.Changed:Fire(p17.Value)
end
function v_u_6.CancelInputs(_) end
function v_u_6.Destroy(p19)
    p19.SettingFrame:Destroy()
    p19.Changed:Destroy()
    p19.Replicate:Destroy()
end
function v_u_6._UpdateResetButton(p20)
    local v21 = p20.ResetButton
    local v22
    if p20.SettingsInfo.InputType == "Divider" then
        v22 = false
    else
        v22 = p20.Value ~= p20.SettingsInfo.DefaultValue
    end
    v21.Visible = v22
end
function v_u_6._Setup(p23)
    p23.Icon.Image = p23.SettingsInfo.Image
    p23.DescriptionText.Text = p23.SettingsInfo.Description
    p23.TitleText.Text = p23.SettingsInfo.DisplayName
    p23.TitleText.Position = p23.SettingsInfo.Description == "" and UDim2.new(p23.TitleText.Position.X.Scale, p23.TitleText.Position.X.Offset, 0.5, p23.TitleText.Position.Y.Offset) or p23.TitleText.Position
end
function v_u_6._Init(p_u_24)
    p_u_24.Changed:Connect(function()
        p_u_24:_UpdateResetButton()
    end)
    p_u_24.ResetButton.MouseButton1Click:Connect(function()
        p_u_24:SetValue(p_u_24.SettingsInfo.DefaultValue)
    end)
    p_u_24:_Setup()
    p_u_24:_UpdateResetButton()
    v_u_4:Add(p_u_24.ResetButton)
end
return v_u_6