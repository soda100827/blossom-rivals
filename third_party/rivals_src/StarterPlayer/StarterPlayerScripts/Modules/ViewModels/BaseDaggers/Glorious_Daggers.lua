local v1 = game:GetService("Players")
local v_u_2 = require(v1.LocalPlayer.PlayerScripts.Modules.ViewModels.BaseDaggers)
local v_u_3 = setmetatable({}, v_u_2)
v_u_3.__index = v_u_3
function v_u_3.new(...)
    local v4 = v_u_2.new(...)
    local v5 = v_u_3
    local v6 = setmetatable(v4, v5)
    v6:_Init()
    return v6
end
function v_u_3._Init(p7)
    p7:_RegisterAmmoVisual(p7.ItemModel:WaitForChild("LeftBody"):WaitForChild("MeshPart1"), 1)
    p7:_RegisterAmmoVisual(p7.ItemModel:WaitForChild("LeftBody"):WaitForChild("MeshPart2"), 1)
    p7:_RegisterAmmoVisual(p7.ItemModel:WaitForChild("LeftBody"):WaitForChild("MeshPart3"), 1)
    p7:_RegisterAmmoVisual(p7.ItemModel:WaitForChild("LeftBody"):WaitForChild("MeshPart4"), 1)
    p7:_RegisterAmmoVisual(p7.ItemModel:WaitForChild("LeftBody"):WaitForChild("MeshPart5"), 1)
    p7:_RegisterAmmoVisual(p7.ItemModel:WaitForChild("RightBody"):WaitForChild("MeshPart1"), 2)
    p7:_RegisterAmmoVisual(p7.ItemModel:WaitForChild("RightBody"):WaitForChild("MeshPart2"), 2)
    p7:_RegisterAmmoVisual(p7.ItemModel:WaitForChild("RightBody"):WaitForChild("MeshPart3"), 2)
    p7:_RegisterAmmoVisual(p7.ItemModel:WaitForChild("RightBody"):WaitForChild("MeshPart4"), 2)
    p7:_RegisterAmmoVisual(p7.ItemModel:WaitForChild("RightBody"):WaitForChild("MeshPart5"), 2)
end
return v_u_3