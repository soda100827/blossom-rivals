local v_u_1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("Players")
local v_u_3 = require(v_u_1.Modules.CONSTANTS)
local v_u_4 = require(v_u_2.LocalPlayer.PlayerScripts.Controllers:WaitForChild("MatchmakingController"))
local v_u_5 = require(v_u_2.LocalPlayer.PlayerScripts.Controllers:WaitForChild("ComplianceController"))
local v_u_6 = require(v_u_2.LocalPlayer.PlayerScripts.Controllers:WaitForChild("QueuePadController"))
local v_u_7 = require(v_u_2.LocalPlayer.PlayerScripts.Controllers:WaitForChild("FighterController"))
local v_u_8 = require(v_u_2.LocalPlayer.PlayerScripts.Modules:WaitForChild("PartyInviteSlot"))
local v_u_9 = require(v_u_2.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect"))
local v_u_10 = require(v_u_2.LocalPlayer.PlayerScripts.Modules:WaitForChild("Page"))
local v_u_11 = v_u_2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("PartyMemberBigSlot")
local v_u_12 = setmetatable({}, v_u_10)
v_u_12.__index = v_u_12
function v_u_12._new()
    local v13 = v_u_10.new(script.Name)
    local v14 = v_u_12
    local v15 = setmetatable(v13, v14)
    v15.CloseButton = v15.PageFrame:WaitForChild("Close")
    v15.MembersFrame = v15.PageFrame:WaitForChild("Members")
    v15.List = v15.PageFrame:WaitForChild("List")
    v15.Container = v15.List:WaitForChild("Container")
    v15.Layout = v15.Container:WaitForChild("Layout")
    v15.EmptyFrame = v15.Container:WaitForChild("Empty")
    v15.TopFrame = v15.Container:WaitForChild("Top")
    v15.SearchBox = v15.TopFrame:WaitForChild("Search"):WaitForChild("Box")
    v15.TabsFrame = v15.TopFrame:WaitForChild("Tabs")
    v15.AllButton = v15.TabsFrame:WaitForChild("All")
    v15.AllButtonText = v15.AllButton:WaitForChild("Title")
    v15.AllButtonBackground = v15.AllButton:WaitForChild("Background")
    v15.AllButtonBackgroundGradient = v15.AllButtonBackground:WaitForChild("UIGradient")
    v15.FriendsButton = v15.TabsFrame:WaitForChild("Friends")
    v15.FriendsButtonText = v15.FriendsButton:WaitForChild("Title")
    v15.FriendsButtonBackground = v15.FriendsButton:WaitForChild("Background")
    v15.FriendsButtonBackgroundGradient = v15.FriendsButtonBackground:WaitForChild("UIGradient")
    v15.LobbyButton = v15.TabsFrame:WaitForChild("Lobby")
    v15.LobbyButtonText = v15.LobbyButton:WaitForChild("Title")
    v15.LobbyButtonBackground = v15.LobbyButton:WaitForChild("Background")
    v15.LobbyButtonBackgroundGradient = v15.LobbyButtonBackground:WaitForChild("UIGradient")
    v15.PlayersFrame = v15.Container:WaitForChild("Players")
    v15.PlayersContainer = v15.PlayersFrame:WaitForChild("Container")
    v15.PlayersLayout = v15.PlayersContainer:WaitForChild("Layout")
    v15.HidePartyDisplay = true
    v15._member_slots = {}
    v15._invite_slots = {}
    v15._offline_invite_slots = {}
    v15._invite_generation_disabled = 0
    v15:_Init()
    return v15
end
function v_u_12.Open(p_u_16, ...)
    v_u_10.Open(p_u_16, ...)
    local v17 = p_u_16._open_connections
    local v18 = v_u_6.ChallengeRequestCooldownChanged
    table.insert(v17, v18:Connect(function()
        p_u_16:_UpdateCooldowns()
    end))
    local v19 = p_u_16._open_connections
    local v20 = v_u_4.InviteRequestCooldownChanged
    table.insert(v19, v20:Connect(function()
        p_u_16:_UpdateCooldowns()
    end))
    p_u_16:_GenerateMembers()
    p_u_16:_GeneratePlayers(true)
    p_u_16:_UpdateCooldowns()
    p_u_16._invite_generation_disabled = tick() + 0.375
    task.delay(0.375, p_u_16._GeneratePlayers, p_u_16)
    p_u_16.SearchBox.Text = ""
end
function v_u_12._UpdateLayouts(p21)
    p21.List.CanvasSize = UDim2.new(0, 0, 0, p21.Layout.AbsoluteContentSize.Y)
    p21.PlayersFrame.Size = UDim2.new(1, 0, 0, p21.PlayersLayout.AbsoluteContentSize.Y)
    p21.EmptyFrame.Visible = p21.PlayersLayout.AbsoluteContentSize.Y < 5
end
function v_u_12._UpdateCooldowns(p22)
    for _, v23 in pairs(p22._invite_slots) do
        v23:UpdateCooldowns()
    end
end
function v_u_12._SetTab(p24, p25)
    p24._current_tab = p25
    p24.AllButtonText.TextColor3 = p24._current_tab == "All" and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
    p24.AllButtonBackground.ImageColor3 = p24._current_tab == "All" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
    p24.AllButtonBackground.ImageTransparency = p24._current_tab == "All" and 0 or 0.25
    p24.AllButtonBackgroundGradient.Enabled = p24._current_tab ~= "All"
    p24.FriendsButtonText.TextColor3 = p24._current_tab == "Friends" and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
    p24.FriendsButtonBackground.ImageColor3 = p24._current_tab == "Friends" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
    p24.FriendsButtonBackground.ImageTransparency = p24._current_tab == "Friends" and 0 or 0.25
    p24.FriendsButtonBackgroundGradient.Enabled = p24._current_tab ~= "Friends"
    p24.LobbyButtonText.TextColor3 = p24._current_tab == "Lobby" and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
    p24.LobbyButtonBackground.ImageColor3 = p24._current_tab == "Lobby" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
    p24.LobbyButtonBackground.ImageTransparency = p24._current_tab == "Lobby" and 0 or 0.25
    p24.LobbyButtonBackgroundGradient.Enabled = p24._current_tab ~= "Lobby"
    p24:_UpdatePlayersVisibility()
end
function v_u_12._UpdatePlayerVisibility(p26, p27)
    local v28 = string.lower(p26.SearchBox.Text)
    local v29 = p27.Frame
    local v30
    if p26._current_tab == "All" or p26._current_tab == p27.Frame.Name then
        v30 = string.find(string.lower(p27.Frame.DisplayName.Text), v28) or string.find(string.lower(p27.Frame.Username.Text), v28)
    else
        v30 = false
    end
    v29.Visible = v30
end
function v_u_12._UpdatePlayersVisibility(p31)
    for _, v32 in pairs(p31._invite_slots) do
        p31:_UpdatePlayerVisibility(v32)
    end
    for _, v33 in pairs(p31._offline_invite_slots) do
        p31:_UpdatePlayerVisibility(v33)
    end
end
function v_u_12._GeneratePlayers(p_u_34, p35)
    if p_u_34:IsOpen() then
        for v36 = #p_u_34._invite_slots, 1, -1 do
            local v37 = p_u_34._invite_slots[v36]
            if p35 or not v37:StillHere() then
                v37:Destroy()
                table.remove(p_u_34._invite_slots, v36)
            end
        end
        if p35 then
            for _, v38 in pairs(p_u_34._offline_invite_slots) do
                v38:Destroy()
            end
            p_u_34._offline_invite_slots = {}
        end
        if tick() >= p_u_34._invite_generation_disabled then
            local v_u_39 = {}
            for _, v40 in pairs(p_u_34._invite_slots) do
                v_u_39[tostring(v40:GetUserID())] = true
            end
            local v_u_41 = 0
            local function v49(p42, p43, p44, p45, p46)
                if not p44 then
                    if p43 then
                        p44 = p43.UserId or nil
                    else
                        p44 = nil
                    end
                end
                if (p44 ~= v_u_2.LocalPlayer.UserId or v_u_3.IS_STUDIO) and not v_u_39[tostring(p44)] then
                    v_u_39[tostring(p44)] = true
                    v_u_41 = v_u_41 + 1
                    local v47 = v_u_8.new(p43, p44, p45, p46)
                    local v48 = v47.Frame
                    v48.LayoutOrder = v48.LayoutOrder + v_u_41
                    v47.Frame.Parent = p_u_34.PlayersContainer
                    p_u_34:_UpdatePlayerVisibility(v47)
                    if p42 then
                        table.insert(p42, v47)
                    end
                end
            end
            for _, v50 in pairs(v_u_7.Objects) do
                v49(p_u_34._invite_slots, v50.Player)
            end
            if #p_u_34._offline_invite_slots == 0 then
                for _, v51 in pairs(v_u_4.Friends) do
                    v49(p_u_34._offline_invite_slots, nil, v51.VisitorId, v51.DisplayName, v51.UserName)
                end
            end
            p_u_34:_UpdatePlayersVisibility()
        end
    else
        return
    end
end
function v_u_12._GenerateMembers(p_u_52)
    if p_u_52:IsOpen() then
        for _, v53 in pairs(p_u_52._member_slots) do
            v53:Destroy()
        end
        p_u_52._member_slots = {}
        local v_u_54 = v_u_4.CurrentParty or { v_u_2.LocalPlayer }
        local function v68(p55, p_u_56)
            local v57
            if p_u_56 then
                v57 = v_u_7:GetFighter(p_u_56)
            else
                v57 = p_u_56
            end
            local v_u_58 = v_u_11:Clone()
            v_u_58.Icon.Image = not p_u_56 and "" or string.format(v_u_3.HEADSHOT_IMAGE, p_u_56.UserId)
            local v59 = v_u_58.Leader
            local v60 = p_u_56 and v_u_4.CurrentParty
            if v60 then
                v60 = p55 == 1
            end
            v59.Visible = v60
            local v61 = v_u_58.Kick
            local v62 = p_u_56 and v_u_4.CurrentParty
            if v62 then
                if v_u_2.LocalPlayer == v_u_54[1] then
                    v62 = p_u_56 ~= v_u_2.LocalPlayer
                else
                    v62 = false
                end
            end
            v61.Visible = v62
            local v63 = v_u_58.Promote
            local v64 = p_u_56 and v_u_4.CurrentParty
            if v64 then
                if v_u_2.LocalPlayer == v_u_54[1] then
                    v64 = p_u_56 ~= v_u_2.LocalPlayer
                else
                    v64 = false
                end
            end
            v63.Visible = v64
            local v65 = v_u_58.Leave
            local v66 = p_u_56 and v_u_4.CurrentParty
            if v66 then
                v66 = p_u_56 == v_u_2.LocalPlayer
            end
            v65.Visible = v66
            v_u_58.DisplayName.Controls.Image = v57 and v_u_3.CONTROLS_IMAGES[v57:Get("Controls")] or ""
            v_u_58.DisplayName.Text = not p_u_56 and "" or v_u_5:GetName(p_u_56)
            v_u_58.Username.Text = not p_u_56 and "" or "@" .. p_u_56.Name
            v_u_58.Background.Visible = p_u_56 ~= nil
            v_u_58.TransparentBackground.Visible = not p_u_56
            v_u_58.LayoutOrder = p55
            v_u_58.Parent = p_u_52.MembersFrame
            local v67 = p_u_52._member_slots
            table.insert(v67, v_u_58)
            v_u_9:Add(v_u_58.Kick)
            v_u_9:Add(v_u_58.Leave)
            v_u_9:Add(v_u_58.Promote)
            v_u_58.Kick.MouseButton1Click:Connect(function()
                v_u_1.Remotes.Matchmaking.KickPlayerFromParty:FireServer(p_u_56)
            end)
            v_u_58.Leave.MouseButton1Click:Connect(function()
                v_u_1.Remotes.Matchmaking.LeaveParty:FireServer()
            end)
            v_u_58.Promote.MouseButton1Click:Connect(function()
                v_u_1.Remotes.Matchmaking.TransferPartyLeader:FireServer(p_u_56)
            end)
            v_u_58.DisplayName:GetPropertyChangedSignal("TextBounds"):Connect(function()
                v_u_58.DisplayName.Controls.Position = UDim2.new(0, v_u_58.DisplayName.TextBounds.X, 0.5, 0)
            end)
            v_u_58.DisplayName.Controls.Position = UDim2.new(0, v_u_58.DisplayName.TextBounds.X, 0.5, 0)
        end
        for v69, v70 in pairs(v_u_54) do
            v68(v69, v70)
        end
        for v71 = #v_u_54 + 1, v_u_3.MAX_PARTY_SIZE do
            v68(v71, nil)
        end
    end
end
function v_u_12._Init(p_u_72)
    p_u_72.CloseButton.MouseButton1Click:Connect(function()
        p_u_72:CloseRequest()
    end)
    p_u_72.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p_u_72:_UpdateLayouts()
    end)
    p_u_72.PlayersLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p_u_72:_UpdateLayouts()
    end)
    p_u_72.AllButton.MouseButton1Click:Connect(function()
        p_u_72:_SetTab("All")
    end)
    p_u_72.FriendsButton.MouseButton1Click:Connect(function()
        p_u_72:_SetTab("Friends")
    end)
    p_u_72.LobbyButton.MouseButton1Click:Connect(function()
        p_u_72:_SetTab("Lobby")
    end)
    p_u_72.SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
        p_u_72:_UpdatePlayersVisibility()
    end)
    v_u_4.PartyChanged:Connect(function()
        p_u_72:_GenerateMembers()
        p_u_72:_GeneratePlayers()
    end)
    v_u_4.FriendsFetched:Connect(function()
        p_u_72:_GeneratePlayers()
    end)
    v_u_7.ObjectAdded:Connect(function()
        p_u_72:_GeneratePlayers()
    end)
    v_u_7.ObjectRemoved:Connect(function()
        p_u_72:_GeneratePlayers()
    end)
    p_u_72:_UpdateLayouts()
    task.defer(p_u_72._SetTab, p_u_72, "All")
    task.defer(p_u_72._GeneratePlayers, p_u_72)
    task.defer(p_u_72._GenerateMembers, p_u_72)
    v_u_9:Add(p_u_72.CloseButton)
    v_u_9:Add(p_u_72.AllButton)
    v_u_9:Add(p_u_72.FriendsButton)
    v_u_9:Add(p_u_72.LobbyButton)
end
return v_u_12._new()