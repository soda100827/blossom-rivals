local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.GameplayUtility)
local v_u_4 = require(v1.Modules.Utility)
local v_u_5 = require(v1.Modules.Signal)
local v_u_6 = require(v2.LocalPlayer.PlayerScripts.Controllers.SpectateController)
local v_u_7 = require(v2.LocalPlayer.PlayerScripts.Controllers.FighterController)
local v_u_8 = require(v2.LocalPlayer.PlayerScripts.Controllers.CameraController)
local v_u_9 = {}
v_u_9.__index = v_u_9
function v_u_9.new(p10)
    local v11 = v_u_9
    local v12 = setmetatable({}, v11)
    v12.EmoteController = p10
    v12._subject_enemies = {}
    v12._subject_enemies_changed = v_u_5.new()
    v12._subject_enemy_added = v_u_5.new()
    v12._subject_enemy_removed = v_u_5.new()
    v12._update_visibility_thread = nil
    v12._dont_render_until = 0
    v12._last_is_emoting_check = nil
    v12:_Init()
    return v12
end
function v_u_9._IsSystemActive(p13)
    return (v_u_6:IsSubjectEmoting() or tick() < p13._dont_render_until) and not v_u_8:HasThirdPersonAccess(true)
end
function v_u_9._GetPosition(_, p14)
    local v15 = p14 and p14:IsAlive() and (p14.Entity and p14.Entity.RootPart)
    if v15 then
        v15 = p14.Entity.RootPart.Position
    end
    return v15
end
function v_u_9._IsHidden(p16, p17)
    if p17 == v_u_6.CurrentSubject then
        return false
    elseif tick() > p16._dont_render_until and not v_u_6:IsSubjectEmoting() then
        return false
    else
        local v18 = p16:_GetPosition(v_u_6.CurrentSubject)
        local v19
        if v18 then
            v19 = p16:_GetPosition(p17)
        else
            v19 = v18
        end
        if v18 and v19 then
            return v_u_4:Raycast(v18, v19, (v18 - v19).Magnitude, v_u_6.CurrentSubject:GetRaycastWhitelist(), Enum.RaycastFilterType.Include).Instance and true or ((v_u_3:GetSmokeCloudBetweenPoints(v18, v19) or (#v_u_3:GetSmokeCloudsInSphere(v19) > 0 or #v_u_3:GetSmokeCloudsInSphere(v18) > 0)) and true or false)
        else
            return false
        end
    end
end
function v_u_9._UpdateVisibility(p20)
    local v21 = v_u_6:IsSubjectEmoting()
    if p20._last_is_emoting_check and not v21 then
        p20._dont_render_until = tick() + 0.25
        task.delay(0.25, p20._CheckSubjectEmoteStatus, p20)
    end
    p20._last_is_emoting_check = v21
    for _, v22 in pairs(p20._subject_enemies) do
        local v23 = p20:_IsHidden(v22) or nil
        if v23 ~= v22:Get("IsHiddenByEmotes") then
            v22:SetReplicate("IsHiddenByEmotes", v23)
        end
    end
end
function v_u_9._CheckSubjectEmoteStatus(p_u_24)
    if p_u_24._update_visibility_thread then
        task.cancel(p_u_24._update_visibility_thread)
        p_u_24._update_visibility_thread = nil
    end
    p_u_24:_UpdateVisibility()
    p_u_24:_UpdateList()
    if p_u_24:_IsSystemActive() then
        p_u_24._update_visibility_thread = task.spawn(function()
            while true do
                wait(0.1)
                p_u_24:_UpdateVisibility()
            end
        end)
    end
end
function v_u_9._GetList(p25)
    local v26 = v_u_6.CurrentSubject
    if not (v26 and (v26:Get("IsInDuel") and (p25:_IsSystemActive() and (v_u_6.CurrentDuelSubject and v_u_6.CurrentDuelSubject.LocalDueler)))) then
        return {}
    end
    local v27 = {}
    for _, v28 in pairs(v_u_7.Objects) do
        if v28 ~= v26 and (v28:Get("EnvironmentID") == v26:Get("EnvironmentID") and (not v28:Get("TeamID") or v28:Get("TeamID") ~= v26:Get("TeamID"))) then
            table.insert(v27, v28)
        end
    end
    return v27
end
function v_u_9._UpdateList(p29)
    local v30 = p29:_GetList()
    local v31 = false
    for v32 = #p29._subject_enemies, 1, -1 do
        local v33 = p29._subject_enemies[v32]
        if not table.find(v30, v33) then
            table.remove(p29._subject_enemies, v32)
            p29._subject_enemy_removed:Fire(v33)
            v31 = true
        end
    end
    for _, v34 in pairs(v30) do
        if not table.find(p29._subject_enemies, v34) then
            local v35 = p29._subject_enemies
            table.insert(v35, v34)
            p29._subject_enemy_added:Fire(v34)
            v31 = true
        end
    end
    if v31 then
        p29._subject_enemies_changed:Fire()
    end
end
function v_u_9._FighterAdded(p_u_36, p37, p38)
    p37:GetDataChangedSignal("EnvironmentID"):Connect(function()
        p_u_36:_UpdateList()
    end)
    p37:GetDataChangedSignal("TeamID"):Connect(function()
        p_u_36:_UpdateList()
    end)
    if not p38 then
        p_u_36:_UpdateList()
    end
end
function v_u_9._Init(p_u_39)
    p_u_39._subject_enemy_added:Connect(function(p40)
        p40:SetReplicate("IsHiddenByEmotes", nil)
    end)
    p_u_39._subject_enemy_removed:Connect(function(p41)
        p41:SetReplicate("IsHiddenByEmotes", nil)
    end)
    v_u_6.DuelSubjectChanged:Connect(function()
        p_u_39:_CheckSubjectEmoteStatus()
    end)
    v_u_6.SubjectEmoteStatusChanged:Connect(function()
        p_u_39:_CheckSubjectEmoteStatus()
    end)
    v_u_7.ObjectAdded:Connect(function(p42)
        p_u_39:_FighterAdded(p42)
    end)
    for _, v43 in pairs(v_u_7.Objects) do
        task.spawn(p_u_39._FighterAdded, p_u_39, v43, true)
    end
    task.defer(p_u_39._CheckSubjectEmoteStatus, p_u_39)
end
return v_u_9