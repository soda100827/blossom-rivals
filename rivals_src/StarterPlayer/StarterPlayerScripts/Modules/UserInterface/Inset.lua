local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("GuiService")
local v_u_3 = game:GetService("Players")
require(v1.Modules.CONSTANTS)
local v_u_4 = require(v_u_3.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("MatchmadeOverlay"))
local v_u_5 = require(v_u_3.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Teleporting"))
local v_u_6 = require(v_u_3.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Equipment"))
require(v_u_3.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect"))
local v_u_7 = require(v_u_3.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Pages"))
local v_u_8 = require(script:WaitForChild("MobileEditorBar"))
local v_u_9 = require(script:WaitForChild("ContextBar"))
local v_u_10 = require(script:WaitForChild("MainBar"))
local v_u_11 = require(script:WaitForChild("Details"))
local v_u_12 = v_u_3.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("InsetGui")
local v_u_13 = {}
v_u_13.__index = v_u_13
function v_u_13._new()
    local v14 = v_u_13
    local v15 = setmetatable({}, v14)
    v15.InsetGui = v_u_12
    v15.MainFrame = v15.InsetGui:WaitForChild("MainFrame")
    v15.Container = v15.MainFrame:WaitForChild("Container")
    v15.LeftButtonsFrame = v15.Container:WaitForChild("LeftButtons")
    v15.RightButtonsFrame = v15.Container:WaitForChild("RightButtons")
    v15.Details = v_u_11.new(v15)
    v15.MobileEditorBar = v_u_8.new(v15)
    v15.ContextBar = v_u_9.new(v15)
    v15.MainBar = v_u_10.new(v15)
    v15:_Init()
    return v15
end
function v_u_13._UpdateVisibility(p16)
    local v17 = not (v_u_7.PageSystem.CurrentPage or (v_u_5.Enabled or v_u_4:IsVisible()))
    if v17 then
        v17 = not v_u_2.MenuIsOpen
    end
    local v18 = not v_u_6.IsOpen
    p16.Details:SetVisible(v17)
    local v19 = p16.MainBar
    local v20
    if v17 then
        if v18 then
            v20 = not p16.MobileEditorBar.Bar.Frame.Visible
        else
            v20 = v18
        end
    else
        v20 = v17
    end
    v19:SetVisible(v20)
    local v21 = p16.ContextBar
    local v22
    if v17 then
        v22 = not p16.MobileEditorBar.Bar.Frame.Visible
    else
        v22 = v17
    end
    v21:SetVisible(v22)
    local v23 = p16.MobileEditorBar
    if v17 then
        if v18 then
            v18 = not p16.MainBar.Bar.Frame.Visible
        end
    else
        v18 = v17
    end
    v23:SetVisible(v18)
end
function v_u_13._CheckBigInset(p24)
    p24.LeftButtonsFrame.Size = UDim2.new(1, 0, 1, -12)
    p24.LeftButtonsFrame.Position = UDim2.new(0, 12, 1, 0)
    p24.LeftButtonsFrame.AnchorPoint = Vector2.new(0, 1)
    local v25 = p24.MainFrame.AbsoluteSize.Y > 100
    p24.Container.Size = v25 and UDim2.new(0, v_u_2.TopbarInset.Width, 0, 58) or UDim2.new(1, 0, 1, 0)
    p24.Container.Position = v25 and UDim2.new(0, v_u_2.TopbarInset.Min.X, 0, 0) or UDim2.new(0, 0, 0, 0)
    p24.RightButtonsFrame.Size = p24.LeftButtonsFrame.Size
    p24.RightButtonsFrame.Position = UDim2.new(-p24.LeftButtonsFrame.Position.X.Scale, -p24.LeftButtonsFrame.Position.X.Offset, p24.LeftButtonsFrame.Position.Y.Scale, p24.LeftButtonsFrame.Position.Y.Offset)
    p24.RightButtonsFrame.AnchorPoint = p24.LeftButtonsFrame.AnchorPoint
end
function v_u_13._Setup(p26)
    p26.MainFrame.Size = UDim2.new(1, 0, 1, 0)
    p26.InsetGui.Parent = v_u_3.LocalPlayer.PlayerGui
end
function v_u_13._Init(p_u_27)
    p_u_27.MainFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        p_u_27:_CheckBigInset()
    end)
    p_u_27.MainBar.Bar.Frame:GetPropertyChangedSignal("Visible"):Connect(function()
        p_u_27:_UpdateVisibility()
    end)
    p_u_27.MobileEditorBar.Bar.Frame:GetPropertyChangedSignal("Visible"):Connect(function()
        p_u_27:_UpdateVisibility()
    end)
    v_u_2:GetPropertyChangedSignal("TopbarInset"):Connect(function()
        p_u_27:_CheckBigInset()
    end)
    v_u_6.Opened:Connect(function()
        p_u_27:_UpdateVisibility()
    end)
    v_u_5.EnabledChanged:Connect(function()
        p_u_27:_UpdateVisibility()
    end)
    v_u_7.PageSystem.PagesActivity:Connect(function()
        p_u_27:_UpdateVisibility()
    end)
    v_u_4.VisibilityChanged:Connect(function()
        p_u_27:_UpdateVisibility()
    end)
    v_u_2:GetPropertyChangedSignal("MenuIsOpen"):Connect(function()
        p_u_27:_UpdateVisibility()
    end)
    p_u_27:_Setup()
    p_u_27:_CheckBigInset()
    p_u_27:_UpdateVisibility()
end
return v_u_13._new()