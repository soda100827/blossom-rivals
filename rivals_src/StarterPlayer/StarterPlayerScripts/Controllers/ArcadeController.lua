local v_u_1 = game:GetService("CollectionService")
local v_u_2 = game:GetService("ReplicatedStorage")
local v3 = game:GetService("Players")
local v_u_4 = require(v_u_2.Modules.CONSTANTS)
local v_u_5 = require(v_u_2.Modules.RotatingQueueLibrary)
local v_u_6 = require(v_u_2.Modules.DuelLibrary)
local v_u_7 = require(v_u_2.Modules.Utility)
local v_u_8 = require(v_u_2.Modules.Signal)
local v_u_9 = require(v3.LocalPlayer.PlayerScripts.Controllers.SpectateController)
local v_u_10 = require(v3.LocalPlayer.PlayerScripts.Controllers.FighterController)
local v_u_11 = require(v3.LocalPlayer.PlayerScripts.Controllers.DuelController)
local v_u_12 = require(v3.LocalPlayer.PlayerScripts.Modules.Functions.SendChat)
local v_u_13 = v3.LocalPlayer.PlayerScripts.Assets.RotatingQueueHolograms
local v_u_14 = {}
v_u_14.__index = v_u_14
function v_u_14._new()
    local v15 = v_u_14
    local v16 = setmetatable({}, v15)
    v16.DuelSet = v_u_8.new()
    v16.UpdateJoinCooldown = v_u_8.new()
    v16.CurrentDuel = nil
    v16._local_fighter = nil
    v16._has_joined_arcade_duel = false
    v16._hologram_loop_thread = nil
    v16._rotating_queue_hologram = nil
    v16._join_cooldown_hash = 0
    v16:_Init()
    return v16
end
function v_u_14.GetJoinCooldown(p17)
    local v18 = p17._local_fighter and p17._local_fighter:GetJoinCooldown() or 0
    return math.ceil(v18)
end
function v_u_14.CanJoin(p19)
    local v20 = p19.CurrentDuel
    if v20 then
        if p19.CurrentDuel:Get("Status") == "GameOver" then
            v20 = false
        else
            v20 = p19:GetJoinCooldown() <= 0
        end
    end
    return v20
end
function v_u_14.ToArcadeServer(_, p21)
    return v_u_2.Remotes.Arcade.TeleportToArcadeServer:InvokeServer(p21)
end
function v_u_14.Join(p22)
    p22._has_joined_arcade_duel = true
    v_u_2.Remotes.Arcade.Join:FireServer()
end
function v_u_14._UpdateHologram(p23, p24)
    if p23._rotating_queue_hologram then
        p23._rotating_queue_hologram:Destroy()
        p23._rotating_queue_hologram = nil
    end
    local v_u_25 = v_u_1:GetTagged("LobbyRotatingQueueHologram")[1]
    if v_u_25 then
        task.defer(function()
            local v26 = v_u_25:WaitForChild("DELETE_AT_RUNTIME", 2)
            if v26 then
                task.defer(v26.Destroy, v26)
            end
        end)
        local v27 = v_u_25:WaitForChild("Primary")
        local v28 = v_u_25:WaitForChild("Particles")
        local v29 = v28:WaitForChild("Emit")
        local v_u_30 = v28:WaitForChild("Attachment")
        v_u_25:WaitForChild("Prompt"):WaitForChild("ProximityPrompt").ObjectText = "Limited Time"
        p23._rotating_queue_hologram = (v_u_13:FindFirstChild(v_u_5:GetCurrent().Name) or v_u_13.Default):Clone()
        p23._rotating_queue_hologram:PivotTo(v27.CFrame)
        p23._rotating_queue_hologram.Name = "_hologram"
        p23._rotating_queue_hologram.Parent = v_u_25
        if p24 then
            v_u_12({
                ["Text"] = "[SERVER] New gamemodes are here! Open the PLAY page now! \240\159\142\137",
                ["Color"] = Color3.fromRGB(100, 255, 50)
            })
            v_u_7:PlayParticles(v29)
            v_u_7:CreateSound("rbxassetid://120776960987657", 0.75, 1, v28, true, 15)
            v_u_7:CreateSound("rbxassetid://75616400922980", 1, 1, v28, true, 15)
            for _, v31 in pairs(v_u_30:GetChildren()) do
                v31.Enabled = true
            end
            task.delay(10, function()
                for _, v32 in pairs(v_u_30:GetChildren()) do
                    v32.Enabled = false
                end
            end)
        end
    end
end
function v_u_14._UpdateHologramLoop(p_u_33)
    local v34 = p_u_33._local_fighter and not p_u_33._local_fighter:Get("IsInDuel")
    if v34 then
        v34 = not p_u_33._local_fighter:Get("IsInShootingRange")
    end
    if v34 then
        if not p_u_33._hologram_loop_thread then
            p_u_33._hologram_loop_thread = task.spawn(function()
                p_u_33:_UpdateHologram()
                while true do
                    wait(v_u_5:GetTimeUntilNext() + 1)
                    p_u_33:_UpdateHologram(true)
                end
            end)
        end
    elseif p_u_33._hologram_loop_thread then
        task.cancel(p_u_33._hologram_loop_thread)
        p_u_33._hologram_loop_thread = nil
        return
    end
end
function v_u_14._UpdateJoinCooldown(p35)
    p35._join_cooldown_hash = p35._join_cooldown_hash + 1
    local v36 = p35._join_cooldown_hash
    local v37 = p35._local_fighter:GetJoinCooldown()
    local v38 = tick() + v37
    p35.UpdateJoinCooldown:Fire()
    for _ = 1, v37 do
        wait(1)
        p35.UpdateJoinCooldown:Fire()
        if p35._join_cooldown_hash ~= v36 then
            return
        end
    end
    wait(v38 - tick())
    if p35._join_cooldown_hash == v36 then
        p35.UpdateJoinCooldown:Fire()
    end
end
function v_u_14._HookLocalFighter(p_u_39)
    p_u_39._local_fighter = v_u_10:WaitForLocalFighter()
    p_u_39._local_fighter:GetDataChangedSignal("IsInDuel"):Connect(function()
        p_u_39:_UpdateHologramLoop()
    end)
    p_u_39._local_fighter:GetDataChangedSignal("IsInShootingRange"):Connect(function()
        p_u_39:_UpdateHologramLoop()
    end)
    p_u_39._local_fighter:GetDataChangedSignal("JoinCooldown"):Connect(function()
        p_u_39:_UpdateJoinCooldown()
    end)
    task.defer(p_u_39._UpdateHologramLoop, p_u_39)
    task.defer(p_u_39._UpdateJoinCooldown, p_u_39)
end
function v_u_14._DuelRemoved(p40, p41)
    if p40.CurrentDuel == p41 then
        p40.CurrentDuel = nil
        p40.DuelSet:Fire(p41)
    end
end
function v_u_14._DuelAdded(p_u_42, p_u_43)
    p_u_43:GetDataChangedSignal("IsCurrentArcadeDuel"):Connect(function()
        if p_u_43:Get("IsCurrentArcadeDuel") then
            p_u_42.CurrentDuel = p_u_43
            p_u_42.DuelSet:Fire(p_u_43)
        end
    end)
    if p_u_43:Get("IsCurrentArcadeDuel") then
        p_u_42.CurrentDuel = p_u_43
        p_u_42.DuelSet:Fire(p_u_43)
    end
end
function v_u_14._PromptAdded(_, p44)
    if v_u_4.IS_ARCADE_SERVER then
        p44:RemoveTag("LobbyOpenPagePrompt")
        p44.Triggered:Connect(function()
            v_u_2.Remotes.Matchmaking.BackToHub:FireServer()
        end)
        local v45 = v_u_6.ArcadeModeByPlaceID
        local v46 = v_u_4.PLACE_ID
        p44.ObjectText = v45[tostring(v46)].DisplayName
        p44.ActionText = "Leave"
    end
end
function v_u_14._Init(p_u_47)
    p_u_47.DuelSet:Connect(function(p48)
        p48:GetDataChangedSignal("Status"):Connect(function()
            p_u_47.UpdateJoinCooldown:Fire()
        end)
        p_u_47.UpdateJoinCooldown:Fire()
        if v_u_10.LocalFighter and not (v_u_10.LocalFighter:Get("IsInDuel") or v_u_10.LocalFighter:Get("IsInShootingRange")) then
            if v_u_4.IS_ARCADE_SERVER and (not p_u_47._has_joined_arcade_duel and #p48.Duelers >= 3) then
                v_u_9:SpectateDuelRequest(p48)
            else
                p_u_47:Join()
            end
        else
            return
        end
    end)
    v_u_11.ObjectAdded:Connect(function(p49)
        p_u_47:_DuelAdded(p49)
    end)
    v_u_11.ObjectRemoved:Connect(function(p50)
        p_u_47:_DuelRemoved(p50)
    end)
    v_u_1:GetInstanceAddedSignal("LobbyRotatingQueueHologram"):Connect(function(p51)
        p_u_47:_UpdateHologram(p51)
    end)
    v_u_1:GetInstanceAddedSignal("LobbyArcadePrompt"):Connect(function(p52)
        p_u_47:_PromptAdded(p52)
    end)
    for _, v53 in pairs(v_u_1:GetTagged("LobbyArcadePrompt")) do
        task.defer(p_u_47._PromptAdded, p_u_47, v53)
    end
    for _, v54 in pairs(v_u_11.Objects) do
        task.defer(p_u_47._DuelAdded, p_u_47, v54)
    end
    task.defer(p_u_47._HookLocalFighter, p_u_47)
end
return v_u_14._new()