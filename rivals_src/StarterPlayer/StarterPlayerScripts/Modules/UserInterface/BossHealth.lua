local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("CollectionService")
local v_u_3 = game:GetService("TweenService")
local v_u_4 = game:GetService("Players")
local v_u_5 = require(v1.Modules.Signal)
local v_u_6 = require(v_u_4.LocalPlayer.PlayerScripts.Controllers.SpectateController)
local v_u_7 = require(v_u_4.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Lobby"):WaitForChild("Matchmaking"))
local v_u_8 = require(v_u_4.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("MobileButtons"))
local v_u_9 = require(v_u_4.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Teleporting"))
local v_u_10 = require(v_u_4.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Equipment"))
local v_u_11 = require(v_u_4.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Queue"))
local v_u_12 = require(v_u_4.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Pages"))
local v_u_13 = require(v_u_4.LocalPlayer.PlayerScripts.Modules:WaitForChild("UILibrary"))
local v_u_14 = v_u_4.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("BossHealthBar")
local v_u_15 = {}
v_u_15.__index = v_u_15
function v_u_15._new()
    local v16 = v_u_15
    local v17 = setmetatable({}, v16)
    v17.Frame = v_u_13:GetTo("MainFrame", "BossHealth")
    v17.Container = v17.Frame:WaitForChild("Container")
    v17._duel_subject_connections = {}
    v17._boss_health_bars = {}
    v17._last_changed_health_bar_frame = nil
    v17._update_health_bar_internal = v_u_5.new()
    v17:_Init()
    return v17
end
function v_u_15._UpdateVisibility(p18)
    local v19 = v_u_6.CurrentDuelSubject
    if v19 then
        v19 = v_u_6.CurrentDuelSubject.DuelInterface.Voting:IsOpen()
    end
    local v20 = p18.Frame
    local v21 = not (v19 or v_u_12.PageSystem.CurrentPage or (v_u_10.IsOpen or v_u_11:IsVisible() or (v_u_9.Enabled or v_u_8.EditorEnabled)))
    if v21 then
        v21 = not v_u_7:IsVisible()
    end
    v20.Visible = v21
end
function v_u_15._DuelSubjectChanged(p_u_22)
    for _, v23 in pairs(p_u_22._duel_subject_connections) do
        v23:Disconnect()
    end
    p_u_22._duel_subject_connections = {}
    p_u_22:_UpdateVisibility()
    if v_u_6.CurrentDuelSubject then
        local v24 = p_u_22._duel_subject_connections
        local v25 = v_u_6.CurrentDuelSubject.DuelInterface.Voting.VisibilityChanged
        table.insert(v24, v25:Connect(function()
            p_u_22:_UpdateVisibility()
        end))
    end
end
function v_u_15._HumanoidAdded(p_u_26, p_u_27)
    p_u_26:_HumanoidRemoved(p_u_27)
    local v28 = {}
    local v29 = {}
    local v_u_30 = v_u_14:Clone()
    v_u_30.Parent = p_u_26.Container
    local function v31()
        v_u_30.Title.Text = p_u_27.Parent and p_u_27.Parent.Name or ""
        v_u_30.Title.AutoLocalize = not (p_u_27.Parent and v_u_4:GetPlayerFromCharacter(p_u_27.Parent))
    end
    local v32 = p_u_27.Parent:GetPropertyChangedSignal("Name")
    table.insert(v28, v32:Connect(v31))
    v_u_30.Title.Text = p_u_27.Parent and (p_u_27.Parent.Name or "") or ""
    v_u_30.Title.AutoLocalize = not (p_u_27.Parent and v_u_4:GetPlayerFromCharacter(p_u_27.Parent))
    local v_u_33 = false
    local function v_u_36()
        local v34 = v_u_30
        local v35 = p_u_26.Frame.Visible and (p_u_27.Health > 0 and p_u_27.RootPart)
        if v35 then
            v35 = (p_u_27.RootPart.Position - workspace.CurrentCamera.CFrame.Position).Magnitude <= 256
        end
        v34.Visible = v35
        if v_u_30.Visible and not v_u_33 then
            v_u_30.Size = UDim2.new(0, 0, 0, 0)
            v_u_30:TweenSize(v_u_14.Size, "Out", "Quint", 0.5, true)
        end
        v_u_33 = v_u_30.Visible
    end
    local v37 = p_u_26._update_health_bar_internal
    table.insert(v28, v37:Connect(v_u_36))
    local v38 = p_u_26.Frame:GetPropertyChangedSignal("Visible")
    table.insert(v28, v38:Connect(v_u_36))
    local v39 = task.defer
    table.insert(v29, v39(function()
        while true do
            v_u_36()
            wait(1)
        end
    end))
    local v_u_40 = nil
    local v_u_41 = nil
    local function v50()
        p_u_26._last_changed_health_bar_frame = v_u_30
        p_u_26._update_health_bar_internal:Fire()
        local v42 = p_u_27.MaxHealth
        local v43 = p_u_27.Health
        local v44 = v43 / v42
        local v45 = math.clamp(v44, 0, 1)
        local v46 = Color3.fromRGB(255, 50, 50):Lerp(Color3.fromRGB(255, 215, 0):Lerp(Color3.fromRGB(100, 255, 50), v45), v45)
        local v47 = Color3.new(v46.R / 2, v46.G / 2, v46.B / 2)
        v_u_30.Health.BackgroundColor3 = v47
        v_u_30.Health.UIStroke.Color = v47
        v_u_30.Health.Bar.BackgroundColor3 = v46
        v_u_30.Health.Bar.Visible = v45 > 0
        v_u_30.Health.Bar.UIStroke.Color = v46
        v_u_30.Health.Bar.Value.Title.Text = v43 > 1 and math.ceil(v43) or ""
        local v48 = v_u_40 and v45 >= v_u_40 and 0.5 or 1
        local v49 = UDim2.new(math.max(0.06, v45), 2, 1, 2)
        if v_u_41 then
            v_u_41:Pause()
        end
        v_u_41 = v_u_3:Create(v_u_30.Health.Bar, TweenInfo.new(0.5 / v48, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            ["Size"] = v49
        })
        v_u_41:Play()
        v_u_40 = v45
        v_u_36()
    end
    local v51 = p_u_27:GetPropertyChangedSignal("MaxHealth")
    table.insert(v28, v51:Connect(v50))
    local v52 = p_u_27:GetPropertyChangedSignal("Health")
    table.insert(v28, v52:Connect(v50))
    v50()
    p_u_26._boss_health_bars[p_u_27] = {
        ["Frame"] = v_u_30,
        ["Connections"] = v28,
        ["Threads"] = v29
    }
end
function v_u_15._HumanoidRemoved(p53, p54)
    local v55 = p53._boss_health_bars[p54]
    if v55 then
        v55.Frame:Destroy()
        for _, v56 in pairs(v55.Connections) do
            v56:Disconnect()
        end
        for _, v57 in pairs(v55.Threads) do
            task.cancel(v57)
        end
        p53._boss_health_bars[p54] = nil
    end
end
function v_u_15._Init(p_u_58)
    v_u_10.Opened:Connect(function()
        p_u_58:_UpdateVisibility()
    end)
    v_u_12.PageSystem.PageOpened:Connect(function()
        p_u_58:_UpdateVisibility()
    end)
    v_u_12.PageSystem.PageClosed:Connect(function()
        p_u_58:_UpdateVisibility()
    end)
    v_u_11.VisibilityChanged:Connect(function()
        p_u_58:_UpdateVisibility()
    end)
    v_u_7.VisibilityChanged:Connect(function()
        p_u_58:_UpdateVisibility()
    end)
    v_u_9.EnabledChanged:Connect(function()
        p_u_58:_UpdateVisibility()
    end)
    v_u_8.EditorEnabledChanged:Connect(function()
        p_u_58:_UpdateVisibility()
    end)
    v_u_6.DuelSubjectChanged:Connect(function()
        p_u_58:_DuelSubjectChanged()
    end)
    v_u_2:GetInstanceAddedSignal("BossHealthBar"):Connect(function(p59)
        p_u_58:_HumanoidAdded(p59)
    end)
    for _, v60 in pairs(v_u_2:GetTagged("BossHealthBar")) do
        task.defer(p_u_58._HumanoidAdded, p_u_58, v60)
    end
    p_u_58:_UpdateVisibility()
    task.defer(p_u_58._DuelSubjectChanged, p_u_58)
end
return v_u_15._new()