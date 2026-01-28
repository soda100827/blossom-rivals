local v1 = game:GetService("Players")
local v_u_2 = require(v1.LocalPlayer.PlayerScripts.Modules.ItemTypes.Gun)
local v_u_3 = setmetatable({}, v_u_2)
v_u_3.__index = v_u_3
function v_u_3.new(...)
    local v4 = v_u_2.new(...)
    local v5 = v_u_3
    local v6 = setmetatable(v4, v5)
    v6.ToggleAimEnabled = nil
    v6:_Init()
    return v6
end
function v_u_3.StartAiming(_)
    return false
end
function v_u_3.FinishAiming(_)
    return false
end
function v_u_3.ReplicateFromServer(p7, p8, ...)
    if p8 == "TransformProjectile" then
        if p7:IsRendered() then
            local v9 = ...
            p7.ViewModel:TransformProjectile(v9, p7._projectile_part_to_model[v9])
        end
    elseif p8 == "MiniExplosionEffect" then
        if p7:IsRendered() then
            local v10 = ...
            v10:Destroy()
            p7.ViewModel:PlayCastParticles(v10.Position, 2)
        end
    else
        v_u_2.ReplicateFromServer(p7, p8, ...)
        return
    end
end
function v_u_3._Init(_) end
return v_u_3