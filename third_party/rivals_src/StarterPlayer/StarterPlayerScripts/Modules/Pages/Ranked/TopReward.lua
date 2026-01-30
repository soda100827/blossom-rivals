local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.CosmeticLibrary)
local v_u_4 = require(v1.Modules.SeasonLibrary)
local v_u_5 = require(v2.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
local v_u_6 = require(v2.LocalPlayer.PlayerScripts.Modules.RewardSlot)
local v_u_7 = require(v2.LocalPlayer.PlayerScripts.Modules.RankIcon)
local v_u_8 = {}
v_u_8.__index = v_u_8
function v_u_8.new(p9)
    local v10 = v_u_8
    local v11 = setmetatable({}, v10)
    v11.Page = p9
    v11.Frame = v11.Page.Container:WaitForChild("TopReward")
    v11.RankContainer = v11.Frame:WaitForChild("RankContainer")
    v11.Container = v11.Frame:WaitForChild("Container")
    v11.Description = v11.Frame:WaitForChild("Description")
    v11.Description2 = v11.Frame:WaitForChild("Description2")
    v11:_Init()
    return v11
end
function v_u_8.Open(p12)
    p12:_Update()
end
function v_u_8.Close(_) end
function v_u_8._GetTopRankDetails(_)
    local v13 = v_u_4:GetRank((1 / 0), nil, v_u_4.CurrentSeason.TopPlayerLeaderboardRank)
    return v13, v_u_4.CurrentSeason.RankProfile.Ranks[v13].RequiredELO
end
function v_u_8._Update(p14)
    if v_u_4.CurrentSeason.TopPlayerRewardSkinName then
        local v15 = v_u_5:Get("Seasons")[v_u_4.CurrentSeason.Name]
        if v15 then
            v15 = v15.RankedPerformances[v_u_4.UNIVERSAL_ELO_NAME]
        end
        if v15 then
            v15 = v15.CurrentELO
        end
        local _, v16 = p14:_GetTopRankDetails()
        local v17 = p14.Frame
        if v15 then
            v15 = v16 <= v15
        end
        v17.Visible = v15
    else
        p14.Frame.Visible = false
    end
end
function v_u_8._Setup(p18)
    local v19, _ = p18:_GetTopRankDetails()
    local v20 = v_u_4.CurrentSeason.TopPlayerRewardSkinName
    if v20 then
        local v21 = v_u_3.Cosmetics[v20]
        p18.Description.Text = string.format("Become %s by reaching top %s on the Ranked Leaderboard!", v19, v_u_4.CurrentSeason.TopPlayerLeaderboardRank)
        p18.Description2.Text = string.format("The %s %s skin will be rewarded to %s players at season end!", v21.Rarity, v20, v19)
        v_u_7.new((1 / 0), nil, v_u_4.CurrentSeason.TopPlayerLeaderboardRank):SetParent(p18.RankContainer)
        v_u_6.new({
            ["Name"] = v20,
            ["Weapon"] = v21.ItemName
        }):SetParent(p18.Container)
    end
end
function v_u_8._Init(p22)
    p22:_Setup()
end
return v_u_8