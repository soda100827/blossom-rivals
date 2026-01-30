local v1 = game:GetService("Players")
local v_u_2 = require(v1.LocalPlayer.PlayerScripts.Modules:WaitForChild("ClientReplicatedClasses"):WaitForChild("ClientFighter"):WaitForChild("ClientItem"):WaitForChild("ClientViewModel"))
local v_u_3 = setmetatable({}, v_u_2)
v_u_3.__index = v_u_3
function v_u_3.new(...)
    local v4 = v_u_2.new(...)
    local v5 = v_u_3
    local v6 = setmetatable(v4, v5)
    v6._hide_this_mesh = v6.ItemModel:WaitForChild("Body"):WaitForChild("MeshPart")
    v6:_Init()
    return v6
end
function v_u_3._UpdateAmmoVisual(p7)
    if not p7._destroyed then
        local v8 = p7.ClientItem:Get("Ammo") > 0
        p7._hide_this_mesh.Material = v8 and Enum.Material.Glass or Enum.Material.SmoothPlastic
        p7:_LocalTransparencyModifier(p7._hide_this_mesh, "AmmoVisual", v8 and 0 or 1)
    end
end
function v_u_3._Init(p_u_9)
    p_u_9.ClientItem:GetDataChangedSignal("Ammo"):Connect(function()
        p_u_9:_UpdateAmmoVisual()
    end)
    task.spawn(p_u_9._UpdateAmmoVisual, p_u_9)
end
return v_u_3