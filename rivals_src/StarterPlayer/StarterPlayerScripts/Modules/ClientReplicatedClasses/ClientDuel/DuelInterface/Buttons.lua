local v_u_1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
require(v_u_1.Modules.CONSTANTS)
local v_u_3 = require(v_u_1.Modules.DuelLibrary)
local v_u_4 = require(v_u_1.Modules.ItemLibrary)
local v_u_5 = require(v_u_1.Modules.GameplayUtility)
local v_u_6 = require(v_u_1.Modules.Utility)
local v_u_7 = require(v_u_1.Modules.Signal)
local v_u_8 = require(v2.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
local v_u_9 = require(v2.LocalPlayer.PlayerScripts.Modules.ButtonEffect)
local v_u_10 = require(v2.LocalPlayer.PlayerScripts.Modules.UserInterface.Pages)
local v_u_11 = {}
v_u_11.__index = v_u_11
function v_u_11.new(p12)
    local v13 = v_u_11
    local v14 = setmetatable({}, v13)
    v14.Updated = v_u_7.new()
    v14.DuelInterface = p12
    v14.Frame = v14.DuelInterface.Frame:WaitForChild("Buttons")
    v14.Container = v14.Frame:WaitForChild("Container")
    v14.ContentsFrame = v14.Container:WaitForChild("Contents")
    v14.SwitchItemsFrame = v14.ContentsFrame:WaitForChild("SwitchItems")
    v14.SwitchItemsButton = v14.SwitchItemsFrame:WaitForChild("Button")
    v14.SwitchItemsTitle = v14.SwitchItemsButton:WaitForChild("Title")
    v14.SwitchItemsRemaining = v14.SwitchItemsButton:WaitForChild("Remaining")
    v14.SwitchItemsBackgroundOn = v14.SwitchItemsButton:WaitForChild("BackgroundOn")
    v14.SwitchItemsBackgroundOff = v14.SwitchItemsButton:WaitForChild("BackgroundOff")
    v14.SwitchItemsLastPickedFrame = v14.SwitchItemsButton:WaitForChild("LastPickedWeapons")
    v14.LeaveDuelFrame = v14.ContentsFrame:WaitForChild("LeaveDuel")
    v14.LeaveDuelButton = v14.LeaveDuelFrame:WaitForChild("Button")
    v14.RespawnNowFrame = v14.ContentsFrame:WaitForChild("RespawnNow")
    v14.RespawnNowButton = v14.RespawnNowFrame:WaitForChild("Button")
    v14.RespawnNowVisualsFrame = v14.RespawnNowButton:WaitForChild("Visuals")
    v14.RespawnNowBar = v14.RespawnNowVisualsFrame:WaitForChild("Bar"):WaitForChild("Bar")
    v14.RespawnInputsFrame = v14.RespawnNowVisualsFrame:WaitForChild("Inputs")
    v14.RespawnVisualsTitle = v14.RespawnNowVisualsFrame:WaitForChild("Title")
    v14.RespawnNowWaitingFrame = v14.RespawnNowButton:WaitForChild("Waiting")
    v14.RespawnNowWaitingDotsFrame = v14.RespawnNowWaitingFrame:WaitForChild("Dots")
    v14.SwitchTeamFrame = v14.ContentsFrame:WaitForChild("SwitchTeam")
    v14.SwitchTeamButton = v14.SwitchTeamFrame:WaitForChild("Button")
    v14.SwitchTeamText = v14.SwitchTeamButton:WaitForChild("Team")
    v14.SwitchTeamBackground = v14.SwitchTeamButton:WaitForChild("Background")
    v14._destroyed = false
    v14._respawn_now_animation_hash = 0
    v14._respawn_now_visible_until = 0
    v14._respawn_now_is_timer_only = false
    v14._last_picked_weapon_images = {}
    v14:_Init()
    return v14
end
function v_u_11.IsLeaveDuelVisible(p15)
    return p15.LeaveDuelFrame.Visible
end
function v_u_11.IsSwitchItemsVisible(p16)
    return p16.SwitchItemsFrame.Visible
end
function v_u_11.IsRespawnNowVisible(p17)
    return p17.RespawnNowFrame.Visible
end
function v_u_11.IsSwitchTeamVisible(p18)
    return p18.SwitchTeamFrame.Visible
end
function v_u_11.IsAnythingVisible(p19)
    return p19:IsLeaveDuelVisible() or p19:IsSwitchItemsVisible() or (p19:IsRespawnNowVisible() or p19:IsSwitchTeamVisible())
end
function v_u_11.SwitchItemsRequest(p20)
    if p20.DuelInterface.ClientDuel.LocalDueler and p20.DuelInterface.ClientDuel.LocalDueler:GetStaggeredSpawnsTurn() then
        v_u_10:OpenPickWeaponsPage()
    else
        v_u_1.Remotes.Duels.SwitchItems:FireServer()
    end
end
function v_u_11.RespawnNowRequest(p21)
    if not p21._respawn_now_is_timer_only then
        p21.RespawnNowWaitingFrame.Visible = true
        p21.RespawnNowVisualsFrame.Visible = false
        v_u_1.Remotes.Duels.RespawnNow:FireServer()
    end
end
function v_u_11.RespawnNowAnimation(p_u_22, p23)
    local v24 = p_u_22.DuelInterface.ClientDuel:Get("RespawnDelay") or 0
    p_u_22._respawn_now_visible_until = tick() + v24
    p_u_22._respawn_now_is_timer_only = p23
    p_u_22._respawn_now_animation_hash = p_u_22._respawn_now_animation_hash + 1
    local v_u_25 = p_u_22._respawn_now_animation_hash
    p_u_22.RespawnInputsFrame.Visible = not p_u_22._respawn_now_is_timer_only
    p_u_22.RespawnVisualsTitle.Text = p_u_22._respawn_now_is_timer_only and "Respawning" or "Respawn"
    p_u_22.RespawnVisualsTitle.Size = p_u_22._respawn_now_is_timer_only and UDim2.new(0.9, 0, 0.5, 0) or UDim2.new(0.9, 0, 0.575, 0)
    p_u_22.RespawnNowWaitingFrame.Visible = false
    p_u_22.RespawnNowVisualsFrame.Visible = true
    p_u_22.RespawnNowBar.Size = UDim2.new(0, 0, 1, 0)
    p_u_22.RespawnNowBar:TweenSize(UDim2.new(1, 0, 1, 0), "Out", "Linear", v24, true, function()
        wait(1)
        if v_u_25 == p_u_22._respawn_now_animation_hash then
            p_u_22.RespawnNowBar.Size = UDim2.new(0, 0, 1, 0)
        end
    end)
    p_u_22:Update()
end
function v_u_11.Update(p26)
    for _, v27 in pairs(p26._last_picked_weapon_images) do
        v27:Destroy()
    end
    p26._last_picked_weapon_images = {}
    local v28 = p26.LeaveDuelFrame.Visible
    local v29 = p26.SwitchItemsFrame.Visible
    local v30 = p26.SwitchItemsBackgroundOn.Visible
    local v31 = p26.SwitchItemsBackgroundOff.Visible
    local v32 = p26.RespawnNowFrame.Visible
    local v33 = p26.SwitchTeamFrame.Visible
    local v34 = p26.DuelInterface.ClientDuel.LocalDueler and not p26.DuelInterface:IsPageOpen()
    if v34 then
        v34 = not p26.DuelInterface.Voting:IsOpen()
    end
    local v35 = p26.DuelInterface.ClientDuel.LocalDueler and p26.DuelInterface.ClientDuel.LocalDueler.ClientFighter
    if v35 then
        v35 = p26.DuelInterface.ClientDuel.LocalDueler.ClientFighter:IsAlive()
    end
    local v36 = (v35 and true or false) and (not p26.DuelInterface.ClientDuel:Get("WasSelfQueued") and p26.DuelInterface.ClientDuel:Get("IsCurrentArcadeDuel"))
    if v36 then
        v36 = p26.DuelInterface.Scoreboard:IsOpen()
    end
    local v37 = v34 and (v36 and p26.DuelInterface.ClientDuel:CanLeave())
    if v37 then
        if p26.DuelInterface.ClientDuel:Get("Status") == "GameOver" then
            v37 = false
        else
            v37 = p26.DuelInterface.Scoreboard:IsOpen()
        end
    end
    p26.LeaveDuelFrame.Visible = v37
    local v38 = v34 and not v35
    if v38 then
        v38 = tick() < p26._respawn_now_visible_until
    end
    p26.RespawnNowFrame.Visible = v38
    local v39 = not v34 and 0 or (p26.DuelInterface.ClientDuel.LocalDueler:Get("SwitchItemsMax") or (1 / 0)) - p26.DuelInterface.ClientDuel.LocalDueler:Get("SwitchItemsCount")
    local v40 = p26.DuelInterface.ClientDuel:Get("CanSwitchItems") == "WhileInvincible" and v35 and p26.DuelInterface.ClientDuel.LocalDueler.ClientFighter.Entity:Get("IsInvincible") or p26.DuelInterface.ClientDuel:Get("CanSwitchItems") == true
    local v41 = v34 and p26.DuelInterface.ClientDuel.LocalDueler
    if v41 then
        v41 = p26.DuelInterface.ClientDuel.LocalDueler:GetStaggeredSpawnsTurn()
    end
    local v42 = v34 and ((v35 and v40 or v41) and not p26.DuelInterface.ClientDuel.LocalDueler.ClientFighter:Get("CanPickWeapons"))
    if v42 then
        if p26.DuelInterface.ClientDuel:Get("ArcadeMode") or (p26.DuelInterface.ClientDuel:Get("RoundNum") > 1 or v41) then
            if p26.DuelInterface.ClientDuel:Get("Status") == "GameOver" then
                v42 = false
            else
                v42 = v_u_5:SwitchingWeaponsMakesSense(p26.DuelInterface.ClientDuel.LocalDueler.ClientFighter, v_u_8)
            end
        else
            v42 = v41
        end
    end
    local v43 = v39 < (1 / 0) and true or v41
    p26.SwitchItemsFrame.Visible = v42
    p26.SwitchItemsTitle.Position = v43 and UDim2.new(0.5, 0, 0.375, 0) or UDim2.new(0.5, 0, 0.5, 0)
    p26.SwitchItemsTitle.Text = v41 and "Pick Weapons" or "Switch Weapons"
    p26.SwitchItemsRemaining.Text = v41 and "before you spawn" or (not v43 and "" or string.format("%s switch%s remaining", v39, v39 == 1 and "" or "es"))
    p26.SwitchItemsBackgroundOn.Visible = v41 or v39 > 0
    p26.SwitchItemsBackgroundOff.Visible = not p26.SwitchItemsBackgroundOn.Visible
    if v41 then
        for v44, v45 in pairs(p26.DuelInterface.ClientDuel.LocalDueler.ClientFighter:Get("LastPickedWeapons") or {}) do
            local v46 = v_u_8:GetWeaponData(v45)
            local v47 = Instance.new("ImageLabel")
            v47.AnchorPoint = Vector2.new(0.5, 0.5)
            v47.Size = UDim2.new(3, 0, 3, 0)
            v47.BackgroundTransparency = 1
            v47.LayoutOrder = v44
            v47.ZIndex = v44
            v47.Image = v46 and v_u_4:GetViewModelImageFromWeaponData(v46) or (v_u_4:GetViewModelImage(v45) or "")
            v47.Parent = p26.SwitchItemsLastPickedFrame
            local v48 = p26._last_picked_weapon_images
            table.insert(v48, v47)
        end
    end
    local v49 = p26:_GetNextTeamID()
    local v50 = p26.DuelInterface.ClientDuel.LocalDueler
    if v50 then
        v50 = p26.DuelInterface.ClientDuel:CountTeam(p26.DuelInterface.ClientDuel.LocalDueler:Get("TeamID"))
    end
    local v51
    if v49 then
        v51 = p26.DuelInterface.ClientDuel:CountTeam(v49)
    else
        v51 = v49
    end
    local v52 = v34 and (v42 and (v49 and p26.DuelInterface.ClientDuel:Get("ArcadeMode"))) and (p26.DuelInterface.ClientDuel.LocalDueler and not p26.DuelInterface.ClientDuel.LocalDueler:Get("JustSwitchedTeam"))
    if v52 then
        v52 = p26.DuelInterface.Scoreboard:IsOpen()
    end
    if v52 then
        if v50 then
            if v51 then
                if v50 > 1 then
                    v51 = v51 < v50
                else
                    v51 = false
                end
            end
        else
            v51 = v50
        end
    else
        v51 = v52
    end
    p26.SwitchTeamFrame.Visible = v52
    p26.SwitchTeamText.Text = not v49 and "" or "to " .. v_u_3.TeamsByID[v49].TeamName
    p26.SwitchTeamBackground.ImageColor3 = v51 and v_u_3:GetTeamColor(v49) or v_u_3.EMPTY_TEAM_COLOR
    if (p26.LeaveDuelFrame.Visible ~= v28 or (p26.SwitchItemsFrame.Visible ~= v29 or (p26.SwitchItemsBackgroundOn.Visible ~= v30 or (p26.SwitchItemsBackgroundOff.Visible ~= v31 or p26.RespawnNowFrame.Visible ~= v32)))) and true or p26.SwitchTeamFrame.Visible ~= v33 then
        p26.Updated:Fire()
    end
end
function v_u_11.Destroy(p53)
    p53._destroyed = true
    p53.Updated:Destroy()
end
function v_u_11._GetNextTeamID(p54)
    local v55 = p54.DuelInterface.ClientDuel.LocalDueler
    if v55 then
        v55 = p54.DuelInterface.ClientDuel.LocalDueler:Get("TeamID")
    end
    local v56 = p54.DuelInterface.ClientDuel:Get("NumTeams")
    if v55 and (v56 and v56 > 1) then
        return v_u_3.Teams[v_u_3.TeamsByID[v55].TeamIndex % v56 + 1].TeamID
    end
end
function v_u_11._UpdateRespawnNowDots(p57)
    if p57.RespawnNowWaitingFrame.Visible then
        p57.RespawnNowWaitingDotsFrame:AddTag("UILoadingDots")
    else
        p57.RespawnNowWaitingDotsFrame:RemoveTag("UILoadingDots")
    end
end
function v_u_11._UpdateVisibility(p58)
    p58.Frame.Visible = not p58.DuelInterface.FinalResults:IsActive()
end
function v_u_11._UpdateParent(p_u_59)
    if not p_u_59._destroyed then
        pcall(function()
            p_u_59.ContentsFrame.Parent = p_u_59.DuelInterface.Scoreboard:IsOpen() and p_u_59.DuelInterface.Scoreboard.ButtonsContainer or p_u_59.Container
        end)
    end
end
function v_u_11._Init(p_u_60)
    p_u_60.SwitchItemsButton.MouseButton1Click:Connect(function()
        p_u_60:SwitchItemsRequest()
    end)
    p_u_60.RespawnNowButton.MouseButton1Click:Connect(function()
        p_u_60:RespawnNowRequest()
    end)
    p_u_60.LeaveDuelButton.MouseButton1Click:Connect(function()
        p_u_60.DuelInterface.ClientDuel:LeaveDuelRequest()
    end)
    p_u_60.SwitchTeamButton.MouseButton1Click:Connect(function()
        if not v_u_1.Remotes.Duels.SwitchTeam:InvokeServer(p_u_60:_GetNextTeamID()) then
            v_u_6:CreateSound("rbxassetid://17153811469", 2, 1, script, true, 5)
        end
    end)
    p_u_60.DuelInterface.FinalResults.Activated:Connect(function()
        p_u_60:_UpdateVisibility()
    end)
    p_u_60.DuelInterface.Scoreboard.VisibilityChanged:Connect(function()
        p_u_60:Update()
        p_u_60:_UpdateParent()
    end)
    p_u_60.DuelInterface.Voting.VisibilityChanged:Connect(function()
        p_u_60:Update()
    end)
    p_u_60.RespawnNowWaitingFrame:GetPropertyChangedSignal("Visible"):Connect(function()
        p_u_60:_UpdateRespawnNowDots()
    end)
    p_u_60:_UpdateVisibility()
    task.defer(p_u_60._UpdateParent, p_u_60)
    v_u_9:Add(p_u_60.LeaveDuelButton)
    v_u_9:Add(p_u_60.RespawnNowButton)
    v_u_9:Add(p_u_60.SwitchItemsButton)
    v_u_9:Add(p_u_60.SwitchTeamButton)
end
return v_u_11