local v1 = game:GetService("Players")
local v_u_2 = require(v1.LocalPlayer.PlayerScripts.Modules:WaitForChild("ClientReplicatedClasses"):WaitForChild("ClientFighter"):WaitForChild("ClientItem"):WaitForChild("ClientViewModel"))
local v_u_3 = setmetatable({}, v_u_2)
v_u_3.__index = v_u_3
function v_u_3.new(...)
    local v4 = v_u_2.new(...)
    local v5 = v_u_3
    local v6 = setmetatable(v4, v5)
    v6._registered_ammo_visuals = {
        ["Bullets"] = {},
        ["ReloadBullets"] = {}
    }
    v6:_Init()
    return v6
end
function v_u_3._UpdateAmmoVisual(p7)
    if not p7._destroyed then
        local v8 = p7:IsAnimationPlaying("Reload") or p7:IsAnimationPlaying("EmptyReload")
        local v9 = p7.ClientItem:Get("AmmoReserve")
        local v10 = p7.ClientItem:Get("Ammo")
        local v11 = v9 + v10
        for v12, v13 in pairs(p7._registered_ammo_visuals.Bullets) do
            local v14 = "AmmoVisual"
            local v15
            if v8 then
                v15 = v12 <= v11 and 0 or 1
            else
                v15 = v12 <= v10 and 0 or 1
            end
            p7:_LocalTransparencyModifier(v13, v14, v15)
        end
        for v16, v17 in pairs(p7._registered_ammo_visuals.ReloadBullets) do
            p7:_LocalTransparencyModifier(v17, "AmmoVisual", v16 <= v10 and 0 or 1)
        end
    end
end
function v_u_3._RegisterAmmoVisual(p18, p19, p20)
    local v21 = p18._registered_ammo_visuals[p19]
    table.insert(v21, p20)
end
function v_u_3._RegisterDefaultAmmoVisuals(p22)
    for _, v23 in pairs({ "ReloadBullets", "Bullets" }) do
        local v24 = p22.ItemModel:WaitForChild(v23)
        for v25 = 1, 6 do
            p22:_RegisterAmmoVisual(v23, v24:WaitForChild(v25))
        end
    end
end
function v_u_3._Init(p_u_26)
    p_u_26.ClientItem:GetDataChangedSignal("AmmoReserve"):Connect(function()
        p_u_26:_UpdateAmmoVisual()
    end)
    p_u_26.ClientItem:GetDataChangedSignal("Ammo"):Connect(function()
        p_u_26:_UpdateAmmoVisual()
    end)
    p_u_26.AnimationPlayed:Connect(function(p27)
        if p27 == "Reload" or p27 == "EmptyReload" then
            p_u_26:_UpdateAmmoVisual()
        end
    end)
    p_u_26.AnimationStopped:Connect(function(p28)
        if p28 == "Reload" or p28 == "EmptyReload" then
            p_u_26:_UpdateAmmoVisual()
        end
    end)
    task.defer(p_u_26._UpdateAmmoVisual, p_u_26)
end
return v_u_3