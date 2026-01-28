local v_u_1 = game:GetService("RunService")
local v_u_2 = game:GetService("Players").LocalPlayer.PlayerScripts.UserInterface:WaitForChild("BowCharge")
local v_u_3 = {}
v_u_3.__index = v_u_3
function v_u_3.new(p4)
    local v5 = v_u_3
    local v6 = setmetatable({}, v5)
    v6.ItemInterface = p4
    v6.Frame = v_u_2:Clone()
    v6.DamageText = v6.Frame:WaitForChild("Damage")
    v6.Background = v6.Frame:WaitForChild("Background")
    v6.BackgroundDivider2 = v6.Background:WaitForChild("Divider2")
    v6.BackgroundDivider3 = v6.Background:WaitForChild("Divider3")
    v6.BackgroundBar = v6.Background:WaitForChild("Bar")
    v6.BackgroundEffect = v6.Background:WaitForChild("Effect")
    v6.BackgroundEffectUIStroke = v6.BackgroundEffect:WaitForChild("UIStroke")
    v6.KeyWhiteFrame = v6.Background:WaitForChild("KeyWhite")
    v6.KeyColorFrame = v6.Background:WaitForChild("KeyColor")
    v6.KeyColorCircleStroke = v6.KeyColorFrame:WaitForChild("Circle"):WaitForChild("UIStroke")
    v6._start_time = nil
    v6._charge_hash = 0
    v6._max_charge_connection = nil
    v6:_Init()
    return v6
end
function v_u_3.Set(p_u_7, p8)
    if not p_u_7._destroyed then
        if p_u_7._max_charge_connection then
            p_u_7._max_charge_connection:Disconnect()
            p_u_7._max_charge_connection = nil
        end
        local v9 = p_u_7.ItemInterface.ClientItem.ViewModel:GetChargeColor(p8)
        local v10 = p_u_7.ItemInterface.ClientItem.Info.ChargeLevelDamageMultipliers
        p_u_7.Frame.Position = UDim2.new(0.5, 24, 0.5, 24)
        local v11 = p_u_7.DamageText
        local v12 = v10[p8] * 100
        v11.Text = "<font family=\"12187365977\"><stroke color=\"rgb(255,255,255)\" joins=\"miter\" thickness=\"3\">" .. math.floor(v12) .. "%</stroke></font>"
        p_u_7.DamageText.TextColor3 = v9
        p_u_7.DamageText.Size = UDim2.new(1, 0, p8 == 1 and 0.5 or 0.75, 0)
        p_u_7.DamageText:TweenSize(UDim2.new(1, 0, 0.5, 0), "Out", "Quint", 0.5, true)
        p_u_7.BackgroundEffectUIStroke.Color = v9
        p_u_7.BackgroundBar.BackgroundColor3 = v9
        p_u_7.KeyColorCircleStroke.Color = v9
        if #v10 <= p8 then
            p_u_7._max_charge_connection = v_u_1.RenderStepped:Connect(function(_)
                p_u_7.Frame.Position = UDim2.new(0.5, 24 + 8 * (math.random() - 0.5), 0.5, 24 + 8 * (math.random() - 0.5))
            end)
        end
    end
end
function v_u_3.Start(p13, p14)
    if not p13._destroyed then
        local v15 = typeof(p14) == "table"
        assert(v15, "Argument 1 invalid, expected a table")
        p13._charge_hash = p13._charge_hash + 1
        p13._start_time = tick()
        p13.Frame.Visible = true
        p13.BackgroundBar.Size = UDim2.new(0, 8, 1, 0)
        p13.BackgroundBar:TweenSize(UDim2.new(1, 0, 1, 0), "Out", "Linear", p14[#p14], true)
        p13.BackgroundEffect.Size = UDim2.new(1, 0, 1, 0)
        p13.BackgroundEffect.Visible = false
        local v16 = {}
        for v17, v18 in pairs(p14) do
            local v19 = v18 / p14[#p14]
            local v20 = p13.ItemInterface.ClientItem.ViewModel:GetChargeColor(v17)
            local v21 = ColorSequenceKeypoint.new
            table.insert(v16, v21(v19, v20))
            if v17 ~= 1 and v17 ~= #p14 then
                p13["BackgroundDivider" .. v17].Position = UDim2.new(v18 / p14[#p14], 0, 0, 0)
            end
        end
    end
end
function v_u_3.Play(p22)
    if not p22._destroyed then
        p22.Background.Size = UDim2.new(1, 0, 0.375, 0)
        p22.Background:TweenSize(UDim2.new(1, 0, 0.25, 0), "Out", "Quint", 0.5, true)
    end
end
function v_u_3.Stop(p_u_23, p24)
    if p_u_23._destroyed then
        return
    else
        if p_u_23._max_charge_connection then
            p_u_23._max_charge_connection:Disconnect()
            p_u_23._max_charge_connection = nil
        end
        if p24 then
            p_u_23.Frame.Visible = false
        else
            local v_u_25 = p_u_23._charge_hash
            p_u_23.BackgroundBar:TweenSize(p_u_23.BackgroundBar.Size, "Out", "Linear", 0, true)
            p_u_23.BackgroundEffect.Visible = true
            p_u_23.BackgroundEffect:TweenSize(UDim2.new(1, 8, 1, 8), "Out", "Linear", 0.5, true, function()
                wait(0.5)
                if p_u_23._charge_hash == v_u_25 then
                    p_u_23.Frame.Visible = false
                end
            end)
        end
        if p_u_23._start_time then
            p_u_23._start_time = nil
        end
    end
end
function v_u_3.Destroy(p26)
    p26.Frame:Destroy()
    if p26._max_charge_connection then
        p26._max_charge_connection:Disconnect()
        p26._max_charge_connection = nil
    end
end
function v_u_3._Setup(p27)
    local v28 = p27.ItemInterface.ClientItem.ViewModel.Name == "Key Bow"
    local v29 = p27.Frame
    v29.Position = v29.Position + (v28 and UDim2.new(0, 18, 0, 0) or UDim2.new(0, 0, 0, 0))
    p27.KeyWhiteFrame.Visible = v28
    p27.KeyColorFrame.Visible = v28
    p27.Frame.Parent = p27.ItemInterface.Mouse.Frame
end
function v_u_3._Init(p_u_30)
    p_u_30.BackgroundEffect:GetPropertyChangedSignal("Size"):Connect(function()
        p_u_30.BackgroundEffectUIStroke.Thickness = 4 - p_u_30.BackgroundEffect.Size.X.Offset / 2
    end)
    p_u_30:_Setup()
    p_u_30:Set(1)
end
return v_u_3