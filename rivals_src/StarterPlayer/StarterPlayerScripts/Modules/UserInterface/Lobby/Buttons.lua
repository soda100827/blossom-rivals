local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("GuiService")
local v_u_3 = game:GetService("Players")
local v_u_4 = require(v1.Modules.CONSTANTS)
local v_u_5 = require(v1.Modules.CosmeticLibrary)
local v_u_6 = require(v1.Modules.SeasonLibrary)
local v_u_7 = require(v1.Modules.InputLibrary)
local v_u_8 = require(v1.Modules.EventLibrary)
local v_u_9 = require(v1.Modules.TaskLibrary)
local v_u_10 = require(v1.Modules.ItemLibrary)
local v_u_11 = require(v_u_3.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController"))
local v_u_12 = require(v_u_3.LocalPlayer.PlayerScripts.Controllers:WaitForChild("ControlsController"))
require(v_u_3.LocalPlayer.PlayerScripts.Controllers:WaitForChild("ShopController"))
local v_u_13 = require(v_u_3.LocalPlayer.PlayerScripts.Modules:WaitForChild("CosmeticViewportFrame"))
local v_u_14 = require(v_u_3.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("MobileButtons"))
local v_u_15 = require(v_u_3.LocalPlayer.PlayerScripts.Modules:WaitForChild("EmoteViewportFrame"))
local v_u_16 = require(v_u_3.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Teleporting"))
local v_u_17 = require(v_u_3.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Equipment"))
local v_u_18 = require(v_u_3.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Queue"))
local v_u_19 = require(v_u_3.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Pages"))
local v_u_20 = require(v_u_3.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect"))
local v_u_21 = require(v_u_3.LocalPlayer.PlayerScripts.Modules:WaitForChild("UILibrary"))
local v_u_22 = v_u_3.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("LobbyButtonSlot")
local v_u_23 = {
    {
        "Backpack",
        "Backpack",
        "See your extra loot",
        "rbxassetid://18185474596"
    },
    {
        "Career",
        "Career",
        "Check out your collection & statistics",
        nil
    },
    {
        "Equipment",
        "Weapons",
        "View your weapons, career, emotes, & more",
        nil,
        "UIOpenPage1"
    },
    {
        "Tasks",
        "Tasks",
        "Complete tasks to earn keys",
        "rbxassetid://17653923757",
        "UIOpenPage2"
    },
    {
        "Shop",
        "Shop",
        "Unlock weapons, redeem codes, & more",
        "rbxassetid://17619445340",
        "UIOpenPage3"
    },
    {
        "BattlePass",
        "Pass",
        "Free weapons, skins, keys, & more",
        "rbxassetid://81577092220450",
        "UIOpenPage4"
    },
    {
        "Settings",
        "Settings",
        "Change crosshair & hotkeys",
        "rbxassetid://17619445191"
    },
    {
        "Rewards",
        "Codes",
        "Earn free rewards & redeem codes",
        "rbxassetid://84811629597038"
    },
    {
        "Recover",
        "Recover",
        "Recover your win streak",
        "rbxassetid://112615701583145"
    },
    {
        "EventOverview",
        "Event",
        "Here for a limited time only!",
        nil
    },
    {
        "EquipmentExit",
        "Leave",
        nil,
        "rbxassetid://17619444538",
        "UICancelAction"
    },
    {
        "Emotes",
        "Emotes",
        "Preview & equip your emotes",
        "rbxassetid://111957823189761",
        "UIOpenPage1"
    },
    {
        "Maps",
        "Maps",
        "View map details & map contracts",
        "rbxassetid://112880011932436",
        "UIOpenPage2"
    },
    {
        "DuelHistory",
        "History",
        "Check out your most recent duels",
        "rbxassetid://18678814606",
        "UIOpenPage3"
    },
    {
        "Collection",
        "Collection",
        "Quickly view your game progress",
        "rbxassetid://18186174849",
        "UIOpenPage4"
    },
    {
        "Contracts",
        "Contracts",
        "Earn free keys & cosmetics",
        "rbxassetid://17619445009"
    },
    {
        "Skins",
        "Skin",
        "Change how this weapon looks",
        nil,
        "UIOpenPage1"
    },
    {
        "Wraps",
        "Wrap",
        "Apply a wrap to this weapon",
        nil,
        "UIOpenPage2"
    },
    {
        "Charms",
        "Charm",
        "Equip a gun buddy",
        nil,
        "UIOpenPage3"
    },
    {
        "Finishers",
        "Finisher",
        "Play an effect on elimination",
        nil,
        "UIOpenPage4"
    }
}
local v_u_24 = {}
v_u_24.__index = v_u_24
function v_u_24._new()
    local v25 = v_u_24
    local v26 = setmetatable({}, v25)
    v26.IsOpen = false
    v26.Frame = v_u_21:GetTo("MainFrame", "Lobby", "Buttons")
    v26._visibility_effect_hash = 0
    v26._hover_effect_hash = 0
    v26._buttons = {}
    v26._button_callbacks = {}
    v26._unhover_functions = {}
    v26._wraps_cosmetic_viewport_frame = nil
    v26._charms_cosmetic_viewport_frame = nil
    v26._emotes_emote_viewport_frame = nil
    v26:_Init()
    return v26
end
function v_u_24._Unhover(p27)
    for _, v28 in pairs(p27._unhover_functions) do
        v28()
    end
end
function v_u_24._UpdateVisibility(p29)
    local v30 = not (v_u_19.PageSystem.CurrentPage or (v_u_17:IsUnlocking() or v_u_18:IsVisible() or (v_u_16.Enabled or v_u_14.EditorEnabled)))
    if v30 then
        v30 = not v_u_2.MenuIsOpen
    end
    p29.IsOpen = v30
    p29.Frame.Container:TweenPosition(p29.IsOpen and UDim2.new(0.5, 0, 0.9625, -20) or UDim2.new(0.5, 0, 1.3, 20), "Out", "Quint", 0.25, true)
    p29:_Unhover()
end
function v_u_24._PlayButtonVisibilityEffect(p_u_31)
    p_u_31._visibility_effect_hash = p_u_31._visibility_effect_hash + 1
    local v_u_32 = p_u_31._visibility_effect_hash
    local v33 = {}
    for _, v34 in pairs(p_u_31._buttons) do
        if v34.Visible then
            table.insert(v33, v34)
        end
    end
    table.sort(v33, function(p35, p36)
        return p35.LayoutOrder < p36.LayoutOrder
    end)
    for v37, v_u_38 in pairs(v33) do
        if v_u_2.ReducedMotionEnabled then
            v_u_38.Size = UDim2.new(1, 0, 1, 0)
            v_u_38:TweenSize(UDim2.new(1, 0, 1, 0), "Out", "Linear", 0, true)
        else
            v_u_38.Size = UDim2.new(0, 0, 0, 0)
            v_u_38:TweenSize(UDim2.new(0, 0, 0, 0), "Out", "Linear", 0, true)
            task.delay(0.1 * (v37 - 1), function()
                if v_u_32 == p_u_31._visibility_effect_hash then
                    v_u_38:TweenSize(UDim2.new(1, 0, 1, 0), "Out", "Back", 0.25, true)
                end
            end)
        end
    end
end
function v_u_24._UpdateButtonInformation(p39)
    if p39._wraps_cosmetic_viewport_frame then
        p39._wraps_cosmetic_viewport_frame:Destroy()
        p39._wraps_cosmetic_viewport_frame = nil
    end
    if p39._charms_cosmetic_viewport_frame then
        p39._charms_cosmetic_viewport_frame:Destroy()
        p39._charms_cosmetic_viewport_frame = nil
    end
    if p39._emotes_emote_viewport_frame then
        p39._emotes_emote_viewport_frame:Destroy()
        p39._emotes_emote_viewport_frame = nil
    end
    local v40 = v_u_11:Get("Seasons")[v_u_6.CurrentSeason.Name]
    if v40 then
        v40 = v40.BattlePass
    end
    local v41 = v40 and v40.MaxPassTrackNum or 0
    local v42 = p39._buttons.BattlePass.Button.Container.Icon
    local v43 = v_u_6.PASS_TRACK_IMAGES
    local v44 = #v_u_6.PASS_TRACK_IMAGES
    v42.Image = v43[math.clamp(v41, 1, v44)]
    local v45 = v_u_11:GetWeaponData(v_u_17:GetSelectedWeapon())
    local v46 = v45 and v45.Skin and (v45.Skin.Name or "NONE_COSMETIC") or "NONE_COSMETIC"
    local v47 = v_u_4.COSMETIC_IMAGES[v46]
    p39._buttons.Skins.Button.Container.Icon.Image = v47 or (v45 and (v_u_10:GetViewModelImageFromWeaponData(v45) or "") or "")
    p39._buttons.Skins.Button.Container.Icon.ImageTransparency = v47 and 0.875 or 0
    p39._buttons.Skins.Button.Container.Icon.Size = v47 and UDim2.new(0.4, 0, 0.4, 0) or UDim2.new(1.875, 0, 1.875, 0)
    local v48 = v45 and v45.Finisher and (v45.Finisher.Name or "NONE_COSMETIC") or "NONE_COSMETIC"
    local v49 = v_u_4.COSMETIC_IMAGES[v48]
    p39._buttons.Finishers.Button.Container.Icon.Image = v49 or v_u_5.Cosmetics[v45.Finisher.Name].Image
    p39._buttons.Finishers.Button.Container.Icon.ImageTransparency = v49 and 0.875 or 0
    p39._buttons.Finishers.Button.Container.Icon.Size = v49 and UDim2.new(0.4, 0, 0.4, 0) or UDim2.new(0.75, 0, 0.75, 0)
    p39._buttons.Finishers.Button.Container.Icon.UICorner.CornerRadius = v49 and UDim.new(0, 0) or UDim.new(1, 0)
    local v50 = v45 and v45.Wrap and (v45.Wrap.Name or "NONE_COSMETIC") or "NONE_COSMETIC"
    local v51 = v_u_4.COSMETIC_IMAGES[v50]
    p39._buttons.Wraps.Button.Container.Icon.Image = v51 or ""
    p39._buttons.Wraps.Button.Container.Icon.ImageTransparency = v51 and 0.875 or 0
    p39._buttons.Wraps.Button.Container.Icon.Size = v51 and UDim2.new(0.4, 0, 0.4, 0) or UDim2.new(0.75, 0, 0.75, 0)
    if v50 ~= "NONE_COSMETIC" and v50 ~= "RANDOM_COSMETIC" then
        p39._wraps_cosmetic_viewport_frame = v_u_13.new(v50)
        p39._wraps_cosmetic_viewport_frame.Frame.Parent = p39._buttons.Wraps.Button.Container
        local v52 = Instance.new("UICorner")
        v52.CornerRadius = UDim.new(1, 0)
        v52.Parent = p39._wraps_cosmetic_viewport_frame.Frame
    end
    local v53 = v45 and (v45.Charm and v45.Charm.Name) or "NONE_COSMETIC"
    local v54 = v_u_4.COSMETIC_IMAGES[v53]
    p39._buttons.Charms.Button.Container.Icon.Image = v54 or ""
    p39._buttons.Charms.Button.Container.Icon.ImageTransparency = v54 and 0.875 or 0
    p39._buttons.Charms.Button.Container.Icon.Size = v54 and UDim2.new(0.4, 0, 0.4, 0) or UDim2.new(0.75, 0, 0.75, 0)
    if v53 ~= "NONE_COSMETIC" and v53 ~= "RANDOM_COSMETIC" then
        p39._charms_cosmetic_viewport_frame = v_u_13.new(v53)
        p39._charms_cosmetic_viewport_frame.Frame.Parent = p39._buttons.Charms.Button.Container
        local v55 = Instance.new("UICorner")
        v55.CornerRadius = UDim.new(1, 0)
        v55.Parent = p39._charms_cosmetic_viewport_frame.Frame
    end
    local v56 = v_u_11:Get("EquippedEmotes")
    local v57 = not next(v56) and "NONE_COSMETIC" or nil
    local v58 = v_u_4.COSMETIC_IMAGES[v57]
    p39._buttons.Emotes.Button.Container.Icon.Image = v58 or ""
    p39._buttons.Emotes.Button.Container.Icon.ImageTransparency = v58 and 0.875 or 0
    p39._buttons.Emotes.Button.Container.Icon.Size = v58 and UDim2.new(0.4, 0, 0.4, 0) or UDim2.new(0.75, 0, 0.75, 0)
    if not v57 then
        local v59 = {}
        for _, v60 in pairs(v56) do
            local v61 = v60.Name
            table.insert(v59, v61)
        end
        local v62 = v59[math.random(#v59)]
        p39._emotes_emote_viewport_frame = v_u_15.new(v62)
        p39._emotes_emote_viewport_frame:HideShadow()
        p39._emotes_emote_viewport_frame:SetParent(p39._buttons.Emotes.Button.Container)
    end
end
function v_u_24._UpdateButtonVisibility(p63)
    local v64 = v_u_17.IsOpen
    local v65 = v_u_17:IsOpenEffectDone()
    local v66
    if v64 then
        v66 = v_u_17:IsCareerPageOpen()
    else
        v66 = v64
    end
    local v67
    if v64 then
        v67 = v_u_17:GetSelectedWeapon()
    else
        v67 = v64
    end
    local v68 = v_u_11:GetWeaponData(v67) ~= nil
    local v69 = not v_u_17:IsCustomizing()
    local v70 = v_u_11:GetStatistic("StatisticDuelsPlayed")
    v_u_11:GetStatistic("StatisticDuelsWon")
    local v71 = p63._buttons.Backpack
    local v72 = not v64
    if v72 then
        v72 = #v_u_11:Get("UnclaimedRewards") > 0
    end
    v71.Visible = v72
    p63._buttons.Career.Visible = false
    p63._buttons.Equipment.Visible = not v64
    p63._buttons.Tasks.Visible = not v64
    local v73 = p63._buttons.Shop
    local v74 = not v64
    if v74 then
        v74 = v70 >= 3
    end
    v73.Visible = v74
    local v75 = p63._buttons.BattlePass
    local v76 = not v64
    if v76 then
        if v70 >= 10 then
            v76 = v_u_6.CurrentSeason.BattlePassActive
        else
            v76 = false
        end
    end
    v75.Visible = v76
    local v77 = p63._buttons.Rewards
    local v78 = not v64
    if v78 then
        if v70 >= 5 then
            v78 = v70 < 15
        else
            v78 = false
        end
    end
    v77.Visible = v78
    local v79 = p63._buttons.Recover
    local v80 = not v64
    if v80 then
        v80 = #v_u_11:Get("StoredStreaks") > 0
    end
    v79.Visible = v80
    local v81 = p63._buttons.EventOverview
    local v82 = not v64 and v_u_8.IS_ACTIVE
    if v82 then
        v82 = v_u_8.NUM_GAMES_NEEDED_TO_PARTICIPATE <= v70
    end
    v81.Visible = v82
    local v83 = p63._buttons.EquipmentExit
    local v84
    if v64 then
        if v65 then
            v84 = v69
        else
            v84 = v65
        end
    else
        v84 = v64
    end
    v83.Visible = v84
    p63._buttons.Contracts.Visible = false
    local v85 = p63._buttons.Skins
    local v86
    if v64 then
        if v65 then
            if v68 then
                v86 = v69
            else
                v86 = v68
            end
        else
            v86 = v65
        end
    else
        v86 = v64
    end
    v85.Visible = v86
    local v87 = p63._buttons.Wraps
    local v88
    if v64 then
        if v65 then
            if v68 then
                v88 = v69
            else
                v88 = v68
            end
        else
            v88 = v65
        end
    else
        v88 = v64
    end
    v87.Visible = v88
    local v89 = p63._buttons.Charms
    local v90
    if v64 then
        if v65 then
            if v68 then
                v90 = v69
            else
                v90 = v68
            end
        else
            v90 = v65
        end
    else
        v90 = v64
    end
    v89.Visible = v90
    local v91 = p63._buttons.Finishers
    local v92 = v64 and (v65 and (v68 and (v69 and v_u_10.Items[v67])))
    if v92 then
        v92 = v_u_10.Items[v67].CanEliminate
    end
    v91.Visible = v92
    local v93 = p63._buttons.Emotes
    if v64 then
        if v65 then
            if not v66 then
                v69 = v66
            end
        else
            v69 = v65
        end
    else
        v69 = v64
    end
    v93.Visible = v69
    p63._buttons.Maps.Visible = false
    p63._buttons.DuelHistory.Visible = false
    p63._buttons.Collection.Visible = false
    local v94 = p63._buttons.Settings
    local v95 = not v64
    if v95 then
        v95 = not p63._buttons.Recover.Visible
    end
    v94.Visible = v95
    p63:_UpdateButtonInformation()
    p63:_PlayButtonVisibilityEffect()
    p63:_Unhover()
end
function v_u_24._CreateButton(p96, p97, p_u_98, p99, p_u_100, p101, p102)
    local v_u_103 = v_u_22:Clone()
    v_u_103.Button.Container.Title.Text = p99
    v_u_103.Button.Container.Icon.Image = p101 or ""
    v_u_103.Button.Container.Bubble.Title.Text = p_u_100 or ""
    v_u_103.Button.Inputs.Gamepad.Keybind:SetAttribute("InputName", p102)
    v_u_103.LayoutOrder = p97
    local v_u_104 = 0
    local function v107()
        if not v_u_103.Button.Container.NotificationBubble.Visible then
            v_u_104 = v_u_104 + 1
            local v_u_105 = v_u_104
            local v106 = v_u_103:IsDescendantOf(v_u_3)
            if v106 then
                v_u_103.Button.Container:TweenPosition(UDim2.new(0.5, 0, 0.375, 0), "Out", "Quint", 0.25, true)
            else
                v_u_103.Button.Container.Position = UDim2.new(0.5, 0, 0.375, 0)
            end
            if p_u_100 then
                v_u_103.Button.Container.Bubble.Visible = true
                v_u_103.Button.Container.Bubble.Position = UDim2.new(0.5, 0, 0, 0)
                if v106 then
                    v_u_103.Button.Container.Bubble.Size = UDim2.new(0, 0, 0.125, 0)
                    v_u_103.Button.Container.Bubble:TweenSize(UDim2.new(5, 0, 0.25, 0), "Out", "Quint", 0.25, true)
                else
                    v_u_103.Button.Container.Bubble.Size = UDim2.new(5, 0, 0.25, 0)
                end
                task.spawn(function()
                    wait(1)
                    while v_u_105 == v_u_104 do
                        if v_u_103:IsDescendantOf(v_u_3) then
                            v_u_103.Button.Container.Bubble:TweenPosition(UDim2.new(0.5, 0, -0.125, 0), "Out", "Sine", 0.5, true)
                        end
                        wait(0.5)
                        if v_u_105 ~= v_u_104 then
                            return
                        end
                        if v_u_103:IsDescendantOf(v_u_3) then
                            v_u_103.Button.Container.Bubble:TweenPosition(UDim2.new(0.5, 0, 0, 0), "In", "Sine", 0.5, true)
                        end
                        wait(0.5)
                    end
                end)
            end
        end
    end
    v_u_103.Button.MouseEnter:Connect(v107)
    if p_u_98 == "Tasks" and v_u_11:Get("BeginnerTasksCompleted") < v_u_9.NUM_BEGINNER_TASKS then
        v107()
    end
    if p_u_98 ~= "Shop" then
        if p_u_98 == "Backpack" then
            local v_u_108 = #(v_u_11:Get("UnclaimedRewards") or {})
            local v_u_109 = 0
            v_u_11:GetDataChangedSignal("UnclaimedRewards"):Connect(function()
                local v110 = #(v_u_11:Get("UnclaimedRewards") or {})
                local v111 = v_u_109
                local v112 = v110 - v_u_108
                v_u_109 = v111 + math.max(0, v112)
                v_u_108 = v110
                v_u_103.Button.Container.Notification.Visible = v_u_109 > 0
                v_u_103.Button.Container.Notification.Title.Text = v_u_109
            end)
            v_u_19.PageSystem.PageOpened:Connect(function()
                if v_u_19.PageSystem.CurrentPage.Name == "Backpack" then
                    v_u_109 = 0
                    v_u_103.Button.Container.Notification.Visible = false
                end
            end)
        elseif p_u_98 == "Tasks" then
            local function v114()
                local v113 = #v_u_11:Get("Tasks") - v_u_11:GetNumTasksCompleted()
                v_u_103.Button.Container.Notification.Visible = v113 > 0
                v_u_103.Button.Container.Notification.Title.Text = v113
            end
            v_u_11:GetDataChangedSignal("BonusTasks"):Connect(v114)
            v_u_11:GetDataChangedSignal("Tasks"):Connect(v114)
            local v115 = #v_u_11:Get("Tasks") - v_u_11:GetNumTasksCompleted()
            v_u_103.Button.Container.Notification.Visible = v115 > 0
            v_u_103.Button.Container.Notification.Title.Text = v115
        elseif p_u_98 == "BattlePass" then
            local function v124()
                local v116 = 0
                local v117 = v_u_11:Get("Seasons")[v_u_6.CurrentSeason.Name]
                if v117 then
                    v117 = v117.BattlePass
                end
                local v118 = v117 and (v117.PassLevel or 0) or 0
                local v119 = v117 and (v117.MaxPassTrackNum or 0) or 0
                for v120 = 1, v118 do
                    for v121 = 1, v119 do
                        if v_u_6.CurrentSeason.BattlePassRewards[v120] and v_u_6.CurrentSeason.BattlePassRewards[v120][v121] then
                            local v122
                            if v120 <= v118 then
                                v122 = v121 <= v119
                            else
                                v122 = false
                            end
                            local v123 = v117 and v117.RewardsClaimed[tostring(v120)]
                            if v123 then
                                v123 = v117.RewardsClaimed[tostring(v120)][tostring(v121)]
                            end
                            if v122 and not v123 then
                                v116 = v116 + 1
                            end
                        end
                    end
                end
                v_u_103.Button.Container.Notification.Visible = v116 > 0
                v_u_103.Button.Container.Notification.Title.Text = v116
            end
            v_u_11:GetDataChangedSignal("Seasons"):Connect(v124)
            v124()
        elseif p_u_98 == "Equipment" or (p_u_98 == "Skins" or (p_u_98 == "Wraps" or (p_u_98 == "Charms" or (p_u_98 == "Finishers" or p_u_98 == "Emotes")))) then
            local function v132()
                local v125 = v_u_11:Get("CosmeticNotifications")
                local v126 = v_u_11:GetUnlockedWeapons(true)
                local v127 = v_u_17:GetSelectedWeapon()
                local v128
                if p_u_98 == "Equipment" then
                    v128 = v_u_5:CountNotifications(v125, nil, v126)
                else
                    local v129 = v_u_5
                    local v130 = p_u_98
                    local v131 = #p_u_98 - 1
                    v128 = v129:CountNotificationsByCosmeticType(v125, string.sub(v130, 1, v131), v127, v126)
                end
                v_u_103.Button.Container.Notification.Visible = v128 > 0
                v_u_103.Button.Container.Notification.Title.Text = v128
            end
            v_u_11:GetDataChangedSignal("CosmeticNotifications"):Connect(v132)
            v_u_11:GetDataChangedSignal("WeaponInventory"):Connect(v132)
            v_u_17.SelectedWeaponChanged:Connect(v132)
            v132()
        end
    end
    if p_u_98 == "Equipment" then
        local function v137()
            if v_u_19.PageSystem.CurrentPage then
                v_u_103.Button.Container.NotificationBubble.Visible = false
                return
            end
            local v133 = v_u_11:Get("UnlockTokens")
            local v134
            if v133 then
                if v133 > 0 then
                    v134 = not v_u_11:OwnsAllWeapons("Standard", true, true)
                else
                    v134 = false
                end
            else
                v134 = v133
            end
            local v135 = 0
            for v136 in pairs(v_u_11:Get("FreeWeaponUnlockCheck")) do
                if not v_u_11:GetWeaponData(v136) then
                    v135 = v135 + 1
                    if v135 >= 2 then
                        break
                    end
                end
            end
            v_u_103.Button.Container.NotificationBubble.Visible = v135 > 0 and true or v134
            v_u_103.Button.Container.NotificationBubble.Title.Text = v135 > 1 and "Unlock your new weapons!" or (v135 == 1 and "Unlock your new weapon!" or (v134 and ("You have " .. v133 .. " free weapon unlock" .. (v133 == 1 and "" or "s") .. "!" or "") or ""))
        end
        v_u_11:GetDataChangedSignal("FreeWeaponUnlockCheck"):Connect(v137)
        v_u_11:GetDataChangedSignal("WeaponInventory"):Connect(v137)
        v_u_11:GetDataChangedSignal("UnlockTokens"):Connect(v137)
        v_u_19.PageSystem.PageOpened:Connect(v137)
        v_u_19.PageSystem.PageClosed:Connect(v137)
        v137()
    end
    p96._unhover_functions[p_u_98] = function()
        v_u_104 = v_u_104 + 1
        v_u_103.Button.Container:TweenPosition(UDim2.new(0.5, 0, 0.5, 0), "Out", "Quint", 0.25, true)
        v_u_103.Button.Container.Bubble.Visible = false
    end
    v_u_103.Button.MouseLeave:Connect(p96._unhover_functions[p_u_98])
    v_u_103.Visible = false
    v_u_103.Parent = p96.Frame.Container.List
    p96._buttons[p_u_98] = v_u_103
    v_u_20:Add(v_u_103.Button)
    local function v138()
        v_u_103.Button.Container.Bubble.Background.Size = UDim2.new(0, v_u_103.Button.Container.Bubble.Title.TextBounds.X + v_u_103.Button.Container.Bubble.Background.AbsoluteSize.Y, 1, 0)
    end
    v_u_103.Button.Container.Bubble.Title:GetPropertyChangedSignal("TextBounds"):Connect(v138)
    v_u_103.Button.Container.Bubble.Background:GetPropertyChangedSignal("AbsoluteSize"):Connect(v138)
    v_u_103.Button.Container.Bubble.Background.Size = UDim2.new(0, v_u_103.Button.Container.Bubble.Title.TextBounds.X + v_u_103.Button.Container.Bubble.Background.AbsoluteSize.Y, 1, 0)
end
function v_u_24._OnButtonClicked(p139, p140, p141)
    p139._buttons[p140].Button.MouseButton1Click:Connect(p141)
    p139._button_callbacks[p140] = p141
end
function v_u_24._Setup(p142)
    for v143, v144 in pairs(v_u_23) do
        p142:_CreateButton(v143, table.unpack(v144))
    end
    p142:_OnButtonClicked("Career", function()
        v_u_19.PageSystem:CloseCurrentPage()
        v_u_17:Open()
        v_u_17:OpenCareerPage(true)
    end)
    p142:_OnButtonClicked("Equipment", function()
        v_u_19.PageSystem:CloseCurrentPage()
        v_u_17:Open()
        if v_u_17:IsCareerPageOpen() then
            v_u_17:SelectWeapon(v_u_4.DEFAULT_WEAPONS[1])
        end
    end)
    p142:_OnButtonClicked("EquipmentExit", function()
        v_u_17:CloseRequest()
    end)
    p142:_OnButtonClicked("Tasks", function()
        v_u_19.PageSystem:OpenPage("Tasks")
    end)
    p142:_OnButtonClicked("Settings", function()
        v_u_19.PageSystem:OpenPage("Settings")
    end)
    p142:_OnButtonClicked("Charms", function()
        v_u_17:StartCustomizing("Charm")
    end)
    p142:_OnButtonClicked("Finishers", function()
        v_u_17:StartCustomizing("Finisher")
    end)
    p142:_OnButtonClicked("Wraps", function()
        v_u_17:StartCustomizing("Wrap")
    end)
    p142:_OnButtonClicked("Skins", function()
        v_u_17:StartCustomizing("Skin")
    end)
    p142:_OnButtonClicked("Contracts", function()
        v_u_19.PageSystem:OpenPage("Contracts")
        v_u_19.PageSystem:WaitForPage("Contracts"):SetWeapon(v_u_17:GetSelectedWeapon())
    end)
    p142:_OnButtonClicked("Shop", function()
        v_u_19.PageSystem:OpenPage("Shop")
        v_u_19.PageSystem:WaitForPage("Shop"):SetPage("Home")
    end)
    p142:_OnButtonClicked("Rewards", function()
        v_u_19.PageSystem:OpenPage("Rewards")
    end)
    p142:_OnButtonClicked("Backpack", function()
        v_u_19.PageSystem:OpenPage("Backpack")
    end)
    p142:_OnButtonClicked("Collection", function()
        v_u_19.PageSystem:OpenPage("Collection")
    end)
    p142:_OnButtonClicked("Recover", function()
        v_u_19.PageSystem:OpenPage("StreakRecovery")
    end)
    p142:_OnButtonClicked("EventOverview", function()
        v_u_19.PageSystem:OpenPage("EventOverview")
    end)
    p142:_OnButtonClicked("DuelHistory", function()
        v_u_19.PageSystem:OpenPage("DuelHistory")
    end)
    p142:_OnButtonClicked("Maps", function()
        v_u_19.PageSystem:OpenPage("Maps")
    end)
    p142:_OnButtonClicked("Emotes", function()
        v_u_17:StartCustomizing("Emote")
    end)
    p142:_OnButtonClicked("BattlePass", function()
        v_u_19.PageSystem:OpenPage("BattlePass")
    end)
    p142._buttons.Career.Button.Container.Icon.Image = string.format(v_u_4.HEADSHOT_IMAGE, v_u_3.LocalPlayer.UserId)
    p142._buttons.Equipment.Button.Container.Icon.Image = v_u_10.ViewModels["Assault Rifle"].Image
    p142._buttons.Equipment.Button.Container.Icon.Size = UDim2.new(1.875, 0, 1.875, 0)
    p142._buttons.EventOverview.Button.Container.Icon.Image = v_u_8.EVENT_DETAILS.OVERVIEW_BUTTON_IMAGE
    p142._buttons.EventOverview.Button.Container.Icon.Size = UDim2.new(1, 0, 1, 0)
    p142._buttons.BattlePass.Button.Container.Icon.Position = UDim2.new(0.55, 0, 0.5, 0)
    p142._buttons.BattlePass.Button.Container.Icon.Size = UDim2.new(0.875, 0, 0.875, 0)
    local v145 = Instance.new("UICorner")
    v145.CornerRadius = UDim.new(1, 0)
    v145.Parent = p142._buttons.Career.Button.Container.Icon
    v145:Clone().Parent = p142._buttons.Finishers.Button.Container.Icon
end
function v_u_24._Init(p_u_146)
    p_u_146.Frame.Container.List.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p_u_146.Frame.Container.Background.Visible = p_u_146.Frame.Container.List.Layout.AbsoluteContentSize.X > 0
        p_u_146.Frame.Container.Background.Size = UDim2.new(0.5, p_u_146.Frame.Container.List.Layout.AbsoluteContentSize.X, 0.5, 0)
    end)
    v_u_17.Opened:Connect(function()
        p_u_146:_UpdateButtonVisibility()
    end)
    v_u_17.SelectedWeaponChanged:Connect(function()
        p_u_146:_UpdateButtonVisibility()
    end)
    v_u_17.CareerPageOpened:Connect(function()
        p_u_146:_UpdateButtonVisibility()
    end)
    v_u_17.CustomizingChanged:Connect(function()
        p_u_146:_UpdateButtonVisibility()
    end)
    v_u_17.FinishedOpenEffect:Connect(function()
        p_u_146:_UpdateButtonVisibility()
    end)
    v_u_17.UnlockingChanged:Connect(function()
        p_u_146:_UpdateVisibility()
    end)
    v_u_19.PageSystem.PageOpened:Connect(function()
        p_u_146:_UpdateVisibility()
    end)
    v_u_19.PageSystem.PageClosed:Connect(function()
        p_u_146:_UpdateVisibility()
    end)
    v_u_18.VisibilityChanged:Connect(function()
        p_u_146:_UpdateVisibility()
    end)
    v_u_16.EnabledChanged:Connect(function()
        p_u_146:_UpdateVisibility()
    end)
    v_u_14.EditorEnabledChanged:Connect(function()
        p_u_146:_UpdateVisibility()
    end)
    v_u_11:GetDataChangedSignal("Seasons"):Connect(function()
        p_u_146:_UpdateButtonInformation()
    end)
    v_u_11:GetDataChangedSignal("WeaponInventory"):Connect(function()
        p_u_146:_UpdateButtonInformation()
        p_u_146:_UpdateButtonVisibility()
    end)
    v_u_11:GetDataChangedSignal("UnclaimedRewards"):Connect(function()
        p_u_146:_UpdateButtonVisibility()
    end)
    v_u_11:GetDataChangedSignal("GroupRank"):Connect(function()
        p_u_146:_UpdateButtonVisibility()
    end)
    v_u_11:GetDataChangedSignal("StoredStreaks"):Connect(function()
        p_u_146:_UpdateButtonVisibility()
    end)
    v_u_11:GetDataChangedSignal("StatisticDuelsPlayed"):Connect(function()
        p_u_146:_UpdateButtonVisibility()
    end)
    v_u_11:GetDataChangedSignal("StatisticDuelsWon"):Connect(function()
        p_u_146:_UpdateButtonVisibility()
    end)
    v_u_2:GetPropertyChangedSignal("MenuIsOpen"):Connect(function()
        p_u_146:_UpdateVisibility()
    end)
    v_u_12.InputBegan:Connect(function(p147, p148)
        if not p148 and (p_u_146.IsOpen and p_u_146.Frame.Visible) then
            for _, v149 in pairs(v_u_23) do
                local v150 = v149[1]
                local v151 = v149[5]
                if v151 and (p_u_146._buttons[v150].Visible and v_u_7:InputIs(p147, v151)) then
                    p_u_146._button_callbacks[v150]()
                    return
                end
            end
        end
    end)
    p_u_146:_Setup()
    p_u_146:_UpdateButtonVisibility()
    p_u_146:_UpdateVisibility()
end
return v_u_24._new()