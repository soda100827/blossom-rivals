local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.ItemLibrary)
require(v1.Modules.Signal)
local v_u_4 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("WeaponStatusHandler"))
local v_u_5 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("DropdownSlot"))
local v_u_6 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect"))
local v_u_7 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("Setting"))
local v_u_8 = setmetatable({}, v_u_7)
v_u_8.__index = v_u_8
function v_u_8.new(...)
    local v9 = v_u_7.new(...)
    local v10 = v_u_8
    local v11 = setmetatable(v9, v10)
    v11.DropdownContainer = v11.SettingFrame:WaitForChild("Container")
    v11.DropdownFrame = v11.DropdownContainer:WaitForChild("Dropdown")
    v11.DropdownButton = v11.DropdownFrame:WaitForChild("Button")
    v11.DropdownText = v11.DropdownButton:WaitForChild("Title")
    v11._custom_value_set = false
    v11._dropdown_slot = nil
    v11:_Init()
    return v11
end
function v_u_8.GetSelection(p12)
    return p12.DropdownButton
end
function v_u_8.InputValue(p13, p14)
    if p13._custom_value_set then
        p13:StoreValue(p14)
    else
        p13:SetValue(p14)
    end
end
function v_u_8.Destroy(p15)
    if p15._dropdown_slot then
        p15._dropdown_slot:Destroy()
    end
    v_u_7.Destroy(p15)
end
function v_u_8._Update(p16)
    p16.DropdownText.Text = p16.Value
    p16.DropdownText.Position = UDim2.new(0.05, 0, 0.5, 0)
    v_u_4:ClearStatusElements(p16.DropdownText)
    local v17 = v_u_4
    local v18 = p16.DropdownText
    local v19 = v_u_3.Items[p16.Value]
    if v19 then
        v19 = v_u_3.Items[p16.Value].Status
    end
    v17:ApplyItemStatusToText(v18, v19)
end
function v_u_8._Init(p_u_20)
    p_u_20.Changed:Connect(function()
        p_u_20:_Update()
    end)
    p_u_20.DropdownButton.MouseButton1Click:Connect(function()
        p_u_20.DropdownButton.Visible = false
        if p_u_20._dropdown_slot then
            p_u_20._dropdown_slot:Cancel()
            p_u_20._dropdown_slot = nil
        end
        p_u_20._dropdown_slot = v_u_5.new(p_u_20.DropdownFrame, p_u_20.SettingsInfo.Options)
        p_u_20._dropdown_slot.Selected:Connect(function(p21)
            p_u_20.DropdownButton.Visible = true
            if p21 then
                p_u_20:InputValue(p21)
            end
            p_u_20._dropdown_slot = nil
        end)
    end)
    p_u_20:_Update()
    v_u_6:Add(p_u_20.DropdownButton, nil, {
        ["ReleaseRatio"] = 1.025,
        ["HoverRatio"] = 1.025
    })
end
return v_u_8