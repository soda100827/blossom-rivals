local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.SeasonLibrary)
local v_u_4 = require(v1.Modules.Utility)
local v_u_5 = v2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("RankIconLabel")
local v_u_6 = v2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("RankIcon")
local v_u_7 = {}
v_u_7.__index = v_u_7
function v_u_7.new(p8, p9, p10)
    local v11 = v_u_7
    local v12 = setmetatable({}, v11)
    v12.ELO = p8
    v12.UserID = p9
    v12.ELOLeaderboardRanking = p10 or v_u_3:GetHighestELOLeaderboardRanking(v12.ELO, v12.UserID)
    v12.RankName = v_u_3:GetRank(v12.ELO, v12.UserID, v12.ELOLeaderboardRanking)
    v12.RankInfo = v_u_3.CurrentSeason.RankProfile.Ranks[v12.RankName]
    v12.Frame = v_u_6:Clone()
    v12.Icon = v12.Frame:WaitForChild("Icon")
    v12._destroyed = false
    v12._label = nil
    v12._label_text = nil
    v12:_Init()
    return v12
end
function v_u_7.GetLabelText(p13)
    return p13._label_text
end
function v_u_7.GetLabel(p14)
    return p14._label
end
function v_u_7.SetParent(p_u_15, p_u_16)
    pcall(function()
        p_u_15.Frame.Parent = p_u_16
    end)
end
function v_u_7.SetLabel(p17, p18, p19)
    if not p17._label then
        p17._label = v_u_5:Clone()
        p17._label.Parent = p17.Frame
        p17._label_text = p17._label:WaitForChild("Title")
    end
    p17._label_text.Text = p18 or p17._label_text.Text
    p17._label_text.TextColor3 = p19 or p17._label_text.TextColor3
end
function v_u_7.SetLabelFromELOEvent(p20, p21, p22, p23)
    p20:SetLabel(p21 and string.format("%s%s ", p21 >= 0 and "+" or "", p21) or p22 and v_u_4:PrettyNumber(p22) or (p23 and p23 .. "/" .. v_u_3.CurrentSeason.RankProfile.NumPlacementDuels or ""), not p21 and Color3.fromRGB(255, 255, 255) or p21 > 0 and Color3.fromRGB(100, 255, 50) or (p21 < 0 and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(255, 215, 0)))
end
function v_u_7.Destroy(p_u_24)
    if not p_u_24._destroyed then
        p_u_24._destroyed = true
        pcall(function()
            p_u_24.Frame:Destroy()
        end)
    end
end
function v_u_7._Setup(p25)
    p25.Icon.Image = p25.RankInfo.Image
end
function v_u_7._Init(p_u_26)
    p_u_26.Frame.Destroying:Connect(function()
        p_u_26:Destroy()
    end)
    p_u_26:_Setup()
end
return v_u_7