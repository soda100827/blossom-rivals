local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = require(v1.Modules.Utility)
local v_u_3 = {}
v_u_3.__index = v_u_3
local function v_u_5(p4)
    return p4
end
local function v_u_7(p6)
    if typeof(p6) == "boolean" then
        return p6
    end
end
local function v_u_9(p8)
    if p8 == nil or p8 == "nil" then
        return "nil"
    end
    if v_u_2:GetInputEnumFromName(p8) then
        return p8
    end
end
local function v_u_11(p10)
    if v_u_2:IsValidHex(p10) then
        return p10
    end
end
function v_u_3.new(p12, p13, p14, p15, p16, p17, p18, ...)
    local v19 = v_u_3
    local v_u_20 = setmetatable({}, v19)
    v_u_20.Section = p12
    v_u_20.Name = p13
    v_u_20.DisplayName = p14
    v_u_20.Image = p15
    v_u_20.Description = p16
    v_u_20.DefaultValue = p18
    v_u_20.InputType = p17
    v_u_20.VerifyInput = nil
    v_u_20.Options = nil
    v_u_20.Min = nil
    v_u_20.Max = nil
    v_u_20.Increment = nil
    v_u_20.GetEnum = nil
    local v21 = { ... }
    if v_u_20.InputType == "Confirm" then
        v_u_20.VerifyInput = v_u_5
    elseif v_u_20.InputType == "Toggle" or (v_u_20.InputType == "ToggleConfirm" or v_u_20.InputType == "Checkbox") then
        v_u_20.VerifyInput = v_u_7
    elseif v_u_20.InputType == "Hotkey" then
        v_u_20.VerifyInput = v_u_9
    elseif v_u_20.InputType == "Color" then
        v_u_20.VerifyInput = v_u_11
    elseif v_u_20.InputType == "Options" or (v_u_20.InputType == "OptionsConfirm" or (v_u_20.InputType == "Dropdown" or v_u_20.InputType == "DropdownConfirm")) then
        local v_u_22 = table.unpack(v21)
        v_u_20.Options = v_u_22
        function v_u_20.VerifyInput(p23)
            if typeof(p23) ~= "string" or not (table.find(v_u_22, p23) and p23) then
                p23 = nil
            end
            return p23
        end
    elseif v_u_20.InputType == "Slider" or v_u_20.InputType == "SliderConfirm" then
        local v24, v25, v26 = table.unpack(v21)
        v_u_20.Min = v24
        v_u_20.Max = v25
        v_u_20.Increment = v26
        function v_u_20.VerifyInput(p27)
            local v28
            if string.lower((tostring(p27))) == "nan" or typeof(p27) ~= "number" then
                v28 = nil
            else
                local v29 = v_u_20.Min
                local v30 = v_u_20.Max
                local v31 = math.clamp(p27, v29, v30) * v_u_20.Increment + 0.5
                v28 = math.floor(v31) / v_u_20.Increment or nil
            end
            return v28
        end
    end
    v_u_20:_Init()
    return v_u_20
end
function v_u_3._Init(_) end
return v_u_3