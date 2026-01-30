local v_u_1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("HttpService")
local v_u_3 = game:GetService("RunService")
local v_u_4 = game:GetService("Lighting")
local v_u_5 = game:GetService("Players")
local v_u_6 = require(v_u_1.Modules.CONSTANTS)
local v_u_7 = require(v_u_1.Modules.InputLibrary)
local v_u_8 = require(v_u_1.Modules.ItemLibrary)
local v_u_9 = require(v_u_1.Modules.Signal)
local v_u_10 = require(v_u_5.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController"))
local v_u_11 = require(v_u_5.LocalPlayer.PlayerScripts.Controllers:WaitForChild("MechanicsController"))
local v_u_12 = require(v_u_5.LocalPlayer.PlayerScripts.Controllers:WaitForChild("SpectateController"))
local v_u_13 = require(v_u_5.LocalPlayer.PlayerScripts.Controllers:WaitForChild("ControlsController"))
local v_u_14 = require(v_u_5.LocalPlayer.PlayerScripts.Controllers:WaitForChild("CameraController"))
local v_u_15 = require(v_u_5.LocalPlayer.PlayerScripts.Controllers:WaitForChild("EmoteController"))
local v_u_16 = require(v_u_5.LocalPlayer.PlayerScripts.Modules:WaitForChild("UserInterface"):WaitForChild("EliminatedEffect"))
local v_u_17 = require(v_u_5.LocalPlayer.PlayerScripts.Modules:WaitForChild("UILibrary"))
local v_u_18 = v_u_5.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("MobileButton")
local v_u_19 = {
    ["IsToggle"] = {},
    ["IsVisible"] = {}
}
local v_u_20 = {}
v_u_20.__index = v_u_20
function v_u_20._new()
    local v21 = v_u_20
    local v22 = setmetatable({}, v21)
    v22.EditorEnabledChanged = v_u_9.new()
    v22.MobileButtonsFrame = v_u_17:GetTo("MobileButtons")
    v22.LocalFighter = nil
    v22.IsEnabled = false
    v22.EditorEnabled = false
    v22._connections = {}
    v22._duel_subject_connections = {}
    v22._hooked_fighter = false
    v22._buttons_generated = false
    v22._buttons = {}
    v22._button_settings = v_u_19
    v22._edits_pending = false
    v22._opaque_buttons = false
    v22._last_button_tap = 0
    v22._equipment_page_visible = false
    v22._page_system_active = false
    v22._blur = Instance.new("BlurEffect")
    v22:_Init()
    return v22
end
function v_u_20.SetPageSystemActive(p23, p24)
    p23._page_system_active = p24
    p23:_UpdateFrameVisibility()
end
function v_u_20.SetEquipmentPageVisible(p25, p26)
    p25._equipment_page_visible = p26
    p25:_UpdateFrameVisibility()
end
function v_u_20.SetEnabled(p27, p28)
    if p28 ~= p27.IsEnabled then
        p27.IsEnabled = p28
        p27:_UpdateFrameVisibility()
        p27:SetEditorEnabled(false)
        p27:_SetupControls()
    end
end
function v_u_20.SetEditorEnabled(p29, p30)
    local v31 = typeof(p30) == "boolean"
    assert(v31, "Argument 1 invalid, expected a boolean")
    p29.EditorEnabled = p30
    p29.EditorEnabledChanged:Fire()
    p29.MobileButtonsFrame.Modal.Visible = p29.EditorEnabled
    v_u_14:SetIsEditingMobileButtons(p29.EditorEnabled)
    for _, v32 in pairs(p29._buttons) do
        v32.Button.Resize.Visible = p29.EditorEnabled
    end
    if not p29.EditorEnabled then
        p29:_ApplyEdits()
    end
    p29:_UpdateButtonVisibility()
    p29._blur.Parent = p29.EditorEnabled and v_u_4 or nil
end
function v_u_20.SetButtonSettings(p33, p34)
    local v35 = not p34 or typeof(p34) == "table"
    assert(v35, "Argument 1 invalid, expected a table or nil")
    for v36, v37 in pairs(p33._buttons) do
        if not v_u_7.MobileButtons[v36].IsCoreInput then
            v37.InputFunction(false, true)
        end
    end
    p33._button_settings = p34 or v_u_19
    p33:_UpdateButtonVisibility()
end
function v_u_20.Switch(p38, p39)
    local v40 = typeof(p39) == "number"
    assert(v40, "Argument 1 invalid, expected a number")
    p38:_ApplyEdits()
    v_u_1.Remotes.Data.SwitchMobileButtonProfile:FireServer(p39)
end
function v_u_20.Reset(p41)
    p41:_ResetButtons()
    p41._edits_pending = false
    v_u_1.Remotes.Data.UpdateMobileButtonSettings:FireServer(v_u_10:Get("MobileButtonProfile"), nil)
end
function v_u_20.EncryptProfile(p42)
    local v43 = p42:_GetCurrentProfile()
    local v44 = string.reverse(v_u_2:JSONEncode(v43))
    local v45 = ""
    for v46 = 1, #v44 do
        local v47 = string.sub(v44, v46, v46)
        local v48 = string.byte(v47) - 1
        v45 = v45 .. string.char(v48)
    end
    return v45
end
function v_u_20.ImportProfile(p49, p50)
    local v51 = typeof(p50) == "string"
    assert(v51, "Argument 1 invalid, expected a string")
    local v52, v53 = p49:_DecryptProfile(p50)
    if v52 then
        p49._edits_pending = true
        p49:_UpdateButtons(v53)
    end
end
function v_u_20._UpdateCameraSinking(p54)
    local v55 = not v_u_10:Get("Settings Camera Mobile Button Sinking")
    for _, v56 in pairs(p54._buttons) do
        v56.Button.Active = v55
    end
end
function v_u_20._UpdateWeaponButtons(p57)
    for v58, v59 in pairs(v_u_7.MobileInputNameToItemIndex) do
        if p57._buttons[v58] then
            p57._buttons[v58].Button.Weapon.Image = p57.LocalFighter and p57.LocalFighter.Items[v59] and p57.LocalFighter.Items[v59].ViewModel.Info.Image or v_u_8.Items[v_u_6.DEFAULT_WEAPONS[v59]].Image
        end
    end
end
function v_u_20._UpdateFrameVisibility(p60)
    local v61 = p60.MobileButtonsFrame
    local v62 = p60.IsEnabled and not (v_u_16:IsVisible() or p60._equipment_page_visible)
    if v62 then
        v62 = not p60._page_system_active
    end
    v61.Visible = v62
end
function v_u_20._Within(_, p63, p64, p65, p66)
    local v67
    if p65.X <= p63 and (p63 <= p65.X + p66.X and p65.Y <= p64) then
        v67 = p64 <= p65.Y + p66.Y
    else
        v67 = false
    end
    return v67
end
function v_u_20._GetCurrentProfile(p68)
    local v69 = {}
    for v70, v71 in pairs(p68._buttons) do
        local v72 = v71.Button.AbsolutePosition + v71.Button.AbsoluteSize * v71.Button.AnchorPoint - p68.MobileButtonsFrame.AbsolutePosition
        v69[v70] = {
            ["Position"] = { v72.X, v72.Y },
            ["Size"] = { v71.Button.Size.X.Offset, v71.Button.Size.Y.Offset }
        }
    end
    return v69
end
function v_u_20._DecryptProfile(_, p_u_73)
    return pcall(function()
        local v74 = ""
        for v75 = #p_u_73, 1, -1 do
            local v76 = p_u_73
            local v77 = string.sub(v76, v75, v75)
            local v78 = string.byte(v77) + 1
            v74 = v74 .. string.char(v78)
        end
        return v_u_2:JSONDecode(v74)
    end)
end
function v_u_20._IsVisible(p79, p80)
    if p79.EditorEnabled then
        return true
    elseif p79.LocalFighter and (not v_u_12.CurrentDuelSubject or (v_u_12.CurrentDuelSubject.LocalDueler or p80 == "mobile_switchcamerapov") and not v_u_12.CurrentDuelSubject.DuelInterface.Voting:IsOpen()) then
        if v_u_7.MobileButtons[p80].AlwaysVisible or p79._button_settings.IsVisible[p80] then
            if v_u_7.MobileButtons[p80].HideIfDead and not p79.LocalFighter:IsAlive() then
                return false
            elseif p80 == "mobile_quickmelee" and (#p79.LocalFighter.Items < p79.LocalFighter:GetQuickAttackIndex("Melee") or p79.LocalFighter.EquippedItem == p79.LocalFighter.Items[p79.LocalFighter:GetQuickAttackIndex("Melee")]) then
                return false
            elseif p80 == "mobile_quickutility" and (#p79.LocalFighter.Items < p79.LocalFighter:GetQuickAttackIndex("Utility") or p79.LocalFighter.EquippedItem == p79.LocalFighter.Items[p79.LocalFighter:GetQuickAttackIndex("Utility")]) then
                return false
            elseif p80 == "mobile_equipnext" and #p79.LocalFighter.Items < 2 then
                return false
            elseif p80 == "mobile_switchcamerapov" and not v_u_14:GetPublicState() then
                return false
            elseif p80 == "mobile_openplayerlist" and not v_u_12.CurrentDuelSubject then
                return false
            elseif p80 == "mobile_equipprimary" and #p79.LocalFighter.Items < 1 then
                return false
            elseif p80 == "mobile_equipsecondary" and #p79.LocalFighter.Items < 2 then
                return false
            elseif p80 == "mobile_equipmelee" and #p79.LocalFighter.Items < 3 then
                return false
            elseif p80 == "mobile_equiputility" and #p79.LocalFighter.Items < 4 then
                return false
            else
                return (p80 ~= "mobile_useemote" or v_u_15:CanEmote()) and true or false
            end
        else
            return false
        end
    else
        return false
    end
end
function v_u_20._UpdateButtonVisibility(p81)
    for v82, v83 in pairs(p81._buttons) do
        v83.Button.Visible = p81:_IsVisible(v82)
    end
end
function v_u_20._ApplyEdits(p84)
    if p84._edits_pending then
        p84._edits_pending = false
        v_u_1.Remotes.Data.UpdateMobileButtonSettings:FireServer(v_u_10:Get("MobileButtonProfile"), p84:_GetCurrentProfile())
    end
end
function v_u_20._ResetButtons(p85)
    local v86 = p85.MobileButtonsFrame.AbsoluteSize.X
    local v87 = p85.MobileButtonsFrame.AbsoluteSize.Y
    local v88 = math.min(v86, v87) <= 500
    local v89 = v88 and UDim2.new() or UDim2.new(0, 0, 0, -45)
    local v90 = v88 and 1 or 1.7894736842105263
    local v91 = v88 and 1 or 1.7142857142857142
    for v92, v93 in pairs(p85._buttons) do
        local v94 = v_u_7.MobileButtons[v92]
        v93.Button.Position = v89 + UDim2.new(v94.DefaultPosition.X.Scale, v94.DefaultPosition.X.Offset * v90, v94.DefaultPosition.Y.Scale, v94.DefaultPosition.Y.Offset * v90)
        v93.Button.Size = UDim2.new(0, v94.DefaultSize.X.Offset * v91, 0, v94.DefaultSize.Y.Offset * v91)
    end
end
function v_u_20._UpdateButtons(p95, p96)
    if p95._buttons_generated then
        p95:_ResetButtons()
        local v97 = p96 or v_u_10:Get("MobileButtonSettings")[v_u_10:Get("MobileButtonProfile")]
        if v97 then
            for v98, v99 in pairs(v97) do
                local v100 = p95._buttons[v98]
                if v100 then
                    v100.Button.Position = UDim2.new(0, v99.Position[1], 0, v99.Position[2])
                    v100.Button.Size = UDim2.new(0, v99.Size[1], 0, v99.Size[2])
                end
            end
        end
    else
        return
    end
end
function v_u_20._HookTouchGui(p_u_101)
    p_u_101.MobileButtonsFrame.JoystickArea.AnchorPoint = Vector2.new(0, 0)
    local v_u_102 = v_u_5.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("TouchGui")
    local v_u_103 = v_u_102:WaitForChild("TouchControlFrame"):WaitForChild("DynamicThumbstickFrame")
    local v_u_104 = v_u_103.Position
    local v_u_105 = v_u_103.AnchorPoint
    local v_u_106 = UDim2.new(1 - v_u_104.X.Scale, -v_u_104.X.Offset, v_u_104.Y.Scale, v_u_104.Y.Offset)
    local v_u_107 = Vector2.new(1 - v_u_105.X, v_u_105.Y)
    local function v_u_116()
        v_u_10:Get("Settings Left Handed Touch Controls")
        local v108 = Vector2.new
        local v109 = v_u_103.AbsolutePosition.X + (v_u_102.AbsolutePosition.X - v_u_17.MainGui.AbsolutePosition.X)
        local v110 = p_u_101.MobileButtonsFrame.AbsoluteSize.X
        local v111 = math.clamp(v109, 0, v110)
        local v112 = v_u_103.AbsolutePosition.Y + (v_u_102.AbsolutePosition.Y - v_u_17.MainGui.AbsolutePosition.Y)
        local v113 = p_u_101.MobileButtonsFrame.AbsoluteSize.Y
        local v114 = v108(v111, (math.clamp(v112, 0, v113)))
        local v115 = Vector2.new(v_u_103.AbsolutePosition.X + v_u_103.AbsoluteSize.X - v114.X, v_u_103.AbsolutePosition.Y + v_u_103.AbsoluteSize.Y - v114.Y)
        p_u_101.MobileButtonsFrame.JoystickArea.Position = UDim2.new(0, v114.X, 0, v114.Y)
        p_u_101.MobileButtonsFrame.JoystickArea.Size = UDim2.new(0, v115.X, 0, v115.Y)
    end
    p_u_101.MobileButtonsFrame:GetPropertyChangedSignal("AbsolutePosition"):Connect(v_u_116)
    p_u_101.MobileButtonsFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(v_u_116)
    v_u_103:GetPropertyChangedSignal("AbsolutePosition"):Connect(v_u_116)
    v_u_103:GetPropertyChangedSignal("AbsoluteSize"):Connect(v_u_116)
    v_u_116()
    local function v118()
        local v117 = v_u_10:Get("Settings Left Handed Touch Controls")
        p_u_101.MobileButtonsFrame.DoubleTapArea.Position = v117 and UDim2.new(0.5, 0, 0.5, 0) or UDim2.new(1, 0, 0.5, 0)
        v_u_103.Position = v117 and v_u_106 or v_u_104
        v_u_103.AnchorPoint = v117 and v_u_107 or v_u_105
        v_u_116()
    end
    v_u_10:GetDataChangedSignal("Settings Left Handed Touch Controls"):Connect(v118)
    v118()
    local function v121()
        local v119 = p_u_101.MobileButtonsFrame.DoubleTapArea
        local v120 = p_u_101.EditorEnabled
        if v120 then
            v120 = v_u_10:Get("Settings Double Tap Shoot")
        end
        v119.Visible = v120
        p_u_101.MobileButtonsFrame.JoystickArea.Visible = p_u_101.EditorEnabled
    end
    v_u_10:GetDataChangedSignal("Settings Double Tap Shoot"):Connect(v121)
    p_u_101.EditorEnabledChanged:Connect(v121)
    local v122 = p_u_101.MobileButtonsFrame.DoubleTapArea
    local v123 = p_u_101.EditorEnabled
    if v123 then
        v123 = v_u_10:Get("Settings Double Tap Shoot")
    end
    v122.Visible = v123
    p_u_101.MobileButtonsFrame.JoystickArea.Visible = p_u_101.EditorEnabled
    v_u_102:WaitForChild("TouchControlFrame"):WaitForChild("JumpButton"):Destroy()
end
function v_u_20._HookFighter(p_u_124)
    if not p_u_124._hooked_fighter then
        p_u_124._hooked_fighter = true
        p_u_124.LocalFighter = p_u_124.LocalFighter or v_u_11:WaitForLocalFighter()
        local function v_u_127()
            p_u_124._opaque_buttons = false
            for v125 in pairs(p_u_124.LocalFighter:GetEquippedItems()) do
                if v125.ItemInterface and v125.ItemInterface:IsScopeActive() then
                    p_u_124._opaque_buttons = true
                    break
                end
            end
            for _, v126 in pairs(p_u_124._buttons) do
                v126.VisualFunction()
            end
        end
        p_u_124.LocalFighter.EquippedItemChanged:Connect(v_u_127)
        local function v_u_130(p128, p129)
            p128.Mouse.Scope.ActiveChanged:Connect(v_u_127)
            if not p129 then
                v_u_127()
            end
        end
        local function v134(p131, p132)
            p131.ToggleOffMobileInputButton:Connect(function(p133)
                p_u_124._buttons[p133].Button1UpFunction()
            end)
            p131.InterfaceAdded:Connect(v_u_130)
            if p131.ItemInterface then
                p131.ItemInterface.Mouse.Scope.ActiveChanged:Connect(v_u_127)
                if not p132 then
                    v_u_127()
                end
            end
        end
        p_u_124.LocalFighter.ItemAdded:Connect(v134)
        for _, v135 in pairs(p_u_124.LocalFighter.Items) do
            task.defer(v134, v135, true)
        end
        v_u_127()
        local function v143()
            for v136, v137 in pairs(p_u_124._buttons) do
                v137.Button.Visible = v_u_7.MobileButtons[v136].IsCoreInput or p_u_124.LocalFighter.EquippedItem ~= nil
            end
            local v138 = p_u_124.LocalFighter.EquippedItem
            if v138 then
                v138 = p_u_124.LocalFighter.EquippedItem.Info.MobileInputSettings
            end
            if v138 then
                local v139 = {
                    ["IsToggle"] = {},
                    ["IsVisible"] = {}
                }
                for v140, v141 in pairs(v138) do
                    local v142 = v_u_7.Inputs[v140].MobileInputName
                    v139.IsToggle[v142] = v141
                    v139.IsVisible[v142] = true
                end
                p_u_124:SetButtonSettings(v139)
            else
                p_u_124:SetButtonSettings(nil)
            end
        end
        p_u_124.LocalFighter.EquippedItemChanged:Connect(v143)
        v143()
        p_u_124.LocalFighter.HealthChanged:Connect(function()
            p_u_124:_UpdateButtonVisibility()
        end)
        p_u_124.LocalFighter.EntityAdded:Connect(function()
            p_u_124:_UpdateButtonVisibility()
        end)
        p_u_124.LocalFighter.Died:Connect(function()
            p_u_124:_UpdateButtonVisibility()
        end)
        p_u_124.LocalFighter:GetDataChangedSignal("IsInDuel"):Connect(function()
            p_u_124:_UpdateButtonVisibility()
        end)
        p_u_124.LocalFighter:GetDataChangedSignal("QuickAttackOverrides"):Connect(function()
            p_u_124:_UpdateButtonVisibility()
        end)
        p_u_124.LocalFighter.ItemAdded:Connect(function()
            p_u_124:_UpdateWeaponButtons()
        end)
        p_u_124.LocalFighter.ItemRemoved:Connect(function()
            p_u_124:_UpdateWeaponButtons()
        end)
        p_u_124:_UpdateWeaponButtons()
    end
end
function v_u_20._GenerateButtons(p_u_144)
    if not p_u_144._buttons_generated then
        p_u_144._buttons_generated = true
        local v145 = require(v_u_5.LocalPlayer.PlayerScripts.Modules:WaitForChild("UserInterface"):WaitForChild("Pages"))
        for v_u_146, v_u_147 in pairs(v_u_7.MobileButtons) do
            local v_u_148 = v_u_7.MobileInputNameToItemIndex[v_u_146]
            local v_u_149 = v_u_18:Clone()
            v_u_149.Name = v_u_146
            v_u_149.Icon.Icon.Image = v_u_147.Image
            v_u_149.Parent = p_u_144.MobileButtonsFrame
            local v_u_150 = false
            local function v_u_152()
                local v151 = not v_u_150 and v_u_148 and (p_u_144.LocalFighter and p_u_144.LocalFighter.EquippedItem)
                if v151 then
                    v151 = p_u_144.LocalFighter.EquippedItem == p_u_144.LocalFighter.Items[v_u_148]
                end
                v_u_149.Icon.ImageTransparency = (p_u_144._opaque_buttons or v151) and 0 or 1
                v_u_149.Icon.Icon.ImageTransparency = (p_u_144._opaque_buttons or v151) and 0 or 0.5
                v_u_149.Icon.Icon.ImageColor3 = v151 and Color3.fromRGB(0, 190, 255) or Color3.fromRGB(0, 0, 0)
            end
            v_u_152()
            local function v_u_155(p153, p154)
                if p154 or not p_u_144.EditorEnabled and p_u_144:_IsVisible(v_u_146) then
                    v_u_150 = p153
                    v_u_152()
                    if v_u_146 == "mobile_switchcamerapov" then
                        if p153 then
                            v_u_14.CameraState:TogglePOV()
                            return
                        end
                    elseif v_u_146 == "mobile_crouch" and v_u_11.IsSliding then
                        if p153 then
                            v_u_11:MobileInput("mobile_jump", true)
                            return
                        end
                    else
                        v_u_11:MobileInput(v_u_146, v_u_150)
                    end
                end
            end
            local function v156()
                if not p_u_144.EditorEnabled then
                    if not p_u_144:_IsVisible(v_u_146) then
                        return
                    end
                    v_u_150 = false
                    v_u_152()
                    if v_u_146 == "mobile_switchcamerapov" then
                        return
                    end
                    if v_u_146 == "mobile_crouch" and v_u_11.IsSliding then
                        return
                    end
                    v_u_11:MobileInput(v_u_146, v_u_150)
                end
            end
            v145.PageSystem.PagesActivity:Connect(v156)
            local function v158(p_u_157)
                p_u_144._last_button_tap = 0
                if v_u_147.AlwaysToggle or p_u_144._button_settings.IsToggle[v_u_146] then
                    v_u_155(not v_u_150)
                else
                    task.spawn(function()
                        if p_u_157 then
                            while p_u_157.UserInputState ~= Enum.UserInputState.End do
                                p_u_157:GetPropertyChangedSignal("UserInputState"):Wait()
                            end
                            if not p_u_144.EditorEnabled then
                                if not p_u_144:_IsVisible(v_u_146) then
                                    return
                                end
                                v_u_150 = false
                                v_u_152()
                                if v_u_146 == "mobile_switchcamerapov" then
                                    return
                                end
                                if v_u_146 == "mobile_crouch" and v_u_11.IsSliding then
                                    return
                                end
                                v_u_11:MobileInput(v_u_146, v_u_150)
                            end
                        end
                    end)
                    v_u_155(true)
                end
            end
            local v_u_159 = false
            local v_u_160 = nil
            local v_u_161 = false
            local v_u_162 = nil
            local v_u_163 = nil
            local v_u_164 = nil
            local function v_u_169()
                local v165 = v_u_149.AbsolutePosition + v_u_149.AbsoluteSize * v_u_149.AnchorPoint - v_u_17:GetMouseLocation()
                local v166 = v165.X ^ 2 + v165.Y ^ 2
                local v167 = math.sqrt(v166) * 2
                local v168 = math.max(v167, 35)
                v_u_149.Size = UDim2.new(0, v168, 0, v168)
            end
            local function v_u_177(p170)
                v_u_163 = v_u_163 + p170.Delta
                local v171 = v_u_164.X + v_u_163.X
                local v172 = p_u_144.MobileButtonsFrame.AbsoluteSize.X
                local v173 = math.clamp(v171, 0, v172)
                local v174 = v_u_164.Y + v_u_163.Y
                local v175 = p_u_144.MobileButtonsFrame.AbsoluteSize.Y
                local v176 = math.clamp(v174, 0, v175)
                v_u_149.Position = UDim2.new(0, v173, 0, v176)
            end
            local function v178(_)
                if v_u_159 then
                    v_u_160:Disconnect()
                    v_u_160 = nil
                    v_u_159 = false
                end
                if v_u_161 then
                    v_u_162:Disconnect()
                    v_u_162 = nil
                    v_u_163 = nil
                    v_u_164 = nil
                    v_u_161 = false
                end
            end
            v_u_149.Resize.MouseButton1Down:Connect(function()
                if p_u_144.EditorEnabled and not v_u_159 then
                    p_u_144._edits_pending = true
                    v_u_159 = true
                    v_u_160 = v_u_3.RenderStepped:Connect(v_u_169)
                end
            end)
            v_u_149.MouseButton1Down:Connect(function()
                if p_u_144.EditorEnabled and not v_u_161 then
                    p_u_144._edits_pending = true
                    v_u_161 = true
                    v_u_164 = v_u_149.AbsolutePosition + v_u_149.AbsoluteSize * v_u_149.AnchorPoint - p_u_144.MobileButtonsFrame.AbsolutePosition
                    v_u_163 = Vector3.new(0, 0, 0)
                    v_u_162 = v_u_13.InputChanged:Connect(v_u_177)
                end
            end)
            if v_u_146 == "mobile_crouch" then
                local function v179()
                    if not v_u_11.IsSliding then
                        task.spawn(v_u_11.MobileInput, v_u_11, "mobile_jump", false)
                    end
                    v_u_149.Icon.Icon.Image = v_u_11.IsSliding and v_u_7.MobileButtons.mobile_jump.Image or (v_u_11.IsSprinting and "rbxassetid://17674207175" or v_u_147.Image)
                end
                v_u_11.StateChanged:Connect(v179)
                if not v_u_11.IsSliding then
                    task.spawn(v_u_11.MobileInput, v_u_11, "mobile_jump", false)
                end
                v_u_149.Icon.Icon.Image = v_u_11.IsSliding and v_u_7.MobileButtons.mobile_jump.Image or (v_u_11.IsSprinting and "rbxassetid://17674207175" or v_u_147.Image)
            end
            p_u_144._buttons[v_u_146] = {
                ["Button"] = v_u_149,
                ["InputFunction"] = v_u_155,
                ["VisualFunction"] = v_u_152,
                ["InputEndedFunction"] = v178,
                ["Button1DownFunction"] = v158,
                ["Button1UpFunction"] = v156
            }
        end
        p_u_144.MobileButtonsFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
            p_u_144:_UpdateButtons()
        end)
        p_u_144:_UpdateButtons()
        p_u_144:_UpdateWeaponButtons()
        p_u_144:_UpdateCameraSinking()
        task.spawn(p_u_144._HookTouchGui, p_u_144)
    end
end
function v_u_20._SetupControls(p_u_180)
    for _, v181 in pairs(p_u_180._connections) do
        v181:Disconnect()
    end
    for _, v182 in pairs(p_u_180._duel_subject_connections) do
        v182:Disconnect()
    end
    p_u_180._connections = {}
    p_u_180._duel_subject_connections = {}
    p_u_180._last_button_tap = 0
    if p_u_180._buttons_generated then
        v_u_11:MobileInput("mobile_shoot", false)
    end
    p_u_180:_UpdateFrameVisibility()
    if p_u_180.IsEnabled then
        task.spawn(p_u_180._HookFighter, p_u_180)
        p_u_180:_GenerateButtons()
        local v_u_183 = nil
        local v184 = p_u_180._connections
        local v185 = v_u_13.InputBegan
        local function v190(p_u_186, _)
            if p_u_186.UserInputType == Enum.UserInputType.Touch then
                local v187 = false
                for _, v188 in pairs(p_u_180._buttons) do
                    if p_u_180.MobileButtonsFrame.Visible and (v188.Button.Visible and p_u_180:_Within(p_u_186.Position.X, p_u_186.Position.Y, v188.Button.AbsolutePosition, v188.Button.AbsoluteSize)) then
                        task.spawn(v188.Button1DownFunction, p_u_186)
                        v187 = true
                    end
                end
                local v189
                if v_u_10:Get("Settings Left Handed Touch Controls") then
                    v189 = p_u_186.Position.X <= p_u_180.MobileButtonsFrame.AbsoluteSize.X / 2
                else
                    v189 = p_u_186.Position.X >= p_u_180.MobileButtonsFrame.AbsoluteSize.X / 2
                end
                if not v187 and v189 then
                    if tick() - p_u_180._last_button_tap > 0.25 then
                        p_u_180._last_button_tap = tick()
                        return
                    end
                    if v_u_10:Get("Settings Double Tap Shoot") or p_u_180.LocalFighter and not (p_u_180.LocalFighter:Get("IsInDuel") or p_u_180.LocalFighter:Get("IsInShootingRange")) then
                        if v_u_183 then
                            v_u_183:Disconnect()
                            v_u_183 = nil
                        end
                        v_u_183 = p_u_186:GetPropertyChangedSignal("UserInputState"):Connect(function()
                            if p_u_186.UserInputState == Enum.UserInputState.End then
                                v_u_183:Disconnect()
                                v_u_11:MobileInput("mobile_shoot", false)
                            end
                        end)
                        v_u_11:MobileInput("mobile_shoot", true)
                    end
                end
            end
        end
        table.insert(v184, v185:Connect(v190))
        local v191 = p_u_180._connections
        local v192 = v_u_13.InputEnded
        table.insert(v191, v192:Connect(function(p193, _)
            if p193.UserInputType == Enum.UserInputType.Touch or p193.UserInputType == Enum.UserInputType.MouseButton1 then
                for _, v194 in pairs(p_u_180._buttons) do
                    v194.InputEndedFunction(p193)
                end
            end
        end))
        local v195 = p_u_180._connections
        local v196 = v_u_11.StateChanged
        local function v197(_)
            if p_u_180.IsEnabled and not v_u_11.IsCrouching then
                p_u_180._buttons.mobile_crouch.InputFunction(false, true)
            end
        end
        table.insert(v195, v196:Connect(v197))
        local v198 = p_u_180._connections
        local v199 = v_u_14.ActiveStateChanged
        table.insert(v198, v199:Connect(function(_)
            p_u_180:_UpdateButtonVisibility()
        end))
        local function v204()
            for _, v200 in pairs(p_u_180._duel_subject_connections) do
                v200:Disconnect()
            end
            p_u_180._duel_subject_connections = {}
            p_u_180:_UpdateButtonVisibility()
            if v_u_12.CurrentDuelSubject then
                local v201 = p_u_180._duel_subject_connections
                local v202 = v_u_12.CurrentDuelSubject.DuelInterface.Voting.VisibilityChanged
                local function v203()
                    p_u_180:_UpdateButtonVisibility()
                end
                table.insert(v201, v202:Connect(v203))
            end
        end
        local v205 = p_u_180._connections
        local v206 = v_u_12.DuelSubjectChanged
        table.insert(v205, v206:Connect(v204))
        v204()
        local v207 = p_u_180._connections
        local v208 = v_u_10:GetDataChangedSignal("MobileButtonProfile")
        table.insert(v207, v208:Connect(function()
            p_u_180:_UpdateButtons()
        end))
        local v209 = p_u_180._connections
        local v210 = v_u_10:GetDataChangedSignal("MobileButtonSettings")
        table.insert(v209, v210:Connect(function()
            p_u_180:_UpdateButtons()
        end))
        local v211 = p_u_180._connections
        local v212 = v_u_15.CanEmoteChanged
        table.insert(v211, v212:Connect(function()
            p_u_180:_UpdateButtonVisibility()
        end))
    end
end
function v_u_20._UpdateControls(p213)
    p213:SetEnabled(v_u_13.CurrentControls == "Touch")
end
function v_u_20._Init(p_u_214)
    v_u_13.ControlsChanged:Connect(function()
        p_u_214:_UpdateControls()
    end)
    v_u_10:GetDataChangedSignal("Settings Camera Mobile Button Sinking"):Connect(function()
        p_u_214:_UpdateCameraSinking()
    end)
    v_u_16.VisibilityChanged:Connect(function()
        p_u_214:_UpdateFrameVisibility()
    end)
    task.defer(p_u_214._UpdateControls, p_u_214)
end
return v_u_20._new()