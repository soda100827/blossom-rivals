local v1 = game:GetService("Players")
local v_u_2 = require(v1.LocalPlayer.PlayerScripts.Modules:WaitForChild("ClientReplicatedClasses"):WaitForChild("ClientFighter"):WaitForChild("ClientItem"):WaitForChild("ClientViewModel"))
local v_u_3 = setmetatable({}, v_u_2)
v_u_3.__index = v_u_3
function v_u_3.new(...)
    local v4 = v_u_2.new(...)
    local v5 = v_u_3
    local v6 = setmetatable(v4, v5)
    v6._registered_ammo_visuals = {}
    v6._visibility_delayed = nil
    v6:_Init()
    return v6
end
function v_u_3._UpdateAmmoVisual(p7)
    if p7._destroyed then
        return
    else
        local v8 = p7.ClientItem:Get("Ammo") > 0 and true or p7:IsAnimationPlaying("Reload")
        if v8 and not p7._visibility_delayed then
            p7._visibility_delayed = true
            wait(0.1)
            p7:_UpdateAmmoVisual()
        else
            p7._visibility_delayed = nil
            for v9 in pairs(p7._registered_ammo_visuals) do
                p7:_LocalTransparencyModifier(v9, "AmmoVisual", v8 and 0 or 1)
            end
        end
    end
end
function v_u_3._RegisterAmmoVisual(p10, p11)
    p10._registered_ammo_visuals[p11] = true
end
function v_u_3._Init(p_u_12)
    p_u_12.ClientItem:GetDataChangedSignal("Ammo"):Connect(function()
        p_u_12:_UpdateAmmoVisual()
    end)
    p_u_12.AnimationPlayed:Connect(function()
        p_u_12:_UpdateAmmoVisual()
    end)
    p_u_12.AnimationStopped:Connect(function()
        p_u_12:_UpdateAmmoVisual()
    end)
    task.spawn(p_u_12._UpdateAmmoVisual, p_u_12)
end
return v_u_3