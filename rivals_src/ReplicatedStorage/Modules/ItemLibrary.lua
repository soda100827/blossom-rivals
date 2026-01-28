local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = require(v1.Modules.CONSTANTS)
local v_u_3 = require(v1.Modules.AnimationLibrary)
local v_u_4 = require(v1.Modules.Utility)
local v_u_5 = {}
local v_u_23 = {
    ["QUICK_ATTACK_ITEM_INDEX_DEFAULTS"] = {
        ["Melee"] = 3,
        ["Utility"] = 4
    },
    ["QUICK_ATTACK_COOLDOWN"] = 0,
    ["KEEP_QUICK_ATTACK_HOLD_DURATION"] = 0.25,
    ["THIRD_PERSON_VIEWMODEL_BLACKLIST"] = {
        ["Fists"] = true,
        ["Hand Gun"] = true
    },
    ["UNIVERSAL_WEAPON_ICON"] = "rbxassetid://123867892559041",
    ["RANDOM_WEAPON_ICON"] = "rbxassetid://132973552546079",
    ["Statuses"] = {},
    ["StatusByPassTrackNum"] = {},
    ["Classes"] = {},
    ["SlotToClass"] = {},
    ["Types"] = {},
    ["Ammos"] = {},
    ["Crosshairs"] = {},
    ["ViewModels"] = {},
    ["ViewModelOrder"] = {},
    ["Charms"] = {},
    ["Items"] = {},
    ["ItemsAlphabetized"] = {},
    ["ItemOrder"] = {},
    ["GetViewModelImage"] = function(p6, p7, p8, p9)
        if p7 then
            local v10 = p6.ViewModels
            if p8 and p8.Name ~= "RANDOM_COSMETIC" then
                p7 = p8.Name or p7
            end
            p7 = v10[p7]
        end
        local v11
        if p7 then
            v11 = p7[p9 and "ImageHighResolution" or "Image"] or nil
        else
            v11 = nil
        end
        return v11
    end,
    ["GetViewModelImageFromWeaponData"] = function(p12, p13, p14)
        return p13 and p12:GetViewModelImage(p13.Name, p13.Skin, p14) or nil
    end,
    ["FormatWeaponNamesByClass"] = function(_, p15, p16, p17)
        local v18 = {}
        for v19 in pairs(v_u_23.Classes) do
            v18[v19] = {}
        end
        for _, v20 in pairs(p15) do
            if not p16 or p16(v20) then
                if p17 then
                    for _, v21 in pairs(v18) do
                        table.insert(v21, v20)
                    end
                else
                    local v22 = v18[v_u_23.Items[v20].Class]
                    table.insert(v22, v20)
                end
            end
        end
        return v18
    end
}
local v_u_24 = {}
local function v33(p25, p26, p27, p28, p29, p30)
    local v31 = p29 or p27
    local v32 = {
        ["Name"] = p25,
        ["Value"] = p26,
        ["Color"] = p27,
        ["PassTrackNum"] = p28,
        ["PassColor"] = v31,
        ["DarkPassColor"] = p30 or Color3.new(v31.R / 4, v31.G / 4, v31.B / 4)
    }
    v_u_23.Statuses[p25] = v32
    v_u_23.StatusByPassTrackNum[p28] = v32
end
v33("Standard", 1, Color3.fromRGB(127, 127, 127), 1, Color3.fromRGB(255, 255, 255), Color3.fromRGB(0, 0, 0))
v33("Prime", 2, Color3.fromRGB(255, 215, 0), 2)
v33("Contraband", 3, Color3.fromRGB(116, 61, 255), 3)
local v34 = {
    ["Name"] = "Primary",
    ["Slot"] = 1,
    ["ImageDiagonalRight"] = "rbxassetid://17225649668",
    ["ImageDiagonalLeft"] = "rbxassetid://17225650124"
}
v_u_23.Classes.Primary = v34
v_u_23.SlotToClass[v34.Slot] = v34
local v35 = {
    ["Name"] = "Secondary",
    ["Slot"] = 2,
    ["ImageDiagonalRight"] = "rbxassetid://17225650488",
    ["ImageDiagonalLeft"] = "rbxassetid://17225650697"
}
v_u_23.Classes.Secondary = v35
v_u_23.SlotToClass[v35.Slot] = v35
local v36 = {
    ["Name"] = "Melee",
    ["Slot"] = 3,
    ["ImageDiagonalRight"] = "rbxassetid://17225650859",
    ["ImageDiagonalLeft"] = "rbxassetid://17225651107"
}
v_u_23.Classes.Melee = v36
v_u_23.SlotToClass[v36.Slot] = v36
local v37 = {
    ["Name"] = "Utility",
    ["Slot"] = 4,
    ["ImageDiagonalRight"] = "rbxassetid://17225651405",
    ["ImageDiagonalLeft"] = "rbxassetid://17225651564"
}
v_u_23.Classes.Utility = v37
v_u_23.SlotToClass[v37.Slot] = v37
v_u_23.Types.Custom = {
    ["Name"] = "Custom"
}
v_u_23.Types.Melee = {
    ["Name"] = "Melee"
}
v_u_23.Types.Gun = {
    ["Name"] = "Gun"
}
v_u_23.Types.Throwable = {
    ["Name"] = "Throwable"
}
v_u_23.Ammos.Light = {
    ["Image"] = "rbxassetid://16539130564"
}
v_u_23.Ammos.Medium = {
    ["Image"] = "rbxassetid://16539130428"
}
v_u_23.Ammos.Heavy = {
    ["Image"] = "rbxassetid://13223128254"
}
v_u_23.Ammos.Shells = {
    ["Image"] = "rbxassetid://16539130288"
}
v_u_23.Ammos.Rockets = {
    ["Image"] = "rbxassetid://13223319925"
}
v_u_23.Ammos.Arrows = {
    ["Image"] = "rbxassetid://13695602038"
}
v_u_23.Ammos.Fuel = {
    ["Image"] = "rbxassetid://13677095789"
}
v_u_23.Ammos.Ball = {
    ["Image"] = "rbxassetid://16538992521"
}
v_u_23.Ammos.Grenade = {
    ["Image"] = "rbxassetid://129377039777545"
}
v_u_23.Ammos.Tripmine = {
    ["Image"] = "rbxassetid://88187393143256"
}
v_u_23.Ammos["Jump Pad"] = {
    ["Image"] = "rbxassetid://77150422264251"
}
v_u_23.Ammos.Daggers = {
    ["Image"] = "rbxassetid://94738849714281"
}
v_u_23.Crosshairs.Default = {
    ["IsSpecial"] = nil,
    ["DotEnabled"] = true,
    ["DotImage"] = "rbxassetid://15085011006",
    ["DotSize"] = nil,
    ["BarsEnabled"] = true,
    ["TopBarImage"] = "rbxassetid://15085011006",
    ["TopBarSize"] = nil,
    ["BottomBarImage"] = "rbxassetid://15085011006",
    ["BottomBarSize"] = nil,
    ["LeftBarImage"] = "rbxassetid://15085011006",
    ["LeftBarSize"] = nil,
    ["RightBarImage"] = "rbxassetid://15085011006",
    ["RightBarSize"] = nil,
    ["CircleEnabled"] = true,
    ["CircleSize"] = nil,
    ["CircleThickness"] = nil
}
v_u_23.Crosshairs.Bars = {
    ["IsSpecial"] = nil,
    ["DotEnabled"] = false,
    ["DotImage"] = "rbxassetid://15085011006",
    ["DotSize"] = nil,
    ["BarsEnabled"] = true,
    ["TopBarImage"] = "rbxassetid://15085011006",
    ["TopBarSize"] = nil,
    ["BottomBarImage"] = "rbxassetid://15085011006",
    ["BottomBarSize"] = nil,
    ["LeftBarImage"] = "rbxassetid://15085011006",
    ["LeftBarSize"] = nil,
    ["RightBarImage"] = "rbxassetid://15085011006",
    ["RightBarSize"] = nil,
    ["CircleEnabled"] = false,
    ["CircleSize"] = nil,
    ["CircleThickness"] = nil
}
v_u_23.Crosshairs.Dot = {
    ["IsSpecial"] = nil,
    ["DotEnabled"] = true,
    ["DotImage"] = "rbxassetid://15085011006",
    ["DotSize"] = nil,
    ["BarsEnabled"] = false,
    ["TopBarImage"] = "rbxassetid://15085011006",
    ["TopBarSize"] = nil,
    ["BottomBarImage"] = "rbxassetid://15085011006",
    ["BottomBarSize"] = nil,
    ["LeftBarImage"] = "rbxassetid://15085011006",
    ["LeftBarSize"] = nil,
    ["RightBarImage"] = "rbxassetid://15085011006",
    ["RightBarSize"] = nil,
    ["CircleEnabled"] = true,
    ["CircleSize"] = nil,
    ["CircleThickness"] = nil
}
v_u_23.Crosshairs.None = {
    ["IsSpecial"] = nil,
    ["DotEnabled"] = false,
    ["DotImage"] = "rbxassetid://15085011006",
    ["DotSize"] = nil,
    ["BarsEnabled"] = false,
    ["TopBarImage"] = "rbxassetid://15085011006",
    ["TopBarSize"] = nil,
    ["BottomBarImage"] = "rbxassetid://15085011006",
    ["BottomBarSize"] = nil,
    ["LeftBarImage"] = "rbxassetid://15085011006",
    ["LeftBarSize"] = nil,
    ["RightBarImage"] = "rbxassetid://15085011006",
    ["RightBarSize"] = nil,
    ["CircleEnabled"] = false,
    ["CircleSize"] = nil,
    ["CircleThickness"] = nil
}
local v38 = UDim2.new(0, 28, 0, 28)
local v39 = UDim2.new(0, 28, 0, 28)
local v40 = UDim2.new(0, 28, 0, 28)
local v41, v42, v43 = UDim2.new(0, 28, 0, 28)
v_u_23.Crosshairs.Spread = {
    ["IsSpecial"] = true,
    ["DotEnabled"] = false,
    ["DotImage"] = v42 or "rbxassetid://15085011006",
    ["DotSize"] = v43,
    ["BarsEnabled"] = true,
    ["TopBarImage"] = "rbxassetid://13492281669",
    ["TopBarSize"] = v38,
    ["BottomBarImage"] = "rbxassetid://14810785706",
    ["BottomBarSize"] = v39,
    ["LeftBarImage"] = "rbxassetid://13492281550",
    ["LeftBarSize"] = v40,
    ["RightBarImage"] = "rbxassetid://14810785574",
    ["RightBarSize"] = v41,
    ["CircleEnabled"] = false,
    ["CircleSize"] = nil,
    ["CircleThickness"] = nil
}
local v44 = UDim2.new(0, 28, 0, 28)
local v45 = UDim2.new(0, 28, 0, 28)
local v46 = UDim2.new(0, 28, 0, 28)
local v47, v48, v49 = UDim2.new(0, 28, 0, 28)
v_u_23.Crosshairs.SpreadH = {
    ["IsSpecial"] = true,
    ["DotEnabled"] = false,
    ["DotImage"] = v48 or "rbxassetid://15085011006",
    ["DotSize"] = v49,
    ["BarsEnabled"] = true,
    ["TopBarImage"] = "rbxassetid://13693685835",
    ["TopBarSize"] = v44,
    ["BottomBarImage"] = "rbxassetid://13693685835",
    ["BottomBarSize"] = v45,
    ["LeftBarImage"] = "rbxassetid://13492281550",
    ["LeftBarSize"] = v46,
    ["RightBarImage"] = "rbxassetid://14810785574",
    ["RightBarSize"] = v47,
    ["CircleEnabled"] = false,
    ["CircleSize"] = nil,
    ["CircleThickness"] = nil
}
local function v72(p50, p51, p52, p53, p54, p55, p56, p57, p58, p59, p60, p61, p62, p63)
    local v64 = {
        ["Image"] = p51,
        ["ImageHighResolution"] = p52,
        ["ImageCentered"] = p53,
        ["EliminationFeedImage"] = p54,
        ["EliminationFeedImageScale"] = p55,
        ["RootPartOffset"] = p56 or CFrame.identity,
        ["Animations"] = {
            ["Equip"] = p57,
            ["Idle"] = p58,
            ["Sprint"] = p59,
            ["Inspect"] = p60,
            ["RareInspect"] = p61
        }
    }
    for v65, v66 in pairs(p62 or {}) do
        v64.Animations[v65] = v66
    end
    for _, v67 in pairs(v64.Animations) do
        local v68 = v_u_3.Info[v67] ~= nil
        assert(v68, v67)
    end
    for v69, v70 in pairs(p63 or {}) do
        v64[v69] = v70
    end
    v_u_23.ViewModels[p50] = v64
    local v71 = v_u_23.ViewModelOrder
    table.insert(v71, p50)
    if string.find(p51, "_") then
        warn("Image missing:", p50)
    end
    if string.find(p52, "_") then
        task.defer(warn, "ImageHighResolution missing:", p50)
    end
    if v_u_5[p51] and not string.find(p51, "_") then
        warn("Image already exists:", p50)
    end
    if v_u_5[p52] and not string.find(p52, "_") then
        warn("ImageHighResolution already exists:", p50)
    end
    if p54 and (v_u_5[p54] and not string.find(p54, "_")) then
        warn("EliminationFeedImage already exists:", p50)
    end
    if p50 ~= "MISSING_WEAPON" and p50 ~= "MISSING_SKIN" then
        v_u_5[p51] = true
        v_u_5[p52] = true
    end
    if p54 then
        v_u_5[p54] = true
    end
end
v72("MISSING_WEAPON", "rbxassetid://124519084257039", "rbxassetid://124519084257039", nil, nil, nil, CFrame.new(0, -0.125, -0.125) * CFrame.Angles(0.04363323129985824, 0, 0), "assaultrifle_equip", "assaultrifle_idle", "assaultrifle_sprint", "assaultrifle_inspect", nil, {
    ["Shoot1"] = "assaultrifle_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "assaultrifle_reload",
    ["EmptyReload"] = nil
})
v72("MISSING_SKIN", "rbxassetid://124519084257039", "rbxassetid://124519084257039", nil, nil, nil, CFrame.new(0, -0.125, -0.125) * CFrame.Angles(0.04363323129985824, 0, 0), "assaultrifle_equip", "assaultrifle_idle", "assaultrifle_sprint", "assaultrifle_inspect", nil, {
    ["Shoot1"] = "assaultrifle_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "assaultrifle_reload",
    ["EmptyReload"] = nil
})
v72("Medkit", "rbxassetid://17160800734", "rbxassetid://13717497368", nil, "rbxassetid://113536105409271", 1.5, nil, "medkit_equip", "medkit_idle", "medkit_sprint", "medkit_inspect", nil, {
    ["Use"] = "medkit_use",
    ["UseQuick"] = "medkit_use_quick"
})
v72("Briefcase", "rbxassetid://18142172067", "rbxassetid://18142174697", nil, nil, nil, nil, "medkit_equip", "medkit_idle", "medkit_sprint", "medkit_inspect", nil, {
    ["Use"] = "medkit_use",
    ["UseQuick"] = "medkit_use_quick"
})
v72("Sandwich", "rbxassetid://17838232333", "rbxassetid://17838233196", nil, nil, nil, nil, "medkit_sandwich_equip", "medkit_sandwich_idle", "medkit_sandwich_sprint", "medkit_sandwich_inspect", nil, {
    ["Use"] = "medkit_sandwich_use",
    ["UseQuick"] = "medkit_sandwich_use_quick"
})
v72("Laptop", "rbxassetid://18770164868", "rbxassetid://18766906510", nil, nil, nil, nil, "medkit_laptop_equip", "medkit_laptop_idle", "medkit_laptop_sprint", "medkit_laptop_inspect", "medkit_laptop_inspect_rare", {
    ["Use"] = "medkit_laptop_use",
    ["UseQuick"] = "medkit_laptop_use_quick"
})
v72("Bucket of Candy", "rbxassetid://93791981490691", "rbxassetid://95706110401359", nil, nil, nil, nil, "medkit_bucketofcandy_equip", "medkit_bucketofcandy_idle", "medkit_bucketofcandy_sprint", "medkit_bucketofcandy_inspect", nil, {
    ["Use"] = "medkit_bucketofcandy_use",
    ["UseQuick"] = "medkit_bucketofcandy_use_quick"
})
v72("Milk & Cookies", "rbxassetid://99156135330432", "rbxassetid://73601847002267", nil, nil, nil, nil, "medkit_milkcookies_equip", "medkit_milkcookies_idle", "medkit_milkcookies_sprint", "medkit_milkcookies_inspect", nil, {
    ["Use"] = "medkit_milkcookies_use",
    ["UseQuick"] = "medkit_milkcookies_use_quick"
})
v72("Medkitty", "rbxassetid://125732280509514", "rbxassetid://126646607101307", nil, nil, nil, CFrame.new(0, 0.25, -0.25), "medkit_medkitty_equip", "medkit_medkitty_idle", "medkit_medkitty_sprint", "medkit_medkitty_inspect", nil, {
    ["Use"] = "medkit_medkitty_use",
    ["UseQuick"] = "medkit_medkitty_use_quick"
})
v72("Glorious Medkit", "rbxassetid://73358160718523", "rbxassetid://73397457340415", nil, nil, nil, nil, "medkit_equip", "medkit_idle", "medkit_sprint", "medkit_inspect", nil, {
    ["Use"] = "medkit_use",
    ["UseQuick"] = "medkit_use_quick"
})
v72("Subspace Tripmine", "rbxassetid://17160799418", "rbxassetid://17098773688", nil, "rbxassetid://132898234292756", 1.25, CFrame.new(0, 0.25, -0.25), "subspacetripmine_equip", "subspacetripmine_idle", "subspacetripmine_sprint", "subspacetripmine_inspect", nil, {
    ["Use"] = "subspacetripmine_use"
})
v72("Don\'t Press", "rbxassetid://17821233203", "rbxassetid://17821264419", nil, nil, nil, nil, "subspacetripmine_equip", "subspacetripmine_idle", "subspacetripmine_sprint", "subspacetripmine_inspect", nil, {
    ["Use"] = "subspacetripmine_use"
})
v72("Spring", "rbxassetid://18766860615", "rbxassetid://18766904035", nil, nil, nil, nil, "subspacetripmine_equip", "subspacetripmine_idle", "subspacetripmine_sprint", "subspacetripmine_inspect", nil, {
    ["Use"] = "subspacetripmine_use"
})
v72("Trick or Treat", "rbxassetid://101693036028491", "rbxassetid://105864401236960", nil, nil, nil, nil, "subspacetripmine_equip", "subspacetripmine_idle", "subspacetripmine_sprint", "subspacetripmine_inspect", nil, {
    ["Use"] = "subspacetripmine_use"
})
v72("Dev-in-the-Box", "rbxassetid://125056115146240", "rbxassetid://93100882010950", nil, nil, nil, nil, "subspacetripmine_equip", "subspacetripmine_idle", "subspacetripmine_sprint", "subspacetripmine_inspect", nil, {
    ["Use"] = "subspacetripmine_use"
})
v72("DIY Tripmine", "rbxassetid://85747991601740", "rbxassetid://105200997776122", nil, nil, nil, nil, "subspacetripmine_equip", "subspacetripmine_idle", "subspacetripmine_sprint", "subspacetripmine_inspect", nil, {
    ["Use"] = "subspacetripmine_use"
})
v72("Glorious Subspace Tripmine", "rbxassetid://112555928142930", "rbxassetid://80869057489077", nil, nil, nil, nil, "subspacetripmine_equip", "subspacetripmine_idle", "subspacetripmine_sprint", "subspacetripmine_inspect", nil, {
    ["Use"] = "subspacetripmine_use"
})
v72("Flamethrower", "rbxassetid://89455038280473", "rbxassetid://85223987405833", nil, "rbxassetid://122303907626596", 3.25, CFrame.new(0.4, -0.2, -0.2) * CFrame.Angles(0.17453292519943295, 0, -0.4363323129985824), "flamethrower_equip", "flamethrower_idle", nil, "flamethrower_inspect", nil)
v72("Pixel Flamethrower", "rbxassetid://17771752104", "rbxassetid://17771753119", nil, nil, nil, CFrame.new(0.4, -0.2, -0.2) * CFrame.Angles(0.17453292519943295, 0, -0.4363323129985824), "flamethrower_pixelflamethrower_equip", "flamethrower_pixelflamethrower_idle", nil, "flamethrower_pixelflamethrower_inspect", nil, nil, {
    ["FramesPerSecond"] = 2,
    ["PlayAnimationsInstantly"] = true
})
v72("Lamethrower", "rbxassetid://18766862822", "rbxassetid://18766906741", nil, nil, nil, CFrame.new(0, -0.2, -0.2), "flamethrower_equip", "flamethrower_idle", nil, "flamethrower_inspect", nil)
v72("Jack O\'Thrower", "rbxassetid://140280020818514", "rbxassetid://81280342017495", nil, nil, nil, CFrame.new(0.4, -0.2, -0.2) * CFrame.Angles(0.17453292519943295, 0, -0.4363323129985824), "flamethrower_equip", "flamethrower_idle", nil, "flamethrower_inspect", nil)
v72("Snowblower", "rbxassetid://128743586418880", "rbxassetid://80434566532022", nil, nil, nil, CFrame.new(0, 0, -0.2) * CFrame.Angles(0.08726646259971647, 0, 0), "flamethrower_snowblower_equip", "flamethrower_snowblower_idle", nil, "flamethrower_snowblower_inspect", nil)
v72("Glitterthrower", "rbxassetid://88920581735649", "rbxassetid://83419562243412", nil, nil, nil, CFrame.new(0, -0.2, -0.2) * CFrame.Angles(0.17453292519943295, 0, 0), "flamethrower_equip", "flamethrower_idle", nil, "flamethrower_inspect", nil)
v72("Glorious Flamethrower", "rbxassetid://71676635953177", "rbxassetid://88697784394796", nil, nil, nil, CFrame.new(0.4, -0.2, -0.2) * CFrame.Angles(0.17453292519943295, 0, -0.4363323129985824), "flamethrower_equip", "flamethrower_idle", nil, "flamethrower_inspect", nil)
v72("Grenade", "rbxassetid://17160801411", "rbxassetid://14526777692", nil, "rbxassetid://132057045886696", 1.5, CFrame.new(0, -0.25, -0.375), "grenade_equip", "grenade_idle", "grenade_sprint", "grenade_inspect", nil, {
    ["ThrowStart"] = "grenade_throw_start_pinpull",
    ["ThrowIdle"] = "grenade_throw_idle",
    ["ThrowFinish"] = "grenade_throw_finish",
    ["LobStart"] = "grenade_lob_start_pinpull",
    ["LobIdle"] = "grenade_lob_idle",
    ["LobFinish"] = "grenade_lob_finish"
})
v72("Whoopee Cushion", "rbxassetid://17672062933", "rbxassetid://17672086704", nil, nil, nil, CFrame.new(0, -0.25, -0.375), "grenade_equip", "grenade_idle", "grenade_sprint", "grenade_inspect", nil, {
    ["ThrowStart"] = "grenade_throw_start",
    ["ThrowIdle"] = "grenade_throw_idle",
    ["ThrowFinish"] = "grenade_throw_finish",
    ["LobStart"] = "grenade_lob_start",
    ["LobIdle"] = "grenade_lob_idle",
    ["LobFinish"] = "grenade_lob_finish"
})
v72("Water Balloon", "rbxassetid://18766859819", "rbxassetid://18769001397", nil, nil, nil, CFrame.new(0, -0.25, -0.375), "grenade_equip", "grenade_idle", "grenade_sprint", "grenade_inspect", nil, {
    ["ThrowStart"] = "grenade_throw_start",
    ["ThrowIdle"] = "grenade_throw_idle",
    ["ThrowFinish"] = "grenade_throw_finish",
    ["LobStart"] = "grenade_lob_start",
    ["LobIdle"] = "grenade_lob_idle",
    ["LobFinish"] = "grenade_lob_finish"
})
v72("Soul Grenade", "rbxassetid://85903097459179", "rbxassetid://126980255892476", nil, nil, nil, CFrame.new(0, -0.25, -0.375), "grenade_equip", "grenade_idle", "grenade_sprint", "grenade_inspect", nil, {
    ["ThrowStart"] = "grenade_throw_start_pinpull",
    ["ThrowIdle"] = "grenade_throw_idle",
    ["ThrowFinish"] = "grenade_throw_finish",
    ["LobStart"] = "grenade_lob_start_pinpull",
    ["LobIdle"] = "grenade_lob_idle",
    ["LobFinish"] = "grenade_lob_finish"
})
v72("Jingle Grenade", "rbxassetid://97646859596860", "rbxassetid://117226824301607", nil, nil, nil, CFrame.new(0, -0.25, -0.375), "grenade_jinglegrenade_equip", "grenade_idle", "grenade_sprint", "grenade_jinglegrenade_inspect", nil, {
    ["ThrowStart"] = "grenade_jinglegrenade_throw_start",
    ["ThrowIdle"] = "grenade_throw_idle",
    ["ThrowFinish"] = "grenade_jinglegrenade_throw_finish",
    ["LobStart"] = "grenade_jinglegrenade_lob_start",
    ["LobIdle"] = "grenade_lob_idle",
    ["LobFinish"] = "grenade_jinglegrenade_lob_finish"
})
v72("Dynamite", "rbxassetid://119066463640901", "rbxassetid://97225646481020", nil, nil, nil, CFrame.new(0, -0.25, -0.375), "grenade_equip", "grenade_idle", "grenade_sprint", "grenade_inspect", nil, {
    ["ThrowStart"] = "grenade_throw_start",
    ["ThrowIdle"] = "grenade_throw_idle",
    ["ThrowFinish"] = "grenade_throw_finish",
    ["LobStart"] = "grenade_lob_start",
    ["LobIdle"] = "grenade_lob_idle",
    ["LobFinish"] = "grenade_lob_finish"
})
v72("Keynade", "rbxassetid://102785971311114", "rbxassetid://122922810220976", nil, nil, nil, CFrame.new(0, 0, -0.5), "grenade_keynade_equip", "grenade_keynade_idle", "grenade_keynade_sprint", "grenade_keynade_inspect", nil, {
    ["ThrowStart"] = "grenade_keynade_throw_start_pinpull",
    ["ThrowIdle"] = "grenade_keynade_throw_idle",
    ["ThrowFinish"] = "grenade_keynade_throw_finish",
    ["LobStart"] = "grenade_keynade_throw_start_pinpull",
    ["LobIdle"] = "grenade_keynade_throw_idle",
    ["LobFinish"] = "grenade_keynade_lob_finish"
})
v72("Glorious Grenade", "rbxassetid://103034870490455", "rbxassetid://102502933883025", nil, nil, nil, CFrame.new(0, -0.25, -0.375), "grenade_equip", "grenade_idle", "grenade_sprint", "grenade_inspect", nil, {
    ["ThrowStart"] = "grenade_throw_start_pinpull",
    ["ThrowIdle"] = "grenade_throw_idle",
    ["ThrowFinish"] = "grenade_throw_finish",
    ["LobStart"] = "grenade_lob_start_pinpull",
    ["LobIdle"] = "grenade_lob_idle",
    ["LobFinish"] = "grenade_lob_finish"
})
v72("Frozen Grenade", "rbxassetid://96120996159611", "rbxassetid://101932886938992", nil, nil, nil, CFrame.new(0, -0.25, -0.375), "grenade_equip", "grenade_idle", "grenade_sprint", "grenade_inspect", nil, {
    ["ThrowStart"] = "grenade_throw_start_pinpull",
    ["ThrowIdle"] = "grenade_throw_idle",
    ["ThrowFinish"] = "grenade_throw_finish",
    ["LobStart"] = "grenade_lob_start_pinpull",
    ["LobIdle"] = "grenade_lob_idle",
    ["LobFinish"] = "grenade_lob_finish"
})
v72("Molotov", "rbxassetid://109264750627289", "rbxassetid://83303332331234", nil, "rbxassetid://72190971541032", 1.25, CFrame.new(0, -0.25, -0.375), "grenade_equip", "molotov_idle", "grenade_sprint", "grenade_inspect", nil, {
    ["ThrowStart"] = "grenade_throw_start",
    ["ThrowIdle"] = "grenade_throw_idle",
    ["ThrowFinish"] = "grenade_throw_finish",
    ["LobStart"] = "grenade_lob_start",
    ["LobIdle"] = "grenade_lob_idle",
    ["LobFinish"] = "grenade_lob_finish"
})
v72("Coffee", "rbxassetid://17672061538", "rbxassetid://17672089358", nil, nil, nil, CFrame.new(0, -0.25, -0.375), "grenade_equip", "grenade_idle", "grenade_sprint", "molotov_coffee_inspect", nil, {
    ["ThrowStart"] = "grenade_throw_start",
    ["ThrowIdle"] = "grenade_throw_idle",
    ["ThrowFinish"] = "grenade_throw_finish",
    ["LobStart"] = "grenade_lob_start",
    ["LobIdle"] = "grenade_lob_idle",
    ["LobFinish"] = "grenade_lob_finish"
})
v72("Torch", "rbxassetid://115586189235552", "rbxassetid://120882142047198", nil, nil, nil, CFrame.new(0, -0.25, -0.375), "grenade_equip", "molotov_idle", "grenade_sprint", "grenade_inspect", nil, {
    ["ThrowStart"] = "grenade_throw_start",
    ["ThrowIdle"] = "grenade_throw_idle",
    ["ThrowFinish"] = "grenade_throw_finish",
    ["LobStart"] = "grenade_lob_start",
    ["LobIdle"] = "grenade_lob_idle",
    ["LobFinish"] = "grenade_lob_finish"
})
v72("Vexed Candle", "rbxassetid://78128648928195", "rbxassetid://136079178184476", nil, nil, nil, CFrame.new(0, -0.25, -0.375), "grenade_equip", "molotov_idle", "grenade_sprint", "grenade_inspect", nil, {
    ["ThrowStart"] = "grenade_throw_start",
    ["ThrowIdle"] = "grenade_throw_idle",
    ["ThrowFinish"] = "grenade_throw_finish",
    ["LobStart"] = "grenade_lob_start",
    ["LobIdle"] = "grenade_lob_idle",
    ["LobFinish"] = "grenade_lob_finish"
})
v72("Hot Coals", "rbxassetid://110423024723304", "rbxassetid://98070129509602", nil, nil, nil, CFrame.new(0, -0.25, -0.375), "molotov_hotcoals_equip", "molotov_hotcoals_idle", nil, nil, nil, {
    ["ThrowStart"] = "molotov_hotcoals_throw_start",
    ["ThrowIdle"] = "molotov_hotcoals_throw_idle",
    ["ThrowFinish"] = "molotov_hotcoals_throw_finish",
    ["LobStart"] = "molotov_hotcoals_lob_start",
    ["LobIdle"] = "molotov_hotcoals_lob_idle",
    ["LobFinish"] = "molotov_hotcoals_lob_finish"
}, {
    ["DisableProceduralSprinting"] = true
})
v72("Lava Lamp", "rbxassetid://79616583726432", "rbxassetid://76191080417885", nil, nil, nil, CFrame.new(0, -0.25, -0.375), "grenade_equip", "molotov_lavalamp_idle", "grenade_sprint", "grenade_inspect", nil, {
    ["ThrowStart"] = "grenade_throw_start",
    ["ThrowIdle"] = "grenade_throw_idle",
    ["ThrowFinish"] = "grenade_throw_finish",
    ["LobStart"] = "grenade_lob_start",
    ["LobIdle"] = "grenade_lob_idle",
    ["LobFinish"] = "grenade_lob_finish"
})
v72("Glorious Molotov", "rbxassetid://108930340066987", "rbxassetid://95650602989880", nil, nil, nil, CFrame.new(0, -0.25, -0.375), "grenade_equip", "molotov_idle", "grenade_sprint", "grenade_inspect", nil, {
    ["ThrowStart"] = "grenade_throw_start",
    ["ThrowIdle"] = "grenade_throw_idle",
    ["ThrowFinish"] = "grenade_throw_finish",
    ["LobStart"] = "grenade_lob_start",
    ["LobIdle"] = "grenade_lob_idle",
    ["LobFinish"] = "grenade_lob_finish"
})
v72("Flashbang", "rbxassetid://17160801529", "rbxassetid://14664488253", nil, "rbxassetid://129373270164561", 1.5, CFrame.new(0, -0.25, -0.375), "grenade_equip", "grenade_idle", "grenade_sprint", "grenade_inspect", nil, {
    ["ThrowStart"] = "grenade_throw_start_pinpull",
    ["ThrowIdle"] = "grenade_throw_idle",
    ["ThrowFinish"] = "grenade_throw_finish",
    ["LobStart"] = "grenade_lob_start_pinpull",
    ["LobIdle"] = "grenade_lob_idle",
    ["LobFinish"] = "grenade_lob_finish"
})
v72("Disco Ball", "rbxassetid://17672061796", "rbxassetid://17672089136", nil, nil, nil, CFrame.new(0, -0.25, -0.375), "grenade_equip", "grenade_idle", "grenade_sprint", "grenade_inspect", nil, {
    ["ThrowStart"] = "grenade_throw_start",
    ["ThrowIdle"] = "grenade_throw_idle",
    ["ThrowFinish"] = "grenade_throw_finish",
    ["LobStart"] = "grenade_lob_start",
    ["LobIdle"] = "grenade_lob_idle",
    ["LobFinish"] = "grenade_lob_finish"
})
v72("Camera", "rbxassetid://18766865640", "rbxassetid://18766908915", nil, nil, nil, CFrame.new(0, -0.25, -0.375), "grenade_equip", "grenade_idle", "grenade_sprint", "grenade_inspect", nil, {
    ["ThrowStart"] = "grenade_throw_start",
    ["ThrowIdle"] = "grenade_throw_idle",
    ["ThrowFinish"] = "grenade_throw_finish",
    ["LobStart"] = "grenade_lob_start",
    ["LobIdle"] = "grenade_lob_idle",
    ["LobFinish"] = "grenade_lob_finish"
})
v72("Pixel Flashbang", "rbxassetid://132815625474597", "rbxassetid://82894448978638", nil, nil, nil, CFrame.new(0, -0.25, -0.375), "grenade_pixelgrenade_equip", "grenade_pixelgrenade_idle", "grenade_pixelgrenade_sprint", "grenade_pixelgrenade_inspect", nil, {
    ["ThrowStart"] = "grenade_pixelgrenade_throw_start_pinpull",
    ["ThrowIdle"] = "grenade_pixelgrenade_throw_idle",
    ["ThrowFinish"] = "grenade_pixelgrenade_throw_finish",
    ["LobStart"] = "grenade_pixelgrenade_lob_start_pinpull",
    ["LobIdle"] = "grenade_pixelgrenade_lob_idle",
    ["LobFinish"] = "grenade_pixelgrenade_lob_finish"
}, {
    ["FramesPerSecond"] = 2,
    ["PlayAnimationsInstantly"] = true
})
v72("Skullbang", "rbxassetid://73796957224972", "rbxassetid://94894233513600", nil, nil, nil, CFrame.new(0, -0.25, -0.375), "grenade_equip", "grenade_idle", "grenade_sprint", "grenade_inspect", nil, {
    ["ThrowStart"] = "grenade_throw_start",
    ["ThrowIdle"] = "grenade_throw_idle",
    ["ThrowFinish"] = "grenade_throw_finish",
    ["LobStart"] = "grenade_lob_start",
    ["LobIdle"] = "grenade_lob_idle",
    ["LobFinish"] = "grenade_lob_finish"
})
v72("Shining Star", "rbxassetid://108392227354212", "rbxassetid://73486952957582", nil, nil, nil, CFrame.new(0, -0.25, -0.375), "grenade_equip", "grenade_idle", "grenade_sprint", "grenade_inspect", nil, {
    ["ThrowStart"] = "grenade_throw_start",
    ["ThrowIdle"] = "grenade_throw_idle",
    ["ThrowFinish"] = "grenade_throw_finish",
    ["LobStart"] = "grenade_lob_start",
    ["LobIdle"] = "grenade_lob_idle",
    ["LobFinish"] = "grenade_lob_finish"
})
v72("Lightbulb", "rbxassetid://125489177573287", "rbxassetid://78421244256536", nil, nil, nil, CFrame.new(0, -0.25, -0.375), "grenade_equip", "grenade_idle", "grenade_sprint", "grenade_inspect", nil, {
    ["ThrowStart"] = "grenade_throw_start_pinpull",
    ["ThrowIdle"] = "grenade_throw_idle",
    ["ThrowFinish"] = "grenade_throw_finish",
    ["LobStart"] = "grenade_lob_start_pinpull",
    ["LobIdle"] = "grenade_lob_idle",
    ["LobFinish"] = "grenade_lob_finish"
})
v72("Glorious Flashbang", "rbxassetid://96760506528185", "rbxassetid://131190784940519", nil, nil, nil, CFrame.new(0, -0.25, -0.375), "grenade_equip", "grenade_idle", "grenade_sprint", "grenade_inspect", nil, {
    ["ThrowStart"] = "grenade_throw_start_pinpull",
    ["ThrowIdle"] = "grenade_throw_idle",
    ["ThrowFinish"] = "grenade_throw_finish",
    ["LobStart"] = "grenade_lob_start_pinpull",
    ["LobIdle"] = "grenade_lob_idle",
    ["LobFinish"] = "grenade_lob_finish"
})
v72("Smoke Grenade", "rbxassetid://17160799767", "rbxassetid://16373283577", nil, "rbxassetid://107823376688548", 1.5, CFrame.new(0, -0.25, -0.375), "grenade_equip", "grenade_idle", "grenade_sprint", "grenade_inspect", nil, {
    ["ThrowStart"] = "grenade_throw_start_pinpull",
    ["ThrowIdle"] = "grenade_throw_idle",
    ["ThrowFinish"] = "grenade_throw_finish",
    ["LobStart"] = "grenade_lob_start_pinpull",
    ["LobIdle"] = "grenade_lob_idle",
    ["LobFinish"] = "grenade_lob_finish"
})
v72("Emoji Cloud", "rbxassetid://17821234077", "rbxassetid://17821265237", nil, nil, nil, CFrame.new(0, -0.25, -0.375), "grenade_equip", "grenade_idle", "grenade_sprint", "grenade_inspect", nil, {
    ["ThrowStart"] = "grenade_throw_start",
    ["ThrowIdle"] = "grenade_throw_idle",
    ["ThrowFinish"] = "grenade_throw_finish",
    ["LobStart"] = "grenade_lob_start",
    ["LobIdle"] = "grenade_lob_idle",
    ["LobFinish"] = "grenade_lob_finish"
})
v72("Balance", "rbxassetid://18766866168", "rbxassetid://18766909964", nil, nil, nil, CFrame.new(0, -0.25, -0.375), "grenade_equip", "grenade_idle", "grenade_sprint", "grenade_inspect", nil, {
    ["ThrowStart"] = "grenade_throw_start",
    ["ThrowIdle"] = "grenade_throw_idle",
    ["ThrowFinish"] = "grenade_throw_finish",
    ["LobStart"] = "grenade_lob_start",
    ["LobIdle"] = "grenade_lob_idle",
    ["LobFinish"] = "grenade_lob_finish"
})
v72("Eyeball", "rbxassetid://135911399763146", "rbxassetid://103493376163318", nil, nil, nil, CFrame.new(0, -0.25, -0.375), "grenade_equip", "grenade_idle", "grenade_sprint", "grenade_inspect", nil, {
    ["ThrowStart"] = "grenade_throw_start",
    ["ThrowIdle"] = "grenade_throw_idle",
    ["ThrowFinish"] = "grenade_throw_finish",
    ["LobStart"] = "grenade_lob_start",
    ["LobIdle"] = "grenade_lob_idle",
    ["LobFinish"] = "grenade_lob_finish"
})
v72("Snowglobe", "rbxassetid://119390465944051", "rbxassetid://86696224913566", nil, nil, nil, CFrame.new(0, -0.25, -0.375), "grenade_equip", "grenade_idle", "grenade_sprint", "grenade_inspect", nil, {
    ["ThrowStart"] = "grenade_throw_start",
    ["ThrowIdle"] = "grenade_throw_idle",
    ["ThrowFinish"] = "grenade_throw_finish",
    ["LobStart"] = "grenade_lob_start",
    ["LobIdle"] = "grenade_lob_idle",
    ["LobFinish"] = "grenade_lob_finish"
})
v72("Hourglass", "rbxassetid://108311418974073", "rbxassetid://70423041582442", nil, nil, nil, CFrame.new(0, -0.25, -0.375), "grenade_equip", "grenade_idle", "grenade_sprint", "grenade_inspect", nil, {
    ["ThrowStart"] = "grenade_throw_start",
    ["ThrowIdle"] = "grenade_throw_idle",
    ["ThrowFinish"] = "grenade_throw_finish",
    ["LobStart"] = "grenade_lob_start",
    ["LobIdle"] = "grenade_lob_idle",
    ["LobFinish"] = "grenade_lob_finish"
})
v72("Glorious Smoke Grenade", "rbxassetid://139714146508398", "rbxassetid://121565824954563", nil, nil, nil, CFrame.new(0, -0.25, -0.375), "grenade_equip", "grenade_idle", "grenade_sprint", "grenade_inspect", nil, {
    ["ThrowStart"] = "grenade_throw_start_pinpull",
    ["ThrowIdle"] = "grenade_throw_idle",
    ["ThrowFinish"] = "grenade_throw_finish",
    ["LobStart"] = "grenade_lob_start_pinpull",
    ["LobIdle"] = "grenade_lob_idle",
    ["LobFinish"] = "grenade_lob_finish"
})
v72("Fists", "rbxassetid://17160801745", "rbxassetid://16560051320", nil, "rbxassetid://99106504223200", 1.5, nil, "fists_equip", "fists_idle", "fists_sprint", "fists_inspect", nil, {
    ["Attack1"] = "fists_attack1",
    ["Attack2"] = "fists_attack2"
})
v72("Boxing Gloves", "rbxassetid://17672060486", "rbxassetid://17672089761", nil, nil, nil, CFrame.new(0, 0, -0.375), "fists_equip", "fists_idle", "fists_sprint", "fists_boxinggloves_inspect", nil, {
    ["Attack1"] = "fists_attack1",
    ["Attack2"] = "fists_attack2"
})
v72("Brass Knuckles", "rbxassetid://18766866012", "rbxassetid://18766909587", nil, nil, nil, CFrame.new(0, 0, -0.375), "fists_equip", "fists_idle", "fists_sprint", "fists_inspect", nil, {
    ["Attack1"] = "fists_attack1",
    ["Attack2"] = "fists_attack2"
})
v72("Pumpkin Claws", "rbxassetid://90996407819750", "rbxassetid://110587168549532", nil, nil, nil, CFrame.new(0, 0, -0.375), "fists_equip", "fists_idle", "fists_sprint", "fists_inspect", nil, {
    ["Attack1"] = "fists_attack1",
    ["Attack2"] = "fists_attack2"
})
v72("Festive Fists", "rbxassetid://102757458529795", "rbxassetid://98061476050478", nil, nil, nil, CFrame.new(0, 0, -0.375), "fists_equip", "fists_idle", "fists_sprint", "fists_inspect", nil, {
    ["Attack1"] = "fists_attack1",
    ["Attack2"] = "fists_attack2"
})
v72("Fists of Hurt", "rbxassetid://140103672289959", "rbxassetid://71585039030211", nil, nil, nil, nil, "fists_equip", "fists_idle", "fists_sprint", "fists_fistsofhurt_inspect", nil, {
    ["Attack1"] = "fists_fistsofhurt_attack1",
    ["Attack2"] = "fists_fistsofhurt_attack2"
})
v72("Glorious Fists", "rbxassetid://82492165200104", "rbxassetid://79755997614985", nil, nil, nil, nil, "fists_equip", "fists_idle", "fists_sprint", "fists_inspect", nil, {
    ["Attack1"] = "fists_attack1",
    ["Attack2"] = "fists_attack2"
})
v72("Knife", "rbxassetid://17160800983", "rbxassetid://13197583583", nil, "rbxassetid://86335100734691", 2, nil, "knife_equip", "knife_idle", "knife_sprint", "knife_inspect", "knife_inspect_rare", {
    ["Attack1"] = "knife_attack1",
    ["Attack2"] = "knife_attack2",
    ["HeavyAttack1"] = "knife_heavyattack1",
    ["HeavyAttackAnimationHit"] = nil
})
v72("Chancla", "rbxassetid://17672060795", "rbxassetid://17672089600", nil, nil, nil, nil, "knife_equip", "knife_idle", "knife_sprint", "knife_inspect", "knife_inspect_rare", {
    ["Attack1"] = "knife_attack1",
    ["Attack2"] = "knife_attack2",
    ["HeavyAttack1"] = "knife_heavyattack1",
    ["HeavyAttackAnimationHit"] = nil
})
v72("Karambit", "rbxassetid://18766863586", "rbxassetid://18766907079", nil, nil, nil, nil, "knife_karambit_equip", "knife_karambit_idle", "knife_karambit_sprint", "knife_karambit_inspect", nil, {
    ["Attack1"] = "knife_karambit_attack1",
    ["Attack2"] = "knife_karambit_attack2",
    ["HeavyAttack1"] = "knife_karambit_heavyattack1",
    ["HeavyAttackAnimationHit"] = "knife_karambit_heavyattack_hit"
})
v72("Machete", "rbxassetid://84364955819899", "rbxassetid://90332754966135", nil, nil, nil, nil, "knife_equip", "knife_idle", "knife_sprint", "knife_inspect", "knife_inspect_rare", {
    ["Attack1"] = "knife_attack1",
    ["Attack2"] = "knife_attack2",
    ["HeavyAttack1"] = "knife_heavyattack1",
    ["HeavyAttackAnimationHit"] = nil
})
v72("Candy Cane", "rbxassetid://124021545052910", "rbxassetid://84302121354096", nil, nil, nil, nil, "knife_karambit_equip", "knife_karambit_idle", "knife_karambit_sprint", "knife_karambit_inspect", nil, {
    ["Attack1"] = "knife_karambit_attack1",
    ["Attack2"] = "knife_karambit_attack2",
    ["HeavyAttack1"] = "knife_karambit_heavyattack1",
    ["HeavyAttackAnimationHit"] = "knife_karambit_heavyattack_hit"
})
v72("Balisong", "rbxassetid://93303458333011", "rbxassetid://114825371645118", nil, nil, nil, CFrame.new(0, 0, -0.25), "knife_balisong_equip", "knife_balisong_idle", "knife_balisong_sprint", "knife_balisong_inspect", nil, {
    ["Attack1"] = "knife_balisong_attack1",
    ["Attack2"] = "knife_balisong_attack2",
    ["HeavyAttack1"] = "knife_balisong_heavyattack1",
    ["HeavyAttackAnimationHit"] = "knife_balisong_heavyattack_hit"
})
v72("Armature.001", "rbxassetid://104026327618871", "rbxassetid://91555068782550", nil, nil, nil, CFrame.new(0, 0, -0.25), "knife_balisong_equip", "knife_balisong_idle", "knife_balisong_sprint", "knife_balisong_inspect", nil, {
    ["Attack1"] = "knife_balisong_attack1",
    ["Attack2"] = "knife_balisong_attack2",
    ["HeavyAttack1"] = "knife_balisong_heavyattack1",
    ["HeavyAttackAnimationHit"] = "knife_armature001_heavyattack_hit"
})
v72("Glorious Knife", "rbxassetid://77448895595314", "rbxassetid://122760026905111", nil, nil, nil, nil, "knife_equip", "knife_idle", "knife_sprint", "knife_inspect", "knife_inspect_rare", {
    ["Attack1"] = "knife_attack1",
    ["Attack2"] = "knife_attack2",
    ["HeavyAttack1"] = "knife_heavyattack1",
    ["HeavyAttackAnimationHit"] = nil
})
v72("Keyrambit", "rbxassetid://108512337101248", "rbxassetid://73252950434501", nil, nil, nil, nil, "knife_keyrambit_equip", "knife_karambit_idle", "knife_karambit_sprint", "knife_karambit_inspect", nil, {
    ["Attack1"] = "knife_keyrambit_attack1",
    ["Attack2"] = "knife_keyrambit_attack2",
    ["HeavyAttack1"] = "knife_keyrambit_heavyattack1",
    ["HeavyAttackAnimationHit"] = "knife_keyrambit_heavyattack_hit"
})
v72("Keylisong", "rbxassetid://100084654831857", "rbxassetid://118944160521617", nil, nil, nil, CFrame.new(0, 0, -0.25), "knife_keylisong_equip", "knife_balisong_idle", "knife_balisong_sprint", "knife_keylisong_inspect", nil, {
    ["Attack1"] = "knife_keylisong_attack1",
    ["Attack2"] = "knife_keylisong_attack2",
    ["HeavyAttack1"] = "knife_keylisong_heavyattack1",
    ["HeavyAttackAnimationHit"] = "knife_keylisong_heavyattack_hit"
})
v72("Chainsaw", "rbxassetid://17160801873", "rbxassetid://13717445410", nil, "rbxassetid://81316332892810", 2.75, nil, "chainsaw_equip", "chainsaw_idle", "chainsaw_sprint", "chainsaw_inspect", nil, {
    ["Attack1"] = "chainsaw_attack1",
    ["Attack2"] = "chainsaw_attack2",
    ["HoldStart"] = "chainsaw_hold_start",
    ["HoldLoop"] = "chainsaw_hold_loop",
    ["HoldFinish"] = "chainsaw_hold_finish"
})
v72("Blobsaw", "rbxassetid://17825963589", "rbxassetid://17825961425", nil, nil, nil, nil, "chainsaw_equip", "chainsaw_idle", "chainsaw_sprint", "chainsaw_inspect", nil, {
    ["Attack1"] = "chainsaw_attack1",
    ["Attack2"] = "chainsaw_attack2",
    ["HoldStart"] = "chainsaw_hold_start",
    ["HoldLoop"] = "chainsaw_hold_loop",
    ["HoldFinish"] = "chainsaw_hold_finish"
})
v72("Handsaws", "rbxassetid://18766864583", "rbxassetid://18769002596", nil, nil, nil, CFrame.new(0, 0, -0.5), "chainsaw_handsaws_equip", "chainsaw_handsaws_idle", "chainsaw_handsaws_sprint", "chainsaw_handsaws_inspect", nil, {
    ["Attack1"] = "chainsaw_handsaws_attack1",
    ["Attack2"] = "chainsaw_handsaws_attack2",
    ["HoldStart"] = "chainsaw_handsaws_hold_start",
    ["HoldLoop"] = "chainsaw_handsaws_hold_loop",
    ["HoldFinish"] = "chainsaw_handsaws_hold_finish"
})
v72("Buzzsaw", "rbxassetid://74057448201836", "rbxassetid://128354991167944", nil, nil, nil, CFrame.new(0, 0.125, -0.125), "chainsaw_buzzsaw_equip", "chainsaw_buzzsaw_idle", "chainsaw_buzzsaw_sprint", "chainsaw_buzzsaw_inspect", nil, {
    ["Attack1"] = "chainsaw_buzzsaw_attack1",
    ["Attack2"] = "chainsaw_buzzsaw_attack2",
    ["HoldStart"] = "chainsaw_buzzsaw_hold_start",
    ["HoldLoop"] = "chainsaw_buzzsaw_hold_loop",
    ["HoldFinish"] = "chainsaw_buzzsaw_hold_finish"
})
v72("Festive Buzzsaw", "rbxassetid://80811854818775", "rbxassetid://111566667788893", nil, nil, nil, CFrame.new(0, 0.125, -0.125), "chainsaw_buzzsaw_equip", "chainsaw_buzzsaw_idle", "chainsaw_buzzsaw_sprint", "chainsaw_buzzsaw_inspect", nil, {
    ["Attack1"] = "chainsaw_buzzsaw_attack1",
    ["Attack2"] = "chainsaw_buzzsaw_attack2",
    ["HoldStart"] = "chainsaw_buzzsaw_hold_start",
    ["HoldLoop"] = "chainsaw_buzzsaw_hold_loop",
    ["HoldFinish"] = "chainsaw_buzzsaw_hold_finish"
})
v72("Mega Drill", "rbxassetid://76663867023998", "rbxassetid://78828669740807", nil, nil, nil, CFrame.new(0, 0, -0.25), "chainsaw_megadrill_equip", "chainsaw_megadrill_idle", "chainsaw_megadrill_sprint", "chainsaw_megadrill_inspect", nil, {
    ["Attack1"] = "chainsaw_megadrill_attack1",
    ["Attack2"] = "chainsaw_megadrill_attack2",
    ["HoldStart"] = "chainsaw_megadrill_hold_start",
    ["HoldLoop"] = "chainsaw_megadrill_hold_loop",
    ["HoldFinish"] = "chainsaw_megadrill_hold_finish"
})
v72("Glorious Chainsaw", "rbxassetid://122622447397834", "rbxassetid://140353527719287", nil, nil, nil, nil, "chainsaw_equip", "chainsaw_idle", "chainsaw_sprint", "chainsaw_inspect", nil, {
    ["Attack1"] = "chainsaw_attack1",
    ["Attack2"] = "chainsaw_attack2",
    ["HoldStart"] = "chainsaw_hold_start",
    ["HoldLoop"] = "chainsaw_hold_loop",
    ["HoldFinish"] = "chainsaw_hold_finish"
})
v72("Katana", "rbxassetid://17160801158", "rbxassetid://13968137196", nil, "rbxassetid://94254432866649", 3, CFrame.new(0, -0.125, -0.25), "katana_equip", "katana_idle", "katana_sprint2", "katana_inspect", "katana_inspect_rare", {
    ["Attack1"] = "katana_attack1",
    ["Attack2"] = "katana_attack2",
    ["DeflectIdle"] = "katana_deflect_idle",
    ["Deflect1"] = "katana_deflect1",
    ["Deflect2"] = "katana_deflect2",
    ["Deflect3"] = "katana_deflect3",
    ["Deflect4"] = "katana_deflect4",
    ["Deflect5"] = "katana_deflect5"
})
v72("Saber", "rbxassetid://17672062341", "rbxassetid://17672087756", nil, nil, nil, CFrame.new(0, -0.125, -0.25), "katana_saber_equip", "katana_idle", "katana_sprint2", "katana_saber_inspect", "katana_saber_inspect_rare", {
    ["Attack1"] = "katana_saber_attack1",
    ["Attack2"] = "katana_saber_attack2",
    ["DeflectIdle"] = "katana_saber_deflect_idle",
    ["Deflect1"] = "katana_deflect1",
    ["Deflect2"] = "katana_deflect2",
    ["Deflect3"] = "katana_deflect3",
    ["Deflect4"] = "katana_deflect4",
    ["Deflect5"] = "katana_deflect5"
})
v72("Lightning Bolt", "rbxassetid://18768968241", "rbxassetid://18769002278", nil, nil, nil, CFrame.new(0, -0.125, -0.25), "katana_lightningbolt_equip", "katana_idle", "katana_sprint2", "katana_inspect", "katana_lightningbolt_inspect_rare", {
    ["Attack1"] = "katana_lightningbolt_attack1",
    ["Attack2"] = "katana_lightningbolt_attack2",
    ["DeflectIdle"] = "katana_lightningbolt_deflect_idle",
    ["Deflect1"] = "katana_deflect1",
    ["Deflect2"] = "katana_deflect2",
    ["Deflect3"] = "katana_deflect3",
    ["Deflect4"] = "katana_deflect4",
    ["Deflect5"] = "katana_deflect5"
})
v72("Pixel Katana", "rbxassetid://127922483074145", "rbxassetid://83686692916164", nil, nil, nil, CFrame.new(0, -0.125, -0.25), "katana_pixelkatana_equip", "katana_pixelkatana_idle", "katana_pixelkatana_sprint", "katana_pixelkatana_inspect", "katana_pixelkatana_inspect_rare", {
    ["Attack1"] = "katana_pixelkatana_attack1",
    ["Attack2"] = "katana_pixelkatana_attack2",
    ["DeflectIdle"] = "katana_pixelkatana_deflect_idle",
    ["Deflect1"] = "katana_deflect1",
    ["Deflect2"] = "katana_deflect2",
    ["Deflect3"] = "katana_deflect3",
    ["Deflect4"] = "katana_deflect4",
    ["Deflect5"] = "katana_deflect5"
}, {
    ["FramesPerSecond"] = 2,
    ["PlayAnimationsInstantly"] = true
})
v72("Devil\'s Trident", "rbxassetid://101234805269080", "rbxassetid://91973056969213", nil, nil, nil, CFrame.new(0, -0.125, -0.25), "katana_equip", "katana_idle", "katana_sprint2", "katana_inspect", "katana_inspect_rare", {
    ["Attack1"] = "katana_devilstrident_attack1",
    ["Attack2"] = "katana_devilstrident_attack2",
    ["DeflectIdle"] = "katana_deflect_idle",
    ["Deflect1"] = "katana_deflect1",
    ["Deflect2"] = "katana_deflect2",
    ["Deflect3"] = "katana_deflect3",
    ["Deflect4"] = "katana_deflect4",
    ["Deflect5"] = "katana_deflect5"
})
v72("New Year Katana", "rbxassetid://102866488046710", "rbxassetid://79288379571855", nil, nil, nil, CFrame.new(0, -0.125, -0.25), "katana_equip", "katana_idle", "katana_sprint2", "katana_inspect", "katana_inspect_rare", {
    ["Attack1"] = "katana_attack1",
    ["Attack2"] = "katana_attack2",
    ["DeflectIdle"] = "katana_deflect_idle",
    ["Deflect1"] = "katana_deflect1",
    ["Deflect2"] = "katana_deflect2",
    ["Deflect3"] = "katana_deflect3",
    ["Deflect4"] = "katana_deflect4",
    ["Deflect5"] = "katana_deflect5"
})
v72("Keytana", "rbxassetid://118899310989170", "rbxassetid://120478111112813", nil, nil, nil, CFrame.new(0, -0.125, -0.25), "katana_keytana_equip", "katana_keytana_idle", "katana_keytana_sprint", "katana_keytana_inspect", "katana_keytana_inspect_rare", {
    ["Attack1"] = "katana_keytana_attack1",
    ["Attack2"] = "katana_keytana_attack2",
    ["DeflectIdle"] = "katana_keytana_deflect_idle",
    ["Deflect1"] = "katana_keytana_deflect1",
    ["Deflect2"] = "katana_keytana_deflect2",
    ["Deflect3"] = "katana_keytana_deflect3"
})
v72("Stellar Katana", "rbxassetid://72617738655198", "rbxassetid://90901679194899", nil, nil, nil, CFrame.new(0, -0.125, -0.25), "katana_equip", "katana_idle", "katana_sprint2", "katana_inspect", "katana_inspect_rare", {
    ["Attack1"] = "katana_attack1",
    ["Attack2"] = "katana_attack2",
    ["DeflectIdle"] = "katana_deflect_idle",
    ["Deflect1"] = "katana_deflect1",
    ["Deflect2"] = "katana_deflect2",
    ["Deflect3"] = "katana_deflect3",
    ["Deflect4"] = "katana_deflect4",
    ["Deflect5"] = "katana_deflect5"
})
v72("Glorious Katana", "rbxassetid://75588958786035", "rbxassetid://94429900086533", nil, nil, nil, CFrame.new(0, -0.125, -0.25), "katana_equip", "katana_idle", "katana_sprint2", "katana_inspect", "katana_inspect_rare", {
    ["Attack1"] = "katana_attack1",
    ["Attack2"] = "katana_attack2",
    ["DeflectIdle"] = "katana_deflect_idle",
    ["Deflect1"] = "katana_deflect1",
    ["Deflect2"] = "katana_deflect2",
    ["Deflect3"] = "katana_deflect3",
    ["Deflect4"] = "katana_deflect4",
    ["Deflect5"] = "katana_deflect5"
})
v72("Arch Katana", "rbxassetid://94679283541658", "rbxassetid://98068422294741", nil, nil, nil, CFrame.new(0, 0, -0.375), "katana_archkatana_equip", "katana_archkatana_idle", "katana_archkatana_sprint", "katana_archkatana_inspect", nil, {
    ["Attack1"] = "katana_archkatana_attack1",
    ["Attack2"] = "katana_archkatana_attack2",
    ["DeflectIdle"] = "katana_archkatana_deflect_idle",
    ["Deflect1"] = "katana_archkatana_deflect1",
    ["Deflect2"] = "katana_archkatana_deflect2",
    ["Deflect3"] = "katana_archkatana_deflect3",
    ["Deflect4"] = "katana_archkatana_deflect4",
    ["Deflect5"] = "katana_archkatana_deflect5"
})
v72("Crystal Katana", "rbxassetid://88872493010693", "rbxassetid://107573852829996", nil, nil, nil, CFrame.new(0, -0.125, -0.25), "katana_crystalkatana_equip", "katana_crystalkatana_idle", "katana_crystalkatana_sprint", "katana_crystalkatana_inspect", nil, {
    ["Attack1"] = "katana_crystalkatana_attack1",
    ["Attack2"] = "katana_crystalkatana_attack2",
    ["DeflectIdle"] = "katana_crystalkatana_deflect_idle",
    ["Deflect1"] = "katana_crystalkatana_deflect1",
    ["Deflect2"] = "katana_crystalkatana_deflect2",
    ["Deflect3"] = "katana_crystalkatana_deflect3",
    ["Deflect4"] = "katana_crystalkatana_deflect4",
    ["Deflect5"] = "katana_crystalkatana_deflect5"
})
v72("Scythe", "rbxassetid://17160800186", "rbxassetid://13834995858", "rbxassetid://18200943790", "rbxassetid://129311929685726", 2, nil, "scythe_equip", "scythe_idle", "scythe_sprint", "scythe_inspect", nil, {
    ["Attack1"] = "scythe_attack1",
    ["Attack2"] = "scythe_attack2",
    ["Dash"] = nil
})
v72("Scythe of Death", "rbxassetid://17825996537", "rbxassetid://17825961272", nil, nil, nil, nil, "scythe_equip", "scythe_idle", "scythe_sprint", "scythe_inspect", nil, {
    ["Attack1"] = "scythe_attack1",
    ["Attack2"] = "scythe_attack2",
    ["Dash"] = nil
})
v72("Anchor", "rbxassetid://18766866743", "rbxassetid://18769023932", nil, nil, nil, nil, "scythe_equip", "scythe_idle", "scythe_sprint", "scythe_inspect", nil, {
    ["Attack1"] = "scythe_anchor_attack1",
    ["Attack2"] = "scythe_anchor_attack2",
    ["Dash"] = nil
})
v72("Keythe", "rbxassetid://114560926055433", "rbxassetid://75967374711732", nil, nil, nil, nil, "scythe_keythe_equip", "scythe_idle", "scythe_sprint", "scythe_inspect", nil, {
    ["Attack1"] = "scythe_keythe_attack1",
    ["Attack2"] = "scythe_keythe_attack2",
    ["Dash"] = nil
})
v72("Bat Scythe", "rbxassetid://131711174838548", "rbxassetid://104168535403995", nil, nil, nil, nil, "scythe_equip", "scythe_idle", "scythe_sprint", "scythe_inspect", nil, {
    ["Attack1"] = "scythe_batscythe_attack1",
    ["Attack2"] = "scythe_batscythe_attack2",
    ["Dash"] = nil
})
v72("Cryo Scythe", "rbxassetid://119930754357379", "rbxassetid://84690820919174", nil, nil, nil, nil, "scythe_cryoscythe_equip", "scythe_idle", "scythe_sprint", "scythe_inspect", nil, {
    ["Attack1"] = "scythe_cryoscythe_attack1",
    ["Attack2"] = "scythe_cryoscythe_attack2",
    ["Dash"] = nil
})
v72("Bug Net", "rbxassetid://115620701626004", "rbxassetid://99173928762511", nil, nil, nil, nil, "scythe_bugnet_equip", "scythe_bugnet_idle", "scythe_bugnet_sprint", "scythe_bugnet_inspect", nil, {
    ["Attack1"] = "scythe_bugnet_attack1",
    ["Attack2"] = "scythe_bugnet_attack2",
    ["Dash"] = nil
})
v72("Sakura Scythe", "rbxassetid://133811689655966", "rbxassetid://115063494552764", nil, nil, nil, nil, "scythe_equip", "scythe_idle", "scythe_sprint", "scythe_inspect", nil, {
    ["Attack1"] = "scythe_attack1",
    ["Attack2"] = "scythe_attack2",
    ["Dash"] = nil
})
v72("Glorious Scythe", "rbxassetid://115811939422419", "rbxassetid://113721128462866", nil, nil, nil, nil, "scythe_equip", "scythe_idle", "scythe_sprint", "scythe_inspect", nil, {
    ["Attack1"] = "scythe_attack1",
    ["Attack2"] = "scythe_attack2",
    ["Dash"] = nil
})
v72("Crystal Scythe", "rbxassetid://73971549402646", "rbxassetid://88778703942724", nil, nil, nil, CFrame.new(0, -0.25, 0), "scythe_crystalscythe_equip", "scythe_crystalscythe_idle", "scythe_crystalscythe_sprint", "scythe_crystalscythe_inspect", nil, {
    ["Attack1"] = "scythe_crystalscythe_attack1",
    ["Attack2"] = "scythe_crystalscythe_attack2",
    ["Dash"] = "scythe_crystalscythe_dash"
})
v72("Trowel", "rbxassetid://17160799172", "rbxassetid://16560547384", nil, "rbxassetid://103642431355604", 1.5, CFrame.new(0, -0.25, -0.375), "trowel_equip", "trowel_idle", "trowel_sprint", "trowel_inspect", nil, {
    ["Attack1"] = "trowel_attack1",
    ["Attack2"] = "trowel_attack2",
    ["Build"] = "trowel_build"
})
v72("Plastic Shovel", "rbxassetid://17672062201", "rbxassetid://17672088012", nil, nil, nil, CFrame.new(0, -0.25, -0.375), "trowel_equip", "trowel_idle", "trowel_sprint", "trowel_inspect", nil, {
    ["Attack1"] = "trowel_attack1",
    ["Attack2"] = "trowel_attack2",
    ["Build"] = "trowel_build"
})
v72("Garden Shovel", "rbxassetid://18766864873", "rbxassetid://18766908058", nil, nil, nil, CFrame.new(0, -0.25, -0.375), "trowel_equip", "trowel_idle", "trowel_sprint", "trowel_inspect", nil, {
    ["Attack1"] = "trowel_attack1",
    ["Attack2"] = "trowel_attack2",
    ["Build"] = "trowel_build"
})
v72("Pumpkin Carver", "rbxassetid://78827307308671", "rbxassetid://130169648063116", nil, nil, nil, CFrame.new(0, -0.25, -0.375), "trowel_equip", "trowel_idle", "trowel_sprint", "trowel_inspect", nil, {
    ["Attack1"] = "trowel_attack1",
    ["Attack2"] = "trowel_attack2",
    ["Build"] = "trowel_build"
})
v72("Snow Shovel", "rbxassetid://78271338778848", "rbxassetid://96400887574950", nil, nil, nil, CFrame.new(0, -0.25, -0.375), "trowel_equip", "trowel_idle", "trowel_sprint", "trowel_inspect", nil, {
    ["Attack1"] = "trowel_attack1",
    ["Attack2"] = "trowel_attack2",
    ["Build"] = "trowel_build"
})
v72("Paintbrush", "rbxassetid://84687920829755", "rbxassetid://83196688094998", nil, nil, nil, CFrame.new(0, -0.25, -0.375), "trowel_equip", "trowel_idle", "trowel_sprint", "trowel_inspect", nil, {
    ["Attack1"] = "trowel_attack1",
    ["Attack2"] = "trowel_attack2",
    ["Build"] = "trowel_build"
})
v72("Glorious Trowel", "rbxassetid://100888500368219", "rbxassetid://132433921578446", nil, nil, nil, CFrame.new(0, -0.25, -0.375), "trowel_equip", "trowel_idle", "trowel_sprint", "trowel_inspect", nil, {
    ["Attack1"] = "trowel_attack1",
    ["Attack2"] = "trowel_attack2",
    ["Build"] = "trowel_build"
})
v72("Flare Gun", "rbxassetid://17160801627", "rbxassetid://13197583892", nil, "rbxassetid://113217458668564", 1.5, CFrame.new(0, -0.125, -0.25), "flaregun_equip", "flaregun_idle", "flaregun_sprint", "flaregun_inspect", nil, {
    ["Shoot1"] = "flaregun_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "flaregun_reload",
    ["EmptyReload"] = nil
})
v72("Firework Gun", "rbxassetid://17691132917", "rbxassetid://17691136322", nil, nil, nil, CFrame.new(0, -0.125, -0.25), "flaregun_equip", "flaregun_idle", "flaregun_sprint", "flaregun_inspect", nil, {
    ["Shoot1"] = "flaregun_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "flaregun_reload",
    ["EmptyReload"] = nil
})
v72("Dynamite Gun", "rbxassetid://18766865384", "rbxassetid://18766908547", nil, nil, nil, CFrame.new(0, -0.125, -0.25), "flaregun_equip", "flaregun_idle", "flaregun_sprint", "flaregun_inspect", nil, {
    ["Shoot1"] = "flaregun_dynamitegun_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "flaregun_reload",
    ["EmptyReload"] = nil
})
v72("Vexed Flare Gun", "rbxassetid://116287930550049", "rbxassetid://138983159218333", nil, nil, nil, CFrame.new(0, -0.125, -0.25), "flaregun_equip", "flaregun_idle", "flaregun_sprint", "flaregun_inspect", nil, {
    ["Shoot1"] = "flaregun_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "flaregun_reload",
    ["EmptyReload"] = nil
})
v72("Wrapped Flare Gun", "rbxassetid://135638020129378", "rbxassetid://135904023852615", nil, nil, nil, CFrame.new(0, -0.125, -0.25), "flaregun_wrappedflaregun_equip", "flaregun_idle", "flaregun_sprint", "flaregun_inspect", nil, {
    ["Shoot1"] = "flaregun_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "flaregun_reload",
    ["EmptyReload"] = nil
})
v72("Banana Flare", "rbxassetid://123589213761955", "rbxassetid://135246839855870", nil, nil, nil, CFrame.new(0, -0.125, -0.25), "flaregun_bananaflare_equip", "flaregun_bananaflare_idle", "flaregun_bananaflare_sprint", "flaregun_bananaflare_inspect", "flaregun_bananaflare_inspect_rare", {
    ["Shoot1"] = "flaregun_bananaflare_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "flaregun_bananaflare_reload",
    ["EmptyReload"] = nil
})
v72("Glorious Flare Gun", "rbxassetid://115324763672074", "rbxassetid://128135635660577", nil, nil, nil, CFrame.new(0, -0.125, -0.25), "flaregun_equip", "flaregun_idle", "flaregun_sprint", "flaregun_inspect", nil, {
    ["Shoot1"] = "flaregun_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "flaregun_reload",
    ["EmptyReload"] = nil
})
v72("Assault Rifle", "rbxassetid://17160682738", "rbxassetid://13197584241", nil, "rbxassetid://101393097640802", 2.5, CFrame.new(0, -0.125, -0.125) * CFrame.Angles(0.04363323129985824, 0, 0), "assaultrifle_equip", "assaultrifle_idle", "assaultrifle_sprint", "assaultrifle_inspect", nil, {
    ["Shoot1"] = "assaultrifle_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "assaultrifle_reload",
    ["EmptyReload"] = nil
})
v72("AK-47", "rbxassetid://17691132793", "rbxassetid://17691136128", nil, nil, nil, CFrame.new(0, -0.125, -0.125) * CFrame.Angles(0.04363323129985824, 0, 0), "assaultrifle_equip", "assaultrifle_idle", "assaultrifle_sprint", "assaultrifle_inspect", nil, {
    ["Shoot1"] = "assaultrifle_ak47_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "assaultrifle_reload",
    ["EmptyReload"] = nil
})
v72("AUG", "rbxassetid://18770192853", "rbxassetid://18770201102", nil, nil, nil, CFrame.new(0.15, -0.2, -0.25) * CFrame.Angles(0, -0.05235987755982989, 0), "assaultrifle_aug_equip", "assaultrifle_aug_idle", "assaultrifle_aug_sprint", "assaultrifle_aug_inspect", nil, {
    ["Shoot1"] = "assaultrifle_aug_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "assaultrifle_aug_reload",
    ["EmptyReload"] = nil
})
v72("Boneclaw Rifle", "rbxassetid://100015754284323", "rbxassetid://116725320040796", nil, nil, nil, CFrame.new(0, -0.125, -0.125) * CFrame.Angles(0.04363323129985824, 0, 0), "assaultrifle_equip", "assaultrifle_idle", "assaultrifle_sprint", "assaultrifle_inspect", nil, {
    ["Shoot1"] = "assaultrifle_boneclawrifle_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "assaultrifle_reload",
    ["EmptyReload"] = nil
})
v72("AKEY-47", "rbxassetid://80017496220683", "rbxassetid://77244120212187", nil, nil, nil, CFrame.new(0, -0.125, -0.125) * CFrame.Angles(0.04363323129985824, 0, 0), "assaultrifle_akey47_equip", "assaultrifle_idle", "assaultrifle_sprint", "assaultrifle_akey47_inspect", nil, {
    ["Shoot1"] = "assaultrifle_akey47_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "assaultrifle_akey47_reload",
    ["EmptyReload"] = nil
})
v72("Gingerbread AUG", "rbxassetid://85584922619813", "rbxassetid://108476862508992", nil, nil, nil, CFrame.new(0.15, -0.2, -0.25) * CFrame.Angles(0, -0.05235987755982989, 0), "assaultrifle_gingerbreadaug_equip", "assaultrifle_gingerbreadaug_idle", "assaultrifle_gingerbreadaug_sprint", "assaultrifle_gingerbreadaug_inspect", nil, {
    ["Shoot1"] = "assaultrifle_gingerbreadaug_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "assaultrifle_gingerbreadaug_reload",
    ["EmptyReload"] = nil
})
v72("Phoenix Rifle", "rbxassetid://140228738718621", "rbxassetid://115604025497445", nil, nil, nil, CFrame.new(0, -0.125, -0.125) * CFrame.Angles(0.04363323129985824, 0, 0), "assaultrifle_equip", "assaultrifle_idle", "assaultrifle_sprint", "assaultrifle_inspect", nil, {
    ["Shoot1"] = "assaultrifle_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "assaultrifle_reload",
    ["EmptyReload"] = nil
})
v72("Tommy Gun", "rbxassetid://111251887761435", "rbxassetid://84369917689099", nil, nil, nil, CFrame.new(0, -0.125, -0.125) * CFrame.Angles(0.04363323129985824, 0, 0), "assaultrifle_tommygun_equip", "assaultrifle_tommygun_idle", "assaultrifle_tommygun_sprint", "assaultrifle_tommygun_inspect", nil, {
    ["Shoot1"] = "assaultrifle_tommygun_shoot1",
    ["FinalShoot"] = "assaultrifle_tommygun_shoot_final",
    ["Reload"] = "assaultrifle_tommygun_reload",
    ["EmptyReload"] = "assaultrifle_tommygun_reload_empty",
    ["EquipEmpty"] = "assaultrifle_tommygun_equip_empty",
    ["IdleEmpty"] = "assaultrifle_tommygun_idle_empty",
    ["SprintEmpty"] = "assaultrifle_tommygun_sprint_empty",
    ["InspectEmpty"] = "assaultrifle_tommygun_inspect_empty"
})
v72("10B Visits", "rbxassetid://122165086598560", "rbxassetid://101791753953377", nil, nil, nil, CFrame.new(0, -0.125, -0.125) * CFrame.Angles(0.04363323129985824, 0, 0), "assaultrifle_equip", "assaultrifle_idle", "assaultrifle_sprint", "assaultrifle_inspect", nil, {
    ["Shoot1"] = "assaultrifle_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "assaultrifle_reload",
    ["EmptyReload"] = nil
})
v72("Glorious Assault Rifle", "rbxassetid://130669996688265", "rbxassetid://130592949312939", nil, nil, nil, CFrame.new(0, -0.125, -0.125) * CFrame.Angles(0.04363323129985824, 0, 0), "assaultrifle_equip", "assaultrifle_idle", "assaultrifle_sprint", "assaultrifle_inspect", nil, {
    ["Shoot1"] = "assaultrifle_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "assaultrifle_reload",
    ["EmptyReload"] = nil
})
v72("Handgun", "rbxassetid://17160801282", "rbxassetid://13197583693", nil, "rbxassetid://113347796650411", 1.5, CFrame.new(0.25, -0.125, -0.125) * CFrame.Angles(0, 0.08726646259971647, -0.17453292519943295), "handgun_equip", "handgun_idle", "handgun_sprint", "handgun_inspect", nil, {
    ["Shoot1"] = "handgun_shoot1",
    ["FinalShoot"] = "handgun_shoot_final",
    ["Reload"] = "handgun_reload",
    ["EmptyReload"] = "handgun_reload_empty"
})
v72("Blaster", "rbxassetid://17821234554", "rbxassetid://17821265750", nil, nil, nil, CFrame.new(0.25, -0.125, -0.125) * CFrame.Angles(0, 0.08726646259971647, -0.17453292519943295), "handgun_equip", "handgun_idle", "handgun_sprint", "handgun_inspect", nil, {
    ["Shoot1"] = "handgun_blaster_shoot1",
    ["FinalShoot"] = "handgun_blaster_shoot_final",
    ["Reload"] = "handgun_reload",
    ["EmptyReload"] = "handgun_reload_empty"
})
v72("Hand Gun", "rbxassetid://18837670624", "rbxassetid://18837677423", nil, nil, nil, CFrame.new(0.25, 0, -0.5) * CFrame.Angles(0, 0.08726646259971647, -0.17453292519943295), "handgun_handgun_equip", "handgun_handgun_idle", "handgun_handgun_sprint", "handgun_handgun_inspect", "handgun_handgun_inspect_rare", {
    ["Shoot1"] = "handgun_handgun_shoot1",
    ["FinalShoot"] = "handgun_handgun_shoot_final",
    ["Reload"] = "handgun_handgun_reload",
    ["EmptyReload"] = "handgun_handgun_reload_empty"
})
v72("Pixel Handgun", "rbxassetid://82199841278177", "rbxassetid://72665687846028", nil, nil, nil, CFrame.new(0.25, -0.125, -0.125) * CFrame.Angles(0, 0.08726646259971647, -0.17453292519943295), "handgun_pixelhandgun_equip", "handgun_pixelhandgun_idle", "handgun_pixelhandgun_sprint", "handgun_pixelhandgun_inspect", nil, {
    ["Shoot1"] = "handgun_pixelhandgun_shoot1",
    ["FinalShoot"] = "handgun_pixelhandgun_shoot_final",
    ["Reload"] = "handgun_pixelhandgun_reload",
    ["EmptyReload"] = "handgun_pixelhandgun_reload_empty"
}, {
    ["FramesPerSecond"] = 2,
    ["PlayAnimationsInstantly"] = true
})
v72("Pumpkin Handgun", "rbxassetid://88495685924653", "rbxassetid://92824393890642", nil, nil, nil, CFrame.new(0.25, -0.125, -0.125) * CFrame.Angles(0, 0.08726646259971647, -0.17453292519943295), "handgun_equip", "handgun_idle", "handgun_sprint", "handgun_inspect", nil, {
    ["Shoot1"] = "handgun_shoot1",
    ["FinalShoot"] = "handgun_shoot_final",
    ["Reload"] = "handgun_reload",
    ["EmptyReload"] = "handgun_reload_empty"
})
v72("Gingerbread Handgun", "rbxassetid://95881238590412", "rbxassetid://72714528734588", nil, nil, nil, CFrame.new(0.25, -0.125, -0.125) * CFrame.Angles(0, 0.08726646259971647, -0.17453292519943295), "handgun_equip", "handgun_idle", "handgun_sprint", "handgun_inspect", nil, {
    ["Shoot1"] = "handgun_shoot1",
    ["FinalShoot"] = "handgun_shoot_final",
    ["Reload"] = "handgun_reload",
    ["EmptyReload"] = "handgun_reload_empty"
})
v72("Gumball Handgun", "rbxassetid://106890990556815", "rbxassetid://138794077251754", nil, nil, nil, CFrame.new(0.25, -0.125, -0.125) * CFrame.Angles(0, 0.08726646259971647, -0.17453292519943295), "handgun_equip", "handgun_idle", "handgun_sprint", "handgun_inspect", nil, {
    ["Shoot1"] = "handgun_gumballhandgun_shoot1",
    ["FinalShoot"] = "handgun_gumballhandgun_shoot_final",
    ["Reload"] = "handgun_reload",
    ["EmptyReload"] = "handgun_reload_empty"
})
v72("Stealth Handgun", "rbxassetid://124919185835138", "rbxassetid://99321324367928", nil, nil, nil, CFrame.new(0.25, -0.125, -0.125) * CFrame.Angles(0, 0.08726646259971647, -0.17453292519943295), "handgun_equip", "handgun_idle", "handgun_sprint", "handgun_inspect", nil, {
    ["Shoot1"] = "handgun_stealthhandgun_shoot1",
    ["FinalShoot"] = "handgun_stealthhandgun_shoot_final",
    ["Reload"] = "handgun_reload",
    ["EmptyReload"] = "handgun_reload_empty"
})
v72("Glorious Handgun", "rbxassetid://85129427786041", "rbxassetid://73041314820303", nil, nil, nil, CFrame.new(0.25, -0.125, -0.125) * CFrame.Angles(0, 0.08726646259971647, -0.17453292519943295), "handgun_equip", "handgun_idle", "handgun_sprint", "handgun_inspect", nil, {
    ["Shoot1"] = "handgun_shoot1",
    ["FinalShoot"] = "handgun_shoot_final",
    ["Reload"] = "handgun_reload",
    ["EmptyReload"] = "handgun_reload_empty"
})
v72("Warp Handgun", "rbxassetid://102974911528828", "rbxassetid://117404871573487", nil, nil, nil, CFrame.new(0.25, -0.125, -0.125) * CFrame.Angles(0, 0.08726646259971647, -0.17453292519943295), "handgun_equip", "handgun_idle", "handgun_sprint", "handgun_inspect", nil, {
    ["Shoot1"] = "handgun_shoot1",
    ["FinalShoot"] = "handgun_shoot_final",
    ["Reload"] = "handgun_reload",
    ["EmptyReload"] = "handgun_reload_empty"
})
v72("Towerstone Handgun", "rbxassetid://88654252790032", "rbxassetid://116418326352365", nil, nil, nil, CFrame.new(0.25, -0.125, -0.125) * CFrame.Angles(0, 0.08726646259971647, -0.17453292519943295), "handgun_equip", "handgun_idle", "handgun_sprint", "handgun_inspect", nil, {
    ["Shoot1"] = "handgun_shoot1",
    ["FinalShoot"] = "handgun_shoot_final",
    ["Reload"] = "handgun_reload",
    ["EmptyReload"] = "handgun_reload_empty"
})
v72("Burst Rifle", "rbxassetid://17160801983", "rbxassetid://13482243466", nil, "rbxassetid://98231967024816", 2.5, CFrame.new(0, -0.125, 0), "burstrifle_equip", "burstrifle_idle", "burstrifle_sprint", "burstrifle_inspect", nil, {
    ["Shoot1"] = "burstrifle_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "burstrifle_reload",
    ["EmptyReload"] = nil
})
v72("Electro Rifle", "rbxassetid://132227459821018", "rbxassetid://87621360986223", nil, nil, nil, CFrame.new(0, -0.125, 0), "burstrifle_equip", "burstrifle_idle", "burstrifle_sprint", "burstrifle_inspect", nil, {
    ["Shoot1"] = "burstrifle_electrorifle_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "burstrifle_electrorifle_reload",
    ["EmptyReload"] = nil
})
v72("Aqua Burst", "rbxassetid://18837670807", "rbxassetid://18837677725", nil, nil, nil, CFrame.new(0, -0.125, 0), "burstrifle_equip", "burstrifle_idle", "burstrifle_sprint", "burstrifle_inspect", nil, {
    ["Shoot1"] = "burstrifle_aquaburst_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "burstrifle_reload",
    ["EmptyReload"] = nil
})
v72("Pixel Burst", "rbxassetid://102648809593259", "rbxassetid://81440970309830", nil, nil, nil, CFrame.new(0, -0.125, 0), "burstrifle_pixelburst_equip", "burstrifle_pixelburst_idle", "burstrifle_pixelburst_sprint", "burstrifle_pixelburst_inspect", nil, {
    ["Shoot1"] = "burstrifle_pixelburst_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "burstrifle_pixelburst_reload",
    ["EmptyReload"] = nil
}, {
    ["FramesPerSecond"] = 2,
    ["PlayAnimationsInstantly"] = true
})
v72("Spectral Burst", "rbxassetid://135012309412679", "rbxassetid://135650382469411", nil, nil, nil, CFrame.new(0, -0.125, 0), "burstrifle_equip", "burstrifle_idle", "burstrifle_sprint", "burstrifle_inspect", nil, {
    ["Shoot1"] = "burstrifle_spectralburst_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "burstrifle_reload",
    ["EmptyReload"] = nil
})
v72("Pine Burst", "rbxassetid://132753732294083", "rbxassetid://100589243117991", nil, nil, nil, CFrame.new(0, -0.125, 0), "burstrifle_equip", "burstrifle_idle", "burstrifle_sprint", "burstrifle_inspect", nil, {
    ["Shoot1"] = "burstrifle_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "burstrifle_reload",
    ["EmptyReload"] = nil
})
v72("FAMAS", "rbxassetid://74974560606812", "rbxassetid://110423034763836", nil, nil, nil, CFrame.new(0.25, -0.125, -0.25) * CFrame.Angles(0, -0.08726646259971647, 0), "burstrifle_famas_equip", "burstrifle_famas_idle", "burstrifle_famas_sprint", "burstrifle_famas_inspect", nil, {
    ["Shoot1"] = "burstrifle_famas_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "burstrifle_famas_reload",
    ["EmptyReload"] = "burstrifle_famas_reload_empty"
})
v72("Glorious Burst Rifle", "rbxassetid://78517330608597", "rbxassetid://125258150017244", nil, nil, nil, CFrame.new(0, -0.125, 0), "burstrifle_equip", "burstrifle_idle", "burstrifle_sprint", "burstrifle_inspect", nil, {
    ["Shoot1"] = "burstrifle_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "burstrifle_reload",
    ["EmptyReload"] = nil
})
v72("Keyst Rifle", "rbxassetid://78377522426003", "rbxassetid://138268719789353", nil, nil, nil, CFrame.new(0, 0, -0.5), "burstrifle_keystrifle_equip", "burstrifle_keystrifle_idle", "burstrifle_keystrifle_sprint", "burstrifle_keystrifle_inspect", nil, {
    ["Shoot1"] = "burstrifle_keystrifle_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "burstrifle_keystrifle_reload",
    ["EmptyReload"] = nil
})
v72("Sniper", "rbxassetid://17160799574", "rbxassetid://13197583098", nil, "rbxassetid://132853334508822", 3.25, CFrame.new(0, -0.125, -0.125), "sniper_equip", "sniper_idle", "sniper_sprint", "sniper_inspect", nil, {
    ["Shoot1"] = "sniper_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "sniper_reload",
    ["EmptyReload"] = "sniper_reload_empty"
})
v72("Pixel Sniper", "rbxassetid://17676081196", "rbxassetid://17676083400", nil, nil, nil, CFrame.new(0, -0.125, -0.125), "sniper_pixelsniper_equip", "sniper_pixelsniper_idle", "sniper_pixelsniper_sprint", "sniper_pixelsniper_inspect", nil, {
    ["Shoot1"] = "sniper_pixelsniper_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "sniper_pixelsniper_reload",
    ["EmptyReload"] = "sniper_pixelsniper_reload_empty"
}, {
    ["FramesPerSecond"] = 2,
    ["PlayAnimationsInstantly"] = true
})
v72("Hyper Sniper", "rbxassetid://18766864081", "rbxassetid://18766907266", nil, nil, nil, CFrame.new(0, -0.125, -0.125), "sniper_equip", "sniper_idle", "sniper_sprint", "sniper_inspect", nil, {
    ["Shoot1"] = "sniper_hypersniper_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "sniper_reload",
    ["EmptyReload"] = "sniper_reload_empty"
})
v72("Keyper", "rbxassetid://85472935605264", "rbxassetid://122634584511896", nil, nil, nil, CFrame.new(0, -0.125, -0.125), "sniper_keyper_equip", "sniper_idle", "sniper_sprint", "sniper_inspect", nil, {
    ["Shoot1"] = "sniper_keyper_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "sniper_reload",
    ["EmptyReload"] = "sniper_reload_empty"
})
v72("Eyething Sniper", "rbxassetid://103915302076013", "rbxassetid://96377501719526", nil, nil, nil, CFrame.new(0, -0.125, -0.125), "sniper_equip", "sniper_idle", "sniper_sprint", "sniper_inspect", nil, {
    ["Shoot1"] = "sniper_eyethingsniper_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "sniper_reload",
    ["EmptyReload"] = "sniper_reload_empty"
})
v72("Gingerbread Sniper", "rbxassetid://99943841952995", "rbxassetid://120163896680390", nil, nil, nil, CFrame.new(0, -0.125, -0.125), "sniper_equip", "sniper_idle", "sniper_sprint", "sniper_inspect", nil, {
    ["Shoot1"] = "sniper_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "sniper_reload",
    ["EmptyReload"] = "sniper_reload_empty"
})
v72("Event Horizon", "rbxassetid://80749667426815", "rbxassetid://82446563771968", nil, nil, nil, CFrame.new(0, 0, -0.25), "sniper_eventhorizon_equip", "sniper_eventhorizon_idle", "sniper_eventhorizon_sprint", "sniper_eventhorizon_inspect", nil, {
    ["Shoot1"] = "sniper_eventhorizon_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "sniper_eventhorizon_reload",
    ["EmptyReload"] = "sniper_eventhorizon_reload_empty"
})
v72("Glorious Sniper", "rbxassetid://118012090175286", "rbxassetid://94794978921271", nil, nil, nil, CFrame.new(0, -0.125, -0.125), "sniper_equip", "sniper_idle", "sniper_sprint", "sniper_inspect", nil, {
    ["Shoot1"] = "sniper_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "sniper_reload",
    ["EmptyReload"] = "sniper_reload_empty"
})
v72("RPG", "rbxassetid://17160802243", "rbxassetid://13197583434", nil, "rbxassetid://95169761396387", 3.5, CFrame.new(0, -0.125, -0.25), "rpg_equip", "rpg_idle", "rpg_sprint", "rpg_inspect", "rpg_inspect_rare", {
    ["Shoot1"] = "rpg_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "rpg_reload",
    ["EmptyReload"] = nil
})
v72("Nuke Launcher", "rbxassetid://17672061995", "rbxassetid://17672088925", nil, nil, nil, CFrame.new(0, -0.125, -0.25), "rpg_equip", "rpg_idle", "rpg_sprint", "rpg_inspect", "rpg_inspect_rare", {
    ["Shoot1"] = "rpg_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "rpg_reload",
    ["EmptyReload"] = nil
})
v72("RPKEY", "rbxassetid://108438721125410", "rbxassetid://122750504849596", nil, nil, nil, CFrame.new(0, -0.125, -0.25), "rpg_rpkey_equip", "rpg_idle", "rpg_sprint", "rpg_inspect", "rpg_inspect_rare", {
    ["Shoot1"] = "rpg_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "rpg_reload",
    ["EmptyReload"] = nil
})
v72("Spaceship Launcher", "rbxassetid://18766860860", "rbxassetid://18766904375", nil, nil, nil, CFrame.new(0, -0.125, -0.25), "rpg_equip", "rpg_idle", "rpg_sprint", "rpg_inspect", "rpg_inspect_rare", {
    ["Shoot1"] = "rpg_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "rpg_reload",
    ["EmptyReload"] = nil
})
v72("Pumpkin Launcher", "rbxassetid://94648176067808", "rbxassetid://130301464984534", nil, nil, nil, CFrame.new(0.375, -0.5, -0.75), "rpg_equip", "rpg_idle", "rpg_sprint", "rpg_inspect", "rpg_inspect_rare", {
    ["Shoot1"] = "rpg_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "rpg_reload",
    ["EmptyReload"] = nil
})
v72("Firework Launcher", "rbxassetid://75233372670156", "rbxassetid://93131277391830", nil, nil, nil, CFrame.new(0, -0.125, -0.25), "rpg_equip", "rpg_idle", "rpg_sprint", "rpg_inspect", "rpg_inspect_rare", {
    ["Shoot1"] = "rpg_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "rpg_reload",
    ["EmptyReload"] = nil
})
v72("Squid Launcher", "rbxassetid://130764310743404", "rbxassetid://80877003243435", nil, nil, nil, CFrame.new(0.125, -0.25, -0.5) * CFrame.Angles(0, 0.08726646259971647, 0), "rpg_equip", "rpg_idle", "rpg_sprint", "rpg_inspect", "rpg_inspect_rare", {
    ["Shoot1"] = "rpg_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "rpg_reload",
    ["EmptyReload"] = nil
})
v72("Pencil Launcher", "rbxassetid://106934516693548", "rbxassetid://74125168400547", nil, nil, nil, CFrame.new(0, -0.25, -0.5) * CFrame.Angles(0, 0.08726646259971647, 0), "rpg_equip", "rpg_idle", "rpg_sprint", "rpg_inspect", "rpg_inspect_rare", {
    ["Shoot1"] = "rpg_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "rpg_reload",
    ["EmptyReload"] = nil
})
v72("Glorious RPG", "rbxassetid://130506879885802", "rbxassetid://77567945870953", nil, nil, nil, CFrame.new(0, -0.125, -0.25), "rpg_equip", "rpg_idle", "rpg_sprint", "rpg_inspect", "rpg_inspect_rare", {
    ["Shoot1"] = "rpg_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "rpg_reload",
    ["EmptyReload"] = nil
})
v72("Shorty", "rbxassetid://17160800091", "rbxassetid://13255103172", nil, "rbxassetid://89929289810261", 2, CFrame.new(0, -0.125, -0.25), "shorty_equip", "shorty_idle", "shorty_sprint", "shorty_inspect", "shorty_inspect_rare", {
    ["Shoot1"] = "shorty_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "shorty_reload",
    ["EmptyReload"] = "shorty_reload_empty"
})
v72("Not So Shorty", "rbxassetid://17672062572", "rbxassetid://17672087325", nil, nil, nil, CFrame.new(0, -0.125, -0.25), "shorty_equip", "shorty_idle", "shorty_sprint", "shorty_inspect", "shorty_inspect_rare", {
    ["Shoot1"] = "shorty_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "shorty_reload",
    ["EmptyReload"] = "shorty_reload_empty"
})
v72("Too Shorty", "rbxassetid://18129531276", "rbxassetid://18129532343", nil, nil, nil, CFrame.new(0, -0.125, -0.25), "shorty_equip", "shorty_idle", "shorty_sprint", "shorty_inspect", "shorty_inspect_rare", {
    ["Shoot1"] = "shorty_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "shorty_reload",
    ["EmptyReload"] = "shorty_reload_empty"
})
v72("Lovely Shorty", "rbxassetid://18766862000", "rbxassetid://18766906011", nil, nil, nil, CFrame.new(0, -0.125, -0.25), "shorty_equip", "shorty_idle", "shorty_sprint", "shorty_inspect", "shorty_inspect_rare", {
    ["Shoot1"] = "shorty_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "shorty_reload",
    ["EmptyReload"] = "shorty_reload_empty"
})
v72("Demon Shorty", "rbxassetid://116443498278384", "rbxassetid://110819203451709", nil, nil, nil, CFrame.new(0, -0.125, -0.25), "shorty_equip", "shorty_idle", "shorty_sprint", "shorty_inspect", "shorty_inspect_rare", {
    ["Shoot1"] = "shorty_demonshorty_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "shorty_reload",
    ["EmptyReload"] = "shorty_reload_empty"
})
v72("Wrapped Shorty", "rbxassetid://136522183669611", "rbxassetid://85255622402845", nil, nil, nil, CFrame.new(0, -0.125, -0.25), "shorty_wrappedshorty_equip", "shorty_idle", "shorty_sprint", "shorty_inspect", "shorty_inspect_rare", {
    ["Shoot1"] = "shorty_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "shorty_reload",
    ["EmptyReload"] = "shorty_reload_empty"
})
v72("Balloon Shorty", "rbxassetid://75590262133322", "rbxassetid://87872312114961", nil, nil, nil, CFrame.new(0, -0.125, -0.25), "shorty_equip", "shorty_idle", "shorty_sprint", "shorty_inspect", "shorty_balloonshorty_inspect_rare", {
    ["Shoot1"] = "shorty_balloonshorty_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "shorty_balloonshorty_reload",
    ["EmptyReload"] = "shorty_balloonshorty_reload_empty"
})
v72("Glorious Shorty", "rbxassetid://105834197552222", "rbxassetid://78845944937729", nil, nil, nil, CFrame.new(0, -0.125, -0.25), "shorty_equip", "shorty_idle", "shorty_sprint", "shorty_inspect", "shorty_inspect_rare", {
    ["Shoot1"] = "shorty_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "shorty_reload",
    ["EmptyReload"] = "shorty_reload_empty"
})
v72("Shotgun", "rbxassetid://17160800007", "rbxassetid://13197583302", nil, "rbxassetid://102792045452343", 2.75, CFrame.new(0, -0.25, -0.55), "shotgun_equip", "shotgun_idle", "shotgun_sprint", "shotgun_inspect", "shotgun_inspect_rare", {
    ["Shoot1"] = "shotgun_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = nil,
    ["EmptyReload"] = nil,
    ["ReloadStart"] = "shotgun_reload_start",
    ["ReloadSegment"] = "shotgun_reload_segment",
    ["ReloadFinish"] = "shotgun_reload_finish",
    ["EmptyReloadStart"] = "shotgun_reload_empty_start",
    ["EmptyReloadSegment"] = "shotgun_reload_segment",
    ["EmptyReloadFinish"] = "shotgun_reload_empty_finish2"
})
v72("Balloon Shotgun", "rbxassetid://17821234823", "rbxassetid://17821266090", nil, nil, nil, CFrame.new(0, -0.25, -0.55), "shotgun_balloonshotgun_equip", "shotgun_idle", "shotgun_sprint", "shotgun_balloonshotgun_inspect", "shotgun_balloonshotgun_inspect_rare", {
    ["Shoot1"] = "shotgun_balloonshotgun_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = nil,
    ["EmptyReload"] = nil,
    ["ReloadStart"] = "shotgun_reload_start",
    ["ReloadSegment"] = "shotgun_balloonshotgun_reload_segment",
    ["ReloadFinish"] = "shotgun_balloonshotgun_reload_finish",
    ["EmptyReloadStart"] = "shotgun_balloonshotgun_reload_empty_start",
    ["EmptyReloadSegment"] = "shotgun_balloonshotgun_reload_segment",
    ["EmptyReloadFinish"] = "shotgun_balloonshotgun_reload_empty_finish2"
})
v72("Hyper Shotgun", "rbxassetid://18768968419", "rbxassetid://18768974410", nil, nil, nil, CFrame.new(0, -0.25, -0.55), "shotgun_equip", "shotgun_idle", "shotgun_sprint", "shotgun_inspect", "shotgun_inspect_rare", {
    ["Shoot1"] = "shotgun_hypershotgun_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = nil,
    ["EmptyReload"] = nil,
    ["ReloadStart"] = "shotgun_reload_start",
    ["ReloadSegment"] = "shotgun_reload_segment",
    ["ReloadFinish"] = "shotgun_reload_finish",
    ["EmptyReloadStart"] = "shotgun_reload_empty_start",
    ["EmptyReloadSegment"] = "shotgun_reload_segment",
    ["EmptyReloadFinish"] = "shotgun_reload_empty_finish2"
})
v72("Broomstick", "rbxassetid://118061559757082", "rbxassetid://126607371232554", nil, nil, nil, CFrame.new(0, -0.125, -0.5), "shotgun_broomstick_equip", "shotgun_idle", "shotgun_sprint", "shotgun_inspect", "shotgun_inspect_rare", {
    ["Shoot1"] = "shotgun_broomstick_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = nil,
    ["EmptyReload"] = nil,
    ["ReloadStart"] = "shotgun_reload_start",
    ["ReloadSegment"] = "shotgun_reload_segment",
    ["ReloadFinish"] = "shotgun_reload_finish",
    ["EmptyReloadStart"] = "shotgun_reload_empty_start",
    ["EmptyReloadSegment"] = "shotgun_reload_segment",
    ["EmptyReloadFinish"] = "shotgun_reload_empty_finish2"
})
v72("Wrapped Shotgun", "rbxassetid://74894345245237", "rbxassetid://122560535811833", nil, nil, nil, CFrame.new(0, -0.125, -0.5), "shotgun_wrappedshotgun_equip", "shotgun_idle", "shotgun_sprint", "shotgun_inspect", "shotgun_inspect_rare", {
    ["Shoot1"] = "shotgun_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = nil,
    ["EmptyReload"] = nil,
    ["ReloadStart"] = "shotgun_reload_start",
    ["ReloadSegment"] = "shotgun_reload_segment",
    ["ReloadFinish"] = "shotgun_reload_finish",
    ["EmptyReloadStart"] = "shotgun_reload_empty_start",
    ["EmptyReloadSegment"] = "shotgun_reload_segment",
    ["EmptyReloadFinish"] = "shotgun_reload_empty_finish2"
})
v72("Cactus Shotgun", "rbxassetid://131606483507460", "rbxassetid://128141817339029", nil, nil, nil, CFrame.new(0, -0.25, -0.55), "shotgun_equip", "shotgun_idle", "shotgun_sprint", "shotgun_inspect", "shotgun_inspect_rare", {
    ["Shoot1"] = "shotgun_cactusshotgun_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = nil,
    ["EmptyReload"] = nil,
    ["ReloadStart"] = "shotgun_reload_start",
    ["ReloadSegment"] = "shotgun_reload_segment",
    ["ReloadFinish"] = "shotgun_reload_finish",
    ["EmptyReloadStart"] = "shotgun_reload_empty_start",
    ["EmptyReloadSegment"] = "shotgun_reload_segment",
    ["EmptyReloadFinish"] = "shotgun_reload_empty_finish2"
})
v72("Shotkey", "rbxassetid://93004214983981", "rbxassetid://101615278610735", nil, nil, nil, CFrame.new(0, 0, -0.5), "shotgun_shotkey_equip", "shotgun_shotkey_idle", "shotgun_shotkey_sprint", "shotgun_shotkey_inspect", nil, {
    ["Shoot1"] = "shotgun_shotkey_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = nil,
    ["EmptyReload"] = nil,
    ["ReloadStart"] = "shotgun_shotkey_reload_start",
    ["ReloadSegment"] = "shotgun_shotkey_reload_segment",
    ["ReloadFinish"] = "shotgun_shotkey_reload_finish",
    ["EmptyReloadStart"] = "shotgun_shotkey_reload_empty_start",
    ["EmptyReloadSegment"] = "shotgun_shotkey_reload_segment",
    ["EmptyReloadFinish"] = "shotgun_shotkey_reload_empty_finish2",
    ["EmptyInspect"] = "shotgun_shotkey_inspect_empty"
})
v72("Glorious Shotgun", "rbxassetid://71704618059601", "rbxassetid://104100596412940", nil, nil, nil, CFrame.new(0, -0.25, -0.55), "shotgun_equip", "shotgun_idle", "shotgun_sprint", "shotgun_inspect", "shotgun_inspect_rare", {
    ["Shoot1"] = "shotgun_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = nil,
    ["EmptyReload"] = nil,
    ["ReloadStart"] = "shotgun_reload_start",
    ["ReloadSegment"] = "shotgun_reload_segment",
    ["ReloadFinish"] = "shotgun_reload_finish",
    ["EmptyReloadStart"] = "shotgun_reload_empty_start",
    ["EmptyReloadSegment"] = "shotgun_reload_segment",
    ["EmptyReloadFinish"] = "shotgun_reload_empty_finish2"
})
v72("Bow", "rbxassetid://17160802080", "rbxassetid://13717212331", nil, "rbxassetid://108384017179119", 2, nil, "bow_equip", "bow_idle", "bow_sprint", "bow_inspect", nil, {
    ["Shoot1"] = "bow_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "bow_reload",
    ["EmptyReload"] = nil,
    ["Charge"] = "bow_charge",
    ["ChargeLoop"] = "bow_charge_loop",
    ["ChargeRelease"] = "bow_charge_release"
})
v72("Compound Bow", "rbxassetid://17672234242", "rbxassetid://17672229023", nil, nil, nil, nil, "bow_equip", "bow_idle", "bow_sprint", "bow_inspect", nil, {
    ["Shoot1"] = "bow_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "bow_reload",
    ["EmptyReload"] = nil,
    ["Charge"] = "bow_charge",
    ["ChargeLoop"] = "bow_charge_loop",
    ["ChargeRelease"] = "bow_charge_release"
})
v72("Raven Bow", "rbxassetid://18766861627", "rbxassetid://18766905321", nil, nil, nil, nil, "bow_equip", "bow_idle", "bow_sprint", "bow_inspect", nil, {
    ["Shoot1"] = "bow_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "bow_reload",
    ["EmptyReload"] = nil,
    ["Charge"] = "bow_charge",
    ["ChargeLoop"] = "bow_charge_loop",
    ["ChargeRelease"] = "bow_charge_release"
})
v72("Bat Bow", "rbxassetid://108984987378619", "rbxassetid://71508472340303", nil, nil, nil, nil, "bow_equip", "bow_idle", "bow_sprint", "bow_inspect", nil, {
    ["Shoot1"] = "bow_batbow_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "bow_reload",
    ["EmptyReload"] = nil,
    ["Charge"] = "bow_charge",
    ["ChargeLoop"] = "bow_charge_loop",
    ["ChargeRelease"] = "bow_batbow_charge_release"
})
v72("Frostbite Bow", "rbxassetid://121895626623160", "rbxassetid://82246935699705", nil, nil, nil, nil, "bow_frostbitebow_equip", "bow_idle", "bow_sprint", "bow_inspect", nil, {
    ["Shoot1"] = "bow_frostbitebow_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "bow_reload",
    ["EmptyReload"] = nil,
    ["Charge"] = "bow_charge",
    ["ChargeLoop"] = "bow_charge_loop",
    ["ChargeRelease"] = "bow_frostbitebow_charge_release"
})
v72("Dream Bow", "rbxassetid://101089313144218", "rbxassetid://104571173348964", nil, nil, nil, nil, "bow_dreambow_equip", "bow_idle", "bow_sprint", "bow_inspect", nil, {
    ["Shoot1"] = "bow_dreambow_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "bow_reload",
    ["EmptyReload"] = nil,
    ["Charge"] = "bow_charge",
    ["ChargeLoop"] = "bow_charge_loop",
    ["ChargeRelease"] = "bow_dreambow_charge_release"
})
v72("Key Bow", "rbxassetid://122525140091212", "rbxassetid://101924188286368", nil, nil, nil, CFrame.new(-0.125, -0.25, -0.5), "bow_keybow_equip", "bow_keybow_idle", "bow_keybow_sprint", "bow_keybow_inspect", "bow_keybow_inspect_rare", {
    ["Shoot1"] = "bow_keybow_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "bow_keybow_reload",
    ["EmptyReload"] = nil,
    ["Charge"] = "bow_keybow_charge",
    ["ChargeLoop"] = "bow_keybow_charge_loop",
    ["ChargeRelease"] = "bow_keybow_charge_release",
    ["InspectEmpty"] = "bow_keybow_inspect_empty"
})
v72("Glorious Bow", "rbxassetid://84201415206621", "rbxassetid://139021383472653", nil, nil, nil, nil, "bow_equip", "bow_idle", "bow_sprint", "bow_inspect", nil, {
    ["Shoot1"] = "bow_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "bow_reload",
    ["EmptyReload"] = nil,
    ["Charge"] = "bow_charge",
    ["ChargeLoop"] = "bow_charge_loop",
    ["ChargeRelease"] = "bow_charge_release"
})
v72("Uzi", "rbxassetid://17160798908", "rbxassetid://14020829706", nil, "rbxassetid://83641084870257", 1.5, CFrame.new(0, -0.125, 0.125), "uzi_equip", "uzi_idle", "uzi_sprint", "uzi_inspect", nil, {
    ["Shoot1"] = "uzi_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "uzi_reload",
    ["EmptyReload"] = nil
})
v72("Water Uzi", "rbxassetid://17821233590", "rbxassetid://17821264784", nil, nil, nil, CFrame.new(-0.125, -0.25, -0.375), "uzi_equip", "uzi_idle", "uzi_sprint", "uzi_inspect", nil, {
    ["Shoot1"] = "uzi_wateruzi_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "uzi_reload",
    ["EmptyReload"] = nil
})
v72("Electro Uzi", "rbxassetid://96806694653207", "rbxassetid://98294074022488", nil, nil, nil, CFrame.new(0, -0.125, 0.125), "uzi_equip", "uzi_idle", "uzi_sprint", "uzi_inspect", nil, {
    ["Shoot1"] = "uzi_electrouzi_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "uzi_electrouzi_reload",
    ["EmptyReload"] = nil
})
v72("Demon Uzi", "rbxassetid://132973040482576", "rbxassetid://81076572654230", nil, nil, nil, CFrame.new(0, -0.125, 0.125), "uzi_equip", "uzi_idle", "uzi_sprint", "uzi_inspect", nil, {
    ["Shoot1"] = "uzi_demonuzi_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "uzi_reload",
    ["EmptyReload"] = nil
})
v72("Pine Uzi", "rbxassetid://82545206964916", "rbxassetid://80778273701013", nil, nil, nil, CFrame.new(0, -0.125, 0.125), "uzi_equip", "uzi_idle", "uzi_sprint", "uzi_inspect", nil, {
    ["Shoot1"] = "uzi_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "uzi_reload",
    ["EmptyReload"] = nil
})
v72("Money Gun", "rbxassetid://100705725115757", "rbxassetid://73092203311844", nil, nil, nil, CFrame.new(0, -0.125, -0.125), "uzi_moneygun_equip", "uzi_moneygun_idle", "uzi_moneygun_sprint", "uzi_moneygun_inspect", nil, {
    ["Shoot1"] = "uzi_moneygun_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "uzi_moneygun_reload",
    ["EmptyReload"] = nil
})
v72("Keyzi", "rbxassetid://100392703246534", "rbxassetid://127937206087121", nil, nil, nil, CFrame.new(0, -0.125, -0.375), "uzi_keyzi_equip", "uzi_keyzi_idle", "uzi_keyzi_sprint", "uzi_keyzi_inspect", nil, {
    ["Shoot1"] = "uzi_keyzi_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "uzi_keyzi_reload",
    ["EmptyReload"] = nil
})
v72("Glorious Uzi", "rbxassetid://120045334159124", "rbxassetid://121978889022374", nil, nil, nil, CFrame.new(0, -0.125, 0.125), "uzi_equip", "uzi_idle", "uzi_sprint", "uzi_inspect", nil, {
    ["Shoot1"] = "uzi_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "uzi_reload",
    ["EmptyReload"] = nil
})
v72("Revolver", "rbxassetid://17160800299", "rbxassetid://14020829500", nil, "rbxassetid://122164679882999", 1.5, CFrame.new(0, -0.125, -0.125), "revolver_equip", "revolver_idle", "revolver_sprint", "revolver_inspect", nil, {
    ["Shoot1"] = "revolver_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "revolver_reload",
    ["EmptyReload"] = "revolver_reload_empty",
    ["QuickShot"] = "revolver_quickshot"
})
v72("Desert Eagle", "rbxassetid://17821234372", "rbxassetid://17821265603", nil, nil, nil, CFrame.new(0.25, -0.125, -0.125) * CFrame.Angles(0, 0.08726646259971647, -0.17453292519943295), "revolver_deserteagle_equip", "handgun_idle", "handgun_sprint", "handgun_inspect", nil, {
    ["Shoot1"] = "revolver_deserteagle_shoot1",
    ["FinalShoot"] = "revolver_deserteagle_shoot_final",
    ["Reload"] = "revolver_deserteagle_reload",
    ["EmptyReload"] = "revolver_deserteagle_reload_empty",
    ["QuickShot"] = "revolver_deserteagle_shoot1"
})
v72("Sheriff", "rbxassetid://18770192507", "rbxassetid://18770200449", nil, nil, nil, CFrame.new(0.25, -0.125, -0.375) * CFrame.Angles(0, 0.08726646259971647, -0.17453292519943295), "revolver_sheriff_equip", "revolver_sheriff_idle", "revolver_sheriff_sprint", "revolver_sheriff_inspect", nil, {
    ["Shoot1"] = "revolver_sheriff_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "revolver_sheriff_reload",
    ["EmptyReload"] = "revolver_sheriff_reload_empty",
    ["QuickShot"] = "revolver_sheriff_quickshot"
})
v72("Boneclaw Revolver", "rbxassetid://119174697609264", "rbxassetid://134217952089145", nil, nil, nil, CFrame.new(0, -0.125, -0.125), "revolver_equip", "revolver_idle", "revolver_sprint", "revolver_inspect", nil, {
    ["Shoot1"] = "revolver_boneclawrevolver_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "revolver_reload",
    ["EmptyReload"] = "revolver_reload_empty",
    ["QuickShot"] = "revolver_boneclawrevolver_quickshot"
})
v72("Peppermint Sheriff", "rbxassetid://95859403750768", "rbxassetid://71229586558137", nil, nil, nil, CFrame.new(0.25, -0.125, -0.375) * CFrame.Angles(0, 0.08726646259971647, -0.17453292519943295), "revolver_peppermintsheriff_equip", "revolver_peppermintsheriff_idle", "revolver_peppermintsheriff_sprint", "revolver_peppermintsheriff_inspect", nil, {
    ["Shoot1"] = "revolver_peppermintsheriff_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "revolver_peppermintsheriff_reload",
    ["EmptyReload"] = "revolver_peppermintsheriff_reload_empty",
    ["QuickShot"] = "revolver_peppermintsheriff_quickshot"
})
v72("Keyvolver", "rbxassetid://87974031410344", "rbxassetid://73746116648532", nil, nil, nil, CFrame.new(0, -0.125, -0.375), "revolver_keyvolver_equip", "revolver_keyvolver_idle", "revolver_keyvolver_sprint", "revolver_keyvolver_inspect", nil, {
    ["Shoot1"] = "revolver_keyvolver_shoot1",
    ["FinalShoot"] = "revolver_keyvolver_shoot_final",
    ["Reload"] = "revolver_keyvolver_reload",
    ["EmptyReload"] = "revolver_keyvolver_reload_empty",
    ["QuickShot"] = "revolver_keyvolver_quickshot",
    ["EquipEmpty"] = "revolver_keyvolver_equip_empty",
    ["IdleEmpty"] = "revolver_keyvolver_idle_empty",
    ["SprintEmpty"] = "revolver_keyvolver_sprint_empty",
    ["InspectEmpty"] = "revolver_keyvolver_inspect_empty"
})
v72("Peppergun", "rbxassetid://124178691056979", "rbxassetid://112311707478578", nil, nil, nil, CFrame.new(0.25, -0.125, -0.375) * CFrame.Angles(0, 0.08726646259971647, -0.17453292519943295), "revolver_peppergun_equip", "revolver_peppergun_idle", "revolver_peppergun_sprint", "revolver_peppergun_inspect", nil, {
    ["Shoot1"] = "revolver_peppergun_shoot1",
    ["FinalShoot"] = "revolver_peppergun_shoot_final",
    ["Reload"] = "revolver_peppergun_reload",
    ["EmptyReload"] = "revolver_peppergun_reload_empty",
    ["QuickShot"] = "revolver_peppergun_quickshot",
    ["EquipEmpty"] = "revolver_peppergun_equip_empty",
    ["IdleEmpty"] = "revolver_peppergun_idle_empty",
    ["SprintEmpty"] = "revolver_peppergun_sprint_empty",
    ["InspectEmpty"] = "revolver_peppergun_inspect_empty"
})
v72("Glorious Revolver", "rbxassetid://118135542031794", "rbxassetid://137749607553707", nil, nil, nil, CFrame.new(0, -0.125, -0.125), "revolver_equip", "revolver_idle", "revolver_sprint", "revolver_inspect", nil, {
    ["Shoot1"] = "revolver_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "revolver_reload",
    ["EmptyReload"] = "revolver_reload_empty",
    ["QuickShot"] = "revolver_quickshot"
})
v72("Paintball Gun", "rbxassetid://17160853798", "rbxassetid://16560547676", nil, "rbxassetid://82789508344248", 2, CFrame.new(0, -0.25, -0.375), "paintballgun_equip", "paintballgun_idle", "paintballgun_sprint", "paintballgun_inspect", nil, {
    ["Shoot1"] = "paintballgun_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "paintballgun_reload",
    ["EmptyReload"] = nil
})
v72("Slime Gun", "rbxassetid://17672062472", "rbxassetid://17672087561", nil, nil, nil, CFrame.new(0, -0.25, -0.375), "paintballgun_equip", "paintballgun_idle", "paintballgun_sprint", "paintballgun_inspect", nil, {
    ["Shoot1"] = "paintballgun_slimegun_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "paintballgun_reload",
    ["EmptyReload"] = nil
})
v72("Boba Gun", "rbxassetid://18768830660", "rbxassetid://18768828072", nil, nil, nil, CFrame.new(0, -0.25, -0.375), "paintballgun_equip", "paintballgun_idle", "paintballgun_sprint", "paintballgun_inspect", nil, {
    ["Shoot1"] = "paintballgun_bobagun_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "paintballgun_reload",
    ["EmptyReload"] = nil
})
v72("Brain Gun", "rbxassetid://85970592668118", "rbxassetid://135843933439701", nil, nil, nil, CFrame.new(0, -0.25, -0.375), "paintballgun_equip", "paintballgun_idle", "paintballgun_sprint", "paintballgun_inspect", nil, {
    ["Shoot1"] = "paintballgun_slimegun_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "paintballgun_reload",
    ["EmptyReload"] = nil
})
v72("Snowball Gun", "rbxassetid://113685354916533", "rbxassetid://78161595959189", nil, nil, nil, CFrame.new(0, -0.25, -0.375), "paintballgun_equip", "paintballgun_idle", "paintballgun_sprint", "paintballgun_inspect", nil, {
    ["Shoot1"] = "paintballgun_snowballgun_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "paintballgun_reload",
    ["EmptyReload"] = nil
})
v72("Ketchup Gun", "rbxassetid://76083615050939", "rbxassetid://130402361506639", nil, nil, nil, CFrame.new(0, -0.25, -0.375), "paintballgun_equip", "paintballgun_idle", "paintballgun_sprint", "paintballgun_inspect", nil, {
    ["Shoot1"] = "paintballgun_ketchupgun_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "paintballgun_reload",
    ["EmptyReload"] = nil
})
v72("Glorious Paintball Gun", "rbxassetid://86297318955856", "rbxassetid://92272641219379", nil, nil, nil, CFrame.new(0, -0.25, -0.375), "paintballgun_equip", "paintballgun_idle", "paintballgun_sprint", "paintballgun_inspect", nil, {
    ["Shoot1"] = "paintballgun_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "paintballgun_reload",
    ["EmptyReload"] = nil
})
v72("Slingshot", "rbxassetid://17160799888", "rbxassetid://17095306079", nil, "rbxassetid://75643870124560", 1.25, CFrame.new(0, -0.375, -0.5), "slingshot_equip", "slingshot_idle", "slingshot_sprint", "slingshot_inspect", nil, {
    ["Shoot1"] = "slingshot_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = nil,
    ["EmptyReload"] = nil
})
v72("Goalpost", "rbxassetid://17672063165", "rbxassetid://17672086378", nil, nil, nil, CFrame.new(0, -0.375, -0.5), "slingshot_equip", "slingshot_idle", "slingshot_sprint", "slingshot_inspect", nil, {
    ["Shoot1"] = "slingshot_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = nil,
    ["EmptyReload"] = nil
})
v72("Stick", "rbxassetid://17672063048", "rbxassetid://17672086502", nil, nil, nil, CFrame.new(0, -0.375, -0.5), "slingshot_equip", "slingshot_idle", "slingshot_sprint", "slingshot_inspect", nil, {
    ["Shoot1"] = "slingshot_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = nil,
    ["EmptyReload"] = nil
})
v72("Boneshot", "rbxassetid://86606957688341", "rbxassetid://103283614012077", nil, nil, nil, CFrame.new(0, -0.375, -0.5), "slingshot_equip", "slingshot_idle", "slingshot_sprint", "slingshot_inspect", nil, {
    ["Shoot1"] = "slingshot_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = nil,
    ["EmptyReload"] = nil
})
v72("Reindeer Slingshot", "rbxassetid://121612921203624", "rbxassetid://106406735551091", nil, nil, nil, CFrame.new(0, -0.375, -0.5), "slingshot_equip", "slingshot_idle", "slingshot_sprint", "slingshot_inspect", nil, {
    ["Shoot1"] = "slingshot_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = nil,
    ["EmptyReload"] = nil
})
v72("Harp", "rbxassetid://80850043664453", "rbxassetid://89702051394732", nil, nil, nil, CFrame.new(0, -0.375, -0.5), "slingshot_harp_equip", "slingshot_harp_idle", "slingshot_harp_sprint", "slingshot_harp_inspect", nil, {
    ["Shoot1"] = "slingshot_harp_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = nil,
    ["EmptyReload"] = nil
})
v72("Glorious Slingshot", "rbxassetid://101195664167288", "rbxassetid://111031840425662", nil, nil, nil, CFrame.new(0, -0.375, -0.5), "slingshot_equip", "slingshot_idle", "slingshot_sprint", "slingshot_inspect", nil, {
    ["Shoot1"] = "slingshot_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = nil,
    ["EmptyReload"] = nil
})
v72("Grenade Launcher", "rbxassetid://17250453814", "rbxassetid://17250456230", nil, "rbxassetid://96911371491753", 2.75, CFrame.new(0, -0.125, -0.125) * CFrame.Angles(0.08726646259971647, 0, 0), "grenadelauncher_equip", "grenadelauncher_idle", "grenadelauncher_sprint", "grenadelauncher_inspect", nil, {
    ["Shoot1"] = "grenadelauncher_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "grenadelauncher_reload",
    ["EmptyReload"] = nil
})
v72("Swashbuckler", "rbxassetid://17821233828", "rbxassetid://17821265007", nil, nil, nil, CFrame.new(0, -0.25, -0.5) * CFrame.Angles(0.08726646259971647, 0, 0), "grenadelauncher_equip", "grenadelauncher_idle", "grenadelauncher_sprint", "grenadelauncher_inspect", nil, {
    ["Shoot1"] = "grenadelauncher_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "grenadelauncher_reload",
    ["EmptyReload"] = nil
})
v72("Uranium Launcher", "rbxassetid://18766860114", "rbxassetid://18766902983", nil, nil, nil, CFrame.new(0, -0.125, -0.125) * CFrame.Angles(0.08726646259971647, 0, 0), "grenadelauncher_equip", "grenadelauncher_idle", "grenadelauncher_sprint", "grenadelauncher_inspect", nil, {
    ["Shoot1"] = "grenadelauncher_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "grenadelauncher_reload",
    ["EmptyReload"] = nil
})
v72("Skull Launcher", "rbxassetid://103257281022910", "rbxassetid://88061081371943", nil, nil, nil, CFrame.new(0, -0.25, -0.5) * CFrame.Angles(0.08726646259971647, 0, 0), "grenadelauncher_equip", "grenadelauncher_idle", "grenadelauncher_sprint", "grenadelauncher_inspect", nil, {
    ["Shoot1"] = "grenadelauncher_skulllauncher_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "grenadelauncher_reload",
    ["EmptyReload"] = nil
})
v72("Snowball Launcher", "rbxassetid://112349955391111", "rbxassetid://136762406657736", nil, nil, nil, CFrame.new(0, -0.25, -0.5) * CFrame.Angles(0.08726646259971647, 0, 0), "grenadelauncher_snowballlauncher_equip", "grenadelauncher_idle", "grenadelauncher_sprint", "grenadelauncher_inspect", nil, {
    ["Shoot1"] = "grenadelauncher_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "grenadelauncher_reload",
    ["EmptyReload"] = nil
})
v72("Gearnade Launcher", "rbxassetid://133756750612042", "rbxassetid://91208130484582", nil, nil, nil, CFrame.new(0, -0.375, -0.375) * CFrame.Angles(0.08726646259971647, 0, 0), "grenadelauncher_gearnadelauncher_equip", "grenadelauncher_idle", "grenadelauncher_sprint", "grenadelauncher_gearnadelauncher_inspect", nil, {
    ["Shoot1"] = "grenadelauncher_gearnadelauncher_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "grenadelauncher_gearnadelauncher_reload",
    ["EmptyReload"] = nil
})
v72("Glorious Grenade Launcher", "rbxassetid://134130354519919", "rbxassetid://133636006123737", nil, nil, nil, CFrame.new(0, -0.125, -0.125) * CFrame.Angles(0.08726646259971647, 0, 0), "grenadelauncher_equip", "grenadelauncher_idle", "grenadelauncher_sprint", "grenadelauncher_inspect", nil, {
    ["Shoot1"] = "grenadelauncher_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "grenadelauncher_reload",
    ["EmptyReload"] = nil
})
v72("Minigun", "rbxassetid://17250458611", "rbxassetid://17250457775", nil, "rbxassetid://139259875015340", 3.25, CFrame.new(0, -0.375, -0.375) * CFrame.Angles(0.08726646259971647, 0.03490658503988659, 0), "minigun_equip", "minigun_idle", "minigun_sprint", "minigun_inspect", nil, {
    ["Shoot1"] = nil,
    ["FinalShoot"] = nil,
    ["Reload"] = nil,
    ["EmptyReload"] = nil,
    ["ChargeStart"] = "minigun_charge_start",
    ["ChargeLoop"] = "minigun_charge_loop",
    ["ChargeFinish"] = "minigun_charge_finish"
})
v72("Lasergun 3000", "rbxassetid://103437974285778", "rbxassetid://116040043955852", nil, nil, nil, CFrame.new(0, -0.5, -0.5) * CFrame.Angles(0.08726646259971647, 0.03490658503988659, 0), "minigun_equip", "minigun_idle", "minigun_sprint", "minigun_inspect", nil, {
    ["Shoot1"] = nil,
    ["FinalShoot"] = nil,
    ["Reload"] = nil,
    ["EmptyReload"] = nil,
    ["ChargeStart"] = "minigun_charge_start",
    ["ChargeLoop"] = "minigun_charge_loop",
    ["ChargeFinish"] = "minigun_charge_finish"
})
v72("Pixel Minigun", "rbxassetid://18766861798", "rbxassetid://18769001642", nil, nil, nil, CFrame.new(0, -0.375, -0.375) * CFrame.Angles(0.08726646259971647, 0.03490658503988659, 0), "minigun_pixelminigun_equip", "minigun_pixelminigun_idle", "minigun_pixelminigun_sprint", "minigun_pixelminigun_inspect", nil, {
    ["Shoot1"] = nil,
    ["FinalShoot"] = nil,
    ["Reload"] = nil,
    ["EmptyReload"] = nil,
    ["ChargeStart"] = "minigun_pixelminigun_charge_start",
    ["ChargeLoop"] = "minigun_pixelminigun_charge_loop",
    ["ChargeFinish"] = "minigun_pixelminigun_charge_finish"
}, {
    ["FramesPerSecond"] = 2,
    ["PlayAnimationsInstantly"] = true
})
v72("Pumpkin Minigun", "rbxassetid://77388785880854", "rbxassetid://101609024294564", nil, nil, nil, CFrame.new(0, -0.375, -0.375) * CFrame.Angles(0.08726646259971647, 0.03490658503988659, 0), "minigun_equip", "minigun_idle", "minigun_sprint", "minigun_inspect", nil, {
    ["Shoot1"] = nil,
    ["FinalShoot"] = nil,
    ["Reload"] = nil,
    ["EmptyReload"] = nil,
    ["ChargeStart"] = "minigun_charge_start",
    ["ChargeLoop"] = "minigun_charge_loop",
    ["ChargeFinish"] = "minigun_charge_finish"
})
v72("Wrapped Minigun", "rbxassetid://127077702465909", "rbxassetid://77902572458498", nil, nil, nil, CFrame.new(0, -0.375, -0.375) * CFrame.Angles(0.08726646259971647, 0.03490658503988659, 0), "minigun_wrappedminigun_equip", "minigun_idle", "minigun_sprint", "minigun_inspect", nil, {
    ["Shoot1"] = nil,
    ["FinalShoot"] = nil,
    ["Reload"] = nil,
    ["EmptyReload"] = nil,
    ["ChargeStart"] = "minigun_charge_start",
    ["ChargeLoop"] = "minigun_charge_loop",
    ["ChargeFinish"] = "minigun_charge_finish"
})
v72("Fighter Jet", "rbxassetid://70780739230558", "rbxassetid://95650502925488", nil, nil, nil, CFrame.new(0, -0.375, -0.375) * CFrame.Angles(0.08726646259971647, 0.03490658503988659, 0), "minigun_fighterjet_equip", "minigun_fighterjet_idle", "minigun_fighterjet_sprint", "minigun_fighterjet_inspect", nil, {
    ["Shoot1"] = nil,
    ["FinalShoot"] = nil,
    ["Reload"] = nil,
    ["EmptyReload"] = nil,
    ["ChargeStart"] = "minigun_fighterjet_charge_start",
    ["ChargeLoop"] = "minigun_fighterjet_charge_loop",
    ["ChargeFinish"] = "minigun_fighterjet_charge_finish"
})
v72("Glorious Minigun", "rbxassetid://84246894288637", "rbxassetid://99372535399034", nil, nil, nil, CFrame.new(0, -0.375, -0.375) * CFrame.Angles(0.08726646259971647, 0.03490658503988659, 0), "minigun_equip", "minigun_idle", "minigun_sprint", "minigun_inspect", nil, {
    ["Shoot1"] = nil,
    ["FinalShoot"] = nil,
    ["Reload"] = nil,
    ["EmptyReload"] = nil,
    ["ChargeStart"] = "minigun_charge_start",
    ["ChargeLoop"] = "minigun_charge_loop",
    ["ChargeFinish"] = "minigun_charge_finish"
})
v72("Exogun", "rbxassetid://17344796376", "rbxassetid://17344797370", nil, "rbxassetid://88192617023871", 1.5, CFrame.new(0, -0.25, 0) * CFrame.Angles(0.08726646259971647, 0, 0), "exogun_equip", "exogun_idle", "exogun_sprint", "exogun_inspect", nil, {
    ["Shoot1"] = "exogun_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "exogun_reload",
    ["EmptyReload"] = nil
})
v72("Wondergun", "rbxassetid://17672060360", "rbxassetid://17672086052", nil, nil, nil, CFrame.new(0, -0.25, 0) * CFrame.Angles(0.08726646259971647, 0, 0), "exogun_equip", "exogun_idle", "exogun_sprint", "exogun_inspect", nil, {
    ["Shoot1"] = "exogun_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "exogun_reload",
    ["EmptyReload"] = nil
})
v72("Singularity", "rbxassetid://17676876756", "rbxassetid://17676875650", nil, nil, nil, CFrame.new(0, -0.25, 0) * CFrame.Angles(0.08726646259971647, 0, 0), "exogun_singularity_equip", "exogun_idle", "exogun_sprint", "exogun_inspect", nil, {
    ["Shoot1"] = "exogun_singularity_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "exogun_singularity_reload",
    ["EmptyReload"] = nil
})
v72("Ray Gun", "rbxassetid://18766861454", "rbxassetid://18766905089", nil, nil, nil, CFrame.new(0, -0.25, 0) * CFrame.Angles(0.08726646259971647, 0, 0), "exogun_equip", "exogun_idle", "exogun_sprint", "exogun_inspect", nil, {
    ["Shoot1"] = "exogun_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "exogun_reload",
    ["EmptyReload"] = nil
})
v72("Exogourd", "rbxassetid://137140750597688", "rbxassetid://125880131168138", nil, nil, nil, CFrame.new(0, -0.25, 0) * CFrame.Angles(0.08726646259971647, 0, 0), "exogun_equip", "exogun_idle", "exogun_sprint", "exogun_inspect", nil, {
    ["Shoot1"] = "exogun_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "exogun_reload",
    ["EmptyReload"] = nil
})
v72("Midnight Festive Exogun", "rbxassetid://127612442529810", "rbxassetid://80015495064851", nil, nil, nil, CFrame.new(0, -0.25, 0) * CFrame.Angles(0.08726646259971647, 0, 0), "exogun_equip", "exogun_idle", "exogun_sprint", "exogun_inspect", nil, {
    ["Shoot1"] = "exogun_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "exogun_reload",
    ["EmptyReload"] = nil
})
v72("Repulsor", "rbxassetid://109263387714628", "rbxassetid://130472229545721", nil, nil, nil, CFrame.new(0, -0.25, -0.25) * CFrame.Angles(0.08726646259971647, 0, 0), "exogun_repulsor_equip", "exogun_repulsor_idle", "exogun_repulsor_sprint", "exogun_repulsor_inspect", nil, {
    ["Shoot1"] = "exogun_repulsor_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "exogun_repulsor_reload",
    ["EmptyReload"] = nil
})
v72("Glorious Exogun", "rbxassetid://129125201034206", "rbxassetid://105785189977176", nil, nil, nil, CFrame.new(0, -0.25, 0) * CFrame.Angles(0.08726646259971647, 0, 0), "exogun_equip", "exogun_idle", "exogun_sprint", "exogun_inspect", nil, {
    ["Shoot1"] = "exogun_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "exogun_reload",
    ["EmptyReload"] = nil
})
v72("Freeze Ray", "rbxassetid://18429552328", "rbxassetid://18429549331", nil, "rbxassetid://72287797030544", 1.5, nil, "freezeray_equip", "freezeray_idle", "freezeray_sprint", "freezeray_inspect", nil, {
    ["Shoot1"] = "freezeray_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = nil,
    ["EmptyReload"] = nil
})
v72("Temporal Ray", "rbxassetid://18429552503", "rbxassetid://18429549663", nil, nil, nil, nil, "freezeray_equip", "freezeray_idle", "freezeray_sprint", "freezeray_inspect", nil, {
    ["Shoot1"] = "freezeray_temporalray_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = nil,
    ["EmptyReload"] = nil
})
v72("Bubble Ray", "rbxassetid://18766865819", "rbxassetid://18769002868", nil, nil, nil, nil, "freezeray_bubbleray_equip", "freezeray_idle", "freezeray_sprint", "freezeray_inspect", nil, {
    ["Shoot1"] = "freezeray_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = nil,
    ["EmptyReload"] = nil
})
v72("Spider Ray", "rbxassetid://136838810668332", "rbxassetid://92621276006979", nil, nil, nil, nil, "freezeray_spiderray_equip", "freezeray_spiderray_idle", "freezeray_spiderray_sprint", "freezeray_spiderray_inspect", nil, {
    ["Shoot1"] = "freezeray_spiderray_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = nil,
    ["EmptyReload"] = nil
})
v72("Wrapped Freeze Ray", "rbxassetid://76183738050112", "rbxassetid://77624613843681", nil, nil, nil, nil, "freezeray_wrappedfreezeray_equip", "freezeray_idle", "freezeray_sprint", "freezeray_inspect", nil, {
    ["Shoot1"] = "freezeray_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = nil,
    ["EmptyReload"] = nil
})
v72("Gum Ray", "rbxassetid://121504417727123", "rbxassetid://124339207784760", nil, nil, nil, nil, "freezeray_equip", "freezeray_idle", "freezeray_sprint", "freezeray_inspect", nil, {
    ["Shoot1"] = "freezeray_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = nil,
    ["EmptyReload"] = nil
})
v72("Glorious Freeze Ray", "rbxassetid://120211873831101", "rbxassetid://96505833323714", nil, nil, nil, nil, "freezeray_equip", "freezeray_idle", "freezeray_sprint", "freezeray_inspect", nil, {
    ["Shoot1"] = "freezeray_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = nil,
    ["EmptyReload"] = nil
})
v72("War Horn", "rbxassetid://104600246515190", "rbxassetid://97997387092919", nil, "rbxassetid://98364412304002", 1.5, nil, "warhorn_equip", "warhorn_idle", "warhorn_sprint", "warhorn_inspect", nil, {
    ["Use"] = "warhorn_use"
})
v72("Trumpet", "rbxassetid://88975601634708", "rbxassetid://113408430051712", nil, nil, nil, nil, "warhorn_equip", "warhorn_idle", "warhorn_sprint", "warhorn_inspect", nil, {
    ["Use"] = "warhorn_trumpet_use"
})
v72("Mammoth Horn", "rbxassetid://93076834584542", "rbxassetid://107659166723688", nil, nil, nil, nil, "warhorn_equip", "warhorn_idle", "warhorn_sprint", "warhorn_inspect", nil, {
    ["Use"] = "warhorn_mammothhorn_use"
})
v72("Megaphone", "rbxassetid://107074211847347", "rbxassetid://100739584109870", nil, nil, nil, nil, "warhorn_equip", "warhorn_idle", "warhorn_sprint", "warhorn_inspect", nil, {
    ["Use"] = "warhorn_megaphone_use"
})
v72("Air Horn", "rbxassetid://111168146142976", "rbxassetid://128732687072177", nil, nil, nil, nil, "warhorn_equip", "warhorn_idle", "warhorn_sprint", "warhorn_inspect", nil, {
    ["Use"] = "warhorn_airhorn_use"
})
v72("Glorious War Horn", "rbxassetid://96293355496772", "rbxassetid://123021790391323", nil, nil, nil, nil, "warhorn_equip", "warhorn_idle", "warhorn_sprint", "warhorn_inspect", nil, {
    ["Use"] = "warhorn_use"
})
v72("Boneclaw Horn", "rbxassetid://138360812591331", "rbxassetid://126578341307256", nil, nil, nil, nil, "warhorn_boneclawhorn_equip", "warhorn_idle", "warhorn_sprint", "warhorn_inspect", nil, {
    ["Use"] = "warhorn_boneclawhorn_use"
})
v72("Satchel", "rbxassetid://82237471151891", "rbxassetid://132559258532984", nil, "rbxassetid://99042007892528", 1.5, nil, "satchel_equip", "grenade_idle", "grenade_sprint", "grenade_inspect", nil, {
    ["ThrowStart"] = "grenade_throw_start",
    ["ThrowIdle"] = "grenade_throw_idle",
    ["ThrowFinish"] = "grenade_throw_finish",
    ["LobStart"] = "grenade_lob_start",
    ["LobIdle"] = "grenade_lob_idle",
    ["LobFinish"] = "grenade_lob_finish",
    ["Detonate"] = "satchel_detonate"
})
v72("Advanced Satchel", "rbxassetid://113860326910548", "rbxassetid://118684510688617", nil, nil, nil, nil, "satchel_equip", "grenade_idle", "grenade_sprint", "grenade_inspect", nil, {
    ["ThrowStart"] = "grenade_throw_start",
    ["ThrowIdle"] = "grenade_throw_idle",
    ["ThrowFinish"] = "grenade_throw_finish",
    ["LobStart"] = "grenade_lob_start",
    ["LobIdle"] = "grenade_lob_idle",
    ["LobFinish"] = "grenade_lob_finish",
    ["Detonate"] = "satchel_advancedsatchel_detonate"
})
v72("Suspicious Gift", "rbxassetid://76209303162814", "rbxassetid://131542627171282", nil, nil, nil, nil, "satchel_suspiciousgift_equip", "grenade_idle", "grenade_sprint", "grenade_inspect", nil, {
    ["ThrowStart"] = "grenade_throw_start",
    ["ThrowIdle"] = "grenade_throw_idle",
    ["ThrowFinish"] = "grenade_throw_finish",
    ["LobStart"] = "grenade_lob_start",
    ["LobIdle"] = "grenade_lob_idle",
    ["LobFinish"] = "grenade_lob_finish",
    ["Detonate"] = "satchel_detonate"
})
v72("Notebook Satchel", "rbxassetid://124817464748150", "rbxassetid://85589408404069", nil, nil, nil, nil, "satchel_equip", "grenade_idle", "grenade_sprint", "grenade_inspect", nil, {
    ["ThrowStart"] = "grenade_throw_start",
    ["ThrowIdle"] = "grenade_throw_idle",
    ["ThrowFinish"] = "grenade_throw_finish",
    ["LobStart"] = "grenade_lob_start",
    ["LobIdle"] = "grenade_lob_idle",
    ["LobFinish"] = "grenade_lob_finish",
    ["Detonate"] = "satchel_detonate"
})
v72("Bag o\' Money", "rbxassetid://129192426700659", "rbxassetid://118634288543707", nil, nil, nil, nil, "satchel_equip", "grenade_idle", "grenade_sprint", "grenade_inspect", nil, {
    ["ThrowStart"] = "grenade_throw_start",
    ["ThrowIdle"] = "grenade_throw_idle",
    ["ThrowFinish"] = "grenade_throw_finish",
    ["LobStart"] = "grenade_lob_start",
    ["LobIdle"] = "grenade_lob_idle",
    ["LobFinish"] = "grenade_lob_finish",
    ["Detonate"] = "satchel_detonate"
})
v72("Glorious Satchel", "rbxassetid://100521994805910", "rbxassetid://85737788428846", nil, nil, nil, nil, "satchel_equip", "grenade_idle", "grenade_sprint", "grenade_inspect", nil, {
    ["ThrowStart"] = "grenade_throw_start",
    ["ThrowIdle"] = "grenade_throw_idle",
    ["ThrowFinish"] = "grenade_throw_finish",
    ["LobStart"] = "grenade_lob_start",
    ["LobIdle"] = "grenade_lob_idle",
    ["LobFinish"] = "grenade_lob_finish",
    ["Detonate"] = "satchel_detonate"
})
v72("Potion Satchel", "rbxassetid://76787046046890", "rbxassetid://112434777433399", nil, nil, nil, nil, "satchel_equip", "grenade_idle", "grenade_sprint", "grenade_inspect", nil, {
    ["ThrowStart"] = "grenade_throw_start",
    ["ThrowIdle"] = "grenade_throw_idle",
    ["ThrowFinish"] = "grenade_throw_finish",
    ["LobStart"] = "grenade_lob_start",
    ["LobIdle"] = "grenade_lob_idle",
    ["LobFinish"] = "grenade_lob_finish",
    ["Detonate"] = "satchel_potionsatchel_detonate"
})
v72("Battle Axe", "rbxassetid://93390542043222", "rbxassetid://78364101927650", nil, "rbxassetid://89974468602998", 2, nil, "battleaxe_equip", "battleaxe_idle", "battleaxe_sprint", "battleaxe_inspect", nil, {
    ["Attack1"] = "battleaxe_attack1",
    ["Attack2"] = "battleaxe_attack2",
    ["SpinAttack"] = "battleaxe_spinattack"
})
v72("The Shred", "rbxassetid://71234381808727", "rbxassetid://95922136476180", nil, nil, nil, nil, "battleaxe_equip", "battleaxe_idle", "battleaxe_sprint", "battleaxe_theshred_inspect", nil, {
    ["Attack1"] = "battleaxe_theshred_attack1",
    ["Attack2"] = "battleaxe_theshred_attack2",
    ["SpinAttack"] = "battleaxe_theshred_spinattack"
})
v72("Nordic Axe", "rbxassetid://80052264197135", "rbxassetid://86476943038006", nil, nil, nil, nil, "battleaxe_equip", "battleaxe_idle", "battleaxe_sprint", "battleaxe_inspect", nil, {
    ["Attack1"] = "battleaxe_attack1",
    ["Attack2"] = "battleaxe_attack2",
    ["SpinAttack"] = "battleaxe_spinattack"
})
v72("Ban Axe", "rbxassetid://111046431576859", "rbxassetid://100159715604530", nil, nil, nil, nil, "battleaxe_equip", "battleaxe_idle", "battleaxe_sprint", "battleaxe_inspect", nil, {
    ["Attack1"] = "battleaxe_attack1",
    ["Attack2"] = "battleaxe_attack2",
    ["SpinAttack"] = "battleaxe_spinattack"
})
v72("Cerulean Axe", "rbxassetid://76353832683350", "rbxassetid://82989708806032", nil, nil, nil, nil, "battleaxe_equip", "battleaxe_idle", "battleaxe_sprint", "battleaxe_inspect", nil, {
    ["Attack1"] = "battleaxe_ceruleanaxe_attack1",
    ["Attack2"] = "battleaxe_ceruleanaxe_attack2",
    ["SpinAttack"] = "battleaxe_ceruleanaxe_spinattack"
})
v72("Glorious Battle Axe", "rbxassetid://87227212476138", "rbxassetid://72356106057179", nil, nil, nil, nil, "battleaxe_equip", "battleaxe_idle", "battleaxe_sprint", "battleaxe_inspect", nil, {
    ["Attack1"] = "battleaxe_attack1",
    ["Attack2"] = "battleaxe_attack2",
    ["SpinAttack"] = "battleaxe_spinattack"
})
v72("Mimic Axe", "rbxassetid://111717370450373", "rbxassetid://96746396437552", nil, nil, nil, nil, "battleaxe_equip", "battleaxe_idle", "battleaxe_sprint", "battleaxe_inspect", nil, {
    ["Attack1"] = "battleaxe_mimicaxe_attack1",
    ["Attack2"] = "battleaxe_mimicaxe_attack2",
    ["SpinAttack"] = "battleaxe_mimicaxe_spinattack"
})
v72("Keyttle Axe", "rbxassetid://122117068984402", "rbxassetid://100168194779130", nil, nil, nil, nil, "battleaxe_keyttleaxe_equip", "battleaxe_keyttleaxe_idle", "battleaxe_keyttleaxe_sprint", "battleaxe_keyttleaxe_inspect", nil, {
    ["Attack1"] = "battleaxe_keyttleaxe_attack1",
    ["Attack2"] = "battleaxe_keyttleaxe_attack2",
    ["SpinAttack"] = "battleaxe_keyttleaxe_spinattack"
})
v72("Riot Shield", "rbxassetid://121172272442833", "rbxassetid://126785276332335", nil, "rbxassetid://97178934256596", 1.75, nil, "riotshield_equip", "riotshield_idle", "riotshield_sprint", "riotshield_inspect", nil, {
    ["Attack1"] = "riotshield_attack1",
    ["Attack2"] = "riotshield_attack2"
})
v72("Door", "rbxassetid://79242603995428", "rbxassetid://137027368393353", nil, nil, nil, nil, "riotshield_equip", "riotshield_idle", "riotshield_sprint", "riotshield_inspect", nil, {
    ["Attack1"] = "riotshield_attack1",
    ["Attack2"] = "riotshield_attack2"
})
v72("Sled", "rbxassetid://73881731607231", "rbxassetid://127016476735322", nil, nil, nil, nil, "riotshield_equip", "riotshield_idle", "riotshield_sprint", "riotshield_inspect", nil, {
    ["Attack1"] = "riotshield_attack1",
    ["Attack2"] = "riotshield_attack2"
})
v72("Energy Shield", "rbxassetid://90215439337413", "rbxassetid://127037252186171", nil, nil, nil, nil, "riotshield_energyshield_equip", "riotshield_idle", "riotshield_sprint", "riotshield_inspect", nil, {
    ["Attack1"] = "riotshield_energyshield_attack1",
    ["Attack2"] = "riotshield_energyshield_attack2"
})
v72("Masterpiece", "rbxassetid://79914271483818", "rbxassetid://72274483575028", nil, nil, nil, nil, "riotshield_equip", "riotshield_idle", "riotshield_sprint", "riotshield_inspect", nil, {
    ["Attack1"] = "riotshield_attack1",
    ["Attack2"] = "riotshield_attack2"
})
v72("Glorious Riot Shield", "rbxassetid://132866851386509", "rbxassetid://117405461442739", nil, nil, nil, nil, "riotshield_equip", "riotshield_idle", "riotshield_sprint", "riotshield_inspect", nil, {
    ["Attack1"] = "riotshield_attack1",
    ["Attack2"] = "riotshield_attack2"
})
v72("Tombstone Shield", "rbxassetid://125895528641243", "rbxassetid://114630737114417", nil, nil, nil, nil, "riotshield_equip", "riotshield_idle", "riotshield_sprint", "riotshield_inspect", nil, {
    ["Attack1"] = "riotshield_attack1",
    ["Attack2"] = "riotshield_attack2"
})
v72("Daggers", "rbxassetid://91885384580845", "rbxassetid://138508026547275", nil, "rbxassetid://112790625455883", 2, CFrame.new(0, -0.125, -0.125), "daggers_equip", "daggers_idle", "daggers_sprint", "daggers_inspect", nil, {
    ["Shoot1"] = "daggers_shoot1",
    ["FinalShoot"] = "daggers_shoot2",
    ["Reload"] = "daggers_reload",
    ["EmptyReload"] = nil,
    ["EmptyEquip"] = "fists_equip",
    ["EmptyIdle"] = "fists_idle",
    ["EmptyInspect"] = "fists_inspect"
})
v72("Aces", "rbxassetid://139089881483398", "rbxassetid://78850921968876", nil, nil, nil, CFrame.new(0, -0.125, -0.125), "daggers_equip", "daggers_idle", "daggers_sprint", "daggers_inspect", nil, {
    ["Shoot1"] = "daggers_aces_shoot1",
    ["FinalShoot"] = "daggers_aces_shoot2",
    ["Reload"] = "daggers_aces_reload",
    ["EmptyReload"] = nil,
    ["EmptyEquip"] = "fists_equip",
    ["EmptyIdle"] = "fists_idle",
    ["EmptyInspect"] = "fists_inspect"
})
v72("Cookies", "rbxassetid://114482325531769", "rbxassetid://112581667413176", nil, nil, nil, CFrame.new(0, -0.125, -0.125), "daggers_equip", "daggers_idle", "daggers_sprint", "daggers_inspect", nil, {
    ["Shoot1"] = "daggers_shoot1",
    ["FinalShoot"] = "daggers_shoot2",
    ["Reload"] = "daggers_cookies_reload",
    ["EmptyReload"] = nil,
    ["EmptyEquip"] = "fists_equip",
    ["EmptyIdle"] = "fists_idle",
    ["EmptyInspect"] = "fists_inspect"
})
v72("Crystal Daggers", "rbxassetid://126221748659600", "rbxassetid://92405854307880", nil, nil, nil, CFrame.new(0, -0.125, -0.125), "daggers_crystaldaggers_equip", "daggers_idle", "daggers_sprint", "daggers_crystaldaggers_inspect", nil, {
    ["Shoot1"] = "daggers_crystaldaggers_shoot1",
    ["FinalShoot"] = "daggers_crystaldaggers_shoot2",
    ["Reload"] = "daggers_crystaldaggers_reload",
    ["EmptyReload"] = nil,
    ["EmptyEquip"] = "fists_equip",
    ["EmptyIdle"] = "fists_idle",
    ["EmptyInspect"] = "fists_inspect"
})
v72("Paper Planes", "rbxassetid://84003122595879", "rbxassetid://90572065167686", nil, nil, nil, CFrame.new(0, -0.125, -0.125), "daggers_equip", "daggers_idle", "daggers_sprint", "daggers_inspect", nil, {
    ["Shoot1"] = "daggers_shoot1",
    ["FinalShoot"] = "daggers_shoot2",
    ["Reload"] = "daggers_paperplanes_reload",
    ["EmptyReload"] = nil,
    ["EmptyEquip"] = "fists_equip",
    ["EmptyIdle"] = "fists_idle",
    ["EmptyInspect"] = "fists_inspect"
})
v72("Shurikens", "rbxassetid://135574097643275", "rbxassetid://118592510576313", nil, nil, nil, CFrame.new(0, -0.125, -0.125), "daggers_equip", "daggers_idle", "daggers_sprint", "daggers_inspect", nil, {
    ["Shoot1"] = "daggers_shurikens_shoot1",
    ["FinalShoot"] = "daggers_shurikens_shoot2",
    ["Reload"] = "daggers_reload",
    ["EmptyReload"] = nil,
    ["EmptyEquip"] = "fists_equip",
    ["EmptyIdle"] = "fists_idle",
    ["EmptyInspect"] = "fists_inspect"
})
v72("Glorious Daggers", "rbxassetid://76023189104485", "rbxassetid://89590724074968", nil, nil, nil, CFrame.new(0, -0.125, -0.125), "daggers_equip", "daggers_idle", "daggers_sprint", "daggers_inspect", nil, {
    ["Shoot1"] = "daggers_shoot1",
    ["FinalShoot"] = "daggers_shoot2",
    ["Reload"] = "daggers_reload",
    ["EmptyReload"] = nil,
    ["EmptyEquip"] = "fists_equip",
    ["EmptyIdle"] = "fists_idle",
    ["EmptyInspect"] = "fists_inspect"
})
v72("Bat Daggers", "rbxassetid://92001964015225", "rbxassetid://137570635514267", nil, nil, nil, CFrame.new(0, -0.125, -0.125), "daggers_equip", "daggers_idle", "daggers_sprint", "daggers_inspect", nil, {
    ["Shoot1"] = "daggers_batdaggers_shoot1",
    ["FinalShoot"] = "daggers_batdaggers_shoot2",
    ["Reload"] = "daggers_reload",
    ["EmptyReload"] = nil,
    ["EmptyEquip"] = "fists_equip",
    ["EmptyIdle"] = "fists_idle",
    ["EmptyInspect"] = "fists_inspect"
})
v72("Keynais", "rbxassetid://84562761142610", "rbxassetid://133742080595679", nil, nil, nil, CFrame.new(0, -0.125, -0.125), "daggers_keynais_equip", "daggers_keynais_idle", "daggers_keynais_sprint", "daggers_keynais_inspect", nil, {
    ["Shoot1"] = "daggers_keynais_shoot1",
    ["FinalShoot"] = "daggers_keynais_shoot2",
    ["Reload"] = "daggers_keynais_reload",
    ["EmptyReload"] = nil,
    ["EmptyEquip"] = "fists_equip",
    ["EmptyIdle"] = "fists_idle",
    ["EmptyInspect"] = "fists_inspect"
})
v72("Energy Pistols", "rbxassetid://79471670126710", "rbxassetid://125338509278840", nil, "rbxassetid://110320793833810", 2.5, CFrame.new(0, -0.375, -0.375) * CFrame.Angles(0.17453292519943295, 0, 0), "energypistols_equip", "energypistols_idle", "energypistols_sprint", "energypistols_inspect", nil, {
    ["Shoot1"] = "energypistols_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = nil,
    ["EmptyReload"] = nil
})
v72("Hacker Pistols", "rbxassetid://140621407555872", "rbxassetid://105705939354438", nil, nil, nil, CFrame.new(0, -0.375, -0.375) * CFrame.Angles(0.17453292519943295, 0, 0), "energypistols_equip", "energypistols_idle", "energypistols_sprint", "energypistols_inspect", nil, {
    ["Shoot1"] = "energypistols_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = nil,
    ["EmptyReload"] = nil
})
v72("Apex Pistols", "rbxassetid://136156057859453", "rbxassetid://132394469151873", nil, nil, nil, CFrame.new(0, -0.375, -0.375) * CFrame.Angles(0.17453292519943295, 0, 0), "energypistols_equip", "energypistols_idle", "energypistols_sprint", "energypistols_inspect", nil, {
    ["Shoot1"] = "energypistols_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = nil,
    ["EmptyReload"] = nil
})
v72("New Year Energy Pistols", "rbxassetid://126589959779039", "rbxassetid://88240834599421", nil, nil, nil, CFrame.new(0, -0.375, -0.375) * CFrame.Angles(0.17453292519943295, 0, 0), "energypistols_equip", "energypistols_idle", "energypistols_sprint", "energypistols_inspect", nil, {
    ["Shoot1"] = "energypistols_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = nil,
    ["EmptyReload"] = nil
})
v72("Void Pistols", "rbxassetid://111278471262300", "rbxassetid://114821885011907", nil, nil, nil, CFrame.new(0, -0.375, -0.375) * CFrame.Angles(0.17453292519943295, 0, 0), "energypistols_voidpistols_equip", "energypistols_idle", "energypistols_sprint", "energypistols_voidpistols_inspect", nil, {
    ["Shoot1"] = "energypistols_voidpistols_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = nil,
    ["EmptyReload"] = nil
})
v72("Hydro Pistols", "rbxassetid://115281889984097", "rbxassetid://102390688726302", nil, nil, nil, CFrame.new(0, -0.375, -0.375) * CFrame.Angles(0.17453292519943295, 0, 0), "energypistols_equip", "energypistols_idle", "energypistols_sprint", "energypistols_inspect", nil, {
    ["Shoot1"] = "energypistols_hydropistols_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = nil,
    ["EmptyReload"] = nil
})
v72("Glorious Energy Pistols", "rbxassetid://114418789647547", "rbxassetid://85080210873739", nil, nil, nil, CFrame.new(0, -0.375, -0.375) * CFrame.Angles(0.17453292519943295, 0, 0), "energypistols_equip", "energypistols_idle", "energypistols_sprint", "energypistols_inspect", nil, {
    ["Shoot1"] = "energypistols_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = nil,
    ["EmptyReload"] = nil
})
v72("Soul Pistols", "rbxassetid://72213738067158", "rbxassetid://95359207769282", nil, nil, nil, CFrame.new(0, -0.375, -0.375) * CFrame.Angles(0.17453292519943295, 0, 0), "energypistols_soulpistols_equip", "energypistols_idle", "energypistols_sprint", "energypistols_inspect", nil, {
    ["Shoot1"] = "energypistols_soulpistols_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = nil,
    ["EmptyReload"] = nil
})
v72("Energy Rifle", "rbxassetid://110259279810005", "rbxassetid://103736834693278", nil, "rbxassetid://129961481216137", 2.5, CFrame.new(0, -0.125, -0.125), "energyrifle_equip", "energyrifle_idle", "energyrifle_sprint", "energyrifle_inspect", nil, {
    ["Shoot1"] = "energyrifle_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = nil,
    ["EmptyReload"] = nil
})
v72("Hacker Rifle", "rbxassetid://122816271917525", "rbxassetid://89213922790170", nil, nil, nil, CFrame.new(0, -0.125, -0.125), "energyrifle_equip", "energyrifle_idle", "energyrifle_sprint", "energyrifle_inspect", nil, {
    ["Shoot1"] = "energyrifle_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = nil,
    ["EmptyReload"] = nil
})
v72("Apex Rifle", "rbxassetid://88144772234151", "rbxassetid://111748806401551", nil, nil, nil, CFrame.new(0, -0.125, -0.125), "energyrifle_equip", "energyrifle_idle", "energyrifle_sprint", "energyrifle_inspect", nil, {
    ["Shoot1"] = "energyrifle_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = nil,
    ["EmptyReload"] = nil
})
v72("New Year Energy Rifle", "rbxassetid://111446782522703", "rbxassetid://101868484686291", nil, nil, nil, CFrame.new(0, -0.125, -0.125), "energyrifle_equip", "energyrifle_idle", "energyrifle_sprint", "energyrifle_inspect", nil, {
    ["Shoot1"] = "energyrifle_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = nil,
    ["EmptyReload"] = nil
})
v72("Hydro Rifle", "rbxassetid://73690448730060", "rbxassetid://101984348353475", nil, nil, nil, CFrame.new(0, -0.125, -0.125), "energyrifle_equip", "energyrifle_idle", "energyrifle_sprint", "energyrifle_inspect", nil, {
    ["Shoot1"] = "energyrifle_hydrorifle_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = nil,
    ["EmptyReload"] = nil
})
v72("Void Rifle", "rbxassetid://95985016411441", "rbxassetid://107749233395884", nil, nil, nil, CFrame.new(0, -0.125, -0.125), "energyrifle_voidrifle_equip", "energyrifle_idle", "energyrifle_sprint", "energyrifle_inspect", nil, {
    ["Shoot1"] = "energyrifle_voidrifle_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = nil,
    ["EmptyReload"] = nil
})
v72("Glorious Energy Rifle", "rbxassetid://72632815443247", "rbxassetid://95552510838071", nil, nil, nil, CFrame.new(0, -0.125, -0.125), "energyrifle_equip", "energyrifle_idle", "energyrifle_sprint", "energyrifle_inspect", nil, {
    ["Shoot1"] = "energyrifle_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = nil,
    ["EmptyReload"] = nil
})
v72("Soul Rifle", "rbxassetid://129351366788323", "rbxassetid://140115840236565", nil, nil, nil, CFrame.new(0, -0.125, -0.125), "energyrifle_soulrifle_equip", "energyrifle_idle", "energyrifle_sprint", "energyrifle_inspect", nil, {
    ["Shoot1"] = "energyrifle_soulrifle_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = nil,
    ["EmptyReload"] = nil
})
v72("Spray", "rbxassetid://92882887485248", "rbxassetid://87291726953666", nil, "rbxassetid://100057833634628", 2.25, CFrame.new(0, -0.2, -0.15), "spray_equip", "spray_idle", "spray_sprint", "spray_inspect", nil, {
    ["Shoot1"] = "spray_shoot1",
    ["FinalShoot"] = "spray_shoot_final",
    ["Reload"] = "spray_reload",
    ["EmptyReload"] = "spray_reload_empty"
})
v72("Lovely Spray", "rbxassetid://131203015026683", "rbxassetid://138177960576401", nil, nil, nil, CFrame.new(0, -0.2, -0.3), "spray_equip", "spray_idle", "spray_sprint", "spray_inspect", nil, {
    ["Shoot1"] = "spray_shoot1",
    ["FinalShoot"] = "spray_shoot_final",
    ["Reload"] = "spray_reload",
    ["EmptyReload"] = "spray_reload_empty"
})
v72("Pine Spray", "rbxassetid://128285758736343", "rbxassetid://79010014206302", nil, nil, nil, CFrame.new(0, -0.2, -0.3), "spray_equip", "spray_idle", "spray_sprint", "spray_inspect", nil, {
    ["Shoot1"] = "spray_shoot1",
    ["FinalShoot"] = "spray_shoot_final",
    ["Reload"] = "spray_reload",
    ["EmptyReload"] = "spray_reload_empty"
})
v72("Nail Gun", "rbxassetid://110577809934251", "rbxassetid://79527532659144", nil, nil, nil, CFrame.new(0.125, -0.2, -0.15), "spray_equip", "spray_idle", "spray_sprint", "spray_inspect", nil, {
    ["Shoot1"] = "spray_nailgun_shoot1",
    ["FinalShoot"] = "spray_nailgun_shoot_final",
    ["Reload"] = "spray_reload",
    ["EmptyReload"] = "spray_nailgun_reload_empty"
})
v72("Spray Bottle", "rbxassetid://137955019285700", "rbxassetid://88384629194597", nil, nil, nil, CFrame.new(0, -0.2, -0.15), "spray_spraybottle_equip", "spray_idle", "spray_sprint", "spray_inspect", nil, {
    ["Shoot1"] = "spray_spraybottle_shoot1",
    ["FinalShoot"] = "spray_spraybottle_shoot_final",
    ["Reload"] = "spray_spraybottle_reload",
    ["EmptyReload"] = "spray_spraybottle_reload_empty"
})
v72("Glorious Spray", "rbxassetid://138246745001490", "rbxassetid://103484739840527", nil, nil, nil, CFrame.new(0, -0.2, -0.15), "spray_equip", "spray_idle", "spray_sprint", "spray_inspect", nil, {
    ["Shoot1"] = "spray_shoot1",
    ["FinalShoot"] = "spray_shoot_final",
    ["Reload"] = "spray_reload",
    ["EmptyReload"] = "spray_reload_empty"
})
v72("Boneclaw Spray", "rbxassetid://114078818081911", "rbxassetid://127336875478381", nil, nil, nil, CFrame.new(0, -0.2, -0.15), "spray_equip", "spray_idle", "spray_sprint", "spray_inspect", nil, {
    ["Shoot1"] = "spray_boneclawspray_shoot1",
    ["FinalShoot"] = "spray_boneclawspray_shoot_final",
    ["Reload"] = "spray_reload",
    ["EmptyReload"] = "spray_reload_empty"
})
v72("Crossbow", "rbxassetid://140211832612284", "rbxassetid://130065160832422", nil, "rbxassetid://120023204894177", 3, CFrame.new(0.25, -0.375, -0.125) * CFrame.Angles(0.08726646259971647, 0, 0), "crossbow_equip", "crossbow_idle", "crossbow_sprint", "crossbow_inspect", nil, {
    ["Shoot1"] = "crossbow_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "crossbow_reload",
    ["EmptyReload"] = nil
})
v72("Pixel Crossbow", "rbxassetid://115931961841903", "rbxassetid://129836248906904", nil, nil, nil, CFrame.new(0.25, -0.375, -0.125) * CFrame.Angles(0.08726646259971647, 0, 0), "crossbow_pixelcrossbow_equip", "crossbow_pixelcrossbow_idle", "crossbow_pixelcrossbow_sprint", "crossbow_pixelcrossbow_inspect", nil, {
    ["Shoot1"] = "crossbow_pixelcrossbow_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "crossbow_pixelcrossbow_reload",
    ["EmptyReload"] = nil
}, {
    ["FramesPerSecond"] = 2,
    ["PlayAnimationsInstantly"] = true
})
v72("Frostbite Crossbow", "rbxassetid://101536997945363", "rbxassetid://116171878456521", nil, nil, nil, CFrame.new(0.25, -0.375, -0.125) * CFrame.Angles(0.08726646259971647, 0, 0), "crossbow_frostbitecrossbow_equip", "crossbow_idle", "crossbow_sprint", "crossbow_inspect", nil, {
    ["Shoot1"] = "crossbow_frostbitecrossbow_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "crossbow_frostbitecrossbow_reload",
    ["EmptyReload"] = nil
})
v72("Harpoon Crossbow", "rbxassetid://107460405492001", "rbxassetid://127546301627893", nil, nil, nil, CFrame.new(0.25, -0.375, -0.125) * CFrame.Angles(0.08726646259971647, 0, 0), "crossbow_harpooncrossbow_equip", "crossbow_harpooncrossbow_idle", "crossbow_harpooncrossbow_sprint", "crossbow_harpooncrossbow_inspect", nil, {
    ["Shoot1"] = "crossbow_harpooncrossbow_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "crossbow_harpooncrossbow_reload",
    ["EmptyReload"] = nil
})
v72("Violin Crossbow", "rbxassetid://74401302514014", "rbxassetid://119666131999240", nil, nil, nil, CFrame.new(0.25, -0.5, -0.125) * CFrame.Angles(0.08726646259971647, 0, 0), "crossbow_equip", "crossbow_violincrossbow_idle", "crossbow_sprint", "crossbow_inspect", "crossbow_violincrossbow_inspect_rare", {
    ["Shoot1"] = "crossbow_violincrossbow_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "crossbow_violincrossbow_reload",
    ["EmptyReload"] = nil
})
v72("Glorious Crossbow", "rbxassetid://70875146419725", "rbxassetid://125494419498405", nil, nil, nil, CFrame.new(0.25, -0.375, -0.125) * CFrame.Angles(0.08726646259971647, 0, 0), "crossbow_equip", "crossbow_idle", "crossbow_sprint", "crossbow_inspect", nil, {
    ["Shoot1"] = "crossbow_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "crossbow_reload",
    ["EmptyReload"] = nil
})
v72("Crossbone", "rbxassetid://103469183638638", "rbxassetid://81476287380261", nil, nil, nil, CFrame.new(0.25, -0.375, -0.125) * CFrame.Angles(0.08726646259971647, 0, 0), "crossbow_equip", "crossbow_idle", "crossbow_sprint", "crossbow_inspect", nil, {
    ["Shoot1"] = "crossbow_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "crossbow_reload",
    ["EmptyReload"] = nil
})
v72("Arch Crossbow", "rbxassetid://94981733362451", "rbxassetid://107213949119266", nil, nil, nil, CFrame.new(-0.125, 0.125, -0.875) * CFrame.Angles(-0.04363323129985824, 0, 0), "crossbow_archcrossbow_equip", "crossbow_archcrossbow_idle", "crossbow_archcrossbow_sprint", "crossbow_archcrossbow_inspect", nil, {
    ["Shoot1"] = "crossbow_archcrossbow_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "crossbow_archcrossbow_reload",
    ["EmptyReload"] = nil,
    ["InspectEmpty"] = "crossbow_archcrossbow_inspect_empty"
})
v72("Gunblade", "rbxassetid://131231034374465", "rbxassetid://131462750179690", nil, "rbxassetid://79528657538147", 3, CFrame.new(0.125, 0, 0) * CFrame.Angles(0, 0.04363323129985824, 0), "gunblade_equip", "gunblade_idle", "gunblade_sprint", "gunblade_inspect", nil, {
    ["Shoot1"] = "gunblade_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = nil,
    ["EmptyReload"] = nil,
    ["ToBlade"] = "gunblade_to_blade",
    ["BladeEquip"] = "gunblade_equip_blade",
    ["BladeIdle"] = "gunblade_idle_blade",
    ["BladeSprint"] = "gunblade_sprint_blade",
    ["BladeInspect"] = "gunblade_inspect_blade",
    ["BladeAttack1"] = "gunblade_attack1_blade",
    ["BladeAttack2"] = "gunblade_attack2_blade",
    ["BladeAttackOnHit"] = "gunblade_attack_blade_onhit",
    ["ToGun1"] = "gunblade_to_gun",
    ["ToGun2"] = "gunblade_to_gun2"
})
v72("Hyper Gunblade", "rbxassetid://134415898983004", "rbxassetid://134499903901922", nil, nil, nil, CFrame.new(0.125, 0, 0) * CFrame.Angles(0, 0.04363323129985824, 0), "gunblade_equip", "gunblade_idle", "gunblade_sprint", "gunblade_inspect", nil, {
    ["Shoot1"] = "gunblade_hypergunblade_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = nil,
    ["EmptyReload"] = nil,
    ["ToBlade"] = "gunblade_to_blade",
    ["BladeEquip"] = "gunblade_equip_blade",
    ["BladeIdle"] = "gunblade_idle_blade",
    ["BladeSprint"] = "gunblade_sprint_blade",
    ["BladeInspect"] = "gunblade_inspect_blade",
    ["BladeAttack1"] = "gunblade_hypergunblade_attack1_blade",
    ["BladeAttack2"] = "gunblade_hypergunblade_attack2_blade",
    ["BladeAttackOnHit"] = "gunblade_hypergunblade_attack_blade_onhit",
    ["ToGun1"] = "gunblade_to_gun",
    ["ToGun2"] = "gunblade_to_gun2"
})
v72("Elf\'s Gunblade", "rbxassetid://114103306647123", "rbxassetid://81214817732179", nil, nil, nil, CFrame.new(0.125, 0, 0) * CFrame.Angles(0, 0.04363323129985824, 0), "gunblade_equip", "gunblade_idle", "gunblade_sprint", "gunblade_inspect", nil, {
    ["Shoot1"] = "gunblade_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = nil,
    ["EmptyReload"] = nil,
    ["ToBlade"] = "gunblade_to_blade",
    ["BladeEquip"] = "gunblade_equip_blade",
    ["BladeIdle"] = "gunblade_idle_blade",
    ["BladeSprint"] = "gunblade_sprint_blade",
    ["BladeInspect"] = "gunblade_inspect_blade",
    ["BladeAttack1"] = "gunblade_attack1_blade",
    ["BladeAttack2"] = "gunblade_attack2_blade",
    ["BladeAttackOnHit"] = "gunblade_attack_blade_onhit",
    ["ToGun1"] = "gunblade_to_gun",
    ["ToGun2"] = "gunblade_to_gun2"
})
v72("Crude Gunblade", "rbxassetid://126996645502136", "rbxassetid://111573250598753", nil, nil, nil, CFrame.new(0.125, 0, 0) * CFrame.Angles(0, 0.04363323129985824, 0), "gunblade_equip", "gunblade_idle", "gunblade_sprint", "gunblade_inspect", nil, {
    ["Shoot1"] = "gunblade_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = nil,
    ["EmptyReload"] = nil,
    ["ToBlade"] = "gunblade_to_blade",
    ["BladeEquip"] = "gunblade_equip_blade",
    ["BladeIdle"] = "gunblade_idle_blade",
    ["BladeSprint"] = "gunblade_sprint_blade",
    ["BladeInspect"] = "gunblade_inspect_blade",
    ["BladeAttack1"] = "gunblade_attack1_blade",
    ["BladeAttack2"] = "gunblade_attack2_blade",
    ["BladeAttackOnHit"] = "gunblade_attack_blade_onhit",
    ["ToGun1"] = "gunblade_to_gun",
    ["ToGun2"] = "gunblade_to_gun2"
})
v72("Gunsaw", "rbxassetid://102700915422689", "rbxassetid://136642950174663", nil, nil, nil, CFrame.new(0.125, 0, 0) * CFrame.Angles(0, 0.04363323129985824, 0), "gunblade_gunsaw_equip", "gunblade_gunsaw_idle", "gunblade_gunsaw_sprint", "gunblade_gunsaw_inspect", nil, {
    ["Shoot1"] = "gunblade_gunsaw_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = nil,
    ["EmptyReload"] = nil,
    ["ToBlade"] = "gunblade_gunsaw_to_blade",
    ["BladeEquip"] = "gunblade_gunsaw_equip_blade",
    ["BladeIdle"] = "gunblade_gunsaw_idle_blade",
    ["BladeSprint"] = "gunblade_gunsaw_sprint_blade",
    ["BladeInspect"] = "gunblade_gunsaw_inspect_blade",
    ["BladeAttack1"] = "gunblade_gunsaw_attack1_blade",
    ["BladeAttack2"] = "gunblade_gunsaw_attack2_blade",
    ["BladeAttackOnHit"] = "gunblade_gunsaw_attack_blade_onhit",
    ["ToGun1"] = "gunblade_gunsaw_to_gun",
    ["ToGun2"] = "gunblade_gunsaw_to_gun2"
})
v72("Glorious Gunblade", "rbxassetid://88003799126136", "rbxassetid://88582922101753", nil, nil, nil, CFrame.new(0.125, 0, 0) * CFrame.Angles(0, 0.04363323129985824, 0), "gunblade_equip", "gunblade_idle", "gunblade_sprint", "gunblade_inspect", nil, {
    ["Shoot1"] = "gunblade_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = nil,
    ["EmptyReload"] = nil,
    ["ToBlade"] = "gunblade_to_blade",
    ["BladeEquip"] = "gunblade_equip_blade",
    ["BladeIdle"] = "gunblade_idle_blade",
    ["BladeSprint"] = "gunblade_sprint_blade",
    ["BladeInspect"] = "gunblade_inspect_blade",
    ["BladeAttack1"] = "gunblade_attack1_blade",
    ["BladeAttack2"] = "gunblade_attack2_blade",
    ["BladeAttackOnHit"] = "gunblade_attack_blade_onhit",
    ["ToGun1"] = "gunblade_to_gun",
    ["ToGun2"] = "gunblade_to_gun2"
})
v72("Boneblade", "rbxassetid://126327381608481", "rbxassetid://126287813768518", nil, nil, nil, CFrame.new(0.125, 0, 0) * CFrame.Angles(0, 0.04363323129985824, 0), "gunblade_equip", "gunblade_idle", "gunblade_sprint", "gunblade_inspect", nil, {
    ["Shoot1"] = "gunblade_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = nil,
    ["EmptyReload"] = nil,
    ["ToBlade"] = "gunblade_to_blade",
    ["BladeEquip"] = "gunblade_equip_blade",
    ["BladeIdle"] = "gunblade_idle_blade",
    ["BladeSprint"] = "gunblade_sprint_blade",
    ["BladeInspect"] = "gunblade_inspect_blade",
    ["BladeAttack1"] = "gunblade_attack1_blade",
    ["BladeAttack2"] = "gunblade_attack2_blade",
    ["BladeAttackOnHit"] = "gunblade_attack_blade_onhit",
    ["ToGun1"] = "gunblade_to_gun",
    ["ToGun2"] = "gunblade_to_gun2"
})
v72("Jump Pad", "rbxassetid://79459600453621", "rbxassetid://102532564314723", nil, "rbxassetid://113965546523164", 1.5, nil, "jumppad_equip", "jumppad_idle", "jumppad_sprint", "jumppad_inspect", nil, {
    ["Use"] = "jumppad_use"
})
v72("Trampoline", "rbxassetid://103567857194140", "rbxassetid://92310435035049", nil, nil, nil, nil, "jumppad_equip", "jumppad_idle", "jumppad_sprint", "jumppad_inspect", nil, {
    ["Use"] = "jumppad_use"
})
v72("Bounce House", "rbxassetid://71226436012588", "rbxassetid://79326657484315", nil, nil, nil, nil, "jumppad_equip", "jumppad_idle", "jumppad_sprint", "jumppad_inspect", nil, {
    ["Use"] = "jumppad_use"
})
v72("Shady Chicken Sandwich", "rbxassetid://86361684164972", "rbxassetid://113753042073837", nil, nil, nil, nil, "jumppad_equip", "jumppad_idle", "jumppad_sprint", "jumppad_inspect", nil, {
    ["Use"] = "jumppad_use"
})
v72("Glorious Jump Pad", "rbxassetid://71803398862947", "rbxassetid://96408475917789", nil, nil, nil, nil, "jumppad_equip", "jumppad_idle", "jumppad_sprint", "jumppad_inspect", nil, {
    ["Use"] = "jumppad_use"
})
v72("Spider Web", "rbxassetid://84204578032332", "rbxassetid://133104747106136", nil, nil, nil, nil, "jumppad_equip", "jumppad_idle", "jumppad_sprint", "jumppad_inspect", nil, {
    ["Use"] = "jumppad_use"
})
v72("Jolly Man", "rbxassetid://97375473537804", "rbxassetid://98002300428288", nil, nil, nil, nil, "jumppad_equip", "jumppad_idle", "jumppad_sprint", "jumppad_inspect", nil, {
    ["Use"] = "jumppad_use"
})
v72("Scepter", "rbxassetid://99183402177823", "rbxassetid://89220212871603", nil, "rbxassetid://102084909464865", 3, nil, "scepter_equip", "scepter_idle", "scepter_sprint", "scepter_inspect", nil, {
    ["Shoot1"] = "scepter_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = nil,
    ["EmptyReload"] = nil
})
v72("Elixir", "rbxassetid://123677194704684", "rbxassetid://96734141776078", nil, "rbxassetid://106686303136827", 1, nil, "elixir_equip", "grenade_idle", "grenade_sprint", "grenade_inspect", nil, {
    ["ThrowStart"] = "grenade_throw_start",
    ["ThrowIdle"] = "grenade_throw_idle",
    ["ThrowFinish"] = "grenade_throw_finish",
    ["LobStart"] = "grenade_lob_start",
    ["LobIdle"] = "grenade_lob_idle",
    ["LobFinish"] = "grenade_lob_finish"
})
v72("Glass Cannon", "rbxassetid://138882843694218", "rbxassetid://82999887306387", nil, "rbxassetid://109359544961471", 1.5, CFrame.new(0, -0.125, -0.2), "glasscannon_equip", "glasscannon_idle", "glasscannon_sprint", "glasscannon_inspect", nil, {
    ["Shoot1"] = "glasscannon_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = nil,
    ["EmptyReload"] = nil,
    ["EmptyEquip"] = "fists_equip",
    ["EmptyIdle"] = "fists_idle",
    ["EmptySprint"] = "fists_sprint",
    ["EmptyInspect"] = "fists_inspect"
})
v72("Glast Shard", "rbxassetid://102980815872652", "rbxassetid://136181940429732", nil, "rbxassetid://89682549635116", 2, nil, "knife_karambit_equip", "knife_karambit_idle", "knife_karambit_sprint", "knife_karambit_inspect", nil, {
    ["Attack1"] = "knife_karambit_attack1",
    ["Attack2"] = "knife_karambit_attack2",
    ["HeavyAttack1"] = "knife_karambit_heavyattack1",
    ["HeavyAttackAnimationHit"] = "knife_karambit_heavyattack_hit"
})
v72("RNG Dice", "rbxassetid://98372867049331", "rbxassetid://75601061529918", nil, "rbxassetid://86815994192766", 1.5, nil, "rngdice_equip", "rngdice_idle", "rngdice_sprint", "rngdice_inspect", nil, {
    ["Use"] = "rngdice_use"
})
v72("Distortion", "rbxassetid://115712150398379", "rbxassetid://130153907701944", nil, "rbxassetid://136813016262803", 2.5, CFrame.new(0, -0, -0.375) * CFrame.Angles(0.04363323129985824, 0, 0), "distortion_equip", "distortion_idle", "distortion_sprint", "distortion_inspect", nil, {
    ["Shoot1"] = "distortion_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = nil,
    ["EmptyReload"] = nil
})
v72("Glorious Distortion", "rbxassetid://134722661973710", "rbxassetid://107736694179886", nil, nil, nil, CFrame.new(0, -0, -0.375) * CFrame.Angles(0.04363323129985824, 0, 0), "distortion_equip", "distortion_idle", "distortion_sprint", "distortion_inspect", nil, {
    ["Shoot1"] = "distortion_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = nil,
    ["EmptyReload"] = nil
})
v72("Electropunk Distortion", "rbxassetid://109544539643046", "rbxassetid://91778033503945", nil, nil, nil, CFrame.new(0, -0, -0.375) * CFrame.Angles(0.04363323129985824, 0, 0), "distortion_equip", "distortion_idle", "distortion_sprint", "distortion_inspect2", nil, {
    ["Shoot1"] = "distortion_electropunkdistortion_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = nil,
    ["EmptyReload"] = nil
})
v72("Experiment D15", "rbxassetid://103446773933340", "rbxassetid://118366946179457", nil, nil, nil, CFrame.new(0, -0, -0.375) * CFrame.Angles(0.04363323129985824, 0, 0), "distortion_equip", "distortion_idle", "distortion_sprint", "distortion_inspect", nil, {
    ["Shoot1"] = "distortion_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = nil,
    ["EmptyReload"] = nil
})
v72("Plasma Distortion", "rbxassetid://126813935337091", "rbxassetid://83622093873798", nil, nil, nil, CFrame.new(0, -0, -0.375) * CFrame.Angles(0.04363323129985824, 0, 0), "distortion_equip", "distortion_idle", "distortion_sprint", "distortion_inspect2", nil, {
    ["Shoot1"] = "distortion_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = nil,
    ["EmptyReload"] = nil
})
v72("Magma Distortion", "rbxassetid://81103807698156", "rbxassetid://109079139956898", nil, nil, nil, CFrame.new(0, -0, -0.375) * CFrame.Angles(0.04363323129985824, 0, 0), "distortion_equip", "distortion_idle", "distortion_sprint", "distortion_inspect", nil, {
    ["Shoot1"] = "distortion_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = nil,
    ["EmptyReload"] = nil
})
v72("Cyber Distortion", "rbxassetid://88995062151276", "rbxassetid://78940266607471", nil, nil, nil, CFrame.new(0, -0, -0.375) * CFrame.Angles(0.04363323129985824, 0, 0), "distortion_equip", "distortion_idle", "distortion_sprint", "distortion_inspect", nil, {
    ["Shoot1"] = "distortion_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = nil,
    ["EmptyReload"] = nil
})
v72("Sleighstortion", "rbxassetid://111242141481650", "rbxassetid://113075083434001", nil, nil, nil, CFrame.new(0, -0, -0.375) * CFrame.Angles(0.04363323129985824, 0, 0), "distortion_equip", "distortion_idle", "distortion_sprint", "distortion_inspect", nil, {
    ["Shoot1"] = "distortion_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = nil,
    ["EmptyReload"] = nil
})
v72("Warper", "rbxassetid://88033795039891", "rbxassetid://97537499062821", nil, "rbxassetid://131943126657510", 2, CFrame.new(0, -0.125, -0.375) * CFrame.Angles(0.08726646259971647, 0, 0), "warper_equip", "warper_idle", "warper_sprint", "warper_inspect", nil, {
    ["Shoot1"] = "warper_shoot1"
})
v72("Glorious Warper", "rbxassetid://95823647035211", "rbxassetid://117284572803988", nil, nil, nil, CFrame.new(0, -0.125, -0.375) * CFrame.Angles(0.08726646259971647, 0, 0), "warper_equip", "warper_idle", "warper_sprint", "warper_inspect", nil, {
    ["Shoot1"] = "warper_shoot1"
})
v72("Electropunk Warper", "rbxassetid://75386728379756", "rbxassetid://96080679722284", nil, nil, nil, CFrame.new(0, -0.125, -0.375) * CFrame.Angles(0.08726646259971647, 0, 0), "warper_equip", "warper_idle", "warper_sprint", "warper_inspect", nil, {
    ["Shoot1"] = "warper_electropunkwarper_shoot1"
})
v72("Experiment W4", "rbxassetid://126884960764998", "rbxassetid://77873591123909", nil, nil, nil, CFrame.new(0, -0.125, -0.375) * CFrame.Angles(0.08726646259971647, 0, 0), "warper_equip", "warper_idle", "warper_sprint", "warper_inspect", nil, {
    ["Shoot1"] = "warper_shoot1"
})
v72("Glitter Warper", "rbxassetid://94607497565715", "rbxassetid://128289126916762", nil, nil, nil, CFrame.new(0, -0.125, -0.375) * CFrame.Angles(0.08726646259971647, 0, 0), "warper_equip", "warper_idle", "warper_sprint", "warper_inspect", nil, {
    ["Shoot1"] = "warper_shoot1"
})
v72("Arcane Warper", "rbxassetid://83632373572638", "rbxassetid://92765478127490", nil, nil, nil, CFrame.new(0, 0, -0.375) * CFrame.Angles(0.08726646259971647, 0, 0), "warper_arcanewarper_equip", "warper_arcanewarper_idle", "warper_arcanewarper_sprint", "warper_arcanewarper_inspect", nil, {
    ["Shoot1"] = "warper_arcanewarper_shoot1"
})
v72("Hotel Bell", "rbxassetid://117742703173821", "rbxassetid://74303585805484", nil, nil, nil, CFrame.new(0, -0.125, -0.375) * CFrame.Angles(0.08726646259971647, 0, 0), "warper_hotelbell_equip", "warper_hotelbell_idle", "warper_hotelbell_sprint", "warper_hotelbell_inspect", nil, {
    ["Shoot1"] = "warper_hotelbell_shoot1"
})
v72("Frost Warper", "rbxassetid://70539216094396", "rbxassetid://84458438183331", nil, nil, nil, CFrame.new(0, -0.125, -0.375) * CFrame.Angles(0.08726646259971647, 0, 0), "warper_equip", "warper_idle", "warper_sprint", "warper_inspect", nil, {
    ["Shoot1"] = "warper_shoot1"
})
v72("Warpstone", "rbxassetid://94035693279005", "rbxassetid://99660718217521", nil, "rbxassetid://114944189821030", 1.5, CFrame.new(0, -0.25, -0.375), "grenade_equip", "grenade_idle", "grenade_sprint", "grenade_inspect", nil, {
    ["ThrowStart"] = "grenade_throw_start",
    ["ThrowIdle"] = "grenade_throw_idle",
    ["ThrowFinish"] = "grenade_throw_finish",
    ["LobStart"] = "grenade_lob_start",
    ["LobIdle"] = "grenade_lob_idle",
    ["LobFinish"] = "grenade_lob_finish"
})
v72("Glorious Warpstone", "rbxassetid://137583560042806", "rbxassetid://99142505492556", nil, nil, nil, CFrame.new(0, -0.25, -0.375), "grenade_equip", "grenade_idle", "grenade_sprint", "grenade_inspect", nil, {
    ["ThrowStart"] = "grenade_throw_start",
    ["ThrowIdle"] = "grenade_throw_idle",
    ["ThrowFinish"] = "grenade_throw_finish",
    ["LobStart"] = "grenade_lob_start",
    ["LobIdle"] = "grenade_lob_idle",
    ["LobFinish"] = "grenade_lob_finish"
})
v72("Unstable Warpstone", "rbxassetid://110083777654388", "rbxassetid://71896071193185", nil, nil, nil, CFrame.new(0, -0.25, -0.375), "grenade_equip", "grenade_idle", "grenade_sprint", "grenade_inspect", nil, {
    ["ThrowStart"] = "grenade_throw_start",
    ["ThrowIdle"] = "grenade_throw_idle",
    ["ThrowFinish"] = "grenade_throw_finish",
    ["LobStart"] = "grenade_lob_start",
    ["LobIdle"] = "grenade_lob_idle",
    ["LobFinish"] = "grenade_lob_finish"
})
v72("Warpeye", "rbxassetid://127023603234857", "rbxassetid://129554679066276", nil, nil, nil, CFrame.new(0, -0.25, -0.375), "warpstone_warpeye_equip", "warpstone_warpeye_idle", "warpstone_warpeye_sprint", "warpstone_warpeye_inspect", nil, {
    ["ThrowStart"] = "warpstone_warpeye_throw_start",
    ["ThrowIdle"] = "warpstone_warpeye_throw_idle",
    ["ThrowFinish"] = "warpstone_warpeye_throw_finish",
    ["LobStart"] = "warpstone_warpeye_lob_start",
    ["LobIdle"] = "warpstone_warpeye_lob_idle",
    ["LobFinish"] = "warpstone_warpeye_lob_finish"
})
v72("Warpbone", "rbxassetid://96452209607150", "rbxassetid://132473085580193", nil, nil, nil, CFrame.new(0, -0.25, -0.375), "grenade_equip", "grenade_idle", "grenade_sprint", "grenade_inspect", nil, {
    ["ThrowStart"] = "grenade_throw_start",
    ["ThrowIdle"] = "grenade_throw_idle",
    ["ThrowFinish"] = "grenade_throw_finish",
    ["LobStart"] = "grenade_lob_start",
    ["LobIdle"] = "grenade_lob_idle",
    ["LobFinish"] = "grenade_lob_finish"
})
v72("Cyber Warpstone", "rbxassetid://133002984228937", "rbxassetid://78671282003316", nil, nil, nil, CFrame.new(0, -0.25, -0.375), "grenade_equip", "grenade_idle", "grenade_sprint", "grenade_inspect", nil, {
    ["ThrowStart"] = "grenade_throw_start",
    ["ThrowIdle"] = "grenade_throw_idle",
    ["ThrowFinish"] = "grenade_throw_finish",
    ["LobStart"] = "grenade_lob_start",
    ["LobIdle"] = "grenade_lob_idle",
    ["LobFinish"] = "grenade_lob_finish"
})
v72("Teleport Disc", "rbxassetid://104608154111107", "rbxassetid://81728761431901", nil, nil, nil, CFrame.new(0, -0.125, -0.375), "warpstone_teleportdisc_equip", "warpstone_teleportdisc_idle", "warpstone_teleportdisc_sprint", "warpstone_teleportdisc_inspect", nil, {
    ["ThrowStart"] = "warpstone_teleportdisc_throw_start",
    ["ThrowIdle"] = "warpstone_teleportdisc_throw_idle",
    ["ThrowFinish"] = "warpstone_teleportdisc_throw_finish",
    ["LobStart"] = "warpstone_teleportdisc_lob_start",
    ["LobIdle"] = "warpstone_teleportdisc_lob_idle",
    ["LobFinish"] = "warpstone_teleportdisc_lob_finish"
})
v72("Electropunk Warpstone", "rbxassetid://75299042976369", "rbxassetid://121167052087315", nil, nil, nil, CFrame.new(0, -0.25, -0.375), "grenade_equip", "grenade_idle", "grenade_sprint", "grenade_inspect", nil, {
    ["ThrowStart"] = "grenade_throw_start",
    ["ThrowIdle"] = "grenade_throw_idle",
    ["ThrowFinish"] = "grenade_throw_finish",
    ["LobStart"] = "grenade_lob_start",
    ["LobIdle"] = "grenade_lob_idle",
    ["LobFinish"] = "grenade_lob_finish"
})
v72("Warpstar", "rbxassetid://102652397897598", "rbxassetid://85728240647371", nil, nil, nil, CFrame.new(0, -0.25, -0.375), "warpstone_warpstar_equip", "warpstone_warpstar_idle", "warpstone_warpstar_sprint", "warpstone_warpstar_inspect", nil, {
    ["ThrowStart"] = "warpstone_warpstar_throw_start",
    ["ThrowIdle"] = "warpstone_warpstar_throw_idle",
    ["ThrowFinish"] = "warpstone_warpstar_throw_finish",
    ["LobStart"] = "warpstone_warpstar_lob_start",
    ["LobIdle"] = "warpstone_warpstar_lob_idle",
    ["LobFinish"] = "warpstone_warpstar_lob_finish"
})
v72("Maul", "rbxassetid://81478141693597", "rbxassetid://96956174894354", nil, "rbxassetid://92986282671073", 2, nil, "maul_equip", "maul_idle", "maul_sprint", "maul_inspect", nil, {
    ["Attack1"] = "maul_attack1",
    ["Attack2"] = "maul_attack2",
    ["ChargeIntro"] = "maul_charge_intro",
    ["ChargeLoop"] = "maul_charge_loop",
    ["ChargeOutro"] = "maul_charge_outro"
})
v72("Sleigh Maul", "rbxassetid://114892026951995", "rbxassetid://112835874307935", nil, nil, nil, nil, "maul_equip", "maul_idle", "maul_sprint", "maul_inspect", nil, {
    ["Attack1"] = "maul_sleighmaul_attack1",
    ["Attack2"] = "maul_sleighmaul_attack2",
    ["ChargeIntro"] = "maul_charge_intro",
    ["ChargeLoop"] = "maul_charge_loop",
    ["ChargeOutro"] = "maul_sleighmaul_charge_outro"
})
v72("Ice Maul", "rbxassetid://100001888078290", "rbxassetid://79987597452893", nil, nil, nil, nil, "maul_equip", "maul_idle", "maul_sprint", "maul_inspect", nil, {
    ["Attack1"] = "maul_attack1",
    ["Attack2"] = "maul_attack2",
    ["ChargeIntro"] = "maul_charge_intro",
    ["ChargeLoop"] = "maul_charge_loop",
    ["ChargeOutro"] = "maul_charge_outro"
})
v72("Glorious Maul", "rbxassetid://125917253783002", "rbxassetid://109898315901573", nil, nil, nil, nil, "maul_equip", "maul_idle", "maul_sprint", "maul_inspect", nil, {
    ["Attack1"] = "maul_attack1",
    ["Attack2"] = "maul_attack2",
    ["ChargeIntro"] = "maul_charge_intro",
    ["ChargeLoop"] = "maul_charge_loop",
    ["ChargeOutro"] = "maul_charge_outro"
})
v72("Permafrost", "rbxassetid://74353733133888", "rbxassetid://78468628083590", nil, "rbxassetid://112007420940132", 2.25, CFrame.new(0, -0.125, -0.5), "permafrost_equip", "permafrost_idle", "permafrost_sprint", "permafrost_inspect", nil, {
    ["Shoot1"] = "permafrost_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "permafrost_reload",
    ["EmptyReload"] = nil,
    ["Throw"] = "permafrost_throw"
})
v72("Snowman Permafrost", "rbxassetid://100890626643184", "rbxassetid://70467865456788", nil, nil, nil, CFrame.new(0, -0.125, -0.5), "permafrost_equip", "permafrost_idle", "permafrost_sprint", "permafrost_inspect", nil, {
    ["Shoot1"] = "permafrost_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "permafrost_reload",
    ["EmptyReload"] = nil,
    ["Throw"] = "permafrost_throw"
})
v72("Ice Permafrost", "rbxassetid://83722160119335", "rbxassetid://122848886028890", nil, nil, nil, CFrame.new(0, -0.125, -0.5), "permafrost_equip", "permafrost_idle", "permafrost_sprint", "permafrost_inspect", nil, {
    ["Shoot1"] = "permafrost_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "permafrost_reload",
    ["EmptyReload"] = nil,
    ["Throw"] = "permafrost_throw"
})
v72("Glorious Permafrost", "rbxassetid://119977291442329", "rbxassetid://82134252571554", nil, nil, nil, CFrame.new(0, -0.125, -0.5), "permafrost_equip", "permafrost_idle", "permafrost_sprint", "permafrost_inspect", nil, {
    ["Shoot1"] = "permafrost_shoot1",
    ["FinalShoot"] = nil,
    ["Reload"] = "permafrost_reload",
    ["EmptyReload"] = nil,
    ["Throw"] = "permafrost_throw"
})
local function v_u_92(p73, p74, p75, p76, p77, p78, p79, p80, p81, p82, p83, p84, p85, p86, p87)
    local v88 = {
        ["Type"] = p73,
        ["Status"] = p74,
        ["Class"] = p75,
        ["Name"] = p76,
        ["Image"] = v_u_23.ViewModels[p76].Image,
        ["EquipCooldown"] = p77,
        ["CanEliminate"] = p78,
        ["WalkSpeedMultiplier"] = p79,
        ["MaxDoubleJumps"] = p80,
        ["CrosshairType"] = p81,
        ["MobileInputSettings"] = p82,
        ["QuickAttackInputs"] = p85,
        ["QuickAttackInputsEasy"] = p86 or p85,
        ["InputSpammingEnabled"] = {
            ["StartShooting"] = p83,
            ["StartAiming"] = p84,
            ["StartReloading"] = 0.5,
            ["StartInspecting"] = false
        }
    }
    for v89, v90 in pairs(p87 or {}) do
        v88[v89] = v90
    end
    v_u_23.Items[p76] = v88
    local v91 = v_u_23.ItemOrder
    table.insert(v91, p76)
    if v_u_2.IS_SERVER then
        if v_u_24[p76] then
            warn("[ITEM] Duplicate item name: " .. p76)
            return v88
        end
        v_u_24[p76] = true
    end
    return v88
end
local function v110(p93, p94, p95, p96, p97, p98, p99, p100, p101, p102, p103, p104, p105, p106)
    local v107 = {}
    for v108, v109 in pairs(p106 or {}) do
        v107[v108] = v109
    end
    v_u_92("Custom", p93, p94, p95, p96, p97, p98, p99, p100, p101, p102, p103, p104, p105, v107)
end
v110("Prime", "Utility", "Medkit", 0.9, false, 0.9, nil, "Default", {
    ["Inspect"] = false,
    ["Shoot"] = false,
    ["Aim"] = false
}, 0, 0, { "StartAiming" }, nil, {
    ["Cooldown"] = 90,
    ["LongHeal"] = 70,
    ["LongLength"] = 6,
    ["LongActionTimestamp"] = 5.25,
    ["QuickHeal"] = 25,
    ["QuickLength"] = 1,
    ["QuickActionTimestamp"] = 0.45
})
v110("Prime", "Utility", "Subspace Tripmine", 0.9, true, 1, nil, "Default", {
    ["Inspect"] = false,
    ["Shoot"] = false
}, 0, 0, { "StartShooting" }, nil, {
    ["Cooldown"] = 0.5,
    ["AmmoType"] = "Tripmine",
    ["MaxAmmo"] = 2,
    ["MaxReach"] = 3,
    ["HitboxDelay"] = 1,
    ["ExplosionRadius"] = 12,
    ["ExplosionDamage"] = 149,
    ["ExplosionKnockback"] = 1.5
})
v110("Prime", "Primary", "Flamethrower", 0.9, true, 0.95, nil, "Default", {
    ["Inspect"] = false,
    ["Shoot"] = false,
    ["Aim"] = false
}, 0, 0, { "StartAiming" }, nil, {
    ["AmmoType"] = "Fuel",
    ["DamagePerSecond"] = 85,
    ["DamageTicksPerSecond"] = 10,
    ["AfterburnDamage"] = 25,
    ["AfterburnDuration"] = 4,
    ["AfterburnTicks"] = 8,
    ["Reach"] = 26,
    ["MaxAmmo"] = 100,
    ["MaxAmmoReserve"] = 0,
    ["AirblastCooldown"] = 4,
    ["AirblastKnockback"] = 1.5,
    ["AirblastRecoilKnockback"] = 1.5
})
v110("Standard", "Utility", "War Horn", 0.4, false, 1, nil, "Default", {
    ["Inspect"] = false,
    ["Shoot"] = false,
    ["Aim"] = false
}, 0, 0, { "StartShooting" }, nil, {
    ["Cooldown"] = 45,
    ["SpeedBoost"] = 0.3,
    ["SpeedBoostDuration"] = 6,
    ["UseEndLag"] = 0.9
})
v110("Standard", "Utility", "Jump Pad", 0.9, false, 1, nil, "Default", {
    ["Inspect"] = false,
    ["Shoot"] = false
}, 0, 0, { "StartShooting" }, nil, {
    ["Cooldown"] = 0.5,
    ["Lifetime"] = 90,
    ["Strength"] = 1,
    ["AmmoType"] = "Jump Pad",
    ["MaxAmmo"] = 3,
    ["MaxReach"] = 32,
    ["HitboxSize"] = Vector3.new(11, 11, 2)
})
v110("Contraband", "Utility", "RNG Dice", 0.9, false, 1, nil, "Default", {
    ["Inspect"] = false,
    ["Shoot"] = false
}, 0, 0, { "StartShooting" }, nil, {
    ["RollDuration"] = 0.25,
    ["Cooldown"] = 3.75,
    ["MaxItems"] = 2
})
v110("Contraband", "Secondary", "Warper", 1, false, 1, nil, "Default", {
    ["Inspect"] = false,
    ["Shoot"] = false,
    ["Aim"] = false
}, 0, 0, { "StartAiming" }, nil, {
    ["ShootCooldown"] = 0.25,
    ["MaxPortalRange"] = 512,
    ["PortalDeadzone"] = 10,
    ["PortalDelayedSpawnThreshold"] = 64,
    ["PortalDelayedSpawnSecondsPerStud"] = 0.025
})
local function v135(p111, p112, p113, p114, p115, p116, p117, p118, p119, p120, p121, p122, p123, p124, _, p125, p126, p127, _, p128, p129)
    local v130 = {
        ["CriticalMultiplier"] = 2,
        ["UseEndLag"] = 0.25,
        ["DirectHitDamage"] = p119 or 0,
        ["Cooldown"] = p120,
        ["Lifetime"] = p121,
        ["MaxAmmo"] = p122,
        ["AmmoType"] = p122 and "Grenade" or nil,
        ["ThrowMaxChargeTime"] = p123,
        ["ThrowForceMin"] = p124,
        ["ThrowForceMax"] = p124,
        ["ThrowGravity"] = p125,
        ["LobMaxChargeTime"] = p126,
        ["LobForceMin"] = p127,
        ["LobForceMax"] = p127,
        ["LobGravity"] = p128
    }
    local v131 = {
        ["Inspect"] = false,
        ["Shoot"] = false,
        ["Aim"] = false
    }
    local v132 = { "StartShooting", "FinishShooting" }
    for v133, v134 in pairs(p129 or {}) do
        v130[v133] = v134
    end
    v_u_92("Throwable", p111, p112, p113, p114, p115, p116, p117, p118, v131, 0.1, 0.1, v132, nil, v130)
end
v135("Standard", "Utility", "Grenade", 0.85, true, 1, nil, "Default", 1, 30, 10, nil, 4, 100, 300, 0.375, 4, 50, 150, 0.75, {
    ["CanCook"] = true,
    ["DetonateDelay"] = 2,
    ["ExplosionRadius"] = 16,
    ["ExplosionDamage"] = 75,
    ["ExplosionKnockback"] = 1.5
})
v135("Standard", "Utility", "Molotov", 0.85, true, 1, nil, "Default", 1, 30, 10, nil, 4, 100, 300, 0.375, 4, 50, 150, 0.75, {
    ["FireRadius"] = 16,
    ["FireDuration"] = 7,
    ["SplashDamage"] = 10,
    ["DamagePerSecond"] = 25,
    ["DamageTicksPerSecond"] = 10,
    ["AfterburnDamage"] = 25,
    ["AfterburnDuration"] = 4,
    ["AfterburnTicks"] = 8
})
v135("Standard", "Utility", "Flashbang", 0.85, false, 1, nil, "Default", 1, 0.5, 10, 2, 4, 100, 300, 0.375, 4, 50, 150, 0.75, {
    ["DetonateDelay"] = 1.5,
    ["BlindDuration"] = 3
})
v135("Standard", "Utility", "Smoke Grenade", 0.85, false, 1, nil, "Default", 1, 0.5, 10, 3, 4, 100, 300, 0.375, 4, 50, 150, 0.75, {
    ["SmokeRadius"] = 24,
    ["SmokeDuration"] = 15
})
v135("Contraband", "Utility", "Elixir", 0.85, true, 1, nil, "Default", 1, 30, 10, nil, 4, 100, 300, 0.375, 4, 50, 150, 0.75, {
    ["SplashRadius"] = 16,
    ["Heal"] = 25,
    ["HealDuration"] = 4,
    ["Damage"] = 50,
    ["DamageDuration"] = 4
})
v135("Standard", "Utility", "Satchel", 0, true, 1, nil, "Default", nil, 0.5, 90, 3, 4, 100, 300, 0.375, 4, 50, 150, 0.75, {
    ["ExplosionRadius"] = 16,
    ["ExplosionDamage"] = 25,
    ["ExplosionKnockback"] = 1.5
})
v135("Prime", "Utility", "Warpstone", 0.85, false, 1, nil, "Default", 1, 30, 10, nil, 4, 100, 300, 0.375, 4, 50, 150, 0.75)
local function v158(p136, p137, p138, p139, p140, p141, p142, p143, p144, p145, p146, p147, p148, p149, p150, p151, p152)
    local v153 = {
        ["AttackCooldown"] = p146,
        ["AttackDelay"] = p147 or 0,
        ["AttackDamage"] = p148,
        ["AttackReach"] = p149,
        ["AttackMaxHits"] = p145 or (1 / 0)
    }
    local v154 = p144 or {
        ["Inspect"] = false,
        ["Shoot"] = false
    }
    local v155 = p150 or { "StartShooting" }
    for v156, v157 in pairs(p152 or {}) do
        v153[v156] = v157
    end
    v_u_92("Melee", p136, p137, p138, p139, p140, p141, p142, p143, v154, 0, 0, v155, p151, v153)
end
v158("Standard", "Melee", "Fists", 0.55, true, 1.05, 1, "Default", nil, 2, 0.35, nil, 30, 6, nil, nil)
v158("Standard", "Melee", "Knife", 0.45, true, 1.1, nil, "Default", {
    ["Inspect"] = false,
    ["Shoot"] = false,
    ["Aim"] = false
}, nil, 0.6, nil, 40, 6, { "StartAiming" }, nil, {
    ["HeavyAttackCooldown"] = 1.25,
    ["HeavyAttackDamage"] = 40,
    ["HeavyAttackReach"] = 7,
    ["CriticalMultiplier"] = 3.75
})
v158("Standard", "Melee", "Chainsaw", 0.6, true, 0.9, nil, "Default", {
    ["Inspect"] = false,
    ["Shoot"] = false,
    ["Aim"] = false
}, nil, 0.6, nil, 60, 6, nil, nil, {
    ["AmmoType"] = "Fuel",
    ["MaxAmmo"] = 150,
    ["MaxAmmoReserve"] = 0,
    ["HoldSpeedBoostMin"] = 0.25,
    ["HoldSpeedBoostMax"] = 0.85,
    ["HoldSpeedBoostRampTime"] = 0.5,
    ["HoldDamageMultiplier"] = 3
})
v158("Standard", "Melee", "Katana", 0.65, true, 1, nil, "Default", {
    ["Inspect"] = false,
    ["Shoot"] = false,
    ["Aim"] = false
}, nil, 0.7, nil, 45, 6, nil, { "StartAiming" }, {
    ["DeflectDuration"] = 1,
    ["DeflectCooldown"] = 4,
    ["DeflectDamageMultiplier"] = 1
})
v158("Standard", "Melee", "Scythe", 1, true, 1, nil, "Default", {
    ["Inspect"] = false,
    ["Shoot"] = false,
    ["Aim"] = false
}, nil, 0.7, nil, 35, 6, nil, { "StartAiming" }, {
    ["DashCooldown"] = 4,
    ["DashDuration"] = 0.25,
    ["DashSpeed"] = 100
})
v158("Prime", "Melee", "Trowel", 1, true, 1.1, nil, "Default", {
    ["Inspect"] = false,
    ["Shoot"] = false,
    ["Aim"] = false
}, nil, 0.6, nil, 50, 6, nil, { "StartAiming" }, {
    ["BuildCooldown"] = 4,
    ["BuildReach"] = 50,
    ["MaxBricks"] = 25,
    ["BrickLifetime"] = 30
})
v158("Standard", "Melee", "Battle Axe", 0.85, true, 0.9, nil, "Default", {
    ["Inspect"] = false,
    ["Shoot"] = false,
    ["Aim"] = false
}, nil, 0.7, nil, 55, 6, { "StartAiming" }, nil, {
    ["SpinCooldown"] = 4,
    ["SpinDuration"] = 0.25,
    ["SpinSpeed"] = 75,
    ["SpinRadius"] = 10,
    ["SpinDamage"] = 30
})
v158("Standard", "Melee", "Riot Shield", 1.05, true, 0.9, nil, "Default", {
    ["Inspect"] = false,
    ["Shoot"] = false,
    ["Aim"] = false
}, nil, 0.7, nil, 25, 7, nil, nil, {
    ["KnockbackForce"] = 64
})
v158("Contraband", "Melee", "Glast Shard", 0.45, true, 1.1, 1, "Default", {
    ["Inspect"] = false,
    ["Shoot"] = false,
    ["Aim"] = false
}, nil, 0.6, nil, 1, 6, { "StartAiming" }, nil, {
    ["HeavyAttackCooldown"] = 1.25,
    ["HeavyAttackDamage"] = 1,
    ["HeavyAttackReach"] = 7,
    ["CriticalMultiplier"] = 150
})
v158("Prime", "Melee", "Maul", 1, true, 0.75, nil, "Default", {
    ["Inspect"] = false,
    ["Shoot"] = false,
    ["Aim"] = false
}, nil, 1.5, 0.6, 75, 8, nil, nil, {
    ["ChargeDamage"] = 75,
    ["ChargeKnockbackForce"] = 256,
    ["ChargeIntro"] = 2.7,
    ["ChargeReleaseCooldown"] = 2.5,
    ["ChargeAttackDelay"] = 0.65
})
local function v244(p159, p160, p161, p162, p163, p164, p165, p166, p167, p168, p169, p170, p171, p172, p173, p174, p175, p176, p177, p178, p179, p180, p181, p182, p183, p184, p185, p186, p187, p188, p189, p190, p191, p192, p193, p194, p195, p196, p197, p198, p199, p200, p201, p202, p203, p204, p205, p206, p207, p208, p209, p210)
    local v211 = p208 or {
        ["Inspect"] = false,
        ["Shoot"] = false,
        ["Aim"] = true,
        ["Reload"] = false
    }
    local v212 = p169 == nil and 0 or p169
    local v213 = p170 == nil and 0 or p170
    local v214 = p209 or { "StartShooting" }
    local v215 = v_u_3.Info[v_u_23.ViewModels[p161].Animations.Reload]
    local v216 = v_u_3.Info[v_u_23.ViewModels[p161].Animations.EmptyReload]
    local v217 = v_u_3.Info[v_u_23.ViewModels[p161].Animations.ReloadStart]
    local v218 = v_u_3.Info[v_u_23.ViewModels[p161].Animations.ReloadSegment]
    local v219 = v_u_3.Info[v_u_23.ViewModels[p161].Animations.ReloadFinish]
    local v220 = v_u_3.Info[v_u_23.ViewModels[p161].Animations.EmptyReloadStart]
    local v221 = v_u_3.Info[v_u_23.ViewModels[p161].Animations.EmptyReloadSegment]
    local v222 = v_u_3.Info[v_u_23.ViewModels[p161].Animations.EmptyReloadFinish]
    local v223 = v215 and "Regular" or (v217 and "Segmented" or nil)
    local v224 = {
        ["CriticalMultiplier"] = p167,
        ["DisableTraditionalCrits"] = p168,
        ["ShootBurst"] = p171 or 1,
        ["ShootBurstCooldown"] = p172 or 0,
        ["ShootCooldown"] = p173,
        ["ShootDamage"] = p174,
        ["ShootRecoil"] = p175,
        ["ShootAccuracy"] = p176,
        ["ShootExplosionRadius"] = p177 or 0,
        ["ShootExplosionDamage"] = p174,
        ["ShootExplosionKnockback"] = p178 or 1,
        ["ShootPellets"] = p179 or 1,
        ["ShootSpread"] = p180 or 0.5,
        ["ShootSpreadConsistent"] = p181 or false,
        ["IsRaycast"] = not p190,
        ["RaycastGrabSmallHitboxes"] = p182 or false,
        ["RaycastBounceCount"] = p183 or 0,
        ["RaycastBounceAlwaysCrits"] = p184,
        ["RaycastBounceRedirectionAngle"] = math.rad(p185 or 0) / 2,
        ["RaycastPierceCount"] = p186 or 0,
        ["RaycastDamageDropoffMultiplier"] = p187,
        ["RaycastDamageDropoffStartDistance"] = p188,
        ["RaycastDamageDropoffEndDistance"] = p189,
        ["IsProjectile"] = p190 or false,
        ["ProjectileClientSided"] = p191 or false,
        ["ProjectileSpeed"] = p192 or 300,
        ["ProjectileGravity"] = p193 or 0,
        ["ProjectileMaxHits"] = p194 or 1,
        ["ProjectileSpawnOffset"] = p195 or CFrame.new(0, 0, -3),
        ["ProjectileGrowthSpeed"] = p196 or 0,
        ["ProjectileGrowthLimit"] = p197 or 1,
        ["ProjectileLifetime"] = p198 or 5,
        ["DamageType"] = p199 or (p177 and p177 > 0 and "Splash" or (p190 and "Projectile" or "Bullet")),
        ["AmmoType"] = p200,
        ["MaxAmmo"] = p201,
        ["MaxAmmoReserve"] = p202,
        ["ReloadType"] = v223
    }
    local v225
    if v223 == "Regular" then
        v225 = v216 ~= nil
    elseif v223 == "Segmented" then
        v225 = v220 ~= nil
    else
        v225 = false
    end
    v224.HasEmptyReload = v225
    local v226
    if v215 then
        v226 = v215.ActionTimestamp
    else
        v226 = nil
    end
    v224.ReloadActionTimestamp = v226
    local v227
    if v215 then
        v227 = v215.Length
    else
        v227 = nil
    end
    v224.ReloadLength = v227
    local v228
    if v216 then
        v228 = v216.ActionTimestamp
    else
        v228 = nil
    end
    v224.EmptyReloadActionTimestamp = v228
    local v229
    if v216 then
        v229 = v216.Length
    else
        v229 = nil
    end
    v224.EmptyReloadLength = v229
    local v230
    if v217 then
        v230 = v217.ActionTimestamp
    else
        v230 = nil
    end
    v224.ReloadStartActionTimestamp = v230
    local v231
    if v217 then
        v231 = v217.Length
    else
        v231 = nil
    end
    v224.ReloadStartLength = v231
    local v232
    if v218 then
        v232 = v218.ActionTimestamp
    else
        v232 = nil
    end
    v224.ReloadSegmentActionTimestamp = v232
    local v233
    if v218 then
        v233 = v218.Length
    else
        v233 = nil
    end
    v224.ReloadSegmentLength = v233
    local v234
    if v219 then
        v234 = v219.ActionTimestamp
    else
        v234 = nil
    end
    v224.ReloadFinishActionTimestamp = v234
    local v235
    if v219 then
        v235 = v219.Length
    else
        v235 = nil
    end
    v224.ReloadFinishLength = v235
    local v236
    if v220 then
        v236 = v220.ActionTimestamp
    else
        v236 = nil
    end
    v224.EmptyReloadStartActionTimestamp = v236
    local v237
    if v220 then
        v237 = v220.Length
    else
        v237 = nil
    end
    v224.EmptyReloadStartLength = v237
    local v238
    if v221 then
        v238 = v221.ActionTimestamp
    else
        v238 = nil
    end
    v224.EmptyReloadSegmentActionTimestamp = v238
    local v239
    if v221 then
        v239 = v221.Length
    else
        v239 = nil
    end
    v224.EmptyReloadSegmentLength = v239
    local v240
    if v222 then
        v240 = v222.ActionTimestamp
    else
        v240 = nil
    end
    v224.EmptyReloadFinishActionTimestamp = v240
    local v241
    if v222 then
        v241 = v222.Length
    else
        v241 = nil
    end
    v224.EmptyReloadFinishLength = v241
    v224.AimFOVOffset = p206 or -50
    v224.AimSpeed = p203 or 1
    v224.AimScopePercent = p204
    v224.AimSpreadMultiplier = p205 or 0
    v224.DisableTracerEffects = p207
    for v242, v243 in pairs(p210 or {}) do
        v224[v242] = v243
    end
    v_u_92("Gun", p159, p160, p161, p162, p163, p164, p165, p166, v211, v212, v213, v214, nil, v224)
end
v244("Standard", "Primary", "MISSING_WEAPON", 0.65, true, 0.9, nil, "Default", 1.25, nil, nil, nil, nil, nil, 0.1, 12, 1, 1, nil, nil, nil, 1, nil, nil, nil, nil, nil, nil, 0.25, 50, 200, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "Medium", 20, 100, nil, nil, nil, nil, nil, nil, nil, nil)
v244("Standard", "Secondary", "Flare Gun", 1.3, true, 1.1, nil, "Default", nil, nil, false, nil, nil, nil, 0.25, nil, 2.5, 0.75, 8, 0, nil, 0, nil, nil, nil, nil, nil, nil, nil, nil, nil, true, nil, 150, 0.5, nil, CFrame.new(1, -1, -3) * CFrame.Angles(0.06981317007977318, 0, 0), nil, nil, 30, nil, "Shells", 1, 1, nil, nil, nil, -40, nil, nil, nil, {
    ["DamagePerSecond"] = 50,
    ["DamageTicksPerSecond"] = 10,
    ["AfterburnDamage"] = 25,
    ["AfterburnDuration"] = 4,
    ["AfterburnTicks"] = 8
})
v244("Standard", "Primary", "Assault Rifle", 0.65, true, 0.9, nil, "Default", 1.25, nil, nil, nil, nil, nil, 0.1, 12, 1, 1, nil, nil, nil, 1, nil, nil, nil, nil, nil, nil, 0.25, 50, 200, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "Medium", 20, 100, nil, nil, nil, nil, nil, nil, nil, nil)
v244("Standard", "Secondary", "Handgun", 0.2, true, 1, nil, "Default", 1.25, nil, false, nil, nil, nil, 0.13, 12, 1, 1, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 0.25, 50, 125, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "Light", 12, 84, nil, nil, nil, -40, nil, nil, nil, nil)
v244("Standard", "Primary", "Burst Rifle", 0.75, true, 0.9, nil, "Default", 1.25, nil, nil, nil, 3, 0.07, 0.6, 20, 1.5, 0.75, nil, nil, nil, 2, nil, nil, nil, nil, nil, nil, 0.25, 50, 200, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "Medium", 15, 60, nil, nil, nil, nil, nil, nil, nil, nil)
v244("Standard", "Primary", "Sniper", 1.15, true, 0.8, nil, "Default", 3, nil, nil, false, nil, nil, 1.5, 50, 10, 0.2, nil, nil, nil, 15, nil, true, nil, nil, nil, 9, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "Heavy", 5, 10, 0.55, 0.925, nil, nil, nil, nil, nil, nil)
v244("Standard", "Primary", "RPG", 1, true, 0.8, nil, "Default", 2, nil, nil, nil, nil, nil, 0.25, 60, 5, 0.4, 16, 1.5, nil, 0, nil, nil, nil, nil, nil, nil, nil, nil, nil, true, nil, 100, nil, nil, CFrame.new(1, -1, -3), nil, nil, nil, nil, "Rockets", 1, 14, 0.625, nil, nil, nil, nil, nil, nil, nil)
v244("Standard", "Secondary", "Shorty", 0.7, true, 1, nil, "SpreadH", 1.5, nil, false, nil, nil, nil, 0.125, 75, 5, 0.25, nil, nil, 10, 7.5, true, nil, nil, nil, nil, nil, 0.333, 7.5, 25, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "Shells", 2, 18, nil, nil, 0.875, -40, nil, nil, nil, nil)
v244("Standard", "Primary", "Shotgun", 0.75, true, 1, nil, "Spread", 1.5, nil, false, false, nil, nil, 0.7, 75, 2.5, 0.75, nil, nil, 10, 6.5, true, nil, nil, nil, nil, 2, 0.333, 10, 50, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "Shells", 7, 35, nil, nil, 0.75, -20, nil, nil, nil, nil)
v244("Standard", "Primary", "Bow", 0.85, true, 1.05, 1, "Default", 2, nil, nil, nil, nil, nil, 0.25, 30, 0, 1, nil, nil, nil, 0, nil, nil, nil, nil, nil, nil, nil, nil, nil, true, true, 300, 0.25, nil, CFrame.new(0, -1, -2), nil, nil, nil, nil, "Arrows", 1, 30, nil, nil, nil, nil, nil, {
    ["Inspect"] = false,
    ["Shoot"] = false,
    ["Aim"] = false,
    ["Reload"] = false
}, nil, {
    ["ChargeReleaseCooldown"] = 1,
    ["ChargeReleaseReloadTimestamp"] = 0.65,
    ["ChargeLevelTimestamps"] = {
        0,
        0.3,
        1,
        1.8
    },
    ["ChargeLevelDamageMultipliers"] = {
        1,
        1.25,
        1.5,
        2
    }
})
v244("Standard", "Secondary", "Uzi", 0.6, true, 1, nil, "Default", 1.25, nil, nil, nil, nil, nil, 0.07, 8, 1, 0.8, nil, nil, nil, 4, nil, nil, nil, nil, nil, nil, 0.25, 50, 125, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "Light", 27, 108, 1.5, nil, 0.5, -40, nil, nil, nil, nil)
v244("Standard", "Secondary", "Revolver", 0.7, true, 0.95, nil, "Default", 1.3334, nil, false, nil, nil, nil, 0.4, 30, 2, 3, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 0.25, 75, 200, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "Light", 6, 36, nil, nil, nil, -40, nil, {
    ["Inspect"] = false,
    ["Shoot"] = false,
    ["Aim"] = false,
    ["Reload"] = false
}, nil, {
    ["QuickShotCooldown"] = 0.15,
    ["QuickShotSpread"] = 10
})
v244("Prime", "Primary", "Paintball Gun", 0.8, true, 0.9, nil, "Default", nil, nil, nil, nil, nil, nil, 0.15, 18.5, 0.5, 2, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 0.25, 50, 200, false, nil, 300, nil, nil, CFrame.new(1, -1, -3), nil, nil, nil, nil, "Ball", 16, 24, nil, nil, nil, -20, nil, nil, nil, nil)
v244("Prime", "Secondary", "Slingshot", 0.45, true, 1.1, nil, "Default", 1.5, true, nil, nil, nil, nil, 0.1, 8, 0.5, 1.5, nil, nil, nil, 0, nil, nil, nil, nil, nil, nil, nil, nil, nil, true, true, 300, 1, 3, CFrame.new(0, -2, -3) * CFrame.Angles(0.06981317007977318, 0, 0), 100, 4, nil, nil, "Ball", 99, 0, nil, nil, nil, -10, nil, nil, nil, nil)
v244("Prime", "Primary", "Grenade Launcher", 1, true, 0.9, nil, "Default", 2, nil, nil, nil, nil, nil, 0.6, 50, 4, 0.75, 12, 1.25, nil, 0, nil, nil, nil, nil, nil, nil, nil, nil, nil, true, nil, 90, 0.25, nil, CFrame.new(0.5, -1, -3) * CFrame.Angles(0.06981317007977318, 0, 0), nil, nil, nil, nil, "Shells", 6, 24, 0.75, nil, nil, -15, nil, nil, nil, nil)
v244("Prime", "Primary", "Minigun", 1, true, 0.75, nil, "Default", 1.25, nil, nil, nil, nil, nil, 0.05, 8, 1, 1, nil, nil, nil, 2, nil, nil, nil, nil, nil, 2, 0.5, 50, 200, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "Heavy", 300, 0, 0.15, nil, 0.5, -5, nil, nil, nil, {
    ["ChargingSpeedBoost"] = -0.5,
    ["ChargingWindUpLength"] = 0.8
})
v244("Prime", "Secondary", "Exogun", 0.7, true, 1, nil, "Default", 2, nil, nil, nil, nil, nil, 0.28, 10, 2, 1, 6.28, 0, nil, nil, nil, nil, nil, nil, nil, nil, 0.2143, 60, 280, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "Ball", 6, 28, nil, nil, nil, -30, nil, nil, nil, nil)
v244("Standard", "Utility", "Freeze Ray", 1, false, 1, nil, "Default", nil, nil, nil, nil, nil, nil, 0.5, 0, 2, 1, 16, 0, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, true, nil, 75, 0.25, nil, CFrame.new(0.5, -0.5, -3) * CFrame.Angles(0.06981317007977318, 0, 0), nil, nil, nil, nil, "Ball", 1, 0, nil, nil, nil, -30, nil, nil, { "StartShooting" }, {
    ["FreezeDuration"] = 3
})
v244("Contraband", "Secondary", "Scepter", 1, true, 1, nil, "Default", 1, nil, nil, nil, nil, nil, 0.5, 25, 0, 1, 12, 0, nil, 0, nil, nil, nil, nil, nil, nil, nil, nil, nil, true, true, 200, 0, nil, CFrame.new(1, -1, 0), nil, nil, nil, nil, "Ball", 30, 0, nil, nil, nil, nil, nil, nil, nil, {
    ["TransformDelay"] = 0.5
})
v244("Standard", "Secondary", "Daggers", 0.8, true, 1.1, 1, "Default", 2, nil, nil, nil, 2, 0.15, 0.6, 20, 0, 1, nil, nil, nil, 0, nil, nil, nil, nil, nil, nil, nil, nil, nil, true, true, 300, 0.25, nil, CFrame.new(0, -1, -2) * CFrame.Angles(0.06981317007977318, 0, 0), nil, nil, nil, nil, "Daggers", 2, 60, nil, nil, nil, nil, nil, {
    ["Inspect"] = false,
    ["Shoot"] = false,
    ["Reload"] = false
}, nil, nil)
v244("Prime", "Secondary", "Energy Pistols", 0.45, true, 1, nil, "Default", 1.25, nil, nil, nil, nil, nil, 0.03, 2.4, 0.2, 1, nil, nil, nil, 0, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "Light", (1 / 0), 0, nil, nil, nil, -20, true, nil, nil, nil)
v244("Prime", "Primary", "Energy Rifle", 1.05, true, 1, nil, "Default", 1.25, nil, nil, nil, nil, nil, 0.3, 20, 2, 1, nil, nil, nil, 0, nil, nil, 2, nil, 15, 9, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "Medium", (1 / 0), 0, nil, nil, nil, nil, nil, nil, nil, nil)
v244("Standard", "Secondary", "Spray", 0.45, true, 1.05, nil, "Default", 1.25, nil, nil, nil, 5, 0.04, 0.3, 6, 2, 0.75, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 0.25, 50, 125, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "Light", 30, 90, 1.25, nil, nil, -40, nil, nil, nil, {
    ["DealsTrueDamage"] = true
})
v244("Standard", "Primary", "Crossbow", 1.15, true, 1.05, nil, "Default", 2, nil, nil, false, nil, nil, 1, 37.5, 1, 0.2, nil, nil, nil, 0, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "Projectile", "Arrows", 1, 30, 0.75, 0.875, nil, nil, nil, nil, nil, nil)
v244("Standard", "Primary", "Gunblade", 1, true, 1, nil, "Default", 1.2223, nil, nil, false, nil, nil, 0.75, 45, 3, 1, nil, nil, nil, 0, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "Medium", 12, 0, nil, nil, nil, nil, nil, {
    ["Inspect"] = false,
    ["Shoot"] = false,
    ["Aim"] = true
}, nil, {
    ["TransitionCooldown"] = 0.6,
    ["BladeDamage"] = 35,
    ["BladeCriticalDamage"] = 50,
    ["BladeCooldown"] = 0.5,
    ["BladeReach"] = 8,
    ["BladeMaxHits"] = (1 / 0),
    ["DashCooldown"] = 1.5,
    ["DashDuration"] = 0.1875,
    ["DashSpeed"] = 100
})
v244("Contraband", "Secondary", "Glass Cannon", 0.75, true, 0.95, nil, "Default", nil, true, false, nil, nil, nil, 1, 150, 15, 3, nil, nil, nil, 0, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "Heavy", 1, 0, nil, nil, nil, nil, nil, {
    ["Inspect"] = false,
    ["Shoot"] = false,
    ["Reload"] = false
}, nil, nil)
v244("Contraband", "Primary", "Distortion", 1.7, true, 1, nil, "Spread", nil, nil, nil, nil, nil, nil, 0.4, 35, 1, 0.5, 4, 0, 5, 5, true, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 90, 0.25, nil, CFrame.new(0.5, -1, -3) * CFrame.Angles(0.06981317007977318, 0, 0), nil, nil, nil, nil, "Ball", 77, 0, 0.75, nil, nil, nil, nil, {
    ["Inspect"] = false,
    ["Shoot"] = false,
    ["Aim"] = false
}, { "StartAiming" }, {
    ["VortexCooldown"] = 30,
    ["VortexRadius"] = 12,
    ["VortexLifetime"] = 4
})
v244("Contraband", "Primary", "Permafrost", 0.5, true, 1, nil, "Default", 1.25, nil, nil, nil, 2, 0.08, 0.2, 13, 1, 1, nil, 0, nil, 1, nil, nil, nil, nil, nil, nil, 0.25, 50, 125, nil, nil, 75, 0.25, nil, nil, nil, nil, nil, nil, "Medium", 30, 90, nil, nil, nil, nil, nil, nil, nil, {
    ["MaxFreezeDuration"] = 3,
    ["SlowDuration"] = 0.75,
    ["SlowBoost"] = -0.35
});
(function()
    for _, v245 in pairs(v_u_23.ItemOrder) do
        local v246 = v_u_23.ItemsAlphabetized
        table.insert(v246, v245)
    end
    table.sort(v_u_23.ItemsAlphabetized, function(p247, p248)
        return v_u_4:StringLessThan(string.lower(p247), string.lower(p248))
    end)
end)();
(function()
    if v_u_2.IS_STUDIO and v_u_2.IS_SERVER then
        local v249 = {}
        local v250 = {
            ["grenade_lob"] = true,
            ["grenade_lob_pinpull"] = true,
            ["grenade_pixelgrenade_lob_start"] = true,
            ["grenade_pixelgrenade_throw"] = true,
            ["grenade_pixelgrenade_throw_pinpull"] = true,
            ["grenade_pixelgrenade_throw_start"] = true,
            ["grenade_throw"] = true,
            ["grenade_throw_pinpull"] = true,
            ["katana_deflect_loop"] = true,
            ["katana_sprint"] = true,
            ["shotgun_reload_empty_finish"] = true,
            ["shotgun_reload_finish2"] = true,
            ["shotgun_shotkey_shoot_aiming"] = true
        }
        for _, v251 in pairs(v_u_23.ViewModels) do
            for _, v252 in pairs(v251.Animations) do
                v249[v252] = true
            end
        end
        local v253 = {}
        for v254 in pairs(v_u_3.Info) do
            if not (v249[v254] or v250[v254]) then
                v253[v254] = true
            end
        end
        if next(v253) then
            warn("[STUDIO] Unused animations:", v253)
        end
    end
end)()
return v_u_23