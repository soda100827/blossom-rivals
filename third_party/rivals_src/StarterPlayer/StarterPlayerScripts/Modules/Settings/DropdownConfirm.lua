local v1 = game:GetService("Players")
local v_u_2 = require(v1.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect"))
local v_u_3 = require(v1.LocalPlayer.PlayerScripts.Modules.Settings:WaitForChild("Dropdown"))
local v_u_4 = setmetatable({}, v_u_3)
v_u_4.__index = v_u_4
function v_u_4.new(...)
    local v5 = v_u_3.new(...)
    local v6 = v_u_4
    local v7 = setmetatable(v5, v6)
    v7.ConfirmButton = v7.DropdownContainer:WaitForChild("Confirm")
    v7._custom_value_set = true
    v7:_Init()
    return v7
end
function v_u_4._Init(p_u_8)
    p_u_8.ConfirmButton.MouseButton1Click:Connect(function()
        p_u_8:SetValue(p_u_8.Value, nil, true)
    end)
    v_u_2:Add(p_u_8.ConfirmButton)
end
return v_u_4