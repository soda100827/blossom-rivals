local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.CosmeticLibrary)
local v_u_4 = require(v_u_2.LocalPlayer.PlayerScripts.Controllers.FighterController)
local v_u_5 = v1.Modules.Emotes
local v_u_6 = {}
v_u_6.__index = v_u_6
function v_u_6.new(p7)
    local v8 = v_u_6
    local v9 = setmetatable({}, v8)
    v9.Scene = p7
    v9._playing_hash = 0
    v9._last_rig = nil
    v9._last_emote = nil
    v9:_Init()
    return v9
end
function v_u_6.OnCustomizingStateChanged(p10)
    task.defer(p10._StartPlaying, p10)
end
function v_u_6.OnStateChanged(p11)
    task.defer(p11._StartPlaying, p11)
end
function v_u_6._StartPlaying(p12)
    p12._playing_hash = p12._playing_hash + 1
    local v13 = p12._playing_hash
    if p12._last_rig then
        p12._last_rig:Destroy()
        p12._last_rig = nil
    end
    if p12._last_emote then
        p12._last_emote:Destroy()
        p12._last_emote = nil
    end
    local v14 = p12.Scene.Equipment:GetSelectedCosmetic()
    local v15 = p12.Scene.Equipment:GetCustomizingType()
    local v16 = v_u_3.Cosmetics[v14]
    if v15 ~= "Emote" or not v16 then
        return
    end
    while true do
        p12._last_rig = v_u_4:GenerateCharacterModel(v_u_2.LocalPlayer.UserId).Template:Clone()
        p12._last_rig:PivotTo(p12.Scene:GetHumanoidCFrame() * v16.ViewportCFrameOffset)
        p12._last_rig.HumanoidRootPart.Anchored = true
        p12._last_rig.Parent = p12.Scene.Model
        local v17 = Instance.new("Animation")
        v17.AnimationId = "rbxassetid://507766388"
        local v18, v19 = pcall(p12._last_rig.Humanoid.LoadAnimation, p12._last_rig.Humanoid, v17)
        if v18 then
            v19:Play(0)
        end
        p12._last_emote = require(v_u_5[v14]).new(p12._last_rig.Humanoid)
        task.defer(p12._last_emote.Simulate, p12._last_emote)
        p12._last_emote.Destroying:Wait()
        if p12._playing_hash ~= v13 then
            return
        end
        if p12._last_rig then
            p12._last_rig:Destroy()
            p12._last_rig = nil
        end
        if p12._last_emote then
            p12._last_emote:Destroy()
            p12._last_emote = nil
        end
    end
end
function v_u_6._Init(_) end
return v_u_6