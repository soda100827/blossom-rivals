local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.EventLibrary)
local v_u_4 = require(v1.Modules.TaskLibrary)
local v_u_5 = require(v1.Modules.Utility)
local v_u_6 = require(v2.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
local v_u_7 = require(v2.LocalPlayer.PlayerScripts.Modules.RewardSlot)
local v_u_8 = v2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("TaskSlot")
local v_u_9 = {}
v_u_9.__index = v_u_9
function v_u_9.new(p10)
    local v11 = v_u_9
    local v12 = setmetatable({}, v11)
    v12.TaskData = p10
    v12.Info = v_u_4.Info[v12.TaskData.Name]
    v12.Frame = v_u_8:Clone()
    v12._connections = {}
    v12._reward_slots = {}
    v12._notification_visible = false
    v12:_Init()
    return v12
end
function v_u_9.SetParent(p13, p14)
    p13.Frame.Parent = p14
end
function v_u_9.SetLocked(p15, p16)
    p15.Frame.Locked.Visible = p16
    p15.Frame.Unlocked.Visible = not p16
end
function v_u_9.ShowNotification(p17, p18)
    local v19 = p17.Frame.Unlocked.Title.Notification
    if p18 then
        p18 = not p17.TaskData.Completed
    end
    v19.Visible = p18
end
function v_u_9.Destroy(p20)
    for _, v21 in pairs(p20._connections) do
        v21:Disconnect()
    end
    p20:_ClearRewards()
    p20.Frame:Destroy()
end
function v_u_9._UpdateNotification(p22)
    p22.Frame.Unlocked.Title.Notification.Position = UDim2.new(0.5, p22.Frame.Unlocked.Title.TextBounds.X / 2 + p22.Frame.Unlocked.Title.AbsoluteSize.Y / 2, 0.5, 0)
end
function v_u_9._ClearRewards(p23)
    for _, v24 in pairs(p23._reward_slots) do
        v24:Destroy()
    end
    p23._reward_slots = {}
end
function v_u_9._UpdateRewards(p25)
    p25:_ClearRewards()
    local v26 = { p25.Info.Rewards, p25.TaskData.BonusRewards or {} }
    for _, v27 in pairs(v26) do
        for _, v28 in pairs(v27) do
            local v29 = v_u_5:CloneTable(v28)
            if v29.Name == "EventCurrency" and v_u_6:Get("EventCurrencyRushProgress") < v_u_3.CURRENCY_RUSH_DAILY_LIMIT then
                v29.Quantity = v29.Quantity * v_u_3.CURRENCY_RUSH_MULTIPLIER
            end
            local v30 = v_u_7.new(v29)
            v30:SetParent(p25.Frame.Unlocked.Reward)
            local v31 = p25._reward_slots
            table.insert(v31, v30)
        end
    end
end
function v_u_9._Setup(p32)
    local v33 = p32.TaskData.Goal or p32.Info.Goal
    local v34 = p32.TaskData.Completed
    local v35 = p32.Frame.Unlocked.Progress.Bar
    local v36 = UDim2.new
    local v37 = p32.TaskData.Progress / v33
    v35.Size = v36(math.clamp(v37, 0, 1), 0, 1, 2)
    p32.Frame.Unlocked.Progress.Bar.BackgroundColor3 = v34 and Color3.fromRGB(100, 255, 50) or Color3.fromRGB(0, 190, 255)
    p32.Frame.Unlocked.Progress.Title.Text = p32.TaskData.Progress .. " / " .. v33
    p32.Frame.Unlocked.Progress.Title.Visible = not v34
    p32.Frame.Unlocked.Progress.Completed.Visible = v34
    p32.Frame.Unlocked.Title.Text = p32.Info.Title
    p32.Frame.Unlocked.Title.Size = #p32.Info.Title > 20 and UDim2.new(0.8, 0, 0.15, 0) or UDim2.new(0.8, 0, 0.1, 0)
    p32.Frame.Unlocked.Icon.Image = p32.Info.Icon
end
function v_u_9._Init(p_u_38)
    p_u_38.Frame.Unlocked.Title:GetPropertyChangedSignal("TextBounds"):Connect(function()
        p_u_38:_UpdateNotification()
    end)
    p_u_38.Frame.Unlocked.Title:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        p_u_38:_UpdateNotification()
    end)
    local v39 = p_u_38._connections
    local v40 = v_u_6:GetDataChangedSignal("EventCurrencyRushProgress")
    table.insert(v39, v40:Connect(function()
        p_u_38:_UpdateRewards()
    end))
    p_u_38:_Setup()
    p_u_38:_UpdateRewards()
    p_u_38:_UpdateNotification()
    p_u_38:ShowNotification(false)
    p_u_38:SetLocked(false)
end
return v_u_9