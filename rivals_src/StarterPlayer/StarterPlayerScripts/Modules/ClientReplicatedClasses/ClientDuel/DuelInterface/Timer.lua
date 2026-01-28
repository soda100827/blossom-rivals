local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("RunService")
local v_u_3 = game:GetService("Players")
local v_u_4 = require(v1.Modules.Utility)
local v_u_5 = require(v1.Modules.Signal)
local v_u_6 = {}
v_u_6.__index = v_u_6
function v_u_6.new(p7)
    local v8 = v_u_6
    local v9 = setmetatable({}, v8)
    v9.TimerChanged = v_u_5.new()
    v9.DuelInterface = p7
    v9.Frame = v9.DuelInterface.Frame:WaitForChild("Top"):WaitForChild("Timer")
    v9.ValueText = v9.Frame:WaitForChild("Value")
    v9.InfiniteIcon = v9.Frame:WaitForChild("Infinite")
    v9.StopwatchText = v9.Frame:WaitForChild("Stopwatch")
    v9._destroyed = false
    v9._is_visible = true
    v9._time_remaining = 0
    v9._countdown_hash = 0
    v9._last4sec_sound = nil
    v9._last10sec_sound = nil
    v9._stopwatch_start = nil
    v9._stopwatch_finish = nil
    v9._stopwatch_connection = nil
    v9:_Init()
    return v9
end
function v_u_6.GetTimeRemaining(p10)
    return p10._time_remaining
end
function v_u_6.SetVisible(p11, p12)
    p11._is_visible = p12
    p11:Update()
end
function v_u_6.Set(p13, p14)
    p13.ValueText.Visible = p14 ~= nil
    p13.InfiniteIcon.Visible = not p13.ValueText.Visible
    p13._countdown_hash = p13._countdown_hash + 1
    if p14 then
        local v15 = p13._countdown_hash
        local v16 = tick()
        while v15 == p13._countdown_hash and tick() - v16 < p14 do
            p13:_SetText(p14 - (tick() - v16))
            v_u_2.RenderStepped:Wait()
        end
        if v15 == p13._countdown_hash then
            p13:_SetText(0)
        end
    else
        return
    end
end
function v_u_6.Pause(p17, p18)
    p17._countdown_hash = p17._countdown_hash + 1
    if p18 then
        p17:_SetText(p18)
    end
    if p17._last4sec_sound then
        p17._last4sec_sound:Destroy()
        p17._last4sec_sound = nil
    end
    if p17._last10sec_sound then
        p17._last10sec_sound:Destroy()
        p17._last10sec_sound = nil
    end
end
function v_u_6.UpdateSizeAndPosition(p19)
    local v20
    if p19.DuelInterface.ClientDuel:Get("ScoresBehavior") == "Duelers" then
        v20 = not p19.DuelInterface.ClientDuel:Get("VoteOptions")
    else
        v20 = false
    end
    local v21 = v20 and UDim2.new(0.5, 0, 0.03, 7.5) or UDim2.new(0.5, 0, 0.04, 10)
    local v22 = v20 and UDim2.new(0.075, 30, 0.0375, 15) or UDim2.new(0.1, 40, 0.05, 20)
    if p19.Frame:IsDescendantOf(v_u_3) then
        p19.Frame:TweenSizeAndPosition(v22, v21, "Out", "Quint", 0.25, true)
    else
        p19.Frame.Size = v22
        p19.Frame.Position = v21
    end
end
function v_u_6.StopwatchStart(p_u_23)
    p_u_23:StopwatchFinish()
    p_u_23.InfiniteIcon.Position = UDim2.new(0.5, 0, 0.4, 0)
    p_u_23.ValueText.Position = UDim2.new(0.5, 0, 0.375, 0)
    p_u_23._stopwatch_start = tick()
    p_u_23._stopwatch_finish = nil
    p_u_23._stopwatch_connection = v_u_2.RenderStepped:Connect(function()
        p_u_23.StopwatchText.Text = string.format("%.3f", tick() - p_u_23._stopwatch_start)
    end)
end
function v_u_6.StopwatchFinish(p24, p25)
    p24._stopwatch_start = nil
    p24._stopwatch_finish = p25
    if p24._stopwatch_connection then
        p24._stopwatch_connection:Disconnect()
        p24._stopwatch_connection = nil
    end
    p24.StopwatchText.Text = p24._stopwatch_finish and string.format("%.3f", p24._stopwatch_finish) or ""
end
function v_u_6.ClearStopwatch(p26)
    p26:StopwatchFinish()
    p26.InfiniteIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
    p26.ValueText.Position = UDim2.new(0.5, 0, 0.5, 0)
end
function v_u_6.Update(p27)
    local v28 = p27.Frame
    local v29 = p27._is_visible and not p27.DuelInterface:IsPageOpen()
    if v29 then
        v29 = not p27.DuelInterface.ClientDuel:Get("HideMostDuelInterfaceElements")
    end
    v28.Visible = v29
end
function v_u_6.Destroy(p30)
    p30._destroyed = true
    p30._countdown_hash = p30._countdown_hash + 1
    p30.TimerChanged:Destroy()
    p30:ClearStopwatch()
end
function v_u_6._SetText(p31, p32)
    p31._time_remaining = p32
    p31.TimerChanged:Fire(p31._time_remaining)
    p31.ValueText.Text = p32 >= 10 and v_u_4:TimeFormat((math.ceil(p32))) or string.format("%.1f", (math.abs(p32)))
    p31.ValueText.TextColor3 = p32 <= 0.05 and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(255, 255, 255)
    if p32 <= 4 then
        if not p31._last4sec_sound and p31.DuelInterface.ClientDuel:Get("Status") == "RoundStarted" then
            p31._last4sec_sound = p31.DuelInterface:CreateSound("rbxassetid://17826390328", 1.25, 1, script, true, 15)
            return
        end
    elseif p32 <= 10 then
        if not p31._last10sec_sound and p31.DuelInterface.ClientDuel:Get("Status") == "RoundStarted" then
            p31._last10sec_sound = p31.DuelInterface:CreateSound("rbxassetid://17826470563", 0.5, 1, script, true, 15)
            return
        end
    else
        if p31._last4sec_sound then
            p31._last4sec_sound:Destroy()
            p31._last4sec_sound = nil
        end
        if p31._last10sec_sound then
            p31._last10sec_sound:Destroy()
            p31._last10sec_sound = nil
        end
    end
end
function v_u_6._Init(p33)
    p33:UpdateSizeAndPosition()
    task.defer(p33._SetText, p33, 0)
end
return v_u_6