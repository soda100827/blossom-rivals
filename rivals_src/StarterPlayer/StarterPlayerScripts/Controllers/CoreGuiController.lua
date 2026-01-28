local v_u_1 = game:GetService("GuiService")
local v_u_2 = game:GetService("StarterGui")
local v_u_3 = game:GetService("Players")
local v_u_4 = require(v_u_3.LocalPlayer.PlayerScripts.Controllers.ControlsController)
local v_u_5 = require(v_u_3.LocalPlayer.PlayerScripts.Modules:WaitForChild("UserInterface"):WaitForChild("Teleporting"))
local v_u_6 = require(v_u_3.LocalPlayer.PlayerScripts.Modules:WaitForChild("UserInterface"):WaitForChild("PlayerList"))
local v_u_7 = require(v_u_3.LocalPlayer.PlayerScripts.Modules:WaitForChild("UserInterface"):WaitForChild("Equipment"))
local v_u_8 = require(v_u_3.LocalPlayer.PlayerScripts.Modules:WaitForChild("UserInterface"):WaitForChild("Pages"))
local v_u_9 = {}
v_u_9.__index = v_u_9
function v_u_9._new()
    local v10 = v_u_9
    local v11 = setmetatable({}, v10)
    v11.LocalFighter = nil
    v11._my_leaderstats_folder = nil
    v11:_Init()
    return v11
end
function v_u_9._UpdatePlayerList(p12)
    local v13
    if v_u_1.ViewportDisplaySize == Enum.DisplaySize.Small then
        v13 = true
    elseif v_u_1.ViewportDisplaySize == Enum.DisplaySize.Large then
        v13 = v_u_4.CurrentControls == "Controller"
    else
        v13 = false
    end
    local v14 = v13 and v_u_6:GetBaseVisibility()
    if v14 then
        v14 = v_u_4.CurrentControls ~= "Controller"
    end
    v_u_6:SetDisabled(v13)
    v_u_2:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, v14 or false)
    local _ = p12._my_leaderstats_folder
end
function v_u_9._UpdateTouchControls(_)
    local v15 = v_u_1
    local v16 = not v_u_7.IsOpen
    if v16 then
        v16 = not v_u_8.PageSystem.CurrentPage
    end
    v15.TouchControlsEnabled = v16
end
function v_u_9._UpdateChat(_)
    local v17 = not v_u_5.Enabled
    v_u_2:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, v17 or false)
end
function v_u_9._UpdateLoop(p18)
    while true do
        pcall(v_u_2.SetCoreGuiEnabled, v_u_2, Enum.CoreGuiType.EmotesMenu, false)
        pcall(v_u_2.SetCoreGuiEnabled, v_u_2, Enum.CoreGuiType.Health, false)
        task.defer(p18._UpdatePlayerList, p18)
        task.defer(p18._UpdateChat, p18)
        wait(1)
    end
end
function v_u_9._HookLeaderstats(p19)
    p19._my_leaderstats_folder = v_u_3.LocalPlayer:WaitForChild("leaderstats")
    task.defer(p19._UpdatePlayerList, p19)
end
function v_u_9._Init(p_u_20)
    v_u_5.EnabledChanged:Connect(function()
        p_u_20:_UpdateChat()
    end)
    v_u_6.BaseVisibilityChanged:Connect(function()
        p_u_20:_UpdatePlayerList()
    end)
    v_u_1:GetPropertyChangedSignal("ViewportDisplaySize"):Connect(function()
        p_u_20:_UpdatePlayerList()
    end)
    v_u_4.ControlsChanged:Connect(function()
        p_u_20:_UpdatePlayerList()
    end)
    v_u_7.Opened:Connect(function()
        p_u_20:_UpdateTouchControls()
    end)
    v_u_8.PageSystem.PagesActivity:Connect(function()
        p_u_20:_UpdateTouchControls()
    end)
    task.defer(p_u_20._HookLeaderstats, p_u_20)
    task.defer(p_u_20._UpdateLoop, p_u_20)
    task.defer(p_u_20._UpdateChat, p_u_20)
    task.defer(p_u_20._UpdatePlayerList, p_u_20)
    task.defer(p_u_20._UpdateTouchControls, p_u_20)
end
return v_u_9._new()