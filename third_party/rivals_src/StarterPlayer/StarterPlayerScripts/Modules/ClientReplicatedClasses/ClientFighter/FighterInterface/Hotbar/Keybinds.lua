local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("Players")
require(v1.Modules.ItemLibrary)
local v_u_3 = require(v_u_2.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
local v_u_4 = require(v_u_2.LocalPlayer.PlayerScripts.Controllers.ControlsController)
local v_u_5 = require(v_u_2.LocalPlayer.PlayerScripts.Controllers.CameraController)
local v_u_6 = v_u_2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("FighterKeybindSlot")
local v_u_7 = {
    { "QuickUtility", "Quick Utility" },
    { "QuickMelee", "Quick Melee" },
    { "OpenPlayerList", "Open Scoreboard" },
    { "SwitchCameraPOV", "Change Camera" },
    { "UseEmote", "Emote" }
}
local v_u_8 = {}
v_u_8.__index = v_u_8
function v_u_8.new(p9)
    local v10 = v_u_8
    local v11 = setmetatable({}, v10)
    v11.Hotbar = p9
    v11.GamepadEquipLastFrame = v11.Hotbar.Container:WaitForChild("GamepadEquipLast")
    v11.GamepadEquipNextFrame = v11.Hotbar.Frame:WaitForChild("GamepadEquipNext")
    v11.Frame = v11.Hotbar.Frame:WaitForChild("Keybinds")
    v11.Layout = v11.Frame:WaitForChild("Layout")
    v11._connections = {}
    v11._slots = {}
    v11:_Init()
    return v11
end
function v_u_8.UpdateVisuals(p12)
    local v13 = require(v_u_2.LocalPlayer.PlayerScripts.Controllers.EmoteController)
    local v14 = p12.Frame
    local v15 = v_u_3:Get("Settings Keybinds Interface")
    if v15 then
        if #p12.Hotbar.FighterInterface.ClientFighter.Items > 0 then
            v15 = v_u_4.CurrentControls == "MouseKeyboard" and true or v_u_4.CurrentControls == "Gamepad"
        else
            v15 = false
        end
    end
    v14.Visible = v15
    p12._slots.QuickUtility.Visible = p12:_IsQuickAttackKeybindVisible("Utility")
    p12._slots.QuickMelee.Visible = p12:_IsQuickAttackKeybindVisible("Melee")
    p12._slots.OpenPlayerList.Visible = p12.Hotbar.FighterInterface.ClientFighter:Get("IsInDuel")
    p12._slots.SwitchCameraPOV.Visible = v_u_5:HasThirdPersonAccess()
    p12._slots.UseEmote.Visible = v13:CanEmote()
    p12:_UpdateGamepad()
end
function v_u_8.Destroy(p16)
    for _, v17 in pairs(p16._connections) do
        v17:Disconnect()
    end
    p16._connections = {}
end
function v_u_8._IsQuickAttackKeybindVisible(p18, p19)
    local v20 = p18.Hotbar.FighterInterface.ClientFighter:GetQuickAttackIndex(p19)
    local v21 = p18.Hotbar.FighterInterface.ClientFighter.IsLocalPlayer
    if v21 then
        if v20 <= #p18.Hotbar.FighterInterface.ClientFighter.Items then
            v21 = p18.Hotbar.FighterInterface.ClientFighter.EquippedItem ~= p18.Hotbar.FighterInterface.ClientFighter.Items[v20]
        else
            v21 = false
        end
    end
    return v21
end
function v_u_8._UpdateGamepad(p22)
    local v23 = v_u_4.CurrentControls == "Gamepad"
    local v24 = p22.GamepadEquipLastFrame
    local v25
    if v23 then
        v25 = #p22.Hotbar.FighterInterface.ClientFighter.Items > 1
    else
        v25 = v23
    end
    v24.Visible = v25
    local v26 = p22.GamepadEquipNextFrame
    local v27
    if v23 then
        v27 = #p22.Hotbar.FighterInterface.ClientFighter.Items > 1
    else
        v27 = v23
    end
    v26.Visible = v27
    p22.Frame.Position = v23 and UDim2.new(1, 0, 0.956, 0) or UDim2.new(0.99, 0, 0.956, 0)
end
function v_u_8._UpdateBackground(p28)
    p28.Frame.Size = UDim2.new(0, p28.Layout.AbsoluteContentSize.X, v_u_4.CurrentControls == "Gamepad" and 0.044 or 0.034, 0)
end
function v_u_8._Setup(p29)
    for v30, v31 in pairs(v_u_7) do
        local v32, v33 = table.unpack(v31)
        local v_u_34 = v_u_6:Clone()
        v_u_34.Container.Keybind:SetAttribute("InputName", v32)
        v_u_34.Container.Title.Text = v33
        v_u_34.LayoutOrder = -v30
        v_u_34.Parent = p29.Frame
        p29._slots[v32] = v_u_34
        local v_u_35 = v_u_34.Container.Title
        v_u_35:GetPropertyChangedSignal("TextBounds"):Connect(function()
            v_u_34.Size = UDim2.new(1.3, v_u_35.TextBounds.X, 1, 0)
        end)
    end
end
function v_u_8._Init(p_u_36)
    p_u_36.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p_u_36:_UpdateBackground()
    end)
    p_u_36:_Setup()
    p_u_36:_UpdateGamepad()
    p_u_36:_UpdateBackground()
end
return v_u_8