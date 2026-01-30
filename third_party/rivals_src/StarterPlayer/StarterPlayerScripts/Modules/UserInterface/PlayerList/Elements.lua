local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("Players")
local v3 = require(v1.Modules.SettingsLibrary)
local v_u_4 = require(v1.Modules.Signal)
local v_u_5 = require(v_u_2.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
local v_u_6 = require(v_u_2.LocalPlayer.PlayerScripts.Controllers.SettingsController)
local v_u_7 = require(v_u_2.LocalPlayer.PlayerScripts.Controllers.FighterController)
local v_u_8 = require(v_u_2.LocalPlayer.PlayerScripts.Modules.PlayerListSlot)
local v_u_9 = require(v_u_2.LocalPlayer.PlayerScripts.Modules.ButtonEffect)
local v_u_10 = v3.Info["Settings PlayerList Leaderstat"].Options
local v_u_11 = { "rbxassetid://17094014569", "rbxassetid://18270680538", "rbxassetid://117835427046796" }
local v_u_12 = {}
v_u_12.__index = v_u_12
function v_u_12.new(p13)
    local v14 = v_u_12
    local v15 = setmetatable({}, v14)
    v15.PlayerListSlotAdded = v_u_4.new()
    v15.PlayerListSlotRemoved = v_u_4.new()
    v15.PlayerList = p13
    v15.Frame = v15.PlayerList.Container:WaitForChild("Elements")
    v15.Container = v15.Frame:WaitForChild("Container")
    v15.Layout = v15.Container:WaitForChild("Layout")
    v15.TopFrame = v15.Container:WaitForChild("Top")
    v15.TopCloseButton = v15.TopFrame:WaitForChild("Close")
    v15.TopLeaderstatFrame = v15.TopFrame:WaitForChild("Leaderstat")
    v15.TopLeaderstatIcon = v15.TopLeaderstatFrame:WaitForChild("Icon")
    v15.TopLeaderstatButton = v15.TopLeaderstatFrame:WaitForChild("Button")
    v15.MiddleFrame = v15.Container:WaitForChild("Middle")
    v15.MiddleList = v15.MiddleFrame:WaitForChild("List")
    v15.MiddleContainer = v15.MiddleList:WaitForChild("Container")
    v15.MiddleLayout = v15.MiddleContainer:WaitForChild("Layout")
    v15.BottomFrame = v15.Container:WaitForChild("Bottom")
    v15.PlayerListSlots = {}
    v15._leaderstat_name = nil
    v15:_Init()
    return v15
end
function v_u_12.GetPlayerListSlot(p16, p17)
    for v18, v19 in pairs(p16.PlayerListSlots) do
        if v18.Player == p17 then
            return v19
        end
    end
end
function v_u_12.SetLeaderstat(p20, p21)
    if p21 ~= p20._leaderstat_name then
        p20._leaderstat_name = p21
        p20.TopLeaderstatIcon.Image = v_u_11[table.find(v_u_10, p20._leaderstat_name)] or ""
        for _, v22 in pairs(p20.PlayerListSlots) do
            v22:SetLeaderstat(p20._leaderstat_name)
        end
    end
end
function v_u_12.OnOpened(p_u_23)
    p_u_23.PlayerList:AddOpenedConnection(p_u_23.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p_u_23:_UpdateVisuals()
    end))
    p_u_23.PlayerList:AddOpenedConnection(p_u_23.MiddleLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p_u_23:_UpdateVisuals()
    end))
    p_u_23.PlayerList:AddOpenedConnection(p_u_23.PlayerList.Frame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        p_u_23:_UpdateVisuals()
    end))
    p_u_23.PlayerList:AddOpenedConnection(p_u_23.BottomFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        p_u_23:_UpdateVisuals()
    end))
    p_u_23.PlayerList:AddOpenedConnection(p_u_23.TopFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        p_u_23:_UpdateVisuals()
    end))
    p_u_23.PlayerList:AddOpenedConnection(v_u_5:GetDataChangedSignal("Settings PlayerList Leaderstat"):Connect(function()
        p_u_23:_UpdateLeaderstatFromSetting()
    end))
    p_u_23.PlayerList:AddOpenedConnection(v_u_7.ObjectRemoved:Connect(function(p24)
        p_u_23:_FighterRemoved(p24)
    end))
    p_u_23.PlayerList:AddOpenedConnection(v_u_7.ObjectAdded:Connect(function(p25)
        p_u_23:_FighterAdded(p25)
    end))
    p_u_23:_UpdateVisuals()
    p_u_23:_UpdateLeaderstatFromSetting()
    for v26, v27 in pairs(p_u_23.PlayerListSlots) do
        if v26.Player:IsDescendantOf(v_u_2) then
            v27:OnOpened()
        else
            task.spawn(p_u_23._FighterRemoved, p_u_23, v26)
        end
    end
    for _, v28 in pairs(v_u_7.Objects) do
        if not p_u_23.PlayerListSlots[v28] then
            task.spawn(p_u_23._FighterAdded, p_u_23, v28)
        end
    end
end
function v_u_12._UpdateLeaderstatFromSetting(p29)
    local v30 = v_u_5:Get("Settings PlayerList Leaderstat")
    if not table.find(v_u_10, v30) then
        v30 = v_u_10[1]
    end
    p29:SetLeaderstat(v30)
end
function v_u_12._UpdateVisuals(p31)
    p31.MiddleList.CanvasSize = UDim2.new(0, 0, 0, p31.MiddleLayout.AbsoluteContentSize.Y)
    local v32 = p31.MiddleFrame
    local v33 = UDim2.new
    local v34 = p31.MiddleLayout.AbsoluteContentSize.Y
    local v35 = p31.PlayerList.Frame.AbsoluteSize.Y - p31.TopFrame.AbsoluteSize.Y - p31.BottomFrame.AbsoluteSize.Y
    v32.Size = v33(1, 0, 0, (math.min(v34, v35)))
    p31.Frame.Size = UDim2.new(1, 0, 0, p31.Layout.AbsoluteContentSize.Y)
end
function v_u_12._FighterRemoved(p36, p37)
    local v38 = p36.PlayerListSlots[p37]
    if v38 then
        v38:Destroy()
        p36.PlayerListSlots[p37] = nil
        p36.PlayerListSlotRemoved:Fire(v38)
    end
end
function v_u_12._FighterAdded(p39, p40)
    p39:_FighterRemoved(p40)
    if p40.Player then
        local v41 = v_u_8.new(p39, p40)
        v41:SetLeaderstat(p39._leaderstat_name)
        v41:SetParent(p39.MiddleContainer)
        p39.PlayerListSlots[p40] = v41
        p39.PlayerListSlotAdded:Fire(v41)
    end
end
function v_u_12._Init(p_u_42)
    p_u_42.TopCloseButton.MouseButton1Click:Connect(function()
        p_u_42.PlayerList:SetClosedByInputs(true)
    end)
    p_u_42.TopLeaderstatButton.MouseButton1Click:Connect(function()
        local v43 = v_u_10[(table.find(v_u_10, p_u_42._leaderstat_name) or 0) % #v_u_10 + 1]
        v_u_6:ChangeSetting("Settings PlayerList Leaderstat", v43)
        p_u_42:SetLeaderstat(v43)
    end)
    v_u_9:Add(p_u_42.TopCloseButton, true)
    v_u_9:Add(p_u_42.TopLeaderstatButton, true)
end
return v_u_12