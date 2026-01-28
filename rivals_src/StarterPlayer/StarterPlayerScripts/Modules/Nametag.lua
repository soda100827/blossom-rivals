local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.CONSTANTS)
local v_u_4 = require(v1.Modules.Utility)
local v_u_5 = require(v2.LocalPlayer.PlayerScripts.Controllers.ComplianceController)
local v_u_6 = require(v2.LocalPlayer.PlayerScripts.Modules.WeaponStatusHandler)
local v_u_7 = require(v2.LocalPlayer.PlayerScripts.Modules.RankIcon)
local v_u_8 = v2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("Nametag")
local v_u_9 = {}
v_u_9.__index = v_u_9
function v_u_9.new(p10, p11, p12, p13, p14, p15)
    local v16 = v_u_9
    local v17 = setmetatable({}, v16)
    v17.BillboardGui = v_u_8:Clone()
    v17._player_object = p10
    v17._controls = p11
    v17._win_streak = p12 or 0
    v17._level = p13 or 0
    v17._elo = p14
    v17._status = p15
    v17._rank_icon = nil
    v17:_Init()
    return v17
end
function v_u_9.GetWinStreak(p18)
    return p18._win_streak
end
function v_u_9.SetParent(p19, p20)
    p19.BillboardGui.Parent = p20
    p19:_UpdatePosition()
end
function v_u_9.Destroy(p21)
    v_u_6:ClearStatusElements(p21.BillboardGui.Frame.Player.Username)
    v_u_6:ClearStatusElements(p21.BillboardGui.Frame.Player)
    p21.BillboardGui:Destroy()
    if p21._rank_icon then
        p21._rank_icon:Destroy()
    end
end
function v_u_9._UpdatePosition(p22)
    p22.BillboardGui.Frame.Player.Controls.Position = UDim2.new(0.5, p22.BillboardGui.Frame.Player.TextBounds.X / 2 * p22.BillboardGui.Frame.Player.AbsoluteSize.Y / p22.BillboardGui.Frame.Player.TextBounds.Y, 0.5, 0)
    p22.BillboardGui.Frame.Player.Level.Position = UDim2.new(0.5, -p22.BillboardGui.Frame.Player.TextBounds.X / 2 * p22.BillboardGui.Frame.Player.AbsoluteSize.Y / p22.BillboardGui.Frame.Player.TextBounds.Y, 0.5, 0)
    p22.BillboardGui.Frame.Player.Rank.Position = p22.BillboardGui.Frame.Player.Level.Position
end
function v_u_9._Setup(p23)
    local v24 = v_u_4:SanitizeName(p23._player_object.Name)
    p23.BillboardGui.Frame.Player.Username.Text = p23._player_object.DisplayName == v24 and "" or "@" .. v24
    p23.BillboardGui.Frame.Player.Text = v_u_5:GetName(p23._player_object)
    p23.BillboardGui.Frame.Player.Controls.Image = v_u_3.CONTROLS_IMAGES[p23._controls] or ""
    p23.BillboardGui.Frame.Streak.Value.Text = p23._win_streak == 0 and "" or v_u_4:PrettyNumber(p23._win_streak)
    p23.BillboardGui.Frame.Streak.Visible = p23._win_streak > 0
    p23.BillboardGui.Frame.Player.Level.Title.Text = v_u_4:PrettyNumber(p23._level)
    local v25 = p23.BillboardGui.Frame.Player.Level
    local v26
    if p23._level > 0 then
        v26 = not p23._elo
    else
        v26 = false
    end
    v25.Visible = v26
    v_u_6:ApplyItemStatusToText(p23.BillboardGui.Frame.Player, p23._status)
    if p23._elo then
        p23._rank_icon = v_u_7.new(p23._elo, p23._player_object.UserId)
        p23._rank_icon:SetParent(p23.BillboardGui.Frame.Player.Rank)
    end
end
function v_u_9._Init(p_u_27)
    p_u_27.BillboardGui.Frame.Player:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        p_u_27:_UpdatePosition()
    end)
    p_u_27.BillboardGui.Frame.Player:GetPropertyChangedSignal("TextBounds"):Connect(function()
        p_u_27:_UpdatePosition()
    end)
    task.spawn(p_u_27._Setup, p_u_27)
    p_u_27:_UpdatePosition()
end
return v_u_9