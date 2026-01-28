local v_u_1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("GuiService")
local v_u_3 = game:GetService("RunService")
local v4 = game:GetService("Players")
local v_u_5 = require(v_u_1.Modules.DuelLibrary)
local v_u_6 = require(v_u_1.Modules.Utility)
local v_u_7 = require(v_u_1.Modules.Signal)
local v_u_8 = require(v4.LocalPlayer.PlayerScripts.Controllers:WaitForChild("MatchmakingController"))
require(v4.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController"))
local v_u_9 = require(v4.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("MobileButtons"))
local v_u_10 = require(v4.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Teleporting"))
local v_u_11 = require(v4.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Equipment"))
local v_u_12 = require(v4.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Queue"))
local v_u_13 = require(v4.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Pages"))
local v_u_14 = require(v4.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect"))
local v_u_15 = require(v4.LocalPlayer.PlayerScripts.Modules:WaitForChild("UILibrary"))
local v_u_16 = {}
v_u_16.__index = v_u_16
function v_u_16._new()
    local v17 = v_u_16
    local v18 = setmetatable({}, v17)
    v18.VisibilityChanged = v_u_7.new()
    v18.Frame = v_u_15:GetTo("MainFrame", "Lobby", "Matchmaking")
    v18._current_queue_name = nil
    v18._queue_hash = 0
    v18._renderstep_connection = nil
    v18:_Init()
    return v18
end
function v_u_16.IsVisible(p19)
    return p19.Frame.Container.Visible
end
function v_u_16._SetQueueName(p_u_20, p21)
    p_u_20._queue_hash = p_u_20._queue_hash + 1
    p_u_20._current_queue_name = p21
    local v_u_22 = p_u_20._queue_hash
    local v23 = v_u_5.MatchmakingQueues[p_u_20._current_queue_name]
    p_u_20.Frame.Container.Visible = p_u_20._current_queue_name ~= nil
    p_u_20.Frame.Container.Queue.Text = v23 and (v23.DisplayName or "") or ""
    p_u_20.Frame.Container.Icon.Image = v23 and v23.Image or ""
    p_u_20.VisibilityChanged:Fire()
    if p_u_20._current_queue_name then
        v_u_6:CreateSound("rbxassetid://18525513345", 1, 1, script, true, 5)
        task.spawn(function()
            for v24 = 0, (1 / 0) do
                if p_u_20._queue_hash ~= v_u_22 then
                    return
                end
                p_u_20.Frame.Container.Timer.Text = v_u_6:TimeFormat(v24)
                wait(1)
            end
        end)
    end
end
function v_u_16._UpdateVisibility(p_u_25)
    local v26 = not (v_u_13.PageSystem.CurrentPage or (v_u_11.IsOpen or v_u_12:IsVisible() or (v_u_10.Enabled or v_u_9.EditorEnabled)))
    if v26 then
        v26 = not v_u_2.MenuIsOpen
    end
    p_u_25.Frame.Container:TweenPosition(v26 and UDim2.new(0.5, 0, 0.075, 40) or UDim2.new(0.5, 0, -0.2, -40), "Out", "Quint", 0.25, true)
    if p_u_25._renderstep_connection then
        p_u_25._renderstep_connection:Disconnect()
        p_u_25._renderstep_connection = nil
    end
    local v_u_27 = 0
    local v_u_28 = tick() + 0.5
    if v26 then
        v26 = v_u_3.RenderStepped:Connect(function(_)
            local v29 = p_u_25.Frame.Container.Icon
            local v30 = tick()
            v29.Rotation = math.sin(v30) * 5
            if tick() >= v_u_28 then
                v_u_27 = (v_u_27 + 1) % 4
                v_u_28 = tick() + 0.5
                local v31 = p_u_25._current_queue_name
                if v31 then
                    v31 = v_u_5.PlaySources[p_u_25._current_queue_name]
                end
                local v32 = v31 and (v31.DuelLogic == "Zombie Tower" and "Searching for zombies" or (v31.DatabaseInfo.NumTeams * v31.DatabaseInfo.PlayersPerTeam <= 1 and "Waiting for server" or "Searching for players")) or "Searching for players"
                p_u_25.Frame.Container.Title.Text = v32 .. string.rep(".", v_u_27)
            end
        end)
    end
    p_u_25._renderstep_connection = v26
end
function v_u_16._Init(p_u_33)
    p_u_33.Frame.Container.Leave.MouseButton1Click:Connect(function()
        v_u_8:LeaveQueue()
    end)
    v_u_11.Opened:Connect(function()
        p_u_33:_UpdateVisibility()
    end)
    v_u_13.PageSystem.PageOpened:Connect(function()
        p_u_33:_UpdateVisibility()
    end)
    v_u_13.PageSystem.PageClosed:Connect(function()
        p_u_33:_UpdateVisibility()
    end)
    v_u_12.VisibilityChanged:Connect(function()
        p_u_33:_UpdateVisibility()
    end)
    v_u_10.EnabledChanged:Connect(function()
        p_u_33:_UpdateVisibility()
    end)
    v_u_9.EditorEnabledChanged:Connect(function()
        p_u_33:_UpdateVisibility()
    end)
    v_u_2:GetPropertyChangedSignal("MenuIsOpen"):Connect(function()
        p_u_33:_UpdateVisibility()
    end)
    v_u_1.Remotes.Matchmaking.UpdateQueueStatus.OnClientEvent:Connect(function(...)
        p_u_33:_SetQueueName(...)
    end)
    p_u_33:_SetQueueName(nil)
    p_u_33:_UpdateVisibility()
    v_u_14:Add(p_u_33.Frame.Container.Leave)
end
return v_u_16._new()