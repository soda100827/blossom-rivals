game:GetService("CollectionService")
local v_u_1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("Players")
local v_u_3 = require(v_u_1.Modules.CONSTANTS)
local v_u_4 = require(v_u_1.Modules.Signal)
local v_u_5 = require(v_u_2.LocalPlayer.PlayerScripts.Controllers.FighterController)
local v_u_6 = require(v_u_2.LocalPlayer.PlayerScripts.Controllers.DuelController)
local v_u_7 = require(v_u_2.LocalPlayer.PlayerScripts.Modules.ReplicatedController)
local v_u_8 = setmetatable({}, v_u_7)
v_u_8.__index = v_u_8
function v_u_8._new()
    local v9 = v_u_7.new("QueuePad")
    local v10 = v_u_8
    local v11 = setmetatable(v9, v10)
    v11.LocalPlayerActivity = v_u_4.new()
    v11.ChallengeRequestCooldownChanged = v_u_4.new()
    v11._local_fighter = nil
    v11._update_loop_active = false
    v11._challenge_cooldowns = {}
    v11._actively_on_queue_pad = false
    v11:_Init()
    return v11
end
function v_u_8.IsChallengeRequestOnCooldown(p12, p13)
    return tick() < (p12._challenge_cooldowns[p13] or 0)
end
function v_u_8.GetQueuePad(p14, p15)
    for _, v16 in pairs(p14.Objects) do
        local v17 = v16:IsInQueue(p15)
        if v17 then
            return v16, v17
        end
    end
end
function v_u_8.CanChallenge(_, p18)
    local v19 = p18 and (p18 ~= v_u_2.LocalPlayer and v_u_3.QUEUES_ACTIVE)
    if v19 then
        v19 = not v_u_6:GetDuel(p18)
    end
    return v19
end
function v_u_8.SendChallengeRequest(p20, p21)
    if p20:CanChallenge(p21) and not p20:IsChallengeRequestOnCooldown(p21) then
        p20._challenge_cooldowns[p21] = tick() + 15
        p20.ChallengeRequestCooldownChanged:Fire()
        task.delay(15, p20.ChallengeRequestCooldownChanged.Fire, p20.ChallengeRequestCooldownChanged)
        v_u_1.Remotes.Misc.SendChallengeRequest:FireServer(p21)
    end
end
function v_u_8._CheckQueueStatus(p22)
    local v23 = p22._local_fighter:IsAlive()
    if v23 then
        v23 = p22._local_fighter.Player
    end
    local v24, v25 = p22:GetQueuePad(v_u_2.LocalPlayer)
    if v24 then
        if not v23 or (p22._local_fighter:Get("IsInDuel") or (p22._local_fighter:Get("IsInShootingRange") or not v24:IsWithin(v23, v25))) then
            v_u_1.Remotes.Misc.QueueLeave:InvokeServer()
            p22._actively_on_queue_pad = false
            return
        end
    elseif v23 then
        for _, v26 in pairs(p22.Objects) do
            local v27 = v26:IsWithin(v23)
            if v27 then
                p22._actively_on_queue_pad = true
                v_u_1.Remotes.Misc.QueueJoin:InvokeServer(v26:Get("ObjectID"), v27)
            end
        end
    end
end
function v_u_8._UpdateLoop(p28)
    if not p28._update_loop_active then
        p28._update_loop_active = true
        while true do
            wait(0.1)
            if not p28._actively_on_queue_pad and (p28._local_fighter:Get("IsInDuel") or p28._local_fighter:Get("IsInShootingRange")) then
                break
            end
            if v_u_3.IS_STUDIO then
                p28:_CheckQueueStatus()
            else
                local v29, v30 = pcall(p28._CheckQueueStatus, p28)
                if not v29 then
                    warn("Failed to check queue status, error:", v30)
                end
            end
        end
        p28._update_loop_active = false
    end
end
function v_u_8._HookLocalFighter(p_u_31)
    p_u_31._local_fighter = v_u_5:WaitForLocalFighter()
    p_u_31._local_fighter:GetDataChangedSignal("IsInDuel"):Connect(function()
        p_u_31:_UpdateLoop()
    end)
    p_u_31._local_fighter:GetDataChangedSignal("IsInShootingRange"):Connect(function()
        p_u_31:_UpdateLoop()
    end)
    p_u_31:_UpdateLoop()
end
function v_u_8._Init(p_u_32)
    p_u_32.ObjectAdded:Connect(function(p33)
        p33.LocalPlayerActivity:Connect(function()
            p_u_32.LocalPlayerActivity:Fire()
        end)
    end)
    task.defer(p_u_32._HookLocalFighter, p_u_32)
end
return v_u_8._new()