local v_u_1 = game:GetService("LocalizationService")
local v_u_2 = game:GetService("CollectionService")
local v_u_3 = game:GetService("ReplicatedStorage")
local v_u_4 = game:GetService("UserInputService")
game:GetService("ServerStorage")
local v_u_5 = game:GetService("SoundService")
local v_u_6 = game:GetService("Players")
local v_u_7 = require(v_u_3.Modules.CONSTANTS)
local v_u_8 = require(v_u_3.Modules.ServerOsTime)
local v_u_9 = require(v_u_3.Modules.BetterDebris)
local v_u_10 = require(v_u_3.Modules.EnumLibrary)
local v_u_11 = require(script:WaitForChild("RenderstepForLoop"))
local v_u_12 = { "rbxassetid://17662038408", "rbxassetid://17662038274", "rbxassetid://17662037971" }
local v_u_13 = {
    ["a"] = true,
    ["e"] = true,
    ["i"] = true,
    ["o"] = true,
    ["u"] = true
}
local v_u_14 = {}
v_u_14.__index = v_u_14
function v_u_14._new()
    local v15 = v_u_14
    local v16 = setmetatable({}, v15)
    v16._particle_hashes = {}
    v16._name_to_input_enum = nil
    v16._search_translator = nil
    v16:_Init()
    return v16
end
function v_u_14.IsUIElementVisible(p17, p18)
    local v19 = p18:IsDescendantOf(v_u_6.LocalPlayer.PlayerGui) or p18:IsDescendantOf(workspace)
    if v19 then
        v19 = p17:_RecursiveIsUIElementVisible(p18)
    end
    return v19
end
function v_u_14.IsTextBoxFocused(_)
    local v20, v21 = pcall(v_u_4.GetFocusedTextBox, v_u_4)
    return not v20 or v21
end
function v_u_14.IsAprilFools(_)
    DateTime.fromUnixTimestamp(v_u_8:Get()):ToUniversalTime()
    return false
end
function v_u_14.DarkenColor(_, p22, p23)
    return Color3.new(p22.R * p23, p22.G * p23, p22.B * p23)
end
function v_u_14.IsWithinRotatedShape(_, p24, p25, p26, p27)
    if p27 == Enum.PartType.Ball then
        local v28 = (p24 - p25.Position).Magnitude
        local v29 = p26.X
        local v30 = p26.Y
        local v31 = p26.Z
        return v28 <= math.max(v29, v30, v31) / 2
    elseif p27 == Enum.PartType.Cylinder then
        local v32 = p25:PointToObjectSpace(p24)
        local v33
        if v32.X >= -p26.X / 2 and v32.X <= p26.X / 2 then
            local v34 = v32.Y ^ 2 + v32.Z ^ 2
            local v35 = math.sqrt(v34)
            local v36 = p26.Y
            local v37 = p26.Z
            v33 = v35 <= math.max(v36, v37) / 2
        else
            v33 = false
        end
        return v33
    else
        local v38 = p25:PointToObjectSpace(p24)
        local v39
        if v38.X >= -p26.X / 2 and (v38.X <= p26.X / 2 and (v38.Y >= -p26.Y / 2 and (v38.Y <= p26.Y / 2 and v38.Z >= -p26.Z / 2))) then
            v39 = v38.Z <= p26.Z / 2
        else
            v39 = false
        end
        return v39
    end
end
function v_u_14.IsWithinPart(_, p40, p41, p42)
    local v43 = (p40.Position - p41).Magnitude
    local v44 = p40.Size.X
    local v45 = p40.Size.Y
    local v46 = p40.Size.Z
    local v47
    if v43 < math.max(v44, v45, v46) * 1.7320508075688772 then
        v47 = v_u_14:IsWithinRotatedShape(p41, p40.CFrame, p40.Size + (p42 or Vector3.new(0, 0, 0)), p40.ClassName == "Part" and p40.Shape or Enum.PartType.Block)
    else
        v47 = false
    end
    return v47
end
function v_u_14.IsWithinTaggedParts(p48, p49, p50, p51, p52)
    local v53 = {}
    for _, v54 in pairs(v_u_2:GetTagged(p49)) do
        if p48:IsWithinPart(v54, p50, p51) then
            if not p52 then
                return v54
            end
            table.insert(v53, v54)
        end
    end
    if p52 then
        return v53
    else
        return nil
    end
end
function v_u_14.LookThrough(p55, p56, p57)
    for _, v58 in pairs(p56:GetChildren()) do
        if v58:IsA("Model") and v58.Name == p57 then
            return v58
        end
        if v58:IsA("Folder") then
            local v59 = p55:LookThrough(v58, p57)
            if v59 then
                return v59
            end
        end
    end
end
function v_u_14.SilentWaitForChild(_, p60, p61)
    while not p60:FindFirstChild(p61) do
        p60.ChildAdded:Wait()
    end
    return p60[p61]
end
function v_u_14.WaitForChildRecursive(_, p_u_62, p_u_63, p_u_64)
    local v65 = p_u_62:FindFirstChild(p_u_63, true)
    if v65 then
        return v65
    end
    local v_u_66 = Instance.new("BindableEvent")
    if p_u_64 then
        task.delay(p_u_64, v_u_66.Fire, v_u_66, nil)
    end
    task.defer(function()
        local v_u_67 = false
        if not p_u_64 then
            task.delay(5, function()
                if not v_u_67 then
                    warn("Infinite yield possible for", p_u_62:GetFullName() .. ":WaitForChildRecursive(\"" .. p_u_63 .. "\")")
                end
            end)
        end
        while true do
            local v68 = p_u_62:FindFirstChild(p_u_63, true)
            if v68 then
                break
            end
            p_u_62.DescendantAdded:Wait()
        end
        v_u_66:Fire(v68)
    end)
    return v_u_66.Event:Wait()
end
function v_u_14.GetTaggedIn(_, p69, p70)
    local v71 = {}
    for _, v72 in pairs(v_u_2:GetTagged(p69)) do
        if v72:IsDescendantOf(p70 or workspace) then
            table.insert(v71, v72)
        end
    end
    return v71
end
function v_u_14.GetCharacterModel(p73, p74)
    if p74 and p74 ~= workspace then
        if v_u_6:GetPlayerFromCharacter(p74) then
            return p74
        else
            return p73:GetCharacterModel(p74.Parent)
        end
    else
        return nil
    end
end
function v_u_14.GetProperArticle(_, p75)
    local v76 = v_u_13
    local v77 = string.lower(p75)
    return "a" .. (v76[string.sub(v77, 1, 1)] and "n" or "")
end
function v_u_14.AntiBarcodeNames(_, p78)
    local v79 = 0
    local v80 = ""
    for v81 = 1, #p78 do
        local v82 = string.sub(p78, v81, v81)
        if v82 == "l" or v82 == "I" then
            v79 = v79 + 1
            v80 = v80 .. (v82 == "l" and "L" or (v82 == "I" and "i" or v82))
        else
            v80 = v80 .. v82
        end
    end
    if v79 > 3 then
        p78 = v80 or p78
    end
    return p78
end
function v_u_14.AntiCircleNames(_, p83)
    local v84 = 0
    local v85 = ""
    for v86 = 1, #p83 do
        local v87 = string.sub(p83, v86, v86)
        if v87 == "O" or v87 == "0" then
            v84 = v84 + 1
            v85 = v85 .. (v87 == "O" and "o" or v87)
        else
            v85 = v85 .. v87
        end
    end
    if v84 > 3 then
        p83 = v85 or p83
    end
    return p83
end
function v_u_14.SanitizeName(p88, p89)
    return p88:AntiCircleNames((p88:AntiBarcodeNames(p89)))
end
function v_u_14.GetName(_, p90, p91, p92)
    local v93
    if p90.HasVerifiedBadge then
        v93 = " " .. utf8.char(57344)
    else
        v93 = (p92 or p90.MembershipType ~= Enum.MembershipType.Premium) and "" or " " .. utf8.char(57345)
    end
    return p91 .. v93
end
function v_u_14.GetConnectionLevelIcon(_, p94)
    return v_u_12[p94]
end
function v_u_14.GetConnectionLevel(_, p95)
    return p95 < 60 and 3 or (p95 < 150 and 2 or 1)
end
function v_u_14.GetLocalConnectionPing(_, p96)
    local v97 = (p96 or v_u_6.LocalPlayer):GetNetworkPing() * 1000
    return math.floor(v97)
end
function v_u_14.DisableTextures(_, p98)
    for _, v99 in pairs(p98:GetDescendants()) do
        if not v99:HasTag("DisabledTexturesBlacklist") then
            if v99:IsA("Light") then
                v99.Shadows = false
            elseif v99:IsA("BasePart") then
                for _, v100 in pairs(Enum.NormalId:GetEnumItems()) do
                    v99[v100.Name .. "Surface"] = Enum.SurfaceType.Smooth
                end
                if v99.Material ~= Enum.Material.ForceField and v99.Material ~= Enum.Material.Neon then
                    v99.Material = Enum.Material.SmoothPlastic
                    v99.MaterialVariant = ""
                end
            elseif (v99:IsA("Texture") or v99:IsA("Decal")) and v99.Texture ~= "rbxassetid://7658055825" then
                v99:Destroy()
            end
        end
    end
end
function v_u_14.IsVisibleFromSearch(p101, p102, ...)
    if not p102 or p102 == "" then
        return true
    end
    local v103 = { ... }
    for v104 = 1, #v103, 2 do
        local v105 = v103[v104]
        if v105 then
            local v106 = v103[v104 + 1] or game
            if p101._search_translator then
                local v107, v108 = pcall(p101._search_translator.Translate, p101._search_translator, v106, v105)
                if v107 then
                    v105 = string.lower(v108)
                end
            end
            if string.find(string.lower(v105), p102) then
                return true
            end
        end
    end
    return false
end
function v_u_14.IsValidHex(_, p109)
    if typeof(p109) ~= "string" or (#p109 ~= 7 or string.sub(p109, 1, 1) ~= "#") then
        return false
    end
    for v110 = 2, 7 do
        local v111 = string.sub(p109, v110, v110)
        local v112 = string.byte(v111)
        if (v112 < 48 or v112 > 57) and (v112 < 97 or v112 > 102) then
            return false
        end
    end
    return true
end
function v_u_14.Color3FromHex(p113, p114)
    local v115 = p113:IsValidHex(p114)
    assert(v115, "Argument 1 invalid, expected a valid hex string")
    local v116 = "0x" .. string.sub(p114, 2, 3)
    local v117 = tonumber(v116)
    local v118 = "0x" .. string.sub(p114, 4, 5)
    local v119 = tonumber(v118)
    local v120 = "0x" .. string.sub(p114, 6, 7)
    local v121 = tonumber(v120)
    return Color3.fromRGB(v117, v119, v121)
end
function v_u_14.HexFromColor3(_, p122)
    local v123 = typeof(p122) == "Color3"
    assert(v123, "Argument 1 invalid, expected a Color3")
    local v124 = p122.R * 255 + 0.5
    local v125 = math.floor(v124)
    local v126 = p122.G * 255 + 0.5
    local v127 = math.floor(v126)
    local v128 = p122.B * 255 + 0.5
    local v129 = math.floor(v128)
    return string.format("#%02x%02x%02x", v125, v127, v129)
end
function v_u_14.GenerateCrosshairAppearance(_, p130, p131, p132)
    local v133
    if p131 and p131["Settings Crosshair Disabled"] ~= nil then
        v133 = p131["Settings Crosshair Disabled"]
    else
        v133 = p130:Get("Settings Crosshair Disabled")
    end
    local v134
    if v133 then
        v134 = {
            ["IsDisabled"] = true
        }
    else
        local v135
        if p131 and p131["Settings Crosshair Bars Enabled"] ~= nil then
            v135 = p131["Settings Crosshair Bars Enabled"]
        else
            v135 = p130:Get("Settings Crosshair Bars Enabled")
        end
        local v136 = not v135
        local v137
        if p131 and p131["Settings Crosshair Dot Enabled"] ~= nil then
            v137 = p131["Settings Crosshair Dot Enabled"]
        else
            v137 = p130:Get("Settings Crosshair Dot Enabled")
        end
        local v138 = not v137
        local v139
        if p131 and p131["Settings Crosshair Circle Enabled"] ~= nil then
            v139 = p131["Settings Crosshair Circle Enabled"]
        else
            v139 = p130:Get("Settings Crosshair Circle Enabled")
        end
        local v140 = not v139
        local v141
        if p131 and p131["Settings Crosshair Outline Enabled"] ~= nil then
            v141 = p131["Settings Crosshair Outline Enabled"]
        else
            v141 = p130:Get("Settings Crosshair Outline Enabled")
        end
        local v142 = not v141
        v134 = {
            ["IsDisabled"] = nil
        }
        local v143
        if p131 and p131["Settings Crosshair Static"] ~= nil then
            v143 = p131["Settings Crosshair Static"]
        else
            v143 = p130:Get("Settings Crosshair Static")
        end
        v134.IsStatic = v143 or nil
        local v144
        if p131 and p131["Settings Crosshair Rotation"] ~= nil then
            v144 = p131["Settings Crosshair Rotation"]
        else
            v144 = p130:Get("Settings Crosshair Rotation")
        end
        v134.Rotation = v144
        local v145
        if p131 and p131["Settings Crosshair Scale"] ~= nil then
            v145 = p131["Settings Crosshair Scale"]
        else
            v145 = p130:Get("Settings Crosshair Scale")
        end
        v134.Scale = v145
        local v146
        if p131 and p131["Settings Crosshair Show While Aiming"] ~= nil then
            v146 = p131["Settings Crosshair Show While Aiming"]
        else
            v146 = p130:Get("Settings Crosshair Show While Aiming")
        end
        v134.ShowWhileAiming = v146 or nil
        local v147
        if p131 and p131["Settings Crosshair Override Shotgun"] ~= nil then
            v147 = p131["Settings Crosshair Override Shotgun"]
        else
            v147 = p130:Get("Settings Crosshair Override Shotgun")
        end
        v134.Override = v147 or nil
        v134.BarsDisabled = v136 or nil
        local v148
        if v136 then
            v148 = nil
        else
            local v149
            if p131 and p131["Settings Crosshair Bars Top Enabled"] ~= nil then
                v149 = p131["Settings Crosshair Bars Top Enabled"]
            else
                v149 = p130:Get("Settings Crosshair Bars Top Enabled")
            end
            v148 = not v149 or nil
        end
        v134.BarsTopDisabled = v148
        local v150
        if v136 then
            v150 = nil
        else
            local v151
            if p131 and p131["Settings Crosshair Bars Bottom Enabled"] ~= nil then
                v151 = p131["Settings Crosshair Bars Bottom Enabled"]
            else
                v151 = p130:Get("Settings Crosshair Bars Bottom Enabled")
            end
            v150 = not v151 or nil
        end
        v134.BarsBottomDisabled = v150
        local v152
        if v136 then
            v152 = nil
        else
            local v153
            if p131 and p131["Settings Crosshair Bars Right Enabled"] ~= nil then
                v153 = p131["Settings Crosshair Bars Right Enabled"]
            else
                v153 = p130:Get("Settings Crosshair Bars Right Enabled")
            end
            v152 = not v153 or nil
        end
        v134.BarsRightDisabled = v152
        local v154
        if v136 then
            v154 = nil
        else
            local v155
            if p131 and p131["Settings Crosshair Bars Left Enabled"] ~= nil then
                v155 = p131["Settings Crosshair Bars Left Enabled"]
            else
                v155 = p130:Get("Settings Crosshair Bars Left Enabled")
            end
            v154 = not v155 or nil
        end
        v134.BarsLeftDisabled = v154
        local v156
        if v136 then
            v156 = nil
        elseif p131 and p131["Settings Crosshair Bars Spacing"] ~= nil then
            v156 = p131["Settings Crosshair Bars Spacing"]
        else
            v156 = p130:Get("Settings Crosshair Bars Spacing")
        end
        v134.BarsSpacing = v156
        local v157
        if v136 then
            v157 = nil
        elseif p131 and p131["Settings Crosshair Bars Length"] ~= nil then
            v157 = p131["Settings Crosshair Bars Length"]
        else
            v157 = p130:Get("Settings Crosshair Bars Length")
        end
        v134.BarsLength = v157
        local v158
        if v136 then
            v158 = nil
        elseif p131 and p131["Settings Crosshair Bars Thickness"] ~= nil then
            v158 = p131["Settings Crosshair Bars Thickness"]
        else
            v158 = p130:Get("Settings Crosshair Bars Thickness")
        end
        v134.BarsThickness = v158
        local v159
        if v136 then
            v159 = nil
        elseif p131 and p131["Settings Crosshair Bars Transparency"] ~= nil then
            v159 = p131["Settings Crosshair Bars Transparency"]
        else
            v159 = p130:Get("Settings Crosshair Bars Transparency")
        end
        v134.BarsTransparency = v159
        local v160
        if v136 then
            v160 = nil
        elseif p131 and p131["Settings Crosshair Bars Color"] ~= nil then
            v160 = p131["Settings Crosshair Bars Color"]
        else
            v160 = p130:Get("Settings Crosshair Bars Color")
        end
        v134.BarsColor = v160
        local v161
        if v136 then
            v161 = nil
        elseif p131 and p131["Settings Crosshair Bars Shape"] ~= nil then
            v161 = p131["Settings Crosshair Bars Shape"]
        else
            v161 = p130:Get("Settings Crosshair Bars Shape")
        end
        v134.BarsShape = v161
        v134.DotDisabled = v138 or nil
        local v162
        if v138 then
            v162 = nil
        elseif p131 and p131["Settings Crosshair Dot Thickness"] ~= nil then
            v162 = p131["Settings Crosshair Dot Thickness"]
        else
            v162 = p130:Get("Settings Crosshair Dot Thickness")
        end
        v134.DotThickness = v162
        local v163
        if v138 then
            v163 = nil
        elseif p131 and p131["Settings Crosshair Dot Transparency"] ~= nil then
            v163 = p131["Settings Crosshair Dot Transparency"]
        else
            v163 = p130:Get("Settings Crosshair Dot Transparency")
        end
        v134.DotTransparency = v163
        local v164
        if v138 then
            v164 = nil
        elseif p131 and p131["Settings Crosshair Dot Color"] ~= nil then
            v164 = p131["Settings Crosshair Dot Color"]
        else
            v164 = p130:Get("Settings Crosshair Dot Color")
        end
        v134.DotColor = v164
        local v165
        if v138 then
            v165 = nil
        elseif p131 and p131["Settings Crosshair Dot Shape"] ~= nil then
            v165 = p131["Settings Crosshair Dot Shape"]
        else
            v165 = p130:Get("Settings Crosshair Dot Shape")
        end
        v134.DotShape = v165
        v134.CircleDisabled = v140 or nil
        local v166
        if v140 then
            v166 = nil
        elseif p131 and p131["Settings Crosshair Circle Color"] ~= nil then
            v166 = p131["Settings Crosshair Circle Color"]
        else
            v166 = p130:Get("Settings Crosshair Circle Color")
        end
        v134.CircleColor = v166
        local v167
        if v140 then
            v167 = nil
        elseif p131 and p131["Settings Crosshair Circle Size"] ~= nil then
            v167 = p131["Settings Crosshair Circle Size"]
        else
            v167 = p130:Get("Settings Crosshair Circle Size")
        end
        v134.CircleSize = v167
        local v168
        if v140 then
            v168 = nil
        elseif p131 and p131["Settings Crosshair Circle Thickness"] ~= nil then
            v168 = p131["Settings Crosshair Circle Thickness"]
        else
            v168 = p130:Get("Settings Crosshair Circle Thickness")
        end
        v134.CircleThickness = v168
        local v169
        if v140 then
            v169 = nil
        elseif p131 and p131["Settings Crosshair Circle Transparency"] ~= nil then
            v169 = p131["Settings Crosshair Circle Transparency"]
        else
            v169 = p130:Get("Settings Crosshair Circle Transparency")
        end
        v134.CircleTransparency = v169
        local v170
        if v140 then
            v170 = nil
        elseif p131 and p131["Settings Crosshair Circle Shape"] ~= nil then
            v170 = p131["Settings Crosshair Circle Shape"]
        else
            v170 = p130:Get("Settings Crosshair Circle Shape")
        end
        v134.CircleShape = v170
        v134.OutlineDisabled = v142 or nil
        local v171
        if v142 then
            v171 = nil
        elseif p131 and p131["Settings Crosshair Outline Thickness"] ~= nil then
            v171 = p131["Settings Crosshair Outline Thickness"]
        else
            v171 = p130:Get("Settings Crosshair Outline Thickness")
        end
        v134.OutlineThickness = v171
        local v172
        if v142 then
            v172 = nil
        elseif p131 and p131["Settings Crosshair Outline Transparency"] ~= nil then
            v172 = p131["Settings Crosshair Outline Transparency"]
        else
            v172 = p130:Get("Settings Crosshair Outline Transparency")
        end
        v134.OutlineTransparency = v172
        local v173
        if v142 then
            v173 = nil
        elseif p131 and p131["Settings Crosshair Outline Color"] ~= nil then
            v173 = p131["Settings Crosshair Outline Color"]
        else
            v173 = p130:Get("Settings Crosshair Outline Color")
        end
        v134.OutlineColor = v173
        local v174
        if v142 then
            v174 = nil
        elseif p131 and p131["Settings Crosshair Outline Type"] ~= nil then
            v174 = p131["Settings Crosshair Outline Type"]
        else
            v174 = p130:Get("Settings Crosshair Outline Type")
        end
        v134.OutlineType = v174
    end
    if not p132 then
        return v134
    end
    local v175 = {}
    for v176, v177 in pairs(v134) do
        v175[v_u_10:ToEnum(v176)] = v177
    end
    return v175
end
function v_u_14.DecodeCrosshairAppearance(_, p178)
    local v179 = {}
    for v180, v181 in pairs(p178) do
        v179[v_u_10:FromEnum(v180)] = v181
    end
    return v179
end
function v_u_14.GetInputEnumFromName(p182, p183)
    if not p182._name_to_input_enum then
        p182._name_to_input_enum = {}
        local v184 = {}
        for _, v185 in pairs({ Enum.KeyCode, Enum.UserInputType }) do
            for _, v186 in pairs(v185:GetEnumItems()) do
                if v184[v186] == nil then
                    v184[v186] = true
                elseif v184[v186] == true then
                    v184[v186] = false
                end
            end
        end
        for v187, v188 in pairs(v184) do
            if v188 then
                p182._name_to_input_enum[v187.Name] = v187
            end
        end
    end
    return p182._name_to_input_enum[p183]
end
function v_u_14.SphereLineIntersection(_, p189, p190, p191, p192)
    local v193 = p192 - p191
    local v194 = v193.magnitude
    local v195 = v193.unit
    local v196 = p191 - p189
    local v197 = v196:Dot(v195)
    local v198 = v196:Dot(v196) - p190 * p190
    if v198 > 0 and v197 > 0 then
        return false
    else
        local v199 = v197 * v197 - v198
        if v199 < 0 then
            return false
        else
            return v194 >= -v197 - math.sqrt(v199)
        end
    end
end
function v_u_14.Knockback(_, p200, p201)
    p200.Velocity = Vector3.new(0, 0, 0)
    local v202 = Instance.new("BodyVelocity")
    local v203 = p201.X
    local v204 = math.abs(v203) > 0.1 and 1 or 0
    local v205 = p201.Y
    local v206 = math.abs(v205) > 0.1 and 1 or 0
    local v207 = p201.Z
    local v208 = math.abs(v207) > 0.1 and 1 or 0
    v202.MaxForce = Vector3.new(v204, v206, v208) * 100000
    v202.Velocity = p201
    v202.Parent = p200
    v_u_9:AddItem(v202, 0.2)
end
function v_u_14.GetArmsData(_, p209)
    if p209 then
        local v210 = p209:FindFirstChildOfClass("Shirt")
        if v210 then
            v210 = v210.ShirtTemplate
        end
        local v211 = p209:FindFirstChildOfClass("BodyColors")
        local v212
        if v211 then
            v212 = v211.LeftArmColor3
        else
            v212 = v211
        end
        if v211 then
            v211 = v211.RightArmColor3
        end
        return v210, v212, v211
    end
end
function v_u_14.TimeFormat(_, p213)
    local v214 = math.floor(p213)
    local v215 = v214 % 60
    local v216 = v214 / 60
    return math.floor(v216) .. ":" .. (v215 < 10 and "0" or "") .. v215
end
function v_u_14.TimeFormat2(_, p217, p218, p219)
    if not p219 and p217 <= 0 then
        return "0s"
    end
    if p219 and p217 < 60 then
        return "0m"
    end
    local v220 = p217 % 60
    local v221 = p217 - v220
    local v222 = v221 / 60 % 60
    local v223 = v221 - v222 * 60
    local v224 = v223 / 60 / 60 % 24
    local v225 = v223 - v224 * 60 * 60
    local v226 = v225 / 60 / 60 / 24 % 365
    local v227 = (v225 - v226 * 24 * 60 * 60) / 60 / 60 / 24 / 365
    if not p218 then
        return (v227 > 0 and (v227 .. "y " or "") or "") .. ((v227 > 0 or v226 > 0) and (v226 .. "d " or "") or "") .. ((v227 > 0 or (v226 > 0 or v224 > 0)) and (v224 .. "h " or "") or "") .. ((v227 > 0 or (v226 > 0 or (v224 > 0 or v222 > 0))) and (v222 .. "m " or "") or "") .. ((v227 > 0 or (v226 > 0 or (v224 > 0 or (v222 > 0 or v220 > 0)))) and not p219 and (v220 .. "s" or "") or "")
    end
    local v228 = typeof(p218) == "number" and p218 and p218 or 1
    local v229 = 0
    local v230 = ""
    for _, v231 in pairs({
        { v227, "y" },
        { v226, "d" },
        { v224, "h" },
        { v222, "m" },
        { v220, "s" }
    }) do
        if v231[1] > 0 then
            v229 = v229 + 1
            v230 = v230 .. (v229 > 1 and " " or "") .. v231[1] .. v231[2]
            if v228 <= v229 then
                break
            end
        end
    end
    return v230
end
function v_u_14.ScaleParticleEmitter(_, p232, p233)
    local v234 = p232:IsA("ParticleEmitter") and {} or p232:GetDescendants()
    table.insert(v234, p232)
    for _, v235 in pairs(v234) do
        if v235:IsA("ParticleEmitter") then
            local v236 = {}
            for _, v237 in pairs(v235.Size.Keypoints) do
                local v238 = NumberSequenceKeypoint.new
                local v239 = v237.Time
                local v240 = v237.Value * p233
                local v241 = v237.Envelope * p233
                table.insert(v236, v238(v239, v240, v241))
            end
            v235.Size = NumberSequence.new(v236)
            v235.Speed = NumberRange.new(v235.Speed.Min * p233, v235.Speed.Max * p233)
            v235.Acceleration = v235.Acceleration * p233 ^ 2
        end
    end
end
function v_u_14.EncodeCFrame(_, p242)
    local v243, v244, v245 = p242:ToOrientation()
    return {
        [utf8.char(0)] = p242.X,
        [utf8.char(1)] = p242.Y,
        [utf8.char(2)] = p242.Z,
        [utf8.char(3)] = v243,
        [utf8.char(4)] = v244,
        [utf8.char(5)] = v245
    }
end
function v_u_14.DecodeCFrame(_, p246)
    return CFrame.new(p246[utf8.char(0)], p246[utf8.char(1)], p246[utf8.char(2)]) * CFrame.fromOrientation(p246[utf8.char(3)], p246[utf8.char(4)], p246[utf8.char(5)])
end
function v_u_14.FromXYToCameraRotation(_, p247, p248)
    return Vector2.new(p247, p248) * 3.141592653589793 * 2 / 256
end
function v_u_14.DecodeCameraRotation(p249, p250)
    local v251, v252 = utf8.codepoint(p250, 1, #p250)
    return p249:FromXYToCameraRotation(v251, v252)
end
function v_u_14.DecodeCameraRotationBulk(_, p253)
    local v254 = { utf8.codepoint(p253, 1, #p253) }
    local v255 = {}
    for v256 = 1, #p253, 3 do
        local v257 = { v254[v256], v254[v256 + 1], v254[v256 + 2] }
        table.insert(v255, v257)
    end
    return v255
end
function v_u_14.EncodeCameraRotation(_, p258)
    if p258 ~= p258 then
        return utf8.char(0) .. utf8.char(0)
    end
    local v259 = p258.X % 6.283185307179586 / 3.141592653589793 / 2 * 256 + 0.5
    local v260 = math.floor(v259)
    local v261 = math.clamp(v260, 0, 255)
    local v262 = p258.Y % 6.283185307179586 / 3.141592653589793 / 2 * 256 + 0.5
    local v263 = math.floor(v262)
    local v264 = math.clamp(v263, 0, 255)
    return utf8.char(v261) .. utf8.char(v264)
end
function v_u_14.AngleBetweenVectors(_, p265, p266)
    local v267 = p266:Dot(p265) / p266.Magnitude / p265.Magnitude
    return math.acos(v267)
end
function v_u_14.PlayParticles(p_u_268, p_u_269)
    if p_u_269 then
        local v270 = typeof(p_u_269) == "Instance" and true or typeof(p_u_269) == "table"
        assert(v270, "Argument 1 invalid, expected an Instance or table")
        local v_u_271 = typeof(p_u_269) == "Instance"
        local v272
        if v_u_271 then
            v272 = not p_u_269:IsDescendantOf(workspace)
        else
            v272 = v_u_271
        end
        local v_u_273
        if v_u_271 and not v272 then
            if not p_u_268._particle_hashes[p_u_269] then
                p_u_268._particle_hashes[p_u_269] = 0
                local v_u_274 = nil
                v_u_274 = p_u_269.AncestryChanged:Connect(function()
                    if not p_u_269:IsDescendantOf(workspace) then
                        v_u_274:Disconnect()
                        p_u_268._particle_hashes[p_u_269] = nil
                    end
                end)
            end
            local v275 = p_u_268._particle_hashes
            v275[p_u_269] = v275[p_u_269] + 1
            v_u_273 = p_u_268._particle_hashes[p_u_269]
        else
            v_u_273 = nil
        end
        local v276
        if v_u_271 then
            v276 = p_u_269:GetDescendants()
            table.insert(v276, p_u_269)
        else
            v276 = {}
            for _, v277 in pairs(p_u_269) do
                table.insert(v276, v277)
                for _, v278 in pairs(v277:GetDescendants()) do
                    table.insert(v276, v278)
                end
            end
        end
        for _, v_u_279 in pairs(v276) do
            if v_u_279:IsA("ParticleEmitter") then
                local v280 = v_u_279:GetAttribute("EmitCount") or 0
                local v281 = v_u_279:GetAttribute("EmitDelay") or 0
                local v_u_282 = v_u_279:GetAttribute("EmitDuration") or 0
                if v281 > 0 then
                    task.delay(v281, v_u_279.Emit, v_u_279, v280)
                else
                    task.spawn(v_u_279.Emit, v_u_279, v280)
                end
                if v_u_282 > 0 then
                    task.defer(function()
                        v_u_279.Enabled = true
                        task.wait(v_u_282)
                        v_u_279.Enabled = false
                    end)
                end
            elseif v_u_279:IsA("Light") then
                local v_u_283 = v_u_279:GetAttribute("Brightness") or 0
                local v_u_284 = v_u_279:GetAttribute("DecaySpeed") or 1
                if not v272 then
                    task.spawn(function()
                        v_u_279.Brightness = v_u_283
                        v_u_279.Enabled = true
                        p_u_268:RenderstepForLoop(0, 100, 10 * v_u_284, function(p285)
                            if v_u_271 and p_u_268._particle_hashes[p_u_269] ~= v_u_273 then
                                return true
                            end
                            v_u_279.Brightness = v_u_283 * (1 - p285 / 100)
                        end)
                        if not p_u_268._particle_hashes[p_u_269] then
                            v_u_279.Brightness = 0
                            v_u_279.Enabled = false
                        end
                    end)
                end
            end
        end
    end
end
function v_u_14.StringLessThan(_, p286, p287)
    if p286 == p287 then
        return false
    end
    local v288 = #p286
    local v289 = #p287
    for v290 = 1, math.min(v288, v289) do
        local v291 = string.sub(p286, v290, v290)
        local v292 = string.byte(v291)
        local v293 = string.sub(p287, v290, v290)
        local v294 = string.byte(v293)
        if v292 ~= v294 then
            return v292 < v294
        end
    end
    return #p286 < #p287
end
function v_u_14.CloneTable(p295, p296, p297)
    local v298 = {}
    for v299, v300 in pairs(p296) do
        if p297 or typeof(v300) ~= "table" then
            v298[v299] = v300
        else
            v298[v299] = p295:CloneTable(v300)
        end
    end
    return v298
end
function v_u_14.PrettyNumber(_, p301)
    local v302 = tonumber(p301)
    if typeof(v302) ~= "number" then
        local v303 = "Argument 1 invalid, expected a number or string, got " .. tostring(p301)
        assert(false, v303)
    end
    if tostring(p301) == "inf" then
        return "inf"
    end
    local v304, v305, v306 = string.match(v302, "^([^%d]*%d)(%d*)(.-)$")
    return v304 .. v305:reverse():gsub("(%d%d%d)", "%1,"):reverse() .. v306
end
function v_u_14.Raycast(_, p307, p308, p309, p310, p311, p312)
    local v313 = typeof(p307) == "Vector3"
    assert(v313, "Argument 1 invalid, expected a Vector3")
    local v314 = typeof(p308) == "Vector3"
    assert(v314, "Argument 2 invalid, expected a Vector3")
    local v315 = typeof(p309) == "number"
    assert(v315, "Argument 3 invalid, expected a number")
    local v316 = not p310 or typeof(p310) == "table"
    assert(v316, "Argument 4 invalid, expected a table or nil")
    local v317 = not p311 or typeof(p311) == "EnumItem"
    assert(v317, "Argument 5 invalid, expected a RaycastFilterType")
    local v318 = not p312 or typeof(p312) == "boolean"
    assert(v318, "Argument 6 invalid, expected a boolean or nil")
    local v319 = p311 or Enum.RaycastFilterType.Exclude
    local v320 = (p308 - p307).Unit * p309
    local v321 = RaycastParams.new()
    v321.FilterDescendantsInstances = p310 or {}
    v321.FilterType = v319
    v321.IgnoreWater = true
    local v322 = workspace:Raycast(p307, v320, v321)
    local v323 = {
        ["Position"] = v322 and v322.Position or p307 + (p308 - p307).Unit * p309
    }
    if v322 then
        p309 = v322.Distance or p309
    end
    v323.Distance = p309
    local v324
    if v322 then
        v324 = v322.Instance or nil
    else
        v324 = nil
    end
    v323.Instance = v324
    local v325
    if v322 then
        v325 = v322.Material or nil
    else
        v325 = nil
    end
    v323.Material = v325
    v323.Normal = v322 and v322.Normal or nil
    if p312 then
        local v326 = (p307 - v323.Position).Magnitude
        local v327 = Instance.new("Part")
        v327.Color = Color3.fromHSV(math.random(), 1, 1)
        v327.Material = Enum.Material.Neon
        v327.Anchored = true
        v327.CanCollide = false
        v327.Size = Vector3.new(0.01, 0.01, v326)
        v327.CFrame = CFrame.new(p307, v323.Position) * CFrame.new(0, 0, -v326 / 2)
        v327.Parent = workspace
        v_u_9:AddItem(v327, 10)
    end
    return v323
end
function v_u_14.WaitForChildWhichIsA(_, p328, p329, p330)
    local v331 = typeof(p328) == "Instance"
    local v332 = "Argument 1 invalid, expected an Instance, got " .. tostring(p328)
    assert(v331, v332)
    local v333 = typeof(p329) == "string"
    local v334 = "Argument 2 invalid, expected a string, got " .. tostring(p329)
    assert(v333, v334)
    local v335 = not p330 or typeof(p330) == "boolean"
    local v336 = "Argument 3 invalid, expected a boolean or nil, got " .. tostring(p330)
    assert(v335, v336)
    while true do
        local v337 = p328:FindFirstChildWhichIsA(p329, p330)
        if v337 then
            break
        end
        if p330 then
            p328.DescendantAdded:Wait()
        else
            p328.ChildAdded:Wait()
        end
    end
    return v337
end
function v_u_14.CreateSound(_, p338, p339, p340, p341, p342, p343, p344, p345, p346, p347)
    local v348 = typeof(p338) == "string"
    assert(v348, p338)
    local v349 = not p339 or typeof(p339) == "number"
    assert(v349, p339)
    local v350 = not p340 or typeof(p340) == "number"
    assert(v350, p340)
    local v351 = not p341 or ((p341 == "script" or typeof(p341) == "Instance") and true or typeof(p341) == "Vector3")
    assert(v351, p341)
    local v352 = not p342 or typeof(p342) == "boolean"
    assert(v352, "Argument 5 invalid, expected a boolean", p342)
    local v353 = not p343 or typeof(p343) == "number"
    assert(v353, "Argument 6 invalid, expected a number or nil", p343)
    local v354 = not p344 or typeof(p344) == "number"
    assert(v354, "Argument 7 invalid, expected a number or nil", p344)
    local v355 = not p345 or typeof(p345) == "number"
    assert(v355, "Argument 8 invalid, expected a number or nil", p345)
    local v356 = not p346 or typeof(p346) == "string"
    assert(v356, "Argument 9 invalid, expected a string or nil", p346)
    local v357 = not p347 or typeof(p347) == "table"
    assert(v357, "Argument 10 invalid, expected a table or nil", p347)
    if not v_u_7.IS_SERVER then
        if typeof(p341) == "Vector3" then
            local v358 = Instance.new("Part")
            v358.CFrame = CFrame.new(p341)
            v358.Size = Vector3.new(1, 1, 1)
            v358.Transparency = 1
            v358.CastShadow = false
            v358.CanCollide = false
            v358.CanTouch = false
            v358.CanQuery = false
            v358.Anchored = true
            v358.Parent = workspace
            v_u_9:AddItem(v358, p343 or 60)
            p341 = v358
        elseif p341 == "script" then
            p341 = script
        end
        local v359 = Instance.new("Sound")
        v359.SoundId = p338
        v359.Volume = p339 or 1
        v359.PlaybackSpeed = p340 or 1
        v359.RollOffMinDistance = p344 or 50
        v359.RollOffMaxDistance = p345 or 400
        v359.RollOffMode = Enum.RollOffMode.Inverse
        v359.SoundGroup = v_u_5[p346 or "Other"]
        v359:AddTag("AudioVisualizer")
        for v360, v361 in pairs(p347 or {}) do
            v359[v360] = v361
        end
        v359.Parent = p341
        if p342 then
            v359:Play()
        end
        if p343 then
            v_u_9:AddItem(v359, p343)
        end
        return v359
    end
    v_u_3.Remotes.Misc.FunctionsUnreliable:FireAllClients(v_u_10:ToEnum("CreateSound"), p338, p339, p340, p341, p342, p343, p344, p345, p346, p347)
end
function v_u_14.WaitForChild(_, p362, ...)
    local v363 = typeof(p362) == "Instance"
    local v364 = "Argument 1 invalid, expected an Instance, got " .. tostring(p362)
    assert(v363, v364)
    for v365, v366 in pairs({ ... }) do
        local v367 = typeof(v366) == "string"
        local v368 = "Argument " .. v365 + 1 .. " invalid, expected a string, got " .. tostring(v366)
        assert(v367, v368)
        p362 = p362:WaitForChild(v366)
    end
    return p362
end
function v_u_14.RenderstepForLoop(_, ...)
    v_u_11(...)
end
function v_u_14._RecursiveIsUIElementVisible(p369, p370)
    if p370:IsA("ScreenGui") or (p370:IsA("SurfaceGui") or p370:IsA("BillboardGui")) then
        return p370.Enabled
    end
    local v371 = p370.Visible
    if v371 then
        v371 = p369:_RecursiveIsUIElementVisible(p370.Parent)
    end
    return v371
end
function v_u_14._SetupTranslator(p372)
    if v_u_7.IS_CLIENT then
        local v373, v374 = pcall(v_u_1.GetTranslatorForPlayerAsync, v_u_1, v_u_6.LocalPlayer)
        if v373 then
            p372._search_translator = v374
        else
            warn("Failed to fetch translator, error:", v374)
        end
    else
        return
    end
end
function v_u_14._Init(p375)
    task.defer(p375._SetupTranslator, p375)
end
return v_u_14._new()