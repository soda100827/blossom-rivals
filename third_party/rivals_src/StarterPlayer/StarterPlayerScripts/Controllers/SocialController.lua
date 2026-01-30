local v_u_1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("SocialService")
local v_u_3 = game:GetService("HttpService")
local v_u_4 = game:GetService("Players")
local v_u_5 = {}
v_u_5.__index = v_u_5
function v_u_5._new()
    local v6 = v_u_5
    local v7 = setmetatable({}, v6)
    v7.CanSendGameInvite = nil
    v7:_Init()
    return v7
end
function v_u_5.PromptFriendInvite(_)
    local v8 = Instance.new("ExperienceInviteOptions")
    v8.PromptMessage = "Challenge your friends to a duel!"
    v8.InviteMessageId = "1dc4ba3b-4978-ea4f-9c63-35babfc20045"
    v8.LaunchData = v_u_3:JSONEncode({
        ["SenderHash"] = v_u_1.Remotes.Misc.RequestInviteData:InvokeServer()
    })
    v_u_2:PromptGameInvite(v_u_4.LocalPlayer, v8)
end
function v_u_5._Fetch(p9)
    local v10, v11 = pcall(v_u_2.CanSendGameInviteAsync, v_u_2, v_u_4.LocalPlayer)
    if v10 then
        p9.CanSendGameInvite = v10 and v11
    else
        warn("Failed to fetch CanSendGameInviteAsync:", v11)
    end
end
function v_u_5._Init(p12)
    task.defer(p12._Fetch, p12)
end
return v_u_5._new()