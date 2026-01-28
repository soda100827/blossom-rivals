local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.InputLibrary)
local v_u_4 = require(v2.LocalPlayer.PlayerScripts.Controllers:WaitForChild("ShootingRangeController"))
local v_u_5 = require(v2.LocalPlayer.PlayerScripts.Controllers:WaitForChild("ControlsController"))
local v_u_6 = require(v2.LocalPlayer.PlayerScripts.Controllers:WaitForChild("FighterController"))
local v_u_7 = require(v2.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Pages"))
local v_u_8 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect"))
local v_u_9 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("UILibrary"))
local v_u_10 = {}
v_u_10.__index = v_u_10
function v_u_10._new()
    local v11 = v_u_10
    local v12 = setmetatable({}, v11)
    v12.Frame = v_u_9:GetTo("MainFrame", "ShootingRange")
    v12._connection = nil
    v12:_Init()
    return v12
end
function v_u_10._Update(p13)
    if p13._connection then
        p13._connection:Disconnect()
        p13._connection = nil
    end
    local v14 = p13.Frame.Container
    local v15 = p13.LocalFighter and p13.LocalFighter:Get("IsInShootingRange")
    if v15 then
        v15 = not v_u_7.PageSystem.CurrentPage
    end
    v14.Visible = v15
    if p13.Frame.Container.Visible then
        p13._connection = v_u_5.InputBegan:Connect(function(p16, p17)
            if not p17 then
                if v_u_3:InputIs(p16, "LeaveDuel") then
                    v_u_4:Leave()
                end
            end
        end)
    end
end
function v_u_10._HookLocalFighter(p_u_18)
    p_u_18.LocalFighter = v_u_6:WaitForLocalFighter()
    p_u_18.LocalFighter:GetDataChangedSignal("IsInShootingRange"):Connect(function()
        p_u_18:_Update()
    end)
    p_u_18:_Update()
end
function v_u_10._Init(p_u_19)
    p_u_19.Frame.Container.Button.MouseButton1Click:Connect(function()
        v_u_4:Leave()
    end)
    v_u_7.PageSystem.PageOpened:Connect(function()
        p_u_19:_Update()
    end)
    v_u_7.PageSystem.PageClosed:Connect(function()
        p_u_19:_Update()
    end)
    p_u_19:_Update()
    task.spawn(p_u_19._HookLocalFighter, p_u_19)
    v_u_8:Add(p_u_19.Frame.Container.Button)
end
return v_u_10._new()