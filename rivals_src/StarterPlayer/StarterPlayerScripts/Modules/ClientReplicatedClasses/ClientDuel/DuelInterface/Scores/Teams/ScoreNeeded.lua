local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.DuelLibrary)
local v_u_4 = require(v1.Modules.Utility)
local v_u_5 = require(v_u_2.LocalPlayer.PlayerScripts.Modules.TeammateSlot)
local v_u_6 = v_u_2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("DuelScoresTeammateScoreNeededSlot")
local v_u_7 = v_u_2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("DuelScoresTeamScoreNeededSlot")
local v_u_8 = v_u_2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("DuelScoresChatBubbleContainer")
local v_u_9 = {}
v_u_9.__index = v_u_9
function v_u_9.new(p10)
    local v11 = v_u_9
    local v12 = setmetatable({}, v11)
    v12.Teams = p10
    v12._connections = {}
    v12._team_slots = {}
    v12._dueler_slots = {}
    v12._bubbles_end_time = nil
    v12:_Init()
    return v12
end
function v_u_9.GetChatBubbleContainer(p13, p14)
    for v15, v16 in pairs(p13._dueler_slots) do
        if v15.Player == p14 then
            return v16.ChatBubbleContainer
        end
    end
end
function v_u_9.Generate(p_u_17)
    p_u_17:_Clear()
    if p_u_17.Teams.Scores.DuelInterface.ClientDuel:Get("ScoresBehavior") == "Teams" and p_u_17.Teams.Scores.DuelInterface.ClientDuel:Get("ScoreNeededToWin") then
        if p_u_17.Teams.Scores.DuelInterface.ClientDuel:Get("VoteOptions") then
            p_u_17._bubbles_end_time = nil
        else
            p_u_17._bubbles_end_time = p_u_17._bubbles_end_time or tick() + 12
            local v18 = tick() < p_u_17._bubbles_end_time
            local v_u_19 = {}
            for v20 = 1, p_u_17.Teams.Scores.DuelInterface.ClientDuel:Get("NumTeams") do
                local v21 = v_u_3.Teams[v20]
                local v22 = p_u_17.Teams.Scores.DuelInterface.ClientDuel.LocalDueler
                if v22 then
                    v22 = v21.TeamID == p_u_17.Teams.Scores.DuelInterface.ClientDuel.LocalDueler:Get("TeamID")
                end
                if not p_u_17.Teams.Scores.DuelInterface.ClientDuel.LocalDueler then
                    v22 = v20 % 2 == 0
                end
                local v23 = v_u_3:GetTeamColor(v21.TeamID)
                local v24 = Color3.new(v23.R * 0.5, v23.G * 0.5, v23.B * 0.5)
                local v25 = v_u_7:Clone()
                v25.Container.Bubble.Visible = v22 and v18
                v25.Container.Progress.Bar.BackgroundColor3 = v24
                v25.Container.Progress.Bar.UIStroke.Color = v24
                v25.Container.Progress.Bar.Bar.BackgroundColor3 = v23
                v25.Container.Progress.Bar.Bar.UIStroke.Color = v23
                v25.AnchorPoint = v22 and Vector2.new(1, 0) or Vector2.new(0, 0)
                v25.Container.AnchorPoint = v22 and Vector2.new(1, 0.5) or Vector2.new(0, 0.5)
                v25.Container.Position = v22 and UDim2.new(1, 0, 0.5, 0) or UDim2.new(0, 0, 0.5, 0)
                v25.Container.Progress.Position = v22 and UDim2.new(1, 0, 0.5, 0) or UDim2.new(0, 0, 0.5, 0)
                v25.Container.Progress.AnchorPoint = v22 and Vector2.new(1, 0.5) or Vector2.new(0, 0.5)
                v25.Container.Progress.Bar.Bar.Position = v22 and UDim2.new(0, -1, 0.5, 0) or UDim2.new(1, 1, 0.5, 0)
                v25.Container.Progress.Bar.Bar.AnchorPoint = v22 and Vector2.new(0, 0.5) or Vector2.new(1, 0.5)
                v25.Container.Progress.Bar.Bar.Value.AnchorPoint = v22 and Vector2.new(1, 0.5) or Vector2.new(0, 0.5)
                v25.Container.Progress.Bar.Bar.Value.Position = v22 and UDim2.new(1, 0, 0.5, 0) or UDim2.new(0, 0, 0.5, 0)
                v25.Container.Progress.Bar.Bar.Value.Title.AnchorPoint = v22 and Vector2.new(1, 0.5) or Vector2.new(0, 0.5)
                v25.Container.Progress.Bar.Bar.Value.Title.Position = v22 and UDim2.new(0.875, 0, 0.5, 0) or UDim2.new(0.125, 0, 0.5, 0)
                v25.Container.Progress.Bar.Bar.Value.Title.TextXAlignment = v22 and Enum.TextXAlignment.Right or Enum.TextXAlignment.Left
                v25.Container.Teammates.Position = v22 and UDim2.new(-7.5, 0, 1.75, 0) or UDim2.new(8.5, 0, 1.75, 0)
                v25.Container.Teammates.Layout.HorizontalAlignment = v22 and Enum.HorizontalAlignment.Left or Enum.HorizontalAlignment.Right
                v25.LayoutOrder = v20
                v25.Parent = v22 and p_u_17.Teams.LeftFrame or p_u_17.Teams.RightFrame
                p_u_17._team_slots[v20] = v25
                local v26 = v25.Container.Bubble
                table.insert(v_u_19, v26)
                local v_u_27 = v25.Container.Bubble.Container.Background
                local v_u_28 = v25.Container.Bubble.Container.Title
                v_u_28:GetPropertyChangedSignal("TextBounds"):Connect(function()
                    v_u_27.Size = UDim2.new(1.625, v_u_28.TextBounds.X, 1, 0)
                end)
                v_u_27.Size = UDim2.new(1.625, v_u_28.TextBounds.X, 1, 0)
            end
            if v18 then
                local v_u_31 = task.spawn(function()
                    while true do
                        for _, v29 in pairs(v_u_19) do
                            if v29:IsDescendantOf(v_u_2) then
                                v29:TweenPosition(UDim2.new(1, 0, 1.5, 0), "Out", "Sine", 0.5, true)
                            end
                        end
                        wait(0.5)
                        for _, v30 in pairs(v_u_19) do
                            if v30:IsDescendantOf(v_u_2) then
                                v30:TweenPosition(UDim2.new(1, 0, 1.25, 0), "In", "Sine", 0.5, true)
                            end
                        end
                        wait(0.5)
                    end
                end)
                task.delay(p_u_17._bubbles_end_time - tick(), function()
                    task.cancel(v_u_31)
                    for _, v32 in pairs(v_u_19) do
                        v32.Visible = false
                    end
                end)
            end
            local v33 = p_u_17._connections
            local v34 = p_u_17.Teams.Scores.DuelInterface.ClientDuel:GetDataChangedSignal("Scores")
            table.insert(v33, v34:Connect(function(_)
                p_u_17:_UpdateScores()
            end))
            local v35 = p_u_17._connections
            local v36 = p_u_17.Teams.Scores.DuelInterface.ClientDuel.DuelerAdded
            table.insert(v35, v36:Connect(function(p37)
                p_u_17:_AddClientDueler(p37)
            end))
            if p_u_17.Teams.Scores.DuelInterface.ClientDuel:Get("ArcadeMode") then
                local v38 = p_u_17._connections
                local v39 = p_u_17.Teams.Scores.DuelInterface.ClientDuel.DuelerRemoved
                table.insert(v38, v39:Connect(function(p40)
                    p_u_17:_RemoveClientDueler(p40)
                end))
            end
            for v41 in pairs(p_u_17.Teams.Scores.DuelInterface:GetLoggedClientDuelers()) do
                p_u_17:_AddClientDueler(v41, true)
            end
            p_u_17:_UpdateScores()
        end
    else
        return
    end
end
function v_u_9.Destroy(p42)
    p42:_Clear()
end
function v_u_9._UpdateScores(p43)
    local v44 = p43.Teams.Scores.DuelInterface.ClientDuel:Get("ScoreNeededToWin")
    local v45 = p43.Teams.Scores.DuelInterface.ClientDuel:Get("Scores")
    for v46, v47 in pairs(p43._team_slots) do
        local v48 = v45[v_u_3.Teams[v46].TeamID]
        v47.Container.Bubble.Container.Title.Text = v_u_4:PrettyNumber(v44) .. " points to win"
        v47.Container.Progress.Bar.Bar.Value.Title.Text = " " .. v_u_4:PrettyNumber(v48) .. " "
        local v49 = v47.Container.Progress.Bar.Bar
        local v50 = UDim2.new
        local v51 = v48 / v44
        v49.Size = v50(math.clamp(v51, 0.125, 1), 2, 1, 2)
    end
end
function v_u_9._RemoveClientDueler(p52, p53)
    local v54 = p52._dueler_slots[p53]
    if v54 then
        for _, v55 in pairs(v54.Connections) do
            v55:Disconnect()
        end
        v54.PlayerSlot:Destroy()
        v54.TeammateSlot:Destroy()
        p52._dueler_slots[p53] = nil
    end
end
function v_u_9._AddClientDueler(p_u_56, p_u_57)
    p_u_56:_RemoveClientDueler(p_u_57)
    local v58 = {}
    local v_u_59 = v_u_6:Clone()
    local function v63()
        local v60 = p_u_57:Get("TeamID")
        local v61 = v_u_59
        local v62
        if v60 then
            v62 = p_u_56._team_slots[v_u_3.TeamsByID[v60].TeamIndex].Container.Teammates
        else
            v62 = nil
        end
        v61.Parent = v62
    end
    local v64 = p_u_57:GetDataChangedSignal("TeamID")
    table.insert(v58, v64:Connect(v63))
    local v65 = v_u_5.new(p_u_57.Player.UserId, nil, nil, nil, true)
    v65.SlotFrame.Container.Size = UDim2.new(0.825, 0, 0.825, 0)
    v65.SlotFrame.Container.Headshot.UICorner.CornerRadius = UDim.new(1, 0)
    v65.SlotFrame.Container.Background.Visible = false
    v65.SlotFrame.Parent = v_u_59
    local v66 = v_u_8:Clone()
    v66.Size = UDim2.new(1.5, 0, 1.5, 0)
    v66.Position = UDim2.new(0.5, 0, 1.25, 0)
    v66.Parent = v65.SlotFrame
    local v67 = p_u_57:Get("TeamID")
    local v68
    if v67 then
        v68 = p_u_56._team_slots[v_u_3.TeamsByID[v67].TeamIndex].Container.Teammates
    else
        v68 = nil
    end
    v_u_59.Parent = v68
    p_u_56._dueler_slots[p_u_57] = {
        ["ClientDueler"] = p_u_57,
        ["PlayerSlot"] = v_u_59,
        ["TeammateSlot"] = v65,
        ["ChatBubbleContainer"] = v66,
        ["Connections"] = v58
    }
end
function v_u_9._Clear(p69)
    for _, v70 in pairs(p69._connections) do
        v70:Disconnect()
    end
    for _, v71 in pairs(p69._team_slots) do
        v71:Destroy()
    end
    for v72 in pairs(p69._dueler_slots) do
        p69:_RemoveClientDueler(v72)
    end
    p69._connections = {}
    p69._team_slots = {}
    p69._dueler_slots = {}
end
function v_u_9._Init(_) end
return v_u_9