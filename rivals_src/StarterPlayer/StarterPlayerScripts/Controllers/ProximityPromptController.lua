local v_u_1 = game:GetService("ProximityPromptService")
local v2 = game:GetService("ReplicatedStorage")
local v_u_3 = game:GetService("GuiService")
local v_u_4 = game:GetService("Players")
local v_u_5 = require(v2.Modules.BetterDebris)
local v_u_6 = require(v2.Modules.ItemLibrary)
local v_u_7 = require(v_u_4.LocalPlayer.PlayerScripts.Controllers:WaitForChild("ControlsController"))
local v_u_8 = require(v_u_4.LocalPlayer.PlayerScripts.Controllers:WaitForChild("SpectateController"))
local v_u_9 = require(v_u_4.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("MobileButtons"))
local v_u_10 = require(v_u_4.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Teleporting"))
local v_u_11 = require(v_u_4.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Shutdown"))
local v_u_12 = require(v_u_4.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Queue"))
local v_u_13 = require(v_u_4.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Pages"))
local v_u_14 = require(v_u_4.LocalPlayer.PlayerScripts.Modules:WaitForChild("WeaponStatusHandler"))
local v_u_15 = require(v_u_4.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect"))
local v_u_16 = v_u_4.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("ProximityPrompts")
local v_u_17 = {}
v_u_17.__index = v_u_17
function v_u_17._new()
    local v18 = v_u_17
    local v19 = setmetatable({}, v18)
    v19._custom_prompt = nil
    v19._custom_prompt_hash = 0
    v19._custom_prompt_connections = {}
    v19:_Init()
    return v19
end
function v_u_17._UpdateEnabled(_)
    local v20 = v_u_1
    local v21 = not (v_u_8.CurrentDuelSubject or v_u_9.EditorEnabled or (v_u_13.PageSystem.CurrentPage or v_u_10.Enabled or (v_u_11.Enabled or v_u_12:IsVisible())))
    if v21 then
        v21 = not v_u_3.MenuIsOpen
    end
    v20.Enabled = v21
end
function v_u_17._Cleanup(p22)
    p22._custom_prompt_hash = p22._custom_prompt_hash + 1
    for _, v23 in pairs(p22._custom_prompt_connections) do
        v23:Disconnect()
    end
    p22._custom_prompt_connections = {}
    if p22._custom_prompt then
        v_u_5:AddItem(p22._custom_prompt, 0.15)
        if p22._custom_prompt:FindFirstChild("Button") and p22._custom_prompt:IsDescendantOf(v_u_4) then
            p22._custom_prompt.Button:TweenSize(UDim2.new(0, 0, 0, 0), "Out", "Quint", 0.25, true)
        end
        p22._custom_prompt = nil
    end
end
function v_u_17._Create(p_u_24, p_u_25)
    p_u_24:_Cleanup()
    p_u_25:SetAttribute("ClickablePrompt", p_u_25.ClickablePrompt)
    p_u_25.ClickablePrompt = v_u_7.CurrentControls == "Touch" and true or p_u_25:GetAttribute("ClickablePrompt")
    p_u_24._custom_prompt_hash = p_u_24._custom_prompt_hash + 1
    local v_u_26 = p_u_24._custom_prompt_hash
    local v27 = v_u_16[p_u_25:GetAttribute("Style") or "Default"]
    p_u_24._custom_prompt = v27:Clone()
    p_u_24._custom_prompt.Name = "ProximityPrompt - " .. v27.Name
    p_u_24._custom_prompt.Button.Inputs.MouseKeyboard.KeyText.Text = p_u_25.KeyboardKeyCode.Name
    p_u_24._custom_prompt.Button.Inputs.Gamepad.Container:SetAttribute("EnumType", "KeyCode")
    p_u_24._custom_prompt.Button.Inputs.Gamepad.Container:SetAttribute("EnumName", p_u_25.GamepadKeyCode.Name)
    p_u_24._custom_prompt.Button.Inputs.Gamepad.Container:AddTag("UIKeybindContainer")
    p_u_24._custom_prompt.Button.Interactable = p_u_25.ClickablePrompt
    p_u_24._custom_prompt.Adornee = p_u_25.Parent
    p_u_24._custom_prompt.Parent = v_u_4.LocalPlayer.PlayerGui
    local function v31()
        p_u_24._custom_prompt.Button.ObjectText.Text = p_u_25.ObjectText
        p_u_24._custom_prompt.Button.ActionText.Text = p_u_25.ActionText
        v_u_14:ClearStatusElements(p_u_24._custom_prompt.Button.ObjectText)
        local v28 = v_u_14
        local v29 = p_u_24._custom_prompt.Button.ObjectText
        local v30 = v_u_6.Items[p_u_25.ObjectText]
        if v30 then
            v30 = v_u_6.Items[p_u_25.ObjectText].Status
        end
        v28:ApplyItemStatusToText(v29, v30)
    end
    local v32 = p_u_24._custom_prompt_connections
    local v33 = p_u_25:GetPropertyChangedSignal("ObjectText")
    table.insert(v32, v33:Connect(v31))
    local v34 = p_u_24._custom_prompt_connections
    local v35 = p_u_25:GetPropertyChangedSignal("ActionText")
    table.insert(v34, v35:Connect(v31))
    v31()
    p_u_24._custom_prompt.Button.Size = UDim2.new(p_u_24._custom_prompt.Button.Size.X.Scale * 0.5, p_u_24._custom_prompt.Button.Size.X.Offset * 0.5, p_u_24._custom_prompt.Button.Size.Y.Scale * 0.5, p_u_24._custom_prompt.Button.Size.Y.Offset * 0.5)
    p_u_24._custom_prompt.Button:TweenSize(v27.Button.Size, "Out", "Quint", 0.25, true, function()
        if p_u_24._custom_prompt_hash == v_u_26 and p_u_25.ClickablePrompt then
            p_u_24._custom_prompt.Button.MouseButton1Down:Connect(function()
                p_u_25:InputHoldBegin()
            end)
            p_u_24._custom_prompt.Button.MouseButton1Up:Connect(function()
                p_u_25:InputHoldEnd()
            end)
            p_u_24._custom_prompt.Button.MouseLeave:Connect(function()
                p_u_25:InputHoldEnd()
            end)
            v_u_15:Add(p_u_24._custom_prompt.Button, nil, {
                ["DontReposition"] = true
            })
        end
    end)
    p_u_24:_UpdateEnabled()
end
function v_u_17._Init(p_u_36)
    v_u_1.PromptShown:Connect(function(p37)
        if p37.Style == Enum.ProximityPromptStyle.Custom then
            p_u_36:_Create(p37)
        end
    end)
    v_u_1.PromptHidden:Connect(function(p38)
        if p38.Style == Enum.ProximityPromptStyle.Custom then
            p_u_36:_Cleanup()
        end
    end)
    v_u_13.PageSystem.PageOpened:Connect(function()
        p_u_36:_UpdateEnabled()
    end)
    v_u_13.PageSystem.PageClosed:Connect(function()
        p_u_36:_UpdateEnabled()
    end)
    v_u_10.EnabledChanged:Connect(function()
        p_u_36:_UpdateEnabled()
    end)
    v_u_11.EnabledChanged:Connect(function()
        p_u_36:_UpdateEnabled()
    end)
    v_u_12.VisibilityChanged:Connect(function()
        p_u_36:_UpdateEnabled()
    end)
    v_u_8.DuelSubjectChanged:Connect(function()
        p_u_36:_UpdateEnabled()
    end)
    v_u_9.EditorEnabledChanged:Connect(function()
        p_u_36:_UpdateEnabled()
    end)
    v_u_3:GetPropertyChangedSignal("MenuIsOpen"):Connect(function()
        p_u_36:_UpdateEnabled()
    end)
    p_u_36:_UpdateEnabled()
end
return v_u_17._new()