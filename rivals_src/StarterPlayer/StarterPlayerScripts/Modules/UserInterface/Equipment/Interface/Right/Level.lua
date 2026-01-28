local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.CosmeticLibrary)
local v_u_4 = require(v1.Modules.LootLibrary)
local v_u_5 = require(v1.Modules.Utility)
local v_u_6 = require(v2.LocalPlayer.PlayerScripts.Controllers.ComplianceController)
local v_u_7 = require(v2.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
local v_u_8 = require(v2.LocalPlayer.PlayerScripts.Modules.ButtonEffect)
local v_u_9 = require(v2.LocalPlayer.PlayerScripts.Modules.RewardSlot)
local v_u_10 = {}
v_u_10.__index = v_u_10
function v_u_10.new(p11)
    local v12 = v_u_10
    local v13 = setmetatable({}, v12)
    v13.Right = p11
    v13.Frame = v13.Right.Container:WaitForChild("Level")
    v13.Container = v13.Frame:WaitForChild("Container")
    v13.BarFrame = v13.Container:WaitForChild("Bar")
    v13.BarFrameGoal = v13.BarFrame:WaitForChild("Goal")
    v13.BarFrameLevel = v13.BarFrame:WaitForChild("Level")
    v13.BarFrameProgress = v13.BarFrame:WaitForChild("Progress")
    v13.BarFrameContainer = v13.BarFrame:WaitForChild("Container")
    v13.BarFrameContainerBar = v13.BarFrameContainer:WaitForChild("Bar")
    v13.ComponentsFrame = v13.Container:WaitForChild("Components")
    v13.ComponentsLayout = v13.ComponentsFrame:WaitForChild("Layout")
    v13.NextRewardFrame = v13.ComponentsFrame:WaitForChild("NextReward")
    v13.NextRewardTitle = v13.NextRewardFrame:WaitForChild("Title")
    v13.NextRewardContainer = v13.NextRewardFrame:WaitForChild("Container")
    v13.LevelUpFrame = v13.ComponentsFrame:WaitForChild("LevelUp")
    v13.LevelUpButton = v13.LevelUpFrame:WaitForChild("Button")
    v13.LevelUpButtonPrice = v13.LevelUpButton:WaitForChild("Price")
    v13._cleanup = {}
    v13._double_clicked = false
    v13:_Init()
    return v13
end
function v_u_10.OnStateChanged(p14)
    p14._double_clicked = false
    p14:_UpdateInformation()
end
function v_u_10._GetInformation(p15)
    if p15.Right.Interface.Equipment:IsCareerPageOpen() then
        local v16 = v_u_7:Get("Level")
        local v17 = v_u_7:Get("XP")
        local v18 = v_u_4:GetCareerLevelsRewardData()
        local v19 = (v16 + 1) / v_u_4:GetCareerLevelsRewardMilestone()
        return v16, v17, v18, math.ceil(v19) * v_u_4:GetCareerLevelsRewardMilestone()
    end
    local v20 = v_u_7:GetWeaponData((p15.Right.Interface.Equipment:GetSelectedWeapon()))
    if v20 then
        local v21 = v20.Level
        local v22 = v20.XP
        local v23, v24 = v_u_4:GetNextWeaponLevelReward(v21, v20.Name)
        return v21, v22, v23, v24
    end
end
function v_u_10._UpdateInformation(p25)
    for _, v26 in pairs(p25._cleanup) do
        v26:Destroy()
    end
    p25._cleanup = {}
    local v27, v28, v29, v30 = p25:_GetInformation()
    local v31 = v27 ~= nil
    p25.Frame.Visible = v31
    if v31 then
        local v32 = p25.Right.Interface.Equipment:IsCareerPageOpen()
        local v33 = v_u_4:GetXPRequiredToLevelUp(v27)
        local v34 = v29 and (v30 and (v27 == v30 - 1 and v_u_3.Rewards[v29.Name]))
        if v34 then
            if v_u_3.Rewards[v29.Name].Type == "Lootbox" then
                v34 = v_u_6:ArePaidRandomItemsRestricted()
            else
                v34 = false
            end
        end
        p25.BarFrameGoal.Text = v33 <= v28 and "" or v_u_5:PrettyNumber(v33)
        p25.BarFrameProgress.Text = v33 <= v28 and "" or v_u_5:PrettyNumber(v28)
        p25.BarFrameLevel.Text = v33 <= v28 and "MAX" or v_u_5:PrettyNumber(v27)
        local v35 = p25.BarFrameContainer
        local v36 = UDim2.new
        local v37 = v28 / v33
        v35.Size = v36(math.clamp(v37, 0, 1), 0, 1, 0)
        local v38 = p25.LevelUpFrame
        local v39 = not v32
        if v39 then
            if v28 < v33 then
                v39 = not v34
            else
                v39 = false
            end
        end
        v38.Visible = v39
        p25.LevelUpButtonPrice.Text = v_u_4:GetCostToLevelUp(v27, v28)
        p25.NextRewardFrame.Visible = v29 ~= nil
        p25.NextRewardTitle.Text = not v30 and "" or "Reward at Level " .. v_u_5:PrettyNumber(v30)
        if v29 then
            local v40 = v_u_9.new(v29)
            v40:SetParent(p25.NextRewardContainer)
            local v41 = p25._cleanup
            table.insert(v41, v40)
        end
    end
end
function v_u_10._Update(p42)
    local v43 = p42.ComponentsLayout.AbsoluteContentSize.Y > 0 and 1.25 or 1
    p42.Frame.Size = UDim2.new(1, 0, 0, (p42.ComponentsFrame.AbsolutePosition.Y - p42.Frame.AbsolutePosition.Y) * v43 + p42.ComponentsLayout.AbsoluteContentSize.Y)
end
function v_u_10._Init(p_u_44)
    p_u_44.ComponentsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p_u_44:_Update()
    end)
    p_u_44.LevelUpButton.MouseButton1Click:Connect(function()
        if p_u_44._double_clicked then
            p_u_44.Right.Interface.Equipment:LevelUpWeapon()
        else
            p_u_44._double_clicked = true
        end
    end)
    v_u_7:GetDataChangedSignal("WeaponInventory"):Connect(function()
        p_u_44:_UpdateInformation()
    end)
    v_u_7:GetDataChangedSignal("Level"):Connect(function()
        p_u_44:_UpdateInformation()
    end)
    p_u_44:_Update()
    v_u_8:Add(p_u_44.LevelUpButton, nil, {
        ["HoverRatio"] = UDim2.new(0, 10, 0, 10),
        ["ReleaseRatio"] = UDim2.new(0, 10, 0, 10)
    })
end
return v_u_10