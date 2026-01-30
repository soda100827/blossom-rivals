local v1 = game:GetService("Players")
local v_u_2 = require(v1.LocalPlayer.PlayerScripts.Modules.WeaponStatusHandler)
local v_u_3 = require(v1.LocalPlayer.PlayerScripts.Modules.ButtonEffect)
local v_u_4 = v1.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("EquipmentButtonSlot")
local v_u_5 = {}
v_u_5.__index = v_u_5
function v_u_5.new(p6, p7, p8, p9, p10, p11, p12)
    local v13 = v_u_5
    local v14 = setmetatable({}, v13)
    v14.Name = p6
    v14.Frame = v_u_4:Clone()
    v14.Button = v14.Frame:WaitForChild("Button")
    v14.Background = v14.Button:WaitForChild("Background")
    v14.LockedLeft = v14.Button:WaitForChild("LockedLeft")
    v14.LockedRight = v14.Button:WaitForChild("LockedRight")
    v14.Icon = v14.Button:WaitForChild("Icon")
    v14.Title = v14.Button:WaitForChild("Title")
    v14.Notification = v14.Title:WaitForChild("Notification")
    v14.NotificationTitle = v14.Notification:WaitForChild("Title")
    v14._layout_order = p7
    v14._is_unlocked = p8
    v14._display_name = p9
    v14._image = p10
    v14._status = p11
    v14._num_notifications = p12 or 0
    v14._is_icon_locked = false
    v14._is_active = false
    v14:_Init()
    return v14
end
function v_u_5.SetParent(p15, p16)
    p15.Frame.Parent = p16
end
function v_u_5.SetCareerIcon(p17)
    local v18 = Instance.new("UICorner")
    v18.CornerRadius = UDim.new(0, 8)
    v18.Parent = p17.Icon
    p17.Icon.Size = UDim2.new(1.1, 0, 1.1, 0)
    p17._is_icon_locked = true
end
function v_u_5.SetActive(p19, p20)
    if p19._is_active ~= p20 then
        p19._is_active = p20
        local v21 = p19.Frame
        local v22
        if p19._is_active then
            v22 = UDim2.new(1, 0, 0.25, 0)
        else
            v22 = UDim2.new(1, 0, 0.2, 0)
        end
        v21:TweenSize(v22, "Out", p19._is_active and "Back" or "Quint", 0.5, true)
        local v23 = p19.Icon
        local v24
        if p19._is_active and not p19._is_icon_locked then
            v24 = UDim2.new(0.8, 0, 0.5, 0)
        else
            v24 = UDim2.new(0.2, 0, 0.5, 0)
        end
        v23:TweenPosition(v24, "Out", "Quint", 0.5, true)
        p19.Background.Visible = p19._is_active
        local v25 = p19.LockedLeft
        local v26
        if p19._is_active then
            v26 = UDim2.new(0.5, 0, 0.375, 0)
        else
            v26 = UDim2.new(0.75, 0, 0.375, 0)
        end
        v25.Size = v26
        p19.LockedRight.Size = p19.LockedLeft.Size
        p19.Icon.ImageTransparency = (p19._is_active or p19._is_unlocked) and 0 or 0.5
        local v27 = p19.Title
        local v28
        if p19._is_active or p19._is_unlocked then
            v28 = Color3.fromRGB(255, 255, 255)
        else
            v28 = Color3.fromRGB(0, 0, 0)
        end
        v27.TextColor3 = v28
        p19.Title.TextTransparency = p19._is_active and 0 or 0.5
        p19.LockedLeft.ImageTransparency = p19._is_active and 0 or 0.5
        local v29 = p19.LockedLeft
        local v30
        if p19._is_active then
            v30 = Color3.fromRGB(255, 255, 255)
        else
            v30 = Color3.fromRGB(0, 0, 0)
        end
        v29.ImageColor3 = v30
        p19.LockedRight.ImageTransparency = p19.LockedLeft.ImageTransparency
        p19.LockedRight.ImageColor3 = p19.LockedLeft.ImageColor3
        p19.Frame.ClipsDescendants = not p19._is_active
        p19.Frame.ZIndex = p19._is_active and 2 or 1
        local v31 = p19.Notification
        local v32 = not p19._is_active
        if v32 then
            v32 = p19._num_notifications > 0
        end
        v31.Visible = v32
    end
end
function v_u_5.Destroy(p33)
    p33.Frame:Destroy()
end
function v_u_5._Update(p34)
    p34.LockedLeft.Position = UDim2.new(0.5, -p34.Title.TextBounds.X / 2, 0.5, 0)
    p34.LockedRight.Position = UDim2.new(0.5, p34.Title.TextBounds.X / 2, 0.5, 0)
    p34.Notification.Position = UDim2.new(0.5, p34.Title.TextBounds.X / 2 + p34.Notification.AbsoluteSize.X / 2, 0.5, 0)
end
function v_u_5._Setup(p35)
    p35.Frame.LayoutOrder = p35._layout_order
    p35.LockedLeft.Visible = not p35._is_unlocked
    p35.LockedRight.Visible = not p35._is_unlocked
    p35.Title.Text = p35._display_name
    local v36 = p35.Title
    local v37
    if p35._is_unlocked then
        v37 = Color3.fromRGB(255, 255, 255)
    else
        v37 = Color3.fromRGB(0, 0, 0)
    end
    v36.TextColor3 = v37
    p35.Icon.Image = p35._image
    p35.Icon.ImageColor3 = p35._is_unlocked and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
    p35.Icon.ImageTransparency = p35._is_unlocked and 0 or 0.5
    p35.Icon.Visible = p35._is_unlocked
    p35.Notification.Visible = p35._num_notifications > 0
    p35.NotificationTitle.Text = p35._num_notifications
    v_u_2:ApplyItemStatusToText(p35.Title, p35._status)
    v_u_2:ApplyItemStatusToImage(p35.LockedLeft, p35._status)
    v_u_2:ApplyItemStatusToImage(p35.LockedRight, p35._status)
end
function v_u_5._Init(p_u_38)
    p_u_38.Title:GetPropertyChangedSignal("TextBounds"):Connect(function()
        p_u_38:_Update()
    end)
    p_u_38.Notification:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        p_u_38:_Update()
    end)
    p_u_38:_Setup()
    p_u_38:_Update()
    v_u_3:Add(p_u_38.Button, nil, {
        ["ReleaseRatio"] = 0.95,
        ["HoverRatio"] = 0.95
    })
end
return v_u_5