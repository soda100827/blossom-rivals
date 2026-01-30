local v1 = game:GetService("Players")
local v_u_2 = require(v1.LocalPlayer.PlayerScripts.Modules.ViewModels["Flare Gun"])
local v_u_3 = setmetatable({}, v_u_2)
v_u_3.__index = v_u_3
function v_u_3.new(...)
    local v4 = v_u_2.new(...)
    local v5 = v_u_3
    local v6 = setmetatable(v4, v5)
    v6:_Init()
    return v6
end
function v_u_3._UpdateViewModelAnimations(p7)
    p7.Animator:ChangeRareInspectAnimation(p7.ClientItem:Get("Ammo") > 0 and "RareInspect" or "nil")
end
function v_u_3._Init(p_u_8)
    local v9 = p_u_8._connections
    local v10 = p_u_8.ClientItem:GetDataChangedSignal("Ammo")
    table.insert(v9, v10:Connect(function()
        p_u_8:_UpdateViewModelAnimations()
    end))
    task.defer(p_u_8._UpdateViewModelAnimations, p_u_8)
end
return v_u_3