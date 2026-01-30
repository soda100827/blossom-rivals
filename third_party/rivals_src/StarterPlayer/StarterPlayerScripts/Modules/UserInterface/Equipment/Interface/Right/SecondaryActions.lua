local v1 = game:GetService("Players")
local v_u_2 = require(v1.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
local v_u_3 = require(v1.LocalPlayer.PlayerScripts.Modules.ButtonEffect)
local v_u_4 = v1.LocalPlayer.PlayerScripts.UserInterface.EquipmentMetricActionSlot
local v_u_5 = {}
v_u_5.__index = v_u_5
function v_u_5.new(p6)
    local v7 = v_u_5
    local v8 = setmetatable({}, v7)
    v8.Right = p6
    v8.Frame = v8.Right.Container:WaitForChild("SecondaryActions")
    v8.Container = v8.Frame:WaitForChild("Container")
    v8.Layout = v8.Container:WaitForChild("Layout")
    v8._last_state = nil
    v8._metric_action_slots = {}
    v8:_Init()
    return v8
end
function v_u_5.SetMetricActionVisible(p9, p10, p11)
    if p9._metric_action_slots[p10] then
        local v12 = p9._metric_action_slots[p10]
        if p11 then
            p11 = p9:_IsMetricActionVisible(p10)
        end
        v12.Visible = p11
        p9:_UpdateVisibility()
    end
end
function v_u_5.CreateMetricAction(p_u_13, p_u_14, p15, p16, p17)
    local v18 = v_u_4:Clone()
    v18.Icon.Image = p15
    v18.Title.Text = p16
    v18.Description.Text = p17
    v18.Name = p_u_14
    v18.Visible = false
    v18.Parent = p_u_13.Container
    p_u_13._metric_action_slots[p_u_14] = v18
    v18.Button.MouseButton1Click:Connect(function()
        p_u_13.Right:SetMetricCardVisible(p_u_14, true)
    end)
    v_u_3:Add(v18.Button, nil, {
        ["HoverRatio"] = UDim2.new(0, 10, 0, 10),
        ["ReleaseRatio"] = UDim2.new(0, 10, 0, 10)
    })
end
function v_u_5.OnStateChanged(p19)
    task.defer(p19._UpdateInformation, p19)
end
function v_u_5.OnOpen(p20)
    p20:_UpdateInformation(true)
end
function v_u_5._IsMetricActionVisible(p21, p22)
    local v23 = p21.Right.Interface.Equipment:IsCareerPageOpen()
    v_u_2:GetWeaponData((p21.Right.Interface.Equipment:GetSelectedWeapon()))
    return (#p22 < 7 or string.sub(p22, 1, 7) ~= "season_") and true or v23
end
function v_u_5._UpdateInformation(p24, p25)
    p24.Right.Interface.Equipment:IsCareerPageOpen()
    v_u_2:GetWeaponData((p24.Right.Interface.Equipment:GetSelectedWeapon()))
    local v26 = p24.Right.Interface.Equipment:GetStateID()
    if p25 or v26 ~= p24._last_state then
        p24._last_state = v26
        p24.Right:ResetMetricCards()
    end
    p24:_UpdateVisibility()
end
function v_u_5._UpdateVisibility(p27)
    local v28 = false
    for _, v29 in pairs(p27._metric_action_slots) do
        v28 = v28 or v29.Visible
    end
    p27.Frame.Visible = v28
end
function v_u_5._UpdateSize(p30)
    p30.Frame.Size = UDim2.new(1, 0, 0, p30.Layout.AbsoluteContentSize.Y)
end
function v_u_5._Init(p_u_31)
    p_u_31.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p_u_31:_UpdateSize()
    end)
    v_u_2:GetDataChangedSignal("WeaponInventory"):Connect(function()
        p_u_31:_UpdateInformation()
    end)
    p_u_31:_UpdateSize()
    p_u_31:_UpdateVisibility()
end
return v_u_5