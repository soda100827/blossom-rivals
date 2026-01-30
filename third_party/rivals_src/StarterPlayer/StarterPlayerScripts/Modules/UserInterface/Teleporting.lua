local v_u_1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("TeleportService")
local v_u_3 = game:GetService("Lighting")
local v_u_4 = game:GetService("Players")
local v_u_5 = require(v_u_1.Modules.FunFacts)
local v_u_6 = require(v_u_1.Modules.Utility)
local v_u_7 = require(v_u_1.Modules.Signal)
require(v_u_4.LocalPlayer.PlayerScripts.Modules:WaitForChild("UILibrary"))
local v_u_8 = v_u_4.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("TeleportingGui")
local v_u_9 = {}
v_u_9.__index = v_u_9
function v_u_9._new()
    local v10 = v_u_9
    local v11 = setmetatable({}, v10)
    v11.EnabledChanged = v_u_7.new()
    v11.Enabled = nil
    v11.GUI = v_u_8:Clone()
    v11.Frame = v11.GUI:WaitForChild("MainFrame")
    v11.Container = v11.Frame:WaitForChild("Container")
    v11.Dots = v11.Container:WaitForChild("Dots")
    v11.FunFactText = v11.Container:WaitForChild("FunFact")
    v11.FunFactButton = v11.FunFactText:WaitForChild("Button")
    v11._enabled_hash = 0
    v11._blur = Instance.new("BlurEffect")
    v11:_Init()
    return v11
end
function v_u_9.Enable(p12, p13)
    if p13 ~= p12.Enabled then
        p12.Enabled = p13
        p12.EnabledChanged:Fire()
        p12._enabled_hash = p12._enabled_hash + 1
        task.spawn(p12._Update, p12)
    end
end
function v_u_9._Update(p_u_14)
    local v_u_15 = p_u_14._enabled_hash
    p_u_14.GUI.Enabled = p_u_14.Enabled
    p_u_14.FunFactText.Text = v_u_5()
    if p_u_14.Enabled then
        p_u_14.Dots:AddTag("UILoadingDots")
    else
        p_u_14.Dots:RemoveTag("UILoadingDots")
    end
    local v_u_16 = p_u_14.Enabled and 1 or 0.5
    local v_u_17 = p_u_14.Enabled and 0.5 or 1
    local v_u_18 = p_u_14.Enabled and 0 or 56
    local v_u_19 = p_u_14.Enabled and 56 or 0
    v_u_6:RenderstepForLoop(0, 100, 4, function(p20)
        if v_u_15 ~= p_u_14._enabled_hash then
            return true
        end
        local v21 = 1 - (1 - p20 / 100) ^ 3
        p_u_14.Frame.BackgroundTransparency = v_u_16 + (v_u_17 - v_u_16) * v21
        p_u_14._blur.Size = v_u_18 + (v_u_19 - v_u_18) * v21
    end)
end
function v_u_9._Setup(p22)
    p22._blur.Size = 0
    p22._blur.Name = "Teleporting"
    p22._blur.Parent = v_u_3
    p22.GUI.Parent = v_u_4.LocalPlayer.PlayerGui
end
function v_u_9._Init(p_u_23)
    p_u_23.EnabledChanged:Connect(function()
        if p_u_23.Enabled then
            v_u_2:SetTeleportGui(p_u_23.GUI)
        end
    end)
    p_u_23.FunFactButton.MouseButton1Click:Connect(function()
        p_u_23.FunFactText.Text = v_u_5()
    end)
    v_u_1.Remotes.Misc.Teleporting.OnClientEvent:Connect(function(p24)
        p_u_23:Enable(p24)
    end)
    p_u_23:_Setup()
    p_u_23:Enable(false)
end
return v_u_9._new()