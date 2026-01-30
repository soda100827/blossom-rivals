local v1 = game:GetService("Players")
local v_u_2 = require(v1.LocalPlayer.PlayerScripts.Modules.ViewModels.BaseRevolver)
local v_u_3 = setmetatable({}, v_u_2)
v_u_3.__index = v_u_3
function v_u_3.new(...)
    local v4 = v_u_2.new(...)
    local v5 = v_u_3
    local v6 = setmetatable(v4, v5)
    v6:_Init()
    return v6
end
function v_u_3._Setup(p7)
    for _, v8 in pairs({ "ReloadBullets", "Bullets" }) do
        local v9 = p7.ItemModel:WaitForChild(v8)
        for v10 = 1, 6 do
            local v11 = v9:WaitForChild(v10)
            p7:_RegisterAmmoVisual(v8, v11:WaitForChild("Red"))
            p7:_RegisterAmmoVisual(v8, v11:WaitForChild("White"))
        end
    end
end
function v_u_3._Init(p12)
    p12:_Setup()
end
return v_u_3