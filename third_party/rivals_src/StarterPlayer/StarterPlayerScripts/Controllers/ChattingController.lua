game:GetService("ReplicatedStorage")
local v_u_1 = game:GetService("TextChatService")
local v_u_2 = game:GetService("StarterGui")
local v_u_3 = game:GetService("Players")
local v_u_4 = require(v_u_3.LocalPlayer.PlayerScripts.Controllers.SpectateController)
local v_u_5 = require(v_u_3.LocalPlayer.PlayerScripts.Controllers.DuelController)
local v_u_6 = {
    {
        ["Result"] = "GG \226\157\164\239\184\143",
        ["Words"] = { "ggez" },
        ["Messages"] = {}
    },
    {
        ["Result"] = "you played well",
        ["Words"] = {
            "ur bad",
            "ur so bad",
            "you are so bad",
            "you are bad",
            "horrible"
        },
        ["Messages"] = {}
    },
    {
        ["Result"] = "W update \226\157\164\239\184\143",
        ["Words"] = { "l update" },
        ["Messages"] = {}
    },
    {
        ["Result"] = "well played \240\159\145\141",
        ["Words"] = { "gg ez" },
        ["Messages"] = { "ez" }
    },
    {
        ["Result"] = "nice loadout",
        ["Words"] = { "p2w", "pay to win", "pay 2 win" },
        ["Messages"] = {}
    }
}
local v_u_7 = {}
v_u_7.__index = v_u_7
function v_u_7._new()
    local v8 = v_u_7
    local v9 = setmetatable({}, v8)
    v9._muted_user_ids = {}
    v9:_Init()
    return v9
end
function v_u_7._UpdateChatBubblesEnabled(_)
    v_u_1:WaitForChild("BubbleChatConfiguration").Enabled = not (v_u_4.CurrentDuelSubject and v_u_4.CurrentDuelSubject.IsRanked)
end
function v_u_7._DuelInterfaceBubble(p10, p11, p12)
    if p11 and not table.find(p10._muted_user_ids, p11.UserId) then
        local v13 = {}
        for _, v14 in pairs(v_u_5.Objects) do
            if v14:GetDueler(p11) then
                table.insert(v13, v14)
            end
        end
        if #v13 ~= 0 then
            for _, v15 in pairs(v13) do
                v15.DuelInterface.Scores:NewChatMessage(p11, p12)
            end
        end
    else
        return
    end
end
function v_u_7._OnIncomingMessage(_, p16)
    if not p16.TextSource then
        return
    end
    local v17 = p16.Text
    local v18 = false
    for _, v19 in pairs(v_u_6) do
        if table.find(v19.Messages, string.lower(v17)) then
            v17 = v19.Result
            v18 = true
            break
        end
    end
    if v18 then
        ::l9::
        if v17 ~= p16.Text then
            local v20 = Instance.new("TextChatMessageProperties")
            v20.Text = v17
            return v20
        end
        return
    else
        while true do
            local v21 = false
            for _, v22 in pairs(v_u_6) do
                for _, v23 in pairs(v22.Words) do
                    local v24 = string.find(string.lower(v17), v23)
                    if v24 then
                        local v25 = v24 - 1
                        local v26 = string.sub(v17, 1, v25)
                        local v27 = v22.Result
                        local v28 = v24 + #v23
                        v17 = v26 .. v27 .. string.sub(v17, v28)
                        v21 = true
                    end
                end
            end
            if not v21 then
                goto l9
            end
        end
    end
end
function v_u_7._Init(p_u_29)
    function v_u_1.OnIncomingMessage(p30)
        local v31 = p_u_29:_OnIncomingMessage(p30)
        if p30.Status == Enum.TextChatMessageStatus.Success then
            local v32 = p30.TextSource and p30.TextSource.UserId
            if v32 then
                v32 = v_u_3:GetPlayerByUserId(p30.TextSource.UserId)
            end
            local v33 = v31 and v31.Translation ~= "" and v31.Translation
            if not v33 then
                if p30.Translation == "" then
                    v33 = nil
                else
                    v33 = p30.Translation or nil
                end
            end
            local v34 = v31 and v31.Text or p30.Text
            task.defer(p_u_29._DuelInterfaceBubble, p_u_29, v32, v33 or v34)
        end
        return v31
    end
    v_u_4.DuelSubjectChanged:Connect(function()
        p_u_29:_UpdateChatBubblesEnabled()
    end)
    task.spawn(function()
        v_u_2:GetCore("PlayerMutedEvent").Event:Connect(function(p35)
            if not table.find(p_u_29._muted_user_ids, p35.UserId) then
                local v36 = p_u_29._muted_user_ids
                local v37 = p35.UserId
                table.insert(v36, v37)
            end
        end)
        v_u_2:GetCore("PlayerUnmutedEvent").Event:Connect(function(p38)
            if table.find(p_u_29._muted_user_ids, p38.UserId) then
                table.remove(p_u_29._muted_user_ids, p38.UserId)
            end
        end)
    end)
    task.defer(p_u_29._UpdateChatBubblesEnabled, p_u_29)
end
return v_u_7._new()