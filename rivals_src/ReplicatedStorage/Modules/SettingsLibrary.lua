local v1 = game:GetService("ReplicatedStorage")
local v2 = require(v1.Modules.CONSTANTS)
local v_u_3 = require(v1.Modules.InputLibrary)
local v_u_4 = require(v1.Modules.SettingsInfo)
local v5 = {
    "Shoot",
    "Aim",
    "Reload",
    "Inspect",
    "QuickMelee",
    "QuickUtility",
    "Divider",
    "Jump",
    "Crouch",
    "Sprint",
    "Slide",
    "SwitchCameraPOV",
    "Divider",
    "EquipPrimary",
    "EquipSecondary",
    "EquipMelee",
    "EquipUtility",
    "EquipNext",
    "EquipLast",
    "Divider",
    "UseEmote",
    "Divider",
    "Ping",
    "OpenPlayerList",
    "SwitchItems",
    "LeaveDuel",
    "SpectateExit",
    "SpectateNext",
    "SpectateLast",
    "HideHUD"
}
for v6 = v2.MAX_EQUIPPABLE_EMOTES, 1, -1 do
    local v7 = table.find(v5, "UseEmote") + 1
    local v8 = "UseEmote" .. v6
    table.insert(v5, v7, v8)
end
local v_u_9 = {
    ["Order"] = {},
    ["Info"] = {},
    ["Hotkeys"] = v5
}
local v10 = 0
local function v_u_13(...)
    local v11 = v_u_4.new(...)
    v_u_9.Info[v11.Name] = v11
    local v12 = v_u_9.Order
    table.insert(v12, v11)
end
local function v19(p14, _)
    local v15 = v_u_3.Inputs[p14]
    local v16 = v15.InputEnums.MouseKeyboard[1]
    local v17 = v15.InputEnums.MouseKeyboard[2]
    local v18 = v15.InputEnums.Gamepad[1]
    v_u_13("Hotkeys", "Settings Hotkey MouseKeyboard" .. p14 .. "1", v15.DisplayName, "", "", "Hotkey", v16 and v16.Name or "nil")
    v_u_13("Hotkeys", "Settings Hotkey MouseKeyboard" .. p14 .. "2", v15.DisplayName, "", "", "Hotkey", v17 and v17.Name or "nil")
    v_u_13("Hotkeys", "Settings Hotkey Gamepad" .. p14 .. "1", v15.DisplayName, "", "", "Hotkey", v18 and v18.Name or "nil")
end
v_u_13("General", "Settings Shadows Disabled", "Disable Shadows", "rbxassetid://17521723349", "Reduces lag", "Toggle", false)
v_u_13("General", "Settings Textures Disabled", "Disable Textures", "rbxassetid://17521723467", "Reduces lag (game restart required when turned off)", "Toggle", false)
v_u_13("General", "Settings Wraps Disabled", "Disable Wraps", "rbxassetid://17593458822", "Reduces lag (you\'ll still see your wraps)", "Toggle", false)
v_u_13("General", "Settings Accessible Flashes", "Accessible Flashes", "rbxassetid://17814211801", "Makes flashbang blinds dark instead of bright", "Toggle", false)
local v20 = "Audio"
local v21
if v20 == "" then
    v20 = string.rep(" ", v10)
    v10 = v10 + 1
    v21 = v10
else
    v21 = v10
end
local v22 = v_u_4.new("General", v20, "", "", "", "Divider")
local v23 = v_u_9.Order
table.insert(v23, v22)
v_u_13("General", "Settings Music Volume", "Music Volume", "rbxassetid://17506383011", "Music made by @BSlickMusic", "Slider", 0.5, 0, 2, 20)
v_u_13("General", "Settings Master Volume", "Master Volume", "rbxassetid://17506383011", "Change the volume of everything (except music)", "Slider", 0.5, 0, 2, 20)
v_u_13("General", "Settings Finisher Volume", "Finisher Volume", "rbxassetid://17506383011", "Changes the volume of finisher effects", "Slider", 0.5, 0, 2, 20)
v_u_13("General", "Settings Emote Volume", "Emote Volume", "rbxassetid://17506383011", "Changes the volume of emotes", "Slider", 0.5, 0, 2, 20)
local v24 = "Controls"
if v24 == "" then
    v24 = string.rep(" ", v21)
    v10 = v21 + 1
    v21 = v10
end
local v25 = v_u_4.new("General", v24, "", "", "", "Divider")
local v26 = v_u_9.Order
table.insert(v26, v25)
v_u_13("General", "Settings Toggle Aim", "Toggle Aim", "rbxassetid://17513805525", "Always on for mobile devices", "Toggle", false)
v_u_13("General", "Settings Toggle Crouch", "Toggle Crouch", "rbxassetid://17513805623", "Always on for mobile devices", "Toggle", false)
v_u_13("General", "Settings Toggle Sprint", "Toggle Sprint", "rbxassetid://17513821002", "Not available for mobile devices", "Toggle", false)
v_u_13("General", "Settings Auto Sprint", "Auto Sprint", "rbxassetid://17513821002", "Always on for mobile devices", "Toggle", true)
v_u_13("General", "Settings Easy Slide", "Easy Slide", "rbxassetid://17524267716", "Allows you to Slide by Crouching while Sprinting", "Toggle", true)
v_u_13("General", "Settings Scroll Equip", "Scroll Equip", "rbxassetid://17136633356", "Allows you to use your mouse wheel to equip weapons", "Toggle", true)
v_u_13("General", "Settings Auto Shoot", "Auto Shoot Mode", "rbxassetid://17513805027", "Not available for mouse & keyboard", "Dropdown", "Custom", { "Custom", "Dynamic", "Disabled" })
v_u_13("General", "Settings Auto Shoot Reaction Time", "Auto Shoot Reaction Time", "rbxassetid://17513805027", "Your autoshoot delay in milliseconds", "Slider", 25, 25, 125, 1)
v_u_13("General", "Settings Auto Jump", "Auto Jump", "rbxassetid://18436038478", "Only available for mobile devices", "Toggle", true)
v_u_13("General", "Settings Double Tap Shoot", "Double Tap To Shoot", "rbxassetid://101488932151631", "Only available for mobile devices", "Toggle", true)
v_u_13("General", "Settings Left Handed Touch Controls", "Left Handed Touch Controls", "rbxassetid://98211826458757", "Only available for mobile devices", "Toggle", false)
v_u_13("General", "Settings Aim Assist Strength", "Aim Assist Strength", "rbxassetid://17513805525", "Not available for mouse & keyboard", "Slider", 0.5, 0, 1, 20)
v_u_13("General", "Settings Gamepad Deadzone", "Controller Deadzone", "rbxassetid://17136633629", "Helps fix joystick drifting", "Slider", 0.25, 0, 0.95, 20)
local v27 = "Camera"
if v27 == "" then
    v27 = string.rep(" ", v21)
    v10 = v21 + 1
    v21 = v10
end
local v28 = v_u_4.new("General", v27, "", "", "", "Divider")
local v29 = v_u_9.Order
table.insert(v29, v28)
v_u_13("General", "Settings Camera Sensitivity", "Sensitivity", "rbxassetid://17548980857", "Change how fast your camera rotates", "Slider", 1, 0.05, 4, 20)
v_u_13("General", "Settings Camera Sensitivity ADS", "ADS Sensitivity Multiplier", "rbxassetid://17548980857", "Multiplies your camera sensitivity while aiming", "Slider", 0.5, 0.05, 2, 20)
v_u_13("General", "Settings Camera Sensitivity X", "Horizontal Sensitivity", "rbxassetid://17548980857", "Specifically change your left/right sensitivity", "Slider", 1, 0.05, 4, 20)
v_u_13("General", "Settings Camera Sensitivity Y", "Vertical Sensitivity", "rbxassetid://17548980857", "Specifically change your up/down sensitivity", "Slider", 1, 0.05, 4, 20)
v_u_13("General", "Settings Camera Zoom Effects", "Camera Zoom Effects", "rbxassetid://17548980857", "Controls the strength of zoom effects (i.e. aiming)", "Slider", 1, 0, 1, 20)
v_u_13("General", "Settings Camera FOV", "Field Of View", "rbxassetid://17548980857", "Changes how much of the world you can see", "Slider", 80, 30, 120, 1)
v_u_13("General", "Settings Camera FOV Effects", "Field Of View Effects", "rbxassetid://17548980857", "Enables gameplay field of view effects", "Toggle", true)
v_u_13("General", "Settings Camera Shake", "Camera Shake", "rbxassetid://17548980857", "Enables camera shaking and recoil effects", "Toggle", true)
v_u_13("General", "Settings Camera Inverted X", "Inverted X", "rbxassetid://17548980857", "Inverts the camera\'s X movements", "Toggle", false)
v_u_13("General", "Settings Camera Inverted Y", "Inverted Y", "rbxassetid://17548980857", "Inverts the camera\'s Y movements", "Toggle", false)
v_u_13("General", "Settings Camera Mobile Button Sinking", "Mobile Button Camera Sinking", "rbxassetid://17548980857", "Lets you turn your camera while using a mobile button", "Toggle", true)
local v30 = "Interface"
if v30 == "" then
    v30 = string.rep(" ", v21)
    v10 = v21 + 1
    v21 = v10
end
local v31 = v_u_4.new("General", v30, "", "", "", "Divider")
local v32 = v_u_9.Order
table.insert(v32, v31)
v_u_13("General", "Settings Hide HUD", "Hide HUD", "rbxassetid://17898066959", "Useful for recording clips", "Toggle", false)
v_u_13("General", "Settings Hide Tasks In Duels", "Hide Tasks", "rbxassetid://17632205556", "Hides tasks after the round starts", "Toggle", false)
v_u_13("General", "Settings Hide Teammate Icons", "Hide Teammate Display", "rbxassetid://17704137194", "Hides teammate icons & health bars in duels", "Toggle", false)
v_u_13("General", "Settings Keybinds Interface", "Keybinds Interface", "rbxassetid://133555125764102", "Displays helpful keybinds under your weapons", "Toggle", true)
v_u_13("General", "Settings Pick Weapons List", "Weapon Picker Mode", "rbxassetid://17539215512", "A different format for picking your weapons", "Dropdown", "Grid", { "Grid", "List" })
v_u_13("General", "Settings Padded HUD", "Padded HUD", "rbxassetid://118715309480493", "Shrinks the HUD to add more space around the edges", "Dropdown", "Using Controller", { "Always On", "Using Controller", "Disabled" })
v_u_13("General", "Settings PlayerList Leaderstat", "Player List Display", "rbxassetid://17898066959", "Change what data the Player List displays", "Dropdown", "Win Streak", { "Win Streak", "Level", "Current ELO" })
local v33 = "Graphics"
if v33 == "" then
    v33 = string.rep(" ", v21)
    v10 = v21 + 1
    v21 = v10
end
local v34 = v_u_4.new("General", v33, "", "", "", "Divider")
local v35 = v_u_9.Order
table.insert(v35, v34)
v_u_13("General", "Settings Pings", "Signals", "rbxassetid://17269776216", "Turns on signal callouts from teammates", "Toggle", true)
v_u_13("General", "Settings ViewModel Highlight", "Weapon Inking", "rbxassetid://17611932430", "Adds a subtle outline around your weapons", "Toggle", true)
v_u_13("General", "Settings Damage Numbers", "Damage Numbers", "rbxassetid://18404346057", "Displays the damage you deal to others", "Toggle", true)
v_u_13("General", "Settings Aiming Hides Muzzle Flashes", "Hide Muzzle Flashes", "rbxassetid://125628882498996", "Hides muzzle flash effects while aiming in", "Toggle", false)
v_u_13("General", "Settings Equipment Background", "Weapons Background", "rbxassetid://17898066959", "Useful for making thumbnails", "Dropdown", "Default", {
    "Default",
    "Green Screen",
    "Blue Screen",
    "Pink Screen"
})
local v36 = "Other"
if v36 == "" then
    v36 = string.rep(" ", v21)
    v10 = v21 + 1
    v21 = v10
end
local v37 = v_u_4.new("General", v36, "", "", "", "Divider")
local v38 = v_u_9.Order
table.insert(v38, v37)
v_u_13("General", "Settings Receive Gifts", "Receive Gifts", "rbxassetid://18917088726", "Allows you to receive gifts from other players", "Toggle", true)
v_u_13("General", "Settings Bounty Rewards Disabled", "Disable Bounty Rewards", "rbxassetid://133391928250838", "Prevents players from farming your charm / wrap", "Toggle", false)
v_u_13("General", "Settings Staff Team Tools Disabled", "Disable Staff Team Tools", "rbxassetid://95626460059631", "Hides mod & debug buttons + hides server errors in chat", "Toggle", false)
v_u_13("Crosshair", "Settings Crosshair Disabled", "Disabled", "rbxassetid://139575687490912", "Makes the crosshair invisible", "Toggle", false)
v_u_13("Crosshair", "Settings Crosshair Static", "Static", "rbxassetid://17516823433", "Turns off all crosshair effects", "Toggle", false)
v_u_13("Crosshair", "Settings Crosshair Rotation", "Rotation", "rbxassetid://103847676236765", "0 or 45 recommended", "Slider", 0, 0, 360, 1)
v_u_13("Crosshair", "Settings Crosshair Scale", "Scale", "rbxassetid://115388073389430", "Make your crosshair big or small", "Slider", 1, 0, 4, 20)
v_u_13("Crosshair", "Settings Crosshair Show While Aiming", "Show While Aiming", "rbxassetid://122558543480189", "Keeps your crosshair visible while aiming", "Toggle", false)
v_u_13("Crosshair", "Settings Crosshair Override Shotgun", "Override Special Crosshairs", "rbxassetid://119489313346738", "Replaces Shotgun and Shorty crosshairs", "Toggle", false)
local v39 = ""
if v39 == "" then
    v39 = string.rep(" ", v21)
    v10 = v21 + 1
    v21 = v10
end
local v40 = v_u_4.new("Crosshair", v39, "", "", "", "Divider")
local v41 = v_u_9.Order
table.insert(v41, v40)
v_u_13("Crosshair", "Settings Crosshair Bars Enabled", "Bars Enabled", "rbxassetid://17516823503", "", "Toggle", true)
v_u_13("Crosshair", "Settings Crosshair Bars Color", "Bars Color", "rbxassetid://17516823503", "", "Color", "#ffffff")
v_u_13("Crosshair", "Settings Crosshair Bars Spacing", "Bars Spacing", "rbxassetid://17516823503", "", "Slider", 16, 0, 64, 1)
v_u_13("Crosshair", "Settings Crosshair Bars Length", "Bars Length", "rbxassetid://17516823503", "", "Slider", 6, 0, 32, 1)
v_u_13("Crosshair", "Settings Crosshair Bars Thickness", "Bars Thickness", "rbxassetid://17516823503", "", "Slider", 2, 0, 32, 1)
v_u_13("Crosshair", "Settings Crosshair Bars Transparency", "Bars Transparency", "rbxassetid://17516823503", "", "Slider", 0, 0, 1, 10)
v_u_13("Crosshair", "Settings Crosshair Bars Shape", "Bars Shape", "rbxassetid://17516823503", "", "Dropdown", "Sharp", { "Sharp", "Round" })
v_u_13("Crosshair", "Settings Crosshair Bars Top Enabled", "Top Bar Enabled", "rbxassetid://17564352694", "", "Toggle", true)
v_u_13("Crosshair", "Settings Crosshair Bars Bottom Enabled", "Bottom Bar Enabled", "rbxassetid://17564352775", "", "Toggle", true)
v_u_13("Crosshair", "Settings Crosshair Bars Right Enabled", "Right Bar Enabled", "rbxassetid://17564352879", "", "Toggle", true)
v_u_13("Crosshair", "Settings Crosshair Bars Left Enabled", "Left Bar Enabled", "rbxassetid://17564353047", "", "Toggle", true)
local v42 = ""
if v42 == "" then
    v42 = string.rep(" ", v21)
    v10 = v21 + 1
    v21 = v10
end
local v43 = v_u_4.new("Crosshair", v42, "", "", "", "Divider")
local v44 = v_u_9.Order
table.insert(v44, v43)
v_u_13("Crosshair", "Settings Crosshair Dot Enabled", "Dot Enabled", "rbxassetid://17516823599", "", "Toggle", true)
v_u_13("Crosshair", "Settings Crosshair Dot Color", "Dot Color", "rbxassetid://17516823599", "", "Color", "#ffffff")
v_u_13("Crosshair", "Settings Crosshair Dot Thickness", "Dot Thickness", "rbxassetid://17516823599", "", "Slider", 2, 0, 16, 1)
v_u_13("Crosshair", "Settings Crosshair Dot Transparency", "Dot Transparency", "rbxassetid://17516823599", "", "Slider", 0, 0, 1, 10)
v_u_13("Crosshair", "Settings Crosshair Dot Shape", "Dot Shape", "rbxassetid://17516823599", "", "Dropdown", "Sharp", { "Sharp", "Round" })
local v45 = ""
if v45 == "" then
    v45 = string.rep(" ", v21)
    v10 = v21 + 1
    v21 = v10
end
local v46 = v_u_4.new("Crosshair", v45, "", "", "", "Divider")
local v47 = v_u_9.Order
table.insert(v47, v46)
v_u_13("Crosshair", "Settings Crosshair Circle Enabled", "Circle Enabled", "rbxassetid://96264839713061", "", "Toggle", false)
v_u_13("Crosshair", "Settings Crosshair Circle Color", "Circle Color", "rbxassetid://96264839713061", "", "Color", "#ffffff")
v_u_13("Crosshair", "Settings Crosshair Circle Size", "Circle Size", "rbxassetid://96264839713061", "", "Slider", 16, 0, 64, 1)
v_u_13("Crosshair", "Settings Crosshair Circle Thickness", "Circle Thickness", "rbxassetid://96264839713061", "", "Slider", 2, 0, 16, 1)
v_u_13("Crosshair", "Settings Crosshair Circle Transparency", "Circle Transparency", "rbxassetid://96264839713061", "", "Slider", 0, 0, 1, 10)
v_u_13("Crosshair", "Settings Crosshair Circle Shape", "Circle Shape", "rbxassetid://96264839713061", "", "Dropdown", "Circle", { "Circle", "Round", "Sharp" })
local v48 = ""
if v48 == "" then
    v48 = string.rep(" ", v21)
    v10 = v21 + 1
end
local v49 = v_u_4.new("Crosshair", v48, "", "", "", "Divider")
local v50 = v_u_9.Order
table.insert(v50, v49)
v_u_13("Crosshair", "Settings Crosshair Outline Enabled", "Outline Enabled", "rbxassetid://17516823683", "", "Toggle", false)
v_u_13("Crosshair", "Settings Crosshair Outline Color", "Outline Color", "rbxassetid://17516823683", "", "Color", "#000000")
v_u_13("Crosshair", "Settings Crosshair Outline Thickness", "Outline Thickness", "rbxassetid://17516823683", "", "Slider", 1, 0, 16, 1)
v_u_13("Crosshair", "Settings Crosshair Outline Transparency", "Outline Transparency", "rbxassetid://17516823683", "", "Slider", 0, 0, 1, 10)
v_u_13("Crosshair", "Settings Crosshair Outline Type", "Outline Type", "rbxassetid://17516823683", "", "Dropdown", "Miter", { "Miter", "Round", "Bevel" })
for _, v51 in pairs(v5) do
    if v51 ~= "Divider" then
        v19(v51)
    end
end
return v_u_9