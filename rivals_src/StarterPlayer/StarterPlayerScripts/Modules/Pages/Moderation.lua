local v_u_1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("UserService")
local v_u_3 = game:GetService("Players")
local v_u_4 = require(v_u_1.Modules.CONSTANTS)
local v_u_5 = require(v_u_1.Modules.SeasonLibrary)
local v_u_6 = require(v_u_1.Modules.Utility)
local v_u_7 = require(v_u_3.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect"))
local v_u_8 = require(v_u_3.LocalPlayer.PlayerScripts.Modules:WaitForChild("PromptSystem"))
local v_u_9 = require(v_u_3.LocalPlayer.PlayerScripts.Modules:WaitForChild("DropdownSlot"))
local v_u_10 = require(v_u_3.LocalPlayer.PlayerScripts.Modules:WaitForChild("RankIcon"))
local v_u_11 = require(v_u_3.LocalPlayer.PlayerScripts.Modules:WaitForChild("Page"))
local v_u_12 = setmetatable({}, v_u_11)
v_u_12.__index = v_u_12
function v_u_12._new()
    local v13 = v_u_11.new(script.Name)
    local v14 = v_u_12
    local v15 = setmetatable(v13, v14)
    v15.CloseButton = v15.PageFrame:WaitForChild("Close")
    v15.CheckTop100StreaksButton = v15.PageFrame:WaitForChild("CheckTop100Streaks")
    v15.CheckTop100TrueStreaksButton = v15.PageFrame:WaitForChild("CheckTop100TrueStreaks")
    v15.WaitingFrame = v15.PageFrame:WaitForChild("Waiting")
    v15.DotsFrame = v15.WaitingFrame:WaitForChild("Dots")
    v15.PromptsFrame = v15.PageFrame:WaitForChild("Prompts")
    v15.LookupFrame = v15.PageFrame:WaitForChild("Lookup")
    v15.LookupBox = v15.LookupFrame:WaitForChild("Box")
    v15.LookupButton = v15.LookupFrame:WaitForChild("Button")
    v15.LookupDropdownButton = v15.LookupFrame:WaitForChild("Dropdown")
    v15.DropdownReferenceFrame = v15.LookupFrame:WaitForChild("DropdownReference")
    v15.BanDataFrame = v15.PageFrame:WaitForChild("BanData")
    v15.BanButton = v15.BanDataFrame:WaitForChild("Ban")
    v15.UnbanButton = v15.BanDataFrame:WaitForChild("Unban")
    v15.KickButton = v15.BanDataFrame:WaitForChild("Kick")
    v15.LogsButton = v15.BanDataFrame:WaitForChild("Logs")
    v15.JoinButton = v15.BanDataFrame:WaitForChild("Join")
    v15.ViewDataButton = v15.BanDataFrame:WaitForChild("ViewData")
    v15.PardonRedFlagsButton = v15.BanDataFrame:WaitForChild("PardonRedFlags")
    v15.DisplayNameText = v15.BanDataFrame:WaitForChild("DisplayName")
    v15.UsernameText = v15.BanDataFrame:WaitForChild("Username")
    v15.StatusText = v15.BanDataFrame:WaitForChild("Status")
    v15.UserIDText = v15.BanDataFrame:WaitForChild("UserID")
    v15.BanHistoryText = v15.BanDataFrame:WaitForChild("BanHistory")
    v15.RedFlagsText = v15.BanDataFrame:WaitForChild("RedFlags")
    v15.OnlineFrame = v15.BanDataFrame:WaitForChild("Online")
    v15.OnlineDot = v15.OnlineFrame:WaitForChild("Dot")
    v15.PlayerPicture = v15.BanDataFrame:WaitForChild("Picture")
    v15.PlayerLevel = v15.PlayerPicture:WaitForChild("Level")
    v15.PlayerLevelText = v15.PlayerLevel:WaitForChild("Title")
    v15.PlayerStreak = v15.PlayerPicture:WaitForChild("Streak")
    v15.PlayerStreakText = v15.PlayerStreak:WaitForChild("Value")
    v15.PlayerControls = v15.PlayerPicture:WaitForChild("Controls")
    v15.PlayerRank = v15.PlayerPicture:WaitForChild("Rank")
    v15.PromptSystem = v_u_8.new(v15.PromptsFrame)
    v15._ban_data = nil
    v15._player_data = nil
    v15._ban_data_hash = 0
    v15._lookup_disabled = false
    v15._player_data_debounce = false
    v15._last_rank_icon = nil
    v15._dropdown_slot = nil
    v15._cached_players = {}
    v15:_Init()
    return v15
end
function v_u_12.SetBanData(p_u_16, p17, p18)
    local v19 = not p17 or typeof(p17) == "table"
    local v20 = "Argument 1 invalid, expected a table or nil, got " .. tostring(p17)
    assert(v19, v20)
    local v21 = not p18 or typeof(p18) == "table"
    local v22 = "Argument 2 invalid, expected a table or nil, got " .. tostring(p18)
    assert(v21, v22)
    p_u_16._ban_data = p17
    p_u_16._player_data = p18
    p_u_16._ban_data_hash = p_u_16._ban_data_hash + 1
    p_u_16.BanDataFrame.Visible = p_u_16._ban_data ~= nil
    if p_u_16._last_rank_icon then
        p_u_16._last_rank_icon:Destroy()
        p_u_16._last_rank_icon = nil
    end
    if p_u_16._ban_data then
        local v_u_23 = p_u_16._ban_data_hash
        local v24 = p_u_16._ban_data.TimeRemaining > 0
        local v25 = p_u_16._ban_data.BanHistory[1] and (p_u_16._ban_data.BanHistory[1].Duration or 0) or 0
        local v26 = p_u_16._player_data and p_u_16._player_data.RedFlags
        if v26 then
            v26 = p_u_16._player_data.RedFlags[#p_u_16._player_data.RedFlags]
        end
        local v27 = p_u_16._player_data
        if v27 then
            v27 = p_u_16._player_data.SessionID ~= nil
        end
        local v28 = p_u_16._player_data
        if v28 then
            v28 = p_u_16._player_data.Level
        end
        local v29 = p_u_16._player_data
        if v29 then
            v29 = p_u_16._player_data.StatisticDuelsWinStreak
        end
        local v30 = p_u_16._player_data
        if v30 then
            v30 = p_u_16._player_data.LastKnownControls
        end
        local v31 = p_u_16._player_data and (p_u_16._player_data.Seasons and p_u_16._player_data.Seasons[v_u_5.CurrentSeason.Name])
        if v31 then
            v31 = p_u_16._player_data.Seasons[v_u_5.CurrentSeason.Name].RankedPerformances[v_u_5.UNIVERSAL_ELO_NAME]
        end
        local v32
        if v31 then
            v32 = v31.CurrentELO
        else
            v32 = v31
        end
        local v33 = p_u_16.PlayerPicture
        local v34 = string.format
        local v35 = v_u_4.HEADSHOT_IMAGE
        local v36 = p_u_16._ban_data.UserID
        v33.Image = v34(v35, (tostring(v36)))
        p_u_16.PlayerLevel.Visible = p_u_16._player_data
        p_u_16.PlayerLevelText.Text = v28 and v_u_6:PrettyNumber(v28) or ""
        p_u_16.PlayerStreakText.Text = v29 and (v29 > 0 and v_u_6:PrettyNumber(v29)) or ""
        p_u_16.PlayerStreak.Visible = p_u_16.PlayerStreakText.Text ~= ""
        p_u_16.PlayerControls.Image = v30 and v_u_4.CONTROLS_IMAGES[v30] or ""
        p_u_16.UsernameText.Text = "@" .. p_u_16._ban_data.Name
        p_u_16.DisplayNameText.Text = "\226\128\162 \226\128\162 \226\128\162"
        local v37 = p_u_16.UserIDText
        local v38 = p_u_16._ban_data.UserID
        v37.Text = tostring(v38)
        p_u_16.StatusText.Text = v24 and ("Banned [" .. (v25 == 999999999 and "Permanent" or v_u_6:TimeFormat2(p_u_16._ban_data.TimeRemaining)) .. "]" or "Unbanned") or "Unbanned"
        p_u_16.StatusText.TextColor3 = v24 and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(100, 255, 50)
        p_u_16.BanHistoryText.Text = v24 and "Current ban reason: " .. p_u_16._ban_data.BanHistory[1].Reason or (#p_u_16._ban_data.BanHistory > 0 and "This player has a ban history" or "This player has no ban history")
        p_u_16.BanHistoryText.TextColor3 = #p_u_16._ban_data.BanHistory > 0 and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(157, 157, 157)
        p_u_16.BanHistoryText.TextTransparency = #p_u_16._ban_data.BanHistory > 0 and 0 or 0.625
        local v39 = p_u_16.RedFlagsText
        local v40
        if v26 then
            local v41 = v26.Reason
            v40 = "RED FLAG: " .. tostring(v41) or "This player has no red flags"
        else
            v40 = "This player has no red flags"
        end
        v39.Text = v40
        p_u_16.RedFlagsText.TextColor3 = v26 and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(157, 157, 157)
        p_u_16.RedFlagsText.TextTransparency = v26 and 0 or 0.625
        p_u_16.OnlineDot.ImageColor3 = v27 and Color3.fromRGB(100, 255, 50) or Color3.fromRGB(255, 50, 50)
        p_u_16.BanButton.Visible = not v24
        p_u_16.UnbanButton.Visible = v24
        if v31 then
            p_u_16._last_rank_icon = v_u_10.new(v32, p_u_16._ban_data.UserID)
            p_u_16._last_rank_icon:SetParent(p_u_16.PlayerRank)
        end
        task.spawn(function()
            local v42 = v_u_2:GetUserInfosByUserIdsAsync({ p_u_16._ban_data.UserID })
            if v_u_23 == p_u_16._ban_data_hash then
                if v42[1] and v42[1].DisplayName then
                    p_u_16.DisplayNameText.Text = v42[1].DisplayName
                end
            else
                return
            end
        end)
    end
end
function v_u_12.Open(p_u_43, ...)
    v_u_11.Open(p_u_43, ...)
    task.spawn(function()
        p_u_43._cached_players = v_u_1.Remotes.Moderator.RequestCachedPlayers:InvokeServer() or p_u_43._cached_players
    end)
end
function v_u_12._PlayersLookupDropdown(p_u_44)
    if p_u_44._dropdown_slot then
        p_u_44._dropdown_slot:Cancel()
        p_u_44._dropdown_slot = nil
    end
    local v45 = v_u_6:CloneTable(p_u_44._cached_players)
    for _, v46 in pairs(v_u_3:GetPlayers()) do
        if not table.find(v45, string.upper(v46.Name)) then
            local v47 = string.upper
            local v48 = v46.Name
            table.insert(v45, v47(v48))
        end
    end
    table.sort(v45, function(p49, p50)
        return v_u_6:StringLessThan(p49, p50)
    end)
    p_u_44._dropdown_slot = v_u_9.new(p_u_44.DropdownReferenceFrame, v45)
    p_u_44._dropdown_slot.Selected:Connect(function(p51)
        if p51 then
            p_u_44.LookupBox.Text = p51
            task.defer(p_u_44._FetchBanData, p_u_44)
        end
        p_u_44._dropdown_slot = nil
    end)
end
function v_u_12._FetchPlayerData(p52)
    if p52._player_data_debounce then
        return
    else
        p52._player_data_debounce = true
        local v53, v54 = pcall(v_u_1.Remotes.Moderator.RequestPlayerData.InvokeServer, v_u_1.Remotes.Moderator.RequestPlayerData, p52._ban_data.Name)
        p52._player_data_debounce = false
        if v53 then
            if v54 then
                p52.PromptSystem:Open("ViewPlayerData", p52._ban_data.Name, v54)
            else
                p52.PromptSystem:Open("ErrorMessage", "Woops!", "This player has never played RIVALS before!")
            end
        else
            p52.PromptSystem:Open("ErrorMessage", "Woops!", "Something went wrong while fetching their data, error:", (tostring(v54)))
            return
        end
    end
end
function v_u_12._FetchBanData(p55)
    if p55._lookup_disabled then
        return
    else
        p55:SetBanData(nil)
        local v56 = p55.LookupBox.Text
        if #v56 ~= 0 then
            p55._lookup_disabled = true
            p55.WaitingFrame.Visible = true
            p55.DotsFrame:AddTag("UILoadingDots")
            local v57 = v_u_1.Remotes.Moderator.RequestPlayer:InvokeServer(v56) or {}
            p55:SetBanData(table.unpack(v57))
            p55._lookup_disabled = false
            p55.WaitingFrame.Visible = false
            p55.DotsFrame:RemoveTag("UILoadingDots")
        end
    end
end
function v_u_12._Init(p_u_58)
    p_u_58.CloseButton.MouseButton1Click:Connect(function()
        p_u_58:CloseRequest()
    end)
    p_u_58.CheckTop100StreaksButton.MouseButton1Click:Connect(function()
        v_u_1.Remotes.Moderator.CheckTop100Streaks:FireServer()
    end)
    p_u_58.CheckTop100TrueStreaksButton.MouseButton1Click:Connect(function()
        v_u_1.Remotes.Moderator.CheckTop100TrueStreaks:FireServer()
    end)
    p_u_58.LookupButton.MouseButton1Click:Connect(function()
        p_u_58:_FetchBanData()
    end)
    p_u_58.LookupDropdownButton.MouseButton1Click:Connect(function()
        p_u_58:_PlayersLookupDropdown()
    end)
    p_u_58.BanButton.MouseButton1Click:Connect(function()
        p_u_58.PromptSystem:Open("Ban", p_u_58._ban_data)
    end)
    p_u_58.UnbanButton.MouseButton1Click:Connect(function()
        p_u_58.PromptSystem:Open("Unban", p_u_58._ban_data)
    end)
    p_u_58.LogsButton.MouseButton1Click:Connect(function()
        p_u_58.PromptSystem:Open("InspectBanLogs", p_u_58._ban_data)
    end)
    p_u_58.JoinButton.MouseButton1Click:Connect(function()
        v_u_1.Remotes.Moderator.Join:FireServer(p_u_58._ban_data.Name)
    end)
    p_u_58.KickButton.MouseButton1Click:Connect(function()
        p_u_58.PromptSystem:Open("Kick", p_u_58._ban_data)
    end)
    p_u_58.ViewDataButton.MouseButton1Click:Connect(function()
        if p_u_58._player_data then
            p_u_58.PromptSystem:Open("ViewPlayerData", p_u_58._ban_data.Name, p_u_58._player_data)
        else
            p_u_58:_FetchPlayerData()
        end
    end)
    p_u_58.PardonRedFlagsButton.MouseButton1Click:Connect(function()
        p_u_58.PromptSystem:Open("Pardon", p_u_58._ban_data)
    end)
    v_u_1.Remotes.Moderator.UpdateBanData.OnClientEvent:Connect(function(p59)
        p_u_58:SetBanData(p59)
    end)
    p_u_58:SetBanData(nil)
    v_u_7:Add(p_u_58.CloseButton)
    v_u_7:Add(p_u_58.CheckTop100StreaksButton)
    v_u_7:Add(p_u_58.CheckTop100TrueStreaksButton)
    v_u_7:Add(p_u_58.LookupButton)
    v_u_7:Add(p_u_58.LookupDropdownButton)
    v_u_7:Add(p_u_58.BanButton)
    v_u_7:Add(p_u_58.UnbanButton)
    v_u_7:Add(p_u_58.JoinButton)
    v_u_7:Add(p_u_58.KickButton)
    v_u_7:Add(p_u_58.LogsButton)
    v_u_7:Add(p_u_58.ViewDataButton)
    v_u_7:Add(p_u_58.PardonRedFlagsButton)
end
return v_u_12._new()