local v1 = game:GetService("Players")
local v_u_2 = require(v1.LocalPlayer.PlayerScripts.Modules.CosmeticSlot)
local v_u_3 = {}
v_u_3.__index = v_u_3
function v_u_3.new(p4)
    local v5 = v_u_3
    local v6 = setmetatable({}, v5)
    v6.Customize = p4
    v6.Frame = v6.Customize.TopFrame:WaitForChild("NameDisplay")
    v6.Background = v6.Frame:WaitForChild("Background")
    v6.ElementsFrame = v6.Frame:WaitForChild("Elements")
    v6.Layout = v6.ElementsFrame:WaitForChild("Layout")
    v6.SlotContainer = v6.ElementsFrame:WaitForChild("Slot"):WaitForChild("Container")
    v6.TitleContainer = v6.ElementsFrame:WaitForChild("TitleContainer")
    v6.Title = v6.TitleContainer:WaitForChild("Title")
    v6._cosmetic_slot = nil
    v6:_Init()
    return v6
end
function v_u_3.OnCustomizingStateChanged(p7)
    p7:_Update()
end
function v_u_3._Update(p8)
    if p8._cosmetic_slot then
        p8._cosmetic_slot:Destroy()
        p8._cosmetic_slot = nil
    end
    local v9 = p8.Customize.Interface.Equipment:GetSelectedCosmetic()
    p8.Frame.Visible = v9 ~= nil
    p8.Title.Text = v9 == "RANDOM_COSMETIC" and "Random" or (v9 or "")
    if v9 then
        p8._cosmetic_slot = v_u_2.new(v9)
        p8._cosmetic_slot:SetWeapon(nil)
        p8._cosmetic_slot:OverrideNameText("")
        p8._cosmetic_slot:SetInteractable(false)
        p8._cosmetic_slot.Frame.Parent = p8.SlotContainer
    end
end
function v_u_3._UpdateLayout(p10)
    p10.TitleContainer.Size = UDim2.new(0, p10.Title.TextBounds.X, 0.75, 0)
    p10.Background.Size = UDim2.new(0, p10.Layout.AbsoluteContentSize.X + p10.TitleContainer.AbsoluteSize.Y * 0.5, 1, 0)
end
function v_u_3._Init(p_u_11)
    p_u_11.Title:GetPropertyChangedSignal("TextBounds"):Connect(function()
        p_u_11:_UpdateLayout()
    end)
    p_u_11.TitleContainer:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        p_u_11:_UpdateLayout()
    end)
    p_u_11.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p_u_11:_UpdateLayout()
    end)
    p_u_11:_UpdateLayout()
end
return v_u_3