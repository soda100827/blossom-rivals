local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("RunService")
local v_u_3 = game:GetService("GuiService")
local v4 = game:GetService("Players")
local v_u_5 = require(v1.Modules.DuelLibrary)
local v_u_6 = require(v1.Modules.ItemLibrary)
local v_u_7 = require(v1.Modules.Utility)
local v_u_8 = require(v1.Modules.Signal)
local v_u_9 = require(v4.LocalPlayer.PlayerScripts.Controllers.ComplianceController)
local v_u_10 = require(v4.LocalPlayer.PlayerScripts.Controllers.SpectateController)
require(v4.LocalPlayer.PlayerScripts.Modules.ButtonEffect)
local v_u_11 = require(v4.LocalPlayer.PlayerScripts.Modules.TeammateSlot)
local v_u_12 = require(v4.LocalPlayer.PlayerScripts.Modules.RankIcon)
local v_u_13 = v4.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("ScoreboardPlayerSlot")
local v_u_14 = v4.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("BanIcon")
local v_u_15 = {}
v_u_15.__index = v_u_15
function v_u_15.new(p16)
    local v17 = v_u_15
    local v18 = setmetatable({}, v17)
    v18.VisibilityChanged = v_u_8.new()
    v18.DuelInterface = p16
    v18.Frame = v18.DuelInterface.Frame:WaitForChild("Scoreboard")
    v18.Container = v18.Frame:WaitForChild("Container")
    v18.TopFrame = v18.Container:WaitForChild("Top")
    v18.TopBackground = v18.TopFrame:WaitForChild("Background")
    v18.TopText = v18.TopFrame:WaitForChild("Score")
    v18.BottomFrame = v18.Container:WaitForChild("Bottom")
    v18.BottomBackground = v18.BottomFrame:WaitForChild("Background")
    v18.BottomInformationText = v18.BottomFrame:WaitForChild("Information")
    v18.ButtonsFrame = v18.Container:WaitForChild("Buttons")
    v18.ButtonsContainer = v18.ButtonsFrame:WaitForChild("Container")
    v18.BannedWeaponsFrame = v18.Container:WaitForChild("BannedWeapons")
    v18.BannedWeaponsContainer = v18.BannedWeaponsFrame:WaitForChild("Container")
    v18._destroyed = false
    v18._scoreboard_open = false
    v18._scoreboard_player_slots = {}
    v18._scoreboard_local_player_slot = nil
    v18._local_player_ping_connection = nil
    v18._neutral_team_color_index = 0
    v18._banned_weapons = {}
    v18:_Init()
    return v18
end
function v_u_15.IsOpen(p19)
    local v20 = not p19._destroyed
    if v20 then
        v20 = p19.Frame.Visible
    end
    return v20
end
function v_u_15.Open(p21, p22)
    if not p21._destroyed then
        if p22 == nil then
            p22 = p21._scoreboard_open
        end
        p21._scoreboard_open = p22
        local v23 = p21.Frame
        local v24 = p21._scoreboard_open and not p21.DuelInterface:IsPageOpen() and not (p21.DuelInterface.Voting:IsOpen() or p21.DuelInterface.FinalResults:IsActive())
        if v24 then
            v24 = p21.DuelInterface.ClientDuel:Get("Status") ~= "GameOver"
        end
        v23.Visible = v24
        p21.VisibilityChanged:Fire()
        p21:Generate()
    end
end
function v_u_15.UpdatePreferredTransparency(p25)
    local v26 = 0 + 0.25 * v_u_3.PreferredTransparency
    p25.TopBackground.ImageTransparency = v26
    p25.BottomBackground.ImageTransparency = v26
    p25:Generate()
end
function v_u_15.Generate(p_u_27)
    for _, v28 in pairs(p_u_27._scoreboard_player_slots) do
        v28:Destroy()
    end
    for _, v29 in pairs(p_u_27._banned_weapons) do
        v29:Destroy()
    end
    p_u_27._banned_weapons = {}
    p_u_27._scoreboard_player_slots = {}
    p_u_27._scoreboard_local_player_slot = nil
    p_u_27._neutral_team_color_index = 0
    if p_u_27._local_player_ping_connection then
        p_u_27._local_player_ping_connection:Disconnect()
        p_u_27._local_player_ping_connection = nil
    end
    if p_u_27.Frame.Visible then
        local v30 = v_u_10.CurrentSubject
        local v31
        if v30 then
            v31 = v30:Get("WeaponPool")
        else
            v31 = v30
        end
        if v30 then
            v30 = v30:Get("WeaponPoolFilterType")
        end
        if v30 == "Blacklist" and #v31 > 0 then
            p_u_27.BannedWeaponsFrame.Visible = true
            for v32, v33 in pairs(v31) do
                local v34 = v_u_14:Clone()
                v34.ImageColor3 = Color3.fromRGB(127, 25, 25)
                v34.Icon.ImageColor3 = Color3.fromRGB(255, 50, 50)
                v34.LayoutOrder = v32
                v34.Weapon.Icon.Image = v_u_6.ViewModels[v33].ImageCentered or v_u_6.Items[v33].Image
                v34.Weapon.ZIndex = 10
                v34.Weapon.Visible = true
                v34.Parent = p_u_27.BannedWeaponsContainer
                local v35 = p_u_27._banned_weapons
                table.insert(v35, v34)
            end
        else
            p_u_27.BannedWeaponsFrame.Visible = false
        end
        local v36 = p_u_27.DuelInterface.ClientDuel:Get("PlaySourceName")
        if v36 then
            v36 = v_u_5.PlaySources[v36].DisplayName
        end
        local v37 = p_u_27.DuelInterface.ClientDuel.Map
        if v37 then
            v37 = p_u_27.DuelInterface.ClientDuel.Map.Name
        end
        local v38 = p_u_27.DuelInterface.ClientDuel.Map
        if v38 then
            v38 = p_u_27.DuelInterface.ClientDuel.Map:GetScoreboardDisplay()
        end
        local v39 = p_u_27.BottomInformationText
        if v38 then
            v37 = v38
        elseif (not v37 or (not v36 or v37 ~= v36)) and (not v37 or v36) then
            if v36 and v37 then
                v37 = string.format("%s   \226\128\162   %s", v36, v37)
            else
                v37 = (not v36 or v37) and "" or v36
            end
        end
        v39.Text = v37
        local v40 = NumberSequence.new(0, 0 + 0.25 * v_u_3.PreferredTransparency)
        for v41, v42 in pairs(p_u_27.DuelInterface:GetLoggedClientDuelers(true)) do
            local v43 = v42:Get("TeamID")
            local v44 = v42.ClientFighter:Get("Controls")
            local v45 = table.find(p_u_27.DuelInterface.ClientDuel.Duelers, v42)
            local v46 = v42:GetHealth() / v42:GetMaxHealth()
            local v47 = v42:Get("Damage") + 0.5
            local v48 = math.floor(v47)
            local v49
            if p_u_27.DuelInterface.ClientDuel.IsRanked or (p_u_27.DuelInterface.ClientDuel:Get("ScoresBehavior") ~= "Teams" or p_u_27.DuelInterface.ClientDuel:Get("ScoreNeededToWin")) then
                v49 = nil
            else
                v49 = v42.Player:GetAttribute("StatisticDuelsWinStreak")
            end
            local v50 = v42.Player:GetAttribute("Level")
            local v51
            if p_u_27.DuelInterface.ClientDuel:Get("ScoresBehavior") == "Duelers" then
                v51 = p_u_27.DuelInterface.ClientDuel:Get("Scores")[v42:Get("DuelerID")]
            else
                v51 = false
            end
            local v52 = v_u_7:SanitizeName(v42.Player.Name)
            local v53 = v_u_13:Clone()
            v53.UIGradient.Transparency = v40
            v53.BackgroundColor3 = p_u_27:_GetTeamColor(v43)
            v53.Username.Text = v42.Player.DisplayName == v52 and "" or "@" .. v52
            v53.DisplayName.Text = v_u_9:GetName(v42.Player)
            v53.DisplayName.Position = v53.Username.Text == "" and UDim2.new(0.1, 0, 0.5, 0) or UDim2.new(0.1, 0, 0.375, 0)
            v53.Eliminations.Text = v_u_7:PrettyNumber(v42:Get("Eliminations"))
            v53.Deaths.Text = v_u_7:PrettyNumber(v42:Get("Deaths"))
            v53.Assists.Text = v_u_7:PrettyNumber(v42:Get("Assists"))
            v53.ConnectionLevel.Icon.Image = v_u_7:GetConnectionLevelIcon(v42.ClientFighter:Get("ConnectionLevel")) or ""
            v53.ConnectionLevel.Position = v42.IsLocalPlayer and UDim2.new(0.925, 0, 0.55, 0) or UDim2.new(0.925, 0, 0.5, 0)
            v53.ConnectionLevel.AnchorPoint = v42.IsLocalPlayer and Vector2.new(0.5, 1) or Vector2.new(0.5, 0.5)
            v53.Ping.Visible = v42.IsLocalPlayer
            v53.LayoutOrder = v41
            v53.Score.Text = v51 and v_u_7:PrettyNumber(v51) or v_u_7:PrettyNumber(v48)
            v53.Weapon.Image = ""
            local v54 = v_u_11.new(v42.Player.UserId, v44, v46, not v45, true, v49, v50)
            v54.SlotFrame.Parent = v53.Container
            if v42:GetStaggeredSpawnsTurn() then
                v54:SetStaggeredSpawnsTurn(v42:GetStaggeredSpawnsTurn(), v43)
            end
            if p_u_27.DuelInterface.ClientDuel.IsRanked then
                v_u_12.new(v42.Player:GetAttribute("DisplayELO"), v42.Player.UserId):SetParent(v53.Rank)
            end
            v53.Parent = p_u_27.Container
            local v55 = p_u_27._scoreboard_player_slots
            table.insert(v55, v53)
            if v42.IsLocalPlayer then
                p_u_27._scoreboard_local_player_slot = v53
            end
        end
        p_u_27._local_player_ping_connection = v_u_2.RenderStepped:Connect(function()
            p_u_27:_UpdateLocalPlayerPing()
        end)
        p_u_27:_UpdateLocalPlayerPing()
    end
end
function v_u_15.Destroy(p56)
    p56._destroyed = true
    if p56._local_player_ping_connection then
        p56._local_player_ping_connection:Disconnect()
        p56._local_player_ping_connection = nil
    end
    p56.VisibilityChanged:Destroy()
end
function v_u_15._UpdateButtonsVisibility(p57)
    p57.ButtonsFrame.Visible = #p57.ButtonsContainer:GetChildren() > 0
end
function v_u_15._GetTeamColor(p58, p59)
    local v60 = v_u_5:GetTeamColor(p59)
    if p59 then
        return v60
    end
    local v61, v62, v63 = v60:ToHSV()
    p58._neutral_team_color_index = p58._neutral_team_color_index + 1
    local v64 = v63 - (p58._neutral_team_color_index % 2 == 0 and 0.05 or 0)
    return Color3.fromHSV(v61, v62, v64)
end
function v_u_15._UpdateLocalPlayerPing(p65)
    if p65._scoreboard_local_player_slot then
        local v66 = v_u_7:GetLocalConnectionPing()
        local v67 = v_u_7:GetConnectionLevelIcon((v_u_7:GetConnectionLevel(v66)))
        p65._scoreboard_local_player_slot.Ping.Text = v66
        p65._scoreboard_local_player_slot.ConnectionLevel.Icon.Image = v67 or ""
    end
end
function v_u_15._Setup(p68)
    p68.TopText.Text = p68.DuelInterface.ClientDuel:Get("ScoresBehavior") == "Duelers" and "POINTS" or "DMG"
end
function v_u_15._Init(p_u_69)
    p_u_69.DuelInterface.FinalResults.Activated:Connect(function()
        p_u_69:Open(nil)
    end)
    p_u_69.DuelInterface.Voting.VisibilityChanged:Connect(function()
        p_u_69:Open(nil)
    end)
    p_u_69.ButtonsContainer.ChildAdded:Connect(function()
        p_u_69:_UpdateButtonsVisibility()
    end)
    p_u_69.ButtonsContainer.ChildRemoved:Connect(function()
        p_u_69:_UpdateButtonsVisibility()
    end)
    p_u_69:_Setup()
    p_u_69:_UpdateButtonsVisibility()
end
return v_u_15