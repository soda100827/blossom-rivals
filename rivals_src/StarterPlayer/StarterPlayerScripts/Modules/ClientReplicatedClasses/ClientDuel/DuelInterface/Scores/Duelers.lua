local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.DuelLibrary)
local v_u_4 = require(v1.Modules.ItemLibrary)
local v_u_5 = require(v1.Modules.Utility)
local v_u_6 = require(v2.LocalPlayer.PlayerScripts.Modules.TeammateSlot)
local v_u_7 = v2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("DuelScoresDuelerTeamBackground")
local v_u_8 = v2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("DuelScoresChatBubbleContainer")
local v_u_9 = v2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("DuelScoresDuelerSlot")
local v_u_10 = {}
v_u_10.__index = v_u_10
function v_u_10.new(p11)
    local v12 = v_u_10
    local v13 = setmetatable({}, v12)
    v13.Scores = p11
    v13.Frame = v13.Scores.Frame:WaitForChild("Duelers")
    v13.Container = v13.Frame:WaitForChild("Container")
    v13._connections = {}
    v13._dueler_slots = {}
    v13:_Init()
    return v13
end
function v_u_10.GetChatBubbleContainer(p14, p15)
    local v16 = nil
    for v17, v18 in pairs(p14._dueler_slots) do
        local v19 = v17.Player == p15
        if not v16 then
            if v19 then
                v16 = v18.ChatBubbleContainer
            else
                v16 = v19
            end
        end
        v18.TeammateSlot.SlotFrame.ZIndex = v19 and 2 or 1
    end
    return v16
end
function v_u_10.Generate(p_u_20)
    p_u_20:_Clear()
    if p_u_20.Scores.DuelInterface.ClientDuel:Get("ScoresBehavior") == "Duelers" and not p_u_20.Scores.DuelInterface.ClientDuel:Get("VoteOptions") then
        local v21 = p_u_20._connections
        local v22 = p_u_20.Scores.DuelInterface.ClientDuel:GetDataChangedSignal("Scores")
        table.insert(v21, v22:Connect(function(_)
            p_u_20:_UpdateRanks()
        end))
        local v23 = p_u_20._connections
        local v24 = p_u_20.Scores.DuelInterface.ClientDuel.DuelerAdded
        table.insert(v23, v24:Connect(function(p25)
            p_u_20:_AddClientDueler(p25)
        end))
        if p_u_20.Scores.DuelInterface.ClientDuel:Get("ArcadeMode") then
            local v26 = p_u_20._connections
            local v27 = p_u_20.Scores.DuelInterface.ClientDuel.DuelerRemoved
            table.insert(v26, v27:Connect(function(p28)
                p_u_20:_RemoveClientDueler(p28)
            end))
        end
        for v29 in pairs(p_u_20.Scores.DuelInterface:GetLoggedClientDuelers()) do
            p_u_20:_AddClientDueler(v29, true)
        end
        p_u_20:_UpdateRanks()
    end
end
function v_u_10.Destroy(p30)
    p30:_Clear()
end
function v_u_10._UpdateRanks(p_u_31)
    task.defer(function()
        local v32 = p_u_31.Scores.DuelInterface:GetLoggedClientDuelers(true)
        for v33, v34 in pairs(v32) do
            local v35 = p_u_31._dueler_slots[v34]
            if v35 then
                v35.TeammateSlot.SlotFrame.LayoutOrder = v33
                v35.TeammateSlot.SlotFrame.Visible = v33 <= 9 and true or v34.IsLocalPlayer
                v35.ScoreSlot.Rank.Text = "#" .. v33
            end
        end
    end)
end
function v_u_10._RemoveClientDueler(p36, p37, p38)
    local v39 = p36._dueler_slots[p37]
    if v39 then
        for _, v40 in pairs(v39.Connections) do
            v40:Disconnect()
        end
        v39.TeammateSlot:Destroy()
        p36._dueler_slots[p37] = nil
        if not p38 then
            p36:_UpdateRanks()
        end
    end
end
function v_u_10._AddClientDueler(p_u_41, p_u_42, p43)
    p_u_41:_RemoveClientDueler(p_u_42, p43)
    local v44 = {}
    local v_u_45 = v_u_6.new(p_u_42.Player.UserId, nil, nil, nil, true)
    local v_u_46 = v_u_7:Clone()
    v_u_46.Parent = v_u_45.SlotFrame.Container.Background
    local v_u_47 = v_u_45.SlotFrame.Container.Background.ImageTransparency
    local function v49()
        local v48 = p_u_42:Get("TeamID")
        v_u_45.SlotFrame.Container.Background.ImageTransparency = v48 and 1 or v_u_47
        v_u_46.ImageColor3 = v_u_3:GetTeamColor(v48)
        v_u_46.Visible = v48 ~= nil
    end
    local v50 = p_u_42:GetDataChangedSignal("TeamID")
    table.insert(v44, v50:Connect(v49))
    local v51 = p_u_42:Get("TeamID")
    v_u_45.SlotFrame.Container.Background.ImageTransparency = v51 and 1 or v_u_47
    v_u_46.ImageColor3 = v_u_3:GetTeamColor(v51)
    v_u_46.Visible = v51 ~= nil
    local v_u_52 = v_u_9:Clone()
    v_u_52.Parent = v_u_45.SlotFrame
    local function v54()
        local v53 = v_u_5:PrettyNumber(p_u_41.Scores.DuelInterface.ClientDuel:Get("Scores")[p_u_42:Get("DuelerID")])
        local _ = p_u_42 and (p_u_42.ClientFighter and (p_u_42.ClientFighter.Items[1] and v_u_4.ViewModels[p_u_42.ClientFighter.Items[1].Name].EliminationFeedImage))
        v_u_52.Score.Text = v53
        v_u_52.Weapon.Image = ""
    end
    local v55 = p_u_41.Scores.DuelInterface.ClientDuel:GetDataChangedSignal("IsGunGame")
    table.insert(v44, v55:Connect(v54))
    local v56 = p_u_41.Scores.DuelInterface.ClientDuel:GetDataChangedSignal("Scores")
    table.insert(v44, v56:Connect(v54))
    v54()
    local v57 = v_u_8:Clone()
    v57.Position = UDim2.new(0.5, 0, 1.375, 0)
    v57.Parent = v_u_45.SlotFrame
    v_u_45.SlotFrame.Parent = p_u_41.Container
    p_u_41._dueler_slots[p_u_42] = {
        ["ClientDueler"] = p_u_42,
        ["TeammateSlot"] = v_u_45,
        ["ScoreSlot"] = v_u_52,
        ["ChatBubbleContainer"] = v57,
        ["Connections"] = v44
    }
    if not p43 then
        p_u_41:_UpdateRanks()
    end
end
function v_u_10._Clear(p58)
    for _, v59 in pairs(p58._connections) do
        v59:Disconnect()
    end
    for v60 in pairs(p58._dueler_slots) do
        p58:_RemoveClientDueler(v60)
    end
    p58._connections = {}
    p58._dueler_slots = {}
end
function v_u_10._Init(_) end
return v_u_10