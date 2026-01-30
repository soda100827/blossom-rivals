local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.DuelLibrary)
local v_u_4 = require(v2.LocalPlayer.PlayerScripts.Modules.TeammateSlot)
local v_u_5 = v2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("DuelScoresChatBubbleContainer")
local v_u_6 = v2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("DuelScoresTeamSlot")
local v_u_7 = {}
v_u_7.__index = v_u_7
function v_u_7.new(p8)
    local v9 = v_u_7
    local v10 = setmetatable({}, v9)
    v10.Teams = p8
    v10._connections = {}
    v10._team_slots = {}
    v10._dueler_slots = {}
    v10:_Init()
    return v10
end
function v_u_7.GetChatBubbleContainer(p11, p12)
    for v13, v14 in pairs(p11._dueler_slots) do
        if v13.Player == p12 then
            return v14.ChatBubbleContainer
        end
    end
end
function v_u_7.Generate(p_u_15)
    p_u_15:_Clear()
    if p_u_15.Teams.Scores.DuelInterface.ClientDuel:Get("ScoresBehavior") == "Teams" and not p_u_15.Teams.Scores.DuelInterface.ClientDuel:Get("ScoreNeededToWin") then
        for v16 = 1, p_u_15.Teams.Scores.DuelInterface.ClientDuel:Get("NumTeams") do
            local v17 = v_u_3.Teams[v16]
            local v18 = p_u_15.Teams.Scores.DuelInterface.ClientDuel.LocalDueler
            if v18 then
                v18 = v17.TeamID == p_u_15.Teams.Scores.DuelInterface.ClientDuel.LocalDueler:Get("TeamID")
            end
            if not p_u_15.Teams.Scores.DuelInterface.ClientDuel.LocalDueler then
                v18 = v16 % 2 == 0
            end
            local v_u_19 = v_u_6:Clone()
            v_u_19.Background.ImageColor3 = v_u_3:GetTeamColor(v17.TeamID)
            v_u_19.Container.Position = v18 and UDim2.new(1, 0, 0.5, 0) or UDim2.new(0, 0, 0.5, 0)
            v_u_19.Container.AnchorPoint = v18 and Vector2.new(1, 0.5) or Vector2.new(0, 0.5)
            v_u_19.Container.Teammates.Position = v18 and UDim2.new(0, 0, 0.5, 0) or UDim2.new(1, 0, 0.5, 0)
            v_u_19.Container.Teammates.AnchorPoint = v18 and Vector2.new(0, 0.5) or Vector2.new(1, 0.5)
            v_u_19.Container.Score.Position = v18 and UDim2.new(1, 0, 0.5, 0) or UDim2.new(0, 0, 0.5, 0)
            v_u_19.Container.Score.AnchorPoint = v18 and Vector2.new(1, 0.5) or Vector2.new(0, 0.5)
            v_u_19.Container.Teammates.Layout.HorizontalAlignment = v18 and Enum.HorizontalAlignment.Right or Enum.HorizontalAlignment.Left
            v_u_19.LayoutOrder = v16
            v_u_19.Parent = v18 and p_u_15.Teams.LeftFrame or p_u_15.Teams.RightFrame
            p_u_15._team_slots[v16] = v_u_19
            local v_u_20 = v_u_19.Container.Score
            local v_u_21 = v_u_19.Container.Teammates.Layout
            local function v22()
                v_u_19.Size = UDim2.new(0, v_u_21.AbsoluteContentSize.X + v_u_20.AbsoluteSize.X, 1, 0)
            end
            v_u_21:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(v22)
            v_u_20:GetPropertyChangedSignal("AbsoluteSize"):Connect(v22)
            v_u_19.Size = UDim2.new(0, v_u_21.AbsoluteContentSize.X + v_u_20.AbsoluteSize.X, 1, 0)
        end
        local v23 = p_u_15._connections
        local v24 = p_u_15.Teams.Scores.DuelInterface.ClientDuel:GetDataChangedSignal("Scores")
        table.insert(v23, v24:Connect(function(_)
            p_u_15:_UpdateScores()
        end))
        local v25 = p_u_15._connections
        local v26 = p_u_15.Teams.Scores.DuelInterface.ClientDuel.DuelerAdded
        table.insert(v25, v26:Connect(function(p27)
            p_u_15:_AddClientDueler(p27)
        end))
        if p_u_15.Teams.Scores.DuelInterface.ClientDuel:Get("ArcadeMode") then
            local v28 = p_u_15._connections
            local v29 = p_u_15.Teams.Scores.DuelInterface.ClientDuel.DuelerRemoved
            table.insert(v28, v29:Connect(function(p30)
                p_u_15:_RemoveClientDueler(p30)
            end))
        end
        for v31 in pairs(p_u_15.Teams.Scores.DuelInterface:GetLoggedClientDuelers()) do
            p_u_15:_AddClientDueler(v31, true)
        end
        p_u_15:_UpdateScores()
    end
end
function v_u_7.Destroy(p32)
    p32:_Clear()
end
function v_u_7._UpdateScores(p33)
    local v34 = p33.Teams.Scores.DuelInterface.ClientDuel:Get("Scores")
    for v35, v36 in pairs(p33._team_slots) do
        v36.Container.Score.Text = v34[v_u_3.Teams[v35].TeamID]
    end
end
function v_u_7._RemoveClientDueler(p37, p38)
    local v39 = p37._dueler_slots[p38]
    if v39 then
        for _, v40 in pairs(v39.Connections) do
            v40:Disconnect()
        end
        v39.TeammateSlot:Destroy()
        p37._dueler_slots[p38] = nil
    end
end
function v_u_7._AddClientDueler(p_u_41, p_u_42)
    p_u_41:_RemoveClientDueler(p_u_42)
    local v43 = {}
    local v_u_44 = v_u_4.new(p_u_42.Player.UserId)
    v_u_44.SlotFrame.Container.Background.Visible = false
    local function v53()
        local v45 = p_u_41.Teams.Scores.DuelInterface.ClientDuel:Get("Status")
        local v46 = p_u_42:Get("TeamID")
        local v47 = p_u_41.Teams.Scores.DuelInterface.ClientDuel.LocalDueler
        if v47 then
            v47 = v46 == p_u_41.Teams.Scores.DuelInterface.ClientDuel.LocalDueler:Get("TeamID")
        end
        local v48 = p_u_42.ClientFighter:Get("Controls")
        local v49 = p_u_42:GetHealth() / p_u_42:GetMaxHealth()
        local v50 = not table.find(p_u_41.Teams.Scores.DuelInterface.ClientDuel.Duelers, p_u_42)
        local v51 = p_u_41.Teams.Scores.DuelInterface.ClientDuel.LocalDueler and not v47
        if v51 then
            if v45 == "RoundFinished" then
                v51 = false
            else
                v51 = v45 ~= "GameOver"
            end
        end
        local v52
        if p_u_41.Teams.Scores.DuelInterface.ClientDuel.IsRanked then
            v52 = nil
        else
            v52 = p_u_42.Player:GetAttribute("Level")
        end
        v_u_44:SetDetails(v48, v49, v50, v51, nil, v52)
    end
    local v54 = p_u_41.Teams.Scores.DuelInterface.ClientDuel:GetDataChangedSignal("Status")
    table.insert(v43, v54:Connect(v53))
    local v55 = p_u_42.ClientFighter:GetDataChangedSignal("Controls")
    table.insert(v43, v55:Connect(v53))
    local v56 = p_u_42.Player:GetAttributeChangedSignal("Level")
    table.insert(v43, v56:Connect(v53))
    local v57 = p_u_41.Teams.Scores.DuelInterface.ClientDuel.DuelerRemoved
    table.insert(v43, v57:Connect(v53))
    local v58 = p_u_42:GetDataChangedSignal("TeamID")
    table.insert(v43, v58:Connect(v53))
    local v59 = p_u_42.HealthChanged
    table.insert(v43, v59:Connect(v53))
    v53()
    local function v63()
        local v60 = p_u_42:Get("TeamID")
        local v61 = v_u_44.SlotFrame
        local v62
        if v60 then
            v62 = p_u_41._team_slots[v_u_3.TeamsByID[v60].TeamIndex].Container.Teammates
        else
            v62 = nil
        end
        v61.Parent = v62
    end
    local v64 = p_u_42:GetDataChangedSignal("TeamID")
    table.insert(v43, v64:Connect(v63))
    local function v65()
        v_u_44:SetStaggeredSpawnsTurn(p_u_42:GetStaggeredSpawnsTurn(), p_u_42:Get("TeamID"))
    end
    local v66 = p_u_41.Teams.Scores.DuelInterface.ClientDuel:GetDataChangedSignal("StaggeredSpawnsOrder")
    table.insert(v43, v66:Connect(v65))
    local v67 = p_u_42:GetDataChangedSignal("TeamID")
    table.insert(v43, v67:Connect(v65))
    v_u_44:SetStaggeredSpawnsTurn(p_u_42:GetStaggeredSpawnsTurn(), p_u_42:Get("TeamID"))
    if p_u_41.Teams.Scores.DuelInterface.ClientDuel.IsRanked then
        v_u_44:SetDisplayELO(p_u_42.Player:GetAttribute("DisplayELO"))
    end
    local v68 = v_u_5:Clone()
    v68.Parent = v_u_44.SlotFrame
    local v69 = p_u_42:Get("TeamID")
    local v70 = v_u_44.SlotFrame
    local v71
    if v69 then
        v71 = p_u_41._team_slots[v_u_3.TeamsByID[v69].TeamIndex].Container.Teammates
    else
        v71 = nil
    end
    v70.Parent = v71
    p_u_41._dueler_slots[p_u_42] = {
        ["ClientDueler"] = p_u_42,
        ["TeammateSlot"] = v_u_44,
        ["ChatBubbleContainer"] = v68,
        ["Connections"] = v43
    }
end
function v_u_7._Clear(p72)
    for _, v73 in pairs(p72._connections) do
        v73:Disconnect()
    end
    for _, v74 in pairs(p72._team_slots) do
        v74:Destroy()
    end
    for v75 in pairs(p72._dueler_slots) do
        p72:_RemoveClientDueler(v75)
    end
    p72._connections = {}
    p72._team_slots = {}
    p72._dueler_slots = {}
end
function v_u_7._Init(_) end
return v_u_7