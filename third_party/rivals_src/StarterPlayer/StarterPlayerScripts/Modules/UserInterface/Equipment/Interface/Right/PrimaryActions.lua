local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.CONSTANTS)
local v_u_4 = require(v1.Modules.ItemLibrary)
local v_u_5 = require(v_u_2.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
local v_u_6 = require(v_u_2.LocalPlayer.PlayerScripts.Modules.WeaponStatusHandler)
local v_u_7 = require(v_u_2.LocalPlayer.PlayerScripts.Modules.ButtonEffect)
local v_u_8 = require(v_u_2.LocalPlayer.PlayerScripts.Modules.UserInterface.Pages)
local v_u_9 = v_u_2.LocalPlayer.PlayerScripts.UserInterface.EquipmentMetricActionSlot
local v_u_10 = {}
v_u_10.__index = v_u_10
function v_u_10.new(p11)
    local v12 = v_u_10
    local v13 = setmetatable({}, v12)
    v13.Right = p11
    v13.Frame = v13.Right.Container:WaitForChild("PrimaryActions")
    v13.Container = v13.Frame:WaitForChild("Container")
    v13.Layout = v13.Container:WaitForChild("Layout")
    v13.ContractsFrame = v13.Container:WaitForChild("Contracts")
    v13.ContractsButton = v13.ContractsFrame:WaitForChild("Button")
    v13.DuelHistoryFrame = v13.Container:WaitForChild("DuelHistory")
    v13.DuelHistoryButton = v13.DuelHistoryFrame:WaitForChild("Button")
    v13.MapsFrame = v13.Container:WaitForChild("Maps")
    v13.MapsButton = v13.MapsFrame:WaitForChild("Button")
    v13.CollectionFrame = v13.Container:WaitForChild("Collection")
    v13.CollectionButton = v13.CollectionFrame:WaitForChild("Button")
    v13.CareerFrame = v13.Container:WaitForChild("Career")
    v13.CareerButton = v13.CareerFrame:WaitForChild("Button")
    v13.CareerIcon = v13.CareerFrame:WaitForChild("Icon")
    v13.WeaponFrame = v13.Container:WaitForChild("Weapon")
    v13.WeaponButton = v13.WeaponFrame:WaitForChild("Button")
    v13.WeaponTitle = v13.WeaponFrame:WaitForChild("Title")
    v13.WeaponIcon = v13.WeaponFrame:WaitForChild("Icon")
    v13._last_state = nil
    v13._back_to_weapon = nil
    v13._metric_action_slots = {}
    v13:_Init()
    return v13
end
function v_u_10.SetMetricActionVisible(p14, p15, p16)
    if p14._metric_action_slots[p15] then
        local v17 = p14._metric_action_slots[p15]
        if p16 then
            p16 = p14:_IsMetricActionVisible(p15)
        end
        v17.Visible = p16
        p14:_UpdateVisibility()
    end
end
function v_u_10.CreateMetricAction(p_u_18, p_u_19, p20, p21, p22)
    local v23 = v_u_9:Clone()
    v23.Icon.Image = p20
    v23.Title.Text = p21
    v23.Description.Text = p22
    v23.Name = p_u_19
    v23.Visible = false
    v23.Parent = p_u_18.Container
    p_u_18._metric_action_slots[p_u_19] = v23
    v23.Button.MouseButton1Click:Connect(function()
        p_u_18.Right:SetMetricCardVisible(p_u_19, true)
    end)
    v_u_7:Add(v23.Button, nil, {
        ["HoverRatio"] = UDim2.new(0, 10, 0, 10),
        ["ReleaseRatio"] = UDim2.new(0, 10, 0, 10)
    })
end
function v_u_10.OnStateChanged(p24)
    task.defer(p24._UpdateInformation, p24)
end
function v_u_10.OnOpen(p25)
    p25:_UpdateInformation(true)
end
function v_u_10._IsMetricActionVisible(p26, p27)
    local v28 = p26.Right.Interface.Equipment:IsCareerPageOpen()
    local v29 = v_u_5:GetWeaponData((p26.Right.Interface.Equipment:GetSelectedWeapon()))
    local v30
    if p27 == "Performance" then
        if v29 == nil then
            return v28
        end
        v30 = true
    else
        if p27 == "Overview" then
            return v29 ~= nil
        end
        if #p27 >= 7 and string.sub(p27, 1, 7) == "season_" then
            return v28
        end
        v30 = true
    end
    return v30
end
function v_u_10._UpdateInformation(p31, p32)
    local v33 = p31.Right.Interface.Equipment:IsCareerPageOpen()
    local v34 = v_u_5:GetWeaponData((p31.Right.Interface.Equipment:GetSelectedWeapon()))
    local v35 = p31.Right.Interface.Equipment:GetStateID()
    if p32 or v35 ~= p31._last_state then
        p31._last_state = v35
        local v36
        if v33 then
            v36 = p31._back_to_weapon
        else
            v36 = nil
        end
        p31._back_to_weapon = v36
        p31.Right:ResetMetricCards()
    end
    local v37 = v_u_4.Items[p31._back_to_weapon]
    p31.WeaponIcon.Image = v37 and (v37.Image or "") or ""
    p31.WeaponTitle.Text = p31._back_to_weapon or ""
    v_u_6:ClearStatusElements(p31.WeaponTitle)
    local v38 = v_u_6
    local v39 = p31.WeaponTitle
    if v37 then
        v37 = v37.Status
    end
    v38:ApplyItemStatusToText(v39, v37)
    local v40 = p31.WeaponFrame
    local v41
    if v33 then
        v41 = p31._back_to_weapon
    else
        v41 = v33
    end
    v40.Visible = v41
    p31.CareerFrame.Visible = false
    p31.ContractsFrame.Visible = v34
    p31.DuelHistoryFrame.Visible = v33
    p31.MapsFrame.Visible = v33
    p31.CollectionFrame.Visible = v33
    p31:_UpdateVisibility()
end
function v_u_10._UpdateVisibility(p42)
    local v43 = p42.ContractsFrame.Visible or (p42.DuelHistoryFrame.Visible or p42.MapsFrame.Visible or (p42.CollectionFrame.Visible or p42.CareerFrame.Visible))
    local v44 = false
    for _, v45 in pairs(p42._metric_action_slots) do
        v44 = v44 or v45.Visible
    end
    p42.Frame.Visible = v43 or v44
end
function v_u_10._UpdateSize(p46)
    p46.Frame.Size = UDim2.new(1, 0, 0, p46.Layout.AbsoluteContentSize.Y)
end
function v_u_10._Setup(p47)
    p47.CareerIcon.Image = string.format(v_u_3.HEADSHOT_IMAGE, v_u_2.LocalPlayer.UserId)
end
function v_u_10._Init(p_u_48)
    p_u_48.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p_u_48:_UpdateSize()
    end)
    p_u_48.ContractsButton.MouseButton1Click:Connect(function()
        v_u_8.PageSystem:OpenPage("Contracts")
        v_u_8.PageSystem:WaitForPage("Contracts"):SetWeapon(p_u_48.Right.Interface.Equipment:GetSelectedWeapon())
    end)
    p_u_48.DuelHistoryButton.MouseButton1Click:Connect(function()
        v_u_8.PageSystem:OpenPage("DuelHistory")
    end)
    p_u_48.MapsButton.MouseButton1Click:Connect(function()
        v_u_8.PageSystem:OpenPage("Maps")
    end)
    p_u_48.CollectionButton.MouseButton1Click:Connect(function()
        v_u_8.PageSystem:OpenPage("Collection")
    end)
    p_u_48.CareerButton.MouseButton1Click:Connect(function()
        p_u_48._back_to_weapon = p_u_48.Right.Interface.Equipment:GetSelectedWeapon()
        p_u_48.Right.Interface.Equipment:OpenCareerPage(true)
    end)
    p_u_48.WeaponButton.MouseButton1Click:Connect(function()
        p_u_48.Right.Interface.Equipment:SelectWeapon(p_u_48._back_to_weapon)
    end)
    v_u_5:GetDataChangedSignal("WeaponInventory"):Connect(function()
        p_u_48:_UpdateInformation()
    end)
    p_u_48:_Setup()
    p_u_48:_UpdateSize()
    p_u_48:_UpdateVisibility()
    p_u_48:CreateMetricAction("Overview", "rbxassetid://18404346057", "Overview", "View weapon metrics")
    p_u_48:CreateMetricAction("Performance", "rbxassetid://17336063541", "Statistics", "See lifetime data")
    v_u_7:Add(p_u_48.ContractsButton, nil, {
        ["HoverRatio"] = UDim2.new(0, 10, 0, 10),
        ["ReleaseRatio"] = UDim2.new(0, 10, 0, 10)
    })
    v_u_7:Add(p_u_48.DuelHistoryButton, nil, {
        ["HoverRatio"] = UDim2.new(0, 10, 0, 10),
        ["ReleaseRatio"] = UDim2.new(0, 10, 0, 10)
    })
    v_u_7:Add(p_u_48.MapsButton, nil, {
        ["HoverRatio"] = UDim2.new(0, 10, 0, 10),
        ["ReleaseRatio"] = UDim2.new(0, 10, 0, 10)
    })
    v_u_7:Add(p_u_48.CollectionButton, nil, {
        ["HoverRatio"] = UDim2.new(0, 10, 0, 10),
        ["ReleaseRatio"] = UDim2.new(0, 10, 0, 10)
    })
    v_u_7:Add(p_u_48.CareerButton, nil, {
        ["HoverRatio"] = UDim2.new(0, 10, 0, 10),
        ["ReleaseRatio"] = UDim2.new(0, 10, 0, 10)
    })
    v_u_7:Add(p_u_48.WeaponButton, nil, {
        ["HoverRatio"] = UDim2.new(0, 10, 0, 10),
        ["ReleaseRatio"] = UDim2.new(0, 10, 0, 10)
    })
end
return v_u_10