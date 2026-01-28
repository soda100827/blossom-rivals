local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("SoundService")
local v_u_3 = game:GetService("Lighting")
local v4 = game:GetService("Players")
local v5 = require(v1.Modules.EventLibrary)
local v_u_6 = require(v4.LocalPlayer.PlayerScripts.Controllers.SpectateController)
local v_u_7 = require(v4.LocalPlayer.PlayerScripts.Controllers.FighterController)
local v_u_8 = require(v4.LocalPlayer.PlayerScripts.Modules.UserInterface.Equipment)
local v_u_9 = v4.LocalPlayer.PlayerScripts.Modules.LightingProfiles
local v_u_10 = v4.LocalPlayer.PlayerScripts.Assets.LightingProfiles
local v_u_11 = v5.IS_ACTIVE and (v5.EVENT_DETAILS.LOBBY_LIGHTING_PROFILE or "Lobby") or "Lobby"
local v_u_12 = v5.IS_ACTIVE and v5.EVENT_DETAILS.EQUIPMENT_LIGHTING_PROFILE or "Lobby"
local v_u_13 = {}
v_u_13.__index = v_u_13
function v_u_13._new()
    local v14 = v_u_13
    local v15 = setmetatable({}, v14)
    v15.LocalFighter = nil
    v15._connections = {}
    v15._assets = {}
    v15._current_lighting_name = nil
    v15:_Init()
    return v15
end
function v_u_13.SetLighting(p16, p17)
    if p17 == p16._current_lighting_name then
        return
    else
        p16:_LoadMapLightingAssets("Default")
        p16:_LoadMapLightingModule("Default")
        if p17 ~= "Default" then
            p16:_LoadMapLightingAssets(p17)
            p16:_LoadMapLightingModule(p17)
        end
    end
end
function v_u_13._LoadMapLightingAssets(p18, p19)
    local v20 = v_u_10:FindFirstChild(p19)
    if v20 then
        for _, v21 in pairs(p18._assets) do
            v21:Destroy()
        end
        p18._assets = {}
        for _, v22 in pairs(v20:GetChildren()) do
            local v23 = v22:Clone()
            v23.Name = "LightingController"
            v23.Parent = v22:IsA("Clouds") and workspace.Terrain or v_u_3
            local v24 = p18._assets
            table.insert(v24, v23)
        end
    end
end
function v_u_13._LoadMapLightingModule(_, p25)
    local v26 = v_u_9:FindFirstChild(p25)
    if v26 then
        v26 = require(v_u_9[p25])
    end
    if v26 then
        for v27, v28 in pairs(v26.TerrainMaterials or {}) do
            workspace.Terrain:SetMaterialColor(v27, v28)
        end
        for v29, v30 in pairs(v26.TerrainProperties or {}) do
            workspace.Terrain[v29] = v30
        end
        for v31, v32 in pairs(v26.LightingProperties or {}) do
            v_u_3[v31] = v32
        end
        for v33, v34 in pairs(v26.SoundServiceProperties or {}) do
            v_u_2[v33] = v34
        end
    end
end
function v_u_13._UpdateLighting(p_u_35)
    for _, v36 in pairs(p_u_35._connections) do
        v36:Disconnect()
    end
    p_u_35._connections = {}
    if v_u_8.IsOpen then
        p_u_35:SetLighting(v_u_12)
        return
    elseif v_u_6.CurrentDuelSubject then
        local function v_u_38()
            local v37 = v_u_6.CurrentDuelSubject
            if v37 then
                v37 = v_u_6.CurrentDuelSubject.Map
            end
            p_u_35:SetLighting(not v37 or v37:Get("LightingProfileOverride") or (v37.Name or "Default"))
        end
        local function v44(p39)
            local v40 = p_u_35._connections
            local v41 = p39:GetDataChangedSignal("LightingProfileOverride")
            local v42 = v_u_38
            table.insert(v40, v41:Connect(v42))
            local v43 = v_u_6.CurrentDuelSubject
            if v43 then
                v43 = v_u_6.CurrentDuelSubject.Map
            end
            p_u_35:SetLighting(not v43 or v43:Get("LightingProfileOverride") or (v43.Name or "Default"))
        end
        local v45 = p_u_35._connections
        local v46 = v_u_6.CurrentDuelSubject.MapAdded
        table.insert(v45, v46:Connect(v44))
        if v_u_6.CurrentDuelSubject.Map then
            local v47 = v_u_6.CurrentDuelSubject.Map
            local v48 = p_u_35._connections
            local v49 = v47:GetDataChangedSignal("LightingProfileOverride")
            table.insert(v48, v49:Connect(v_u_38))
            local v50 = v_u_6.CurrentDuelSubject
            if v50 then
                v50 = v_u_6.CurrentDuelSubject.Map
            end
            p_u_35:SetLighting(not v50 or v50:Get("LightingProfileOverride") or (v50.Name or "Default"))
        end
        local v51 = v_u_6.CurrentDuelSubject
        if v51 then
            v51 = v_u_6.CurrentDuelSubject.Map
        end
        p_u_35:SetLighting(not v51 or v51:Get("LightingProfileOverride") or (v51.Name or "Default"))
        return
    elseif p_u_35.LocalFighter and p_u_35.LocalFighter:Get("IsInShootingRange") then
        p_u_35:SetLighting("Shooting Range")
    else
        p_u_35:SetLighting(v_u_11)
    end
end
function v_u_13._HookLocalFighter(p_u_52)
    p_u_52.LocalFighter = v_u_7:WaitForLocalFighter()
    p_u_52.LocalFighter:GetDataChangedSignal("IsInShootingRange"):Connect(function()
        p_u_52:_UpdateLighting()
    end)
    p_u_52:_UpdateLighting()
end
function v_u_13._Setup(_)
    workspace.Terrain:ClearAllChildren()
    for _, v53 in pairs(v_u_3:GetChildren()) do
        if v53.Name == "REMOVE_AT_RUNTIME" then
            v53:Destroy()
        end
    end
end
function v_u_13._Init(p_u_54)
    v_u_6.DuelSubjectChanged:Connect(function()
        p_u_54:_UpdateLighting()
    end)
    v_u_8.Opened:Connect(function()
        p_u_54:_UpdateLighting()
    end)
    p_u_54:_Setup()
    p_u_54:_UpdateLighting()
    task.spawn(p_u_54._HookLocalFighter, p_u_54)
end
return v_u_13._new()