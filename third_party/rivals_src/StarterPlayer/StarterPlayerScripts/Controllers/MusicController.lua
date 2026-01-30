local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("SoundService")
local v3 = game:GetService("Players")
local v4 = require(v1.Modules.EventLibrary)
local v_u_5 = require(v1.Modules.Utility)
local v_u_6 = require(v3.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController"))
local v_u_7 = require(v3.LocalPlayer.PlayerScripts.Controllers:WaitForChild("SpectateController"))
local v_u_8 = require(v3.LocalPlayer.PlayerScripts.Controllers:WaitForChild("FighterController"))
local v_u_9 = require(v3.LocalPlayer.PlayerScripts.Modules:WaitForChild("UserInterface"):WaitForChild("Equipment"))
local v_u_10 = v4.IS_ACTIVE and (v4.EVENT_DETAILS.LOBBY_MUSIC or "Default") or "Default"
local v_u_11 = v4.IS_ACTIVE and v4.EVENT_DETAILS.LOBBY_MUSIC_MUFFLED or "DefaultMuffled"
local v_u_12 = {
    [""] = { "", 1 },
    ["Default"] = { "rbxassetid://17697682466", 1 },
    ["DefaultMuffled"] = { "rbxassetid://17733314783", 1 },
    ["Spooky"] = { "rbxassetid://100081814360953", 1 },
    ["SpookyMuffled"] = { "rbxassetid://86062306109271", 0.5 },
    ["Festive"] = { "rbxassetid://82135261819112", 1 },
    ["FestiveMuffled"] = { "rbxassetid://96771526359691", 1 },
    ["Obby"] = { "rbxassetid://91718252417630", 1 },
    ["ZombieTower"] = { "rbxassetid://119694504935889", 1 }
}
local v_u_13 = {}
v_u_13.__index = v_u_13
function v_u_13._new()
    local v14 = v_u_13
    local v15 = setmetatable({}, v14)
    v15.LocalFighter = nil
    v15._volume = 0.5
    v15._sound_name = ""
    v15._sound_info = v_u_12.
    v15._is_tweening = false
    v15._sound = Instance.new("Sound")
    v15._next_sound = Instance.new("Sound")
    v15._volume_multiplier = 1
    v15._duel_subject_connections = {}
    v15:_Init()
    return v15
end
function v_u_13.SetSoundID(p16, p17, p18)
    local v19 = not p17 or v_u_12[p17]
    assert(v19, "Argument 1 invalid, expected a string or nil")
    local v20 = not p18 or typeof(p18) == "number"
    assert(v20, "Argument 2 invalid, expected a number or nil")
    if p17 ~= p16._sound_name then
        p16._sound_name = p17 or ""
        p16._sound_info = v_u_12[p16._sound_name]
        p16._volume_multiplier = p18 or 1
        task.spawn(p16._TweenSoundID, p16)
    end
end
function v_u_13.SetVolume(p21, p22)
    local v23 = typeof(p22) == "number"
    assert(v23, "Argument 1 invalid, expected a number")
    p21._volume = p22
    p21:_UpdateVolume()
end
function v_u_13._UpdateSoundGroups(_, p24, p25)
    v_u_2.Other.Volume = p24 == "Settings Master Volume" and p25 and p25 or v_u_6:Get("Settings Master Volume")
    v_u_2.Music.Volume = p24 == "Settings Music Volume" and p25 and p25 or v_u_6:Get("Settings Music Volume")
end
function v_u_13._GetVolume(p26)
    local v27 = p26._sound_info[2]
    local v28 = v_u_7.CurrentSubject and v_u_7.CurrentSubject.Entity
    if v28 then
        v28 = v_u_7.CurrentSubject.Entity:GetCurrentEmote()
    end
    local v29 = v28 and v28.Info.IsAudioIntrusive and 0 or 1
    return v27 * p26._volume_multiplier * p26._volume * v29
end
function v_u_13._TweenSoundID(p_u_30)
    if not p_u_30._is_tweening then
        p_u_30._is_tweening = true
        while p_u_30._sound.SoundId ~= p_u_30._sound_info[1] do
            local v31 = (p_u_30._sound_name == "" or p_u_30._sound.SoundId == "") and 0.25 or 2
            p_u_30._next_sound.SoundId = p_u_30._sound_info[1]
            if p_u_30._sound_name ~= "" then
                p_u_30._next_sound:Play()
                p_u_30._next_sound.TimePosition = p_u_30._sound.TimePosition
            end
            local v_u_32 = p_u_30._sound.Volume
            v_u_5:RenderstepForLoop(0, 100, v31, function(p33)
                local v34 = p33 / 100
                p_u_30._sound.Volume = (1 - v34) * v_u_32
                p_u_30._next_sound.Volume = v34 * p_u_30:_GetVolume()
            end)
            p_u_30._sound:Stop()
            local v35 = p_u_30._next_sound
            p_u_30._next_sound = p_u_30._sound
            p_u_30._sound = v35
        end
        p_u_30._is_tweening = false
    end
end
function v_u_13._UpdateVolume(p36)
    if not p36._is_tweening then
        p36._sound.Volume = p36:_GetVolume()
    end
end
function v_u_13._UpdateSoundID(p37)
    p37:SetSoundID((v_u_9.IsOpen or v_u_7.CurrentDuelSubject and v_u_7.CurrentDuelSubject:Get("Status") == "GameOver") and v_u_11 or (not v_u_7.CurrentDuelSubject and (p37.LocalFighter and not p37.LocalFighter:Get("IsInShootingRange")) and true or false) and v_u_10 or (v_u_7.CurrentDuelSubject and v_u_7.CurrentDuelSubject:Get("DuelMusic") or nil))
end
function v_u_13._DuelSubjectChanged(p_u_38)
    p_u_38:_UpdateSoundID()
    if v_u_7.CurrentDuelSubject then
        local v39 = p_u_38._duel_subject_connections
        local v40 = v_u_7.CurrentDuelSubject:GetDataChangedSignal("DuelMusic")
        table.insert(v39, v40:Connect(function()
            p_u_38:_UpdateSoundID()
        end))
    end
end
function v_u_13._HookLocalFighter(p_u_41)
    p_u_41.LocalFighter = v_u_8:WaitForLocalFighter()
    p_u_41.LocalFighter:GetDataChangedSignal("IsInShootingRange"):Connect(function()
        p_u_41:_UpdateSoundID()
    end)
    p_u_41.LocalFighter:GetDataChangedSignal("IsInDuel"):Connect(function()
        p_u_41:_UpdateSoundID()
    end)
    p_u_41:_UpdateSoundID()
end
function v_u_13._Setup(p42)
    p42._sound.Name = "Music"
    p42._sound.Looped = true
    p42._sound.SoundGroup = v_u_2.Music
    p42._sound.Parent = script
    p42._next_sound.Name = "NextMusic"
    p42._next_sound.Looped = true
    p42._next_sound.SoundGroup = v_u_2.Music
    p42._next_sound.Parent = script
end
function v_u_13._Init(p_u_43)
    v_u_7.DuelSubjectChanged:Connect(function()
        p_u_43:_DuelSubjectChanged()
    end)
    v_u_7.DuelSubjectStatusChanged:Connect(function()
        p_u_43:_UpdateSoundID()
    end)
    v_u_7.SubjectEmoteStatusChanged:Connect(function()
        p_u_43:_UpdateVolume()
    end)
    v_u_9.Opened:Connect(function()
        p_u_43:_UpdateSoundID()
    end)
    v_u_6:GetDataChangedSignal("Settings Master Volume"):Connect(function()
        p_u_43:_UpdateSoundGroups()
    end)
    v_u_6:GetDataChangedSignal("Settings Music Volume"):Connect(function()
        p_u_43:_UpdateSoundGroups()
    end)
    v_u_6.SettingsSliderChanged:Connect(function(p44, p45)
        if p44 == "Settings Master Volume" or p44 == "Settings Music Volume" then
            p_u_43:_UpdateSoundGroups(p44, p45)
        end
    end)
    p_u_43:_Setup()
    p_u_43:_UpdateVolume()
    p_u_43:_DuelSubjectChanged()
    task.spawn(p_u_43._HookLocalFighter, p_u_43)
    task.defer(p_u_43._UpdateSoundGroups, p_u_43)
end
return v_u_13._new()