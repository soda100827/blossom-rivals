local v_u_1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("SocialService")
local v_u_3 = game:GetService("HttpService")
local v_u_4 = game:GetService("Players")
local v_u_5 = require(v_u_1.Modules.CONSTANTS)
local v_u_6 = require(v_u_4.LocalPlayer.PlayerScripts.Controllers.MatchmakingController)
local v_u_7 = require(v_u_4.LocalPlayer.PlayerScripts.Controllers.ComplianceController)
local v_u_8 = require(v_u_4.LocalPlayer.PlayerScripts.Controllers.QueuePadController)
local v_u_9 = require(v_u_4.LocalPlayer.PlayerScripts.Controllers.FighterController)
local v_u_10 = require(v_u_4.LocalPlayer.PlayerScripts.Modules.ButtonEffect)
local v_u_11 = v_u_4.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("PartyInviteSlot")
local v_u_12 = {}
v_u_12.__index = v_u_12
function v_u_12.new(p13, p14, p15, p16)
    local v17 = v_u_12
    local v18 = setmetatable({}, v17)
    v18.Frame = v_u_11:Clone()
    v18._destroyed = false
    v18._player_object = p13
    if not p14 then
        if v18._player_object then
            p14 = v18._player_object.UserId or nil
        else
            p14 = nil
        end
    end
    v18._user_id = p14
    if not p15 then
        if v18._player_object then
            p15 = v18._player_object.DisplayName or nil
        else
            p15 = nil
        end
    end
    v18._display_name = p15
    if not p16 then
        if v18._player_object then
            p16 = v18._player_object.Name or nil
        else
            p16 = nil
        end
    end
    v18._username = p16
    v18:_Init()
    return v18
end
function v_u_12.StillHere(p19)
    local v20 = p19._player_object
    if v20 then
        v20 = p19._player_object.Parent == v_u_4
    end
    return v20
end
function v_u_12.GetUserID(p21)
    return p21._user_id
end
function v_u_12.UpdateCooldowns(p22)
    p22.Frame.Buttons.Challenge.Button.Off.Visible = v_u_8:IsChallengeRequestOnCooldown(p22._player_object)
    p22.Frame.Buttons.Challenge.Button.On.Visible = not p22.Frame.Buttons.Challenge.Button.Off.Visible
    p22.Frame.Buttons.Invite.Button.Off.Visible = v_u_6:IsInviteRequestOnCooldown(p22._player_object)
    p22.Frame.Buttons.Invite.Button.On.Visible = not p22.Frame.Buttons.Invite.Button.Off.Visible
end
function v_u_12.Destroy(p23)
    p23._destroyed = true
    p23.Frame:Destroy()
end
function v_u_12._Update(p24)
    p24.Frame.DisplayName.Controls.Position = UDim2.new(0, p24.Frame.DisplayName.TextBounds.X, 0.5, 0)
end
function v_u_12._CheckFriendsWith(p25)
    if p25._destroyed then
        return
    elseif v_u_6:IsFriendsWith(p25._user_id) then
        p25.Frame.Name = "Friends"
        local v26 = p25.Frame
        v26.LayoutOrder = v26.LayoutOrder + 999999
    end
end
function v_u_12._Setup(p27)
    local v28 = v_u_9:GetFighter(p27._player_object)
    p27.Frame.Buttons.Challenge.Visible = v_u_8:CanChallenge(p27._player_object)
    p27.Frame.Buttons.Invite.Visible = v_u_6:CanInvitePlayerToParty(p27._player_object)
    p27.Frame.Buttons.InviteExternal.Visible = not p27._player_object
    p27.Frame.Icon.Image = string.format(v_u_5.HEADSHOT_IMAGE, p27._user_id)
    p27.Frame.DisplayName.Controls.Image = v28 and v_u_5.CONTROLS_IMAGES[v28:Get("Controls")] or ""
    p27.Frame.DisplayName.Text = p27._player_object and v_u_7:GetName(p27._player_object) or (p27._display_name or "")
    p27.Frame.Username.Text = p27._player_object and "@" .. p27._player_object.Name or (p27._username and ("@" .. p27._username or "") or "")
    p27.Frame.Name = "Lobby"
    p27.Frame.LayoutOrder = 0
end
function v_u_12._Init(p_u_29)
    p_u_29.Frame.DisplayName:GetPropertyChangedSignal("TextBounds"):Connect(function()
        p_u_29:_Update()
    end)
    p_u_29.Frame.Buttons.Challenge.Button.MouseButton1Click:Connect(function()
        v_u_8:SendChallengeRequest(p_u_29._player_object)
    end)
    p_u_29.Frame.Buttons.Invite.Button.MouseButton1Click:Connect(function()
        v_u_6:SendPartyInvite(p_u_29._player_object)
    end)
    p_u_29.Frame.Buttons.InviteExternal.Button.MouseButton1Click:Connect(function()
        local v30 = Instance.new("ExperienceInviteOptions")
        v30.PromptMessage = "Invite to your party!"
        v30.InviteMessageId = "466fc19d-8334-514f-80e7-cba27e22bc22"
        v30.InviteUser = p_u_29._user_id
        v30.LaunchData = v_u_3:JSONEncode({
            ["PartyInviteHash"] = v_u_1.Remotes.Matchmaking.RequestPartyInviteData:InvokeServer()
        })
        v_u_2:PromptGameInvite(v_u_4.LocalPlayer, v30)
        p_u_29.Frame.Buttons.InviteExternal.Button.On.Visible = false
        p_u_29.Frame.Buttons.InviteExternal.Button.Off.Visible = true
    end)
    p_u_29:_Setup()
    p_u_29:_Update()
    p_u_29:UpdateCooldowns()
    task.defer(p_u_29._CheckFriendsWith, p_u_29)
    v_u_10:Add(p_u_29.Frame.Buttons.Invite.Button)
    v_u_10:Add(p_u_29.Frame.Buttons.InviteExternal.Button)
    v_u_10:Add(p_u_29.Frame.Buttons.Challenge.Button)
end
return v_u_12