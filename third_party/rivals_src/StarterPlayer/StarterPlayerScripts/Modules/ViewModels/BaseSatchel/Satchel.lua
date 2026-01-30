local v1 = game:GetService("Players")
local v_u_2 = require(v1.LocalPlayer.PlayerScripts.Modules.ViewModels.BaseSatchel)
local v_u_3 = setmetatable({}, v_u_2)
v_u_3.__index = v_u_3
function v_u_3.new(...)
    local v4 = v_u_2.new(...)
    local v5 = v_u_3
    local v6 = setmetatable(v4, v5)
    v6:_Init()
    return v6
end
function v_u_3._Init(p_u_7)
    task.defer(function()
        p_u_7.ClientItem.ProjectileThrown:Connect(function(_, p8)
            p_u_7:_PlayBeepAnimation(p8:WaitForChild("Beep"))
        end)
    end)
    p_u_7:_RegisterBeepPart(p_u_7.ItemModel:WaitForChild("Body"):WaitForChild("Beep"))
end
return v_u_3