local v_u_1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("UserInputService")
local v_u_3 = game:GetService("GuiService")
local v_u_4 = game:GetService("Players")
local v_u_5 = require(v_u_1.Modules.CONSTANTS)
local v_u_6 = require(v_u_1.Modules.SettingsLibrary)
local v_u_7 = require(v_u_1.Modules.BountyLibrary)
local v_u_8 = require(v_u_1.Modules.DebugLibrary)
local v_u_9 = require(v_u_1.Modules.InputLibrary)
local v_u_10 = require(v_u_1.Modules.SettingsInfo)
local v_u_11 = require(v_u_1.Modules.DuelLibrary)
local v_u_12 = require(v_u_1.Modules.Utility)
local v_u_13 = require(v_u_4.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController"))
local v_u_14 = require(v_u_4.LocalPlayer.PlayerScripts.Controllers:WaitForChild("ControlsController"))
local v_u_15 = require(v_u_4.LocalPlayer.PlayerScripts.Controllers:WaitForChild("SettingsController"))
local v_u_16 = require(v_u_4.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect"))
local v_u_17 = require(v_u_4.LocalPlayer.PlayerScripts.Modules.Settings:WaitForChild("Divider"))
local v_u_18 = require(v_u_4.LocalPlayer.PlayerScripts.Modules:WaitForChild("Crosshair"))
local v_u_19 = require(v_u_4.LocalPlayer.PlayerScripts.Modules:WaitForChild("Page"))
local v_u_20 = v_u_4.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("HotkeysSettingContainer")
local v_u_21 = v_u_4.LocalPlayer.PlayerScripts.Modules:WaitForChild("Settings")
local v_u_22 = setmetatable({}, v_u_19)
v_u_22.__index = v_u_22
function v_u_22._new()
    local v23 = v_u_19.new(script.Name)
    local v24 = v_u_22
    local v25 = setmetatable(v23, v24)
    v25.CloseButton = v25.PageFrame:WaitForChild("Close")
    v25.HotkeyGuide = v25.PageFrame:WaitForChild("HotkeyGuide")
    v25.HotkeyGuideContainer = v25.HotkeyGuide:WaitForChild("Container")
    v25.HotkeyGuideFrame = v25.HotkeyGuideContainer:WaitForChild("Frame")
    v25.HotkeyGuideBackground = v25.HotkeyGuideFrame:WaitForChild("Background")
    v25.HotkeyGuideBackgroundGradient = v25.HotkeyGuideBackground:WaitForChild("UIGradient")
    v25.CrosshairGuide = v25.PageFrame:WaitForChild("CrosshairGuide")
    v25.CrosshairGuideContainer = v25.CrosshairGuide:WaitForChild("Container")
    v25.CrosshairGuideFrame = v25.CrosshairGuideContainer:WaitForChild("Frame")
    v25.CrosshairGuideBackground = v25.CrosshairGuideFrame:WaitForChild("Background")
    v25.CrosshairGuideBackgroundNext = v25.CrosshairGuideBackground:WaitForChild("Next")
    v25.CrosshairGuideBackgroundCurrent = v25.CrosshairGuideBackground:WaitForChild("Current")
    v25.CrosshairGuideShadow = v25.CrosshairGuideFrame:WaitForChild("Shadow")
    v25.List = v25.PageFrame:WaitForChild("List")
    v25.Container = v25.List:WaitForChild("Container")
    v25.Layout = v25.Container:WaitForChild("Layout")
    v25.HotkeyGuideSpacer = v25.Container:WaitForChild("HotkeyGuideSpacer")
    v25.CrosshairGuideSpacer = v25.Container:WaitForChild("CrosshairGuideSpacer")
    v25.DefaultSettingsFrame = v25.Container:WaitForChild("DefaultSettings")
    v25.DefaultButton = v25.DefaultSettingsFrame:WaitForChild("Button")
    v25.DefaultButtonText = v25.DefaultButton:WaitForChild("Title")
    v25.TabsFrame = v25.Container:WaitForChild("Tabs")
    v25.GeneralButton = v25.TabsFrame:WaitForChild("General")
    v25.GeneralButtonText = v25.GeneralButton:WaitForChild("Title")
    v25.GeneralButtonBackground = v25.GeneralButton:WaitForChild("Background")
    v25.GeneralButtonBackgroundGradient = v25.GeneralButtonBackground:WaitForChild("UIGradient")
    v25.HotkeysButton = v25.TabsFrame:WaitForChild("Hotkeys")
    v25.HotkeysButtonText = v25.HotkeysButton:WaitForChild("Title")
    v25.HotkeysButtonBackground = v25.HotkeysButton:WaitForChild("Background")
    v25.HotkeysButtonBackgroundGradient = v25.HotkeysButtonBackground:WaitForChild("UIGradient")
    v25.CrosshairButton = v25.TabsFrame:WaitForChild("Crosshair")
    v25.CrosshairButtonText = v25.CrosshairButton:WaitForChild("Title")
    v25.CrosshairButtonBackground = v25.CrosshairButton:WaitForChild("Background")
    v25.CrosshairButtonBackgroundGradient = v25.CrosshairButtonBackground:WaitForChild("UIGradient")
    v25.Crosshair = v_u_18.new()
    v25.SettingObjects = {}
    v25._default_settings_cooldown = 0
    v25._hotkey_setting_containers = {}
    v25._current_tab = nil
    v25._is_hotkey_guide_cutoff = nil
    v25._is_crosshair_guide_cutoff = nil
    v25._map_num = 0
    v25._is_listening_for_hotkey = false
    v25:_Init()
    return v25
end
function v_u_22.Open(p_u_26, ...)
    v_u_19.Open(p_u_26, ...)
    task.spawn(function()
        local v27 = p_u_26._is_open_hash
        while true do
            local v28 = p_u_26
            v28._map_num = v28._map_num + 1
            p_u_26.CrosshairGuideBackgroundNext.Image = p_u_26:_GetMapImage(p_u_26._map_num + 1)
            p_u_26.CrosshairGuideBackgroundCurrent.Image = p_u_26:_GetMapImage(p_u_26._map_num)
            p_u_26.CrosshairGuideBackgroundCurrent.Position = UDim2.new(0.5, 0, 0.375, 0)
            p_u_26.CrosshairGuideBackgroundCurrent:TweenPosition(UDim2.new(0.5, 0, 0.5, 0), "Out", "Quint", 0.25, true)
            wait(5)
            if v27 ~= p_u_26._is_open_hash then
                break
            end
            p_u_26.CrosshairGuideBackgroundCurrent:TweenPosition(UDim2.new(0.5, 0, 0.625, 0), "In", "Quint", 0.25, true)
            wait(0.25)
            if v27 ~= p_u_26._is_open_hash then
                return
            end
        end
    end)
end
function v_u_22.Close(p29, ...)
    for _, v30 in pairs(p29.SettingObjects) do
        if v30.SettingsInfo.InputType == "Color" then
            v30:SetOpen(false)
            v30:CancelInputs(false)
        end
    end
    v_u_19.Close(p29, ...)
end
function v_u_22._GetMapImage(_, p31)
    return v_u_11.Maps[v_u_11.MapOrder[(p31 - 1) % #v_u_11.MapOrder + 1]].Image
end
function v_u_22._UpdateControls(p32)
    p32.HotkeysButton.Visible = v_u_14.CurrentControls == "MouseKeyboard" and true or v_u_14.CurrentControls == "Gamepad"
end
function v_u_22._UpdateCrosshairAppearance(p33, p34)
    p33.Crosshair:SetAppearance(v_u_12:GenerateCrosshairAppearance(v_u_13, p34))
    p33.Crosshair:SetSpacing(p33.Crosshair:GetAppearanceSpacing())
end
function v_u_22._UpdateCrosshairGuidePosition(p35)
    local v36 = p35.CrosshairGuideSpacer.AbsolutePosition.Y - p35.PageFrame.AbsolutePosition.Y
    local v37 = p35.List.AbsolutePosition.Y - p35.PageFrame.AbsolutePosition.Y
    local v38 = v36 < v37 - 10
    p35.CrosshairGuideFrame.Position = UDim2.new(0.5, 0, 0, math.max(v37, v36) - (p35.CrosshairGuideContainer.AbsolutePosition.Y - p35.PageFrame.AbsolutePosition.Y))
    if p35._is_crosshair_guide_cutoff ~= v38 then
        p35._is_crosshair_guide_cutoff = v38
        local v39 = p35._is_crosshair_guide_cutoff and UDim2.new(1.1, 0, 0.2, 0) or UDim2.new(1, 0, 0.2, 0)
        if p35.CrosshairGuideFrame:IsDescendantOf(v_u_4) then
            p35.CrosshairGuideFrame:TweenSize(v39, "Out", "Quint", 0.25, true)
        else
            p35.CrosshairGuideFrame.Size = v39
        end
        p35.CrosshairGuideShadow.Visible = p35._is_crosshair_guide_cutoff
    end
end
function v_u_22._UpdateHotkeyGuidePosition(p40)
    local v41 = p40.HotkeyGuideSpacer.AbsolutePosition.Y - p40.PageFrame.AbsolutePosition.Y
    local v42 = p40.List.AbsolutePosition.Y - p40.PageFrame.AbsolutePosition.Y
    local v43 = v41 < v42 - 10
    p40.HotkeyGuideFrame.Position = UDim2.new(0.5, 0, 0, math.max(v42, v41) - (p40.HotkeyGuideContainer.AbsolutePosition.Y - p40.PageFrame.AbsolutePosition.Y))
    if p40._is_hotkey_guide_cutoff ~= v43 then
        p40._is_hotkey_guide_cutoff = v43
        local v44 = p40._is_hotkey_guide_cutoff and UDim2.new(1.1, 0, 1.5, 0) or UDim2.new(1, 0, 1, 0)
        if p40.HotkeyGuideBackground:IsDescendantOf(v_u_4) then
            p40.HotkeyGuideBackground:TweenSize(v44, "Out", "Quint", 0.25, true)
        else
            p40.HotkeyGuideBackground.Size = v44
        end
        p40.HotkeyGuideBackground.ImageTransparency = p40._is_hotkey_guide_cutoff and 0 or 0.25
        p40.HotkeyGuideBackgroundGradient.Enabled = not p40._is_hotkey_guide_cutoff
    end
end
function v_u_22._SetTab(p45, p46)
    p45._current_tab = p46
    p45.GeneralButtonText.TextColor3 = p45._current_tab == "General" and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
    p45.GeneralButtonBackground.ImageColor3 = p45._current_tab == "General" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
    p45.GeneralButtonBackground.ImageTransparency = p45._current_tab == "General" and 0 or 0.25
    p45.GeneralButtonBackgroundGradient.Enabled = p45._current_tab ~= "General"
    p45.HotkeysButtonText.TextColor3 = p45._current_tab == "Hotkeys" and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
    p45.HotkeysButtonBackground.ImageColor3 = p45._current_tab == "Hotkeys" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
    p45.HotkeysButtonBackground.ImageTransparency = p45._current_tab == "Hotkeys" and 0 or 0.25
    p45.HotkeysButtonBackgroundGradient.Enabled = p45._current_tab ~= "Hotkeys"
    p45.CrosshairButtonText.TextColor3 = p45._current_tab == "Crosshair" and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
    p45.CrosshairButtonBackground.ImageColor3 = p45._current_tab == "Crosshair" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
    p45.CrosshairButtonBackground.ImageTransparency = p45._current_tab == "Crosshair" and 0 or 0.25
    p45.CrosshairButtonBackgroundGradient.Enabled = p45._current_tab ~= "Crosshair"
    p45.DefaultButtonText.Text = "Reset " .. p45._current_tab
    p45.HotkeyGuideSpacer.Visible = p45._current_tab == "Hotkeys"
    p45.HotkeyGuide.Visible = p45._current_tab == "Hotkeys"
    p45.CrosshairGuideSpacer.Visible = p45._current_tab == "Crosshair"
    p45.CrosshairGuide.Visible = p45._current_tab == "Crosshair"
    for _, v47 in pairs(p45.SettingObjects) do
        local v48 = v47.SettingFrame
        local v49
        if v47.SettingsInfo.Section == p45._current_tab then
            v49 = p45.Container or nil
        else
            v49 = nil
        end
        v48.Parent = v49
    end
    for _, v50 in pairs(p45._hotkey_setting_containers) do
        local v51
        if p45._current_tab == "Hotkeys" then
            v51 = p45.Container or nil
        else
            v51 = nil
        end
        v50.Parent = v51
    end
end
function v_u_22._Generate(p_u_52)
    for v53, v_u_54 in pairs(v_u_6.Order) do
        if v_u_54.InputType ~= "Hotkey" then
            if v_u_54.Name == "Settings Bounty Rewards Disabled" then
                local v55 = v_u_7.Players
                local v56 = v_u_4.LocalPlayer.UserId
                if v55[tostring(v56)] then
                    goto l5
                end
            else
                ::l5::
                if v_u_54.Name ~= "Settings Staff Team Tools Disabled" or (v_u_5.HAS_MODERATOR_ACCESS(v_u_13:Get("GroupRank")) or v_u_8:HasBasicAccess(v_u_4.LocalPlayer.UserId, v_u_13:Get("GroupRank"))) then
                    local v_u_57 = require(v_u_21:WaitForChild(v_u_54.InputType)).new(v_u_54)
                    local function v58()
                        v_u_57:SetValue(v_u_13:Get(v_u_54.Name), true, true)
                    end
                    v_u_13:GetDataChangedSignal(v_u_54.Name):Connect(v58)
                    v_u_57:SetValue(v_u_13:Get(v_u_54.Name), true, true)
                    v_u_57.Replicate:Connect(function()
                        v_u_15:ChangeSetting(v_u_54.Name, v_u_57.Value)
                    end)
                    if v_u_57.SettingsInfo.InputType == "Slider" or v_u_57.SettingsInfo.InputType == "Color" then
                        v_u_57.SliderChanged:Connect(function(p59)
                            v_u_13.SettingsSliderChanged:Fire(v_u_54.Name, p59)
                        end)
                    end
                    if v_u_54.Name == "Settings Auto Shoot Reaction Time" then
                        local function v60()
                            v_u_57.SettingFrame.Visible = v_u_13:Get("Settings Auto Shoot") == "Custom"
                        end
                        v_u_13:GetDataChangedSignal("Settings Auto Shoot"):Connect(v60)
                        v_u_57.SettingFrame.Visible = v_u_13:Get("Settings Auto Shoot") == "Custom"
                    end
                    v_u_57.SettingFrame.LayoutOrder = v53
                    p_u_52.SettingObjects[v_u_54.Name] = v_u_57
                end
            end
        end
    end
    for v61, v62 in pairs(v_u_6.Hotkeys) do
        if v62 == "Divider" then
            local v63 = v_u_17.new(v_u_10.new("", "", "", "", "", "Divider"))
            v63.SettingFrame.LayoutOrder = v61
            v63.SettingFrame.Parent = p_u_52.Container
            local v64 = p_u_52._hotkey_setting_containers
            local v65 = v63.SettingFrame
            table.insert(v64, v65)
        else
            local v66 = v_u_9.Inputs[v62]
            local v_u_67 = v_u_20:Clone()
            v_u_67.Title.Text = v66.DisplayName
            v_u_67.Icon.Image = v66.Image
            v_u_67.LayoutOrder = v61
            local v68 = p_u_52._hotkey_setting_containers
            table.insert(v68, v_u_67)
            local v_u_69 = {
                { v_u_67.MouseKeyboard1, "Settings Hotkey MouseKeyboard" .. v62 .. "1" },
                { v_u_67.MouseKeyboard2, "Settings Hotkey MouseKeyboard" .. v62 .. "2" },
                { v_u_67.Gamepad1, "Settings Hotkey Gamepad" .. v62 .. "1" }
            }
            local function v_u_71()
                v_u_67.Reset.Visible = false
                for _, v70 in pairs(v_u_69) do
                    if v_u_13:Get(v70[2]) ~= v_u_6.Info[v70[2]].DefaultValue then
                        v_u_67.Reset.Visible = true
                        return
                    end
                end
            end
            v_u_67.Reset.MouseButton1Click:Connect(function()
                local v72 = {}
                for _, v73 in pairs(v_u_69) do
                    local v74 = { v73[2], v_u_6.Info[v73[2]].DefaultValue }
                    table.insert(v72, v74)
                end
                v_u_15:ChangeSettings(v72)
            end)
            v_u_16:Add(v_u_67.Reset)
            local function v98(p_u_75, p_u_76)
                local v_u_77 = v_u_6.Info[p_u_76]
                local v_u_78 = {}
                local v_u_79 = nil
                local function v_u_84(p80)
                    if p80 ~= v_u_79 then
                        v_u_79 = p80
                        local v81
                        if p80 then
                            v81 = v_u_12:GetInputEnumFromName(p80)
                        else
                            v81 = p80
                        end
                        p_u_75.Listening.Text = ""
                        p_u_75.Keybind.Visible = true
                        p_u_75.Keybind:RemoveTag("UIKeybindContainer")
                        if v81 then
                            local v82 = p_u_75.Keybind
                            local v83 = v81.EnumType
                            v82:SetAttribute("EnumType", (tostring(v83)))
                            p_u_75.Keybind:SetAttribute("EnumName", p80)
                            p_u_75.Keybind:AddTag("UIKeybindContainer")
                        end
                    end
                end
                local function v_u_87(p85)
                    local v86 = v_u_13:Get(p_u_76) ~= "nil"
                    p_u_75.Edit.Size = v86 and UDim2.new(1, 0, 0.5, 0) or UDim2.new(1, 0, 1, 0)
                    p_u_75.Edit.Visible = p85
                    p_u_75.Unbind.Visible = v86 and p85
                end
                local function v_u_89()
                    for _, v88 in pairs(v_u_78) do
                        v88:Disconnect()
                    end
                    v_u_78 = {}
                    p_u_52._is_listening_for_hotkey = false
                end
                p_u_75.Edit.MouseButton1Click:Connect(function()
                    v_u_87(false)
                    v_u_89()
                    p_u_52._is_listening_for_hotkey = true
                    local v90 = v_u_78
                    local v91 = v_u_2.InputBegan
                    local function v96(p92)
                        local v93 = v_u_77.VerifyInput
                        local v94
                        if p92.KeyCode == Enum.KeyCode.Unknown then
                            v94 = p92.UserInputType.Name
                        else
                            v94 = p92.KeyCode.Name
                        end
                        local v95 = v93(v94)
                        v_u_89()
                        p_u_75.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                        v_u_84(v95)
                        v_u_15:ChangeSetting(p_u_76, v95)
                    end
                    table.insert(v90, v91:Connect(v96))
                    p_u_75.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    p_u_75.Keybind.Visible = false
                    p_u_75.Listening.Text = "\226\128\162 \226\128\162 \226\128\162"
                    v_u_3.SelectedObject = nil
                end)
                p_u_75.Unbind.MouseButton1Click:Connect(function()
                    v_u_87(false)
                    v_u_15:ChangeSetting(p_u_76, nil)
                end)
                p_u_75.MouseEnter:Connect(function()
                    if #v_u_78 == 0 then
                        v_u_87(true)
                    end
                end)
                p_u_75.MouseLeave:Connect(function()
                    v_u_87(false)
                end)
                local function v97()
                    v_u_84(v_u_13:Get(p_u_76))
                    v_u_71()
                end
                v_u_13:GetDataChangedSignal(p_u_76):Connect(v97)
                v_u_84(v_u_13:Get(p_u_76))
                v_u_71()
            end
            v98(v_u_67.MouseKeyboard1, "Settings Hotkey MouseKeyboard" .. v62 .. "1")
            v98(v_u_67.MouseKeyboard2, "Settings Hotkey MouseKeyboard" .. v62 .. "2")
            v98(v_u_67.Gamepad1, "Settings Hotkey Gamepad" .. v62 .. "1")
        end
    end
    p_u_52.Crosshair:SetParent(p_u_52.CrosshairGuideFrame)
    p_u_52:_SetTab("General")
end
function v_u_22._Init(p_u_99)
    p_u_99.CloseButton.MouseButton1Click:Connect(function()
        p_u_99:CloseRequest()
    end)
    p_u_99.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p_u_99.List.CanvasSize = UDim2.new(0, 0, 0, p_u_99.Layout.AbsoluteContentSize.Y)
    end)
    p_u_99.DefaultButton.MouseButton1Click:Connect(function()
        if tick() >= p_u_99._default_settings_cooldown then
            p_u_99._default_settings_cooldown = tick() + 1
            v_u_1.Remotes.Data.DefaultSettings:FireServer(p_u_99._current_tab)
        end
    end)
    p_u_99.GeneralButton.MouseButton1Click:Connect(function()
        p_u_99:_SetTab("General")
    end)
    p_u_99.HotkeysButton.MouseButton1Click:Connect(function()
        p_u_99:_SetTab("Hotkeys")
    end)
    p_u_99.CrosshairButton.MouseButton1Click:Connect(function()
        p_u_99:_SetTab("Crosshair")
    end)
    p_u_99.HotkeyGuideSpacer:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
        p_u_99:_UpdateHotkeyGuidePosition()
    end)
    p_u_99.CrosshairGuideSpacer:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
        p_u_99:_UpdateCrosshairGuidePosition()
    end)
    v_u_3:GetPropertyChangedSignal("SelectedObject"):Connect(function()
        if p_u_99:IsOpen() and p_u_99._is_listening_for_hotkey then
            task.defer(function()
                v_u_3.SelectedObject = nil
            end)
        end
    end)
    v_u_14.ControlsChanged:Connect(function()
        p_u_99:_UpdateControls()
    end)
    v_u_13.SettingsSliderChanged:Connect(function(p100, p101)
        p_u_99:_UpdateCrosshairAppearance({
            [p100] = p101
        })
    end)
    for v102, v103 in pairs(v_u_6.Info) do
        if v103.Section == "Crosshair" then
            v_u_13:GetDataChangedSignal(v102):Connect(function()
                p_u_99:_UpdateCrosshairAppearance()
            end)
        end
    end
    task.spawn(p_u_99._Generate, p_u_99)
    p_u_99:_UpdateControls()
    p_u_99:_UpdateCrosshairAppearance()
    p_u_99:_UpdateHotkeyGuidePosition()
    p_u_99:_UpdateCrosshairGuidePosition()
    v_u_16:Add(p_u_99.CloseButton)
    v_u_16:Add(p_u_99.DefaultButton)
    v_u_16:Add(p_u_99.GeneralButton, nil, {
        ["HoverRatio"] = 1.05,
        ["ReleaseRatio"] = 1.05
    })
    v_u_16:Add(p_u_99.HotkeysButton, nil, {
        ["HoverRatio"] = 1.05,
        ["ReleaseRatio"] = 1.05
    })
    v_u_16:Add(p_u_99.CrosshairButton, nil, {
        ["HoverRatio"] = 1.05,
        ["ReleaseRatio"] = 1.05
    })
end
return v_u_22._new()