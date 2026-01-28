local v_u_1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("Players")
local v_u_3 = require(v_u_1.Modules.CONSTANTS)
local v_u_4 = require(v_u_1.Modules.ReplicatedClass)
require(v_u_1.Modules.Utility)
local v_u_5 = require(v_u_1.Modules.Signal)
local v_u_6 = require(v_u_2.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
local v_u_7 = require(v_u_2.LocalPlayer.PlayerScripts.Controllers.DuelController)
local v_u_8 = {
    "ServerRegion",
    "MatchmadeStatus",
    "MatchmadeExpectedPlayers",
    "MatchmadeConnectedPlayers",
    "MatchmadeGameOver",
    "MatchmadeCountdown",
    "MatchmadeRematchAvailable",
    "MatchmadeRematchCount",
    "MatchmadeRematchGoal",
    "MatchmadeRematchSuccess"
}
local v_u_9 = setmetatable({}, v_u_4)
v_u_9.__index = v_u_9
function v_u_9._new()
    local v10 = v_u_4.new()
    local v11 = v_u_9
    local v12 = setmetatable(v10, v11)
    v12.PartyChanged = v_u_5.new()
    v12.FriendsFetched = v_u_5.new()
    v12.MatchmadeDuelEnded = v_u_5.new()
    v12.RematchDetailsChanged = v_u_5.new()
    v12.InviteRequestCooldownChanged = v_u_5.new()
    v12.CurrentParty = nil
    v12.Friends = {}
    v12._is_friends_with = {}
    v12._invite_cooldowns = {}
    v12:_Init()
    return v12
end
function v_u_9.IsMatchmadeDuelOver(p13)
    local v14 = v_u_3.IS_MATCHMAKING_SERVER
    if v14 then
        v14 = p13:Get("MatchmadeGameOver")
    end
    return v14
end
function v_u_9.IsPartyLeader(p15)
    return not p15.CurrentParty or p15.CurrentParty[1] == v_u_2.LocalPlayer
end
function v_u_9.IsInParty(p16, p17)
    local v18 = p16.CurrentParty
    if v18 then
        v18 = table.find(p16.CurrentParty, p17)
    end
    return v18
end
function v_u_9.IsFriendsWith(p19, p20)
    local v21 = p19._is_friends_with[tostring(p20)]
    if v21 then
        return v21
    end
    local v22, v23 = pcall(v_u_2.LocalPlayer.IsFriendsWith, v_u_2.LocalPlayer, p20)
    if v22 then
        return v23
    end
    warn("Failed to check IsFriendsWith, error:", v23)
    return false
end
function v_u_9.IsRematchAvailable(p24)
    local v25 = not p24:Get("MatchmadeRematchSuccess") and (p24:Get("MatchmadeRematchCount") and p24:Get("MatchmadeRematchGoal"))
    if v25 then
        v25 = p24:Get("MatchmadeRematchAvailable")
    end
    return v25
end
function v_u_9.IsInviteRequestOnCooldown(p26, p27)
    return tick() < (p26._invite_cooldowns[p27] or 0)
end
function v_u_9.CanInvitePlayerToParty(p28, p29)
    local v30 = p29 and (p29 ~= v_u_2.LocalPlayer and (p28:IsPartyLeader() and not p28:IsInParty(p29)))
    if v30 then
        v30 = not v_u_7:GetDuel(p29)
    end
    return v30
end
function v_u_9.SendPartyInvite(p31, p32)
    if p31:CanInvitePlayerToParty(p32) and not p31:IsInviteRequestOnCooldown(p32) then
        p31._invite_cooldowns[p32] = tick() + 15
        p31.InviteRequestCooldownChanged:Fire()
        task.delay(15, p31.InviteRequestCooldownChanged.Fire, p31.InviteRequestCooldownChanged)
        v_u_1.Remotes.Matchmaking.SendPartyInvite:FireServer(p32)
    end
end
function v_u_9.QueueInto(_, p33)
    return v_u_1.Remotes.Matchmaking.JoinQueue:InvokeServer(p33)
end
function v_u_9.LeaveQueue(_)
    v_u_1.Remotes.Matchmaking.LeaveQueue:FireServer()
end
function v_u_9._OnboardingQueue(p34)
    if not v_u_3.IS_STUDIO and (not v_u_3.IS_PRIVATE_HUB_SERVER and v_u_6:GetStatistic("StatisticDuelsPlayed") <= 0) then
        p34:QueueInto(v_u_3.BEGINNER_QUEUE_NAME)
    end
end
function v_u_9._FetchFriends(p35)
    while true do
        local v36, v37 = pcall(v_u_2.LocalPlayer.GetFriendsOnline, v_u_2.LocalPlayer, 50)
        if v36 then
            break
        end
        warn("Failed to fetch friends, error:", v37)
        wait(1)
    end
    p35.Friends = v37
    for _, v38 in pairs(p35.Friends) do
        local v39 = p35._is_friends_with
        local v40 = v38.VisitorId
        v39[tostring(v40)] = true
    end
    p35.FriendsFetched:Fire()
end
function v_u_9._FetchParty(_)
    v_u_1.Remotes.Matchmaking.RequestOneTimePartyReplication:FireServer()
end
function v_u_9._Setup(p_u_41)
    for _, v_u_42 in pairs(v_u_8) do
        local v_u_43 = string.find(v_u_42, "Rematch")
        workspace:GetAttributeChangedSignal(v_u_42):Connect(function()
            p_u_41:SetReplicate(v_u_42, workspace:GetAttribute(v_u_42))
            if v_u_43 then
                p_u_41.RematchDetailsChanged:Fire()
            end
        end)
        p_u_41:SetReplicate(v_u_42, workspace:GetAttribute(v_u_42))
    end
end
function v_u_9._Init(p_u_44)
    v_u_1.Remotes.Matchmaking.UpdateParty.OnClientEvent:Connect(function(p45)
        p_u_44.CurrentParty = p45
        p_u_44.PartyChanged:Fire()
    end)
    p_u_44:GetDataChangedSignal("MatchmadeGameOver"):Connect(function()
        p_u_44.MatchmadeDuelEnded:Fire()
    end)
    p_u_44:_Setup()
    task.defer(p_u_44._FetchParty, p_u_44)
    task.defer(p_u_44._FetchFriends, p_u_44)
    task.defer(p_u_44._OnboardingQueue, p_u_44)
end
return v_u_9._new()