local v_u_1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("Players")
local v_u_3 = require(v_u_1.Modules.Signal)
local v_u_4 = require(v_u_2.LocalPlayer.PlayerScripts.Controllers.UserInterfaceController)
local v_u_5 = require(v_u_2.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
local v_u_6 = require(v_u_2.LocalPlayer.PlayerScripts.Controllers.SpectateController)
local v_u_7 = require(v_u_2.LocalPlayer.PlayerScripts.Controllers.FighterController)
local v_u_8 = require(v_u_2.LocalPlayer.PlayerScripts.Controllers.CameraController)
local v_u_9 = require(script:WaitForChild("EmoteRenderLogic"))
local v_u_10 = require(script:WaitForChild("EmoteSoundLogic"))
local v_u_11 = {}
v_u_11.__index = v_u_11
function v_u_11._new()
    local v12 = v_u_11
    local v13 = setmetatable({}, v12)
    v13.CanEmoteChanged = v_u_3.new()
    v13.EmoteRenderLogic = v_u_9.new(v13)
    v13.EmoteSoundLogic = v_u_10.new(v13)
    v13:_Init()
    return v13
end
function v_u_11.CanEmote(_, p14)
    if v_u_4:IsEquipmentOpen() or not p14 and v_u_4:IsPageOpen() then
        return false
    end
    local v15 = v_u_7:GetFighter(v_u_2.LocalPlayer)
    local v16
    if v15 then
        v16 = v15:Get("IsSpectating")
    else
        v16 = v15
    end
    local v17
    if v_u_8:GetPublicState() == v_u_8.CameraState.States.CustomFreecam then
        v17 = not v_u_6.CurrentDuelSubject or v_u_6.CurrentDuelSubject.LocalDueler
    else
        v17 = false
    end
    if not (v16 or v17) then
        return false
    end
    local v18 = v15.IsLocalPlayer and (v15:IsAlive() and not v15.Entity:Get("IsFrozen"))
    if v18 then
        v18 = next(v_u_5:Get("EquippedEmotes")) ~= nil
    end
    return v18
end
function v_u_11.UseEmote(_, p19)
    v_u_1.Remotes.Replication.Fighter.UseEmote:FireServer(p19)
end
function v_u_11.EquipEmote(_, p20, p21)
    v_u_1.Remotes.Data.EquipEmote:FireServer(p20, p21)
end
function v_u_11._FighterAdded(p_u_22, p23)
    if p23.IsLocalPlayer then
        local function v_u_24()
            p_u_22.CanEmoteChanged:Fire()
        end
        p23:GetDataChangedSignal("IsSpectating"):Connect(v_u_24)
        p23.HealthChanged:Connect(v_u_24)
        p_u_22.CanEmoteChanged:Fire()
        local function v26(p25)
            p25:GetDataChangedSignal("IsFrozen"):Connect(v_u_24)
            p_u_22.CanEmoteChanged:Fire()
        end
        p23.EntityAdded:Connect(v26)
        if p23.Entity then
            task.spawn(v26, p23.Entity)
        end
    end
end
function v_u_11._Init(p_u_27)
    v_u_5:GetDataChangedSignal("EquippedEmotes"):Connect(function()
        p_u_27.CanEmoteChanged:Fire()
    end)
    v_u_8.StateChanged:Connect(function()
        p_u_27.CanEmoteChanged:Fire()
    end)
    v_u_6.DuelSubjectChanged:Connect(function()
        p_u_27.CanEmoteChanged:Fire()
    end)
    v_u_4.PageSystemPagesActivity:Connect(function()
        p_u_27.CanEmoteChanged:Fire()
    end)
    v_u_4.EquipmentOpened:Connect(function()
        p_u_27.CanEmoteChanged:Fire()
    end)
    v_u_7.ObjectAdded:Connect(function(p28)
        p_u_27:_FighterAdded(p28)
    end)
    for _, v29 in pairs(v_u_7.Objects) do
        task.spawn(p_u_27._FighterAdded, p_u_27, v29)
    end
end
return v_u_11._new()