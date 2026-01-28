local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("TweenService")
local v3 = game:GetService("Players")
local v_u_4 = require(v1.Modules.BetterDebris)
local v_u_5 = require(v1.Modules.Signal)
local v_u_6 = require(v1.Modules.Spring)
local v_u_7 = require(v3.LocalPlayer.PlayerScripts.Controllers.ControlsController)
local v_u_8 = v3.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("HotbarCooldownSlot")
local v_u_9 = v3.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("HotbarSlot")
local v_u_10 = {
    "EquipPrimary",
    "EquipSecondary",
    "EquipMelee",
    "EquipUtility"
}
local v_u_11 = {}
v_u_11.__index = v_u_11
function v_u_11.new(p12, p13)
    local v14 = v_u_11
    local v15 = setmetatable({}, v14)
    v15.Clicked = v_u_5.new()
    v15.Hotbar = p12
    v15.ClientItem = p13
    v15.Frame = v_u_9:Clone()
    v15.Background = v15.Frame:WaitForChild("Background")
    v15.Button = v15.Frame:WaitForChild("Button")
    v15.Icon = v15.Frame:WaitForChild("Icon")
    v15.CooldownsFrame = v15.Frame:WaitForChild("Cooldowns")
    v15.MouseKeyboardInputKeybind = v15.Frame:WaitForChild("Inputs"):WaitForChild("MouseKeyboard"):WaitForChild("Keybind")
    v15._connections = {}
    v15._item_slot_rotation_spring = v_u_6.new(0, 1, 20)
    v15._item_slot_position_spring = v_u_6.new(0, 0.75, 20)
    v15._item_slot_color_spring = v_u_6.new(0, 1, 10)
    v15:_Init()
    return v15
end
function v_u_11.EquipEffect(p16)
    p16._item_slot_position_spring.Velocity = -10
end
function v_u_11.RollEffect(p17)
    p17._item_slot_position_spring.Velocity = -40
    local v18 = p17._item_slot_rotation_spring
    v18.Target = v18.Target + 360
end
function v_u_11.QuickAttackFailedEffect(p19)
    p19._item_slot_position_spring.Value = 0.25
    p19._item_slot_color_spring.Value = 1
    p19.Hotbar.FighterInterface:CreateSound("rbxassetid://17153811469", 2, 1, script, true, 5)
end
function v_u_11.CooldownEffect(p20, p21, p22, _, p23)
    local v24 = v_u_8:Clone()
    v24.Icon.Image = p21
    v24.Bar.Bar.Size = UDim2.new(p23 and 0 or 1, 0, 1.5, 0)
    v24.Parent = p20.CooldownsFrame
    v_u_4:AddItem(v24, p22)
    v_u_2:Create(v24.Bar.Bar, TweenInfo.new(p22, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
        ["Size"] = UDim2.new(p23 and 1 or 0, 0, 1.5, 0)
    }):Play()
    return v24
end
function v_u_11.UpdateVisuals(p25)
    local v26 = p25.Hotbar.FighterInterface.ClientFighter.EquippedItem == p25.ClientItem
    local v27 = p25.ClientItem:Get("ItemIndex")
    local v28 = p25.ClientItem.ClientFighter.IsLocalPlayer
    if v28 then
        v28 = v_u_10[v27]
    end
    p25.Frame.ZIndex = v26 and 999 or v27
    p25.Frame.LayoutOrder = v27
    p25.Frame.Size = v26 and UDim2.new(1, 0, 1, 0) or UDim2.new(0.75, 0, 0.75, 0)
    local v29 = p25.Background
    local v30
    if v27 % 2 == 0 then
        v30 = v26 and "rbxassetid://13220167337" or "rbxassetid://13188242287"
    else
        v30 = v26 and "rbxassetid://13220167472" or "rbxassetid://13188242420"
    end
    v29.Image = v30
    p25.Background.ImageTransparency = v26 and 0 or 0.7
    local v31 = p25.MouseKeyboardInputKeybind
    local v32
    if v28 then
        v32 = not v26
    else
        v32 = v28
    end
    v31.Visible = v32
    p25.MouseKeyboardInputKeybind:SetAttribute("InputName", v28)
end
function v_u_11.UpdateVisibility(p33)
    p33.Frame.Visible = v_u_7.CurrentControls ~= "Touch" and true or not p33.Hotbar.FighterInterface.ClientFighter.IsLocalPlayer
end
function v_u_11.Update(p34, _, _)
    p34.Icon.Rotation = p34._item_slot_rotation_spring.Value
    p34.Icon.Position = UDim2.new(0.5, 0, 0.5 + p34._item_slot_position_spring.Value, 0)
    p34.Icon.ImageColor3 = Color3.fromRGB(255, 255, 255):Lerp(Color3.fromRGB(127, 0, 0), 1 - (1 - p34._item_slot_color_spring.Value) ^ 2)
end
function v_u_11.Destroy(p35)
    for _, v36 in pairs(p35._connections) do
        v36:Disconnect()
    end
    p35.Clicked:Destroy()
    p35.Frame:Destroy()
end
function v_u_11._Setup(p37)
    p37.Frame.Name = p37.ClientItem.Name
    p37.Icon.Image = p37.ClientItem.ViewModel:GetImage()
end
function v_u_11._Init(p_u_38)
    p_u_38.Button.MouseButton1Click:Connect(function()
        p_u_38.Clicked:Fire()
    end)
    local v39 = p_u_38._connections
    local v40 = p_u_38.ClientItem:GetDataChangedSignal("ItemIndex")
    table.insert(v39, v40:Connect(function()
        p_u_38:UpdateVisuals()
    end))
    p_u_38:_Setup()
    p_u_38:UpdateVisuals()
    p_u_38:UpdateVisibility()
end
return v_u_11