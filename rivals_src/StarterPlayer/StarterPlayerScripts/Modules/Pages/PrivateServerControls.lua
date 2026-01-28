local v_u_1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("Players")
local v_u_3 = require(v_u_1.Modules.CONSTANTS)
local v_u_4 = require(v_u_1.Modules.SettingsInfo)
local v_u_5 = require(v_u_1.Modules.DuelLibrary)
require(v_u_1.Modules.Utility)
local v_u_6 = require(v_u_2.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PrivateServerController"))
require(v_u_2.LocalPlayer.PlayerScripts.Controllers:WaitForChild("ComplianceController"))
local v_u_7 = require(v_u_2.LocalPlayer.PlayerScripts.Controllers:WaitForChild("FighterController"))
local v_u_8 = require(v_u_2.LocalPlayer.PlayerScripts.Controllers:WaitForChild("ArcadeController"))
local v_u_9 = require(v_u_2.LocalPlayer.PlayerScripts.Modules:WaitForChild("Settings"):WaitForChild("DropdownConfirm"))
local v_u_10 = require(v_u_2.LocalPlayer.PlayerScripts.Modules:WaitForChild("Settings"):WaitForChild("Confirm"))
local v_u_11 = require(v_u_2.LocalPlayer.PlayerScripts.Modules:WaitForChild("Settings"):WaitForChild("Toggle"))
local v_u_12 = require(v_u_2.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect"))
local v_u_13 = require(v_u_2.LocalPlayer.PlayerScripts.Modules:WaitForChild("Page"))
local v_u_14 = v_u_2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("PrivateServerPlayerSlot")
local v_u_15 = setmetatable({}, v_u_13)
v_u_15.__index = v_u_15
function v_u_15._new()
    local v16 = v_u_13.new(script.Name)
    local v17 = v_u_15
    local v18 = setmetatable(v16, v17)
    v18.CloseButton = v18.PageFrame:WaitForChild("Close")
    v18.LockedFrame = v18.PageFrame:WaitForChild("Locked")
    v18.List = v18.PageFrame:WaitForChild("List")
    v18.Container = v18.List:WaitForChild("Container")
    v18.Layout = v18.Container:WaitForChild("Layout")
    v18.UseLockedWeaponsFrame = v18.Container:WaitForChild("UseLockedWeapons")
    v18.UseLockedWeaponsTemplate = v18.UseLockedWeaponsFrame:WaitForChild("Template")
    v18.ShootingRangePVPFrame = v18.Container:WaitForChild("ShootingRangePVP")
    v18.ShootingRangePVPTemplate = v18.ShootingRangePVPFrame:WaitForChild("Template")
    v18.FreecamEnabledFrame = v18.Container:WaitForChild("FreecamEnabled")
    v18.FreecamEnabledTemplate = v18.FreecamEnabledFrame:WaitForChild("Template")
    v18.ArcadeStartFrame = v18.Container:WaitForChild("ArcadeStart")
    v18.ArcadeStartTemplate = v18.ArcadeStartFrame:WaitForChild("Template")
    v18.ArcadeEndFrame = v18.Container:WaitForChild("ArcadeEnd")
    v18.ArcadeEndTemplate = v18.ArcadeEndFrame:WaitForChild("Template")
    v18.PlayersFrame = v18.Container:WaitForChild("Players")
    v18.PlayersContainer = v18.PlayersFrame:WaitForChild("Container")
    v18.PlayersLayout = v18.PlayersContainer:WaitForChild("Layout")
    v18.BannedPlayersFrame = v18.Container:WaitForChild("BannedPlayers")
    v18.BannedPlayersContainer = v18.BannedPlayersFrame:WaitForChild("Container")
    v18.BannedPlayersLayout = v18.BannedPlayersContainer:WaitForChild("Layout")
    v18.UseLockedWeaponsSetting = v_u_11.new(v_u_4.new("", "", "Use Locked Weapons", "rbxassetid://17229230506", "Allows all players to use locked weapons in duels", "Toggle", true), v18.UseLockedWeaponsTemplate)
    v18.ShootingRangePVPSetting = v_u_11.new(v_u_4.new("", "", "Shooting Range PVP", "rbxassetid://119084789924359", "Allows you to battle each other in the Shooting Range", "Toggle", false), v18.ShootingRangePVPTemplate)
    v18.FreecamEnabledSetting = v_u_11.new(v_u_4.new("", "", "Freecam Enabled", "rbxassetid://17548980857", "Allows all players to use freecam by pressing [Shift] + [P]", "Toggle", true), v18.FreecamEnabledTemplate)
    v18.ArcadeStartSetting = v_u_9.new(v_u_4.new("", "", "Private Arcade", "rbxassetid://81276179444570", "Launch a private Arcade duel", "DropdownConfirm", v18:_GetArcadeModeDisplayNames()[1], v18:_GetArcadeModeDisplayNames()), v18.ArcadeStartTemplate)
    v18.ArcadeEndSetting = v_u_10.new(v_u_4.new("", "", "Private Arcade", "rbxassetid://81276179444570", "End the private Arcade duel", "Confirm", false), v18.ArcadeEndTemplate)
    v18._player_slots = {}
    v18._arcade_mode_display_names = nil
    v18._to_arcade_mode_name = nil
    v18:_Init()
    return v18
end
function v_u_15.Open(p19, ...)
    v_u_13.Open(p19, ...)
    p19:_UpdatePlayers()
    p19:_UpdateArcadeStatus()
end
function v_u_15._GetArcadeModeDisplayNames(p20)
    if not p20._arcade_mode_display_names then
        p20._arcade_mode_display_names = {}
        p20._to_arcade_mode_name = {}
        for _, v21 in pairs(v_u_5.ArcadeModeOrder) do
            local v22 = v_u_5.ArcadeModes[v21].DisplayName
            local v23 = p20._arcade_mode_display_names
            local v24 = v_u_5.ArcadeModes[v21].DisplayName
            table.insert(v23, v24)
            p20._to_arcade_mode_name[v22] = v21
        end
    end
    return p20._arcade_mode_display_names
end
function v_u_15._UpdateArcadeStatus(p25)
    if p25:IsOpen() then
        p25.ArcadeStartFrame.Visible = v_u_8.CurrentDuel == nil
        p25.ArcadeEndFrame.Visible = not p25.ArcadeStartFrame.Visible
    end
end
function v_u_15._CreatePlayerSlot(p26, p27, p28, p29, p30, p31, p32, p33, p34)
    local v_u_35 = v_u_14:Clone()
    v_u_35.Kick.Visible = p32
    v_u_35.Ban.Visible = p33
    v_u_35.Unban.Visible = p34
    v_u_35.Icon.Image = string.format(v_u_3.HEADSHOT_IMAGE, p29)
    v_u_35.DisplayName.Controls.Image = ""
    v_u_35.DisplayName.Text = p30
    v_u_35.Username.Text = "@" .. p31
    v_u_35.LayoutOrder = p27
    v_u_35.Parent = p28
    local v36 = p26._player_slots
    table.insert(v36, v_u_35)
    v_u_12:Add(v_u_35.Kick)
    v_u_12:Add(v_u_35.Ban)
    v_u_12:Add(v_u_35.Unban)
    v_u_35.DisplayName:GetPropertyChangedSignal("TextBounds"):Connect(function()
        v_u_35.DisplayName.Controls.Position = UDim2.new(0, v_u_35.DisplayName.TextBounds.X, 0.5, 0)
    end)
    v_u_35.DisplayName.Controls.Position = UDim2.new(0, v_u_35.DisplayName.TextBounds.X, 0.5, 0)
    return v_u_35
end
function v_u_15._UpdatePlayers(p37)
    for _, v38 in pairs(p37._player_slots) do
        v38:Destroy()
    end
    p37._player_slots = {}
    if p37:IsOpen() then
        for v39, v_u_40 in pairs(v_u_7.Objects) do
            if v_u_3.IS_STUDIO or v_u_40.Player ~= v_u_2.LocalPlayer then
                local v41 = p37:_CreatePlayerSlot(v39, p37.PlayersContainer, v_u_40.Player.UserId, v_u_40.Player.DisplayName, v_u_40.Player.Name, v_u_3.IS_STUDIO or v_u_40.Player ~= v_u_2.LocalPlayer, true, false)
                v41.Kick.MouseButton1Click:Connect(function()
                    v_u_1.Remotes.PrivateServer.KickPlayer:FireServer(v_u_40.Player)
                end)
                v41.Ban.MouseButton1Click:Connect(function()
                    v_u_1.Remotes.PrivateServer.BanPlayer:FireServer(v_u_40.Player)
                end)
            end
        end
        for v42, v43 in pairs(v_u_6.BannedPlayers) do
            local v_u_44, v45, v46 = table.unpack(v43)
            p37:_CreatePlayerSlot(v42, p37.BannedPlayersContainer, v_u_44, v45, v46, false, false, true).Unban.MouseButton1Click:Connect(function()
                v_u_1.Remotes.PrivateServer.UnbanPlayer:FireServer(v_u_44)
            end)
        end
    end
end
function v_u_15._Setup(p47)
    local v48 = v_u_3.IS_PRIVATE_SERVER_OWNER(v_u_2.LocalPlayer.UserId)
    p47.LockedFrame.Visible = not v48
    p47.List.Visible = v48
    p47.UseLockedWeaponsTemplate:Destroy()
    p47.UseLockedWeaponsSetting.SettingFrame.Parent = p47.UseLockedWeaponsFrame
    p47.ShootingRangePVPTemplate:Destroy()
    p47.ShootingRangePVPSetting.SettingFrame.Parent = p47.ShootingRangePVPFrame
    p47.FreecamEnabledTemplate:Destroy()
    p47.FreecamEnabledSetting.SettingFrame.Parent = p47.FreecamEnabledFrame
    p47.ArcadeStartTemplate:Destroy()
    p47.ArcadeStartSetting.SettingFrame.Parent = p47.ArcadeStartFrame
    p47.ArcadeEndTemplate:Destroy()
    p47.ArcadeEndSetting.SettingFrame.Parent = p47.ArcadeEndFrame
end
function v_u_15._Init(p_u_49)
    p_u_49.CloseButton.MouseButton1Click:Connect(function()
        p_u_49:CloseRequest()
    end)
    p_u_49.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p_u_49.List.CanvasSize = UDim2.new(0, 0, 0, p_u_49.Layout.AbsoluteContentSize.Y)
        p_u_49.List.Active = p_u_49.Layout.AbsoluteContentSize.Y >= p_u_49.List.AbsoluteSize.Y
    end)
    p_u_49.PlayersLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p_u_49.PlayersFrame.Size = UDim2.new(1, 0, 0, p_u_49.PlayersLayout.AbsoluteContentSize.Y)
    end)
    p_u_49.PlayersFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        p_u_49.PlayersFrame.Visible = p_u_49.PlayersFrame.AbsoluteSize.Y > 0
    end)
    p_u_49.BannedPlayersLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p_u_49.BannedPlayersFrame.Size = UDim2.new(1, 0, 0, p_u_49.BannedPlayersLayout.AbsoluteContentSize.Y)
    end)
    p_u_49.BannedPlayersFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        p_u_49.BannedPlayersFrame.Visible = p_u_49.BannedPlayersFrame.AbsoluteSize.Y > 0
    end)
    p_u_49.UseLockedWeaponsSetting.Replicate:Connect(function()
        v_u_1.Remotes.PrivateServer.SetUseLockedWeapons:FireServer(p_u_49.UseLockedWeaponsSetting.Value or false)
    end)
    p_u_49.ShootingRangePVPSetting.Replicate:Connect(function()
        v_u_1.Remotes.PrivateServer.SetShootingRangePVP:FireServer(p_u_49.ShootingRangePVPSetting.Value or false)
    end)
    p_u_49.FreecamEnabledSetting.Replicate:Connect(function()
        v_u_1.Remotes.PrivateServer.SetFreecamEnabled:FireServer(p_u_49.FreecamEnabledSetting.Value or false)
    end)
    p_u_49.ArcadeStartSetting.Replicate:Connect(function()
        p_u_49:_GetArcadeModeDisplayNames()
        v_u_1.Remotes.PrivateServer.StartArcadeMode:FireServer(p_u_49._to_arcade_mode_name[p_u_49.ArcadeStartSetting.Value])
    end)
    p_u_49.ArcadeEndSetting.Replicate:Connect(function()
        v_u_1.Remotes.PrivateServer.EndArcadeMode:FireServer()
    end)
    v_u_7.ObjectAdded:Connect(function()
        p_u_49:_UpdatePlayers()
    end)
    v_u_7.ObjectRemoved:Connect(function()
        p_u_49:_UpdatePlayers()
    end)
    v_u_6.BannedPlayersChanged:Connect(function()
        p_u_49:_UpdatePlayers()
    end)
    v_u_8.DuelSet:Connect(function()
        p_u_49:_UpdateArcadeStatus()
    end)
    p_u_49:_Setup()
    v_u_12:Add(p_u_49.CloseButton)
end
return v_u_15._new()