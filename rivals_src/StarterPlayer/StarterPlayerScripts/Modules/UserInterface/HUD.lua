local v_u_1 = game:GetService("GuiService")
local v_u_2 = game:GetService("Players")
local v_u_3 = require(v_u_2.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController"))
local v_u_4 = require(v_u_2.LocalPlayer.PlayerScripts.Controllers:WaitForChild("SpectateController"))
local v_u_5 = require(v_u_2.LocalPlayer.PlayerScripts.Controllers:WaitForChild("ControlsController"))
local v_u_6 = require(v_u_2.LocalPlayer.PlayerScripts.Controllers:WaitForChild("FighterController"))
local v_u_7 = require(v_u_2.LocalPlayer.PlayerScripts.Modules:WaitForChild("UserInterface"):WaitForChild("Pages"))
local v_u_8 = require(v_u_2.LocalPlayer.PlayerScripts.Modules:WaitForChild("UILibrary"))
local v_u_9 = {}
v_u_9.__index = v_u_9
function v_u_9._new()
    local v10 = v_u_9
    local v11 = setmetatable({}, v10)
    v11.MainFrame = v_u_8:GetTo("MainFrame")
    v11:_Init()
    return v11
end
function v_u_9._UpdateSize(p12)
    local v13 = v_u_3:Get("Settings Padded HUD")
    local v14 = not v_u_7.PageSystem.CurrentPage
    if v14 then
        if v13 == "Always On" then
            v14 = true
        elseif v13 == "Using Controller" then
            v14 = v_u_5.CurrentControls == "Gamepad"
        else
            v14 = false
        end
    end
    local v15 = v14 and UDim2.new(0.9, 0, 0.9, 0) or UDim2.new(1, 0, 1, 0)
    if p12.MainFrame:IsDescendantOf(v_u_2) then
        p12.MainFrame:TweenSize(v15, "Out", "Quint", 0.25, true)
    else
        p12.MainFrame.Size = v15
    end
end
function v_u_9._Update(p16)
    local v17 = not (v_u_6.LocalFighter and v_u_6.LocalFighter:Get("IsHiddenByCutscene"))
    if v17 then
        v17 = not v_u_3:Get("Settings Hide HUD")
    end
    local v18 = v_u_4.CurrentDuelSubject
    if v18 then
        v18 = v_u_4.CurrentDuelSubject:Get("Status") == "Voting"
    end
    local v19 = not v_u_1.MenuIsOpen
    p16.MainFrame.BottomStack.Visible = v17
    p16.MainFrame.Notifications.Visible = v17
    local v20 = p16.MainFrame.DuelInterfaces
    if v17 or v18 then
        v18 = v19
    end
    v20.Visible = v18
    p16.MainFrame.EliminatedEffect.Visible = v17
    p16.MainFrame.FighterInterfaces.Visible = v17 and v19
    p16.MainFrame.ShootingRange.Visible = v17 and v19
    p16.MainFrame.Lobby.Visible = v17
end
function v_u_9._HookLocalFighter(p_u_21)
    v_u_6:WaitForLocalFighter():GetDataChangedSignal("IsHiddenByCutscene"):Connect(function()
        p_u_21:_Update()
    end)
    task.defer(p_u_21._Update, p_u_21)
end
function v_u_9._Init(p_u_22)
    v_u_3:GetDataChangedSignal("Settings Hide HUD"):Connect(function()
        p_u_22:_Update()
    end)
    v_u_3:GetDataChangedSignal("Settings Padded HUD"):Connect(function()
        p_u_22:_UpdateSize()
    end)
    v_u_4.DuelSubjectChanged:Connect(function()
        p_u_22:_Update()
    end)
    v_u_4.DuelSubjectStatusChanged:Connect(function()
        p_u_22:_Update()
    end)
    v_u_5.ControlsChanged:Connect(function()
        p_u_22:_UpdateSize()
    end)
    v_u_7.PageSystem.PagesActivity:Connect(function()
        p_u_22:_UpdateSize()
    end)
    v_u_1:GetPropertyChangedSignal("MenuIsOpen"):Connect(function()
        p_u_22:_Update()
    end)
    p_u_22:_Update()
    p_u_22:_UpdateSize()
    task.defer(p_u_22._HookLocalFighter, p_u_22)
end
return v_u_9._new()