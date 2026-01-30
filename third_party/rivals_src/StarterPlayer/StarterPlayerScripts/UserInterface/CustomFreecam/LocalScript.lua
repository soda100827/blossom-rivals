local v_u_1 = math.abs
local v_u_2 = math.clamp
local v_u_3 = math.exp
local v_u_4 = math.rad
local v_u_5 = math.sign
local v_u_6 = math.sqrt
local v_u_7 = math.tan
local v_u_8 = game:GetService("ContextActionService")
local v_u_9 = game:GetService("Players")
local v_u_10 = game:GetService("RunService")
game:GetService("StarterGui")
local v_u_11 = game:GetService("UserInputService")
local v_u_12 = game:GetService("Workspace")
local v_u_13 = UserSettings().GameSettings
local v_u_14 = game:GetService("Lighting")
if not v_u_9.LocalPlayer then
    v_u_9:GetPropertyChangedSignal("LocalPlayer"):Wait()
    local _ = v_u_9.LocalPlayer
end
local v_u_15 = v_u_12.CurrentCamera
v_u_12:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    local v16 = v_u_12.CurrentCamera
    if v16 then
        v_u_15 = v16
    end
end)
local v_u_17 = nil
local v18, v19 = pcall(function()
    return UserSettings():IsUserFeatureEnabled("UserExitFreecamBreaksWithShiftlock")
end)
local v_u_20 = v18 and v19
local v21, v22 = pcall(function()
    return UserSettings():IsUserFeatureEnabled("UserShowGuiHideToggles")
end)
local v_u_23 = v21 and v22
local v24, v25 = pcall(function()
    return UserSettings():IsUserFeatureEnabled("UserFixFreecamDeltaTimeCalculation")
end)
local v_u_26 = v24 and v25
local v27, v28 = pcall(function()
    return UserSettings():IsUserFeatureEnabled("UserFixFreecamGuiChangeVisibility")
end)
local v_u_29 = v27 and v28
local v30, v31 = pcall(function()
    return UserSettings():IsUserFeatureEnabled("UserFreecamControlSpeed")
end)
local v_u_32 = v30 and v31
local v33, v34 = pcall(function()
    return UserSettings():IsUserFeatureEnabled("UserFreecamTiltControl")
end)
local v_u_35 = v33 and v34
local v36, v37 = pcall(function()
    return UserSettings():IsUserFeatureEnabled("UserFreecamSmoothnessControl")
end)
local v_u_38 = v36 and v37
local v39, v40 = pcall(function()
    return UserSettings():IsUserFeatureEnabled("UserFreecamGuiDestabilization")
end)
local v_u_41 = v39 and v40
local v42, v43 = pcall(function()
    return UserSettings():IsUserFeatureEnabled("UserFreecamDepthOfFieldEffect")
end)
local v_u_44 = v42 and v43
local _ = Enum.ContextActionPriority.Low.Value
local v_u_45 = Enum.ContextActionPriority.High.Value
local _ = { Enum.KeyCode.LeftShift, Enum.KeyCode.P }
local v_u_46 = {
    [Enum.KeyCode.Z] = true,
    [Enum.KeyCode.C] = true
}
local v_u_47 = {
    [Enum.KeyCode.ButtonL1] = true,
    [Enum.KeyCode.ButtonR1] = true
}
local v_u_48 = {
    [Enum.KeyCode.BackSlash] = true
}
local v_u_49 = Vector2.new(0.75, 1) * 8
local v_u_50 = 5
local v_u_51 = 5
local v_u_52 = 4
local v_u_53 = 5
local v_u_54 = {}
local v_u_55 = 0
local v_u_56 = {}
local v_u_57 = {}
v_u_57.__index = v_u_57
function v_u_57.new(p58, p59)
    local v60 = v_u_57
    local v61 = setmetatable({}, v60)
    v61.f = p58
    v61.p = p59
    v61.v = p59 * 0
    return v61
end
function v_u_57.Update(p62, p63, p64)
    local v65 = p62.f * 2 * 3.141592653589793
    local v66 = p62.p
    local v67 = p62.v
    local v68 = p64 - v66
    local v69 = v_u_3(-v65 * p63)
    local v70 = p64 + (v67 * p63 - v68 * (v65 * p63 + 1)) * v69
    local v71 = (v65 * p63 * (v68 * v65 - v67) + v67) * v69
    p62.p = v70
    p62.v = v71
    return v70
end
function v_u_57.SetFreq(p72, p73)
    p72.f = p73
end
function v_u_57.Reset(p74, p75)
    p74.p = p75
    p74.v = p75 * 0
end
local v_u_76 = Vector3.new()
local v_u_77
if v_u_35 then
    v_u_77 = Vector3.new()
else
    v_u_77 = Vector2.new()
end
local v_u_78 = 0
local v_u_79 = v_u_57.new(v_u_50, (Vector3.new()))
local v_u_80 = v_u_57.new(v_u_51, Vector2.new())
local v_u_81 = v_u_57.new(v_u_52, 0)
local v_u_82 = v_u_57.new(v_u_53, 0)
local v_u_83 = {}
local function v_u_85(p84)
    return v_u_5(p84) * v_u_2((v_u_3(2 * ((v_u_1(p84) - 0.15) / 0.85)) - 1) / 6.38905609893065, 0, 1)
end
local v_u_86 = {
    ["ButtonX"] = 0,
    ["ButtonY"] = 0,
    ["DPadDown"] = 0,
    ["DPadUp"] = 0,
    ["DPadLeft"] = 0,
    ["DPadRight"] = 0,
    ["ButtonL2"] = 0,
    ["ButtonR2"] = 0,
    ["ButtonL1"] = 0,
    ["ButtonR1"] = 0,
    ["Thumbstick1"] = Vector2.new(),
    ["Thumbstick2"] = Vector2.new()
}
local v_u_87 = {
    ["W"] = 0,
    ["A"] = 0,
    ["S"] = 0,
    ["D"] = 0,
    ["E"] = 0,
    ["Q"] = 0,
    ["U"] = 0,
    ["H"] = 0,
    ["J"] = 0,
    ["K"] = 0,
    ["I"] = 0,
    ["Y"] = 0,
    ["Up"] = 0,
    ["Down"] = 0,
    ["Left"] = 0,
    ["Right"] = 0,
    ["LeftShift"] = 0,
    ["RightShift"] = 0,
    ["Z"] = 0,
    ["C"] = 0,
    ["Comma"] = 0,
    ["Period"] = 0,
    ["LeftBracket"] = 0,
    ["RightBracket"] = 0,
    ["Semicolon"] = 0,
    ["Quote"] = 0,
    ["V"] = 0,
    ["B"] = 0,
    ["N"] = 0,
    ["M"] = 0,
    ["BackSlash"] = 0,
    ["Minus"] = 0,
    ["Equals"] = 0
}
local v_u_88 = {
    ["Delta"] = Vector2.new(),
    ["MouseWheel"] = 0
}
local v_u_89 = Vector2.new(1, 1) * 0.04908738521234052
local v_u_90 = v_u_89 / 60
local v_u_91 = Vector2.new(1, 1) * 0.39269908169872414
local v_u_92 = {
    ["FarIntensity"] = {
        ["ADJ"] = 0.1,
        ["MIN"] = 0,
        ["MAX"] = 1
    },
    ["NearIntensity"] = {
        ["ADJ"] = 0.1,
        ["MIN"] = 0,
        ["MAX"] = 1
    },
    ["FocusDistance"] = {
        ["ADJ"] = 20,
        ["MIN"] = 0,
        ["MAX"] = 200
    },
    ["FocusRadius"] = {
        ["ADJ"] = 5,
        ["MIN"] = 0,
        ["MAX"] = 50
    }
}
local v_u_93 = 1
local v_u_94 = 1
local v_u_95 = 1
function v_u_83.Vel(p96)
    if v_u_32 then
        v_u_93 = v_u_2(v_u_93 + p96 * (v_u_87.Up - v_u_87.Down + v_u_86.DPadUp - v_u_86.DPadDown) * 0.75, 0.01, 4)
    else
        v_u_93 = v_u_2(v_u_93 + p96 * (v_u_87.Up - v_u_87.Down) * 0.75, 0.01, 4)
    end
    local v97 = v_u_85(v_u_86.Thumbstick1.X)
    local v98 = v_u_85(v_u_86.ButtonR2) - v_u_85(v_u_86.ButtonL2)
    local v99 = v_u_85
    local v100 = -v_u_86.Thumbstick1.Y
    local v101 = Vector3.new(v97, v98, v99(v100)) * Vector3.new(1, 1, 1)
    local v102 = v_u_87.D - v_u_87.A + v_u_87.K - v_u_87.H
    local v103 = v_u_87.E - v_u_87.Q + v_u_87.I - v_u_87.Y
    local v104 = v_u_87.S - v_u_87.W + v_u_87.J - v_u_87.U
    local v105 = Vector3.new(v102, v103, v104) * Vector3.new(1, 1, 1)
    local v106 = v_u_11:IsKeyDown(Enum.KeyCode.LeftShift) or v_u_11:IsKeyDown(Enum.KeyCode.RightShift)
    return (v101 + v105) * (v_u_93 * (v106 and 0.25 or 1))
end
function v_u_83.Pan(p107)
    local v108 = Vector2.new(v_u_85(v_u_86.Thumbstick2.Y), v_u_85(-v_u_86.Thumbstick2.X)) * v_u_91
    local v109 = v_u_88.Delta * v_u_89
    if v_u_26 and p107 > 0 then
        v109 = v_u_88.Delta / p107 * v_u_90
    end
    v_u_88.Delta = Vector2.new()
    return v108 + v109
end
function v_u_83.Fov(p110)
    if v_u_32 then
        v_u_95 = v_u_2(v_u_95 + p110 * (v_u_87.Right - v_u_87.Left + v_u_86.DPadRight - v_u_86.DPadLeft) * 0.75, 0.01, 4)
    end
    local v111 = (v_u_86.ButtonX - v_u_86.ButtonY) * 0.25
    local v112 = v_u_88.MouseWheel * 1
    if v_u_26 and p110 > 0 then
        v112 = v_u_88.MouseWheel / p110 * 0.016666666666666666
    end
    v_u_88.MouseWheel = 0
    if v_u_32 then
        return (v111 + v112) * v_u_95
    else
        return v111 + v112
    end
end
function v_u_83.Roll(p113)
    v_u_94 = v_u_2(v_u_94 + p113 * (v_u_87.Period - v_u_87.Comma) * 0.75, 0.01, 4)
    return ((v_u_86.ButtonR1 - v_u_86.ButtonL1) * 1 + (v_u_87.C - v_u_87.Z) * 1) * v_u_94
end
function v_u_83.SpringControl(p114)
    if not (v_u_44 and (v_u_11:IsKeyDown(Enum.KeyCode.LeftShift) or v_u_11:IsKeyDown(Enum.KeyCode.RightShift) or (v_u_11:IsKeyDown(Enum.KeyCode.LeftControl) or v_u_11:IsKeyDown(Enum.KeyCode.RightControl)))) then
        v_u_50 = v_u_2(v_u_50 + p114 * (v_u_87.RightBracket - v_u_87.LeftBracket) * 0.75, 0.01, 10)
        v_u_79:SetFreq(v_u_50)
        v_u_51 = v_u_2(v_u_51 + p114 * (v_u_87.Quote - v_u_87.Semicolon) * 0.75, 0.01, 10)
        v_u_80:SetFreq(v_u_51)
        v_u_52 = v_u_2(v_u_52 + p114 * (v_u_87.B - v_u_87.V) * 0.75, 0.01, 10)
        v_u_81:SetFreq(v_u_52)
        v_u_53 = v_u_2(v_u_53 + p114 * (v_u_87.M - v_u_87.N) * 0.75, 0.01, 10)
        v_u_82:SetFreq(v_u_53)
    end
end
function v_u_83.DoF(p115)
    local v116 = v_u_11:IsKeyDown(Enum.KeyCode.LeftShift) or v_u_11:IsKeyDown(Enum.KeyCode.RightShift)
    local v117 = v_u_11:IsKeyDown(Enum.KeyCode.LeftControl) or v_u_11:IsKeyDown(Enum.KeyCode.RightControl)
    if v116 then
        v_u_17.FarIntensity = v_u_2(v_u_17.FarIntensity + p115 * (v_u_87.RightBracket - v_u_87.LeftBracket) * v_u_92.FarIntensity.ADJ, v_u_92.FarIntensity.MIN, v_u_92.FarIntensity.MAX)
        v_u_17.InFocusRadius = v_u_2(v_u_17.InFocusRadius + p115 * (v_u_87.Equals - v_u_87.Minus) * v_u_92.FocusRadius.ADJ, v_u_92.FocusRadius.MIN, v_u_92.FocusRadius.MAX)
        return
    elseif v117 then
        v_u_17.NearIntensity = v_u_2(v_u_17.NearIntensity + p115 * (v_u_87.RightBracket - v_u_87.LeftBracket) * v_u_92.NearIntensity.ADJ, v_u_92.NearIntensity.MIN, v_u_92.NearIntensity.MAX)
    else
        v_u_17.FocusDistance = v_u_2(v_u_17.FocusDistance + p115 * (v_u_87.Equals - v_u_87.Minus) * v_u_92.FocusDistance.ADJ, v_u_92.FocusDistance.MIN, v_u_92.FocusDistance.MAX)
    end
end
local function v_u_129(p118)
    local v119 = os.clock()
    local v120 = v_u_54[p118]
    if v120 and ((v120 and (v119 - v120 or -1) or -1) <= 0.25 and v119 - v_u_55 >= 0.1) then
        local v121 = v_u_77.x
        local v122 = v_u_77.y
        v_u_77 = Vector3.new(v121, v122, 0)
        v_u_82:Reset(0)
        if v_u_44 then
            local v123 = v_u_47
            local v124 = v_u_86
            for v125, _ in pairs(v123) do
                if v124[v125.Name] then
                    v124[v125.Name] = 0
                end
            end
            local v126 = v_u_46
            local v127 = v_u_87
            for v128, _ in pairs(v126) do
                if v127[v128.Name] then
                    v127[v128.Name] = 0
                end
            end
        else
            v_u_86.ButtonL1 = 0
            v_u_86.ButtonR1 = 0
            v_u_87.C = 0
            v_u_87.Z = 0
        end
        v_u_55 = v119
    end
    v_u_54[p118] = v119
end
local function v_u_140(_, p130, p131)
    v_u_87[p131.KeyCode.Name] = p130 == Enum.UserInputState.Begin and 1 or 0
    if v_u_35 and (v_u_46[p131.KeyCode] and p131.UserInputState == Enum.UserInputState.Begin) then
        v_u_129(p131.KeyCode)
    end
    if v_u_44 and (v_u_48[p131.KeyCode] and p131.UserInputState == Enum.UserInputState.Begin) then
        if v_u_17.Enabled then
            for _, v132 in ipairs(v_u_56) do
                if v132.Parent then
                    v132.Enabled = true
                end
            end
            v_u_56 = {}
        else
            v_u_56 = {}
            for _, v133 in ipairs(v_u_15:GetChildren()) do
                if v133:IsA("DepthOfFieldEffect") and v133.Enabled then
                    v_u_56[#v_u_56 + 1] = v133
                    v133.Enabled = false
                end
            end
            for _, v134 in ipairs(v_u_14:GetChildren()) do
                if v134:IsA("DepthOfFieldEffect") and v134.Enabled then
                    v_u_56[#v_u_56 + 1] = v134
                    v134.Enabled = false
                end
            end
            v_u_15.ChildAdded:Connect(function(p135)
                if p135:IsA("DepthOfFieldEffect") and p135.Enabled then
                    v_u_56[#v_u_56 + 1] = p135
                    p135.Enabled = false
                end
            end)
            v_u_14.ChildAdded:Connect(function(p136)
                if p136:IsA("DepthOfFieldEffect") and p136.Enabled then
                    v_u_56[#v_u_56 + 1] = p136
                    p136.Enabled = false
                end
            end)
        end
        v_u_17.Enabled = not v_u_17.Enabled
        local v137 = v_u_48
        local v138 = v_u_87
        for v139, _ in pairs(v137) do
            if v138[v139.Name] then
                v138[v139.Name] = 0
            end
        end
    end
    return Enum.ContextActionResult.Sink
end
local function v_u_143(_, p141, p142)
    v_u_86[p142.KeyCode.Name] = p141 == Enum.UserInputState.Begin and 1 or 0
    if v_u_35 and (v_u_47[p142.KeyCode] and p142.UserInputState == Enum.UserInputState.Begin) then
        v_u_129(p142.KeyCode)
    end
    return Enum.ContextActionResult.Sink
end
local function v_u_146(_, _, p144)
    local v145 = p144.Delta
    v_u_88.Delta = Vector2.new(-v145.y, -v145.x)
    return Enum.ContextActionResult.Sink
end
local function v_u_148(_, _, p147)
    v_u_86[p147.KeyCode.Name] = p147.Position
    return Enum.ContextActionResult.Sink
end
local function v_u_150(_, _, p149)
    v_u_86[p149.KeyCode.Name] = p149.Position.z
    return Enum.ContextActionResult.Sink
end
local function v_u_152(_, _, p151)
    v_u_88[p151.UserInputType.Name] = -p151.Position.z
    return Enum.ContextActionResult.Sink
end
function v_u_83.StartCapture()
    if v_u_32 then
        v_u_8:BindActionAtPriority("FreecamKeyboard", v_u_140, false, v_u_45, Enum.KeyCode.W, Enum.KeyCode.U, Enum.KeyCode.A, Enum.KeyCode.H, Enum.KeyCode.S, Enum.KeyCode.J, Enum.KeyCode.D, Enum.KeyCode.K, Enum.KeyCode.E, Enum.KeyCode.I, Enum.KeyCode.Q, Enum.KeyCode.Y)
        v_u_8:BindActionAtPriority("FreecamKeyboardControlSpeed", v_u_140, false, v_u_45, Enum.KeyCode.Up, Enum.KeyCode.Down, Enum.KeyCode.Left, Enum.KeyCode.Right)
        v_u_8:BindActionAtPriority("FreecamGamepadControlSpeed", v_u_143, false, v_u_45, Enum.KeyCode.DPadUp, Enum.KeyCode.DPadDown, Enum.KeyCode.DPadLeft, Enum.KeyCode.DPadRight)
    else
        v_u_8:BindActionAtPriority("FreecamKeyboard", v_u_140, false, v_u_45, Enum.KeyCode.W, Enum.KeyCode.U, Enum.KeyCode.A, Enum.KeyCode.H, Enum.KeyCode.S, Enum.KeyCode.J, Enum.KeyCode.D, Enum.KeyCode.K, Enum.KeyCode.E, Enum.KeyCode.I, Enum.KeyCode.Q, Enum.KeyCode.Y, Enum.KeyCode.Up, Enum.KeyCode.Down)
    end
    if v_u_35 then
        v_u_8:BindActionAtPriority("FreecamKeyboardTiltControl", v_u_140, false, v_u_45, Enum.KeyCode.Z, Enum.KeyCode.C)
        v_u_8:BindActionAtPriority("FreecamGamepadTiltControl", v_u_143, false, v_u_45, Enum.KeyCode.ButtonL1, Enum.KeyCode.ButtonR1)
        v_u_8:BindActionAtPriority("FreecamKeyboardTiltControlSpeed", v_u_140, false, v_u_45, Enum.KeyCode.Comma, Enum.KeyCode.Period)
        if v_u_38 then
            v_u_8:BindActionAtPriority("FreecamKeyboardSmoothnessControl", v_u_140, false, v_u_45, Enum.KeyCode.LeftBracket, Enum.KeyCode.RightBracket, Enum.KeyCode.Semicolon, Enum.KeyCode.Quote, Enum.KeyCode.V, Enum.KeyCode.B, Enum.KeyCode.N, Enum.KeyCode.M)
        end
    end
    if v_u_44 then
        v_u_8:BindActionAtPriority("FreecamKeyboardDoFToggle", v_u_140, false, v_u_45, Enum.KeyCode.BackSlash)
        v_u_8:BindActionAtPriority("FreecamKeyboardDoFControls", v_u_140, false, v_u_45, Enum.KeyCode.Minus, Enum.KeyCode.Equals)
    end
    v_u_8:BindActionAtPriority("FreecamMousePan", v_u_146, false, v_u_45, Enum.UserInputType.MouseMovement)
    v_u_8:BindActionAtPriority("FreecamMouseWheel", v_u_152, false, v_u_45, Enum.UserInputType.MouseWheel)
    v_u_8:BindActionAtPriority("FreecamGamepadButton", v_u_143, false, v_u_45, Enum.KeyCode.ButtonX, Enum.KeyCode.ButtonY)
    v_u_8:BindActionAtPriority("FreecamGamepadTrigger", v_u_150, false, v_u_45, Enum.KeyCode.ButtonR2, Enum.KeyCode.ButtonL2)
    v_u_8:BindActionAtPriority("FreecamGamepadThumbstick", v_u_148, false, v_u_45, Enum.KeyCode.Thumbstick1, Enum.KeyCode.Thumbstick2)
end
function v_u_83.StopCapture()
    v_u_93 = 1
    if v_u_32 then
        v_u_95 = 1
    end
    if v_u_35 then
        v_u_94 = 1
    end
    local v153 = v_u_86
    for v154, v155 in pairs(v153) do
        v153[v154] = v155 * 0
    end
    local v156 = v_u_87
    for v157, v158 in pairs(v156) do
        v156[v157] = v158 * 0
    end
    local v159 = v_u_88
    for v160, v161 in pairs(v159) do
        v159[v160] = v161 * 0
    end
    v_u_8:UnbindAction("FreecamKeyboard")
    if v_u_32 then
        v_u_8:UnbindAction("FreecamKeyboardControlSpeed")
        v_u_8:UnbindAction("FreecamGamepadControlSpeed")
    end
    if v_u_35 then
        v_u_8:UnbindAction("FreecamKeyboardTiltControl")
        v_u_8:UnbindAction("FreecamGamepadTiltControl")
        v_u_8:UnbindAction("FreecamKeyboardTiltControlSpeed")
        if v_u_38 then
            v_u_8:UnbindAction("FreecamKeyboardSmoothnessControl")
        end
    end
    if v_u_44 then
        v_u_8:UnbindAction("FreecamKeyboardDoFToggle")
        v_u_8:UnbindAction("FreecamKeyboardDoFControls")
    end
    v_u_8:UnbindAction("FreecamMousePan")
    v_u_8:UnbindAction("FreecamMouseWheel")
    v_u_8:UnbindAction("FreecamGamepadButton")
    v_u_8:UnbindAction("FreecamGamepadTrigger")
    v_u_8:UnbindAction("FreecamGamepadThumbstick")
end
local function v_u_179(p162)
    local v163 = v_u_15.ViewportSize
    local v164 = v_u_7(v_u_78 / 2) * 2
    local v165 = v163.x / v163.y * v164
    local v166 = p162.rightVector
    local v167 = p162.upVector
    local v168 = p162.lookVector
    local v169 = Vector3.new()
    local v170 = 512
    for v171 = 0, 1, 0.5 do
        for v172 = 0, 1, 0.5 do
            local v173 = (v171 - 0.5) * v165
            local v174 = (v172 - 0.5) * v164
            local v175 = v166 * v173 - v167 * v174 + v168
            local v176 = p162.p + v175 * 0.1
            local _, v177 = v_u_12:FindPartOnRay(Ray.new(v176, v175.unit * v170))
            local v178 = (v177 - v176).magnitude
            if v178 < v170 then
                v169 = v175.unit
                v170 = v178
            end
        end
    end
    return v168:Dot(v169) * v170
end
local function v_u_198(p180)
    if v_u_38 then
        v_u_83.SpringControl(p180)
    end
    if v_u_44 and (v_u_17 and v_u_17.Parent) then
        v_u_83.DoF(p180)
    end
    local v181 = v_u_79:Update(p180, v_u_83.Vel(p180))
    local v182 = v_u_80:Update(p180, v_u_83.Pan(p180))
    local v183 = v_u_81:Update(p180, v_u_83.Fov(p180))
    local v184
    if v_u_35 then
        v184 = v_u_82:Update(p180, v_u_83.Roll(p180))
    else
        v184 = nil
    end
    local v185 = v_u_6(0.7002075382097097 / v_u_7((v_u_4(v_u_78 / 2))))
    v_u_78 = v_u_2(v_u_78 + v183 * 300 * (p180 / v185), 1, 120)
    local v186
    if v_u_35 then
        local v187 = v182 * v_u_49 * (p180 / v185)
        local v188 = v_u_77
        local v189 = v187.X
        local v190 = v187.Y
        local v191 = v184 * -1.5707963267948966 * (p180 / v185)
        v_u_77 = v188 + Vector3.new(v189, v190, v191)
        if v_u_38 then
            local v192 = v_u_77.x % 6.283185307179586
            local v193 = v_u_77.y % 6.283185307179586
            local v194 = v_u_77.z % 6.283185307179586
            v_u_77 = Vector3.new(v192, v193, v194)
        else
            local v195 = v_u_2(v_u_77.x, -1.5707963267948966, 1.5707963267948966)
            local v196 = v_u_77.y % 6.283185307179586
            local v197 = v_u_77.z
            v_u_77 = Vector3.new(v195, v196, v197)
        end
        v186 = CFrame.new(v_u_76) * CFrame.fromOrientation(v_u_77.x, v_u_77.y, v_u_77.z) * CFrame.new(v181 * Vector3.new(50, 50, 50) * p180)
    else
        v_u_77 = v_u_77 + v182 * v_u_49 * (p180 / v185)
        v_u_77 = Vector2.new(v_u_2(v_u_77.x, -1.5707963267948966, 1.5707963267948966), v_u_77.y % 6.283185307179586)
        v186 = CFrame.new(v_u_76) * CFrame.fromOrientation(v_u_77.x, v_u_77.y, 0) * CFrame.new(v181 * Vector3.new(50, 50, 50) * p180)
    end
    v_u_76 = v186.p
    v_u_15.CFrame = v186
    v_u_15.Focus = v186 * CFrame.new(0, 0, -v_u_179(v186))
    v_u_15.FieldOfView = v_u_78
end
local v_u_199 = {}
local v_u_200 = nil
local v_u_201 = nil
local v_u_202 = nil
local v_u_203 = nil
local v_u_204 = nil
local v_u_205 = nil
local v_u_206 = {}
function v_u_199.Push()
    v_u_205 = v_u_15.FieldOfView
    v_u_15.FieldOfView = 70
    v_u_202 = v_u_15.CameraType
    v_u_15.CameraType = Enum.CameraType.Custom
    v_u_204 = v_u_15.CFrame
    v_u_203 = v_u_15.Focus
    v_u_201 = v_u_11.MouseIconEnabled
    v_u_11.MouseIconEnabled = true
    if v_u_20 then
        local v207 = v_u_9.LocalPlayer.DevEnableMouseLock
        local v208 = v_u_9.LocalPlayer.DevComputerMovementMode == Enum.DevComputerMovementMode.Scriptable
        local v209 = v207 and (v_u_13.ControlMode == Enum.ControlMode.MouseLockSwitch and v_u_13.ComputerMovementMode ~= Enum.ComputerMovementMode.ClickToMove)
        if v209 then
            v209 = not v208
        end
        if v209 then
            v_u_200 = Enum.MouseBehavior.Default
            ::l17::
            v_u_11.MouseBehavior = Enum.MouseBehavior.Default
            return
        end
    end
    v_u_200 = v_u_11.MouseBehavior
    goto l17
end
function v_u_199.Pop()
    if v_u_29 then
        v_u_206 = {}
    end
    v_u_15.FieldOfView = v_u_205
    v_u_205 = nil
    v_u_15.CameraType = v_u_202
    v_u_202 = nil
    v_u_15.CFrame = v_u_204
    v_u_204 = nil
    v_u_15.Focus = v_u_203
    v_u_203 = nil
    v_u_11.MouseIconEnabled = v_u_201
    v_u_201 = nil
    v_u_11.MouseBehavior = v_u_200
    v_u_200 = nil
end
local function v_u_211()
    if not v_u_41 and v_u_23 then
        script:SetAttribute("FreecamEnabled", true)
    end
    local v210 = v_u_15.CFrame
    if v_u_35 then
        v_u_77 = Vector3.new(v210:toEulerAnglesYXZ())
    else
        v_u_77 = Vector2.new(v210:toEulerAnglesYXZ())
    end
    v_u_76 = v210.p
    v_u_78 = v_u_15.FieldOfView
    v_u_79:Reset((Vector3.new()))
    v_u_80:Reset(Vector2.new())
    v_u_81:Reset(0)
    if v_u_35 then
        v_u_82:Reset(0)
    end
    if v_u_38 then
        v_u_50 = 1.5
        v_u_51 = 1
        v_u_52 = 4
        v_u_53 = 1
    end
    v_u_199.Push()
    if v_u_44 and not (v_u_17 and v_u_17.Parent) then
        v_u_17 = Instance.new("DepthOfFieldEffect")
        v_u_17.Enabled = false
        v_u_17.Name = "FreecamDepthOfField"
        v_u_17.Parent = v_u_15
    end
    v_u_10:BindToRenderStep("CustomFreecam", Enum.RenderPriority.Camera.Value, v_u_198)
    v_u_83.StartCapture()
end
local function v_u_213()
    if not v_u_41 and v_u_23 then
        script:SetAttribute("FreecamEnabled", false)
    end
    if v_u_44 and (v_u_17 and v_u_17.Parent) then
        if v_u_17.Enabled then
            for _, v212 in ipairs(v_u_56) do
                if v212.Parent then
                    v212.Enabled = true
                end
            end
            v_u_56 = {}
        end
        v_u_17.Enabled = false
    end
    v_u_83.StopCapture()
    v_u_10:UnbindFromRenderStep("CustomFreecam")
    v_u_199.Pop()
end
local v_u_214 = false
script:WaitForChild("Toggle").Event:Connect(function(p215)
    if p215 and not v_u_214 then
        v_u_211()
    elseif not p215 and v_u_214 then
        v_u_213()
    end
    v_u_214 = p215
end)