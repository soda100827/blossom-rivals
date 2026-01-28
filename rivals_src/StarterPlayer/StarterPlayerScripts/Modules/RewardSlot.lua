local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("UserInputService")
local v_u_3 = game:GetService("RunService")
local v_u_4 = game:GetService("Players")
local v_u_5 = require(v1.Modules.CosmeticLibrary)
local v_u_6 = require(v1.Modules.ItemLibrary)
local v_u_7 = require(v1.Modules.ShopLibrary)
local v_u_8 = require(v1.Modules.Utility)
local v_u_9 = require(v_u_4.LocalPlayer.PlayerScripts.Modules:WaitForChild("WeaponStatusHandler"))
local v_u_10 = require(v_u_4.LocalPlayer.PlayerScripts.Modules:WaitForChild("CosmeticSlot"))
local v_u_11 = require(v_u_4.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect"))
local v_u_12 = require(v_u_4.LocalPlayer.PlayerScripts.Modules:WaitForChild("UILibrary"))
local v_u_13 = v_u_4.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("RewardBubble")
local v_u_14 = v_u_4.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("RewardSlot")
local v_u_15 = {}
v_u_15.__index = v_u_15
function v_u_15.new(p16, p17, p18)
    local v19 = v_u_15
    local v20 = setmetatable({}, v19)
    v20.RewardData = p16
    v20.CosmeticInfo = v_u_5.Cosmetics[v20.RewardData.Name]
    v20.RewardInfo = v_u_5.Rewards[v20.RewardData.Name]
    v20.Frame = v_u_14:Clone()
    v20.CosmeticSlot = nil
    v20._ignore_button_effects = p17
    v20._is_locked = p18
    v20._key_slot_frame = nil
    v20._bubble_hash = 0
    v20._bubble_frame = nil
    v20._bubble_reward_slot = nil
    v20._bubble_connections = {}
    v20._bubble_auto_close_delay = nil
    v20._on_click_callback = nil
    v20:_Init()
    return v20
end
function v_u_15.GetRewardBubbleTitle(p21)
    local v22 = p21.RewardData.Quantity or 1
    local v23 = p21.RewardInfo and p21.RewardInfo.BubbleTitle
    if not v23 then
        if not p21.RewardInfo or p21.RewardInfo.Type ~= "Weapon" then
            ::l5::
            v23 = p21.RewardInfo and (p21.RewardInfo.PrioritizeNameOverQuantity and v22 == 1) and p21.RewardInfo.DisplayName or p21.RewardInfo and "\195\151" .. v_u_8:PrettyNumber(v22) .. " " .. (v22 ~= 1 and p21.RewardInfo.DisplayNamePlural or p21.RewardInfo.DisplayName) or p21.RewardData.Name .. " " .. v_u_5.Cosmetics[p21.RewardData.Name].Type
            goto l3
        end
        if p21:_IsUnreleasedWeapon() then
            return "COMING SOON"
        end
        v23 = p21.RewardInfo.DisplayName
        if not v23 then
            goto l5
        end
    end
    ::l3::
    return v23
end
function v_u_15.GetRewardBubbleDescription(p24)
    local v25 = p24.RewardInfo and p24.RewardInfo.BubbleDescription or p24.RewardInfo and p24.RewardInfo.Type == "Lootbox" and (p24.RewardData.Weapon and (p24.RewardData.Weapon ~= "IsRandom" and p24.RewardData.Weapon ~= "IsUniversal") and "Contains special items for " .. p24.RewardData.Weapon .. "!" or p24.RewardInfo.LootboxDescription) or p24.RewardInfo and p24.RewardInfo.Type == "Weapon" and (p24:_IsUnreleasedWeapon() and "in " .. v_u_8:TimeFormat2(v_u_7:GetTimeUntilWeaponRelease(p24.RewardData.Name)) .. "!" or v_u_6.Items[p24.RewardData.Name].Status .. " Weapon")
    if not v25 then
        if p24.RewardData.Weapon == "IsUniversal" then
            return "Given to all weapons forever!"
        end
        if p24.RewardData.Weapon == "IsRandom" then
            return "Given to a random weapon!"
        end
        v25 = p24.RewardData.Weapon and "Given to " .. p24.RewardData.Weapon .. "!" or (p24.CosmeticInfo and p24.CosmeticInfo.Description or "???")
    end
    return v25
end
function v_u_15.SetParent(p26, p27)
    p26.Frame.Parent = p27
end
function v_u_15.SetInteractable(p28, p29)
    p28.Frame.Reward.Interactable = p29
    if p28.CosmeticSlot then
        p28.CosmeticSlot:SetInteractable(p29)
    end
end
function v_u_15.SetWeapon(p30, p31)
    if p30.CosmeticSlot then
        return p30.CosmeticSlot:SetWeapon(p31)
    else
        if p31 == "IsRandom" and (p30.RewardInfo and p30.RewardInfo.Type == "Lootbox") then
            p31 = nil
        end
        if p31 then
            local v32 = v_u_6.Items[p31]
            local v33 = v_u_6.ViewModels[p31]
            local v34 = p31 == "IsUniversal" and true or p31 == "IsRandom"
            local v35
            if p31 == "IsUniversal" then
                v35 = v_u_6.UNIVERSAL_WEAPON_ICON
            elseif p31 == "IsRandom" then
                v35 = v_u_6.RANDOM_WEAPON_ICON
            else
                v35 = not v33 and "" or (v33.ImageCentered or v33.Image)
            end
            p30.Frame.Reward.Weapon.Visible = true
            p30.Frame.Reward.Weapon.Container.IconCanvas.Icon.Image = v35
            p30.Frame.Reward.Weapon.Container.IconCanvas.Icon.ImageTransparency = v34 and 0.25 or 0
            p30.Frame.Reward.Weapon.Container.IconCanvas.Icon.Size = v34 and UDim2.new(0.7, 0, 0.7, 0) or UDim2.new(4, 0, 4, 0)
            v_u_9:ApplyItemStatusToBackground(p30.Frame.Reward.Weapon.Container.Background, p30.Frame.Reward.Weapon.Container.Outline.UIStroke, v32 and v32.Status or "Standard")
        else
            p30.Frame.Reward.Weapon.Visible = false
        end
    end
end
function v_u_15.OnClick(p36, p37)
    p36._on_click_callback = p37
end
function v_u_15.HideWeaponVisual(p38)
    p38.Frame.Reward.Weapon.Visible = false
    if p38.CosmeticSlot then
        p38.CosmeticSlot.Frame.Button.Weapon.Visible = false
    end
end
function v_u_15.UseHighResolutionImage(p39)
    if p39.RewardInfo then
        p39.Frame.Reward.Icon.Image = p39.RewardInfo.ImageHighResolution or p39.RewardInfo.Image
    end
    if p39.CosmeticSlot then
        p39.CosmeticSlot:UseHighResolutionImage()
    end
end
function v_u_15.SetNameText(p40, p41)
    p40.Frame.Reward.Title.Text = p41
    if p40.CosmeticSlot then
        p40.CosmeticSlot.Frame.Button.Title.Text = p41
    end
end
function v_u_15.LockedImage(p42)
    p42.Frame.Reward.Icon.ImageColor3 = Color3.fromRGB(0, 0, 0)
    p42.Frame.Reward.Icon.ImageTransparency = 0.5
    if p42.CosmeticSlot then
        p42.CosmeticSlot.Frame.Button.Icon.ImageColor3 = Color3.fromRGB(0, 0, 0)
        p42.CosmeticSlot.Frame.Button.Icon.ImageTransparency = 0.5
    end
end
function v_u_15.InvertNameText(p43)
    if p43.RewardInfo and p43.RewardInfo.Type == "Weapon" then
        p43.Frame.Reward.Title.Visible = false
    else
        p43.Frame.Reward.Title.TextColor3 = Color3.fromRGB(0, 0, 0)
        p43.Frame.Reward.Title.UIStroke.Enabled = false
    end
end
function v_u_15.SetBubbleAutoCloseDelay(p44, p45)
    p44._bubble_auto_close_delay = p45
end
function v_u_15.CloseBubble(p46)
    p46._bubble_hash = p46._bubble_hash + 1
    for _, v47 in pairs(p46._bubble_connections) do
        v47:Disconnect()
    end
    p46._bubble_connections = {}
    p46._open_bubble_upwards = nil
    if p46._bubble_frame then
        p46._bubble_frame:Destroy()
        p46._bubble_frame = nil
    end
    if p46._bubble_reward_slot then
        p46._bubble_reward_slot:Destroy()
        p46._bubble_reward_slot = nil
    end
    v_u_3:UnbindFromRenderStep("RewardSlotOpenBubble")
end
function v_u_15.OpenBubble(p_u_48, p49, p50)
    p_u_48:CloseBubble()
    p_u_48._open_bubble_upwards = p49
    p_u_48._bubble_hash = p_u_48._bubble_hash + 1
    local v_u_51 = p_u_48._bubble_hash
    local v52 = p50 or 1
    local v53 = UDim2.new(v_u_13.Size.X.Scale * v52, v_u_13.Size.X.Offset * v52, v_u_13.Size.Y.Scale * v52, v_u_13.Size.Y.Offset * v52)
    local v_u_54 = UDim2.new(v53.X.Scale / 2, v53.X.Offset / 2, v53.Y.Scale / 2, v53.Y.Offset / 2)
    p_u_48._bubble_frame = v_u_13:Clone()
    p_u_48._bubble_frame.Title.Text = p_u_48:GetRewardBubbleTitle()
    p_u_48._bubble_frame.Description.Text = p_u_48:GetRewardBubbleDescription()
    p_u_48._bubble_frame.Size = v_u_54
    p_u_48._bubble_frame.Parent = v_u_12:GetTo("MainFrame")
    p_u_48._bubble_frame:TweenSize(v53, "Out", "Back", 0.25, true)
    p_u_48._bubble_reward_slot = v_u_15.new(p_u_48.RewardData, true)
    p_u_48._bubble_reward_slot:OnClick(function() end)
    p_u_48._bubble_reward_slot:InvertNameText()
    p_u_48._bubble_reward_slot:SetParent(p_u_48._bubble_frame.Reward)
    if p_u_48:_IsUnreleasedWeapon() then
        p_u_48._bubble_reward_slot:LockedImage()
    end
    if p_u_48.RewardInfo and p_u_48.RewardInfo.Type == "Weapon" then
        local v55 = v_u_6.Items[p_u_48.RewardInfo.DisplayName]
        if v55 then
            v55 = v_u_6.Items[p_u_48.RewardInfo.DisplayName].Status
        end
        v_u_9:ApplyItemStatusToText(p_u_48._bubble_frame.Title, v55)
        v_u_9:ApplyItemStatusToText(p_u_48._bubble_frame.Description, v55)
    elseif p_u_48.RewardData and p_u_48.RewardData.Weapon then
        local v56 = v_u_9
        local v57 = p_u_48._bubble_frame.Description
        local v58 = v_u_6.Items[p_u_48.RewardData.Weapon]
        if v58 then
            v58 = v_u_6.Items[p_u_48.RewardData.Weapon].Status
        end
        v56:ApplyItemStatusToText(v57, v58)
    elseif p_u_48.RewardInfo and p_u_48.RewardInfo.NameStatus then
        v_u_9:ApplyItemStatusToText(p_u_48._bubble_frame.Title, p_u_48.RewardInfo.NameStatus)
    end
    local v59 = p_u_48._bubble_connections
    local v60 = v_u_2.InputBegan
    table.insert(v59, v60:Connect(function(p61)
        if p61.UserInputType == Enum.UserInputType.MouseButton1 or (p61.UserInputType == Enum.UserInputType.Touch or (p61.KeyCode == Enum.KeyCode.ButtonA or p61.KeyCode == Enum.KeyCode.ButtonB)) then
            p_u_48:CloseBubble()
        end
    end))
    local v62 = p_u_48._bubble_connections
    local v63 = p_u_48.Frame.AncestryChanged
    local function v64()
        if not (p_u_48.Frame:IsDescendantOf(workspace) or p_u_48.Frame:IsDescendantOf(v_u_4.LocalPlayer.PlayerGui)) then
            p_u_48:CloseBubble()
        end
    end
    table.insert(v62, v63:Connect(v64))
    local v65 = p_u_48._bubble_connections
    local v66 = p_u_48.Frame:GetPropertyChangedSignal("AbsolutePosition")
    table.insert(v65, v66:Connect(function()
        p_u_48:_UpdateBubblePosition()
    end))
    local v67 = p_u_48._bubble_connections
    local v68 = p_u_48.Frame:GetPropertyChangedSignal("AbsoluteSize")
    table.insert(v67, v68:Connect(function()
        p_u_48:_UpdateBubblePosition()
    end))
    v_u_3:BindToRenderStep("RewardSlotOpenBubble", Enum.RenderPriority.Camera.Value - 1, function()
        p_u_48:_UpdateBubblePosition()
    end)
    p_u_48:_UpdateBubblePosition()
    if p_u_48._bubble_auto_close_delay then
        task.delay(p_u_48._bubble_auto_close_delay, function()
            if p_u_48._bubble_hash == v_u_51 then
                p_u_48._bubble_frame:TweenSize(v_u_54, "In", "Quint", 0.25, true)
                wait(0.25)
                if p_u_48._bubble_hash == v_u_51 then
                    p_u_48:CloseBubble()
                end
            else
                return
            end
        end)
    end
end
function v_u_15.Destroy(p69)
    p69:CloseBubble()
    p69.Frame:Destroy()
    if p69.CosmeticSlot then
        p69.CosmeticSlot:Destroy()
    end
end
function v_u_15._IsUnreleasedWeapon(p70)
    local v71 = p70.RewardInfo
    if v71 then
        if p70.RewardInfo.Type == "Weapon" then
            v71 = not table.find(v_u_7:GetReleasedOwnableWeapons(), p70.RewardData.Name)
        else
            v71 = false
        end
    end
    return v71
end
function v_u_15._OnClick(p72)
    if p72._on_click_callback then
        return p72._on_click_callback()
    end
    p72:OpenBubble()
end
function v_u_15._GetLayerCollector(p73)
    local v74 = p73.Frame.Parent
    while v74 and not v74:IsA("LayerCollector") do
        v74 = v74.Parent
    end
    return v74
end
function v_u_15._UpdateBubblePosition(p75)
    if p75._bubble_frame.Parent then
        local v76 = p75:_GetLayerCollector()
        local v77
        if v76 then
            v77 = v76:IsA("SurfaceGui")
        else
            v77 = v76
        end
        local v78, v79
        if v77 then
            local v80 = v76.Adornee or v76.Parent
            if v80:IsA("BasePart") then
                local v81 = workspace.CurrentCamera:WorldToScreenPoint(v80.Position)
                if v81.Z < 0 then
                    v78 = -p75._bubble_frame.AbsoluteSize * 10
                else
                    v78 = v_u_12:ScreenPointToPosition(v81)
                end
            else
                v78 = Vector2.new()
            end
            v79 = Vector2.new()
        else
            v78 = p75.Frame.AbsolutePosition
            v79 = p75.Frame.AbsoluteSize
        end
        local v82 = v78 - p75._bubble_frame.Parent.AbsolutePosition
        local v83
        if p75._open_bubble_upwards == true then
            v83 = false
        else
            v83 = p75._open_bubble_upwards == false and true or v82.Y + v79.Y / 2 < p75._bubble_frame.Parent.AbsoluteSize.Y / 2
        end
        local v84 = p75._bubble_frame
        local v85 = UDim2.new
        local v86 = v82.X + v79.X / 2
        local v87 = p75._bubble_frame.AbsoluteSize.X / 2 + 10
        local v88 = p75._bubble_frame.Parent.AbsoluteSize.X - p75._bubble_frame.AbsoluteSize.X / 2 - 10
        v84.Position = v85(0, math.clamp(v86, v87, v88), v77 and 0 or (v83 and 0.02 or -0.02), v82.Y + (not v83 and 0 or v79.Y))
        local v89 = p75._bubble_frame
        local v90
        if v83 then
            v90 = Vector2.new(0.5, 0)
        else
            v90 = Vector2.new(0.5, 1)
        end
        v89.AnchorPoint = v90
        local v91 = p75._bubble_frame.Arrow
        local v92 = UDim2.new
        local v93 = v82.X + v79.X / 2 - (p75._bubble_frame.AbsolutePosition.X - p75._bubble_frame.Parent.AbsolutePosition.X)
        local v94 = p75._bubble_frame.Arrow.AbsoluteSize.X * 0.875 + 10
        local v95 = p75._bubble_frame.AbsoluteSize.X - p75._bubble_frame.Arrow.AbsoluteSize.X * 0.875 - 10
        v91.Position = v92(0, math.clamp(v93, v94, v95), v83 and 0 or 1, v83 and 2 or -2)
    end
end
function v_u_15._Setup(p_u_96)
    if p_u_96.CosmeticInfo then
        p_u_96.CosmeticSlot = v_u_10.new(p_u_96.RewardData.Name, p_u_96._is_locked, p_u_96._ignore_button_effects)
        p_u_96.CosmeticSlot:SetQuantity(p_u_96.RewardData.Quantity)
        p_u_96.CosmeticSlot.Frame.Parent = p_u_96.Frame
        p_u_96.CosmeticSlot.Frame.Button.MouseButton1Click:Connect(function()
            p_u_96:_OnClick()
        end)
    elseif p_u_96.RewardInfo then
        local v97 = v_u_6.Items[p_u_96.RewardData.Name]
        local v98 = p_u_96.RewardInfo.Type ~= "Weapon" and p_u_96.RewardInfo.PrioritizeNameOverQuantity
        if v98 then
            v98 = (p_u_96.RewardData.Quantity or 1) == 1
        end
        p_u_96.Frame.Reward.Visible = true
        p_u_96.Frame.Reward.Title.Text = v98 and p_u_96.RewardInfo.DisplayName or "\195\151" .. v_u_8:PrettyNumber(p_u_96.RewardData.Quantity or 1)
        p_u_96.Frame.Reward.Title.Size = v98 and UDim2.new(0.9, 0, 0.2, 0) or UDim2.new(0.9, 0, 0.4, 0)
        p_u_96.Frame.Reward.Icon.Image = p_u_96.RewardInfo.Image
        p_u_96.Frame.Reward.Icon.Size = UDim2.new(p_u_96.RewardInfo.ImageScale, 0, p_u_96.RewardInfo.ImageScale, 0)
        local v99 = v_u_9
        local v100 = p_u_96.Frame.Reward.Title
        local v101 = p_u_96.RewardInfo.NameStatus
        if v101 then
            v97 = v101
        elseif v97 then
            v97 = v97.Status
        end
        v99:ApplyItemStatusToText(v100, v97)
        p_u_96.Frame.Reward.MouseButton1Click:Connect(function()
            p_u_96:_OnClick()
        end)
        if not p_u_96._ignore_button_effects then
            v_u_11:Add(p_u_96.Frame.Reward)
        end
    else
        warn("reward_data = {")
        for v102, v103 in pairs(p_u_96.RewardData) do
            warn("\t", v102, v103)
        end
        warn("}")
        local v104 = p_u_96.RewardData.Name
        assert(false, v104)
    end
    p_u_96:SetWeapon(p_u_96.RewardData.Weapon)
end
function v_u_15._Init(p105)
    p105:_Setup()
end
return v_u_15