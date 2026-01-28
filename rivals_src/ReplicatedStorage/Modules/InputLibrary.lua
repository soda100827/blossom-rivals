local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("UserInputService")
game:GetService("HttpService")
local v3 = game:GetService("Players")
local v4 = require(v1.Modules.CONSTANTS)
local v_u_5 = require(v1.Modules.Utility)
local v_u_6 = v4.IS_CLIENT
if v_u_6 then
    v_u_6 = require(v3.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
end
local v_u_7 = v4.IS_CLIENT
if v_u_7 then
    v_u_7 = require(v3.LocalPlayer.PlayerScripts.Controllers.ControlsController)
end
local v_u_8 = {
    ["MouseWheel"] = "MouseWheel",
    ["MouseButton1"] = "MB1",
    ["MouseButton2"] = "MB2",
    ["MouseButton3"] = "MB3",
    ["LeftControl"] = "LCtrl",
    ["RightControl"] = "RCtrl",
    ["LeftShift"] = "LShift",
    ["RightShift"] = "RShift",
    ["Zero"] = "0",
    ["Tab"] = "Tab",
    ["LeftAlt"] = "LAlt",
    ["RAlt"] = "RAlt",
    ["Space"] = "Space"
}
local v_u_9 = {
    "One",
    "Two",
    "Three",
    "Four",
    "Five",
    "Six",
    "Seven",
    "Eight",
    "Nine",
    "Zero"
}
local v_u_10 = {
    ["MouseKeyboard"] = { "Settings Hotkey MouseKeyboard%s1", "Settings Hotkey MouseKeyboard%s2" },
    ["Gamepad"] = { "Settings Hotkey Gamepad%s1" }
}
local v_u_11 = {
    ["Short"] = {
        ["Base"] = "rbxassetid://16491694294",
        ["Pressed"] = "rbxassetid://16491693602",
        ["DisplayString"] = nil
    },
    ["Long"] = {
        ["Base"] = "rbxassetid://16491693870",
        ["Pressed"] = "rbxassetid://16491693385",
        ["DisplayString"] = nil
    },
    ["MB1"] = {
        ["Base"] = "rbxassetid://13194849055",
        ["Pressed"] = "rbxassetid://13194848851",
        ["DisplayString"] = ""
    },
    ["MB2"] = {
        ["Base"] = "rbxassetid://13194848725",
        ["Pressed"] = "rbxassetid://13194848539",
        ["DisplayString"] = ""
    },
    ["MB3"] = {
        ["Base"] = "rbxassetid://115443077181302",
        ["Pressed"] = "rbxassetid://121057755614364",
        ["DisplayString"] = ""
    }
}
local v_u_54 = {
    ["Inputs"] = {},
    ["ItemInputs"] = {},
    ["ItemInputTypeToName"] = {},
    ["MobileButtons"] = {},
    ["MobileInputNameToItemIndex"] = {},
    ["GetInputName"] = function(p12, p13)
        for v14 in pairs(v_u_54.Inputs) do
            if p12:InputIs(v14, p13) then
                return v14
            end
        end
    end,
    ["GetInputs"] = function(_, p15, p16)
        local v17 = v_u_54.Inputs[p15]
        if v17 then
            if not v17.IsHotkey then
                return v17.InputEnums[p16 or v_u_7.CurrentControls]
            end
            local v18 = {}
            for _, v19 in pairs(v_u_10[p16 or v_u_7.CurrentControls] or {}) do
                local v20 = v_u_5
                local v21 = v_u_6
                local v22 = string.format
                table.insert(v18, v20:GetInputEnumFromName(v21:Get(v22(v19, p15))))
            end
            return v18
        end
    end,
    ["GetInputIcons"] = function(p23, p_u_24, p_u_25)
        local v26, v27 = pcall(function()
            return v_u_2:GetImageForKeyCode(Enum[p_u_24][p_u_25])
        end)
        if v26 and v27 ~= "" then
            return v27, v27, ""
        end
        local v28 = p23:GetInputString(p_u_24, p_u_25)
        local v29 = v_u_11[v28] or v_u_11[#v28 == 1 and "Short" or "Long"]
        return v29.Base, v29.Pressed, v29.DisplayString or v28
    end,
    ["GetInputString"] = function(_, p30, p31)
        local v32 = v_u_8[p31]
        if v32 then
            return v32
        end
        local v33 = table.find(v_u_9, p31)
        if v33 then
            return tostring(v33)
        end
        local v34, v35 = pcall(v_u_2.GetStringForKeyCode, v_u_2, Enum[p30][p31])
        return not v34 or #v35 > 6 and string.sub(v35, 1, 6) == "Button" and string.sub(v35, 7) or (#v35 > 4 and string.sub(v35, 1, 4) == "DPad" and string.sub(v35, 5) or (v35 or ""))
    end,
    ["GetInputIconsByInputName"] = function(p36, p37, p38)
        local v39 = p36:FindFirstEnum(p37, p38)
        if not v39 then
            return v_u_11.Short.Base, v_u_11.Short.Pressed, ""
        end
        local v40 = v39.EnumType
        return p36:GetInputIcons(tostring(v40), v39.Name)
    end,
    ["FindFirstEnum"] = function(p41, p42, p43)
        local v44 = p41:GetInputs(p42, p43)
        if v44 then
            v44 = v44[1]
        end
        return v44
    end,
    ["InputIs"] = function(p45, p46, p47)
        local v48 = v_u_54.Inputs[p47]
        local v49 = p45:GetInputs(p47)
        if p46 == p47 or v48 and v48.MobileInputName == p46 then
            v49 = true
        elseif v49 then
            v49 = table.find(v49, p46.KeyCode) or table.find(v49, p46.UserInputType)
        end
        return v49
    end,
    ["IsInputDown"] = function(p50, p51, p52)
        if v_u_7:IsInputDown(p51) then
            return true
        end
        for _, v53 in pairs(p50:GetInputs(p51) or {}) do
            if not (p52 and table.find(p52, v53)) and v_u_7:IsInputDown(v53) then
                return true
            end
        end
    end
}
local function v65(p55, p56, p57, p58, p59, p60, p61, p62)
    local v63 = {
        ["IsItemInput"] = p55,
        ["IsHotkey"] = p56,
        ["InputName"] = p57,
        ["StartName"] = "Start" .. p57 .. "ing",
        ["FinishName"] = "Finish" .. p57 .. "ing",
        ["MobileInputName"] = nil,
        ["DisplayName"] = p58,
        ["Image"] = p59,
        ["InputEnums"] = {
            ["MouseKeyboard"] = p60 or {},
            ["Gamepad"] = p61 or {},
            ["Touch"] = {},
            ["VR"] = p62 or {}
        }
    }
    v_u_54.Inputs[p57] = v63
    if p55 then
        local v64 = v_u_54.ItemInputs
        table.insert(v64, p57)
        v_u_54.ItemInputTypeToName[v63.StartName] = p57
        v_u_54.ItemInputTypeToName[v63.FinishName] = p57
    end
end
v65(true, true, "Inspect", "Inspect", "rbxassetid://17513805400", { Enum.KeyCode.V }, { Enum.KeyCode.DPadDown }, nil)
v65(true, true, "Aim", "Aim (Action #1)", "rbxassetid://17513805525", { Enum.UserInputType.MouseButton2, Enum.KeyCode.E }, { Enum.KeyCode.ButtonL2 }, { Enum.KeyCode.ButtonR1, Enum.KeyCode.ButtonL1 })
v65(true, true, "Shoot", "Shoot (Action #2)", "rbxassetid://17513805027", { Enum.UserInputType.MouseButton1 }, { Enum.KeyCode.ButtonR2 }, { Enum.KeyCode.ButtonR2, Enum.KeyCode.ButtonL2 })
v65(true, true, "Reload", "Reload (Action #3)", "rbxassetid://17513813485", { Enum.KeyCode.R }, { Enum.KeyCode.ButtonX }, { Enum.KeyCode.ButtonY })
v65(true, true, "Sprint", "Sprint", "rbxassetid://17513821002", { Enum.KeyCode.LeftShift, Enum.KeyCode.RightShift }, { Enum.KeyCode.ButtonL3 }, { Enum.KeyCode.ButtonL3 })
v65(false, true, "Crouch", "Crouch", "rbxassetid://17513805623", { Enum.KeyCode.LeftControl, Enum.KeyCode.C }, { Enum.KeyCode.ButtonB }, { Enum.KeyCode.ButtonB })
v65(false, true, "Slide", "Slide", "rbxassetid://17524267716", nil, nil, nil)
v65(false, true, "SwitchCameraPOV", "Camera", "rbxassetid://17548980857", { Enum.KeyCode.B }, { Enum.KeyCode.DPadUp }, nil)
v65(false, true, "EquipPrimary", "Equip Primary", "rbxassetid://17539215512", { Enum.KeyCode.One }, nil, nil)
v65(false, true, "EquipSecondary", "Equip Secondary", "rbxassetid://17539215639", { Enum.KeyCode.Two }, nil, nil)
v65(false, true, "EquipMelee", "Equip Melee", "rbxassetid://17539235478", { Enum.KeyCode.Three }, nil, nil)
v65(false, true, "EquipUtility", "Equip Utility", "rbxassetid://17539235638", { Enum.KeyCode.Four }, nil, nil)
v65(false, true, "EquipLast", "Equip Previous Weapon", "rbxassetid://17513804864", nil, { Enum.KeyCode.ButtonL1 }, nil)
v65(false, true, "EquipNext", "Equip Next Weapon", "rbxassetid://17513804705", nil, { Enum.KeyCode.ButtonR1 }, { Enum.KeyCode.ButtonX })
v65(false, true, "Jump", "Jump", "rbxassetid://17513836637", { Enum.KeyCode.Space }, { Enum.KeyCode.ButtonA }, { Enum.KeyCode.ButtonA })
v65(false, true, "QuickMelee", "Melee", "rbxassetid://17506296977", { Enum.KeyCode.F }, { Enum.KeyCode.ButtonR3 }, nil)
v65(false, true, "QuickUtility", "Utility", "rbxassetid://17513805716", { Enum.KeyCode.G }, { Enum.KeyCode.ButtonY }, nil)
v65(false, true, "Ping", "Signal", "rbxassetid://17269776216", { Enum.UserInputType.MouseButton3 }, nil, nil)
v65(false, true, "OpenPlayerList", "Open Scoreboard", "rbxassetid://17513827700", { Enum.KeyCode.Tab, Enum.KeyCode.LeftAlt }, { Enum.KeyCode.DPadLeft }, nil)
v65(false, true, "SpectateLast", "Spectate Previous Player", "rbxassetid://17513823007", { Enum.UserInputType.MouseButton1 }, nil, nil)
v65(false, true, "SpectateNext", "Spectate Next Player", "rbxassetid://17513823007", { Enum.UserInputType.MouseButton2 }, { Enum.KeyCode.DPadRight }, nil)
v65(false, true, "SpectateExit", "Stop Spectating", "rbxassetid://17513823007", { Enum.KeyCode.M }, { Enum.KeyCode.DPadDown }, nil)
v65(false, true, "SwitchItems", "Switch Weapons", "rbxassetid://13667080363", { Enum.KeyCode.M }, { Enum.KeyCode.DPadDown }, nil)
v65(false, true, "LeaveDuel", "Leave Duel", "rbxassetid://17498605048", { Enum.KeyCode.M }, { Enum.KeyCode.DPadDown }, nil)
v65(false, true, "UseEmote", "Emote", "rbxassetid://82983645557125", { Enum.KeyCode.T }, { Enum.KeyCode.DPadRight }, nil)
v65(false, true, "HideHUD", "Hide HUD", "rbxassetid://17898066959", nil, nil, nil)
for v66 = 1, v4.MAX_EQUIPPABLE_EMOTES do
    v65(false, true, "UseEmote" .. v66, "Quick Emote " .. v66, "rbxassetid://82983645557125", nil, nil, nil)
end
v65(false, false, "LeanLeft", "Lean Left", "rbxassetid://17513844569", nil, nil, nil)
v65(false, false, "LeanRight", "Lean Right", "rbxassetid://17513844569", nil, nil, nil)
v65(false, false, "UICancelAction", "UI Cancel Action", "rbxassetid://17136633629", { Enum.KeyCode.Backspace, Enum.KeyCode.Escape }, { Enum.KeyCode.ButtonB }, nil)
v65(false, false, "UIPrimaryAction", "UI Primary Action", "rbxassetid://17136633629", nil, { Enum.KeyCode.ButtonX }, nil)
v65(false, false, "UISecondaryAction", "UI Secondary Action", "rbxassetid://17136633629", nil, { Enum.KeyCode.ButtonY }, nil)
v65(false, false, "UITertiaryAction", "UI Tertiary Action", "rbxassetid://17136633629", nil, { Enum.KeyCode.ButtonL1 }, nil)
v65(false, false, "UIQuaternaryAction", "UI Quaternary Action", "rbxassetid://17136633629", nil, { Enum.KeyCode.ButtonR1 }, nil)
v65(false, false, "UIOpenPage1", "UI Open Page 1", "rbxassetid://17136633629", nil, { Enum.KeyCode.DPadLeft }, nil)
v65(false, false, "UIOpenPage2", "UI Open Page 2", "rbxassetid://17136633629", nil, { Enum.KeyCode.DPadDown }, nil)
v65(false, false, "UIOpenPage3", "UI Open Page 3", "rbxassetid://17136633629", nil, { Enum.KeyCode.DPadRight }, nil)
v65(false, false, "UIOpenPage4", "UI Open Page 4", "rbxassetid://17136633629", nil, { Enum.KeyCode.DPadUp }, nil)
local function v80(p67, p68, p69, p70, p71, p72, p73, p74, p75, p76)
    local v77 = {
        ["IsCoreInput"] = p67,
        ["InputName"] = p69,
        ["Image"] = p70 or "rbxassetid://13695061446",
        ["DefaultPosition"] = p71,
        ["DefaultSize"] = p72,
        ["AlwaysVisible"] = p73,
        ["AlwaysToggle"] = p74,
        ["HideIfDead"] = not p75
    }
    for v78, v79 in pairs(p76 or {}) do
        v77[v78] = v79
    end
    v_u_54.MobileButtons[p68] = v77
    v_u_54.Inputs[p69].MobileInputName = p68
    if v77.ItemIndex then
        v_u_54.MobileInputNameToItemIndex[p68] = v77.ItemIndex
    end
end
v80(false, "mobile_aim", "Aim", "rbxassetid://13774376480", UDim2.new(1, -90, 1, -185), UDim2.new(0, 70, 0, 70))
v80(false, "mobile_shoot", "Shoot", "rbxassetid://13774376715", UDim2.new(1, -160, 1, -150), UDim2.new(0, 70, 0, 70))
v80(false, "mobile_reload", "Reload", "rbxassetid://13774376638", UDim2.new(1, -230, 1, -130), UDim2.new(0, 50, 0, 50))
v80(false, "mobile_inspect", "Inspect", "rbxassetid://13774376564", UDim2.new(0, 90, 0, 80), UDim2.new(0, 40, 0, 40))
v80(false, "mobile_quickmelee", "QuickMelee", "rbxassetid://13814923695", UDim2.new(1, -85, 0, 100), UDim2.new(0, 30, 0, 30), true)
v80(false, "mobile_quickutility", "QuickUtility", "rbxassetid://16600936252", UDim2.new(1, -40, 0, 100), UDim2.new(0, 30, 0, 30), true)
v80(true, "mobile_crouch", "Crouch", "rbxassetid://13814923555", UDim2.new(1, -185, 1, -75), UDim2.new(0, 70, 0, 70), true, true)
v80(true, "mobile_jump", "Jump", "rbxassetid://13774392305", UDim2.new(1, -90, 1, -90), UDim2.new(0, 80, 0, 80), true)
v80(true, "mobile_switchcamerapov", "SwitchCameraPOV", "rbxassetid://13774392495", UDim2.new(0, 40, 0, 80), UDim2.new(0, 40, 0, 40), true, nil, true)
v80(false, "mobile_openplayerlist", "OpenPlayerList", "rbxassetid://17319839617", UDim2.new(0, 140, 0, 80), UDim2.new(0, 40, 0, 40), true, nil, true)
v80(false, "mobile_equipprimary", "EquipPrimary", "rbxassetid://16793449322", UDim2.new(1, -175, 0, 60), UDim2.new(0, 40, 0, 40), true, nil, nil, {
    ["ItemIndex"] = 1
})
v80(false, "mobile_equipsecondary", "EquipSecondary", "rbxassetid://16793449322", UDim2.new(1, -130, 0, 60), UDim2.new(0, 40, 0, 40), true, nil, nil, {
    ["ItemIndex"] = 2
})
v80(false, "mobile_equipmelee", "EquipMelee", "rbxassetid://16793449322", UDim2.new(1, -85, 0, 60), UDim2.new(0, 40, 0, 40), true, nil, nil, {
    ["ItemIndex"] = 3
})
v80(false, "mobile_equiputility", "EquipUtility", "rbxassetid://16793449322", UDim2.new(1, -40, 0, 60), UDim2.new(0, 40, 0, 40), true, nil, nil, {
    ["ItemIndex"] = 4
})
v80(false, "mobile_useemote", "UseEmote", "rbxassetid://137981590006803", UDim2.new(0, 190, 0, 80), UDim2.new(0, 40, 0, 40), true)
return v_u_54