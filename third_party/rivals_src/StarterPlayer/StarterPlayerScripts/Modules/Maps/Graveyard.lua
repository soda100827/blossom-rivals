local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.ServerOsTime)
local v_u_4 = require(v2.LocalPlayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientDuel.ClientMap)
local v_u_5 = v2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("FilmGrain")
local v_u_6 = setmetatable({}, v_u_4)
v_u_6.__index = v_u_6
function v_u_6.new(...)
    local v7 = v_u_4.new(...)
    local v8 = v_u_6
    local v9 = setmetatable(v7, v8)
    v9._film_grain = v_u_5:Clone()
    v9._film_grain_loop_active = false
    v9._last_hour = v9:_GetBellRingHour()
    v9._arcade_status = nil
    v9:_Init()
    return v9
end
function v_u_6.Destroy(p10)
    p10._film_grain:Destroy()
    v_u_4.Destroy(p10)
end
function v_u_6._GetBellRingHour(_)
    local v11 = v_u_3:Get() / 60 / 60
    return math.floor(v11)
end
function v_u_6._UpdateFilmGrainLoop(p12)
    if not (p12._film_grain_loop_active or p12:Get("IsHidden")) then
        p12._film_grain_loop_active = true
        while not (p12._destroyed or p12:Get("IsHidden")) do
            p12._film_grain.Position = UDim2.new(math.random(), 0, math.random(), 0)
            local v13 = p12:_GetBellRingHour()
            if p12._last_hour ~= v13 then
                p12._last_hour = v13
                p12:CreateSound("rbxassetid://125988297033633", 1, 1, script, true, 15)
            end
            wait(0.06666666666666667)
        end
        p12._film_grain_loop_active = false
    end
end
function v_u_6._UpdateLightingProfile(p14)
    local v15
    if p14.ClientDuel:Get("ArcadeMode") then
        v15 = p14._arcade_status
    else
        v15 = p14.ClientDuel:Get("LastRoundStartingStatus")
    end
    p14:SetReplicate("LightingProfileOverride", v15 == "SuddenDeath" and "Graveyard - SuddenDeath" or (v15 == "MatchPoint" and "Graveyard - MatchPoint" or "Graveyard"))
    if v15 == "SuddenDeath" and p14.ClientDuel:Get("IsSpectating") then
        p14:CreateSound("rbxassetid://115990126225378", 1, 1, script, true, 15)
    end
    if v15 == "MatchPoint" then
        local v16 = p14._film_grain
        local v17
        if v15 == "MatchPoint" then
            v17 = p14.ClientDuel.DuelInterface.Frame or nil
        else
            v17 = nil
        end
        v16.Parent = v17
    end
end
function v_u_6._UpdateLightingProfileFromTimer(p18)
    local v19 = p18.ClientDuel.DuelInterface.Timer:GetTimeRemaining()
    local v20
    if v19 then
        v20 = p18.ClientDuel:Get("Status") == "RoundStarted" and true or p18.ClientDuel:Get("Status") == "RoundFinished"
    else
        v20 = v19
    end
    local v21
    if v20 then
        v21 = v19 < 10 and "SuddenDeath" or (v19 < 30 and "MatchPoint" or nil)
    else
        v21 = nil
    end
    if v21 ~= p18._arcade_status then
        p18._arcade_status = v21
        p18:_UpdateLightingProfile()
    end
end
function v_u_6._Setup(p_u_22)
    if p_u_22.ClientDuel:Get("ArcadeMode") then
        p_u_22.ClientDuel.DuelInterface.Timer.TimerChanged:Connect(function()
            p_u_22:_UpdateLightingProfileFromTimer()
        end)
        p_u_22:_UpdateLightingProfileFromTimer()
    else
        p_u_22.ClientDuel:GetDataChangedSignal("LastRoundStartingStatus"):Connect(function()
            p_u_22:_UpdateLightingProfile()
        end)
        p_u_22:_UpdateLightingProfile()
    end
end
function v_u_6._Init(p_u_23)
    p_u_23.ClientDuel:GetDataChangedSignal("IsHidden"):Connect(function()
        p_u_23:_UpdateFilmGrainLoop()
    end)
    p_u_23:_Setup()
    task.defer(p_u_23._UpdateFilmGrainLoop, p_u_23)
end
return v_u_6