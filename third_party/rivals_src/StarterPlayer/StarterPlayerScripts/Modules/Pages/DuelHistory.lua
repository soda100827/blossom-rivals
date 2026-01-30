local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.CONSTANTS)
local v_u_4 = require(v1.Modules.SeasonLibrary)
local v_u_5 = require(v1.Modules.DuelLibrary)
local v_u_6 = require(v1.Modules.Utility)
local v_u_7 = require(v_u_2.LocalPlayer.PlayerScripts.Controllers:WaitForChild("ComplianceController"))
local v_u_8 = require(v_u_2.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController"))
local v_u_9 = require(v_u_2.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect"))
local v_u_10 = require(v_u_2.LocalPlayer.PlayerScripts.Modules:WaitForChild("RankIcon"))
local v_u_11 = require(v_u_2.LocalPlayer.PlayerScripts.Modules:WaitForChild("Page"))
local v_u_12 = v_u_2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("DuelHistoryRageQuitSlot")
local v_u_13 = v_u_2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("DuelHistoryHeadshotSlot")
local v_u_14 = v_u_2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("DuelHistoryDuelerSlot")
local v_u_15 = v_u_2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("DuelHistoryEmptySlot")
local v_u_16 = v_u_2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("DuelHistorySlot")
local v_u_17 = setmetatable({}, v_u_11)
v_u_17.__index = v_u_17
function v_u_17._new()
    local v18 = v_u_11.new(script.Name)
    local v19 = v_u_17
    local v20 = setmetatable(v18, v19)
    v20.CloseButton = v20.PageFrame:WaitForChild("Close")
    v20.List = v20.PageFrame:WaitForChild("List")
    v20.Container = v20.List:WaitForChild("Container")
    v20.Layout = v20.Container:WaitForChild("Layout")
    v20._duel_history_slots = {}
    v20._generate_hash = 0
    v20:_Init()
    return v20
end
function v_u_17.Open(p21, ...)
    v_u_11.Open(p21, ...)
    task.spawn(p21._Generate, p21)
end
function v_u_17._SetupELOEventLog(_, p22, p23)
    p22.Visible = p23
    if p23 then
        local v24 = v_u_10.new(p23.CurrentELO, nil, p23.CurrentLeaderboardRanking or (1 / 0))
        v24:SetLabelFromELOEvent(p23.ELOIncrement, p23.CurrentELO, p23.DuelsPlayed)
        v24:SetParent(p22)
    end
end
function v_u_17._Generate(p25)
    for _, v26 in pairs(p25._duel_history_slots) do
        v26:Destroy()
    end
    p25._duel_history_slots = {}
    p25._generate_hash = p25._generate_hash + 1
    local v27 = p25._generate_hash
    local v28 = {}
    for _, v29 in pairs(v_u_8:Get("LoggedELOEvents")) do
        if v29.LogID then
            v28[v29.LogID] = v29
        end
    end
    for v30, v_u_31 in pairs(v_u_8:Get("DuelHistory")) do
        if v27 ~= p25._generate_hash then
            return
        end
        local v32 = v28[v_u_31.LogID]
        if v_u_31.IsRageQuit then
            local v33 = v_u_12:Clone()
            v33.LayoutOrder = v30
            v33.Parent = p25.Container
            local v34 = p25._duel_history_slots
            table.insert(v34, v33)
            p25:_SetupELOEventLog(v33.RankContainer, v32)
            wait(0.03)
        else
            local v35 = false
            for _, v36 in pairs(v_u_31.Duelers) do
                if v36.UserID == v_u_2.LocalPlayer.UserId then
                    v35 = true
                    break
                end
            end
            if v35 then
                local v_u_37 = v_u_16:Clone()
                v_u_37.LayoutOrder = v30
                v_u_37.Map.Image = v_u_31.Map and v_u_5.Maps[v_u_31.Map] and (v_u_5.Maps[v_u_31.Map].Image or "") or ""
                v_u_37.Container.QueueName.Text = v_u_31.QueueName and v_u_5.MatchmakingQueues[v_u_31.QueueName] and v_u_5.MatchmakingQueues[v_u_31.QueueName].DisplayName or (v_u_31.QueueName or "")
                v_u_37.Container.Score.Text = ""
                v_u_37.Container.EDATitle.Visible = false
                v_u_37.Container.EDA.Visible = false
                p25:_SetupELOEventLog(v_u_37.Container.RankContainer, v32)
                for v38 = 1, v_u_31.NumTeams do
                    local v39 = v_u_37.Container.Score
                    v39.Text = v39.Text .. v_u_31.Scores[v38] .. (v38 == v_u_31.NumTeams and "" or " \226\128\162 ")
                end
                local v40 = v_u_4:IsRankedQueue(v_u_31.QueueName)
                local v_u_41 = {}
                for v42, v43 in pairs(v_u_31.Duelers) do
                    if v43.UserID == v_u_2.LocalPlayer.UserId then
                        local v44 = v_u_31.WinningTeamIndex
                        if v44 then
                            v44 = v_u_31.WinningTeamIndex == v43.TeamIndex
                        end
                        v_u_37.Container.Background.ImageColor3 = v44 and Color3.fromRGB(100, 255, 50) or Color3.fromRGB(255, 50, 50)
                        v_u_37.Container.Title.Text = v44 and "VICTORY" or "DEFEAT"
                        v_u_37.Container.EDA.Text = (v43.Eliminations or "?") .. " \226\128\162 " .. (v43.Deaths or "?") .. " \226\128\162 " .. (v43.Assists or "?")
                        v_u_37.Container.EDA.Visible = not v_u_37.Container.RankContainer.Visible
                        v_u_37.Container.EDATitle.Visible = v_u_37.Container.EDA.Visible
                    end
                    local v45 = v_u_13:Clone()
                    v45.Image = not v43.UserID and "rbxassetid://18623501726" or string.format(v_u_3.HEADSHOT_IMAGE, v43.UserID)
                    v45.ImageColor3 = not v43.UserID and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
                    v45.ImageTransparency = v43.UserID and 0 or 0.5
                    v45.LayoutOrder = v43.TeamIndex * 1000 + v42
                    v45.Parent = v_u_37.Container.Headshots
                    local v46 = v_u_14:Clone()
                    v46.Player.Image = not v43.UserID and "rbxassetid://18623501726" or string.format(v_u_3.HEADSHOT_IMAGE, v43.UserID)
                    v46.DisplayName.Text = "\226\128\162 \226\128\162 \226\128\162"
                    v46.Username.Text = "@\226\128\162 \226\128\162 \226\128\162"
                    local v47 = v46.Damage
                    local v48
                    if v43.Damage then
                        local v49 = v_u_6
                        local v50 = v43.Damage + 0.5
                        v48 = v49:PrettyNumber((math.floor(v50))) or ""
                    else
                        v48 = ""
                    end
                    v47.Text = v48
                    v46.Eliminations.Text = v43.Eliminations or ""
                    v46.Deaths.Text = v43.Deaths or ""
                    v46.Assists.Text = v43.Assists or ""
                    v46.MVPText.Visible = v43.IsMVP
                    v46.MVPIcon.Visible = v43.IsMVP
                    local v51 = v_u_5
                    local v52 = v43.TeamIndex and v_u_5.Teams[v43.TeamIndex]
                    if v52 then
                        v52 = v_u_5.Teams[v43.TeamIndex].TeamID
                    end
                    v46.BackgroundColor3 = v51:GetTeamColor(v52)
                    v46.LayoutOrder = v42
                    v46.Parent = v_u_37.Container.Duelers
                    if v43.UserID then
                        local v53 = v43.UserID
                        v_u_41[tostring(v53)] = v46
                    end
                    if v40 then
                        v_u_10.new(v43.DisplayELO, nil, v43.DisplayELOLeaderboardRanking or (1 / 0)):SetParent(v46.Rank)
                    end
                end
                v_u_37.Parent = p25.Container
                local v54 = p25._duel_history_slots
                table.insert(v54, v_u_37)
                local v_u_55 = v_u_9:Add(v_u_37, nil, {
                    ["HoverRatio"] = 1.025,
                    ["ReleaseRatio"] = 1.025
                })
                local v_u_56 = false
                local v_u_57 = false
                v_u_37.MouseButton1Click:Connect(function()
                    v_u_57 = not v_u_57
                    local v58 = v_u_57 and UDim2.new(1, 0, (#v_u_37.Container.Duelers:GetChildren() - 3) * 0.07500000000000001 + 0.2475, 0) or UDim2.new(1, 0, 0.2, 0)
                    v_u_55.UpdateOriginalSize(v58)
                    v_u_37.Size = v58
                    v_u_37.Container.Duelers.Visible = v_u_57
                    if not v_u_56 then
                        v_u_56 = true
                        local v59 = {}
                        for _, v60 in pairs(v_u_31.Duelers) do
                            if v60.UserID then
                                local v61 = v60.UserID
                                table.insert(v59, v61)
                            end
                        end
                        local v62 = v_u_7:GetUserInfos(v59)
                        for v63, v64 in pairs(v_u_41) do
                            local v65 = v62[v63]
                            if v65 then
                                v64.Username.Text = v65.Username == v65.DisplayName and "" or "@" .. v65.Username
                                v64.DisplayName.Text = v65.DisplayName
                                v64.DisplayName.Position = v64.Username.Text == "" and UDim2.new(0.1, 0, 0.5, 0) or UDim2.new(0.1, 0, 0.35, 0)
                            end
                        end
                    end
                end)
                wait(0.03)
            end
        end
    end
    for _ = #p25._duel_history_slots + 1, 6 do
        if v27 ~= p25._generate_hash then
            return
        end
        local v66 = v_u_15:Clone()
        v66.LayoutOrder = 99999
        v66.Parent = p25.Container
        local v67 = p25._duel_history_slots
        table.insert(v67, v66)
        wait(0.03)
    end
end
function v_u_17._Init(p_u_68)
    p_u_68.CloseButton.MouseButton1Click:Connect(function()
        p_u_68:CloseRequest()
    end)
    p_u_68.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p_u_68.List.CanvasSize = UDim2.new(0, 0, 0, p_u_68.Layout.AbsoluteContentSize.Y)
    end)
    v_u_9:Add(p_u_68.CloseButton)
end
return v_u_17._new()