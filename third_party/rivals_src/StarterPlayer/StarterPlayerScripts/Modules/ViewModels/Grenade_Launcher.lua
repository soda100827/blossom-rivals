local v1 = game:GetService("Players")
local v_u_2 = require(v1.LocalPlayer.PlayerScripts.Modules:WaitForChild("ClientReplicatedClasses"):WaitForChild("ClientFighter"):WaitForChild("ClientItem"):WaitForChild("ClientViewModel"))
local v_u_3 = setmetatable({}, v_u_2)
v_u_3.__index = v_u_3
function v_u_3.new(...)
    local v4 = v_u_2.new(...)
    local v5 = v_u_3
    local v6 = setmetatable(v4, v5)
    v6.ReloadBulletsModel = v6.ItemModel:WaitForChild("ReloadBullets")
    v6.BulletsModel = v6.ItemModel:WaitForChild("Bullets")
    v6._bullet_parts = {}
    v6:_Init()
    return v6
end
function v_u_3._UpdateAmmoVisual(p7)
    if not p7._destroyed then
        local v8 = p7.ClientItem:Get("AmmoReserve")
        local v9 = p7.ClientItem:Get("Ammo")
        for v10, v11 in pairs(p7._bullet_parts.BulletsModel) do
            for _, v12 in pairs(v11:GetChildren()) do
                p7:_LocalTransparencyModifier(v12, "AmmoVisual", v10 <= v9 and 0 or 1)
            end
        end
        for v13, v14 in pairs(p7._bullet_parts.ReloadBulletsModel) do
            for _, v15 in pairs(v14:GetChildren()) do
                p7:_LocalTransparencyModifier(v15, "AmmoVisual", v13 <= v8 and 0 or 1)
            end
        end
    end
end
function v_u_3._Setup(p16)
    for _, v17 in pairs({ "ReloadBulletsModel", "BulletsModel" }) do
        p16._bullet_parts[v17] = {}
        for v18 = 1, 6 do
            p16._bullet_parts[v17][v18] = p16[v17]:WaitForChild(v18)
        end
    end
end
function v_u_3._Init(p_u_19)
    p_u_19.ClientItem:GetDataChangedSignal("AmmoReserve"):Connect(function()
        p_u_19:_UpdateAmmoVisual()
    end)
    p_u_19.ClientItem:GetDataChangedSignal("Ammo"):Connect(function()
        p_u_19:_UpdateAmmoVisual()
    end)
    p_u_19:_Setup()
    task.spawn(p_u_19._UpdateAmmoVisual, p_u_19)
end
return v_u_3