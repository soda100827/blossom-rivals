local v1 = game:GetService("Players")
local v_u_2 = require(v1.LocalPlayer.PlayerScripts.Modules.Functions.FlashbangEffect)
local v_u_3 = require(v1.LocalPlayer.PlayerScripts.Modules.ItemTypes.Throwable)
local v_u_4 = setmetatable({}, v_u_3)
v_u_4.__index = v_u_4
function v_u_4.new(...)
    local v5 = v_u_3.new(...)
    local v6 = v_u_4
    local v7 = setmetatable(v5, v6)
    v7._play_flash_sound_callback = nil
    v7._play_ringing_sound_callback = nil
    v7:_Init()
    return v7
end
function v_u_4.ReplicateFromServer(p8, p9, ...)
    if p9 == "BlindEffect" then
        if p8:IsRendered() then
            local v10, v11 = ...
            v_u_2({ v11 }, v10, p8.Info.BlindDuration, p8:Get("ObjectID"), p8.ViewModel.Name, p8._play_flash_sound_callback, p8._play_ringing_sound_callback)
        end
    else
        v_u_3.ReplicateFromServer(p8, p9, ...)
        return
    end
end
function v_u_4._Setup(p_u_12)
    function p_u_12._play_flash_sound_callback(p13)
        return p_u_12.ViewModel:PlayFlashSound(p13)
    end
    function p_u_12._play_ringing_sound_callback(p14)
        return p_u_12.ViewModel:PlayRingingSound(p14)
    end
end
function v_u_4._Init(p15)
    p15:_Setup()
end
return v_u_4