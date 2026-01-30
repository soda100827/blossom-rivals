local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("Players")
require(v1.Modules.CONSTANTS)
local v_u_3 = require(v_u_2.LocalPlayer.PlayerScripts.Controllers:WaitForChild("ComplianceController"))
local v_u_4 = require(v_u_2.LocalPlayer.PlayerScripts.Controllers:WaitForChild("ControlsController"))
local v_u_5 = require(v_u_2.LocalPlayer.PlayerScripts.Controllers:WaitForChild("SpectateController"))
local v_u_6 = require(v_u_2.LocalPlayer.PlayerScripts.Controllers:WaitForChild("ArcadeController"))
local v_u_7 = require(v_u_2.LocalPlayer.PlayerScripts.Controllers:WaitForChild("CameraController"))
local v_u_8 = require(v_u_2.LocalPlayer.PlayerScripts.Modules:WaitForChild("UserInterface"):WaitForChild("EliminatedEffect"))
local v_u_9 = require(v_u_2.LocalPlayer.PlayerScripts.Modules:WaitForChild("UserInterface"):WaitForChild("Pages"))
local v_u_10 = require(v_u_2.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect"))
local v_u_11 = require(v_u_2.LocalPlayer.PlayerScripts.Modules:WaitForChild("UILibrary"))
local v_u_12 = {}
v_u_12.__index = v_u_12
function v_u_12._new()
    local v13 = v_u_12
    local v14 = setmetatable({}, v13)
    v14.Frame = v_u_11:GetTo("MainFrame", "BottomStack", "Spectate")
    v14.Container = v14.Frame:WaitForChild("Container")
    v14.Background = v14.Container:WaitForChild("Background")
    v14.NextButton = v14.Container:WaitForChild("Next")
    v14.LastButton = v14.Container:WaitForChild("Last")
    v14.ExitButton = v14.Container:WaitForChild("Exit")
    v14.JoinButton = v14.Container:WaitForChild("Join")
    v14.JoinButtonOff = v14.JoinButton:WaitForChild("Off")
    v14.JoinButtonOffTitle = v14.JoinButtonOff:WaitForChild("Title")
    v14.JoinButtonOn = v14.JoinButton:WaitForChild("On")
    v14.JoinBubble = v14.JoinButtonOn:WaitForChild("Bubble")
    v14.PlayerText = v14.Container:WaitForChild("Player")
    v14.UsernameText = v14.Container:WaitForChild("Username")
    v14.FreecamButton = v14.Container:WaitForChild("Freecam")
    v14.ExitFreecamButton = v14.Container:WaitForChild("ExitFreecam")
    v14._connections = {}
    v14._join_bubble_connection = nil
    v14._join_bubble_hash = 0
    v14:_Init()
    return v14
end
function v_u_12._UpdateJoinCooldown(p15)
    local v16 = v_u_6:GetJoinCooldown()
    local v17 = v_u_6:CanJoin()
    p15.JoinButtonOffTitle.Text = v16 > 0 and v16 and v16 or "Join"
    p15.JoinButtonOff.Visible = not v17
    p15.JoinButtonOn.Visible = v17
end
function v_u_12._Update(p_u_18)
    p_u_18._join_bubble_hash = p_u_18._join_bubble_hash + 1
    local v19 = not v_u_9.PageSystem.CurrentPage
    local v20 = v_u_7:GetPublicState() == v_u_7.CameraState.States.CustomFreecam
    local v21 = p_u_18.JoinButton
    local v22 = v19 and not v20 and (v_u_5.CurrentDuelSubject and not v_u_5.CurrentDuelSubject.LocalDueler)
    if v22 then
        v22 = v_u_5.CurrentDuelSubject:Get("IsCurrentArcadeDuel")
    end
    v21.Visible = v22
    local v23 = p_u_18.Background
    local v24
    if v19 then
        v24 = not v20
    else
        v24 = v19
    end
    v23.Visible = v24
    local v25 = p_u_18.LastButton
    local v26
    if v19 then
        v26 = not v20
    else
        v26 = v19
    end
    v25.Visible = v26
    local v27 = p_u_18.NextButton
    local v28
    if v19 then
        v28 = not v20
    else
        v28 = v19
    end
    v27.Visible = v28
    local v29 = p_u_18.PlayerText
    local v30
    if v19 then
        v30 = not v20
    else
        v30 = v19
    end
    v29.Visible = v30
    local v31 = p_u_18.UsernameText
    local v32
    if v19 then
        v32 = not v20
    else
        v32 = v19
    end
    v31.Visible = v32
    p_u_18.ExitFreecamButton.Visible = false
    p_u_18.PlayerText.Text = v19 and not v_u_5.CurrentDuelSubject and "" or (not v_u_5.CurrentSubject and p_u_18.PlayerText.Text or v_u_3:GetName(v_u_5.CurrentSubject.Player))
    p_u_18.UsernameText.Text = v19 and not v_u_5.CurrentDuelSubject or not v_u_5.CurrentSubject and p_u_18.UsernameText.Text or (v_u_5.CurrentSubject.Player.DisplayName ~= v_u_5.CurrentSubject.Player.Name and "@" .. v_u_5.CurrentSubject.Player.Name or "")
    p_u_18.PlayerText.Position = v19 and p_u_18.UsernameText.Text == "" and UDim2.new(0.5, 0, 0.5, 0) or UDim2.new(0.5, 0, 0.35, 0)
    local v33 = p_u_18.FreecamButton
    local v34 = v19 and (v_u_5.CurrentDuelSubject and not v_u_5.CurrentDuelSubject.LocalDueler)
    if v34 then
        if v_u_4.CurrentControls == "MouseKeyboard" then
            v34 = not v20
        else
            v34 = false
        end
    end
    v33.Visible = v34
    local v35 = p_u_18.ExitButton
    local v36 = v19 and (v_u_5.CurrentDuelSubject and not v_u_5.CurrentDuelSubject.LocalDueler)
    if v36 then
        v36 = not p_u_18.ExitFreecamButton.Visible
    end
    v35.Visible = v36
    p_u_18.Frame.Size = p_u_18.ExitButton.Visible and UDim2.new(0.04, 20, 0.08, 40) or UDim2.new(0.04, 20, 0.04, 20)
    local v37 = p_u_18.Frame
    local v38 = not v_u_8:IsVisible() and v_u_5.CurrentDuelSubject and not (v_u_5.CurrentSubject and v_u_5.CurrentSubject.IsLocalPlayer or v_u_5.CurrentDuelSubject:Get("VoteOptions"))
    if v38 then
        if v_u_5.CurrentDuelSubject:Get("Status") == "GameOver" then
            v38 = false
        else
            v38 = not v_u_5.CurrentDuelSubject.DuelInterface.Buttons:IsAnythingVisible()
        end
    end
    v37.Visible = v38
    if p_u_18.JoinButton.Visible and p_u_18.JoinBubble.Visible then
        task.spawn(function()
            local v39 = p_u_18._join_bubble_hash
            while true do
                if p_u_18.JoinBubble:IsDescendantOf(v_u_2) then
                    p_u_18.JoinBubble:TweenPosition(UDim2.new(0.5, 0, -0.6, 0), "Out", "Sine", 0.5, true)
                end
                wait(0.5)
                if v39 ~= p_u_18._join_bubble_hash then
                    return
                end
                if p_u_18.JoinBubble:IsDescendantOf(v_u_2) then
                    p_u_18.JoinBubble:TweenPosition(UDim2.new(0.5, 0, -0.25, 0), "In", "Sine", 0.5, true)
                end
                wait(0.5)
                if v39 ~= p_u_18._join_bubble_hash then
                    return
                end
            end
        end)
    end
end
function v_u_12._Listen(p_u_40)
    for _, v41 in pairs(p_u_40._connections) do
        v41:Disconnect()
    end
    p_u_40._connections = {}
    p_u_40:_Update()
    if v_u_5.CurrentDuelSubject then
        local v42 = p_u_40._connections
        local v43 = v_u_5.CurrentDuelSubject:GetDataChangedSignal("VoteOptions")
        table.insert(v42, v43:Connect(function()
            p_u_40:_Update()
        end))
        local v44 = p_u_40._connections
        local v45 = v_u_5.CurrentDuelSubject:GetDataChangedSignal("Status")
        table.insert(v44, v45:Connect(function()
            p_u_40:_Update()
        end))
        local v46 = p_u_40._connections
        local v47 = v_u_5.CurrentDuelSubject:GetDataChangedSignal("IsCurrentArcadeDuel")
        table.insert(v46, v47:Connect(function()
            p_u_40:_Update()
        end))
        local v48 = p_u_40._connections
        local v49 = v_u_5.CurrentDuelSubject.DuelInterface.Buttons.Updated
        table.insert(v48, v49:Connect(function()
            p_u_40:_Update()
        end))
        local v50 = p_u_40._connections
        local v51 = v_u_5.SubjectChanged
        table.insert(v50, v51:Connect(function()
            p_u_40:_Update()
        end))
        local v52 = p_u_40._connections
        local v53 = v_u_4.ControlsChanged
        table.insert(v52, v53:Connect(function()
            p_u_40:_Update()
        end))
        local v54 = p_u_40._connections
        local v55 = v_u_9.PageSystem.PagesActivity
        table.insert(v54, v55:Connect(function()
            p_u_40:_Update()
        end))
        local v56 = p_u_40._connections
        local v57 = v_u_6.UpdateJoinCooldown
        table.insert(v56, v57:Connect(function()
            p_u_40:_UpdateJoinCooldown()
        end))
        p_u_40:_UpdateJoinCooldown()
    end
end
function v_u_12._Init(p_u_58)
    p_u_58.NextButton.MouseButton1Click:Connect(function()
        v_u_5:Next()
    end)
    p_u_58.LastButton.MouseButton1Click:Connect(function()
        v_u_5:Last()
    end)
    p_u_58.ExitButton.MouseButton1Click:Connect(function()
        v_u_5:Exit()
    end)
    p_u_58.FreecamButton.MouseButton1Click:Connect(function()
        v_u_7.CameraState:SetCustomFreecamEnabled(true)
    end)
    p_u_58.ExitFreecamButton.MouseButton1Click:Connect(function()
        v_u_7.CameraState:SetCustomFreecamEnabled(false)
    end)
    p_u_58.JoinButton.MouseButton1Click:Connect(function()
        v_u_6:Join()
        p_u_58.JoinBubble.Visible = false
        p_u_58:_Update()
    end)
    v_u_7.CustomFreecamStateChanged:Connect(function()
        p_u_58:_Update()
    end)
    v_u_8.VisibilityChanged:Connect(function()
        p_u_58:_Update()
    end)
    v_u_5.DuelSubjectChanged:Connect(function()
        p_u_58:_Listen()
    end)
    task.spawn(p_u_58._Listen, p_u_58)
    v_u_10:Add(p_u_58.NextButton)
    v_u_10:Add(p_u_58.LastButton)
    v_u_10:Add(p_u_58.ExitButton)
    v_u_10:Add(p_u_58.JoinButton)
    v_u_10:Add(p_u_58.FreecamButton)
    v_u_10:Add(p_u_58.ExitFreecamButton)
end
return v_u_12._new()