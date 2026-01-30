local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("Players")
local v3 = require(v1.Modules.CONSTANTS)
local v_u_4 = require(v1.Modules.Utility)
local v_u_5 = require(v1.Modules.Emote)
local v_u_6 = v3.IS_CLIENT
if v_u_6 then
    v_u_6 = require(v_u_2.LocalPlayer.PlayerScripts.Modules.RankIcon)
end
local v_u_7 = setmetatable({}, v_u_5)
v_u_7.__index = v_u_7
function v_u_7.new(...)
    local v8 = v_u_5.new(nil, script.Name, ...)
    local v9 = v_u_7
    local v10 = setmetatable(v8, v9)
    v10:_Init()
    return v10
end
function v_u_7.PlayClient(p11, ...)
    v_u_5.PlayClient(p11, ...)
    p11:_PlayAnimation("rbxassetid://110098633210491", "rbxassetid://125433333048429", 4.85)
    local v12 = p11._humanoid and p11._humanoid.Parent
    if v12 then
        v12 = v_u_2:GetPlayerFromCharacter(p11._humanoid.Parent)
    end
    local v13
    if v12 then
        v13 = v12:GetAttribute("StatisticDuelsWinStreak")
    else
        v13 = v12
    end
    local v14
    if v12 then
        v14 = v12:GetAttribute("Level")
    else
        v14 = v12
    end
    local v15
    if v12 then
        v15 = v12:GetAttribute("DisplayELO")
    else
        v15 = v12
    end
    if v12 then
        v12 = v12.UserId
    end
    local v16 = p11:_SetupMultipleProps(script.FlexProp)
    v16.Pillow1.Attachment.BillboardGui.Streak.Value.Text = v_u_4:PrettyNumber(v13 or 0)
    v16.Pillow2.Attachment.BillboardGui.Level.Title.Text = v_u_4:PrettyNumber(v14 or 1)
    v_u_6.new(v15, v12):SetParent(v16.Pillow3.Attachment.BillboardGui.Rank)
    p11:CreateSound("rbxassetid://97330697628857", 0.75, 1, nil, true)
end
function v_u_7._Init(_) end
return v_u_7