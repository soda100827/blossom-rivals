local v1 = game:GetService("Players")
local v_u_2 = require(v1.LocalPlayer.PlayerScripts.Modules:WaitForChild("ClientReplicatedClasses"):WaitForChild("ClientFighter"):WaitForChild("ClientItem"):WaitForChild("ClientViewModel"))
local v_u_3 = setmetatable({}, v_u_2)
v_u_3.__index = v_u_3
function v_u_3.new(...)
    local v4 = v_u_2.new(...)
    local v5 = v_u_3
    local v6 = setmetatable(v4, v5)
    v6._registered_ammo_visuals = {}
    local v7 = v6._charm_pivot_attachment
    if v7 then
        v7 = v6._charm_pivot_attachment.Parent
    end
    v6._charm_attachment_parent = v7
    v6:_Init()
    return v6
end
function v_u_3._UpdateAmmoVisual(p8)
    if not p8._destroyed then
        for v9, v10 in pairs(p8._registered_ammo_visuals) do
            local v11 = v10 <= p8.ClientItem:Get("Ammo") and true or p8:IsAnimationPlaying("Reload")
            p8:_LocalTransparencyModifier(v9, "AmmoVisual", v11 and 0 or 1)
            if v10 == 2 and p8._charm_pivot_attachment then
                local v12 = p8._charm_pivot_attachment
                local v13
                if v11 then
                    v13 = p8._charm_attachment_parent or nil
                else
                    v13 = nil
                end
                v12.Parent = v13
            end
        end
    end
end
function v_u_3._RegisterAmmoVisual(p14, p15, p16)
    p14._registered_ammo_visuals[p15] = p16
end
function v_u_3._Init(p_u_17)
    p_u_17.ClientItem:GetDataChangedSignal("Ammo"):Connect(function()
        p_u_17:_UpdateAmmoVisual()
    end)
    p_u_17.AnimationPlayed:Connect(function()
        p_u_17:_UpdateAmmoVisual()
    end)
    p_u_17.AnimationStopped:Connect(function()
        p_u_17:_UpdateAmmoVisual()
    end)
    task.spawn(p_u_17._UpdateAmmoVisual, p_u_17)
end
return v_u_3