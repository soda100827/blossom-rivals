local v_u_1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("AdService")
local v3 = game:GetService("Players")
local v_u_4 = require(v_u_1.Modules.MonetizationLibrary)
local v_u_5 = require(v_u_1.Modules.Utility)
local v_u_6 = require(v_u_1.Modules.Signal)
local v_u_7 = require(v3.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
local v_u_8 = require(v3.LocalPlayer.PlayerScripts.Modules.ButtonEffect)
local v_u_9 = require(v3.LocalPlayer.PlayerScripts.Modules.RewardSlot)
local v_u_10 = v3.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("VideoAdRewards")
local v_u_11 = v3.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("VideoAdRewardSlot")
local v_u_12 = {}
v_u_12.__index = v_u_12
function v_u_12.new(_)
    local v13 = v_u_12
    local v14 = setmetatable({}, v13)
    v14.PlayedAd = v_u_6.new()
    v14.AvailabilityChanged = v_u_6.new()
    v14.Frame = v_u_10:Clone()
    v14.Container = v14.Frame:WaitForChild("Container")
    v14.Background = v14.Container:WaitForChild("Background")
    v14.WaitingFrame = v14.Container:WaitForChild("Waiting")
    v14.WaitingDotsFrame = v14.WaitingFrame:WaitForChild("Dots")
    v14.UnavailableFrame = v14.Container:WaitForChild("Unavailable")
    v14.UnavailableTitle = v14.UnavailableFrame:WaitForChild("Title")
    v14.UnavailableDescription = v14.UnavailableFrame:WaitForChild("Description")
    v14.UnavailableImage = v14.UnavailableFrame:WaitForChild("ImageLabel")
    v14.AvailableFrame = v14.Container:WaitForChild("Available")
    v14.AvailableTitle = v14.AvailableFrame:WaitForChild("Title")
    v14.AvailableDescription = v14.AvailableFrame:WaitForChild("Description")
    v14.RewardsFrame = v14.AvailableFrame:WaitForChild("Rewards")
    v14._connections = {}
    v14._cleanup = {}
    v14._update_hash = 0
    v14._auto_update_task = nil
    v14._buttons_position = nil
    v14._placement_id = nil
    v14:_Init()
    return v14
end
function v_u_12.IsAvailable(p15)
    return p15.AvailableFrame.Visible
end
function v_u_12.SetButtonsPositionY(p16, p17)
    p16._buttons_position_y = p17
end
function v_u_12.SetRewardsSize(p18, p19)
    p18.RewardsFrame.Size = UDim2.new(0.9, 0, p19, 0)
end
function v_u_12.SetBackgroundVisible(p20, p21)
    p20.Background.Visible = p21
end
function v_u_12.SetWhiteColor(p22, p23)
    p22.AvailableTitle.TextColor3 = p23
    p22.AvailableDescription.TextColor3 = p23
    p22.UnavailableTitle.TextColor3 = p23
    p22.UnavailableDescription.TextColor3 = p23
    p22.UnavailableImage.ImageColor3 = p23
    for _, v24 in pairs(p22.WaitingDotsFrame:GetChildren()) do
        if v24:IsA("ImageLabel") then
            v24.ImageColor3 = p23
        end
    end
end
function v_u_12.AutoUpdate(p_u_25, p_u_26)
    p_u_25._auto_update_task = task.spawn(function()
        while true do
            p_u_25:Update()
            wait(p_u_26 or 60)
        end
    end)
end
function v_u_12.Update(p27)
    task.spawn(p27._Update, p27)
end
function v_u_12.WeakUpdate(p28)
    if not p28.AvailableFrame.Visible then
        p28:Update()
    end
end
function v_u_12.Destroy(p29)
    for _, v30 in pairs(p29._connections) do
        v30:Disconnect()
    end
    if p29._auto_update_task then
        task.cancel(p29._auto_update_task)
    end
    p29.AvailabilityChanged:Destroy()
    p29.PlayedAd:Destroy()
end
function v_u_12._Update(p_u_31)
    for _, v32 in pairs(p_u_31._cleanup) do
        v32:Destroy()
    end
    p_u_31._cleanup = {}
    p_u_31._update_hash = p_u_31._update_hash + 1
    local v33 = p_u_31._update_hash
    p_u_31.WaitingFrame.Visible = true
    p_u_31.WaitingDotsFrame:AddTag("UILoadingDots")
    p_u_31.UnavailableFrame.Visible = false
    p_u_31.AvailableFrame.Visible = false
    local v34, v35 = pcall(v_u_2.GetAdAvailabilityNowAsync, v_u_2, Enum.AdFormat.RewardedVideo)
    if v33 == p_u_31._update_hash then
        if v34 then
            v34 = v35.AdAvailabilityResult == Enum.AdAvailabilityResult.IsAvailable
        end
        p_u_31.WaitingFrame.Visible = false
        p_u_31.WaitingDotsFrame:RemoveTag("UILoadingDots")
        p_u_31.UnavailableFrame.Visible = not v34
        p_u_31.AvailableFrame.Visible = v34
        if v34 then
            local v36 = 0
            for v37 = 1, #v_u_4.VideoAdRewards do
                local v38 = v_u_7:Get("VideoAdRewardsClaimed") % #v_u_4.VideoAdRewards + v37
                local v39 = v_u_4.VIDEO_AD_REWARDS_MAX_SCALE_FACTOR
                local v40 = (v_u_7:Get("VideoAdRewardsClaimed") + v37) / #v_u_4.VideoAdRewards
                local v41 = math.ceil(v40)
                local v42 = math.min(v39, v41)
                local v43 = v_u_4.VideoAdRewards[(v38 - 1) % #v_u_4.VideoAdRewards + 1]
                local v_u_44 = v37 == 1
                if v37 > 1 then
                    local v45 = p_u_31:_CreateArrow()
                    v45.LayoutOrder = v36
                    v45.Parent = p_u_31.RewardsFrame
                    local v46 = p_u_31._cleanup
                    table.insert(v46, v45)
                    v36 = v36 + 1
                end
                local v47 = { v43.RewardDatas }
                if v_u_7:Get("VideoAdRewardsClaimed") + v37 <= #v_u_4.VideoAdRewards then
                    local v48 = v43.PreRepetitionRewardDatas
                    table.insert(v47, v48)
                end
                local v49 = 0
                for _, v50 in pairs(v47) do
                    v49 = v49 + #v50
                end
                local v51 = 0
                for _, v52 in pairs(v47) do
                    for _, v53 in pairs(v52) do
                        v51 = v51 + 1
                        v36 = v36 + 1
                        local v54 = v_u_5:CloneTable(v53)
                        v54.Quantity = (v54.Quantity or 1) * v42
                        local v_u_55 = v_u_11:Clone()
                        v_u_55.Button.Visible = v51 == 1
                        v_u_55.Button.Position = UDim2.new(v49 * 0.5, 0, p_u_31._buttons_position_y or 1.25, 0)
                        v_u_55.Button.Unlocked.Title.Text = v_u_7:Get("VideoAdsWatchedBeforeClaiming") .. " / " .. v43.NumAdsRequired
                        v_u_55.Button.Unlocked.Visible = v_u_44
                        v_u_55.Button.Locked.Visible = not v_u_44
                        v_u_55.LayoutOrder = v36
                        v_u_55.Parent = p_u_31.RewardsFrame
                        local v56 = p_u_31._cleanup
                        table.insert(v56, v_u_55)
                        local v57 = v_u_9.new(v54)
                        v57:SetParent(v_u_55)
                        local v58 = p_u_31._cleanup
                        table.insert(v58, v57)
                        local function v59()
                            v_u_55.Button.Unlocked.Title.Position = UDim2.new(0.5, v_u_55.Button.Unlocked.Title.Icon.AbsoluteSize.X * 0.4, 0.5, 0)
                            v_u_55.Button.Unlocked.Title.Icon.Position = UDim2.new(0.5, -v_u_55.Button.Unlocked.Title.TextBounds.X / 2, 0.5, 0)
                        end
                        v_u_55.Button.Unlocked.Title.Icon:GetPropertyChangedSignal("AbsoluteSize"):Connect(v59)
                        v_u_55.Button.Unlocked.Title:GetPropertyChangedSignal("TextBounds"):Connect(v59)
                        v59()
                        if v_u_44 then
                            v_u_55.Button.MouseButton1Click:Connect(function()
                                if v_u_44 then
                                    p_u_31.PlayedAd:Fire()
                                    v_u_1.Remotes.Misc.PlayVideoAd:FireServer()
                                end
                            end)
                            v_u_8:Add(v_u_55.Button)
                            task.defer(pcall, v_u_2.RegisterAdOpportunityAsync, v_u_2, v_u_55.Button, p_u_31._placement_id)
                        end
                    end
                end
            end
        end
    else
        return
    end
end
function v_u_12._CreateArrow(_)
    local v60 = Instance.new("ImageLabel")
    v60.AnchorPoint = Vector2.new(0.5, 0.5)
    v60.BackgroundTransparency = 1
    v60.Image = "rbxassetid://133426948634565"
    v60.SizeConstraint = Enum.SizeConstraint.RelativeYY
    v60.Size = UDim2.new(0.5, 0, 0.25, 0)
    v60.ScaleType = Enum.ScaleType.Fit
    return v60
end
function v_u_12._Init(p_u_61)
    p_u_61.AvailableFrame:GetPropertyChangedSignal("Visible"):Connect(function()
        p_u_61.AvailabilityChanged:Fire()
    end)
    local v62 = p_u_61._connections
    local v63 = v_u_7:GetDataChangedSignal("VideoAdRewardsClaimed")
    table.insert(v62, v63:Connect(function()
        p_u_61:Update()
    end))
    local v64 = p_u_61._connections
    local v65 = v_u_7:GetDataChangedSignal("VideoAdsWatchedBeforeClaiming")
    table.insert(v64, v65:Connect(function()
        p_u_61:Update()
    end))
end
return v_u_12