local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.ReplicatedClass)
local v_u_4 = require(v1.Modules.Utility)
require(v1.Modules.Signal)
local v_u_5 = require(v2.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
local v_u_6 = {
    ["Docks"] = { "rbxassetid://17813065011", 0.25, 0 },
    ["Station"] = { "rbxassetid://17813065464", 0.25, 13 },
    ["Backrooms"] = { "rbxassetid://17813170797", 1, 0 },
    ["Construction"] = { "rbxassetid://93752516938586", 1, 0 },
    ["Big Backrooms"] = { "rbxassetid://17813170797", 1, 0 },
    ["Onyx"] = { "rbxassetid://12099785239", 0.375, 0 },
    ["Big Onyx"] = { "rbxassetid://12099785239", 0.375, 0 },
    ["Splash"] = { "rbxassetid://18963688210", 0.75, 0 },
    ["Big Splash"] = { "rbxassetid://18963688210", 0.75, 0 },
    ["Zombie Tower"] = { "rbxassetid://90122406367653", 0.25, 0 },
    ["Iceberg"] = { "rbxassetid://103004663415392", 0.25, 0 },
    ["Village"] = { "rbxassetid://103004663415392", 0.25, 0 }
}
local v_u_7 = setmetatable({}, v_u_3)
v_u_7.__index = v_u_7
function v_u_7.new(p8, p9)
    local v10 = v_u_3.new(p8)
    local v11 = v_u_7
    local v12 = setmetatable(v10, v11)
    v12.Name = p8.Name
    v12.Model = p8.Model
    v12.ClientDuel = p9
    v12.Data.IsHidden = nil
    v12.Data.LightingProfileOverride = nil
    v12._destroyed = false
    v12._connections = {}
    v12._active_connections = {}
    v12._on_hidden_update_callback = nil
    v12._textures_deleted = false
    v12._ambience_sound = nil
    v12._spectate_part = nil
    v12:_Init()
    return v12
end
function v_u_7.IsRendered(p13)
    return p13.ClientDuel:IsRendered()
end
function v_u_7.GetSpectatePart(p14)
    if not p14._spectate_part then
        p14._spectate_part = p14.Model:FindFirstChild("Spectate")
    end
    return p14._spectate_part
end
function v_u_7.GetScoreboardDisplay(_)
    return nil
end
function v_u_7.SetHidden(p_u_15, p16)
    if p16 == p_u_15:Get("IsHidden") then
        return
    else
        for _, v17 in pairs(p_u_15._active_connections) do
            v17:Disconnect()
        end
        p_u_15._active_connections = {}
        p_u_15:SetReplicate("IsHidden", p16)
        local v18 = p_u_15.Model
        local v19
        if p_u_15:Get("IsHidden") then
            v19 = nil
        else
            v19 = workspace or nil
        end
        v18.Parent = v19
        p_u_15:_UpdateAmbience()
        if not p_u_15:Get("IsHidden") then
            local v20 = p_u_15._active_connections
            local v21 = v_u_5:GetDataChangedSignal("Settings Textures Disabled")
            table.insert(v20, v21:Connect(function()
                p_u_15:_UpdateTextures()
            end))
            p_u_15:_UpdateTextures()
        end
    end
end
function v_u_7.CreateSound(p22, ...)
    if not p22:Get("IsHidden") then
        return v_u_4:CreateSound(...)
    end
end
function v_u_7.Destroy(p23)
    p23._destroyed = true
    for _, v24 in pairs(p23._active_connections) do
        v24:Disconnect()
    end
    for _, v25 in pairs(p23._connections) do
        v25:Disconnect()
    end
    if p23._ambience_sound then
        p23._ambience_sound:Destroy()
    end
    v_u_3.Destroy(p23)
end
function v_u_7._UpdateAmbience(p26)
    if p26:Get("IsHidden") and p26._ambience_sound then
        p26._ambience_sound:Destroy()
        p26._ambience_sound = nil
    else
        local v27 = not p26:Get("IsHidden") and (not p26._ambience_sound and v_u_6[p26.Name])
        if v27 then
            p26._ambience_sound = v_u_4:CreateSound(v27[1], v27[2], 1, script, true)
            p26._ambience_sound.Looped = true
            p26._ambience_sound.TimePosition = v27[3]
        end
    end
end
function v_u_7._UpdateTextures(p28)
    if not p28._textures_deleted and (not p28:Get("IsHidden") and v_u_5:Get("Settings Textures Disabled")) then
        p28._textures_deleted = true
        v_u_4:DisableTextures(p28.Model)
    end
end
function v_u_7._Init(p29)
    p29:SetHidden(false)
end
return v_u_7