local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("UserInputService")
local v_u_3 = game:GetService("StarterGui")
local v_u_4 = game:GetService("GuiService")
local v5 = game:GetService("Players")
local v_u_6 = require(v1.Modules.InputLibrary)
local v_u_7 = require(v1.Modules.Signal)
require(v5.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
local v_u_8 = require(v5.LocalPlayer.PlayerScripts.Controllers.ControlsController)
local v_u_9 = require(v5.LocalPlayer.PlayerScripts.Controllers.SpectateController)
local v_u_10 = require(v5.LocalPlayer.PlayerScripts.Controllers.FighterController)
local v_u_11 = require(v5.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("MatchmadeOverlay"))
local v_u_12 = require(v5.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("MobileButtons"))
local v_u_13 = require(v5.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Teleporting"))
local v_u_14 = require(v5.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Equipment"))
local v_u_15 = require(v5.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Pages"))
local v_u_16 = require(v5.LocalPlayer.PlayerScripts.Modules:WaitForChild("UILibrary"))
local v_u_17 = require(script:WaitForChild("Elements"))
local v_u_18 = require(script:WaitForChild("Inspect"))
local v_u_19 = {}
v_u_19.__index = v_u_19
function v_u_19._new()
    local v20 = v_u_19
    local v21 = setmetatable({}, v20)
    v21.OpenedChanged = v_u_7.new()
    v21.ClosedByInputsChanged = v_u_7.new()
    v21.BaseVisibilityChanged = v_u_7.new()
    v21.Frame = v_u_16:GetTo("PlayerList")
    v21.Container = v21.Frame:WaitForChild("Container")
    v21.IsOpen = nil
    v21.ClosedByInputs = false
    v21.Elements = v_u_17.new(v21)
    v21.Inspect = v_u_18.new(v21)
    v21._local_fighter = nil
    v21._opened_connections = {}
    v21._is_disabled = false
    v21:_Init()
    return v21
end
function v_u_19.GetBaseVisibility(p22)
    local v23 = not (v_u_12.EditorEnabled or (v_u_13.Enabled or v_u_9.CurrentDuelSubject) or (v_u_14.IsOpen or v_u_15.PageSystem.CurrentPage or (v_u_11:IsVisible() or v_u_4.MenuIsOpen)))
    if v23 then
        local v24 = p22._local_fighter
        if v24 then
            v24 = p22._local_fighter:Get("IsInShootingRange")
        end
        v23 = not v24
    end
    return v23
end
function v_u_19.SetDisabled(p25, p26)
    if p26 ~= p25._is_disabled then
        p25._is_disabled = p26
        p25:_UpdateVisibility()
    end
end
function v_u_19.SetClosedByInputs(p27, p28)
    p27.ClosedByInputs = p28
    p27.ClosedByInputsChanged:Fire()
end
function v_u_19.SelectPlayerExternally(p29, p30)
    p29.Inspect:SelectPlayer(p29.Elements:GetPlayerListSlot(p30))
end
function v_u_19.SetIsFriend(p31, p32, p33)
    for v34, v35 in pairs(p31.Elements.PlayerListSlots) do
        if v34.Player == p32 then
            v35:SetIsFriend(p33)
        end
    end
end
function v_u_19.SetIsBlocked(p36, p37, p38)
    for v39, v40 in pairs(p36.Elements.PlayerListSlots) do
        if v39.Player == p37 then
            v40:SetIsBlocked(p38)
        end
    end
end
function v_u_19.OnOpened(p_u_41)
    p_u_41:AddOpenedConnection(p_u_41.Frame.Parent:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        p_u_41:_UpdateSize()
    end))
    p_u_41:AddOpenedConnection(v_u_4:GetPropertyChangedSignal("TopbarInset"):Connect(function()
        p_u_41:_UpdatePosition()
    end))
    p_u_41:_UpdateSize()
    p_u_41:_UpdatePosition()
    p_u_41.Elements:OnOpened()
    p_u_41.Inspect:OnOpened()
end
function v_u_19.AddOpenedConnection(p42, p43)
    local v44 = p42._opened_connections
    table.insert(v44, p43)
end
function v_u_19._IsVisibleRegardlessOfInputs(p45)
    local v46 = p45:GetBaseVisibility()
    if v46 then
        v46 = not p45._is_disabled
    end
    return v46
end
function v_u_19._UpdateSize(p47)
    local v48 = p47.Frame
    local v49 = UDim2.new
    local v50 = p47.Frame.Parent.AbsoluteSize.X * 0.5
    v48.Size = v49(0, math.min(320, v50), 0.5, 0)
end
function v_u_19._UpdatePosition(p51)
    p51.Container.Position = UDim2.new(0, 0, 0, v_u_4.TopbarInset.Height)
end
function v_u_19._UpdateVisibility(p52)
    p52.BaseVisibilityChanged:Fire()
    local v53 = p52:_IsVisibleRegardlessOfInputs()
    if v53 then
        v53 = not p52.ClosedByInputs
    end
    if v53 == p52.IsOpen then
        return
    else
        p52.IsOpen = v53
        p52.OpenedChanged:Fire()
        task.defer(p52.Frame.TweenPosition, p52.Frame, p52.IsOpen and UDim2.new(1, -10, 0, 10) or UDim2.new(1, 650, 0, 10), "Out", "Quint", 0.25, true)
        if p52.IsOpen then
            p52:OnOpened()
        else
            for _, v54 in pairs(p52._opened_connections) do
                v54:Disconnect()
            end
            p52._opened_connections = {}
        end
    end
end
function v_u_19._HookLocalFighter(p_u_55)
    p_u_55._local_fighter = v_u_10:WaitForLocalFighter()
    p_u_55._local_fighter:GetDataChangedSignal("IsInShootingRange"):Connect(function()
        p_u_55:_UpdateVisibility()
    end)
    p_u_55:_UpdateVisibility()
end
function v_u_19._Init(p_u_56)
    p_u_56.ClosedByInputsChanged:Connect(function()
        p_u_56:_UpdateVisibility()
    end)
    v_u_8.ControlsChanged:Connect(function()
        p_u_56:_UpdateVisibility()
    end)
    v_u_9.DuelSubjectChanged:Connect(function()
        p_u_56:_UpdateVisibility()
    end)
    v_u_14.Opened:Connect(function()
        p_u_56:_UpdateVisibility()
    end)
    v_u_15.PageSystem.PagesActivity:Connect(function()
        p_u_56:_UpdateVisibility()
    end)
    v_u_13.EnabledChanged:Connect(function()
        p_u_56:_UpdateVisibility()
    end)
    v_u_12.EditorEnabledChanged:Connect(function()
        p_u_56:_UpdateVisibility()
    end)
    v_u_11.VisibilityChanged:Connect(function()
        p_u_56:_UpdateVisibility()
    end)
    v_u_4:GetPropertyChangedSignal("MenuIsOpen"):Connect(function()
        p_u_56:_UpdateVisibility()
    end)
    v_u_2.InputBegan:Connect(function(p57, p58)
        if not p58 and (p_u_56:_IsVisibleRegardlessOfInputs() and (v_u_6:InputIs(p57, "OpenPlayerList") and not v_u_2:IsKeyDown(Enum.KeyCode.LeftAlt))) then
            p_u_56:SetClosedByInputs(not p_u_56.ClosedByInputs)
        end
    end)
    task.spawn(function()
        v_u_3:GetCore("PlayerFriendedEvent").Event:Connect(function(p59)
            p_u_56:SetIsFriend(p59, true)
        end)
        v_u_3:GetCore("PlayerUnfriendedEvent").Event:Connect(function(p60)
            p_u_56:SetIsFriend(p60, false)
        end)
        v_u_3:GetCore("PlayerBlockedEvent").Event:Connect(function(p61)
            p_u_56:SetIsBlocked(p61, true)
        end)
        v_u_3:GetCore("PlayerUnblockedEvent").Event:Connect(function(p62)
            p_u_56:SetIsBlocked(p62, false)
        end)
    end)
    p_u_56:_UpdateSize()
    p_u_56:_UpdatePosition()
    p_u_56:_UpdateVisibility()
    task.defer(p_u_56._HookLocalFighter, p_u_56)
end
return v_u_19._new()