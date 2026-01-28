local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("TweenService")
local v_u_3 = game:GetService("RunService")
local v4 = game:GetService("Players")
local v_u_5 = require(v1.Modules.CONSTANTS)
local v_u_6 = require(v1.Modules.FunFacts)
local v_u_7 = require(v1.Modules.Utility)
local v_u_8 = require(v1.Modules.Signal)
local v_u_9 = require(v4.LocalPlayer.PlayerScripts.Controllers:WaitForChild("MatchmakingController"))
local v_u_10 = require(v4.LocalPlayer.PlayerScripts.Modules:WaitForChild("UserInterface"):WaitForChild("Notifications"))
local v_u_11 = require(v4.LocalPlayer.PlayerScripts.Modules:WaitForChild("UILibrary"))
local v_u_12 = {}
v_u_12.__index = v_u_12
function v_u_12._new()
    local v13 = v_u_12
    local v14 = setmetatable({}, v13)
    v14.VisibilityChanged = v_u_8.new()
    v14.Frame = v_u_11:GetTo("MatchmadeOverlay")
    v14._countdown_hash = 0
    v14._aborted_notification = false
    v14._cover_part = Instance.new("Part")
    v14._cover_connection = nil
    v14:_Init()
    return v14
end
function v_u_12.IsVisible(p15)
    return p15.Frame.Visible
end
function v_u_12._Countdown(p16)
    p16._countdown_hash = p16._countdown_hash + 1
    local v17 = p16._countdown_hash
    local v18 = v_u_9:Get("MatchmadeCountdown") or 0
    p16.Frame.Countdown.Visible = v18 > 0
    p16.Frame.Countdown.Value.Text = v18
    if v18 <= 0 then
        return
    else
        v_u_7:CreateSound("rbxassetid://17259538274", 0.5, 1, script, true, 5)
        local v19 = tick()
        while tick() < v19 + 0.375 do
            if v17 ~= p16._countdown_hash then
                return
            end
            local v20 = (tick() - v19) / 0.375
            local v21 = v_u_2:GetValue(v20, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
            local v22 = v_u_2:GetValue(v20, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
            p16.Frame.Countdown.Value.Size = UDim2.new(1, 0, 1.25 - 0.625 * v21)
            p16.Frame.Countdown.Glow.ImageTransparency = 0.875 - 0.25 * v22
            p16.Frame.Countdown.Glow.Size = UDim2.new(v22, 0, v22, 0)
            v_u_3.RenderStepped:Wait()
        end
        local v23 = tick()
        while tick() < v23 + 0.625 do
            if v17 ~= p16._countdown_hash then
                return
            end
            local v24 = (tick() - v23) / 0.625
            local v25 = v_u_2:GetValue(v24, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
            local v26 = v_u_2:GetValue(v24, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
            p16.Frame.Countdown.Value.Size = UDim2.new(1, 0, 0.625 - 0.625 * v25)
            p16.Frame.Countdown.Glow.ImageTransparency = 0.625 + 0.25 * v26
            v_u_3.RenderStepped:Wait()
        end
        if v17 == p16._countdown_hash then
            p16.Frame.Countdown.Visible = false
        end
    end
end
function v_u_12._Update(p_u_27)
    local v28 = v_u_9:Get("MatchmadeStatus")
    local v29 = v_u_9:Get("MatchmadeExpectedPlayers")
    local v30 = p_u_27.Frame
    local v31 = v_u_5.IS_MATCHMAKING_SERVER and not v_u_9:Get("MatchmadeGameOver")
    if v31 then
        v31 = v28 == "Waiting" and true or v28 == "Starting"
    end
    v30.Visible = v31
    p_u_27.Frame.Waiting.Visible = v28 == "Waiting"
    p_u_27.Frame.Waiting.Title.Text = not v29 and "Waiting for server" or string.format("Waiting for players   %s / %s", v_u_9:Get("MatchmadeConnectedPlayers") or 0, v29)
    if p_u_27.Frame.Waiting.Visible then
        p_u_27.Frame.Waiting.Dots:AddTag("UILoadingDots")
    else
        p_u_27.Frame.Waiting.Dots:RemoveTag("UILoadingDots")
    end
    if p_u_27.Frame.Visible and not p_u_27._cover_connection then
        p_u_27._cover_part.Parent = workspace
        p_u_27._cover_connection = v_u_3.RenderStepped:Connect(function()
            p_u_27._cover_part.CFrame = workspace.CurrentCamera.CFrame * CFrame.new(0, 0, -1)
        end)
    elseif not p_u_27.Frame.Visible and p_u_27._cover_connection then
        p_u_27._cover_part.Parent = nil
        p_u_27._cover_connection:Disconnect()
        p_u_27._cover_connection = nil
    end
    if v28 == "Aborted" and not p_u_27._aborted_notification then
        p_u_27._aborted_notification = true
        v_u_10:Queue("Duel Cancelled", "Not enough players connected", "rbxassetid://18553001997", nil, 0.75)
    end
end
function v_u_12._Setup(p32)
    p32._cover_part.Size = Vector3.new(10, 10, 0)
    p32._cover_part.Anchored = true
    p32._cover_part.CanCollide = false
    p32._cover_part.CanTouch = false
    p32._cover_part.CanQuery = false
    p32._cover_part.Color = Color3.fromRGB(0, 0, 0)
    p32._cover_part.Material = Enum.Material.Neon
    local v33 = Instance.new("SurfaceGui")
    v33.AlwaysOnTop = true
    v33.Face = Enum.NormalId.Back
    v33.Parent = p32._cover_part
    local v34 = Instance.new("Frame")
    v34.Size = UDim2.new(1, 0, 1, 0)
    v34.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    v34.Parent = v33
    p32.Frame.Waiting.FunFact.Text = v_u_6()
end
function v_u_12._Init(p_u_35)
    p_u_35.Frame:GetPropertyChangedSignal("Visible"):Connect(function()
        p_u_35.VisibilityChanged:Fire()
    end)
    p_u_35.Frame.Waiting.FunFact.Button.MouseButton1Click:Connect(function()
        p_u_35.Frame.Waiting.FunFact.Text = v_u_6()
    end)
    v_u_9:GetDataChangedSignal("MatchmadeGameOver"):Connect(function()
        p_u_35:_Update()
    end)
    v_u_9:GetDataChangedSignal("MatchmadeStatus"):Connect(function()
        p_u_35:_Update()
    end)
    v_u_9:GetDataChangedSignal("MatchmadeCountdown"):Connect(function()
        p_u_35:_Update()
        p_u_35:_Countdown()
    end)
    v_u_9:GetDataChangedSignal("MatchmadeConnectedPlayers"):Connect(function()
        p_u_35:_Update()
        p_u_35:_Countdown()
    end)
    v_u_9:GetDataChangedSignal("MatchmadeExpectedPlayers"):Connect(function()
        p_u_35:_Update()
        p_u_35:_Countdown()
    end)
    p_u_35:_Setup()
    task.defer(p_u_35._Update, p_u_35)
    task.defer(p_u_35._Countdown, p_u_35)
end
return v_u_12._new()