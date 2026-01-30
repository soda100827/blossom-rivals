local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = require(v1.Modules.Utility)
local v_u_3 = require(v1.Modules.Signal)
local v_u_4 = {}
v_u_4.__index = v_u_4
function v_u_4.new(p5)
    local v6
    if typeof(p5) == "Instance" then
        v6 = p5:IsA("Frame")
    else
        v6 = false
    end
    local v7 = "Argument 1 invalid, expected a Frame, got " .. tostring(p5)
    assert(v6, v7)
    local v8 = v_u_4
    local v9 = setmetatable({}, v8)
    v9.Frame = p5
    v9.RedFrame = v9.Frame:WaitForChild("Red")
    v9.RedTextBox = v9.RedFrame:WaitForChild("Box")
    v9.GreenFrame = v9.Frame:WaitForChild("Green")
    v9.GreenTextBox = v9.GreenFrame:WaitForChild("Box")
    v9.BlueFrame = v9.Frame:WaitForChild("Blue")
    v9.BlueTextBox = v9.BlueFrame:WaitForChild("Box")
    v9.HexFrame = v9.Frame:WaitForChild("Hex")
    v9.HexTextBox = v9.HexFrame:WaitForChild("Box")
    v9.HexOutline = v9.HexFrame:WaitForChild("Outline")
    v9.Value = nil
    v9.Updated = v_u_3.new()
    v9.Changed = v_u_3.new()
    v9:_Init()
    return v9
end
function v_u_4.SetColor(p10, p11, p12)
    p10.Value = p11
    p10.Updated:Fire(p10.Value, p12 or false)
    p10:_ValueChanged()
end
function v_u_4.SetStartingColor(p13, p14)
    p13.Value = p14
    p13.Changed:Fire(p13.Value)
    p13:_ValueChanged()
end
function v_u_4.Destroy(p15)
    p15.Updated:Destroy()
    p15.Changed:Destroy()
end
function v_u_4._ClampColorChannel(_, p16)
    local v17 = tonumber(p16) or 0
    local v18 = math.floor(v17)
    return math.clamp(v18, 0, 255)
end
function v_u_4._ValueChanged(p19)
    local v20 = p19.Value
    local v21 = v_u_2:Color3FromHex(v20)
    local v22 = p19:_ClampColorChannel(v21.R * 255)
    local v23 = p19:_ClampColorChannel(v21.G * 255)
    local v24 = p19:_ClampColorChannel(v21.B * 255)
    p19.RedTextBox.Text = v22
    p19.GreenTextBox.Text = v23
    p19.BlueTextBox.Text = v24
    p19.HexTextBox.Text = v20
    p19.HexOutline.ImageColor3 = v21
end
function v_u_4._UpdateFromRGB(p25)
    local v26 = p25:_ClampColorChannel(p25.RedTextBox.Text)
    local v27 = p25:_ClampColorChannel(p25.GreenTextBox.Text)
    local v28 = p25:_ClampColorChannel(p25.BlueTextBox.Text)
    p25:SetColor((v_u_2:HexFromColor3((Color3.fromRGB(v26, v27, v28)))))
end
function v_u_4._UpdateFromHex(p29)
    local v30 = string.lower(p29.HexTextBox.Text)
    p29:SetColor(v_u_2:IsValidHex(v30) and v30 and v30 or "#000000")
end
function v_u_4._Init(p_u_31)
    p_u_31.RedTextBox.FocusLost:Connect(function()
        p_u_31:_UpdateFromRGB()
    end)
    p_u_31.GreenTextBox.FocusLost:Connect(function()
        p_u_31:_UpdateFromRGB()
    end)
    p_u_31.BlueTextBox.FocusLost:Connect(function()
        p_u_31:_UpdateFromRGB()
    end)
    p_u_31.HexTextBox.FocusLost:Connect(function()
        p_u_31:_UpdateFromHex()
    end)
    p_u_31:SetStartingColor("#ffffff")
end
return v_u_4