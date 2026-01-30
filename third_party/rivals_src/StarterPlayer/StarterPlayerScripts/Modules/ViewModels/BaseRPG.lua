local v1 = game:GetService("Players")
local v_u_2 = require(v1.LocalPlayer.PlayerScripts.Modules:WaitForChild("ClientReplicatedClasses"):WaitForChild("ClientFighter"):WaitForChild("ClientItem"):WaitForChild("ClientViewModel"))
local v_u_3 = setmetatable({}, v_u_2)
v_u_3.__index = v_u_3
function v_u_3.new(...)
    local v4 = v_u_2.new(...)
    local v5 = v_u_3
    local v6 = setmetatable(v4, v5)
    v6._visibility_delayed = nil
    v6._registered_ammo_visuals = {}
    v6:_Init()
    return v6
end
function v_u_3._UpdateRocket(p7)
    if p7._destroyed then
        return
    else
        local v8 = p7.ClientItem:Get("Ammo") > 0 and true or p7:IsAnimationPlaying("Reload")
        if v8 and not p7._visibility_delayed then
            p7._visibility_delayed = true
            wait(0.1)
            p7:_UpdateRocket()
        else
            local v9 = v8 and 0 or 1
            for _, v10 in pairs(p7._registered_ammo_visuals) do
                p7:_LocalTransparencyModifier(v10, "AmmoVisual", v9)
            end
            p7._visibility_delayed = nil
        end
    end
end
function v_u_3._RegisterAmmoVisual(p11, p12)
    local v13 = p11._registered_ammo_visuals
    table.insert(v13, p12)
end
function v_u_3._Init(p_u_14)
    p_u_14.ClientItem:GetDataChangedSignal("Ammo"):Connect(function()
        p_u_14:_UpdateRocket()
    end)
    p_u_14.AnimationPlayed:Connect(function(p15)
        if p15 == "Reload" then
            p_u_14:_UpdateRocket()
        end
    end)
    p_u_14.AnimationStopped:Connect(function(p16)
        if p16 == "Reload" then
            p_u_14:_UpdateRocket()
        end
    end)
    task.spawn(p_u_14._UpdateRocket, p_u_14)
end
return v_u_3