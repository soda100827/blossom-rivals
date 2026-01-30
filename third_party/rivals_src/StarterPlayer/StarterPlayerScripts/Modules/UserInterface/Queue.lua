local v_u_1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("TweenService")
local v_u_3 = game:GetService("RunService")
local v_u_4 = game:GetService("Players")
local v_u_5 = require(v_u_1.Modules.CONSTANTS)
local v_u_6 = require(v_u_1.Modules.Utility)
local v_u_7 = require(v_u_1.Modules.Signal)
local v_u_8 = require(v_u_4.LocalPlayer.PlayerScripts.Controllers:WaitForChild("FighterController"))
local v_u_9 = require(v_u_4.LocalPlayer.PlayerScripts.Controllers:WaitForChild("SocialController"))
local v_u_10 = require(v_u_4.LocalPlayer.PlayerScripts.Controllers:WaitForChild("QueuePadController"))
local v_u_11 = require(v_u_4.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect"))
local v_u_12 = require(v_u_4.LocalPlayer.PlayerScripts.Modules:WaitForChild("TeammateSlot"))
local v_u_13 = require(v_u_4.LocalPlayer.PlayerScripts.Modules:WaitForChild("UILibrary"))
local v_u_14 = v_u_4.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("LocalQueuePlayerSlot")
local v_u_15 = v_u_4.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("TitleVS")
local v_u_16 = {}
v_u_16.__index = v_u_16
function v_u_16._new()
    local v17 = v_u_16
    local v18 = setmetatable({}, v17)
    v18.VisibilityChanged = v_u_7.new()
    v18.Frame = v_u_13:GetTo("MainFrame", "BottomStack", "Queue")
    v18.Container = v18.Frame:WaitForChild("Container")
    v18._cleanup = {}
    v18._countdown_hash = 0
    v18._last_countdown_sound = nil
    v18:_Init()
    return v18
end
function v_u_16.IsVisible(p19)
    return p19.Container.Visible
end
function v_u_16._UpdateInviteFrame(p20)
    local v21 = p20.Container.Invite
    local v22 = v_u_9.CanSendGameInvite
    if v22 then
        v22 = not p20.Container.Countdown.Visible
    end
    v21.Visible = v22
end
function v_u_16._UpdateWaitingBackground(p23)
    p23.Container.Waiting.Background.Size = UDim2.new(0, p23.Container.Background.AbsoluteSize.X, 0, p23.Container.Background.AbsoluteSize.Y)
end
function v_u_16._UpdateSize(p24)
    p24.Frame.Size = p24.Container.Visible and (p24.Container.Start.Visible or (p24.Container.Ready.Visible or p24.Container.Countdown.Visible)) and UDim2.new(0.1, 30, 0.1875, 56.25) or UDim2.new(0.1, 30, 0.1, 30)
end
function v_u_16._StartCountdown(p25)
    p25._countdown_hash = p25._countdown_hash + 1
    local v26 = p25._countdown_hash
    p25.Container.Countdown.Visible = true
    p25.Container.Waiting.Visible = false
    p25.Container.Start.Visible = false
    p25:_UpdateSize()
    for v27 = 3, 1, -1 do
        if v26 ~= p25._countdown_hash then
            return
        end
        p25.Container.Countdown.Value.Text = v27
        p25._last_countdown_sound = v_u_6:CreateSound("rbxassetid://17259538274", 0.5, 1, script, true, 5)
        local v28 = tick()
        while tick() < v28 + 0.375 do
            if v26 ~= p25._countdown_hash then
                return
            end
            local v29 = (tick() - v28) / 0.375
            local v30 = v_u_2:GetValue(v29, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
            local v31 = v_u_2:GetValue(v29, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
            p25.Container.Countdown.Value.Size = UDim2.new(1, 0, 1.25 - 0.625 * v30)
            p25.Container.Countdown.Glow.ImageTransparency = 0.875 - 0.25 * v31
            p25.Container.Countdown.Glow.Size = UDim2.new(v31, 0, v31, 0)
            v_u_3.RenderStepped:Wait()
        end
        local v32 = tick()
        while tick() < v32 + 0.625 do
            if v26 ~= p25._countdown_hash then
                return
            end
            local v33 = (tick() - v32) / 0.625
            local v34 = v_u_2:GetValue(v33, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
            local v35 = v_u_2:GetValue(v33, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
            p25.Container.Countdown.Value.Size = UDim2.new(1, 0, 0.625 - 0.625 * v34)
            p25.Container.Countdown.Glow.ImageTransparency = 0.625 + 0.25 * v35
            v_u_3.RenderStepped:Wait()
        end
    end
end
function v_u_16._StopCountdown(p36)
    p36._countdown_hash = p36._countdown_hash + 1
    p36.Container.Countdown.Visible = false
    p36:_UpdateSize()
    if p36._last_countdown_sound then
        p36._last_countdown_sound:Destroy()
        p36._last_countdown_sound = nil
    end
end
function v_u_16._Update(p37)
    for _, v38 in pairs(p37._cleanup) do
        v38:Destroy()
    end
    p37._cleanup = {}
    local v39 = v_u_10:GetQueuePad(v_u_4.LocalPlayer)
    p37.Container.Visible = v39 or false
    p37.VisibilityChanged:Fire()
    p37:_UpdateSize()
    if not p37.Container.Visible then
        p37.Frame.UIScale.Scale = 1
        p37:_StopCountdown()
        return
    end
    local v40 = v39:GetClientFightersWaiting()
    local v41 = 0
    local v42 = 0
    local v43 = 0
    local v44 = 0
    local v45 = 0
    local v46 = 0
    local v47 = 0
    for v48 = 1, v39:Get("NumTeams") do
        local v49 = v40[v48]
        local v50 = #v49
        v41 = math.max(v41, v50)
        v47 = table.find(v49, v_u_8.LocalFighter) and (#v49 or v47) or v47
        local v51 = false
        local v52 = false
        for v53 = 1, v39:Get("InfinitePlayersPerTeam") and (1 / 0) or v39:Get("PlayersPerTeam") do
            local v54 = v49[v53]
            if not v54 and v39:Get("InfinitePlayersPerTeam") then
                if v51 then
                    break
                end
                v51 = true
            end
            local v55 = v_u_14:Clone()
            local v56
            if v39:Get("NumTeams") == 2 and v48 == 1 then
                v56 = -v45 or v45
            else
                v56 = v45
            end
            v55.LayoutOrder = v56
            local v57 = v55.Container.Ready
            local v58
            if v54 then
                v58 = v39:IsReady(v54.Player)
            else
                v58 = v54
            end
            v57.Visible = v58
            v55.Parent = p37.Container.Details
            local v59 = p37._cleanup
            table.insert(v59, v55)
            v42 = v42 + 1
            v45 = v45 + 1
            if v54 then
                v55.Container.Dots:Destroy()
                local v60 = v_u_12.new(v54.Player.UserId, v54:Get("Controls"), 1, false, true, v54.Player:GetAttribute("StatisticDuelsWinStreak"), v54.Player:GetAttribute("Level"))
                v60.SlotFrame.Container.Background.Visible = false
                v60.SlotFrame.Parent = v55.Container
                local v61 = p37._cleanup
                table.insert(v61, v60)
                v46 = v46 + 1
                v52 = true
            else
                v55.Container.Dots:AddTag("UILoadingDots")
            end
        end
        if v48 ~= v39:Get("NumTeams") then
            local v62 = v_u_15:Clone()
            v62.LayoutOrder = v45
            v62.Parent = p37.Container.Details
            local v63 = p37._cleanup
            table.insert(v63, v62)
            v43 = v43 + 1
            v45 = v45 + 1
        end
        if v52 then
            v44 = v44 + 1
        end
    end
    local v64 = p37.Frame.UIScale
    local v65 = 1.3 - v42 * 0.05
    v64.Scale = math.clamp(v65, 0.5, 1)
    p37.Container.Background.Size = UDim2.new(v43 * 0.7 + 0.125 + v42 * 0.875, 0, 1, 0)
    local v66 = p37.Container.Ready
    local v67 = not v39:Get("InfinitePlayersPerTeam")
    if v67 then
        if v44 == v39:Get("NumTeams") and v47 < v41 then
            v67 = not v39:IsReady(v_u_8.LocalFighter.Player)
        else
            v67 = false
        end
    end
    v66.Visible = v67
    local v68 = p37.Container.Start
    local v69 = v39:Get("InfinitePlayersPerTeam")
    if v69 then
        if v44 > 1 then
            v69 = v_u_5.IS_PRIVATE_SERVER_OWNER(v_u_4.LocalPlayer.UserId)
        else
            v69 = false
        end
    end
    v68.Visible = v69
    local v70 = p37.Container.Waiting
    local v71 = v39:Get("InfinitePlayersPerTeam")
    if v71 then
        if v44 > 1 then
            v71 = not v_u_5.IS_PRIVATE_SERVER_OWNER(v_u_4.LocalPlayer.UserId)
        else
            v71 = false
        end
    end
    v70.Visible = v71
    p37:_UpdateSize()
    if v39:Get("IsStarting") then
        p37:_StartCountdown()
    else
        p37:_StopCountdown()
    end
end
function v_u_16._WaitForLocalFighter(p72)
    v_u_8:WaitForLocalFighter()
    p72:_Update()
end
function v_u_16._Init(p_u_73)
    p_u_73.Container.Background:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        p_u_73:_UpdateWaitingBackground()
    end)
    p_u_73.Container.Countdown:GetPropertyChangedSignal("Visible"):Connect(function()
        p_u_73:_UpdateInviteFrame()
    end)
    p_u_73.Container.Start.MouseButton1Click:Connect(function()
        v_u_1.Remotes.PrivateServer.StartQueuePad:FireServer()
    end)
    p_u_73.Container.Ready.MouseButton1Click:Connect(function()
        v_u_1.Remotes.Misc.QueueReady:FireServer()
    end)
    p_u_73.Container.Invite.Button.MouseButton1Click:Connect(function()
        v_u_9:PromptFriendInvite()
    end)
    v_u_10.LocalPlayerActivity:Connect(function()
        p_u_73:_Update()
    end)
    p_u_73:_Update()
    p_u_73:_UpdateInviteFrame()
    p_u_73:_UpdateWaitingBackground()
    task.spawn(p_u_73._WaitForLocalFighter, p_u_73)
    v_u_11:Add(p_u_73.Container.Start)
    v_u_11:Add(p_u_73.Container.Ready)
    v_u_11:Add(p_u_73.Container.Invite.Button, nil, {
        ["HoverRatio"] = UDim2.new(0, 10, 0, 10),
        ["ReleaseRatio"] = UDim2.new(0, 10, 0, 10)
    })
end
return v_u_16._new()