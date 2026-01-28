local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("UserInputService")
local v_u_3 = require(v1.Modules.CONSTANTS)
local v_u_4 = require(v1.Modules.Utility)
local v_u_5 = require(v1.Modules.Signal)
local v_u_6 = {
    ["Desktop"] = "MouseKeyboard",
    ["Mobile"] = "Touch",
    ["Console"] = "Gamepad",
    ["VR"] = "VR"
}
local v_u_7 = {
    [Enum.UserInputType.MouseButton1] = "MouseKeyboard",
    [Enum.UserInputType.MouseButton2] = "MouseKeyboard",
    [Enum.UserInputType.MouseButton3] = "MouseKeyboard",
    [Enum.UserInputType.Keyboard] = "MouseKeyboard",
    [Enum.UserInputType.Touch] = "Touch",
    [Enum.UserInputType.Gamepad1] = "Gamepad",
    [Enum.UserInputType.Gamepad2] = "Gamepad",
    [Enum.UserInputType.Gamepad3] = "Gamepad",
    [Enum.UserInputType.Gamepad4] = "Gamepad",
    [Enum.UserInputType.Gamepad5] = "Gamepad",
    [Enum.UserInputType.Gamepad6] = "Gamepad",
    [Enum.UserInputType.Gamepad7] = "Gamepad",
    [Enum.UserInputType.Gamepad8] = "Gamepad"
}
local v_u_8 = {
    [Enum.KeyCode.W] = "MouseKeyboard",
    [Enum.KeyCode.A] = "MouseKeyboard",
    [Enum.KeyCode.S] = "MouseKeyboard",
    [Enum.KeyCode.D] = "MouseKeyboard"
}
local v_u_9 = {}
v_u_9.__index = v_u_9
function v_u_9._new()
    local v10 = v_u_9
    local v11 = setmetatable({}, v10)
    v11.ControlsChanged = v_u_5.new()
    v11.InputBegan = v_u_5.new()
    v11.InputChanged = v_u_5.new()
    v11.InputEnded = v_u_5.new()
    v11.CurrentControls = v_u_6[v_u_3.DEVICE]
    v11._toggled_inputs = {}
    v11._is_verification_disabled = false
    v11:_Init()
    return v11
end
function v_u_9.IsInputDown(p12, p13)
    return p13.EnumType == Enum.KeyCode and v_u_2:IsKeyDown(p13) or (p13.EnumType == Enum.UserInputType and v_u_2:IsMouseButtonPressed(p13) or p13.EnumType == Enum.KeyCode and (p12.CurrentControls == "Gamepad" or p12.CurrentControls == "VR") and v_u_2:IsGamepadButtonDown(v_u_2:GetLastInputType(), p13) or p12:IsToggled(p13))
end
function v_u_9.IsToggled(p14, p15)
    return p14._toggled_inputs[p15]
end
function v_u_9.ToggleInput(p16, p17, p18)
    p16._toggled_inputs[p17] = p18 or nil
end
function v_u_9.SetControls(p19, p20)
    if p20 and p20 ~= p19.CurrentControls then
        if p20 ~= "VR" and p19.CurrentControls ~= "VR" then
            p19.CurrentControls = p20
            p19.ControlsChanged:Fire()
        end
    else
        return
    end
end
function v_u_9.DisableVerification(p21, p22)
    p21._is_verification_disabled = p22
end
function v_u_9._VerifyControls(p23, p24, p25)
    if p23._is_verification_disabled or (p25 or v_u_4:IsTextBoxFocused()) then
        return
    elseif p24.KeyCode ~= Enum.KeyCode.Thumbstick1 and p24.KeyCode ~= Enum.KeyCode.Thumbstick2 or (p24.Position * Vector3.new(1, 1, 0)).Magnitude >= 0.75 then
        p23:SetControls(v_u_7[p24.UserInputType] or v_u_8[p24.KeyCode])
    end
end
function v_u_9._Init(p_u_26)
    v_u_2.InputBegan:Connect(function(...)
        p_u_26:_VerifyControls(...)
        p_u_26.InputBegan:Fire(...)
    end)
    v_u_2.InputChanged:Connect(function(...)
        p_u_26:_VerifyControls(...)
        p_u_26.InputChanged:Fire(...)
    end)
    v_u_2.InputEnded:Connect(function(...)
        p_u_26:_VerifyControls(...)
        p_u_26.InputEnded:Fire(...)
    end)
end
return v_u_9._new()