local v_u_1 = game:GetService("GuiService")
local v2 = game:GetService("Players")
local v_u_3 = require(v2.LocalPlayer.PlayerScripts.Modules.UserInterface.Pages)
local v_u_4 = require(v2.LocalPlayer.PlayerScripts.Modules.UILibrary)
local v_u_5 = require(script:WaitForChild("Customize"))
local v_u_6 = require(script:WaitForChild("Right"))
local v_u_7 = require(script:WaitForChild("Left"))
local v_u_8 = {}
v_u_8.__index = v_u_8
function v_u_8.new(p9)
    local v10 = v_u_8
    local v11 = setmetatable({}, v10)
    v11.Equipment = p9
    v11.Frame = v_u_4:GetTo("MainFrame", "Equipment")
    v11.Customize = v_u_5.new(v11)
    v11.Right = v_u_6.new(v11)
    v11.Left = v_u_7.new(v11)
    v11:_Init()
    return v11
end
function v_u_8.OnCustomizingStateChanged(p12, ...)
    p12.Customize:OnCustomizingStateChanged(...)
end
function v_u_8.OnStateChanged(p13, ...)
    p13.Right:OnStateChanged(...)
    p13.Left:OnStateChanged(...)
    p13.Customize:OnStateChanged(...)
end
function v_u_8.OnOpen(p14, ...)
    p14.Right:OnOpen(...)
    p14.Left:OnOpen(...)
    p14:_UpdateComponentsVisibility()
end
function v_u_8.Update(p15, ...)
    p15.Left:Update(...)
end
function v_u_8._UpdateComponentsVisibility(p16)
    local v17 = p16.Equipment.IsOpen and (p16.Equipment:IsOpenEffectDone() and not (p16.Equipment:IsUnlocking() or v_u_3.PageSystem.CurrentPage))
    if v17 then
        v17 = not v_u_1.MenuIsOpen
    end
    local v18 = p16.Equipment:IsCustomizing()
    local v19 = p16.Right
    local v20
    if v17 then
        v20 = not v18
    else
        v20 = v17
    end
    v19:SetVisible(v20)
    local v21 = p16.Left
    local v22
    if v17 then
        v22 = not v18
    else
        v22 = v17
    end
    v21:SetVisible(v22)
    p16.Customize:SetVisible(v17 and v18)
end
function v_u_8._Init(p_u_23)
    p_u_23.Equipment.CustomizingChanged:Connect(function()
        p_u_23:_UpdateComponentsVisibility()
    end)
    p_u_23.Equipment.UnlockingChanged:Connect(function()
        p_u_23:_UpdateComponentsVisibility()
    end)
    p_u_23.Equipment.FinishedOpenEffect:Connect(function()
        p_u_23:_UpdateComponentsVisibility()
    end)
    v_u_3.PageSystem.PagesActivity:Connect(function()
        p_u_23:_UpdateComponentsVisibility()
    end)
    v_u_1:GetPropertyChangedSignal("MenuIsOpen"):Connect(function()
        p_u_23:_UpdateComponentsVisibility()
    end)
    p_u_23:_UpdateComponentsVisibility()
end
return v_u_8