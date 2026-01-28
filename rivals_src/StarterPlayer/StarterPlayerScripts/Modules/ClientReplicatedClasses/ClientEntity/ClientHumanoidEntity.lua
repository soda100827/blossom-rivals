local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.Signal)
local v_u_4 = require(v2.LocalPlayer.PlayerScripts.Controllers.PreloadController)
local v_u_5 = require(v2.LocalPlayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientEntity)
local v_u_6 = v2.LocalPlayer.PlayerScripts.Assets.Misc.HeadshotParticles.Attachment
local v_u_7 = v1.Modules.Emotes
local v_u_8 = setmetatable({}, v_u_5)
v_u_8.__index = v_u_8
function v_u_8.new(p9)
    local v10 = v_u_5.new(p9)
    local v11 = v_u_8
    local v12 = setmetatable(v10, v11)
    v12.EmoteStatusChanged = v_u_3.new()
    v12.Humanoid = p9.Humanoid
    v12._headshot_particles = v_u_6:Clone()
    v12._animation_cleanup = {}
    v12._current_emote = nil
    v12:_Init()
    return v12
end
function v_u_8.IsEmoting(p13)
    return p13._current_emote ~= nil
end
function v_u_8.GetCurrentEmote(p14)
    return p14._current_emote
end
function v_u_8.GetHealth(p15)
    return p15.Humanoid and p15.Humanoid.Health or 0
end
function v_u_8.GetMaxHealth(p16)
    return p16.Humanoid and p16.Humanoid.MaxHealth or 100
end
function v_u_8.CancelEmote(p17, p18)
    local v19 = p17._current_emote
    if v19 then
        if not p18 or p17._current_emote.ObjectID == p18 then
            v19:Destroy()
            p17._current_emote = nil
            p17.EmoteStatusChanged:Fire()
        end
    else
        return
    end
end
function v_u_8.PlayEmote(p20, p21)
    p20:CancelEmote()
    if p20:IsAlive() then
        local v22 = require(v_u_7[p21.Name]).new(p20.Humanoid)
        v22:SetSerial(p21)
        p20._current_emote = v22
        p20.EmoteStatusChanged:Fire()
        v22:PlayClient()
    end
end
function v_u_8.ReplicateFromServer(p23, p24, ...)
    if p24 == "PlayAnimation" then
        if p23:IsRendered() then
            p23:_PlayAnimation(...)
        end
    elseif p24 == "EmotePlayed" then
        if p23:IsRendered() then
            p23:PlayEmote(...)
        end
    elseif p24 == "EmoteStopped" then
        p23:CancelEmote(...)
    else
        v_u_5.ReplicateFromServer(p23, p24, ...)
    end
end
function v_u_8.Destroy(p25)
    for _, v26 in pairs(p25._animation_cleanup) do
        v26:Destroy()
    end
    p25._animation_cleanup = {}
    p25.EmoteStatusChanged:Destroy()
    p25:CancelEmote()
    v_u_5.Destroy(p25)
end
function v_u_8._PlayAnimation(p27, p28, ...)
    local v29 = v_u_4:GetPreloadedAnimationID(p28) or p28
    local v30 = v_u_4:GetPreloadedAnimation(p28) or p27:_CreateAnimation(v29)
    local v31 = p27.Humanoid:LoadAnimation(v30)
    local v32 = p27._animation_cleanup
    table.insert(v32, v31)
    v31:Play(...)
end
function v_u_8._CreateAnimation(p33, p34)
    local v35 = typeof(p34) == "string"
    assert(v35, "Argument 1 invalid, expected a string")
    local v36 = Instance.new("Animation")
    v36.AnimationId = p34
    local v37 = p33._animation_cleanup
    table.insert(v37, v36)
    return v36
end
function v_u_8._Setup(p_u_38)
    local v39 = p_u_38._headshot_particles
    local v40 = p_u_38.Model
    if v40 then
        v40 = p_u_38.Model:FindFirstChild("Head")
    end
    v39.Parent = v40
    if p_u_38.Humanoid then
        p_u_38.Humanoid:GetPropertyChangedSignal("MaxHealth"):Connect(function()
            p_u_38.HealthChanged:Fire()
        end)
        p_u_38.Humanoid:GetPropertyChangedSignal("Health"):Connect(function()
            p_u_38.HealthChanged:Fire()
        end)
    end
end
function v_u_8._Init(p41)
    p41:_Setup()
end
return v_u_8