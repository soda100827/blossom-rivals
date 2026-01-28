local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("StarterGui")
local v_u_3 = game:GetService("Players")
local v_u_4 = require(v1.Modules.CONSTANTS)
local v_u_5 = require(v1.Modules.PlayerDataUtility)
local v_u_6 = require(v1.Modules.DebugLibrary)
local v_u_7 = require(v1.Modules.Utility)
local v_u_8 = require(v1.Modules.Signal)
require(v_u_3.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
local v_u_9 = require(v_u_3.LocalPlayer.PlayerScripts.Modules.WeaponStatusHandler)
local v_u_10 = require(v_u_3.LocalPlayer.PlayerScripts.Modules.ButtonEffect)
local v_u_11 = require(v_u_3.LocalPlayer.PlayerScripts.Modules.RankIcon)
local v_u_12 = v_u_3.LocalPlayer.PlayerScripts.UserInterface.PlayerListSlot
local v_u_13 = { 0.45, "rbxassetid://89686341813708" }
local v_u_14 = { 0.625, "rbxassetid://140099562989635" }
local v_u_15 = { 0.45, "rbxassetid://114408044569826" }
local v_u_16 = { 0.6, "rbxassetid://134084662516990" }
local v_u_17 = { 0.5, "rbxassetid://108431611670429" }
local v_u_18 = { 0.4, "rbxassetid://97625610157994" }
local v_u_19 = { 0.5, "rbxassetid://118031781381166" }
local v_u_20 = { 0.4, "rbxassetid://105897927" }
local v_u_21 = {}
v_u_21.__index = v_u_21
function v_u_21.new(p22, p23)
    local v24 = v_u_21
    local v25 = setmetatable({}, v24)
    v25.Clicked = v_u_8.new()
    v25.Elements = p22
    v25.ClientFighter = p23
    v25.Frame = v_u_12:Clone()
    v25.Button = v25.Frame:WaitForChild("Button")
    v25.HighlightFrame = v25.Frame:WaitForChild("Highlight")
    v25.LeaderstatFrame = v25.Frame:WaitForChild("Leaderstat")
    v25.LeaderstatTitle = v25.LeaderstatFrame:WaitForChild("Title")
    v25.LeaderstatRankContainer = v25.LeaderstatFrame:WaitForChild("RankContainer")
    v25.PlayerContainer = v25.Frame:WaitForChild("Player"):WaitForChild("Container")
    v25.PlayerIcon = v25.PlayerContainer:WaitForChild("Icon")
    v25.PlayerTitle = v25.PlayerContainer:WaitForChild("Title")
    v25.PlayerTitleIcon = v25.PlayerTitle:WaitForChild("Icon")
    v25._connections = {}
    v25._is_highlighted = false
    v25._is_hovered = false
    v25._leaderstat_name = nil
    v25._leaderstat_rank_icon = nil
    v25._is_friend = nil
    v25._is_blocked = nil
    v25:_Init()
    return v25
end
function v_u_21.IsFriend(p26)
    return p26._is_friend
end
function v_u_21.IsBlocked(p27)
    return p27._is_blocked
end
function v_u_21.SetParent(p28, p29)
    p28.Frame.Parent = p29
end
function v_u_21.SetLeaderstat(p30, p31)
    p30._leaderstat_name = p31
    p30:_UpdateLeaderstat()
end
function v_u_21.SetHighlighted(p32, p33)
    p32._is_highlighted = p33
    p32:_UpdateHighlight()
end
function v_u_21.SetIsFriend(p34, p35)
    if p34._is_friend ~= p35 then
        p34._is_friend = p35
        p34:_UpdateIcon()
    end
end
function v_u_21.SetIsBlocked(p36, p37)
    if p36._is_blocked ~= p37 then
        p36._is_blocked = p37
        p36:_UpdateIcon()
    end
end
function v_u_21.OnOpened(p38)
    p38:_UpdateLeaderstat()
    p38:_UpdateIcon()
    p38:_UpdateVisuals()
    p38:_UpdateStatus()
end
function v_u_21.Destroy(p39)
    for _, v40 in pairs(p39._connections) do
        v40:Disconnect()
    end
    if p39._leaderstat_rank_icon then
        p39._leaderstat_rank_icon:Destroy()
        p39._leaderstat_rank_icon = nil
    end
    p39.Clicked:Destroy()
    p39.Frame:Destroy()
end
function v_u_21._UpdateVisuals(p_u_41)
    if p_u_41.Elements.PlayerList.IsOpen then
        task.delay(0, function()
            p_u_41.PlayerTitleIcon.Position = UDim2.new(0, p_u_41.PlayerTitle.TextBounds.X, 0.5, 0)
        end)
    end
end
function v_u_21._UpdateIcon(p42)
    if p42.Elements.PlayerList.IsOpen then
        local v43
        if p42._is_blocked then
            v43 = v_u_18
        elseif p42._is_friend then
            v43 = v_u_19
        else
            local v44 = v_u_6.DEBUG_WHITELIST_USERS
            local v45 = p42.ClientFighter.Player.UserId
            if v44[tostring(v45)] == true then
                v43 = v_u_13
            elseif v_u_5:IsNosniyGamesTeamMemberRaw(p42.ClientFighter.Player:GetAttribute("GroupRank")) then
                v43 = v_u_14
            elseif p42.ClientFighter.Player.UserId == 261 then
                v43 = v_u_20
            elseif p42.ClientFighter.Player:GetAttribute("IsRobloxEmployee") then
                v43 = v_u_15
            elseif p42.ClientFighter.Player:GetAttribute("IsInfluencer") then
                v43 = v_u_16
            elseif p42.ClientFighter.Player.MembershipType == Enum.MembershipType.Premium then
                v43 = v_u_17
            else
                v43 = nil
            end
        end
        p42.PlayerIcon.Image = v43 and (v43[2] or "") or ""
        p42.PlayerIcon.Size = v43 and UDim2.new(v43[1], 0, v43[1], 0) or UDim2.new(0, 0, 0, 0)
        p42.PlayerTitleIcon.Image = v_u_4.CONTROLS_IMAGES[p42.ClientFighter:Get("Controls")] or ""
    end
end
function v_u_21._UpdateStatus(p46)
    if p46.Elements.PlayerList.IsOpen then
        v_u_9:ClearStatusElements(p46.PlayerTitle)
        v_u_9:ApplyItemStatusToText(p46.PlayerTitle, p46.ClientFighter.Player:GetAttribute("PlayerStatus"))
    end
end
function v_u_21._UpdateLeaderstat(p47)
    if p47.Elements.PlayerList.IsOpen then
        if p47._leaderstat_rank_icon then
            p47._leaderstat_rank_icon:Destroy()
            p47._leaderstat_rank_icon = nil
        end
        local v48 = p47._leaderstat_name and p47.ClientFighter.Player:FindFirstChild("CustomLeaderstats")
        if v48 then
            v48 = p47.ClientFighter.Player.CustomLeaderstats:FindFirstChild(p47._leaderstat_name)
        end
        p47.Frame.LayoutOrder = v48 and (-v48.Value or 1) or 1
        if v48 and not v48:GetAttribute("StillLoading") then
            if p47._leaderstat_name == "Current ELO" then
                p47.LeaderstatTitle.Text = ""
                p47._leaderstat_rank_icon = v_u_11.new(v48.Value, p47.ClientFighter.Player.UserId)
                p47._leaderstat_rank_icon:SetParent(p47.LeaderstatRankContainer)
            else
                p47.LeaderstatTitle.Text = not v48.Value and "\226\128\162 \226\128\162 \226\128\162" or v_u_7:PrettyNumber(v48.Value)
            end
        else
            p47.LeaderstatTitle.Text = "\226\128\162 \226\128\162 \226\128\162"
            return
        end
    else
        return
    end
end
function v_u_21._UpdateHighlight(p49)
    p49.HighlightFrame.BackgroundTransparency = p49._is_highlighted and 0.875 or (p49._is_hovered and 0.95 or 1)
end
function v_u_21._SetHovered(p50, p51)
    p50._is_hovered = p51
    p50:_UpdateHighlight()
end
function v_u_21._FetchIsBlocked(p52)
    local v53, v54 = pcall(v_u_2.GetCore, v_u_2, "GetBlockedUserIds")
    if v53 then
        v53 = table.find(v54, p52.ClientFighter.Player.UserId) ~= nil
    end
    p52:SetIsBlocked(v53)
end
function v_u_21._FetchIsFriend(p55)
    if p55.ClientFighter.IsLocalPlayer then
        p55:SetIsFriend(false)
    else
        local v56, v57 = pcall(p55.ClientFighter.Player.IsFriendsWith, p55.ClientFighter.Player, v_u_3.LocalPlayer.UserId)
        p55:SetIsFriend(v56 and v57)
    end
end
function v_u_21._SetupLeaderstats(p_u_58)
    local v59 = p_u_58.ClientFighter.Player:WaitForChild("CustomLeaderstats")
    local v60 = p_u_58._connections
    local v61 = v59.ChildRemoved
    table.insert(v60, v61:Connect(function()
        p_u_58:_UpdateLeaderstat()
    end))
    local function v64(p62, p63)
        p62:GetPropertyChangedSignal("Value"):Connect(function()
            p_u_58:_UpdateLeaderstat()
        end)
        p62:GetAttributeChangedSignal("StillLoading"):Connect(function()
            p_u_58:_UpdateLeaderstat()
        end)
        if not p63 then
            p_u_58:_UpdateLeaderstat()
        end
    end
    local v65 = p_u_58._connections
    local v66 = v59.ChildAdded
    table.insert(v65, v66:Connect(v64))
    for _, v67 in pairs(v59:GetChildren()) do
        task.spawn(v64, v67, true)
    end
    p_u_58:_UpdateLeaderstat()
end
function v_u_21._Setup(p68)
    p68.PlayerTitle.Text = v_u_7:GetName(p68.ClientFighter.Player, p68.ClientFighter.Player.DisplayName, true)
end
function v_u_21._Init(p_u_69)
    p_u_69.Button.MouseButton1Click:Connect(function()
        p_u_69.Clicked:Fire()
    end)
    p_u_69.Button.MouseEnter:Connect(function()
        p_u_69:_SetHovered(true)
    end)
    p_u_69.Button.MouseLeave:Connect(function()
        p_u_69:_SetHovered(false)
    end)
    p_u_69.PlayerTitle:GetPropertyChangedSignal("TextBounds"):Connect(function()
        p_u_69:_UpdateVisuals()
    end)
    p_u_69.PlayerTitle:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        p_u_69:_UpdateVisuals()
    end)
    p_u_69.PlayerTitle:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
        p_u_69:_UpdateVisuals()
    end)
    local v70 = p_u_69._connections
    local v71 = p_u_69.ClientFighter:GetDataChangedSignal("Controls")
    table.insert(v70, v71:Connect(function()
        p_u_69:_UpdateIcon()
    end))
    local v72 = p_u_69._connections
    local v73 = p_u_69.ClientFighter.Player:GetAttributeChangedSignal("GroupRank")
    table.insert(v72, v73:Connect(function()
        p_u_69:_UpdateIcon()
    end))
    local v74 = p_u_69._connections
    local v75 = p_u_69.ClientFighter.Player:GetAttributeChangedSignal("IsRobloxEmployee")
    table.insert(v74, v75:Connect(function()
        p_u_69:_UpdateIcon()
    end))
    local v76 = p_u_69._connections
    local v77 = p_u_69.ClientFighter.Player:GetAttributeChangedSignal("IsInfluencer")
    table.insert(v76, v77:Connect(function()
        p_u_69:_UpdateIcon()
    end))
    local v78 = p_u_69._connections
    local v79 = p_u_69.ClientFighter.Player:GetPropertyChangedSignal("MembershipType")
    table.insert(v78, v79:Connect(function()
        p_u_69:_UpdateIcon()
    end))
    local v80 = p_u_69._connections
    local v81 = p_u_69.ClientFighter.Player:GetAttributeChangedSignal("PlayerStatus")
    table.insert(v80, v81:Connect(function()
        p_u_69:_UpdateStatus()
    end))
    p_u_69:_Setup()
    p_u_69:_UpdateIcon()
    p_u_69:_UpdateStatus()
    p_u_69:_UpdateVisuals()
    p_u_69:_UpdateHighlight()
    p_u_69:_UpdateLeaderstat()
    task.spawn(p_u_69._FetchIsFriend, p_u_69)
    task.spawn(p_u_69._FetchIsBlocked, p_u_69)
    task.spawn(p_u_69._SetupLeaderstats, p_u_69)
    v_u_10:Add(p_u_69.Button, true)
end
return v_u_21