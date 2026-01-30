local v1 = game:GetService("Players")
local v_u_2 = require(v1.LocalPlayer.PlayerScripts.Controllers:WaitForChild("FighterController"))
local v_u_3 = require(v1.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Pages"))
local v_u_4 = require(v1.LocalPlayer.PlayerScripts.Modules:WaitForChild("PartyDisplay"))
local v_u_5 = require(v1.LocalPlayer.PlayerScripts.Modules:WaitForChild("UILibrary"))
local v_u_6 = {}
v_u_6.__index = v_u_6
function v_u_6._new()
    local v7 = v_u_6
    local v8 = setmetatable({}, v7)
    v8.IsVisible = false
    v8.Frame = v_u_5:GetTo("MainFrame", "Pages", "SideParty")
    v8.Container = v8.Frame:WaitForChild("Container")
    v8.LocalFighter = nil
    v8.SidePartyDisplay = v_u_4.new(v8.Container, true)
    v8:_Init()
    return v8
end
function v_u_6._UpdateVisibility(p9)
    local v10 = v_u_3.PageSystem.CurrentPage and not v_u_3.PageSystem.CurrentPage.HidePartyDisplay and (p9.LocalFighter and not p9.LocalFighter:Get("IsInDuel"))
    if v10 then
        v10 = not p9.LocalFighter:Get("IsInShootingRange")
    end
    p9.IsVisible = v10
    p9.Container:TweenPosition(p9.IsVisible and UDim2.new(0.05, 0, 0.95, 0) or UDim2.new(-0.15, 0, 0.95, 0), "Out", "Quint", 0.25, true)
end
function v_u_6._HookLocalFighter(p_u_11)
    p_u_11.LocalFighter = v_u_2:WaitForLocalFighter()
    p_u_11.LocalFighter:GetDataChangedSignal("IsInShootingRange"):Connect(function()
        p_u_11:_UpdateVisibility()
    end)
    p_u_11.LocalFighter:GetDataChangedSignal("IsInDuel"):Connect(function()
        p_u_11:_UpdateVisibility()
    end)
    p_u_11:_UpdateVisibility()
end
function v_u_6._Init(p_u_12)
    v_u_3.PageSystem.PageOpened:Connect(function()
        p_u_12:_UpdateVisibility()
    end)
    v_u_3.PageSystem.PageClosed:Connect(function()
        p_u_12:_UpdateVisibility()
    end)
    p_u_12:_UpdateVisibility()
    task.spawn(p_u_12._HookLocalFighter, p_u_12)
end
return v_u_6._new()