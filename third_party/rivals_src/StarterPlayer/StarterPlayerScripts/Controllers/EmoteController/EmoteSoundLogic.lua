local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.CosmeticLibrary)
local v_u_4 = require(v2.LocalPlayer.PlayerScripts.Controllers.SpectateController)
local v_u_5 = require(v2.LocalPlayer.PlayerScripts.Controllers.FighterController)
local v_u_6 = {}
v_u_6.__index = v_u_6
function v_u_6.new(p7)
    local v8 = v_u_6
    local v9 = setmetatable({}, v8)
    v9.EmoteController = p7
    v9._emotes_order = {}
    v9:_Init()
    return v9
end
function v_u_6._GetDistance(_, p10)
    local v11 = workspace.CurrentCamera.CFrame.Position
    local v12 = p10.Entity and p10.Entity.RootPart
    if v12 then
        v12 = p10.Entity.RootPart.Position
    end
    if v12 then
        return (v11 - v12).Magnitude
    else
        return nil
    end
end
function v_u_6._IsValidFighter(p13, p14)
    local v15
    if v_u_4.CurrentSubject then
        v15 = v_u_4.CurrentSubject:Get("EnvironmentID")
    elseif v_u_4.CurrentDuelSubject then
        v15 = v_u_4.CurrentDuelSubject:Get("EnvironmentID")
    else
        v15 = nil
    end
    if v15 ~= p14:Get("EnvironmentID") then
        return false
    end
    local v16 = p13:_GetDistance(p14)
    return v16 and v16 <= 128 and true or false
end
function v_u_6._VerifyEmotesOrder(p_u_17)
    local v18 = {}
    for v19 = #p_u_17._emotes_order, 1, -1 do
        local v20 = p_u_17._emotes_order[v19]
        v18[v20.ClientFighter] = true
        if v20.Emote:IsDestroyed() or not p_u_17:_IsValidFighter(v20.ClientFighter) then
            v20.Emote:HideSounds(false)
            table.remove(p_u_17._emotes_order, v19)
        end
    end
    for _, v21 in pairs(v_u_5.Objects) do
        if not v18[v21] then
            local v22 = v21.Entity and v21.Entity:IsEmoting()
            if v22 then
                v22 = v21.Entity:GetCurrentEmote()
            end
            if v22 and (v_u_3.Cosmetics[v22.Name].IsAudioIntrusive and p_u_17:_IsValidFighter(v21)) then
                local v23 = p_u_17._emotes_order
                table.insert(v23, {
                    ["Emote"] = v22,
                    ["ClientFighter"] = v21
                })
            end
        end
    end
    table.clear(v18)
    table.sort(p_u_17._emotes_order, function(p24, p25)
        return p_u_17:_GetDistance(p24.ClientFighter) < p_u_17:_GetDistance(p25.ClientFighter)
    end)
end
function v_u_6._Check(p26)
    p26:_VerifyEmotesOrder()
    local v27 = v_u_4:IsSubjectEmoting()
    local v28
    if v27 then
        v28 = v_u_3.Cosmetics[v_u_4.CurrentSubject.Entity:GetCurrentEmote().Name].IsAudioIntrusive
    else
        v28 = v27
    end
    for v29, v30 in pairs(p26._emotes_order) do
        local v31
        if v27 and v28 then
            v31 = v30.ClientFighter ~= v_u_4.CurrentSubject
        else
            v31 = v29 > 1
        end
        v30.Emote:HideSounds(v31)
    end
end
function v_u_6._CheckLoop(p32)
    while true do
        p32:_Check()
        wait(1)
    end
end
function v_u_6._FighterAdded(p_u_33, p34, p_u_35)
    local function v37(p36)
        p36.EmoteStatusChanged:Connect(function()
            p_u_33:_Check()
        end)
        if not p_u_35 then
            p_u_33:_Check()
        end
    end
    p34.EntityAdded:Connect(v37)
    if p34.Entity then
        task.spawn(v37, p34.Entity)
    end
    if not p_u_35 then
        p_u_33:_Check()
    end
end
function v_u_6._Init(p_u_38)
    v_u_4.SubjectEmoteStatusChanged:Connect(function()
        p_u_38:_Check()
    end)
    v_u_5.ObjectAdded:Connect(function(p39)
        p_u_38:_FighterAdded(p39)
    end)
    for _, v40 in pairs(v_u_5.Objects) do
        task.spawn(p_u_38._FighterAdded, p_u_38, v40, true)
    end
    task.defer(p_u_38._CheckLoop, p_u_38)
end
return v_u_6