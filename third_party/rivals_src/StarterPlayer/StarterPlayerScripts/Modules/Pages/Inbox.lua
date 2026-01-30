local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.Signal)
local v_u_4 = require(v2.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Notifications"))
local v_u_5 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("NotificationSlot"))
local v_u_6 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect"))
local v_u_7 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("Page"))
local v_u_8 = setmetatable({}, v_u_7)
v_u_8.__index = v_u_8
function v_u_8._new()
    local v9 = v_u_7.new(script.Name)
    local v10 = v_u_8
    local v11 = setmetatable(v9, v10)
    v11.NotificationQueued = v_u_3.new()
    v11.NotificationAdded = v_u_3.new()
    v11.CloseButton = v11.PageFrame:WaitForChild("Close")
    v11.List = v11.PageFrame:WaitForChild("List")
    v11.Container = v11.List:WaitForChild("Container")
    v11.Layout = v11.Container:WaitForChild("Layout")
    v11.SlotsFrame = v11.Container:WaitForChild("Slots")
    v11.SlotsContainer = v11.SlotsFrame:WaitForChild("Container")
    v11.SlotsLayout = v11.SlotsContainer:WaitForChild("Layout")
    v11._layout_order = 0
    v11._notification_queue = {}
    v11._notification_slots = {}
    v11._notification_queued_debounce = false
    v11._notification_added_debounce = false
    v11:_Init()
    return v11
end
function v_u_8.GetNumNewNotifications(p12)
    return #p12._notification_queue
end
function v_u_8.GetNumOldNotifications(p13)
    return #p13._notification_slots
end
function v_u_8.GetNumNotifications(p14)
    return p14:GetNumNewNotifications() + p14:GetNumOldNotifications()
end
function v_u_8.AddNotification(p_u_15, p16)
    p_u_15._layout_order = p_u_15._layout_order + 1
    local v17 = v_u_5.new(p16[1], p16[2], p16[3], p16[4], p16[5])
    v17.Frame.LayoutOrder = -p_u_15._layout_order
    v17.Frame.ZIndex = -p_u_15._layout_order
    v17:SetParent(p_u_15.SlotsContainer)
    v17:UpdateAge()
    local v18 = p_u_15._notification_slots
    table.insert(v18, 1, v17)
    local v19 = table.remove(p_u_15._notification_slots, 50)
    if v19 then
        v19:Destroy()
    end
    p_u_15._notification_added_debounce = true
    task.defer(function()
        if p_u_15._notification_added_debounce then
            p_u_15._notification_added_debounce = false
            p_u_15.NotificationAdded:Fire()
        end
    end)
    p_u_15:UpdateAges()
end
function v_u_8.QueueNotification(p_u_20, ...)
    local v21 = {
        ...,
        [5] = tick()
    }
    if p_u_20._is_open then
        p_u_20:AddNotification(v21)
    else
        local v22 = p_u_20._notification_queue
        table.insert(v22, v21)
        p_u_20._notification_queued_debounce = true
        task.defer(function()
            if p_u_20._notification_queued_debounce then
                p_u_20._notification_queued_debounce = false
                p_u_20.NotificationQueued:Fire()
            end
        end)
    end
end
function v_u_8.GenerateQueue(p23)
    local v24 = #p23._notification_queue - 50
    for v25 = math.max(1, v24), #p23._notification_queue do
        p23:AddNotification(p23._notification_queue[v25])
    end
    p23._notification_queue = {}
end
function v_u_8.UpdateAges(p26)
    for _, v27 in pairs(p26._notification_slots) do
        v27:UpdateAge()
    end
end
function v_u_8.Open(p28, ...)
    v_u_7.Open(p28, ...)
    p28:GenerateQueue()
    p28:UpdateAges()
end
function v_u_8._Init(p_u_29)
    p_u_29.CloseButton.MouseButton1Click:Connect(function()
        p_u_29:CloseRequest()
    end)
    p_u_29.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p_u_29.List.CanvasSize = UDim2.new(0, 0, 0, p_u_29.Layout.AbsoluteContentSize.Y)
        p_u_29.List.Active = p_u_29.Layout.AbsoluteContentSize.Y >= p_u_29.List.AbsoluteSize.Y
    end)
    p_u_29.SlotsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p_u_29.SlotsFrame.Size = UDim2.new(1, 0, 0, p_u_29.SlotsLayout.AbsoluteContentSize.Y)
    end)
    v_u_4.NotificationSent:Connect(function(...)
        p_u_29:QueueNotification(...)
    end)
    v_u_6:Add(p_u_29.CloseButton)
end
return v_u_8._new()