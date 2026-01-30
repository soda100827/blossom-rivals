local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = require(v1.Modules.DuelLibrary)
local v_u_3 = require(v1.Modules.Utility)
local v_u_4 = UDim2.new(0.5, 0, 0.125, 30)
local v_u_5 = UDim2.new(0.175, 58, 0.07, 20)
local v_u_6 = {}
v_u_6.__index = v_u_6
function v_u_6.new(p7)
    local v8 = v_u_6
    local v9 = setmetatable({}, v8)
    v9.DuelInterface = p7
    v9.Frame = v9.DuelInterface.Frame:WaitForChild("Top"):WaitForChild("RoundResult")
    v9.Container = v9.Frame:WaitForChild("Container")
    v9.OutlineFrame = v9.Container:WaitForChild("Outline")
    v9.OutlineUIStroke = v9.OutlineFrame:WaitForChild("UIStroke")
    v9.ShineFrame = v9.Container:WaitForChild("Shine"):WaitForChild("Frame")
    v9.Background = v9.Container:WaitForChild("Background")
    v9.BackgroundTitle = v9.Background:WaitForChild("Title")
    v9.BackgroundStatus = v9.Background:WaitForChild("Status")
    v9.Background2 = v9.Container:WaitForChild("Background2")
    v9._destroyed = false
    v9._round_result_hash = 0
    v9:_Init()
    return v9
end
function v_u_6.Play(p_u_10, p11)
    p_u_10._round_result_hash = p_u_10._round_result_hash + 1
    local v_u_12 = p_u_10._round_result_hash
    local v13 = p11 == nil and "Tie" or (p_u_10.DuelInterface.ClientDuel.LocalDueler and (p_u_10.DuelInterface.ClientDuel.LocalDueler and p11 == p_u_10.DuelInterface.ClientDuel.LocalDueler:Get("TeamID") and "Win" or "Lose") or "Win")
    p_u_10.Frame.Size = v_u_5
    p_u_10.Frame.Position = v_u_4
    p_u_10.OutlineFrame.Size = UDim2.new(1, 0, 1, 0)
    p_u_10.OutlineUIStroke.Thickness = 0
    p_u_10.ShineFrame.Position = UDim2.new(-0.5, 0, 0.5, 0)
    p_u_10.BackgroundTitle.TextTransparency = 0
    p_u_10.BackgroundStatus.TextTransparency = 0
    p_u_10.BackgroundTitle.Text = (p_u_10.DuelInterface.ClientDuel.LocalDueler or not p11) and "ROUND" or v_u_2.TeamsByID[p11].TeamName
    local v14 = p_u_10.BackgroundStatus
    local v15
    if p_u_10.DuelInterface.ClientDuel.LocalDueler then
        v15 = v13 == "Win" and "WON" or (v13 == "Lose" and "LOST" or "DRAW")
    else
        v15 = p11 and "WON" or "DRAW"
    end
    v14.Text = v15
    local v16 = p_u_10.Background2
    local v17
    if p_u_10.DuelInterface.ClientDuel.LocalDueler then
        v17 = v13 == "Win" and Color3.fromRGB(67, 214, 59) or (v13 == "Lose" and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(150, 150, 150))
    else
        v17 = v_u_2:GetTeamColor(p11)
    end
    v16.ImageColor3 = v17
    p_u_10.Background2.ImageTransparency = 0
    p_u_10.Frame.Visible = true
    p_u_10.DuelInterface:CreateSound(v13 == "Win" and "rbxassetid://16810041280" or (v13 == "Lose" and "rbxassetid://16810321565" or "rbxassetid://16810087814"), 1.5, 1, script, true, 5)
    if v13 == "Win" then
        p_u_10.Frame.Size = UDim2.new()
        task.spawn(v_u_3.RenderstepForLoop, v_u_3, 0, 100, 4, function(p18)
            if p_u_10._round_result_hash ~= v_u_12 then
                return true
            end
            local v19 = 1 + 2.70158 * (p18 / 100 - 1) ^ 3 + 1.70158 * (p18 / 100 - 1) ^ 2
            p_u_10.Frame.Position = v_u_4 + UDim2.new(0, 0, 0.15 * (1 - v19), 0)
        end)
        v_u_3:RenderstepForLoop(0, 100, 4, function(p20)
            if p_u_10._round_result_hash ~= v_u_12 then
                return true
            end
            local v21 = p20 / 100
            p_u_10.Frame.Size = UDim2.new(v_u_5.X.Scale * v21, v_u_5.X.Offset * v21, v_u_5.Y.Scale * v21, v_u_5.Y.Offset * v21)
        end)
        if p_u_10._round_result_hash == v_u_12 then
            v_u_3:RenderstepForLoop(0, 100, 5, function(p22)
                if p_u_10._round_result_hash ~= v_u_12 then
                    return true
                end
                local v23 = 1 - (1 - p22 / 100) ^ 4
                p_u_10.OutlineUIStroke.Thickness = 12 * v23
            end)
            if p_u_10._round_result_hash == v_u_12 then
                v_u_3:RenderstepForLoop(0, 100, 2, function(p24)
                    if p_u_10._round_result_hash ~= v_u_12 then
                        return true
                    end
                    local v25 = 1 - (1 - p24 / 100) ^ 4
                    local v26 = 12 * (1 - v25)
                    p_u_10.OutlineUIStroke.Thickness = v26 < 0.5 and 0 or v26
                    p_u_10.OutlineFrame.Size = UDim2.new(1, 12 * v25 * 1.5, 1, 12 * v25 * 1.5)
                end)
                if p_u_10._round_result_hash == v_u_12 then
                    v_u_3:RenderstepForLoop(0, 100, 2, function(p27)
                        if p_u_10._round_result_hash ~= v_u_12 then
                            return true
                        end
                        local v28 = 1 - (1 - p27 / 100) ^ 2
                        p_u_10.ShineFrame.Position = UDim2.new(-0.5 + 2 * v28, 0, 0.5, 0)
                    end)
                    wait(2)
                    if p_u_10._round_result_hash == v_u_12 then
                        v_u_3:RenderstepForLoop(0, 100, 2, function(p29)
                            if p_u_10._round_result_hash ~= v_u_12 then
                                return true
                            end
                            local v30 = (p29 / 100) ^ 4
                            p_u_10.BackgroundTitle.TextTransparency = v30
                            p_u_10.BackgroundStatus.TextTransparency = v30
                            p_u_10.Background2.ImageTransparency = v30
                        end)
                        if p_u_10._round_result_hash == v_u_12 then
                            p_u_10.Frame.Visible = false
                        end
                    else
                        return
                    end
                else
                    return
                end
            else
                return
            end
        else
            return
        end
    elseif v13 == "Lose" then
        v_u_3:RenderstepForLoop(0, 100, 2, function(p31)
            if p_u_10._round_result_hash ~= v_u_12 then
                return true
            end
            local v32 = 1 - (1 - p31 / 100) ^ 2
            local v33 = 20 * (1 - (p31 / 100) ^ 2)
            p_u_10.Frame.Position = v_u_4 + UDim2.new(0, v33 * math.random(), -0.025 * (1 - v32), 30 + v33 * 0.25 * math.random())
            p_u_10.BackgroundTitle.TextTransparency = 1 - v32
            p_u_10.BackgroundStatus.TextTransparency = 1 - v32
            p_u_10.Background2.ImageTransparency = 1 - v32
        end)
        wait(3)
        if p_u_10._round_result_hash == v_u_12 then
            v_u_3:RenderstepForLoop(0, 100, 1, function(p34)
                if p_u_10._round_result_hash ~= v_u_12 then
                    return true
                end
                local v35 = (p34 / 100) ^ 4
                p_u_10.BackgroundTitle.TextTransparency = v35
                p_u_10.BackgroundStatus.TextTransparency = v35
                p_u_10.Background2.ImageTransparency = v35
            end)
            if p_u_10._round_result_hash == v_u_12 then
                p_u_10.Frame.Visible = false
            end
        else
            return
        end
    else
        if v13 == "Tie" then
            v_u_3:RenderstepForLoop(0, 100, 2, function(p36)
                if p_u_10._round_result_hash ~= v_u_12 then
                    return true
                end
                local v37 = 1 - (1 - p36 / 100) ^ 4
                p_u_10.BackgroundTitle.TextTransparency = 1 - v37
                p_u_10.BackgroundStatus.TextTransparency = 1 - v37
                p_u_10.Background2.ImageTransparency = 1 - v37
            end)
            wait(3)
            if p_u_10._round_result_hash ~= v_u_12 then
                return
            end
            v_u_3:RenderstepForLoop(0, 100, 2, function(p38)
                if p_u_10._round_result_hash ~= v_u_12 then
                    return true
                end
                local v39 = (p38 / 100) ^ 4
                p_u_10.BackgroundTitle.TextTransparency = v39
                p_u_10.BackgroundStatus.TextTransparency = v39
                p_u_10.Background2.ImageTransparency = v39
            end)
            if p_u_10._round_result_hash ~= v_u_12 then
                return
            end
            p_u_10.Frame.Visible = false
        end
        return
    end
end
function v_u_6.UpdateVisibility(p40)
    p40.Container.Visible = not p40.DuelInterface:IsPageOpen()
end
function v_u_6.Destroy(p41)
    p41._destroyed = true
    p41._round_result_hash = p41._round_result_hash + 1
end
function v_u_6._Init(_) end
return v_u_6