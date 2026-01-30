local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.CONSTANTS)
local v_u_4 = require(v1.Modules.DuelLibrary)
local v_u_5 = require(v1.Modules.Utility)
local v_u_6 = require(v2.LocalPlayer.PlayerScripts.Controllers.LeaderboardController)
require(v2.LocalPlayer.PlayerScripts.Controllers.ControlsController)
local v_u_7 = require(v2.LocalPlayer.PlayerScripts.Modules.RankIcon)
local v_u_8 = v2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("TeammateSlot")
local v_u_9 = UDim2.new(0.5, 0, 0.5, 0)
local v_u_10 = {}
v_u_10.__index = v_u_10
function v_u_10.new(p11, p12, p13, p14, p15, p16, p17)
    local v18 = v_u_10
    local v19 = setmetatable({}, v18)
    v19.SlotFrame = v_u_8:Clone()
    v19._destroyed = false
    v19._connections = {}
    v19._user_id = p11
    v19._controls = p12
    v19._health_percent = p13 or 1
    v19._disconnected = p14
    v19._hide_health = p15
    if not p16 or (p16 <= 0 or not p16) then
        p16 = nil
    end
    v19._win_streak = p16
    v19._level = p17 or nil
    v19._display_elo_set = false
    v19._display_elo = nil
    v19._rank_icon = nil
    v19._override_icon = nil
    v19._override_icon_size = nil
    v19._override_icon_color = nil
    v19._override_icon_text = nil
    v19._override_icon_text_color = nil
    v19:_Init()
    return v19
end
function v_u_10.SetDetails(p20, p21, p22, p23, p24, p25, p26)
    p20._controls = p21
    p20:SetHealthPercent(p22, true)
    p20:SetDisconnected(p23, true)
    p20._hide_health = p24
    if not p25 or (p25 <= 0 or not p25) then
        p25 = nil
    end
    p20._win_streak = p25
    p20._level = p26 or nil
    p20:_UpdateDetails()
end
function v_u_10.SetDisplayELO(p27, p28)
    p27._display_elo_set = true
    p27._display_elo = p28
    p27:_UpdateRankIcon()
end
function v_u_10.SetDisconnected(p29, p30, p31)
    if p30 then
        p29:OverrideIcon(nil, nil, nil, nil, nil, p31)
    end
    p29._disconnected = p30
    if not p31 then
        p29:_UpdateDetails()
    end
end
function v_u_10.SetHealthPercent(p32, p33, p34)
    p32._health_percent = p33 or 1
    if not p34 then
        p32:_UpdateDetails()
    end
end
function v_u_10.OverrideIcon(p35, p36, p37, p38, p39, p40, p41)
    if not p35._disconnected then
        p35._override_icon = p36
        p35._override_icon_size = p37
        p35._override_icon_color = p38
        p35._override_icon_text = p39
        p35._override_icon_text_color = p40
        if not p41 then
            p35:_UpdateDetails()
        end
    end
end
function v_u_10.SetStaggeredSpawnsTurn(p42, p43, p44)
    if p43 then
        p42:OverrideIcon("rbxassetid://15319354627", UDim2.new(0.75, 0, 0.75, 0), Color3.fromRGB(0, 0, 0), p43, v_u_4:GetTeamColor(p44, Color3.fromRGB(255, 255, 255)))
    else
        p42:OverrideIcon()
    end
end
function v_u_10.Destroy(p_u_45)
    p_u_45._destroyed = true
    for _, v46 in pairs(p_u_45._connections) do
        v46:Disconnect()
    end
    p_u_45._connections = {}
    p_u_45:SetDisplayELO(nil)
    pcall(function()
        p_u_45.SlotFrame:Destroy()
    end)
end
function v_u_10._UpdateRankIcon(p47)
    if p47._rank_icon then
        p47._rank_icon:Destroy()
        p47._rank_icon = nil
    end
    if p47._destroyed or not p47._display_elo_set then
        return
    else
        local v48 = p47.SlotFrame:FindFirstChild("Container")
        if v48 then
            v48 = p47.SlotFrame.Container:FindFirstChild("Rank")
        end
        if v48 then
            p47._rank_icon = v_u_7.new(p47._display_elo, p47._user_id)
            p47._rank_icon:SetParent(v48)
        end
    end
end
function v_u_10._UpdateDetails(p49)
    if not p49._destroyed then
        local v50 = Color3.fromRGB(255, 50, 50):Lerp(Color3.fromRGB(255, 215, 0):Lerp(Color3.fromRGB(100, 255, 50), p49._health_percent), p49._health_percent)
        local v51 = Color3.new(v50.R / 2, v50.G / 2, v50.B / 2)
        local v52 = not p49._disconnected
        if v52 then
            v52 = p49._health_percent > 0
        end
        local v53 = p49.SlotFrame.Container.Health
        local v54
        if v52 then
            v54 = not p49._hide_health
        else
            v54 = v52
        end
        v53.Visible = v54
        p49.SlotFrame.Container.Health.Bar.Size = UDim2.new(p49._health_percent, 0, 1, 0)
        p49.SlotFrame.Container.Health.BackgroundColor3 = v51
        p49.SlotFrame.Container.Health.UIStroke.Color = Color3.new(v50.R * 0.25, v50.G * 0.25, v50.B * 0.25)
        p49.SlotFrame.Container.Health.Bar.BackgroundColor3 = v50
        p49.SlotFrame.Container.Health.Bar.UIStroke.Color = v50
        p49.SlotFrame.Container.Headshot.ImageTransparency = v52 and 0 or 0.75
        p49.SlotFrame.Container.Icon.Visible = not v52
        p49.SlotFrame.Container.Icon.Image = p49._override_icon or (p49._disconnected and "rbxassetid://16782728353" or (v52 and "" or "rbxassetid://16802957270"))
        p49.SlotFrame.Container.Icon.Size = p49._override_icon_size or v_u_9
        p49.SlotFrame.Container.Icon.ImageColor3 = p49._override_icon_color or Color3.fromRGB(255, 255, 255)
        p49.SlotFrame.Container.Icon.TextLabel.Text = p49._override_icon_text or ""
        p49.SlotFrame.Container.Icon.TextLabel.TextColor3 = p49._override_icon_text_color or Color3.fromRGB(0, 0, 0)
        p49.SlotFrame.Container.Controls.Image = v52 and (not p49._win_streak and p49._controls) and (v_u_3.CONTROLS_IMAGES[p49._controls] or "") or ""
        local v55 = p49.SlotFrame.Container.Streak
        local v56 = v52 and p49._win_streak
        if v56 then
            v56 = p49._win_streak > 0
        end
        v55.Visible = v56
        p49.SlotFrame.Container.Streak.Value.Text = v_u_5:PrettyNumber(p49._win_streak or 0)
        local v57 = p49.SlotFrame.Container.Level
        local v58
        if v52 then
            v58 = p49._level
        else
            v58 = v52
        end
        v57.Visible = v58
        p49.SlotFrame.Container.Level.Title.Text = v_u_5:PrettyNumber(p49._level or 0)
        p49.SlotFrame.Container.Rank.Visible = v52
    end
end
function v_u_10._Setup(p59)
    p59.SlotFrame.Container.Headshot.Image = string.format(v_u_3.HEADSHOT_IMAGE, p59._user_id)
end
function v_u_10._Init(p_u_60)
    local v61 = p_u_60._connections
    local v62 = v_u_6:GetLeaderboardRefreshedSignal("Highest ELO")
    table.insert(v61, v62:Connect(function()
        p_u_60:_UpdateRankIcon()
    end))
    p_u_60.SlotFrame.Destroying:Connect(function()
        p_u_60:Destroy()
    end)
    p_u_60:_Setup()
    p_u_60:_UpdateDetails()
end
return v_u_10