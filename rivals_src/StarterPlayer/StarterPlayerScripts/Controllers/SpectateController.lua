local v_u_1 = game:GetService("ReplicatedStorage")
game:GetService("StarterGui")
local v_u_2 = game:GetService("RunService")
local v_u_3 = game:GetService("Players")
local v_u_4 = require(v_u_1.Modules.CONSTANTS)
local v_u_5 = require(v_u_1.Modules.InputLibrary)
local v_u_6 = require(v_u_1.Modules.Signal)
local v_u_7 = require(v_u_3.LocalPlayer.PlayerScripts.Controllers.ControlsController)
local v_u_8 = require(v_u_3.LocalPlayer.PlayerScripts.Controllers.FighterController)
local v_u_9 = require(v_u_3.LocalPlayer.PlayerScripts.Controllers.CameraController)
local v_u_10 = require(v_u_3.LocalPlayer.PlayerScripts.Controllers.DuelController)
local v_u_11 = require(v_u_3.LocalPlayer.PlayerScripts.Modules.UserInterface.Teleporting)
local v_u_12 = {}
v_u_12.__index = v_u_12
function v_u_12._new()
    local v13 = v_u_12
    local v14 = setmetatable({}, v13)
    v14.SubjectChanged = v_u_6.new()
    v14.SubjectEmoteStatusChanged = v_u_6.new()
    v14.DuelSubjectChanged = v_u_6.new()
    v14.DuelSubjectEnvironmentIDChanged = v_u_6.new()
    v14.DuelSubjectStatusChanged = v_u_6.new()
    v14.Subjects = {}
    v14.CurrentSubject = nil
    v14.CurrentDuelSubject = nil
    v14._duel_connections = {}
    v14._subject_connections = {}
    v14._last_spectating_user_id = nil
    v14._spectate_duel_request_queue = {}
    v14._spectate_duel_request_queue_active = false
    v14:_Init()
    return v14
end
function v_u_12.IsRendered(p15, p16)
    local v17 = not v_u_4.IS_ARCADE_SERVER and (v_u_3.LocalPlayer:GetAttribute("EnvironmentID") ~= p16 and p15.CurrentDuelSubject)
    if v17 then
        v17 = p15.CurrentDuelSubject:Get("EnvironmentID") == p16
    end
    return v17
end
function v_u_12.IsSubjectEmoting(p18)
    local v19 = p18.CurrentSubject and p18.CurrentSubject.Entity
    if v19 then
        v19 = p18.CurrentSubject.Entity:IsEmoting()
    end
    return v19
end
function v_u_12.Increment(p20, p21)
    if p20.CurrentDuelSubject and not (p20.CurrentSubject and p20.CurrentSubject.IsLocalPlayer) then
        local v22 = p20.CurrentSubject and (table.find(p20.Subjects, p20.CurrentSubject) or 0) or 0
        local v23
        if v22 or p21 ~= 1 then
            if v22 or p21 ~= -1 then
                if p21 == 1 and v22 == #p20.Subjects then
                    v23 = 1
                elseif p21 == -1 and v22 == 1 then
                    v23 = #p20.Subjects
                else
                    v23 = v22 + p21
                end
            else
                v23 = #p20.Subjects
            end
        else
            v23 = 1
        end
        p20:_RawSetCurrentSubject(p20.Subjects[v23])
        p20:_VerifySubject(p21 == -1)
    end
end
function v_u_12.Next(p24)
    p24:Increment(1)
end
function v_u_12.Last(p25)
    p25:Increment(-1)
end
function v_u_12.Exit(p26)
    if p26.CurrentDuelSubject and not p26.CurrentDuelSubject.LocalDueler then
        p26:SpectateDuelRequest(nil)
    end
end
function v_u_12.SpectateDuelRequest(p_u_27, p28)
    local v29 = v_u_10:GetDuel(v_u_3.LocalPlayer) or p28
    local v30 = p_u_27._spectate_duel_request_queue
    table.insert(v30, { v29 })
    task.spawn(function()
        if not p_u_27._spectate_duel_request_queue_active then
            p_u_27._spectate_duel_request_queue_active = true
            while #p_u_27._spectate_duel_request_queue > 0 do
                local v31 = table.remove(p_u_27._spectate_duel_request_queue, 1)
                local v32 = p_u_27.CurrentDuelSubject and p_u_27.CurrentDuelSubject:Get("ObjectID") or nil
                local v33 = v31[1] and v31[1]:Get("ObjectID") or nil
                if v33 ~= v32 then
                    v_u_1.Remotes.Replication.Fighter.SpectateDuel:FireServer(v33)
                    wait(1)
                end
            end
            p_u_27._spectate_duel_request_queue = {}
            p_u_27._spectate_duel_request_queue_active = false
        end
    end)
end
function v_u_12.Update(p34, p35)
    local v36 = p34.CurrentDuelSubject and p34.CurrentDuelSubject:GetFighters() or v_u_8:GetFightersNotInDuel()
    if v_u_8.LocalFighter and not table.find(v36, v_u_8.LocalFighter) then
        local v37 = v_u_8.LocalFighter
        table.insert(v36, v37)
    end
    local v38 = {}
    for _, v39 in pairs(v36) do
        if not v38[v39.Player] then
            v38[v39.Player] = true
            if v_u_4.IS_TESTING_SERVER then
                v39:Update(p35)
            else
                local v40, v41 = pcall(v39.Update, v39, p35)
                if not v40 then
                    warn("ClientFighter::Update errored:", v41)
                end
            end
        end
    end
end
function v_u_12._IsValidSubject(p42, p43)
    if v_u_9:GetPublicState() == v_u_9.CameraState.States.CustomFreecam then
        return false
    end
    if not (p43 and p43:IsAlive()) then
        return false
    end
    if p42.CurrentDuelSubject and not table.find(p42.CurrentDuelSubject:GetFighters(), p43) then
        return false
    end
    if not (p42.CurrentDuelSubject and p42.CurrentDuelSubject.LocalDueler) then
        return true
    end
    if p42.CurrentDuelSubject and (p42.CurrentDuelSubject.LocalDueler and p42.CurrentDuelSubject.LocalDueler:IsAlive()) then
        return p43 == p42.CurrentDuelSubject.LocalDueler.ClientFighter
    end
    local v44 = p42.CurrentDuelSubject.LocalDueler:Get("TeamID")
    if not v44 then
        return true
    end
    if p42.CurrentDuelSubject:Get("IsCurrentArcadeDuel") then
        return true
    end
    local v45 = false
    for _, v46 in pairs(p42.CurrentDuelSubject.Duelers) do
        if v46:Get("TeamID") == v44 and v46:IsAlive() then
            v45 = true
            break
        end
    end
    return (not p42.CurrentDuelSubject:Get("StaggeredSpawns") or p42.CurrentDuelSubject:Get("Status") == "RoundFinished") and not v45 and true or p43:Get("TeamID") == v44
end
function v_u_12._RawSetCurrentSubject(p47, p48)
    if p48 ~= p47.CurrentSubject then
        for _, v49 in pairs(p47._subject_connections) do
            v49:Disconnect()
        end
        p47._subject_connections = {}
        if p47.CurrentSubject then
            p47.CurrentSubject:SetReplicate("IsSpectating", false)
        end
        p47.CurrentSubject = p48
        p47.SubjectChanged:FireDeferred()
        if p47.CurrentSubject then
            p47.CurrentSubject:SetReplicate("IsSpectating", true)
        end
    end
end
function v_u_12._VerifySubject(p_u_50, p51)
    local v52 = p_u_50.CurrentSubject and (table.find(p_u_50.Subjects, p_u_50.CurrentSubject) or 1) or 1
    local v53 = p51 and -1 or 1
    local v54 = nil
    for v55 = 1, #p_u_50.Subjects do
        local v56 = (v52 + (v55 - 1) * v53 - 1) % #p_u_50.Subjects + 1
        local v57 = p_u_50.Subjects[v56]
        if p_u_50:_IsValidSubject(v57) then
            v54 = v57
            break
        end
    end
    if v54 == p_u_50.CurrentSubject then
        return
    else
        p_u_50:_RawSetCurrentSubject(v54)
        if p_u_50.CurrentSubject then
            local function v58()
                p_u_50:_VerifySubject()
            end
            local v59 = p_u_50._subject_connections
            local v60 = p_u_50.CurrentSubject.EntityRemoved
            table.insert(v59, v60:Connect(v58))
            local v61 = p_u_50._subject_connections
            local v62 = p_u_50.CurrentSubject.EntityAdded
            table.insert(v61, v62:Connect(v58))
            local v63 = p_u_50._subject_connections
            local v64 = p_u_50.CurrentSubject.Died
            table.insert(v63, v64:Connect(v58))
            local v65 = p_u_50._subject_connections
            local v66 = p_u_50.CurrentSubject.EntityAdded
            table.insert(v65, v66:Connect(function(p67)
                local v68 = p_u_50._subject_connections
                local v69 = p67.EmoteStatusChanged
                local function v70()
                    p_u_50.SubjectEmoteStatusChanged:Fire()
                end
                table.insert(v68, v69:Connect(v70))
            end))
            if p_u_50.CurrentSubject.Entity then
                local v71 = p_u_50.CurrentSubject.Entity
                local v72 = p_u_50._subject_connections
                local v73 = v71.EmoteStatusChanged
                table.insert(v72, v73:Connect(function()
                    p_u_50.SubjectEmoteStatusChanged:Fire()
                end))
            end
        end
    end
end
function v_u_12._CleanupCurrentDuelSubject(p74, p75)
    for _, v76 in pairs(p74._duel_connections) do
        v76:Disconnect()
    end
    p74._duel_connections = {}
    for v77 = #p74.Subjects, 1, -1 do
        p74:_RemoveSubject(p74.Subjects[v77], true)
    end
    p74:_VerifySubject()
    if p74.CurrentDuelSubject and p74.CurrentDuelSubject ~= p75 then
        p74.CurrentDuelSubject:SetReplicate("IsSpectating", false)
        for _, v78 in pairs(p74.CurrentDuelSubject.Duelers) do
            if v78.ClientFighter then
                v78.ClientFighter:ClearInterface()
                v78.ClientFighter:ClearSounds(true)
            end
        end
    end
end
function v_u_12._SpectateDuel(p_u_79, p80)
    local v81 = v_u_10:GetDuel(v_u_3.LocalPlayer)
    if v81 and p80 ~= v81 then
        return
    else
        p_u_79:_CleanupCurrentDuelSubject(p80)
        p_u_79.CurrentDuelSubject = p80
        p_u_79.DuelSubjectChanged:Fire()
        if p_u_79.CurrentDuelSubject then
            p_u_79.CurrentDuelSubject:SetReplicate("IsSpectating", true)
            local v82 = p_u_79._duel_connections
            local v83 = p_u_79.CurrentDuelSubject:GetDataChangedSignal("EnvironmentID")
            table.insert(v82, v83:Connect(function()
                p_u_79.DuelSubjectEnvironmentIDChanged:Fire()
            end))
            local v84 = p_u_79._duel_connections
            local v85 = p_u_79.CurrentDuelSubject:GetDataChangedSignal("Status")
            table.insert(v84, v85:Connect(function()
                p_u_79.DuelSubjectStatusChanged:Fire()
            end))
            local function v_u_86()
                p_u_79:_VerifySubject()
            end
            local v87 = p_u_79._duel_connections
            local v88 = p_u_79.CurrentDuelSubject:GetDataChangedSignal("IsCurrentArcadeDuel")
            table.insert(v87, v88:Connect(v_u_86))
            local v89 = p_u_79._duel_connections
            local v90 = p_u_79.CurrentDuelSubject:GetDataChangedSignal("Status")
            table.insert(v89, v90:Connect(v_u_86))
            local v91 = p_u_79._duel_connections
            local v92 = p_u_79.CurrentDuelSubject.DuelerRemoved
            table.insert(v91, v92:Connect(function(p93)
                if p93.IsLocalPlayer then
                    p_u_79:SpectateDuelRequest(nil)
                else
                    p_u_79:_RemoveSubject(p93.ClientFighter)
                end
            end))
            local function v108(p94, p95)
                local v96 = p_u_79._duel_connections
                local v97 = p94:GetDataChangedSignal("TeamID")
                local v98 = v_u_86
                table.insert(v96, v97:Connect(v98))
                local v99 = p_u_79._duel_connections
                local v100 = p94.EntityAdded
                local v101 = v_u_86
                table.insert(v99, v100:Connect(v101))
                local v102 = p_u_79._duel_connections
                local v103 = p94.Eliminated
                local v104 = v_u_86
                table.insert(v102, v103:Connect(v104))
                local v105 = p_u_79._duel_connections
                local v106 = p94.Died
                local v107 = v_u_86
                table.insert(v105, v106:Connect(v107))
                p_u_79:_AddSubject(p94.ClientFighter, p95)
            end
            local v109 = p_u_79._duel_connections
            local v110 = p_u_79.CurrentDuelSubject.DuelerAdded
            table.insert(v109, v110:Connect(v108))
            for _, v111 in pairs(p_u_79.CurrentDuelSubject.Duelers) do
                v108(v111, true)
            end
            p_u_79:_VerifySubject()
        end
    end
end
function v_u_12._AddSubject(p112, p113, p114)
    if not table.find(p112.Subjects, p113) then
        local v115 = p112.Subjects
        table.insert(v115, p113)
        if not p114 then
            p112:_VerifySubject()
        end
    end
end
function v_u_12._RemoveSubject(p116, p117, p118)
    if p117.IsLocalPlayer then
        return
    else
        local v119 = table.find(p116.Subjects, p117)
        if v119 then
            if p117 == p116.CurrentSubject then
                p116:Increment(-1)
            end
            table.remove(p116.Subjects, v119)
            if not p118 then
                p116:_VerifySubject()
            end
        end
    end
end
function v_u_12._SpectatingReplicationLoop(p120)
    while true do
        wait(1)
        local v121 = p120.CurrentSubject
        if v121 then
            v121 = p120.CurrentSubject.Player.UserId
        end
        if v121 ~= p120._last_spectating_user_id then
            p120._last_spectating_user_id = v121
            v_u_1.Remotes.Replication.Fighter.Spectating:FireServer(p120._last_spectating_user_id)
        end
    end
end
function v_u_12._HookLocalFighter(p_u_122)
    local v_u_123 = v_u_8:WaitForLocalFighter()
    local function v125()
        local v124 = v_u_123:Get("SpectatingDuelObjectID")
        p_u_122:_SpectateDuel(v124 and v_u_10:GetDuelByID(v124) or nil)
    end
    v_u_123:GetDataChangedSignal("SpectatingDuelObjectID"):Connect(v125)
    local v126 = v_u_123:Get("SpectatingDuelObjectID")
    p_u_122:_SpectateDuel(v126 and v_u_10:GetDuelByID(v126) or nil)
end
function v_u_12._Init(p_u_127)
    p_u_127.SubjectChanged:Connect(function()
        p_u_127.SubjectEmoteStatusChanged:Fire()
        v_u_9:SetSubject(p_u_127.CurrentSubject)
    end)
    p_u_127.DuelSubjectChanged:Connect(function()
        p_u_127:_VerifySubject()
        v_u_9.CameraState:SetCustomFreecamEnabled(false)
        v_u_9:SetDuelSubject(p_u_127.CurrentDuelSubject)
    end)
    v_u_2:BindToRenderStep("SpectateController", Enum.RenderPriority.Camera.Value + 1, function(p128)
        p_u_127:Update(p128)
    end)
    v_u_7.InputBegan:Connect(function(p129, p130)
        if p130 or v_u_9:GetPublicState() == v_u_9.CameraState.States.ThirdPersonUnlockedMouse and p129.UserInputType == Enum.UserInputType.MouseButton2 then
            return
        else
            local v131 = v_u_9:GetPublicState() == v_u_9.CameraState.States.CustomFreecam
            if v_u_5:InputIs(p129, "SpectateNext") and not v131 then
                p_u_127:Next()
                return
            elseif v_u_5:InputIs(p129, "SpectateLast") and not v131 then
                p_u_127:Last()
            elseif v_u_5:InputIs(p129, "SpectateExit") then
                p_u_127:Exit()
            end
        end
    end)
    v_u_8.ObjectAdded:Connect(function(p132)
        if p132.IsLocalPlayer then
            p132.EntityAdded:Connect(function()
                p_u_127:_VerifySubject()
            end)
            p132.EntityRemoved:Connect(function()
                p_u_127:_VerifySubject()
            end)
            p132.Died:Connect(function()
                p_u_127:_VerifySubject()
            end)
            p_u_127:_AddSubject(p132)
        end
    end)
    v_u_8.ObjectRemoved:Connect(function(p133)
        p_u_127:_RemoveSubject(p133)
    end)
    v_u_10.LocalPlayerJoinedDuel:Connect(function(p134, p135)
        p_u_127:SpectateDuelRequest(p134, p135)
    end)
    v_u_10.LocalPlayerLeftDuel:Connect(function(_, _)
        p_u_127:SpectateDuelRequest(nil)
    end)
    v_u_10.ObjectRemoved:Connect(function(p136)
        if p_u_127.CurrentDuelSubject == p136 then
            p_u_127:SpectateDuelRequest(nil)
        end
    end)
    v_u_9.CustomFreecamStateChanged:Connect(function()
        p_u_127:_VerifySubject()
    end)
    v_u_11.EnabledChanged:Connect(function()
        if v_u_11.Enabled then
            p_u_127:SpectateDuelRequest(nil)
        end
    end)
    p_u_127:_VerifySubject()
    task.spawn(p_u_127._HookLocalFighter, p_u_127)
    task.spawn(p_u_127._SpectatingReplicationLoop, p_u_127)
end
return v_u_12._new()