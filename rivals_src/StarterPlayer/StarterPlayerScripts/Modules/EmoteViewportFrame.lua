local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.CosmeticLibrary)
local v_u_4 = require(v1.Modules.Utility)
local v_u_5 = require(v2.LocalPlayer.PlayerScripts.Modules.ViewportCameras)
local v_u_6 = v2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("EmoteViewportFrame")
local v_u_7 = v2.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild("EmoteDummy")
local v_u_8 = v1.Modules.Emotes
local v_u_9 = {}
v_u_9.__index = v_u_9
function v_u_9.new(p10, p11)
    local v12 = v_u_3.Cosmetics[p10].Type == "Emote"
    assert(v12)
    local v13 = v_u_9
    local v14 = setmetatable({}, v13)
    v14.Name = p10
    v14.Frame = v_u_6:Clone()
    v14.EmoteGlow = v14.Frame.EmoteGlow
    v14._destroyed = false
    v14._world_model = v14.Frame.WorldModel
    v14._playing_emotes_hash = 0
    v14._dummy = nil
    v14._fade_speed = v14.Name == "MISSING_EMOTE" and (1 / 0) or (p11 or 1)
    v14._is_locked = false
    v14:_Init()
    return v14
end
function v_u_9.SetParent(p15, p16)
    p15.Frame.Parent = p16
    p15.EmoteGlow.Parent = p16
end
function v_u_9.SetLocked(p17, p18)
    p17._is_locked = p18
    p17.Frame.ImageColor3 = p17._is_locked and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
    p17.Frame.ImageTransparency = p17:_GetImageTransparency()
end
function v_u_9.HideShadow(p19)
    p19.EmoteGlow.Visible = false
end
function v_u_9.Destroy(p20)
    p20._destroyed = true
    p20._playing_emotes_hash = p20._playing_emotes_hash + 1
    p20.Frame:Destroy()
    p20:_Clear()
end
function v_u_9._GetImageTransparency(p21)
    return p21._is_locked and 0.5 or 0
end
function v_u_9._Clear(p22)
    if p22._dummy then
        p22._dummy:Destroy()
        p22._dummy = nil
    end
    if p22._last_emote then
        p22._last_emote:Destroy()
        p22._last_emote = nil
    end
end
function v_u_9._PlayEmote(p_u_23)
    if not p_u_23._destroyed then
        p_u_23._playing_emotes_hash = p_u_23._playing_emotes_hash + 1
        local v_u_24 = p_u_23._playing_emotes_hash
        p_u_23:_Clear()
        while true do
            local v25 = tick()
            p_u_23._dummy = v_u_7:Clone()
            p_u_23._dummy:PivotTo(v_u_3.Cosmetics[p_u_23.Name].ViewportCFrameOffset)
            p_u_23._dummy.Parent = p_u_23._world_model
            v_u_4:RenderstepForLoop(0, 100, 4 * p_u_23._fade_speed, function(p26)
                if p_u_23._playing_emotes_hash ~= v_u_24 then
                    return true
                end
                local v27 = (p26 / 100) ^ 3
                p_u_23.Frame.ImageTransparency = 1 + (p_u_23:_GetImageTransparency() - 1) * v27
                p_u_23.EmoteGlow.ImageTransparency = 1 + -0.5 * v27
            end)
            if p_u_23._playing_emotes_hash ~= v_u_24 then
                break
            end
            if p_u_23._dummy:FindFirstChild("Humanoid") then
                p_u_23._last_emote = require(v_u_8[p_u_23.Name]).new(p_u_23._dummy.Humanoid)
                task.defer(p_u_23._last_emote.Simulate, p_u_23._last_emote)
                p_u_23._last_emote.Destroying:Wait()
            end
            v_u_4:RenderstepForLoop(0, 100, 4 * p_u_23._fade_speed, function(p28)
                if p_u_23._playing_emotes_hash ~= v_u_24 then
                    return true
                end
                local v29 = 1 - (1 - p28 / 100) ^ 3
                p_u_23.Frame.ImageTransparency = p_u_23:_GetImageTransparency() + (1 - p_u_23:_GetImageTransparency()) * v29
                p_u_23.EmoteGlow.ImageTransparency = 0.5 + 0.5 * v29
            end)
            if p_u_23._playing_emotes_hash ~= v_u_24 then
                return
            end
            p_u_23:_Clear()
            wait(1 - (tick() - v25))
            if p_u_23._playing_emotes_hash ~= v_u_24 then
                return
            end
        end
    end
end
function v_u_9._Setup(p30)
    p30.Frame.CurrentCamera = v_u_5.Emote
end
function v_u_9._Init(p_u_31)
    p_u_31.Frame.AncestryChanged:Connect(function()
        p_u_31:_PlayEmote()
    end)
    p_u_31:_Setup()
    task.spawn(p_u_31._PlayEmote, p_u_31)
end
return v_u_9