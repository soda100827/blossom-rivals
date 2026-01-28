local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = require(v1.Modules.CosmeticLibrary)
local v_u_3 = {}
v_u_3.__index = v_u_3
function v_u_3.new(p4)
    local v5 = v_u_3
    local v6 = setmetatable({}, v5)
    v6.Customize = p4
    v6.Frame = v6.Customize.TopFrame:WaitForChild("Description")
    v6.Background = v6.Frame:WaitForChild("Background")
    v6.Arrow = v6.Frame:WaitForChild("Arrow")
    v6.Title = v6.Frame:WaitForChild("Title")
    v6:_Init()
    return v6
end
function v_u_3.OnCustomizingStateChanged(p7)
    p7:_Update()
end
function v_u_3._UpdateArrow(p8)
    local v9 = p8.Background.AbsolutePosition.X + p8.Background.AbsoluteSize.X / 2 - (p8.Customize.NameDisplay.SlotContainer.AbsolutePosition.X + p8.Customize.NameDisplay.SlotContainer.AbsoluteSize.X / 2)
    local v10 = math.abs(v9)
    local v11 = p8.Background.AbsoluteSize.X / 2 - p8.Arrow.AbsoluteSize.X - 8
    local v12 = math.min(v10, v11) * math.sign(v9)
    p8.Arrow.Position = UDim2.new(0.5, -v12, 0, 2)
end
function v_u_3._Update(p13)
    local v14 = p13.Customize.Interface.Equipment:GetSelectedCosmetic()
    local v15 = v_u_2.Cosmetics[v14]
    local v16 = v14 == "RANDOM_COSMETIC" and "Equips a random cosmetic every time you spawn" or (v15 and v15.GetDescription(true) or nil)
    p13.Frame.Visible = v16 ~= nil
    p13.Title.Text = v16 or ""
    if p13.Frame.Visible then
        p13.Frame.Size = UDim2.new(0.5, 0.03125, 0)
        p13.Frame:TweenSize(UDim2.new(1, 0, 0.0625, 0), "Out", "Back", 0.25, true)
    end
end
function v_u_3._UpdateBackground(p17)
    p17.Background.Size = UDim2.new(0, p17.Title.TextBounds.X + p17.Frame.AbsoluteSize.Y, 1, 0)
end
function v_u_3._Init(p_u_18)
    p_u_18.Title:GetPropertyChangedSignal("TextBounds"):Connect(function()
        p_u_18:_UpdateBackground()
    end)
    p_u_18.Background:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
        p_u_18:_UpdateArrow()
    end)
    p_u_18.Background:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        p_u_18:_UpdateArrow()
    end)
    p_u_18.Arrow:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        p_u_18:_UpdateArrow()
    end)
    p_u_18.Customize.NameDisplay.SlotContainer:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
        p_u_18:_UpdateArrow()
    end)
    p_u_18.Customize.NameDisplay.SlotContainer:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        p_u_18:_UpdateArrow()
    end)
    p_u_18:_UpdateBackground()
    p_u_18:_UpdateArrow()
end
return v_u_3