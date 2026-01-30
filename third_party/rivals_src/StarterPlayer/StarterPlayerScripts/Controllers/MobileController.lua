local v_u_1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("CollectionService")
local v_u_3 = game:GetService("Players")
local v_u_4 = require(v_u_1.Modules.CONSTANTS)
local v_u_5 = require(v_u_1.Modules.Utility)
local v_u_6 = require(v_u_3.LocalPlayer.PlayerScripts.Controllers:WaitForChild("ControlsController"))
local v_u_7 = require(v_u_3.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Teleporting"))
local v_u_8 = {}
v_u_8.__index = v_u_8
function v_u_8._new()
    local v9 = v_u_8
    local v10 = setmetatable({}, v9)
    v10._models = {}
    v10:_Init()
    return v10
end
function v_u_8._FixPermanentKeyboardBug(_)
    if v_u_5:IsTextBoxFocused() then
        local v_u_11 = Instance.new("ScreenGui")
        v_u_11.Parent = v_u_3.LocalPlayer.PlayerGui
        local v_u_12 = Instance.new("TextBox")
        v_u_12.BackgroundTransparency = 1
        v_u_12.Text = ""
        v_u_12.PlaceholderText = ""
        v_u_12.TextTransparency = 1
        v_u_12.Parent = v_u_11
        task.defer(function()
            v_u_12:CaptureFocus()
            task.defer(function()
                v_u_12:ReleaseFocus()
                v_u_12:Destroy()
                v_u_11:Destroy()
            end)
        end)
    end
end
function v_u_8._UpdatePrompts(p13)
    for v16, v15 in pairs(p13._models) do
        if not v_u_4.IS_MOBILE_SERVER and v_u_6.CurrentControls ~= "Touch" then
            local v16 = nil
        end
        v15.Parent = v16
    end
end
function v_u_8._PromptAdded(p17, p18)
    local v19 = p18:WaitForChild("Model")
    local v20 = v19:WaitForChild("Prompt"):WaitForChild("ProximityPrompt")
    v20.Triggered:Connect(function()
        v_u_1.Remotes.Misc.MobileDuelsTeleport:FireServer()
    end)
    v20.ActionText = v_u_4.IS_MOBILE_SERVER and "Leave" or "Teleport"
    p17._models[p18] = v19
    task.defer(p17._UpdatePrompts, p17)
end
function v_u_8._Init(p_u_21)
    v_u_7.EnabledChanged:Connect(function()
        p_u_21:_FixPermanentKeyboardBug()
    end)
    v_u_2:GetInstanceAddedSignal("LobbyMobileDuelsPrompt"):Connect(function(p22)
        p_u_21:_PromptAdded(p22)
    end)
    for _, v23 in pairs(v_u_2:GetTagged("LobbyMobileDuelsPrompt")) do
        task.defer(p_u_21._PromptAdded, p_u_21, v23)
    end
    task.defer(p_u_21._UpdatePrompts, p_u_21)
    task.defer(p_u_21._FixPermanentKeyboardBug, p_u_21)
end
return v_u_8._new()