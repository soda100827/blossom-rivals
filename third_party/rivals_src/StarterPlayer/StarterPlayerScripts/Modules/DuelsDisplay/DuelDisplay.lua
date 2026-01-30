local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.DuelLibrary)
local v_u_4 = require(v1.Modules.Signal)
local v_u_5 = require(v2.LocalPlayer.PlayerScripts.Controllers.SpectateController)
local v_u_6 = require(v2.LocalPlayer.PlayerScripts.Modules.TeammateSlot)
local v_u_7 = require(v2.LocalPlayer.PlayerScripts.Modules.ButtonEffect)
local v_u_8 = v2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("DuelsBoardTeamSlot")
local v_u_9 = v2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("DuelsBoardSlot")
local v_u_10 = {}
v_u_10.__index = v_u_10
function v_u_10.new(p11)
    local v12 = v_u_10
    local v13 = setmetatable({}, v12)
    v13.GameOver = v_u_4.new()
    v13.ClientDuel = p11
    v13.Frame = v_u_9:Clone()
    v13._destroyed = false
    v13._connections = {}
    v13._num_teams = v13.ClientDuel:Get("NumTeams")
    v13._team_slots = {}
    v13._team_ids = {}
    v13._dueler_slots = {}
    v13:_Init()
    return v13
end
function v_u_10.Destroy(p14)
    p14._destroyed = true
    for _, v15 in pairs(p14._connections) do
        v15:Disconnect()
    end
    p14.GameOver:Destroy()
    p14.Frame:Destroy()
end
function v_u_10._DuelerAdded(p16, p_u_17)
    if not p16._destroyed then
        p16:_UpdateScores()
        local v18 = table.find(p16._team_ids, p_u_17:Get("TeamID"))
        local v_u_19 = v_u_6.new(p_u_17.Player.UserId, p_u_17.ClientFighter:Get("Controls"), 1, false, false, p_u_17.Player:GetAttribute("StatisticDuelsWinStreak"), p_u_17.Player:GetAttribute("Level"))
        v_u_19.SlotFrame.Container.Background.Visible = false
        v_u_19.SlotFrame.Parent = v18 and p16.Frame.Teams[v18].Container or p16.Frame.Teams
        p16._dueler_slots[p_u_17] = v_u_19
        local v20 = p16._connections
        local v21 = p_u_17.HealthChanged
        table.insert(v20, v21:Connect(function()
            v_u_19:SetHealthPercent(p_u_17:GetHealth() / p_u_17:GetMaxHealth())
        end))
        v_u_19:SetHealthPercent(p_u_17:GetHealth() / p_u_17:GetMaxHealth())
    end
end
function v_u_10._DuelerRemoved(p22, p23)
    if p22.ClientDuel:Get("ArcadeMode") then
        local v24 = p22._dueler_slots[p23]
        if v24 then
            v24:Destroy()
            p22._dueler_slots[p23] = nil
        end
    else
        return
    end
end
function v_u_10._UpdateScores(p25)
    local v26 = p25.ClientDuel:Get("ScoresBehavior")
    local v27 = p25.ClientDuel:Get("Scores")
    for v28, v29 in pairs(p25._team_ids) do
        p25.Frame.Teams[v28].Container.Score.Visible = v26 == "Teams"
        p25.Frame.Teams[v28].Container.Score.Text = v27[v29] or "0"
    end
end
function v_u_10._UpdateMap(p30)
    local v31 = p30.ClientDuel.Map and p30.ClientDuel.Map.Model
    if v31 then
        v31 = p30.ClientDuel.Map.Model.Name
    end
    p30.Frame.Picture.Image = not v31 and "" or v_u_3.Maps[v31].Image
    p30.Frame.NoPicture.Visible = v31 == nil
end
function v_u_10._Setup(p32)
    for v33 = 1, p32._num_teams do
        local v34 = v_u_8:Clone()
        v34.Container.Layout.HorizontalAlignment = p32._num_teams == 2 and v33 == 1 and Enum.HorizontalAlignment.Right or Enum.HorizontalAlignment.Left
        v34.Container.Score.LayoutOrder = v34.Container.Layout.HorizontalAlignment == Enum.HorizontalAlignment.Right and 99999 or -99999
        v34.Size = UDim2.new(0.9 / p32._num_teams, 0, 1, 0)
        v34.LayoutOrder = v33 * 2
        v34.Name = v33
        v34.Parent = p32.Frame.Teams
        p32._team_slots[v33] = v34
        local v35 = p32._team_ids
        local v36 = utf8.char
        table.insert(v35, v36(v33))
    end
    p32.Frame.Teams.Spectate.LayoutOrder = p32._num_teams == 2 and 3 or -1
    for _, v37 in pairs(p32.ClientDuel.Duelers) do
        task.defer(p32._DuelerAdded, p32, v37)
    end
end
function v_u_10._Init(p_u_38)
    p_u_38.Frame.SpectateButton.MouseButton1Click:Connect(function()
        v_u_5:SpectateDuelRequest(p_u_38.ClientDuel)
    end)
    local v39 = p_u_38._connections
    local v40 = p_u_38.ClientDuel.MapAdded
    table.insert(v39, v40:Connect(function()
        p_u_38:_UpdateMap()
    end))
    local v41 = p_u_38._connections
    local v42 = p_u_38.ClientDuel:GetDataChangedSignal("Scores")
    table.insert(v41, v42:Connect(function()
        p_u_38:_UpdateScores()
    end))
    local v43 = p_u_38._connections
    local v44 = p_u_38.ClientDuel.DuelerAdded
    table.insert(v43, v44:Connect(function(p45)
        p_u_38:_DuelerAdded(p45)
    end))
    local v46 = p_u_38._connections
    local v47 = p_u_38.ClientDuel.DuelerRemoved
    table.insert(v46, v47:Connect(function(p48)
        p_u_38:_DuelerRemoved(p48)
    end))
    local v49 = p_u_38._connections
    local v50 = p_u_38.ClientDuel.DuelerRemoved
    table.insert(v49, v50:Connect(function(p51)
        if p_u_38._dueler_slots[p51] then
            p_u_38._dueler_slots[p51]:SetDisconnected(true)
        end
    end))
    local v52 = p_u_38._connections
    local v53 = p_u_38.ClientDuel:GetDataChangedSignal("Status")
    table.insert(v52, v53:Connect(function()
        if p_u_38.ClientDuel:Get("Status") == "GameOver" then
            p_u_38.GameOver:Fire()
        end
    end))
    p_u_38:_Setup()
    p_u_38:_UpdateMap()
    p_u_38:_UpdateScores()
    v_u_7:Add(p_u_38.Frame.SpectateButton, nil, {
        ["TargetElement"] = p_u_38.Frame.Teams.Spectate.Icon
    })
end
return v_u_10