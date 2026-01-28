local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.SeasonLibrary)
local v_u_4 = require(v1.Modules.Utility)
local v_u_5 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect"))
local v_u_6 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("RankIcon"))
local v_u_7 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("Prompt"))
local v_u_8 = v2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("RankGraphSlot")
local v_u_9 = setmetatable({}, v_u_7)
v_u_9.__index = v_u_9
function v_u_9.new(_, _)
    local v10 = v_u_7.new(script.Name)
    local v11 = v_u_9
    local v12 = setmetatable(v10, v11)
    v12.CloseButton = v12.PromptFrame:WaitForChild("Close")
    v12.List = v12.PromptFrame:WaitForChild("List")
    v12.Container = v12.List:WaitForChild("Container")
    v12.Layout = v12.Container:WaitForChild("Layout")
    v12.ELOShieldMaxELOAllowedText = v12.Container:WaitForChild("ELOShieldMaxELOAllowed")
    v12.ELODecayPeriodText = v12.Container:WaitForChild("ELODecayPeriod")
    v12.ELODecayAmountText = v12.Container:WaitForChild("ELODecayAmount")
    v12.RanksFrame = v12.Container:WaitForChild("Ranks")
    v12.RanksContainer = v12.RanksFrame:WaitForChild("Container")
    v12._rank_icons = {}
    v12:_Init()
    return v12
end
function v_u_9.Destroy(p13)
    for _, v14 in pairs(p13._rank_icons) do
        v14:Destroy()
    end
    v_u_7.Destroy(p13)
end
function v_u_9._UpdateList(p15)
    p15.List.CanvasSize = UDim2.new(0, 0, 0, p15.Layout.AbsoluteContentSize.Y)
    p15.List.ClipsDescendants = true
end
function v_u_9._GetELORange(_, p16)
    local v17 = v_u_3.CurrentSeason.RankProfile.Ranks[v_u_3.CurrentSeason.RankProfile.Groups[p16].Ranks[1]].RequiredELOLeaderboardRanking
    if v17 then
        return "Top " .. v_u_4:PrettyNumber(v17)
    end
    local v18 = nil
    local v19 = nil
    for _, v20 in pairs(v_u_3.CurrentSeason.RankProfile.RanksOrder) do
        local v21 = v_u_3.CurrentSeason.RankProfile.Ranks[v20]
        if v18 or v21.RankGroupName ~= p16 then
            if v18 and v21.RankGroupName ~= p16 then
                v19 = v21.RequiredELO - 1
                break
            end
        else
            v18 = v21.RequiredELO
        end
    end
    if v18 then
        if v19 then
            return v_u_4:PrettyNumber(v18) .. "+"
        else
            return v_u_4:PrettyNumber(v18) .. "+"
        end
    else
        return ""
    end
end
function v_u_9._Setup(p22)
    local v23 = #v_u_3.CurrentSeason.RankProfile.GroupsOrder - 1
    for v24, v25 in pairs(v_u_3.CurrentSeason.RankProfile.GroupsOrder) do
        if v24 ~= 1 then
            local v26 = v_u_3.CurrentSeason.RankProfile.Groups[v25]
            local v27 = v26.Color
            local v28 = v26.SecondaryColor
            local v29 = v26.SecondaryColor ~= Color3.fromRGB(0, 0, 0)
            local v30 = v_u_8:Clone()
            v30.Bar.Title.Text = v25
            local v31 = v30.Bar.Background
            if not v29 then
                v28 = v27
            end
            v31.ImageColor3 = v28
            v30.Bar.BackgroundStriped.ImageColor3 = v27
            v30.Bar.BackgroundStriped.Visible = v29
            v30.Bar.Rank.ELO.UIStroke.Color = Color3.new(v26.Color.R * 0.25, v26.Color.G * 0.25, v26.Color.B * 0.25)
            v30.Bar.Rank.ELO.Text = p22:_GetELORange(v25)
            v30.Bar.Size = UDim2.new(0.9, 0, 0.3 + 0.5 * (v24 - 2) / (v23 - 1), 0)
            v30.Size = UDim2.new(1 / v23, 0, 1, 0)
            v30.LayoutOrder = v24
            v30.ZIndex = v24
            v30.Parent = p22.RanksContainer
            local v32 = v_u_3.CurrentSeason.RankProfile.Ranks[v26.Ranks[#v26.Ranks]]
            local v33 = v_u_6.new(v32.RequiredELO, nil, v32.RequiredELOLeaderboardRanking or (1 / 0))
            v33:SetParent(v30.Bar.Rank)
            local v34 = p22._rank_icons
            table.insert(v34, v33)
        end
    end
    p22.ELOShieldMaxELOAllowedText.Visible = v_u_3.CurrentSeason.ELOShieldMaxELOAllowed or false
    p22.ELOShieldMaxELOAllowedText.Text = not p22.ELOShieldMaxELOAllowedText.Visible and "" or string.format(" \226\128\162 Players with %s+ ELO do not receive ELO Shields", v_u_4:PrettyNumber(v_u_3.CurrentSeason.ELOShieldMaxELOAllowed))
    p22.ELODecayPeriodText.Visible = v_u_3.CurrentSeason.ELODecayThreshold or false
    p22.ELODecayPeriodText.Text = not p22.ELODecayPeriodText.Visible and "" or string.format(" \226\128\162 Players with %s+ ELO must play Ranked atleast once every %s to avoid ELO Decay", v_u_4:PrettyNumber(v_u_3.CurrentSeason.ELODecayThreshold), v_u_4:TimeFormat2(v_u_3.CurrentSeason.ELODecayInactivePeriodDays * 24 * 60 * 60, true))
    p22.ELODecayAmountText.Visible = v_u_3.CurrentSeason.ELODecayThreshold or false
    local v35 = p22.ELODecayAmountText
    local v36
    if p22.ELODecayAmountText.Visible then
        local v37 = string.format
        local v38 = v_u_4
        local v39 = v_u_3.CurrentSeason.ELODecayPerInactiveDay
        v36 = v37(" \226\128\162 ELO Decay makes you lose %s ELO for every day you remain inactive", v38:PrettyNumber((math.abs(v39))))
    else
        v36 = ""
    end
    v35.Text = v36
end
function v_u_9._Init(p_u_40)
    p_u_40.CloseButton.MouseButton1Click:Connect(function()
        p_u_40:CloseRequest()
    end)
    p_u_40.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p_u_40:_UpdateList()
    end)
    p_u_40.List:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
        p_u_40:_UpdateList()
    end)
    p_u_40:_Setup()
    p_u_40:_UpdateList()
    v_u_5:Add(p_u_40.CloseButton)
end
return v_u_9