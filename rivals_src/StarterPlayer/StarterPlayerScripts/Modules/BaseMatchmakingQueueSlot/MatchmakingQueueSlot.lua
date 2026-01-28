local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.CONSTANTS)
local v_u_4 = require(v1.Modules.DuelLibrary)
require(v1.Modules.Utility)
local v_u_5 = require(v1.Modules.Signal)
local v_u_6 = require(v2.LocalPlayer.PlayerScripts.Controllers:WaitForChild("MatchmakingController"))
local v_u_7 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("BaseMatchmakingQueueSlot"))
local v_u_8 = v2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("MatchmakingQueueSlot")
local v_u_9 = setmetatable({}, v_u_7)
v_u_9.__index = v_u_9
function v_u_9.new(p10, p11)
    local v12 = v_u_4.MatchmakingQueues[p10]
    assert(v12, p10)
    local v13 = v_u_7.new(v_u_8:Clone(), nil, p10 == v_u_3.BEGINNER_QUEUE_NAME)
    local v14 = v_u_9
    local v15 = setmetatable(v13, v14)
    v15.QueueStatus = v_u_5.new()
    v15.QueueName = p10
    v15.Container = p11
    v15._queue_info = v_u_4.MatchmakingQueues[v15.QueueName]
    v15._y_scale = v15.Container:GetAttribute("YScale") or 1
    v15:_Init()
    return v15
end
function v_u_9.Destroy(p16)
    p16.QueueStatus:Destroy()
    v_u_7.Destroy(p16)
end
function v_u_9._Setup(p17)
    p17.Container.BackgroundTransparency = 1
    p17.Container.BorderSizePixel = 0
    p17.Frame.Button.Title.Size = UDim2.new(p17.Frame.Button.Title.Size.X.Scale, p17.Frame.Button.Title.Size.X.Offset, p17.Frame.Button.Title.Size.Y.Scale * p17._y_scale, p17.Frame.Button.Title.Size.Y.Offset * p17._y_scale)
    p17.Frame.Button.Title.Position = UDim2.new(p17.Frame.Button.Title.Position.X.Scale, p17.Frame.Button.Title.Position.X.Offset, 0.5 + (p17.Frame.Button.Title.Position.Y.Scale - 0.5) * p17._y_scale, 0.5 + (p17.Frame.Button.Title.Position.Y.Offset - 0.5) * p17._y_scale)
    p17.Frame.Button.Description.Size = UDim2.new(p17.Frame.Button.Description.Size.X.Scale, p17.Frame.Button.Description.Size.X.Offset, p17.Frame.Button.Description.Size.Y.Scale * p17._y_scale, p17.Frame.Button.Description.Size.Y.Offset * p17._y_scale)
    p17.Frame.Button.Description.Position = UDim2.new(p17.Frame.Button.Description.Position.X.Scale, p17.Frame.Button.Description.Position.X.Offset, 0.5 + (p17.Frame.Button.Description.Position.Y.Scale - 0.5) * p17._y_scale, 0.5 + (p17.Frame.Button.Description.Position.Y.Offset - 0.5) * p17._y_scale)
    p17.Frame.Button.BottomLeft.Size = UDim2.new(p17.Frame.Button.BottomLeft.Size.X.Scale * p17._y_scale, p17.Frame.Button.BottomLeft.Size.X.Offset * p17._y_scale, p17.Frame.Button.BottomLeft.Size.Y.Scale * p17._y_scale, p17.Frame.Button.BottomLeft.Size.Y.Offset * p17._y_scale)
    local v18 = p17._queue_info
    if v18 then
        v18 = p17._queue_info.AreStreaksDisabled
    end
    p17.Frame.Button.Thumbnail.Image = p17._queue_info and (p17._queue_info.Thumbnail or "") or ""
    p17.Frame.Button.Description.Text = p17._queue_info and (p17._queue_info.Description or "") or ""
    p17.Frame.Button.Title.Text = p17._queue_info and (p17._queue_info.DisplayName or "") or ""
    p17.Frame.Button.Title.Position = p17.Frame.Button.Description.Text == "" and UDim2.new(0.5, 0, 0.5, 0) or p17.Frame.Button.Title.Position
    p17.Frame.Button.BottomLeft.StreaksDisabled.Visible = v18 and v18() or false
    p17.Frame.Parent = p17.Container
end
function v_u_9._Init(p_u_19)
    p_u_19.Clicked:Connect(function()
        p_u_19.QueueStatus:Fire(v_u_6:QueueInto(p_u_19.QueueName))
    end)
    p_u_19:_Setup()
end
return v_u_9