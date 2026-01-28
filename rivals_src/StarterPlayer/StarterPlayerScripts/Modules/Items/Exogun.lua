local v1 = game:GetService("Players")
local v_u_2 = require(v1.LocalPlayer.PlayerScripts.Modules.ItemTypes.Gun)
local v_u_3 = setmetatable({}, v_u_2)
v_u_3.__index = v_u_3
function v_u_3.new(...)
    local v4 = v_u_2.new(...)
    local v5 = v_u_3
    local v6 = setmetatable(v4, v5)
    v6:_Init()
    return v6
end
function v_u_3._Init(p_u_7)
    function p_u_7._on_reload_callback()
        local v_u_8 = p_u_7._reload_hash
        task.delay(0.5, function()
            if v_u_8 == p_u_7._reload_hash then
                p_u_7.ViewModel:PlayReloadParticles()
            end
        end)
    end
end
return v_u_3