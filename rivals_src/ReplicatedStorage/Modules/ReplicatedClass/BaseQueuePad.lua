local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = require(v1.Modules.CONSTANTS)
local v_u_3 = require(v1.Modules.ReplicatedClass)
local v_u_4 = require(v1.Modules.ServerOsTime)
local v_u_5 = require(v1.Modules.DuelLibrary)
local v_u_6 = require(v1.Modules.Utility)
local v_u_7 = setmetatable({}, v_u_3)
v_u_7.__index = v_u_7
function v_u_7.new(...)
    local v8 = v_u_3.new(...)
    local v9 = v_u_7
    local v10 = setmetatable(v8, v9)
    v10:_Init()
    return v10
end
function v_u_7.GetActualQueueName(p11)
    return v_u_5:GetFirstQueueNameByDuelLogic(p11:Get("QueueName")) or p11:Get("QueueName")
end
function v_u_7.GetDuelLogics(p12, p13)
    local v14 = {}
    for _, v15 in pairs(v_u_5.PlaySourceOrder) do
        local v16 = v_u_5.PlaySources[v15]
        if v16.Type == "MatchmakingQueue" then
            local v17 = v_u_5.MatchmakingQueues[v15]
            local v18 = v16.DuelLogic or (v17.TitleName or v17.DisplayName)
            if not table.find(v14, v18) and v_u_4:Get() >= v17.TerminalsReleaseTime then
                local v19
                if v17.NumTeams == p12:Get("NumTeams") then
                    v19 = true
                elseif v17.NumTeams == 1 then
                    v19 = p12:Get("NumTeams") == 2
                else
                    v19 = false
                end
                if v19 then
                    local v20 = not p13 or p13.HasVerifiedBadge
                    if not v20 then
                        if #p13.DisplayName >= 2 then
                            local v21 = p13.DisplayName
                            v20 = string.sub(v21, 1, 2) == "00"
                        else
                            v20 = false
                        end
                    end
                    if v16.DuelLogic ~= "Easy Exploits" or (not p13 or (v20 or v_u_2.IS_STUDIO)) then
                        table.insert(v14, v18)
                    end
                end
            end
        end
    end
    return v14
end
function v_u_7.GetMaxPlayersPerTeam(_)
    return 9
end
function v_u_7.CountTeam(p22, p23)
    local v24 = 0
    for _ in pairs(p22:Get("PlayersWaiting")[p23]) do
        v24 = v24 + 1
    end
    return v24
end
function v_u_7.IsReady(p25, p26)
    local v27 = p25:IsInQueue(p26)
    if v27 then
        local v28 = p25:Get("PlayersWaiting")[v27]
        local v29 = p26.UserId
        v27 = v28[tostring(v29)]
    end
    return v27
end
function v_u_7.IsInQueue(p30, p31)
    for v32, v33 in pairs(p30:Get("PlayersWaiting")) do
        local v34 = p31.UserId
        if v33[tostring(v34)] ~= nil then
            return v32
        end
    end
end
function v_u_7.IsWithin(p35, p36, p37)
    if not p37 then
        for v38 = 1, p35:Get("NumTeams") do
            if p35:IsWithin(p36, v38) then
                return v38
            end
        end
        return false
    end
    local v39 = p35:Get("Model"):WaitForChild("Important"):WaitForChild("Team" .. p37)
    local v40 = p36 and (p36.Character and p36.Character:FindFirstChild("HumanoidRootPart"))
    if v40 then
        v40 = p36.Character.HumanoidRootPart.Position
    end
    if v39 then
        if v40 then
            v40 = v_u_6:IsWithinRotatedShape(v40, v39.CFrame, v39.Size, v39.Shape)
        end
    else
        v40 = v39
    end
    return v40
end
function v_u_7._Init(_) end
return v_u_7