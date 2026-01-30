local v_u_1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v_u_1.Modules.CONSTANTS)
local v_u_4 = require(v2.LocalPlayer.PlayerScripts.Controllers.MatchmakingController)
local v_u_5 = require(v2.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
local v_u_6 = require(v2.LocalPlayer.PlayerScripts.Controllers.SpectateController)
local v_u_7 = require(v2.LocalPlayer.PlayerScripts.Modules.ButtonEffect)
local v_u_8 = {
    ["HoverRatio"] = UDim2.new(0, 10, 0, 10),
    ["ReleaseRatio"] = UDim2.new(0, 10, 0, 10)
}
local v_u_9 = {}
v_u_9.__index = v_u_9
function v_u_9.new(p10)
    local v11 = v_u_9
    local v12 = setmetatable({}, v11)
    v12.FinalResults = p10
    v12.Frame = v12.FinalResults.Frame:WaitForChild("Buttons")
    v12.BottomRightFrame = v12.Frame:WaitForChild("BottomRight")
    v12.BottomRightContainer = v12.BottomRightFrame:WaitForChild("Container")
    v12.ContinueFrame = v12.BottomRightContainer:WaitForChild("Continue")
    v12.ContinueButton = v12.ContinueFrame:WaitForChild("Button")
    v12.PlayAgainFrame = v12.BottomRightContainer:WaitForChild("PlayAgain")
    v12.PlayAgainButton = v12.PlayAgainFrame:WaitForChild("Button")
    v12.LeaveFrame = v12.BottomRightContainer:WaitForChild("Leave")
    v12.LeaveButton = v12.LeaveFrame:WaitForChild("Button")
    v12.LeaveButtonTitle = v12.LeaveButton:WaitForChild("Title")
    v12.LeaveButtonTitleStroke = v12.LeaveButtonTitle:WaitForChild("UIStroke")
    v12.LeaveButtonShine = v12.LeaveButton:WaitForChild("Shine")
    v12.LeaveButtonOutlineUIStroke = v12.LeaveButton:WaitForChild("Outline"):WaitForChild("UIStroke")
    v12.RematchFrame = v12.BottomRightContainer:WaitForChild("Rematch")
    v12.RematchButton = v12.RematchFrame:WaitForChild("Button")
    v12.RematchButtonTitle = v12.RematchButton:WaitForChild("Title")
    v12.RematchButtonTitleStroke = v12.RematchButtonTitle:WaitForChild("UIStroke")
    v12.RematchButtonCount = v12.RematchButton:WaitForChild("Count")
    v12.RematchButtonCountStroke = v12.RematchButtonCount:WaitForChild("UIStroke")
    v12.RematchButtonShine = v12.RematchButton:WaitForChild("Shine")
    v12.RematchButtonOutlineUIStroke = v12.RematchButton:WaitForChild("Outline"):WaitForChild("UIStroke")
    v12.BottomLeftFrame = v12.Frame:WaitForChild("BottomLeft")
    v12.BottomLeftContainer = v12.BottomLeftFrame:WaitForChild("Container")
    v12.BackFrame = v12.BottomLeftContainer:WaitForChild("Back")
    v12.BackButton = v12.BackFrame:WaitForChild("Button")
    v12._destroyed = false
    v12:_Init()
    return v12
end
function v_u_9.LeaveRequest(p13)
    if p13.FinalResults.Winners:IsFinished() then
        if p13.FinalResults.DuelInterface.ClientDuel.LocalDueler then
            v_u_1.Remotes.Duels.LeaveDuel:FireServer()
        else
            v_u_6:Exit()
        end
    else
        p13.FinalResults.Winners:Skip()
        return
    end
end
function v_u_9.Rematch(_)
    v_u_1.Remotes.Duels.Rematch:FireServer()
end
function v_u_9.PlayAgain(_)
    v_u_1.Remotes.Matchmaking.PlayAgain:FireServer()
end
function v_u_9.Continue(p14)
    p14.FinalResults:SetPage("Summary")
end
function v_u_9.Update(p15)
    p15:_UpdateRematchButton()
end
function v_u_9.Destroy(p16)
    p16._destroyed = true
end
function v_u_9._UpdateRematchButton(p17)
    local v18 = p17.FinalResults.DuelInterface.ClientDuel:Get("RematchCount")
    local v19 = p17.FinalResults.DuelInterface.ClientDuel:Get("RematchGoal")
    local v20 = p17.FinalResults.DuelInterface.ClientDuel:Get("RematchSuccess")
    local v21
    if v20 then
        v21 = v20
    elseif v18 then
        if v19 then
            v21 = p17.FinalResults.DuelInterface.ClientDuel:Get("RematchAvailable")
        else
            v21 = v19
        end
    else
        v21 = v18
    end
    local v22 = v21 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
    local v23 = v21 and 0 or 0.75
    p17.RematchButtonOutlineUIStroke.Color = v22
    p17.RematchButtonShine.ImageColor3 = v22
    p17.RematchButtonTitle.TextColor3 = v22
    p17.RematchButtonCount.TextColor3 = v22
    p17.RematchButtonOutlineUIStroke.Transparency = v23
    p17.RematchButtonShine.ImageTransparency = v23
    p17.RematchButtonTitle.TextTransparency = v23
    p17.RematchButtonCount.TextTransparency = v23
    p17.RematchButtonCount.Text = v20 and "\226\128\162 \226\128\162 \226\128\162" or (v21 and v18 .. " / " .. v19 or "Unavailable")
    p17.RematchButtonCount.FontFace = v21 and Font.fromId(12187365977, Enum.FontWeight.Heavy) or Font.fromId(12187365977, Enum.FontWeight.Medium)
    p17.RematchButtonTitleStroke.Enabled = v21
    p17.RematchButtonCountStroke.Enabled = v21
end
function v_u_9._UpdateButtonStates(p24)
    local v25 = p24.FinalResults:IsActive()
    local v26 = p24.FinalResults.Winners:IsFinished()
    local v27 = p24.FinalResults.CurrentPage
    local v28 = p24.FinalResults.DuelInterface.ClientDuel.LocalDueler ~= nil
    local v29 = p24.ContinueFrame
    local v30
    if v25 then
        if v26 then
            if v27 == "Winners" then
                v30 = p24.FinalResults.Summary:HasDetailsReady()
            else
                v30 = false
            end
        else
            v30 = v26
        end
    else
        v30 = v25
    end
    v29.Visible = v30
    local v31 = p24.RematchFrame
    local v32 = v28 and not p24.ContinueFrame.Visible
    if v32 then
        if v25 then
            v32 = v26
        else
            v32 = v25
        end
    end
    v31.Visible = v32
    local v33 = p24.PlayAgainFrame
    local v34 = v28 and (not p24.ContinueFrame.Visible and (v25 and (v26 and v_u_3.IS_MATCHMAKING_SERVER)))
    if v34 then
        v34 = v_u_4:IsPartyLeader()
    end
    v33.Visible = v34
    p24.LeaveFrame.Visible = not p24.ContinueFrame.Visible and v25
    local v35 = p24.BackButton
    if v25 then
        if v26 then
            v25 = v27 == "Summary"
        else
            v25 = v26
        end
    end
    v35.Visible = v25
    local v36 = v26 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
    local v37 = v26 and 0 or 0.75
    p24.LeaveButtonTitle.Text = v26 and "Leave" or "Skip"
    p24.LeaveButtonTitle.TextColor3 = v36
    p24.LeaveButtonShine.ImageColor3 = v36
    p24.LeaveButtonOutlineUIStroke.Color = v36
    p24.LeaveButtonTitle.TextTransparency = v37
    p24.LeaveButtonShine.ImageTransparency = v37
    p24.LeaveButtonOutlineUIStroke.Transparency = v37
    p24.LeaveButtonTitleStroke.Enabled = v26
end
function v_u_9._Init(p_u_38)
    p_u_38.LeaveButton.MouseButton1Click:Connect(function()
        p_u_38:LeaveRequest()
    end)
    p_u_38.PlayAgainButton.MouseButton1Click:Connect(function()
        p_u_38:PlayAgain()
    end)
    p_u_38.RematchButton.MouseButton1Click:Connect(function()
        p_u_38:Rematch()
    end)
    p_u_38.ContinueButton.MouseButton1Click:Connect(function()
        p_u_38:Continue()
    end)
    p_u_38.BackButton.MouseButton1Click:Connect(function()
        p_u_38.FinalResults:SetPage("Winners")
    end)
    p_u_38.FinalResults.Activated:Connect(function()
        p_u_38:_UpdateButtonStates()
    end)
    p_u_38.FinalResults.Winners.Finished:Connect(function()
        if v_u_5:Get("Settings Hide HUD") then
            p_u_38:LeaveRequest()
        end
        p_u_38:_UpdateButtonStates()
    end)
    p_u_38.FinalResults.PageChanged:Connect(function()
        p_u_38:_UpdateButtonStates()
    end)
    task.defer(p_u_38._UpdateButtonStates, p_u_38)
    task.defer(p_u_38._UpdateRematchButton, p_u_38)
    v_u_7:Add(p_u_38.ContinueButton, nil, v_u_8)
    v_u_7:Add(p_u_38.LeaveButton, nil, v_u_8)
    v_u_7:Add(p_u_38.PlayAgainButton, nil, v_u_8)
    v_u_7:Add(p_u_38.RematchButton, nil, v_u_8)
    v_u_7:Add(p_u_38.BackButton, nil, v_u_8)
end
return v_u_9