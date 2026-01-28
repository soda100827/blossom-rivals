local v1 = game:GetService("Players")
local v_u_2 = require(v1.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Pages"))
local v_u_3 = require(v1.LocalPlayer.PlayerScripts.Modules:WaitForChild("UILibrary"))
local v_u_4 = {}
v_u_4.__index = v_u_4
function v_u_4._new()
    local v5 = v_u_4
    local v6 = setmetatable({}, v5)
    v6.Frame = v_u_3:GetTo("MainFrame", "JoystickModal")
    v6:_Init()
    return v6
end
function v_u_4._Update(p7)
    p7.Frame.Visible = v_u_2.PageSystem.CurrentPage ~= nil
end
function v_u_4._Init(p_u_8)
    v_u_2.PageSystem.PagesActivity:Connect(function()
        p_u_8:_Update()
    end)
    p_u_8:_Update()
end
return v_u_4._new()