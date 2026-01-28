local v_u_1 = game:GetService("CollectionService")
local v2 = game:GetService("ReplicatedStorage")
local v3 = game:GetService("Players")
local v4 = require(v2.Modules.CONSTANTS)
local v_u_5 = require(v2.Modules.GameplayUtility)
local v_u_6 = require(v2.Modules.Signal)
local v_u_7 = v4.IS_CLIENT
if v_u_7 then
    v_u_7 = require(v3.LocalPlayer.PlayerScripts.Controllers.SpectateController)
end
local v_u_8 = {}
v_u_8.__index = v_u_8
function v_u_8.new(p9, p10)
    local v11 = v_u_8
    local v12 = setmetatable({}, v11)
    v12.SteppedOut = v_u_6.new()
    v12.Warning = v_u_6.new()
    v12.Kill = v_u_6.new()
    v12._fighter_subject = p9
    v12._update_frequency = p10 or 0.1
    v12._next_update = 0
    v12._oob_details = nil
    v12._connections = {}
    v12._object_connections = {}
    v12._is_visible = false
    v12:_Init()
    return v12
end
function v_u_8.GetSubject(p13)
    if p13._fighter_subject then
        return p13._fighter_subject.Entity
    end
    local v14 = v_u_7 and (v_u_7.CurrentSubject and v_u_7.CurrentSubject.IsLocalPlayer)
    if v14 then
        v14 = v_u_7.CurrentSubject.Entity
    end
    return v14
end
function v_u_8.IsOutOfBounds(p15)
    local v16 = p15:GetSubject()
    if v16 and (v16:IsAlive() and v16.RootPart) then
        return v_u_5:IsWithinOOBPart(v16.RootPart.Position)
    end
end
function v_u_8.SetVisible(p17, p18)
    p17._is_visible = p18
    if not p17._is_visible then
        for _, v19 in pairs(v_u_1:GetTagged("OutOfBoundsSafePart")) do
            p17:_UpdateVisibilityForPart(v19)
        end
        for _, v20 in pairs(v_u_1:GetTagged("OutOfBoundsPart")) do
            p17:_UpdateVisibilityForPart(v20)
        end
    end
end
function v_u_8.Update(p21, _)
    if tick() < p21._next_update then
        return
    else
        p21._next_update = tick() + p21._update_frequency
        if not p21:_CheckKill() then
            local v22 = p21:IsOutOfBounds()
            if v22 then
                if not p21._oob_details or v22 ~= p21._oob_details.Part then
                    local v23 = v_u_5:GetOOBWarnDelay(v22:GetAttribute("WarnDelay"))
                    local v24 = v_u_5:GetOOBKillDelay(v22:GetAttribute("KillDelay"))
                    if not p21._oob_details or v23 + v24 < p21._oob_details.KillTime - tick() then
                        p21._oob_details = {
                            ["Part"] = v22,
                            ["WarnTime"] = tick() + v23,
                            ["KillTime"] = tick() + v23 + v24
                        }
                        p21.Warning:Fire(v23 + v24)
                    end
                end
            elseif p21._oob_details then
                p21._oob_details = nil
                p21.SteppedOut:Fire()
            end
            p21:_CheckKill()
        end
    end
end
function v_u_8.Destroy(p25)
    p25.SteppedOut:Destroy()
    p25.Warning:Destroy()
    p25.Kill:Destroy()
    for _, v26 in pairs(p25._connections) do
        v26:Disconnect()
    end
    for _, v27 in pairs(p25._object_connections) do
        for _, v28 in pairs(v27) do
            v28:Disconnect()
        end
    end
end
function v_u_8._CheckKill(p29)
    if p29._oob_details and tick() >= p29._oob_details.KillTime then
        p29.Kill:Fire(p29._oob_details.Part)
        p29._oob_details = nil
        p29.SteppedOut:Fire()
        return true
    end
end
function v_u_8._UpdateVisibilityForPart(p30, p31)
    if p30._is_visible then
        p31.Transparency = 0
        p31.Material = Enum.Material.ForceField
        p31.Color = Color3.fromRGB(255, 215, 0)
    else
        task.defer(p31.ClearAllChildren, p31)
        p31.Transparency = 1
    end
end
function v_u_8._ObjectAdded(p32, p33)
    p32:_ObjectRemoved(p33)
    p32._object_connections[p33] = {}
    local v34 = p32._object_connections[p33]
    local v35 = p33.ChildAdded
    table.insert(v34, v35:Connect(function(p36)
        task.defer(p36.Destroy, p36)
    end))
    p32:_UpdateVisibilityForPart(p33)
end
function v_u_8._ObjectRemoved(p37, p38)
    for _, v39 in pairs(p37._object_connections[p38] or {}) do
        v39:Disconnect()
    end
    p37._object_connections[p38] = nil
end
function v_u_8._Init(p_u_40)
    local v41 = p_u_40._connections
    local v42 = v_u_1:GetInstanceAddedSignal("OutOfBoundsPart")
    table.insert(v41, v42:Connect(function(p43)
        p_u_40:_ObjectAdded(p43)
    end))
    local v44 = p_u_40._connections
    local v45 = v_u_1:GetInstanceAddedSignal("OutOfBoundsSafePart")
    table.insert(v44, v45:Connect(function(p46)
        p_u_40:_ObjectAdded(p46)
    end))
    for _, v47 in pairs(v_u_1:GetTagged("OutOfBoundsPart")) do
        task.defer(p_u_40._ObjectAdded, p_u_40, v47)
    end
    for _, v48 in pairs(v_u_1:GetTagged("OutOfBoundsSafePart")) do
        task.defer(p_u_40._ObjectAdded, p_u_40, v48)
    end
end
return v_u_8