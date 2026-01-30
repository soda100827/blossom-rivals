local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.CONSTANTS)
require(v1.Modules.DebugLibrary)
local v_u_4 = require(v1.Modules.Utility)
local v_u_5 = require(v_u_2.LocalPlayer.PlayerScripts.Controllers:WaitForChild("ControlsController"))
local v_u_6 = require(v_u_2.LocalPlayer.PlayerScripts.Controllers:WaitForChild("FighterController"))
local v_u_7 = require(v_u_2.LocalPlayer.PlayerScripts.Controllers:WaitForChild("CameraController"))
local v_u_8 = require(v_u_2.LocalPlayer.PlayerScripts.Modules:WaitForChild("InsetButtonsBar"))
local v_u_9 = require(v_u_2.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Pages"))
local v_u_10 = require(v_u_2.LocalPlayer.PlayerScripts.Modules:WaitForChild("UILibrary"))
local v_u_11 = require(v_u_2.LocalPlayer.PlayerScripts.Modules.Pages:WaitForChild("Inbox"))
local v_u_12 = v_u_2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("InboxNotification")
local v_u_13 = {
    {
        "Open",
        "See more",
        "rbxassetid://14641612286",
        nil,
        nil,
        nil
    },
    {
        "Settings",
        "Change your crosshair & hotkeys",
        "rbxassetid://14641612286",
        nil,
        nil,
        "Settings"
    },
    {
        "PatchNotes",
        "Read the latest news",
        "rbxassetid://18457336026",
        nil,
        nil,
        "PatchNotes"
    },
    {
        "Inbox",
        "View your recent notifications",
        "rbxassetid://96509180790493",
        nil,
        nil,
        "Inbox"
    },
    {
        "PrivateServerControls",
        "Edit your private server",
        "rbxassetid://12343093905",
        nil,
        nil,
        "PrivateServerControls"
    },
    {
        "MobileEditor",
        "Edit your touch screen buttons",
        "rbxassetid://98757786697658",
        UDim2.new(0.525, 0, 0.525, 0),
        UDim2.new(0.55, 0, 0.55, 0),
        nil
    },
    {
        "Freecam",
        "Turn on freecam mode",
        "rbxassetid://17548980857",
        nil,
        nil,
        nil
    }
}
local v_u_14 = {}
v_u_14.__index = v_u_14
function v_u_14.new(p15)
    local v16 = v_u_14
    local v17 = setmetatable({}, v16)
    v17.Inset = p15
    v17.Bar = v_u_8.new(v_u_10.BUTTON_BACKGROUND_TRANSPARENCY, v_u_10.BUTTON_BACKGROUND_COLOR, v_u_10.BUTTON_ICON_COLOR, true)
    v17._inbox_notification_frame = v_u_12:Clone()
    v17._local_fighter = nil
    v17:_Init()
    return v17
end
function v_u_14.SetVisible(p18, p19, p20)
    p18.Bar.Frame.Visible = p19
    p18.Bar.Frame.Size = p20 or p18.Bar.Frame.Size
    local v21 = p18.Bar
    local v22
    if p18.Bar.Frame.Visible then
        v22 = p18.Bar.IsOpen
    else
        v22 = false
    end
    v21:Toggle(v22)
end
function v_u_14._UpdateFreecam(p23)
    local v24 = v_u_7.CameraState:HasFreecamAccess()
    local v25 = v_u_7:GetPublicState() == v_u_7.CameraState.States.CustomFreecam
    local v26 = p23.Bar.Buttons.Freecam.Frame
    local v27 = v24 and not v25
    if v27 then
        v27 = v_u_5.CurrentControls == "MouseKeyboard"
    end
    v26.Visible = v27
end
function v_u_14._UpdateMirrored(p28)
    local v29
    if v_u_5.CurrentControls == "Touch" then
        v29 = not p28._local_fighter or p28._local_fighter:Get("IsInDuel") or (p28._local_fighter:Get("IsInShootingRange") or #p28._local_fighter.Items > 0)
    else
        v29 = false
    end
    p28.Bar:SetMirrored(not v29)
    p28.Bar.Frame.Parent = v29 and p28.Inset.LeftButtonsFrame or p28.Inset.RightButtonsFrame
end
function v_u_14._UpdateInbox(p30)
    local v31 = v_u_11:GetNumNewNotifications()
    p30.Bar.Buttons.Inbox.Frame.Visible = v_u_11:GetNumNotifications() > 0
    p30._inbox_notification_frame.Title.Text = v_u_4:PrettyNumber(v31)
    local v32 = p30._inbox_notification_frame
    local v33
    if v31 <= 0 then
        v33 = nil
    elseif p30.Bar.IsOpen then
        v33 = p30.Bar.Buttons.Inbox.Frame.Button
    else
        v33 = p30.Bar.Buttons.Open.Frame.Button
    end
    v32.Parent = v33
end
function v_u_14._UpdateOpenButton(p34)
    local v35 = p34.Bar.Buttons.Open
    local v36 = v35.Frame.Button.Icon.Image
    v35.Frame.Button.OnHover.Bubble.Container.Title.Text = p34.Bar.IsOpen and "See less" or "See more"
    v35.Frame.Button.Icon.Image = p34.Bar.IsOpen and "rbxassetid://108220438104376" or "rbxassetid://14641612286"
    if v35.Frame.Button.Icon.Image ~= v36 then
        if v35.Frame.Button:IsDescendantOf(v_u_2) then
            v35.Frame.Button.Icon.Size = UDim2.new(0, 0, 0, 0)
            v35.Frame.Button.Icon:TweenSize(UDim2.new(0.5, 0, 0.5, 0), "Out", "Quint", 0.25, true)
            return
        end
        v35.Frame.Button.Icon.Size = UDim2.new(0.5, 0, 0.5, 0)
    end
end
function v_u_14._UpdateMobileEditorVisibility(p37)
    local v38 = v_u_5.CurrentControls == "Touch"
    p37.Bar.Buttons.MobileEditor.Frame.Visible = v38
    if p37.Inset.MobileEditorBar.Bar.Frame.Visible and not v38 then
        p37.Inset.MobileEditorBar:SetVisible(false)
    end
end
function v_u_14._HookLocalFighter(p_u_39)
    p_u_39._local_fighter = v_u_6:WaitForLocalFighter()
    p_u_39._local_fighter:GetDataChangedSignal("IsInDuel"):Connect(function()
        p_u_39:_UpdateMirrored()
    end)
    p_u_39._local_fighter:GetDataChangedSignal("IsInShootingRange"):Connect(function()
        p_u_39:_UpdateMirrored()
    end)
    p_u_39._local_fighter.ItemAdded:Connect(function()
        p_u_39:_UpdateMirrored()
    end)
    p_u_39._local_fighter.ItemRemoved:Connect(function()
        p_u_39:_UpdateMirrored()
    end)
    p_u_39:_UpdateMirrored()
end
function v_u_14._Setup(p_u_40)
    for v41, v42 in pairs(v_u_13) do
        local v43, v44, v45, v46, v47, v_u_48 = table.unpack(v42)
        p_u_40.Bar:CreateButton(v41, v43, v44, v45, v46, v47).Clicked:Connect(function()
            if v_u_48 then
                v_u_9.PageSystem:OpenPage(v_u_48)
            end
        end)
    end
    p_u_40.Bar.Buttons.Open.Clicked:Connect(function()
        p_u_40.Bar:Toggle()
    end)
    p_u_40.Bar.Buttons.MobileEditor.Clicked:Connect(function()
        p_u_40.Inset.MobileEditorBar:SetVisible(true, p_u_40.Bar.Frame.Size)
    end)
    p_u_40.Bar.Buttons.Freecam.Clicked:Connect(function()
        v_u_7.CameraState:SetCustomFreecamEnabled(v_u_7:GetPublicState() ~= v_u_7.CameraState.States.CustomFreecam)
    end)
    local v49 = p_u_40.Bar.Buttons.PrivateServerControls.Frame
    local v50 = v_u_3.IS_PRIVATE_HUB_SERVER
    if v50 then
        v50 = v_u_3.IS_PRIVATE_SERVER_OWNER(v_u_2.LocalPlayer.UserId)
    end
    v49.Visible = v50
    p_u_40.Bar.Buttons.Open.Frame.Visible = true
end
function v_u_14._Init(p_u_51)
    p_u_51.Bar.OpenedChanged:Connect(function()
        p_u_51:_UpdateOpenButton()
        p_u_51:_UpdateInbox()
    end)
    v_u_11.NotificationAdded:Connect(function()
        p_u_51:_UpdateInbox()
    end)
    v_u_11.NotificationQueued:Connect(function()
        p_u_51:_UpdateInbox()
    end)
    v_u_5.ControlsChanged:Connect(function()
        p_u_51:_UpdateMirrored()
        p_u_51:_UpdateMobileEditorVisibility()
        p_u_51:_UpdateFreecam()
    end)
    v_u_7.CustomFreecamStateChanged:Connect(function()
        p_u_51:_UpdateFreecam()
    end)
    v_u_7.CameraState.FreecamAccessChanged:Connect(function()
        p_u_51:_UpdateFreecam()
    end)
    p_u_51:_Setup()
    p_u_51:_UpdateInbox()
    p_u_51:_UpdateFreecam()
    p_u_51:_UpdateOpenButton()
    p_u_51:_UpdateMobileEditorVisibility()
    task.defer(p_u_51._HookLocalFighter, p_u_51)
    p_u_51:SetVisible(true)
end
return v_u_14