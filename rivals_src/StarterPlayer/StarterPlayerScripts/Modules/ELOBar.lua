local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.SeasonLibrary)
local v_u_4 = require(v1.Modules.Utility)
local v_u_5 = require(v_u_2.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
local v_u_6 = require(v_u_2.LocalPlayer.PlayerScripts.Modules.RankIcon)
local v_u_7 = v_u_2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("ELOBar")
local v_u_8 = {}
v_u_8.__index = v_u_8
function v_u_8.new()
    local v9 = v_u_8
    local v10 = setmetatable({}, v9)
    v10.Frame = v_u_7:Clone()
    v10.ProgressBar = v10.Frame:WaitForChild("Progress"):WaitForChild("Bar")
    v10.ProgressBarTexture = v10.ProgressBar:WaitForChild("Texture")
    v10.LeftRankText = v10.Frame:WaitForChild("LeftRank")
    v10.LeftELOText = v10.Frame:WaitForChild("LeftELO")
    v10.CurrentELOTitle = v10.Frame:WaitForChild("CurrentELOTitle")
    v10.CurrentELOText = v10.Frame:WaitForChild("CurrentELO")
    v10.RightRankText = v10.Frame:WaitForChild("RightRank")
    v10.RightELOText = v10.Frame:WaitForChild("RightELO")
    v10.RankCurrentFrame = v10.Frame:WaitForChild("RankCurrent")
    v10.RankNextFrame = v10.Frame:WaitForChild("RankNext")
    v10._is_enabled = nil
    v10._update_hash = 0
    v10._current_rank_icon = nil
    v10._next_rank_icon = nil
    v10._preloaded_rank_icons = false
    v10:_Init()
    return v10
end
function v_u_8.SetParent(p11, p12)
    p11.Frame.Parent = p12
end
function v_u_8.Update(p13, p14)
    p13._is_enabled = p14
    p13._update_hash = p13._update_hash + 1
    p13:_Update()
end
function v_u_8.Destroy(p15)
    p15.Frame:Destroy()
end
function v_u_8._Update(p_u_16)
    if p_u_16._current_rank_icon then
        p_u_16._current_rank_icon:Destroy()
        p_u_16._current_rank_icon = nil
    end
    if p_u_16._next_rank_icon then
        p_u_16._next_rank_icon:Destroy()
        p_u_16._next_rank_icon = nil
    end
    p_u_16.Frame.Visible = false
    if p_u_16._is_enabled then
        local v_u_17 = v_u_3.CurrentSeason.RankProfile
        local v18 = v_u_5:Get("Seasons")[v_u_3.CurrentSeason.Name]
        if v18 then
            v18 = v18.RankedPerformances[v_u_3.UNIVERSAL_ELO_NAME]
        end
        if v18 then
            local v19 = v_u_3:GetRank(v18.CurrentELO, v_u_2.LocalPlayer.UserId)
            local v20 = v_u_17.Ranks[v19]
            local v21 = v_u_17.RanksOrder
            local v22 = #v_u_17.RanksOrder
            local v23 = table.find(v_u_17.RanksOrder, v19) + 1
            local v24 = v21[math.min(v22, v23)]
            local v25 = v_u_17.Ranks[v24]
            local v26 = v25.RequiredELO and v20.RequiredELO
            if v26 then
                v26 = v25.RequiredELO - v20.RequiredELO == 0
            end
            local v27
            if v18.CurrentELO then
                v27 = v24 == v19 and 1 or (v26 and 0.5 or (v18.CurrentELO - v20.RequiredELO) / (v25.RequiredELO - v20.RequiredELO))
            else
                v27 = v18.DuelsPlayed / v_u_3.CurrentSeason.RankProfile.NumPlacementDuels
            end
            if v27 <= 0 then
                v27 = 0
            elseif not v26 then
                v27 = math.clamp(v27, 0, 1) * 0.9 + 0.1
            end
            local v28 = v_u_17.Groups[v20.RankGroupName]
            if v26 then
                v19 = v_u_17.RanksOrder[table.find(v_u_17.RanksOrder, v24) - 1]
                v20 = v_u_17.Ranks[v19]
                v28 = v_u_17.Groups[v25.RankGroupName]
            end
            p_u_16.ProgressBar.BackgroundColor3 = v28.Color
            p_u_16.ProgressBar.Size = UDim2.new(0, 0, 1, 0)
            p_u_16.ProgressBarTexture.ImageColor3 = v28.SecondaryColor
            p_u_16.ProgressBar:TweenSize(UDim2.new(v27, 0, 1, 0), "InOut", "Quint", 0.5, true)
            p_u_16.LeftRankText.Text = v19
            p_u_16.LeftELOText.Text = not v18.CurrentELO and "" or v_u_4:PrettyNumber(v20.RequiredELO)
            p_u_16.CurrentELOTitle.Text = v18.CurrentELO and "Your ELO" or "Play Ranked"
            local v29 = p_u_16.CurrentELOText
            local v30
            if v18.CurrentELO then
                v30 = v_u_4:PrettyNumber(v18.CurrentELO)
            else
                v30 = v18.DuelsPlayed .. " / " .. v_u_3.CurrentSeason.RankProfile.NumPlacementDuels
            end
            v29.Text = v30
            p_u_16.RightRankText.Text = not v18.CurrentELO and "Unlock your rank" or v24
            local v31 = p_u_16.RightELOText
            local v32
            if v18.CurrentELO then
                if v25.RequiredELOLeaderboardRanking then
                    v32 = "Top " .. v_u_4:PrettyNumber(v25.RequiredELOLeaderboardRanking)
                else
                    v32 = v_u_4:PrettyNumber(v25.RequiredELO)
                end
            else
                v32 = ""
            end
            v31.Text = v32
            local v33
            if v18.CurrentELO then
                v33 = v18.CurrentELO
            else
                v33 = nil
            end
            local v34
            if v18.CurrentELO then
                v34 = v20.RequiredELOLeaderboardRanking
            else
                v34 = nil
            end
            p_u_16._current_rank_icon = v_u_6.new(v33, nil, v34 or (1 / 0))
            p_u_16._current_rank_icon:SetParent(p_u_16.RankCurrentFrame)
            if v18.CurrentELO then
                local v35
                if v18.CurrentELO then
                    v35 = v25.RequiredELO
                else
                    v35 = nil
                end
                local v36
                if v18.CurrentELO then
                    v36 = v25.RequiredELOLeaderboardRanking
                else
                    v36 = nil
                end
                p_u_16._next_rank_icon = v_u_6.new(v35, nil, v36 or (1 / 0))
                p_u_16._next_rank_icon:SetParent(p_u_16.RankNextFrame)
            else
                if not p_u_16._preloaded_rank_icons then
                    p_u_16._preloaded_rank_icons = true
                    for _, v37 in pairs(v_u_17.GroupsOrder) do
                        local v38 = v_u_17.Groups[v37]
                        local v39 = v_u_17.Ranks[v38.Ranks[#v38.Ranks]]
                        local v40 = v_u_6.new(v39.RequiredELO, nil, v39.RequiredELOLeaderboardRanking or (1 / 0))
                        v40.Frame.Size = UDim2.new(0, 0, 0, 0)
                        v40:SetParent(p_u_16.RankNextFrame)
                    end
                end
                task.spawn(function()
                    local v41 = p_u_16._update_hash
                    while true do
                        for v42, v43 in pairs(v_u_17.GroupsOrder) do
                            if v42 ~= 1 then
                                if v41 ~= p_u_16._update_hash then
                                    return
                                end
                                if p_u_16._next_rank_icon then
                                    p_u_16._next_rank_icon:Destroy()
                                    p_u_16._next_rank_icon = nil
                                end
                                local v44 = v_u_17.Groups[v43]
                                local v45 = v_u_17.Ranks[v44.Ranks[#v44.Ranks]]
                                p_u_16._next_rank_icon = v_u_6.new(v45.RequiredELO, nil, v45.RequiredELOLeaderboardRanking or (1 / 0))
                                p_u_16._next_rank_icon:SetParent(p_u_16.RankNextFrame)
                                wait(1)
                            end
                        end
                    end
                end)
            end
            p_u_16.Frame.Visible = true
        end
    else
        return
    end
end
function v_u_8._Init(p46)
    p46:Update(false)
end
return v_u_8