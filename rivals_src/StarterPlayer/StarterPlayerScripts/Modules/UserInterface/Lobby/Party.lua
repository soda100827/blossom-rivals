local v_u_1 = game:GetService("TweenService")
local v_u_2 = game:GetService("GuiService")
local v3 = game:GetService("Players")
local v_u_4 = require(v3.LocalPlayer.PlayerScripts.Controllers:WaitForChild("MatchmakingController"))
local v_u_5 = require(v3.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Lobby"):WaitForChild("Matchmaking"))
local v_u_6 = require(v3.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("MobileButtons"))
local v_u_7 = require(v3.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Teleporting"))
local v_u_8 = require(v3.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Equipment"))
local v_u_9 = require(v3.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Queue"))
local v_u_10 = require(v3.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Pages"))
local v_u_11 = require(v3.LocalPlayer.PlayerScripts.Modules:WaitForChild("PartyDisplay"))
local v_u_12 = require(v3.LocalPlayer.PlayerScripts.Modules:WaitForChild("UILibrary"))
local v_u_13 = {}
v_u_13.__index = v_u_13
function v_u_13._new()
    local v14 = v_u_13
    local v15 = setmetatable({}, v14)
    v15.IsVisible = false
    v15.Frame = v_u_12:GetTo("MainFrame", "Lobby", "Party")
    v15.BottomDisplayFrame = v15.Frame:WaitForChild("BottomDisplay")
    v15.BottomDisplayContainer = v15.BottomDisplayFrame:WaitForChild("Container")
    v15.BottomDisplayLayout = v15.BottomDisplayContainer:WaitForChild("Layout")
    v15.BottomPartyDisplay = v_u_11.new(v15.BottomDisplayContainer)
    v15._last_tween = nil
    v15:_Init()
    return v15
end
function v_u_13._UpdateVisibility(p16)
    if p16._last_tween then
        p16._last_tween:Pause()
        p16._last_tween = nil
    end
    local v17 = not (v_u_10.PageSystem.CurrentPage or (v_u_8.IsOpen or v_u_9:IsVisible() or (v_u_7.Enabled or v_u_6.EditorEnabled)))
    if v17 then
        v17 = not v_u_2.MenuIsOpen
    end
    local v18 = v_u_5:IsVisible()
    local v19 = v_u_4:IsRematchAvailable()
    local v20
    if v18 then
        v20 = Enum.HorizontalAlignment.Center
    else
        v20 = Enum.HorizontalAlignment.Left
    end
    local v21
    if v18 then
        v21 = Vector2.new(0.5, 0.5)
    else
        v21 = Vector2.new(0, 0)
    end
    local v22
    if v18 and v17 then
        v22 = UDim2.new(0.5, 0, 0.5, 0)
    elseif v18 and not v17 then
        v22 = UDim2.new(0.5, 0, 7, 0)
    elseif v17 and v19 then
        v22 = UDim2.new(2.75, 0, -1.25, 0)
    elseif v17 then
        v22 = UDim2.new(2.75, 0, 0, 0)
    else
        v22 = UDim2.new(2.75, 0, 7, 0)
    end
    p16.IsVisible = v17
    p16.BottomDisplayLayout.HorizontalAlignment = v20
    p16._last_tween = v_u_1:Create(p16.BottomDisplayContainer, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        ["Position"] = v22,
        ["AnchorPoint"] = v21
    })
    p16._last_tween:Play()
end
function v_u_13._Init(p_u_23)
    v_u_8.Opened:Connect(function()
        p_u_23:_UpdateVisibility()
    end)
    v_u_10.PageSystem.PageOpened:Connect(function()
        p_u_23:_UpdateVisibility()
    end)
    v_u_10.PageSystem.PageClosed:Connect(function()
        p_u_23:_UpdateVisibility()
    end)
    v_u_9.VisibilityChanged:Connect(function()
        p_u_23:_UpdateVisibility()
    end)
    v_u_5.VisibilityChanged:Connect(function()
        p_u_23:_UpdateVisibility()
    end)
    v_u_7.EnabledChanged:Connect(function()
        p_u_23:_UpdateVisibility()
    end)
    v_u_6.EditorEnabledChanged:Connect(function()
        p_u_23:_UpdateVisibility()
    end)
    v_u_4.RematchDetailsChanged:Connect(function()
        p_u_23:_UpdateVisibility()
    end)
    v_u_2:GetPropertyChangedSignal("MenuIsOpen"):Connect(function()
        p_u_23:_UpdateVisibility()
    end)
    p_u_23:_UpdateVisibility()
end
return v_u_13._new()