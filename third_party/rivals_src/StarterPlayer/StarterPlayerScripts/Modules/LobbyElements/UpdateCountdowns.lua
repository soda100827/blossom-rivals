local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("CollectionService")
local v_u_3 = game:GetService("SocialService")
local v4 = game:GetService("Players")
local v_u_5 = require(v1.Modules.ServerOsTime)
local v_u_6 = require(v1.Modules.Utility)
local v_u_7 = require(v4.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
local v_u_8 = require(v4.LocalPlayer.PlayerScripts.Modules.LobbyElement)
local v_u_9 = setmetatable({}, v_u_8)
v_u_9.__index = v_u_9
function v_u_9._new(...)
    local v10 = v_u_8.new(...)
    local v11 = v_u_9
    local v12 = setmetatable(v10, v11)
    v12._models = {}
    v12._countdown_hash = 0
    v12._next_event_details = nil
    v12:_Init()
    return v12
end
function v_u_9.Update(p13, _)
    if p13._next_event_details then
        for _, v14 in pairs(p13._models) do
            local v15 = workspace.CurrentCamera.CFrame.X
            local v16 = v14.CountdownCFrame.Y + (workspace.CurrentCamera.CFrame.Y - v14.CountdownCFrame.Y) / 2
            local v17 = workspace.CurrentCamera.CFrame.Z
            local v18 = Vector3.new(v15, v16, v17)
            v14.CountdownPart.CFrame = CFrame.new(v14.CountdownCFrame.Position, v18) * CFrame.Angles(0.2617993877991494, 0, 0)
        end
    end
end
function v_u_9._GetDateTime(_, p19)
    return DateTime.fromUniversalTime(p19.Year, p19.Month, p19.Day, p19.Hour, p19.Minute, p19.Second, p19.Millisecond)
end
function v_u_9._UpdateCountdown(p_u_20)
    for v21, v22 in pairs(p_u_20._models) do
        v22.CountdownModel.Parent = nil
        v22.LogoModel.Parent = v21
    end
    p_u_20._next_event = nil
    p_u_20._countdown_hash = p_u_20._countdown_hash + 1
    local v23 = p_u_20._countdown_hash
    if v_u_7:GetStatistic("StatisticDuelsPlayed") < 10 then
        return
    end
    local v24, v25 = pcall(v_u_3.GetUpcomingExperienceEventsAsync, v_u_3)
    if not v24 then
        warn("Failed to fetch upcoming events, error:", v25)
        return
    end
    if p_u_20._countdown_hash ~= v23 then
        return
    end
    table.sort(v25, function(p26, p27)
        local v28 = p_u_20:_GetDateTime(p26.StartTime)
        local v29 = p_u_20:_GetDateTime(p27.StartTime)
        return v28.UnixTimestamp < v29.UnixTimestamp
    end)
    local v30 = nil
    for _, v31 in pairs(v25) do
        if not v31.HasStarted and (not v31.HasEnded and v31.Status == Enum.ExperienceEventStatus.Active) then
            v30 = v31
            break
        end
    end
    if v30 then
        local v32, v33 = pcall(v_u_3.GetExperienceEventAsync, v_u_3, v30.Id)
        if v32 then
            if p_u_20._countdown_hash == v23 then
                p_u_20._next_event_details = v33
                for v34, v35 in pairs(p_u_20._models) do
                    v35.CountdownModel.Parent = v34
                    v35.LogoModel.Parent = nil
                    v35.CountdownTitle.Text = string.upper(p_u_20._next_event_details.Title)
                end
                local v36 = p_u_20:_GetDateTime(p_u_20._next_event_details.StartTime)
                while true do
                    local v37 = v36.UnixTimestamp - v_u_5:Get()
                    local v38 = math.ceil(v37)
                    for _, v39 in pairs(p_u_20._models) do
                        v39.CountdownText.Text = v38 <= 0 and "ANY SECOND NOW" or v_u_6:TimeFormat2(v38)
                    end
                    wait(1)
                    if p_u_20._countdown_hash ~= v23 then
                        return
                    end
                end
            else
                return
            end
        else
            warn("Failed to fetch event details, error:", v25)
            return
        end
    else
        return
    end
end
function v_u_9._ModelAdded(p_u_40, p41)
    p41:WaitForChild("Countdown"):PivotTo(p41:WaitForChild("Countdown"):GetPivot() + Vector3.new(0, 100, 0))
    local v42 = {
        ["CountdownModel"] = p41:WaitForChild("Countdown"),
        ["CountdownPart"] = p41:WaitForChild("Countdown"):WaitForChild("Part"),
        ["CountdownCFrame"] = p41:WaitForChild("Countdown"):WaitForChild("Part").CFrame,
        ["CountdownTitle"] = p41:WaitForChild("Countdown"):WaitForChild("Part"):WaitForChild("SurfaceGui"):WaitForChild("Title"),
        ["CountdownText"] = p41:WaitForChild("Countdown"):WaitForChild("Part"):WaitForChild("SurfaceGui"):WaitForChild("Countdown"),
        ["LogoModel"] = p41:WaitForChild("Logo")
    }
    p_u_40._models[p41] = v42
    p41:WaitForChild("Countdown"):WaitForChild("Prompt"):WaitForChild("ProximityPrompt").Triggered:Connect(function()
        if p_u_40._next_event_details then
            local v43, v44 = pcall(v_u_3.PromptRsvpToEventAsync, v_u_3, p_u_40._next_event_details.Id)
            if not v43 then
                warn("Failed to prompt event RSVP, error:", v44)
            end
        end
    end)
    p_u_40:_UpdateCountdown()
end
function v_u_9._Init(p_u_45)
    v_u_7:GetDataChangedSignal("StatisticDuelsPlayed"):Connect(function()
        p_u_45:_UpdateCountdown()
    end)
    v_u_2:GetInstanceAddedSignal("LobbyUpdateCountdown"):Connect(function(p46)
        p_u_45:_ModelAdded(p46)
    end)
    for _, v47 in pairs(v_u_2:GetTagged("LobbyUpdateCountdown")) do
        task.defer(p_u_45._ModelAdded, p_u_45, v47)
    end
end
return v_u_9._new()