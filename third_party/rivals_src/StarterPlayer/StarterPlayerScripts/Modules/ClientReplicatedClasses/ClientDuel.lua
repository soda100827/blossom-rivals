local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.CONSTANTS)
local v_u_4 = require(v1.Modules.ReplicatedClass)
local v_u_5 = require(v1.Modules.SeasonLibrary)
local v_u_6 = require(v1.Modules.Signal)
local v_u_7 = require(v_u_2.LocalPlayer.PlayerScripts.Controllers.SpectateController)
local v_u_8 = require(v_u_2.LocalPlayer.PlayerScripts.Controllers.FighterController)
local v_u_9 = require(v_u_2.LocalPlayer.PlayerScripts.Modules.UserInterface.Pages)
local v_u_10 = require(script:WaitForChild("DuelInterface"))
local v_u_11 = require(script:WaitForChild("ChickenGame"))
local v_u_12 = require(script:WaitForChild("ClientMap"))
local v_u_13 = v_u_2.LocalPlayer.PlayerScripts.Modules.Maps
local v_u_14 = setmetatable({}, v_u_4)
v_u_14.__index = v_u_14
function v_u_14.new(p15)
    local v16 = v_u_4.new(p15)
    local v17 = v_u_14
    local v18 = setmetatable(v16, v17)
    v18.DuelerAdded = v_u_6.new()
    v18.DuelerRemoved = v_u_6.new()
    v18.MapAdded = v_u_6.new()
    v18.Duelers = {}
    v18.Map = nil
    v18.DuelInterface = v_u_10.new(v18)
    v18.LocalDueler = nil
    v18.IsRanked = v_u_5:IsRankedQueue(v18:Get("QueueName"))
    v18.ChickenGame = v_u_11.new(v18)
    v18.Data.IsSpectating = false
    v18.Data.LastRoundStartingStatus = nil
    v18.Data.DuelMusic = nil
    v18._temp_serial = p15
    v18._connections = {}
    v18._client_fighters = {}
    v18._duelers_by_player = {}
    v18:_Init()
    return v18
end
function v_u_14.IsRendered(p19)
    return v_u_3.SHOULD_ALWAYS_REPLICATE() or p19.LocalDueler or p19 == v_u_7.CurrentDuelSubject
end
function v_u_14.CanLeave(p20)
    if v_u_9.PageSystem.CurrentPage then
        return false
    else
        return p20:Get("IsCurrentArcadeDuel") or p20:Get("RoundNum") > 1 and p20:Get("Status") == "RoundFinished" and not p20:Get("CanTrackStatistics") or p20:Get("WasSelfQueued")
    end
end
function v_u_14.GetDueler(p21, p22)
    if p21._duelers_by_player[p22] then
        return p21._duelers_by_player[p22]
    end
    for v23, v24 in pairs(p21.Duelers) do
        if v24.Player == p22 or v24:Get("ObjectID") == p22 then
            return v24, v23
        end
    end
end
function v_u_14.GetFighters(p25)
    return table.clone(p25._client_fighters)
end
function v_u_14.CountTeam(p26, p27)
    local v28 = 0
    for _, v29 in pairs(p26.Duelers) do
        v28 = v28 + (v29:Get("TeamID") == p27 and 1 or 0)
    end
    return v28
end
function v_u_14.LeaveDuelRequest(p30)
    if p30:CanLeave() then
        v_u_9.PageSystem:OpenPage("LeaveDuel", true)
    end
end
function v_u_14.ReplicateFromServer(p31, p32, ...)
    if p32 == "DuelerAdded" then
        p31:_DuelerAdded(...)
        return
    elseif p32 == "DuelerRemoved" then
        p31:_DuelerRemoved(...)
        return
    elseif p32 == "DuelerChanged" then
        p31:_DuelerChanged(...)
        return
    elseif p32 == "MapAdded" then
        p31:_MapAdded(...)
    elseif p32 == "MapChanged" then
        local v33 = ...
        local v34 = p31:FromEnum(v33) or v33
        if p31.Map then
            p31.Map:ReplicateFromServer(v34, select(2, ...))
            return
        end
    else
        if p32 == "RoundStarting" then
            if p31:IsRendered() then
                local v35, v36 = ...
                local v37 = p31:FromEnum(v36)
                p31:SetReplicate("LastRoundStartingStatus", v37)
                if v37 == "MatchPoint" then
                    p31.DuelInterface.MatchPoint:Play(false)
                elseif v37 == "SuddenDeath" then
                    p31.DuelInterface.MatchPoint:Play(true)
                end
                p31.DuelInterface.Timer:Set(v35)
            end
        end
        if p32 == "RoundStart" then
            if p31:IsRendered() then
                p31.DuelInterface.Timer:Set(...)
            end
        end
        if p32 == "RoundFinish" then
            if p31:IsRendered() then
                local v38, v39 = ...
                p31.DuelInterface.Timer:Pause(v39)
                p31.DuelInterface.RoundResult:Play(v38)
            end
        end
        if p32 == "FinalResults" then
            if p31:IsRendered() then
                p31.DuelInterface.FinalResults:Play(...)
            end
        end
        if p32 == "Countdown" then
            if p31:IsRendered() then
                p31.DuelInterface.Timer:Set(...)
            end
        end
        if p32 == "ChosenMapEffect" then
            if p31:IsRendered() then
                p31.DuelInterface.Voting:PlayMapChosenEffect(...)
            end
        end
        if p32 == "PauseTimer" then
            if p31:IsRendered() then
                p31.DuelInterface.Timer:Pause(...)
            end
        end
        if p32 == "RespawnNowAnimation" then
            if p31:IsRendered() then
                local v40, v41 = ...
                if p31.LocalDueler and v40 == p31.LocalDueler.Player then
                    p31.DuelInterface.Buttons:RespawnNowAnimation(v41)
                end
            else
                return
            end
        end
        if p32 == "ChickenGamesRedLight" then
            if p31:IsRendered() then
                p31.ChickenGame:RedLight(...)
            end
        end
        if p32 == "ChickenGamesGreenLight" then
            if p31:IsRendered() then
                p31.ChickenGame:GreenLight(...)
            end
        end
        if p32 == "ChickenGamesElimination" then
            if p31:IsRendered() then
                p31.ChickenGame:Elimination(...)
            end
        end
        if p32 == "ChickenGamesStop" then
            if p31:IsRendered() then
                p31.ChickenGame:Stop(...)
            end
        end
        if p32 == "TimerStopwatchStarted" then
            if p31:IsRendered() then
                p31.DuelInterface.Timer:StopwatchStart(...)
            end
        end
        if p32 == "TimerStopwatchFinished" then
            if p31:IsRendered() then
                p31.DuelInterface.Timer:StopwatchFinish(...)
            end
        end
        v_u_4.ReplicateFromServer(p31, p32, ...)
    end
end
function v_u_14.Destroy(p42)
    for _, v43 in pairs(p42._connections) do
        v43:Disconnect()
    end
    for _, v44 in pairs(p42.Duelers) do
        v44:Destroy()
    end
    p42._client_fighters = {}
    p42._duelers_by_player = {}
    if p42.Map then
        p42.Map:Destroy()
    end
    p42.DuelInterface:Destroy()
    p42.ChickenGame:Destroy()
    p42.DuelerAdded:Destroy()
    p42.DuelerRemoved:Destroy()
    p42.MapAdded:Destroy()
    v_u_4.Destroy(p42)
end
function v_u_14._UpdateHidden(p45)
    local v46 = not p45:Get("IsSpectating")
    if p45.Map then
        p45.Map:SetHidden(v46)
    end
end
function v_u_14._UpdateAllies(p47)
    local v48 = p47:GetDueler(v_u_2.LocalPlayer)
    local v49
    if v48 then
        v49 = v48:Get("TeamID")
    else
        v49 = v48
    end
    for _, v50 in pairs(p47.Duelers) do
        local v51
        if v49 then
            if v50 == v48 then
                v51 = false
            else
                v51 = v49 == v50:Get("TeamID")
            end
        else
            v51 = v49
        end
        v50:SetAlly(v51)
    end
end
function v_u_14._DuelerChanged(p52, p53, p54, ...)
    local v55 = p52:GetDueler(p53)
    if v55 then
        v55:ReplicateFromServer(p52:FromEnum(p54) or p54, ...)
    end
end
function v_u_14._DuelerAdded(p56, p57)
    if not p56:GetDueler(p57[p56:ToEnum("Data")][p56:ToEnum("ObjectID")]) then
        local v58 = p57[p56:ToEnum("ClientReplicatedClassType")]
        local v59 = v_u_8:WaitForFighter(p57[p56:ToEnum("Player")])
        local v60 = v_u_4:GetReplicatedClass(p56:FromEnum(v58) or v58).new(p57, v59, p56)
        local v61 = p56.Duelers
        table.insert(v61, v60)
        local v62 = p56._client_fighters
        table.insert(v62, v59)
        p56._duelers_by_player[v60.Player] = v60
        local v63
        if v59.IsLocalPlayer then
            v63 = v60
        else
            v63 = p56.LocalDueler
        end
        p56.LocalDueler = v63
        p56.DuelerAdded:Fire(v60)
    end
end
function v_u_14._DuelerRemoved(p64, p65)
    local v66, v67 = p64:GetDueler(p65)
    if v67 then
        if v66 == p64.LocalDueler then
            p64.LocalDueler = nil
        end
        local v68 = v66.ClientFighter and table.find(p64._client_fighters, v66.ClientFighter)
        if v68 then
            table.remove(p64._client_fighters, v68)
        end
        table.remove(p64.Duelers, v67)
        p64._duelers_by_player[v66.Player] = nil
        p64.DuelerRemoved:Fire(v66)
        v66:Destroy()
    end
end
function v_u_14._MapAdded(p69, p70)
    local v71 = p70[p69:ToEnum("Name")]
    p69.Map = (v_u_13:FindFirstChild(v71) and require(v_u_13[v71]) or v_u_12).new(p70, p69)
    p69.MapAdded:Fire(p69.Map)
end
function v_u_14._Setup(p72)
    for _, v73 in pairs(p72._temp_serial.Duelers) do
        task.spawn(p72._DuelerAdded, p72, v73)
    end
    if p72._temp_serial.Map then
        task.spawn(p72._MapAdded, p72, p72._temp_serial.Map)
    end
    p72._temp_serial = nil
end
function v_u_14._Init(p_u_74)
    p_u_74.DuelerAdded:Connect(function()
        p_u_74:_UpdateAllies()
    end)
    p_u_74.MapAdded:Connect(function()
        p_u_74:_UpdateHidden()
    end)
    p_u_74:GetDataChangedSignal("IsSpectating"):Connect(function()
        p_u_74:_UpdateHidden()
    end)
    p_u_74:_Setup()
    p_u_74:_UpdateAllies()
    p_u_74:_UpdateHidden()
end
return v_u_14