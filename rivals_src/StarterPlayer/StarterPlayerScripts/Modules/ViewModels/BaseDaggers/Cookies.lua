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
    for v8, v9 in pairs({ "LeftBody", "RightBody" }) do
        for v10 = 1, 7 do
            p7:_RegisterAmmoVisual(p7.ItemModel:WaitForChild(v9):WaitForChild("MeshPart" .. v10), v8)
        end
    end
end
return v_u_3