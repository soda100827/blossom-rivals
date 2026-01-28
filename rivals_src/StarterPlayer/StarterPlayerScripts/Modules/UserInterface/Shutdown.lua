local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("RunService")
local v_u_3 = game:GetService("Lighting")
local v_u_4 = game:GetService("Players")
local v_u_5 = require(v1.Modules.Utility)
local v_u_6 = require(v1.Modules.Signal)
local v_u_7 = require(v_u_4.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Teleporting"))
local v_u_8 = require(v_u_4.LocalPlayer.PlayerScripts.Modules:WaitForChild("UILibrary"))
local v_u_9 = v_u_4.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("Shutdown")
local v_u_10 = {
    [Enum.CloseReason.RobloxMaintenance] = "Roblox maintenance",
    [Enum.CloseReason.OutOfMemory] = "The server ran out of memory",
    [Enum.CloseReason.ServerEmpty] = "The server is now empty",
    [Enum.CloseReason.DeveloperUpdate] = "Migrating to new servers",
    [Enum.CloseReason.DeveloperShutdown] = "Shutdown by the developers"
}
local v_u_11 = {}
v_u_11.__index = v_u_11
function v_u_11._new()
    local v12 = v_u_11
    local v13 = setmetatable({}, v12)
    v13.EnabledChanged = v_u_6.new()
    v13.Enabled = nil
    v13:_Init()
    return v13
end
function v_u_11.Enable(p14, p15)
    p14.Enabled = true
    p14.EnabledChanged:Fire()
    v_u_8.MainGui.Enabled = false
    v_u_7.GUI.Parent = nil
    local v_u_16 = v_u_9:Clone()
    v_u_16.MainFrame.Reason.Text = v_u_10[p15] or (p15 and p15.Value or "")
    v_u_16.Parent = v_u_4.LocalPlayer.PlayerGui
    v_u_2.RenderStepped:Connect(function(p17)
        local v18 = v_u_16.MainFrame.Icon
        local v19 = v18.Rotation
        local v20 = tick() * 2 % 6.283185307179586
        v18.Rotation = v19 + (math.sin(v20) + 1) * p17 * 300
    end)
    local v_u_21 = Instance.new("BlurEffect")
    v_u_21.Name = "Shutdown"
    v_u_21.Parent = v_u_3
    v_u_5:RenderstepForLoop(0, 100, 1, function(p22)
        local v23 = (1 - p22 / 100) ^ 5
        v_u_21.Size = 56 * (1 - v23)
        v_u_16.MainFrame.BackgroundTransparency = 0.5 + 0.5 * v23
        v_u_16.MainFrame.Description.TextTransparency = 0.5 - 0.5 * v23
        v_u_16.MainFrame.Title.TextTransparency = v23
        v_u_16.MainFrame.Icon.ImageTransparency = v23
    end)
end
function v_u_11._Init(_) end
return v_u_11._new()