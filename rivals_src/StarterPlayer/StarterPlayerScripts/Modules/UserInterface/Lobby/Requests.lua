local v_u_1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v_u_1.Modules.CONSTANTS)
require(v_u_1.Modules.BetterDebris)
local v_u_4 = require(v2.LocalPlayer.PlayerScripts.Controllers:WaitForChild("ComplianceController"))
local v_u_5 = require(v2.LocalPlayer.PlayerScripts.Controllers:WaitForChild("QueuePadController"))
local v_u_6 = require(v2.LocalPlayer.PlayerScripts.Controllers:WaitForChild("FighterController"))
local v_u_7 = require(v2.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("MobileButtons"))
local v_u_8 = require(v2.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Teleporting"))
local v_u_9 = require(v2.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Equipment"))
local v_u_10 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("JoinQueuePadSlot"))
local v_u_11 = require(v2.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Queue"))
local v_u_12 = require(v2.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Pages"))
local v_u_13 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect"))
local v_u_14 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("UILibrary"))
local v_u_15 = v2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("PartyRequestSlot")
local v_u_16 = v2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("ChallengeSlot")
local v_u_17 = {}
v_u_17.__index = v_u_17
function v_u_17._new()
    local v18 = v_u_17
    local v19 = setmetatable({}, v18)
    v19.Frame = v_u_14:GetTo("MainFrame", "Lobby", "Requests")
    v19._join_queue_pad_slots = {}
    v19._is_hidden = false
    v19._num_challenge_requests = 0
    v19:_Init()
    return v19
end
function v_u_17.IsSomethingVisible(p20)
    for _, v21 in pairs(p20._join_queue_pad_slots) do
        if v21:IsVisible() then
            return true
        end
    end
    return p20._num_challenge_requests > 0
end
function v_u_17.SetHidden(p22, p23)
    p22._is_hidden = p23
    p22:_UpdateHidden()
end
function v_u_17.ChallengeRequest(p_u_24, p_u_25, p26, p27, p_u_28)
    if p_u_25 then
        local v29 = v_u_6:GetFighter(p_u_25)
        local v_u_30 = (p27 or v_u_16):Clone()
        v_u_30.Container.DisplayName.Text = v_u_4:GetName(p_u_25)
        local v31 = v_u_30.Container.DisplayName.Controls
        local v32 = v_u_3.CONTROLS_IMAGES
        if v29 then
            v29 = v29:Get("Controls")
        end
        v31.Image = v32[v29] or ""
        v_u_30.Container.Headshot.Image = string.format(v_u_3.HEADSHOT_IMAGE, p_u_25.UserId)
        v_u_30.Parent = p_u_24.Frame.Container.List
        v_u_13:Add(v_u_30.Container.Accept)
        v_u_13:Add(v_u_30.Container.Decline)
        local function v34()
            v_u_30:Destroy()
            local v33 = p_u_24
            v33._num_challenge_requests = v33._num_challenge_requests - 1
            p_u_24:_UpdateHidden()
        end
        v_u_30.Container.Decline.MouseButton1Click:Connect(v34)
        task.delay(p26, v34)
        v_u_30.Container.Accept.MouseButton1Click:Connect(function()
            if p_u_28 then
                p_u_28()
            else
                v_u_1.Remotes.Misc.AcceptChallengeRequest:FireServer(p_u_25)
            end
            v_u_30:Destroy()
            local v35 = p_u_24
            v35._num_challenge_requests = v35._num_challenge_requests - 1
            p_u_24:_UpdateHidden()
        end)
        v_u_30.Container.DisplayName:GetPropertyChangedSignal("TextBounds"):Connect(function()
            v_u_30.Container.DisplayName.Controls.Position = UDim2.new(0, v_u_30.Container.DisplayName.TextBounds.X, 0.5, 0)
        end)
        v_u_30.Container.DisplayName.Controls.Position = UDim2.new(0, v_u_30.Container.DisplayName.TextBounds.X, 0.5, 0)
        v_u_30.Container.Position = UDim2.new(4, 0, 0, 0)
        v_u_30.Container:TweenPosition(UDim2.new(0, 0, 0, 0), "Out", "Quint", 0.5, true)
        v_u_30.Container.Bar:TweenSize(UDim2.new(0, 0, 0.02, 0), "Out", "Linear", p26, true)
        p_u_24._num_challenge_requests = p_u_24._num_challenge_requests + 1
        p_u_24:_UpdateHidden()
    end
end
function v_u_17.PartyRequest(p36, p_u_37, p38)
    p36:ChallengeRequest(p_u_37, p38, v_u_15, function()
        v_u_1.Remotes.Matchmaking.AcceptPartyInvite:FireServer(p_u_37)
    end)
end
function v_u_17._UpdateHidden(p39)
    p39.Frame.Container.Hide.Visible = p39._is_hidden or p39:IsSomethingVisible()
    p39.Frame.Container.Hide.Icon.Image = p39._is_hidden and "rbxassetid://18227594779" or "rbxassetid://18227594654"
    p39.Frame.Container.List:TweenPosition(p39._is_hidden and UDim2.new(5, 0, 0.5, 0) or UDim2.new(1, 0, 0.5, 0), "Out", "Quint", 0.25, true)
end
function v_u_17._QueuePadAdded(p_u_40, p41)
    local v42 = v_u_10.new(p41)
    v42.Frame.Parent = p_u_40.Frame.Container.List
    local v43 = p_u_40._join_queue_pad_slots
    table.insert(v43, v42)
    v42.VisibilityChanged:Connect(function()
        p_u_40:_UpdateHidden()
    end)
    p_u_40:_UpdateHidden()
end
function v_u_17._UpdateVisibility(p44)
    local v45 = not (v_u_12.PageSystem.CurrentPage or v_u_9.IsOpen or (v_u_11:IsVisible() or v_u_8.Enabled))
    if v45 then
        v45 = not v_u_7.EditorEnabled
    end
    p44.Frame.Container:TweenPosition(v45 and UDim2.new(1, 0, 0.9, -20) or UDim2.new(1.5, 0, 0.9, -20), "Out", "Quint", 0.25, true)
end
function v_u_17._Init(p_u_46)
    p_u_46.Frame.Container.Hide.MouseButton1Click:Connect(function()
        p_u_46:SetHidden(not p_u_46._is_hidden)
    end)
    v_u_9.Opened:Connect(function()
        p_u_46:_UpdateVisibility()
    end)
    v_u_12.PageSystem.PageOpened:Connect(function()
        p_u_46:_UpdateVisibility()
    end)
    v_u_12.PageSystem.PageClosed:Connect(function()
        p_u_46:_UpdateVisibility()
    end)
    v_u_11.VisibilityChanged:Connect(function()
        p_u_46:_UpdateVisibility()
    end)
    v_u_8.EnabledChanged:Connect(function()
        p_u_46:_UpdateVisibility()
    end)
    v_u_7.EditorEnabledChanged:Connect(function()
        p_u_46:_UpdateVisibility()
    end)
    v_u_5.ObjectAdded:Connect(function(p47)
        p_u_46:_QueuePadAdded(p47)
    end)
    for _, v48 in pairs(v_u_5.Objects) do
        task.defer(p_u_46._QueuePadAdded, p_u_46, v48)
    end
    p_u_46:_UpdateHidden()
    p_u_46:_UpdateVisibility()
    v_u_13:Add(p_u_46.Frame.Container.Hide)
end
return v_u_17._new()