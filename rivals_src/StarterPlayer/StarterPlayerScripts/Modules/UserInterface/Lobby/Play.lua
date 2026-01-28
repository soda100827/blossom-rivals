local v_u_1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("GuiService")
local v_u_3 = game:GetService("Players")
local v_u_4 = require(v_u_1.Modules.CONSTANTS)
require(v_u_1.Modules.InputLibrary)
local v_u_5 = require(v_u_3.LocalPlayer.PlayerScripts.Controllers:WaitForChild("MatchmakingController"))
local v_u_6 = require(v_u_3.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController"))
require(v_u_3.LocalPlayer.PlayerScripts.Controllers:WaitForChild("FighterController"))
local v_u_7 = require(v_u_3.LocalPlayer.PlayerScripts.Controllers:WaitForChild("ArcadeController"))
local v_u_8 = require(v_u_3.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Lobby"):WaitForChild("Matchmaking"))
local v_u_9 = require(v_u_3.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("MobileButtons"))
local v_u_10 = require(v_u_3.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Teleporting"))
local v_u_11 = require(v_u_3.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Equipment"))
local v_u_12 = require(v_u_3.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Queue"))
local v_u_13 = require(v_u_3.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Pages"))
local v_u_14 = require(v_u_3.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect"))
local v_u_15 = require(v_u_3.LocalPlayer.PlayerScripts.Modules:WaitForChild("UILibrary"))
local v_u_16 = {}
v_u_16.__index = v_u_16
function v_u_16._new()
    local v17 = v_u_16
    local v18 = setmetatable({}, v17)
    v18.Frame = v_u_15:GetTo("MainFrame", "Lobby", "Play")
    v18.HubButton = v18.Frame:WaitForChild("Hub")
    v18.PlayButton = v18.Frame:WaitForChild("Play")
    v18.PlayButtonOffFrame = v18.PlayButton:WaitForChild("Off")
    v18.PlayButtonOffJoinText = v18.PlayButtonOffFrame:WaitForChild("Title")
    v18.PlayButtonJoinFrame = v18.PlayButton:WaitForChild("Join")
    v18.PlayButtonJoinText = v18.PlayButtonJoinFrame:WaitForChild("Title")
    v18.PlayButtonJoinBubble = v18.PlayButtonJoinFrame:WaitForChild("Bubble")
    v18.RematchButton = v18.Frame:WaitForChild("Rematch")
    v18.RematchCountText = v18.RematchButton:WaitForChild("Count")
    v18.IsHubVisible = false
    v18.IsPlayVisible = false
    v18.IsRematchVisible = false
    v18._bubble_effect = 0
    v18:_Init()
    return v18
end
function v_u_16.GoBackToHub(_)
    v_u_1.Remotes.Matchmaking.BackToHub:FireServer()
end
function v_u_16.RematchRequest(_)
    v_u_1.Remotes.Duels.Rematch:FireServer()
end
function v_u_16.OpenPlayPage(_)
    if v_u_4.IS_ARCADE_SERVER or v_u_7.CurrentDuel then
        v_u_7:Join()
        return
    elseif v_u_6:GetStatistic("StatisticDuelsPlayed") <= 1 and (v_u_6:GetStatistic("StatisticDuelsWon") < v_u_4.BEGINNER_QUEUE_WINS and not v_u_5.CurrentParty) then
        v_u_5:QueueInto(v_u_4.BEGINNER_QUEUE_NAME)
    else
        v_u_13.PageSystem:OpenPage("Matchmaking", true)
    end
end
function v_u_16._UpdateRematchButton(p19)
    local v20 = v_u_5:Get("MatchmadeRematchSuccess")
    local v21 = v_u_5:Get("MatchmadeRematchCount")
    local v22 = v_u_5:Get("MatchmadeRematchGoal")
    local v23 = v_u_5:IsRematchAvailable()
    p19.RematchCountText.Text = v20 and "\226\128\162 \226\128\162 \226\128\162" or (v23 and v21 .. " / " .. v22 or "Unavailable")
end
function v_u_16._BubbleEffect(p24)
    p24._bubble_effect = p24._bubble_effect + 1
    local v25 = p24._bubble_effect
    if p24.Frame.Visible and (p24.PlayButtonJoinFrame.Visible and p24.PlayButtonJoinBubble.Visible) then
        while v25 == p24._bubble_effect do
            if p24.PlayButtonJoinBubble:IsDescendantOf(v_u_3) then
                p24.PlayButtonJoinBubble:TweenPosition(UDim2.new(0.5, 0, -0.5, 0), "Out", "Sine", 0.5, true)
            end
            wait(0.5)
            if v25 ~= p24._bubble_effect then
                return
            end
            if p24.PlayButtonJoinBubble:IsDescendantOf(v_u_3) then
                p24.PlayButtonJoinBubble:TweenPosition(UDim2.new(0.5, 0, -0.2, 0), "In", "Sine", 0.5, true)
            end
            wait(0.5)
        end
    end
end
function v_u_16._UpdatePlayButton(p26)
    if v_u_4.IS_ARCADE_SERVER or v_u_7.CurrentDuel then
        local v27 = v_u_7:GetJoinCooldown()
        local v28 = v_u_7.CurrentDuel
        if v28 then
            if v_u_7.CurrentDuel:Get("Status") == "GameOver" then
                v28 = false
            else
                v28 = v27 <= 0
            end
        end
        p26.PlayButtonJoinBubble.Visible = false
        p26.PlayButtonOffJoinText.Text = v27 > 0 and v27 and v27 or "Join"
        p26.PlayButtonJoinFrame.Visible = v28
        p26.PlayButtonOffFrame.Visible = not v28
    else
        p26.PlayButtonJoinBubble.Visible = v_u_6:GetStatistic("StatisticDuelsPlayed") <= 3
        p26.PlayButtonJoinText.Text = "Play"
        p26.PlayButtonJoinFrame.Visible = true
        p26.PlayButtonOffFrame.Visible = false
    end
    task.spawn(p26._BubbleEffect, p26)
end
function v_u_16._UpdateVisibility(p29)
    local v30 = not (v_u_13.PageSystem.CurrentPage or v_u_11.IsOpen or (v_u_12:IsVisible() or v_u_8:IsVisible() or (v_u_10.Enabled or v_u_9.EditorEnabled)))
    if v30 then
        v30 = not v_u_2.MenuIsOpen
    end
    local v31 = v30 and (v_u_4.IS_ARCADE_SERVER or v_u_5:IsMatchmadeDuelOver())
    if v31 then
        v31 = v_u_5:IsPartyLeader()
    end
    p29.IsHubVisible = v31
    local v32
    if v30 then
        v32 = v_u_4.QUEUES_ACTIVE or v_u_4.IS_ARCADE_SERVER or (v_u_7.CurrentDuel or v_u_5:IsMatchmadeDuelOver())
    else
        v32 = v30
    end
    p29.IsPlayVisible = v32
    if v30 then
        v30 = v_u_5:IsRematchAvailable()
    end
    p29.IsRematchVisible = v30
    p29.HubButton:TweenPosition(p29.IsHubVisible and UDim2.new(-3.5, 0, 0.5, 0) or UDim2.new(-3.5, 0, 7, 0), "Out", "Quint", 0.25, true)
    p29.PlayButton:TweenPosition(p29.IsPlayVisible and UDim2.new(0.5, 0, 0.5, 0) or UDim2.new(0.5, 0, 7, 0), "Out", "Quint", 0.25, true)
    p29.RematchButton:TweenPosition(p29.IsRematchVisible and UDim2.new(4.5, 0, 0.5, 0) or UDim2.new(4.5, 0, 7, 0), "Out", "Quint", 0.25, true)
end
function v_u_16._Init(p_u_33)
    p_u_33.PlayButton.MouseButton1Click:Connect(function()
        p_u_33:OpenPlayPage()
    end)
    p_u_33.HubButton.MouseButton1Click:Connect(function()
        p_u_33:GoBackToHub()
    end)
    p_u_33.RematchButton.MouseButton1Click:Connect(function()
        p_u_33:RematchRequest()
    end)
    p_u_33.Frame:GetPropertyChangedSignal("Visible"):Connect(function()
        p_u_33:_UpdatePlayButton()
    end)
    v_u_5.PartyChanged:Connect(function()
        p_u_33:_UpdateVisibility()
    end)
    v_u_5.MatchmadeDuelEnded:Connect(function()
        p_u_33:_UpdateVisibility()
    end)
    v_u_5.RematchDetailsChanged:Connect(function()
        p_u_33:_UpdateVisibility()
        p_u_33:_UpdateRematchButton()
    end)
    v_u_11.Opened:Connect(function()
        p_u_33:_UpdateVisibility()
    end)
    v_u_13.PageSystem.PageOpened:Connect(function()
        p_u_33:_UpdateVisibility()
    end)
    v_u_13.PageSystem.PageClosed:Connect(function()
        p_u_33:_UpdateVisibility()
    end)
    v_u_12.VisibilityChanged:Connect(function()
        p_u_33:_UpdateVisibility()
    end)
    v_u_8.VisibilityChanged:Connect(function()
        p_u_33:_UpdateVisibility()
    end)
    v_u_10.EnabledChanged:Connect(function()
        p_u_33:_UpdateVisibility()
    end)
    v_u_9.EditorEnabledChanged:Connect(function()
        p_u_33:_UpdateVisibility()
    end)
    v_u_6:GetDataChangedSignal("StatisticDuelsPlayed"):Connect(function()
        p_u_33:_UpdatePlayButton()
    end)
    v_u_7.DuelSet:Connect(function(_)
        p_u_33:_UpdateVisibility()
        p_u_33:_UpdatePlayButton()
    end)
    v_u_7.UpdateJoinCooldown:Connect(function()
        p_u_33:_UpdatePlayButton()
    end)
    v_u_2:GetPropertyChangedSignal("MenuIsOpen"):Connect(function()
        p_u_33:_UpdateVisibility()
    end)
    if v_u_7.CurrentDuel then
        task.defer(p_u_33._ArcadeDuelAdded, p_u_33, v_u_7.CurrentDuel)
    end
    p_u_33:_UpdatePlayButton()
    p_u_33:_UpdateVisibility()
    v_u_14:Add(p_u_33.HubButton)
    v_u_14:Add(p_u_33.PlayButton)
    v_u_14:Add(p_u_33.RematchButton)
end
return v_u_16._new()