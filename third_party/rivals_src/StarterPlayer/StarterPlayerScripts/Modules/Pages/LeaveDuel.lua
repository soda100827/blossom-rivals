local v_u_1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect"))
local v_u_4 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("Page"))
local v_u_5 = setmetatable({}, v_u_4)
v_u_5.__index = v_u_5
function v_u_5._new()
    local v6 = v_u_4.new(script.Name)
    local v7 = v_u_5
    local v8 = setmetatable(v6, v7)
    v8.CloseButton = v8.PageFrame:WaitForChild("Close")
    v8.LeaveButton = v8.PageFrame:WaitForChild("Leave")
    v8.LeaveButtonOnFrame = v8.LeaveButton:WaitForChild("On")
    v8.LeaveButtonCountdownFrame = v8.LeaveButton:WaitForChild("Countdown")
    v8.LeaveButtonCountdownText = v8.LeaveButtonCountdownFrame:WaitForChild("Title")
    v8._countdown_hash = 0
    v8:_Init()
    return v8
end
function v_u_5.Open(p9, ...)
    v_u_4.Open(p9, ...)
    task.spawn(p9._Countdown, p9)
end
function v_u_5._Countdown(p10)
    p10._countdown_hash = p10._countdown_hash + 1
    local _ = p10._countdown_hash
    p10.LeaveButtonCountdownFrame.Visible = true
    p10.LeaveButtonOnFrame.Visible = false
    p10.LeaveButtonCountdownFrame.Visible = false
    p10.LeaveButtonOnFrame.Visible = true
end
function v_u_5._Init(p_u_11)
    p_u_11.CloseButton.MouseButton1Click:Connect(function()
        p_u_11:CloseRequest()
    end)
    p_u_11.LeaveButton.MouseButton1Click:Connect(function()
        if p_u_11.LeaveButtonOnFrame.Visible then
            v_u_1.Remotes.Duels.LeaveDuel:FireServer()
            p_u_11:CloseRequest()
        end
    end)
    v_u_3:Add(p_u_11.CloseButton)
    v_u_3:Add(p_u_11.LeaveButton)
end
return v_u_5._new()