local v_u_1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("StarterGui")
game:GetService("RunService")
local v_u_3 = game:GetService("Players")
local v_u_4 = require(v_u_1.Modules.EnumLibrary)
local v_u_5 = require(v_u_1.Modules.Utility)
require(v_u_3.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
local v_u_6 = require(v_u_3.LocalPlayer.PlayerScripts.Controllers.ControlsController)
local v_u_7 = require(v_u_3.LocalPlayer.PlayerScripts.Controllers.CameraController)
local v_u_8 = require(v_u_3.LocalPlayer.PlayerScripts.Modules.ReplicatedController)
local v_u_9 = v_u_3.LocalPlayer.PlayerScripts.Assets:WaitForChild("Misc"):WaitForChild("DefaultCharacter")
local v_u_10 = setmetatable({}, v_u_8)
v_u_10.__index = v_u_10
function v_u_10._new()
    local v11 = v_u_8.new("Fighter")
    local v12 = v_u_10
    local v13 = setmetatable(v11, v12)
    v13.LocalFighter = nil
    v13._network_id_map = {}
    v13._last_encoded_camera_rotation = nil
    v13._last_connection_level = nil
    v13._player_to_fighter = {}
    v13._model_to_fighter = {}
    v13._last_controls_replicated_time = 0
    v13._character_model_cache = {}
    v13:_Init()
    return v13
end
function v_u_10.GetFighter(p14, p15)
    local v16 = p14._player_to_fighter[p15] or p14._model_to_fighter[p15]
    if v16 then
        return v16
    elseif p15 then
        if typeof(p15) == "Instance" then
            if not p15:IsA("Player") then
                return p14:GetFighter(v_u_3:GetPlayerFromCharacter(p15))
            end
            for v17, v18 in pairs(p14.Objects) do
                if v18.Player == p15 then
                    return v18, v17
                end
            end
            return nil
        end
        if typeof(p15) == "number" then
            return p14:GetFighter(v_u_3:GetPlayerByUserId(p15))
        end
        local v19 = "Argument 1 invalid, expected a Player or a Model or nil, got " .. tostring(p15) .. " (type: " .. (typeof(p15) == "Instance" and p15.ClassName or typeof(p15)) .. ")"
        assert(false, v19)
    end
end
function v_u_10.GetFighterFromNetworkID(p20, p21)
    return p20._network_id_map[p21]
end
function v_u_10.GetFightersNotInDuel(p22)
    local v23 = {}
    for _, v24 in pairs(p22.Objects) do
        if not v24:Get("IsInDuel") then
            table.insert(v23, v24)
        end
    end
    return v23
end
function v_u_10.GetEntities(p25)
    local v26 = {}
    for _, v27 in pairs(p25.Objects) do
        if v27.Entity then
            local v28 = v27.Entity
            table.insert(v26, v28)
        end
    end
    return v26
end
function v_u_10.GetFighterModels(p29, p30)
    local v31 = {}
    for _, v32 in pairs(p29.Objects) do
        if v32.Entity and not (p30 and v32.IsLocalPlayer) then
            local v33 = v32.Entity.Model
            table.insert(v31, v33)
        end
    end
    return v31
end
function v_u_10.WaitForFighter(p34, ...)
    while true do
        local v35 = p34:GetFighter(...)
        if v35 then
            break
        end
        p34.ObjectAdded:Wait()
    end
    return v35
end
function v_u_10.WaitForLocalFighter(p36)
    return p36:WaitForFighter(v_u_3.LocalPlayer)
end
function v_u_10.GenerateCharacterModel(p_u_37, p_u_38, p39)
    if p_u_37._character_model_cache[tostring(p_u_38)] then
        return p_u_37._character_model_cache[tostring(p_u_38)]
    end
    local function v46()
        local v40, v41 = pcall(v_u_3.GetHumanoidDescriptionFromUserId, v_u_3, p_u_38)
        if v40 then
            v41.Head = 2432102561
            v41.Torso = 15365012259
            v41.LeftArm = 15365010034
            v41.RightArm = 15365012263
            v41.LeftLeg = 15365010038
            v41.RightLeg = 15365010030
            local v42, v43 = pcall(v_u_3.CreateHumanoidModelFromDescription, v_u_3, v41, Enum.HumanoidRigType.R15)
            if v42 then
                p_u_37._preloaded_character_model = v43
                local v44 = {
                    ["Template"] = v43
                }
                local v45 = p_u_38
                p_u_37._character_model_cache[tostring(v45)] = v44
                return v44
            end
            warn("Failed to create humanoid model:", v43)
        else
            warn("Failed to fetch humanoid description:", v41)
        end
    end
    if p39 then
        return v46()
    end
    task.spawn(v46)
    return p_u_37._character_model_cache[tostring(p_u_38)] or {
        ["Template"] = v_u_9
    }
end
function v_u_10._VerifyEntityLoop(p_u_47)
    local function v49()
        local v48 = not (p_u_47.LocalFighter:Get("IsInDuel") or p_u_47.LocalFighter:Get("IsInShootingRange"))
        if v48 then
            v48 = not (v_u_3.LocalPlayer.Character and p_u_47.LocalFighter.Entity) or p_u_47.LocalFighter.Entity.Model ~= v_u_3.LocalPlayer.Character
        end
        return v48
    end
    while wait(1) do
        if v49() then
            wait(2)
            if v49() then
                v_u_1.Remotes.Replication.Fighter.VerifyClientEntity:FireServer()
                wait(10)
            end
        end
    end
end
function v_u_10._ConnectionLevelReplicationLoop(p50)
    while true do
        repeat
            wait(1)
        until p50.LocalFighter and p50.LocalFighter:Get("IsInDuel")
        local v51 = v_u_5:GetConnectionLevel((v_u_5:GetLocalConnectionPing()))
        if v51 ~= p50._last_connection_level then
            p50._last_connection_level = v51
            v_u_1.Remotes.Replication.Fighter.UpdateConnectionLevel:FireServer(v51)
        end
    end
end
function v_u_10._UpdateNetworkIDMap(p52)
    p52._network_id_map = {}
    for _, v53 in pairs(p52.Objects) do
        local v54 = v53:Get("DecodedNetworkID")
        if v54 then
            p52._network_id_map[v54] = v53
        end
    end
end
function v_u_10._FighterAdded(p_u_55, p_u_56)
    p_u_56:GetDataChangedSignal("DecodedNetworkID"):Connect(function()
        p_u_55:_UpdateNetworkIDMap()
    end)
    p_u_56.EntityAdded:Connect(function(p57)
        p_u_55._model_to_fighter[p57.Model] = p_u_56
    end)
    p_u_56.EntityRemoved:Connect(function(_)
        for v58, v59 in pairs(p_u_55._model_to_fighter) do
            if v59 == p_u_56 then
                p_u_55._model_to_fighter[v58] = nil
            end
        end
    end)
    if p_u_56.Entity and p_u_56.Entity.Model then
        p_u_55._model_to_fighter[p_u_56.Entity.Model] = p_u_56
    end
    p_u_55._player_to_fighter[p_u_56.Player] = p_u_56
    p_u_55:_UpdateNetworkIDMap()
end
function v_u_10._ReplicateControls(p60)
    if p60.LocalFighter then
        local v61 = 0.2 - (tick() - p60._last_controls_replicated_time)
        local v62 = math.max(v61, 0.2)
        task.delay(v62, function()
            v_u_1.Remotes.Replication.Fighter.SetControls:FireServer(v_u_6.CurrentControls)
        end)
    end
end
function v_u_10._CameraReplicationLoop(p63)
    while true do
        while true do
            wait(0.1)
            if p63.LocalFighter and (p63.LocalFighter:Get("IsSpectating") and v_u_7:GetPublicState()) then
                break
            end
            if not p63._replication_stopped then
                v_u_1.Remotes.Replication.Fighter.UpdateCameraRotation:FireServer(v_u_5:EncodeCameraRotation(Vector2.zero), nil)
                p63._replication_stopped = true
            end
        end
        local v64 = v_u_5:EncodeCameraRotation(v_u_7.Rotation)
        if p63._replication_stopped or v64 ~= p63._last_encoded_camera_rotation then
            v_u_1.Remotes.Replication.Fighter.UpdateCameraRotation:FireServer(v64, nil)
        end
        p63._last_encoded_camera_rotation = v64
        p63._replication_stopped = false
    end
end
function v_u_10._HookLocalFighter(p_u_65)
    p_u_65.LocalFighter = p_u_65:WaitForLocalFighter()
    local function v66()
        v_u_7:SetThirdPersonOverride(p_u_65.LocalFighter:Get("ThirdPersonOverride"))
    end
    p_u_65.LocalFighter:GetDataChangedSignal("ThirdPersonOverride"):Connect(v66)
    task.defer(v66)
    local v_u_67 = 0
    local v_u_68 = Instance.new("BindableEvent")
    v_u_68.Event:Connect(function()
        v_u_1.Remotes.Replication.Fighter.ResetCharacter:FireServer()
    end)
    local function v77()
        v_u_67 = v_u_67 + 1
        local v69 = v_u_67
        while v_u_67 == v69 do
            local v70 = pcall
            local v71 = v_u_2.SetCore
            local v72 = v_u_2
            local v73 = "ResetButtonCallback"
            local v74 = not p_u_65.LocalFighter:Get("IsInDuel")
            if v74 then
                v74 = v_u_68
            end
            local v75, v76 = v70(v71, v72, v73, v74)
            if v75 then
                break
            end
            warn("Failed to set reset button callback", v76)
            wait(0.1)
        end
    end
    p_u_65.LocalFighter:GetDataChangedSignal("IsInDuel"):Connect(v77)
    task.defer(v77)
    p_u_65:_ReplicateControls()
    task.defer(p_u_65._CameraReplicationLoop, p_u_65)
    task.defer(p_u_65._ConnectionLevelReplicationLoop, p_u_65)
    task.defer(p_u_65._VerifyEntityLoop, p_u_65)
end
function v_u_10._Setup(p78)
    function p78._reject_object_added_serial_callback(p79)
        local v80 = not p79[v_u_4:ToEnum("Player")]
        if v80 then
            v80 = not v_u_3:GetPlayerByUserId(p79[v_u_4:ToEnum("UserID")])
        end
        return v80
    end
end
function v_u_10._Init(p_u_81)
    p_u_81.ObjectAdded:Connect(function(p82)
        p_u_81:_FighterAdded(p82)
    end)
    p_u_81.ObjectRemoved:Connect(function(p83)
        for v84, v85 in pairs(p_u_81._player_to_fighter) do
            if v85 == p83 then
                p_u_81._model_to_fighter[v84] = nil
            end
        end
        for v86, v87 in pairs(p_u_81._model_to_fighter) do
            if v87 == p83 then
                p_u_81._model_to_fighter[v86] = nil
            end
        end
    end)
    v_u_6.ControlsChanged:Connect(function()
        p_u_81:_ReplicateControls()
    end)
    v_u_1.Remotes.Replication.Fighter.UpdateCameraRotations.OnClientEvent:Connect(function(p88)
        local v89 = v_u_5:DecodeCameraRotationBulk(p88)
        for _, v90 in pairs(v89) do
            local v91, v92, v93 = table.unpack(v90)
            local v94 = p_u_81:GetFighterFromNetworkID(v91)
            if v94 then
                v94:SetReplicate("CameraRotation", v_u_5:FromXYToCameraRotation(v92, v93))
            end
        end
    end)
    for _, v95 in pairs(p_u_81.Objects) do
        task.spawn(p_u_81._FighterAdded, p_u_81, v95)
    end
    p_u_81:_Setup()
    task.defer(p_u_81._HookLocalFighter, p_u_81)
end
return v_u_10._new()