local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("MaterialService")
local v3 = game:GetService("Players")
local v_u_4 = require(v1.Modules.CONSTANTS)
local v_u_5 = require(v1.Modules.CurrencyLibrary)
local v_u_6 = require(v1.Modules.ItemLibrary)
local v_u_7 = require(v1.Modules.ShopLibrary)
local v_u_8 = require(v1.Modules.Utility)
local v_u_56 = {
    ["IGNORE_TRANSPARENCY_WHITELIST"] = {
        ["Riot Shield"] = true
    },
    ["RENAMED_COSMETICS"] = {
        ["Hexxed"] = "Vexed",
        ["Hexxed Flare Gun"] = "Vexed Flare Gun",
        ["Hexxed Candle"] = "Vexed Candle",
        ["Rivals"] = "RIVALS",
        ["Bone Crossbow"] = "Crossbone",
        ["Bonestone"] = "Warpbone",
        ["2025 Energy Rifle"] = "New Year Energy Rifle",
        ["2025 Energy Pistols"] = "New Year Energy Pistols",
        ["2025 Katana"] = "New Year Katana",
        ["New Year Rifle"] = "New Year Energy Rifle"
    },
    ["Rarities"] = {},
    ["Types"] = {},
    ["Cosmetics"] = {},
    ["CosmeticsAlphabetized"] = {},
    ["CosmeticNameToLootbox"] = {},
    ["Rewards"] = {},
    ["LootboxOrder"] = {},
    ["OwnsCosmeticForWeapon"] = function(_, p9, p10, p11)
        local v12 = p9 and p9[p10]
        if v12 then
            v12 = p9[p10][p11]
        end
        return v12
    end,
    ["OwnsCosmeticUniversally"] = function(_, p13, p14)
        local v15 = p13 and p13[p14]
        if v15 then
            v15 = p13[p14].IsUniversal
        end
        return v15
    end,
    ["OwnsCosmeticNormally"] = function(_, p16, p17)
        if p16 then
            p16 = p16[p17] == true
        end
        return p16
    end,
    ["OwnsCosmetic"] = function(p18, p19, p20, p21)
        return p18:OwnsCosmeticNormally(p19, p20) or (p18:OwnsCosmeticUniversally(p19, p20) or p18:OwnsCosmeticForWeapon(p19, p20, p21))
    end,
    ["OwnsCosmeticForSomething"] = function(p22, p23, p24)
        if p22:OwnsCosmeticNormally(p23, p24) then
            return true
        end
        for _, v25 in pairs(p23 and p23[p24] or {}) do
            if v25 then
                return true
            end
        end
    end,
    ["HasNotification"] = function(_, p26, p27, p28)
        if p26 and p26[p27] then
            return p26[p27] == true and true or p26[p27][p28]
        else
            return false
        end
    end,
    ["CountNotificationsByWeapon"] = function(_, p29, p30)
        local v31 = 0
        for _, v32 in pairs(p29) do
            if typeof(v32) == "table" then
                for v33 in pairs(v32) do
                    if v33 == p30 then
                        v31 = v31 + 1
                    end
                end
            end
        end
        return v31
    end,
    ["CountNotificationsByCosmeticType"] = function(p34, p35, p36, p37, p38)
        local v39 = 0
        for v40, v41 in pairs(p35) do
            local v42 = p34.Cosmetics[v40]
            if v42 and v42.Type == p36 then
                if typeof(v41) == "table" then
                    for v43 in pairs(v41) do
                        if (not p38 or p38[v43]) and v43 == p37 then
                            v39 = v39 + 1
                        end
                    end
                elseif v41 == true then
                    v39 = v39 + 1
                end
            end
        end
        return v39
    end,
    ["CountNotifications"] = function(p44, p45, p46, p47)
        if not p46 then
            local v48 = 0
            for v49 in pairs(p45) do
                v48 = v48 + p44:CountNotifications(p45, v49, p47)
            end
            return v48
        end
        if not (p45 and p45[p46]) then
            return 0
        end
        if p45[p46] == true then
            return 1
        end
        local v50 = 0
        for v51 in pairs(p45[p46]) do
            if not p47 or p47[v51] then
                v50 = v50 + 1
            end
        end
        return v50
    end,
    ["ExternallySetCosmeticDescription"] = function(_, p52, p53)
        if #p52 < 8 or string.sub(p52, 1, 8) ~= "MISSING_" then
            local v54 = v_u_56.Cosmetics[p52].Description
            local v55 = not v54 or v54 == p53
            assert(v55, p52)
            v_u_56.Cosmetics[p52].Description = p53
        end
    end
}
local v_u_57 = {}
local v58 = {
    ["Value"] = 0,
    ["Color"] = Color3.fromRGB(255, 255, 255)
}
v_u_56.Rarities.None = v58
local v59 = {
    ["Value"] = 1,
    ["Color"] = Color3.fromRGB(255, 140, 0)
}
v_u_56.Rarities.Unique = v59
local v60 = {
    ["Value"] = 2,
    ["Color"] = Color3.fromRGB(123, 255, 0)
}
v_u_56.Rarities.Common = v60
local v61 = {
    ["Value"] = 3,
    ["Color"] = Color3.fromRGB(0, 221, 255)
}
v_u_56.Rarities.Rare = v61
local v62 = {
    ["Value"] = 4,
    ["Color"] = Color3.fromRGB(255, 0, 0)
}
v_u_56.Rarities.Legendary = v62
local v63 = {
    ["Value"] = 5,
    ["Color"] = Color3.fromRGB(64, 68, 186)
}
v_u_56.Rarities.Mythical = v63
local v64 = {
    ["Value"] = 6,
    ["Color"] = Color3.fromRGB(0, 0, 0)
}
v_u_56.Rarities.Unobtainable = v64
v_u_56.Types.Reward = {
    ["Value"] = 0,
    ["IsWeaponCosmetic"] = nil,
    ["NotCosmetic"] = true
}
v_u_56.Types.Charm = {
    ["Value"] = 1,
    ["IsWeaponCosmetic"] = true,
    ["NotCosmetic"] = nil
}
v_u_56.Types.Wrap = {
    ["Value"] = 2,
    ["IsWeaponCosmetic"] = true,
    ["NotCosmetic"] = nil
}
v_u_56.Types.Finisher = {
    ["Value"] = 3,
    ["IsWeaponCosmetic"] = true,
    ["NotCosmetic"] = nil
}
v_u_56.Types.Skin = {
    ["Value"] = 4,
    ["IsWeaponCosmetic"] = true,
    ["NotCosmetic"] = nil
}
v_u_56.Types.Emote = {
    ["Value"] = 5,
    ["IsWeaponCosmetic"] = nil,
    ["NotCosmetic"] = nil
}
local function v_u_81(p65, p66, p67, p68, p69, p70, p71, p72, p73)
    local v74 = v_u_56.Rarities[p66] ~= nil
    assert(v74)
    local v75 = not v_u_56.RENAMED_COSMETICS[p67]
    assert(v75)
    local v_u_78 = {
        ["Rarity"] = p66,
        ["Type"] = p65,
        ["Image"] = p68 or "",
        ["ImageScale"] = p69 or 1,
        ["Hidden"] = p70,
        ["Description"] = p71,
        ["DescriptionSpecific"] = p72,
        ["GetDescription"] = nil,
        ["GetDescription"] = function(p76)
            local v77 = p76 and v_u_78.DescriptionSpecific or v_u_78.Description
            if v77 then
                return tostring(v77)
            else
                return nil
            end
        end
    }
    for v79, v80 in pairs(p73 or {}) do
        v_u_78[v79] = v80
    end
    v_u_56.Cosmetics[p67] = v_u_78
    if v_u_4.IS_SERVER then
        if v_u_57[p67] then
            error("[ITEM] Duplicate item name: " .. p67)
            return
        end
        v_u_57[p67] = true
    end
end
local v82 = v_u_6.ViewModels["10B Visits"]
local v83 = {
    ["ItemName"] = "Assault Rifle",
    ["ImageHighResolution"] = v82.ImageHighResolution
}
v_u_81("Skin", "Unique", "10B Visits", v82.Image, 3, nil, "Earned by redeeming a code when the game (RIVALS) reaches 10,000,000,000 visits", nil, v83)
local v84 = v_u_6.ViewModels["Compound Bow"]
local v85 = {
    ["ItemName"] = "Bow",
    ["ImageHighResolution"] = v84.ImageHighResolution
}
v_u_81("Skin", "Common", "Compound Bow", v84.Image, 3, nil, nil, nil, v85)
local v86 = v_u_6.ViewModels.Goalpost
local v87 = {
    ["ItemName"] = "Slingshot",
    ["ImageHighResolution"] = v86.ImageHighResolution
}
v_u_81("Skin", "Common", "Goalpost", v86.Image, 3, nil, nil, nil, v87)
local v88 = v_u_6.ViewModels.Stick
local v89 = {
    ["ItemName"] = "Slingshot",
    ["ImageHighResolution"] = v88.ImageHighResolution
}
v_u_81("Skin", "Common", "Stick", v88.Image, 3, nil, nil, nil, v89)
local v90 = v_u_6.ViewModels.Chancla
local v91 = {
    ["ItemName"] = "Knife",
    ["ImageHighResolution"] = v90.ImageHighResolution
}
v_u_81("Skin", "Common", "Chancla", v90.Image, 3, nil, nil, nil, v91)
local v92 = v_u_6.ViewModels.Coffee
local v93 = {
    ["ItemName"] = "Molotov",
    ["ImageHighResolution"] = v92.ImageHighResolution
}
v_u_81("Skin", "Common", "Coffee", v92.Image, 3, nil, nil, nil, v93)
local v94 = v_u_6.ViewModels["Too Shorty"]
local v95 = {
    ["ItemName"] = "Shorty",
    ["ImageHighResolution"] = v94.ImageHighResolution
}
v_u_81("Skin", "Common", "Too Shorty", v94.Image, 3, nil, "Included in the Starter Bundle", nil, v95)
local v96 = v_u_6.ViewModels["Not So Shorty"]
local v97 = {
    ["ItemName"] = "Shorty",
    ["ImageHighResolution"] = v96.ImageHighResolution
}
v_u_81("Skin", "Common", "Not So Shorty", v96.Image, 3, nil, nil, nil, v97)
local v98 = v_u_6.ViewModels["Lovely Shorty"]
local v99 = {
    ["ItemName"] = "Shorty",
    ["ImageHighResolution"] = v98.ImageHighResolution
}
v_u_81("Skin", "Common", "Lovely Shorty", v98.Image, 3, nil, nil, nil, v99)
local v100 = v_u_6.ViewModels.Lamethrower
local v101 = {
    ["ItemName"] = "Flamethrower",
    ["ImageHighResolution"] = v100.ImageHighResolution
}
v_u_81("Skin", "Common", "Lamethrower", v100.Image, 3, nil, nil, nil, v101)
local v102 = v_u_6.ViewModels["Brass Knuckles"]
local v103 = {
    ["ItemName"] = "Fists",
    ["ImageHighResolution"] = v102.ImageHighResolution
}
v_u_81("Skin", "Common", "Brass Knuckles", v102.Image, 3, nil, nil, nil, v103)
local v104 = v_u_6.ViewModels.Balance
local v105 = {
    ["ItemName"] = "Smoke Grenade",
    ["ImageHighResolution"] = v104.ImageHighResolution
}
v_u_81("Skin", "Common", "Balance", v104.Image, 3, nil, nil, nil, v105)
local v106 = v_u_6.ViewModels.Torch
local v107 = {
    ["ItemName"] = "Molotov",
    ["ImageHighResolution"] = v106.ImageHighResolution
}
v_u_81("Skin", "Common", "Torch", v106.Image, 3, nil, nil, nil, v107)
local v108 = v_u_6.ViewModels.Machete
local v109 = {
    ["ItemName"] = "Knife",
    ["ImageHighResolution"] = v108.ImageHighResolution
}
v_u_81("Skin", "Common", "Machete", v108.Image, 3, nil, nil, nil, v109)
local v110 = v_u_6.ViewModels["Pumpkin Claws"]
local v111 = {
    ["ItemName"] = "Fists",
    ["ImageHighResolution"] = v110.ImageHighResolution
}
v_u_81("Skin", "Common", "Pumpkin Claws", v110.Image, 3, nil, nil, nil, v111)
local v112 = v_u_6.ViewModels["Eyething Sniper"]
local v113 = {
    ["ItemName"] = "Sniper",
    ["ImageHighResolution"] = v112.ImageHighResolution
}
v_u_81("Skin", "Common", "Eyething Sniper", v112.Image, 3, nil, nil, nil, v113)
local v114 = v_u_6.ViewModels["Pumpkin Handgun"]
local v115 = {
    ["ItemName"] = "Handgun",
    ["ImageHighResolution"] = v114.ImageHighResolution
}
v_u_81("Skin", "Common", "Pumpkin Handgun", v114.Image, 3, nil, nil, nil, v115)
local v116 = v_u_6.ViewModels["Spectral Burst"]
local v117 = {
    ["ItemName"] = "Burst Rifle",
    ["ImageHighResolution"] = v116.ImageHighResolution
}
v_u_81("Skin", "Common", "Spectral Burst", v116.Image, 3, nil, nil, nil, v117)
local v118 = v_u_6.ViewModels["Pumpkin Minigun"]
local v119 = {
    ["ItemName"] = "Minigun",
    ["ImageHighResolution"] = v118.ImageHighResolution
}
v_u_81("Skin", "Common", "Pumpkin Minigun", v118.Image, 3, nil, nil, nil, v119)
local v120 = v_u_6.ViewModels.Skullbang
local v121 = {
    ["ItemName"] = "Flashbang",
    ["ImageHighResolution"] = v120.ImageHighResolution
}
v_u_81("Skin", "Common", "Skullbang", v120.Image, 3, nil, nil, nil, v121)
local v122 = v_u_6.ViewModels["Trick or Treat"]
local v123 = {
    ["ItemName"] = "Subspace Tripmine",
    ["ImageHighResolution"] = v122.ImageHighResolution
}
v_u_81("Skin", "Common", "Trick or Treat", v122.Image, 3, nil, nil, nil, v123)
local v124 = v_u_6.ViewModels.Door
local v125 = {
    ["ItemName"] = "Riot Shield",
    ["ImageHighResolution"] = v124.ImageHighResolution
}
v_u_81("Skin", "Common", "Door", v124.Image, 3, nil, nil, nil, v125)
local v126 = v_u_6.ViewModels["Lovely Spray"]
local v127 = {
    ["ItemName"] = "Spray",
    ["ImageHighResolution"] = v126.ImageHighResolution
}
v_u_81("Skin", "Common", "Lovely Spray", v126.Image, 3, nil, nil, nil, v127)
local v128 = v_u_6.ViewModels["Wrapped Shotgun"]
local v129 = {
    ["ItemName"] = "Shotgun",
    ["ImageHighResolution"] = v128.ImageHighResolution
}
v_u_81("Skin", "Common", "Wrapped Shotgun", v128.Image, 3, nil, nil, nil, v129)
local v130 = v_u_6.ViewModels["Wrapped Shorty"]
local v131 = {
    ["ItemName"] = "Shorty",
    ["ImageHighResolution"] = v130.ImageHighResolution
}
v_u_81("Skin", "Common", "Wrapped Shorty", v130.Image, 3, nil, nil, nil, v131)
local v132 = v_u_6.ViewModels["Wrapped Flare Gun"]
local v133 = {
    ["ItemName"] = "Flare Gun",
    ["ImageHighResolution"] = v132.ImageHighResolution
}
v_u_81("Skin", "Common", "Wrapped Flare Gun", v132.Image, 3, nil, nil, nil, v133)
local v134 = v_u_6.ViewModels["Wrapped Minigun"]
local v135 = {
    ["ItemName"] = "Minigun",
    ["ImageHighResolution"] = v134.ImageHighResolution
}
v_u_81("Skin", "Common", "Wrapped Minigun", v134.Image, 3, nil, nil, nil, v135)
local v136 = v_u_6.ViewModels["Wrapped Freeze Ray"]
local v137 = {
    ["ItemName"] = "Freeze Ray",
    ["ImageHighResolution"] = v136.ImageHighResolution
}
v_u_81("Skin", "Common", "Wrapped Freeze Ray", v136.Image, 3, nil, nil, nil, v137)
local v138 = v_u_6.ViewModels["Mammoth Horn"]
local v139 = {
    ["ItemName"] = "War Horn",
    ["ImageHighResolution"] = v138.ImageHighResolution
}
v_u_81("Skin", "Common", "Mammoth Horn", v138.Image, 3, nil, nil, nil, v139)
local v140 = v_u_6.ViewModels["Festive Fists"]
local v141 = {
    ["ItemName"] = "Fists",
    ["ImageHighResolution"] = v140.ImageHighResolution
}
v_u_81("Skin", "Common", "Festive Fists", v140.Image, 3, nil, nil, nil, v141)
local v142 = v_u_6.ViewModels["Midnight Festive Exogun"]
local v143 = {
    ["ItemName"] = "Exogun",
    ["ImageHighResolution"] = v142.ImageHighResolution
}
v_u_81("Skin", "Common", "Midnight Festive Exogun", v142.Image, 3, nil, nil, nil, v143)
local v144 = v_u_6.ViewModels.Sled
local v145 = {
    ["ItemName"] = "Riot Shield",
    ["ImageHighResolution"] = v144.ImageHighResolution
}
v_u_81("Skin", "Common", "Sled", v144.Image, 3, nil, nil, nil, v145)
local v146 = v_u_6.ViewModels["Nordic Axe"]
local v147 = {
    ["ItemName"] = "Battle Axe",
    ["ImageHighResolution"] = v146.ImageHighResolution
}
v_u_81("Skin", "Common", "Nordic Axe", v146.Image, 3, nil, nil, nil, v147)
local v148 = v_u_6.ViewModels["Suspicious Gift"]
local v149 = {
    ["ItemName"] = "Satchel",
    ["ImageHighResolution"] = v148.ImageHighResolution
}
v_u_81("Skin", "Common", "Suspicious Gift", v148.Image, 3, nil, nil, nil, v149)
local v150 = v_u_6.ViewModels["Pine Burst"]
local v151 = {
    ["ItemName"] = "Burst Rifle",
    ["ImageHighResolution"] = v150.ImageHighResolution
}
v_u_81("Skin", "Common", "Pine Burst", v150.Image, 3, nil, nil, nil, v151)
local v152 = v_u_6.ViewModels["Pine Uzi"]
local v153 = {
    ["ItemName"] = "Uzi",
    ["ImageHighResolution"] = v152.ImageHighResolution
}
v_u_81("Skin", "Common", "Pine Uzi", v152.Image, 3, nil, nil, nil, v153)
local v154 = v_u_6.ViewModels["Pine Spray"]
local v155 = {
    ["ItemName"] = "Spray",
    ["ImageHighResolution"] = v154.ImageHighResolution
}
v_u_81("Skin", "Common", "Pine Spray", v154.Image, 3, nil, nil, nil, v155)
local v156 = v_u_6.ViewModels["Elf\'s Gunblade"]
local v157 = {
    ["ItemName"] = "Gunblade",
    ["ImageHighResolution"] = v156.ImageHighResolution
}
v_u_81("Skin", "Common", "Elf\'s Gunblade", v156.Image, 3, nil, nil, nil, v157)
local v158 = v_u_6.ViewModels["Phoenix Rifle"]
local v159 = {
    ["ItemName"] = "Assault Rifle",
    ["ImageHighResolution"] = v158.ImageHighResolution
}
v_u_81("Skin", "Common", "Phoenix Rifle", v158.Image, 3, nil, nil, nil, v159)
local v160 = v_u_6.ViewModels.Trampoline
local v161 = {
    ["ItemName"] = "Jump Pad",
    ["ImageHighResolution"] = v160.ImageHighResolution
}
v_u_81("Skin", "Common", "Trampoline", v160.Image, 3, nil, nil, nil, v161)
local v162 = v_u_6.ViewModels["Ban Axe"]
local v163 = {
    ["ItemName"] = "Battle Axe",
    ["ImageHighResolution"] = v162.ImageHighResolution
}
v_u_81("Skin", "Common", "Ban Axe", v162.Image, 3, nil, nil, nil, v163)
local v164 = v_u_6.ViewModels["Cactus Shotgun"]
local v165 = {
    ["ItemName"] = "Shotgun",
    ["ImageHighResolution"] = v164.ImageHighResolution
}
v_u_81("Skin", "Common", "Cactus Shotgun", v164.Image, 3, nil, nil, nil, v165)
local v166 = v_u_6.ViewModels["Crude Gunblade"]
local v167 = {
    ["ItemName"] = "Gunblade",
    ["ImageHighResolution"] = v166.ImageHighResolution
}
v_u_81("Skin", "Common", "Crude Gunblade", v166.Image, 3, nil, nil, nil, v167)
local v168 = v_u_6.ViewModels["DIY Tripmine"]
local v169 = {
    ["ItemName"] = "Subspace Tripmine",
    ["ImageHighResolution"] = v168.ImageHighResolution
}
v_u_81("Skin", "Common", "DIY Tripmine", v168.Image, 3, nil, nil, nil, v169)
local v170 = v_u_6.ViewModels.Dynamite
local v171 = {
    ["ItemName"] = "Grenade",
    ["ImageHighResolution"] = v170.ImageHighResolution
}
v_u_81("Skin", "Common", "Dynamite", v170.Image, 3, nil, nil, nil, v171)
local v172 = v_u_6.ViewModels["Gumball Handgun"]
local v173 = {
    ["ItemName"] = "Handgun",
    ["ImageHighResolution"] = v172.ImageHighResolution
}
v_u_81("Skin", "Common", "Gumball Handgun", v172.Image, 3, nil, nil, nil, v173)
local v174 = v_u_6.ViewModels["Ketchup Gun"]
local v175 = {
    ["ItemName"] = "Paintball Gun",
    ["ImageHighResolution"] = v174.ImageHighResolution
}
v_u_81("Skin", "Common", "Ketchup Gun", v174.Image, 3, nil, nil, nil, v175)
local v176 = v_u_6.ViewModels.Lightbulb
local v177 = {
    ["ItemName"] = "Flashbang",
    ["ImageHighResolution"] = v176.ImageHighResolution
}
v_u_81("Skin", "Common", "Lightbulb", v176.Image, 3, nil, nil, nil, v177)
local v178 = v_u_6.ViewModels.Megaphone
local v179 = {
    ["ItemName"] = "War Horn",
    ["ImageHighResolution"] = v178.ImageHighResolution
}
v_u_81("Skin", "Common", "Megaphone", v178.Image, 3, nil, nil, nil, v179)
local v180 = v_u_6.ViewModels["Nail Gun"]
local v181 = {
    ["ItemName"] = "Spray",
    ["ImageHighResolution"] = v180.ImageHighResolution
}
v_u_81("Skin", "Common", "Nail Gun", v180.Image, 3, nil, nil, nil, v181)
local v182 = v_u_6.ViewModels["Notebook Satchel"]
local v183 = {
    ["ItemName"] = "Satchel",
    ["ImageHighResolution"] = v182.ImageHighResolution
}
v_u_81("Skin", "Common", "Notebook Satchel", v182.Image, 3, nil, nil, nil, v183)
local v184 = v_u_6.ViewModels["Paper Planes"]
local v185 = {
    ["ItemName"] = "Daggers",
    ["ImageHighResolution"] = v184.ImageHighResolution
}
v_u_81("Skin", "Common", "Paper Planes", v184.Image, 3, nil, nil, nil, v185)
local v186 = v_u_6.ViewModels["Pencil Launcher"]
local v187 = {
    ["ItemName"] = "RPG",
    ["ImageHighResolution"] = v186.ImageHighResolution
}
v_u_81("Skin", "Common", "Pencil Launcher", v186.Image, 3, nil, "Included in the RPG Bundle", nil, v187)
local v188 = v_u_6.ViewModels["Bag o\' Money"]
local v189 = {
    ["ItemName"] = "Satchel",
    ["ImageHighResolution"] = v188.ImageHighResolution
}
v_u_81("Skin", "Common", "Bag o\' Money", v188.Image, 3, nil, nil, nil, v189)
local v190 = v_u_6.ViewModels.Shurikens
local v191 = {
    ["ItemName"] = "Daggers",
    ["ImageHighResolution"] = v190.ImageHighResolution
}
v_u_81("Skin", "Common", "Shurikens", v190.Image, 3, nil, nil, nil, v191)
local v192 = v_u_6.ViewModels["Glorious Assault Rifle"]
local v193 = {
    ["ItemName"] = "Assault Rifle",
    ["ImageHighResolution"] = v192.ImageHighResolution
}
v_u_81("Skin", "Common", "Glorious Assault Rifle", v192.Image, 3, nil, "Purchased from the Ranked Shop", nil, v193)
local v194 = v_u_6.ViewModels["Glorious Battle Axe"]
local v195 = {
    ["ItemName"] = "Battle Axe",
    ["ImageHighResolution"] = v194.ImageHighResolution
}
v_u_81("Skin", "Common", "Glorious Battle Axe", v194.Image, 3, nil, "Purchased from the Ranked Shop", nil, v195)
local v196 = v_u_6.ViewModels["Glorious Bow"]
local v197 = {
    ["ItemName"] = "Bow",
    ["ImageHighResolution"] = v196.ImageHighResolution
}
v_u_81("Skin", "Common", "Glorious Bow", v196.Image, 3, nil, "Purchased from the Ranked Shop", nil, v197)
local v198 = v_u_6.ViewModels["Glorious Burst Rifle"]
local v199 = {
    ["ItemName"] = "Burst Rifle",
    ["ImageHighResolution"] = v198.ImageHighResolution
}
v_u_81("Skin", "Common", "Glorious Burst Rifle", v198.Image, 3, nil, "Purchased from the Ranked Shop", nil, v199)
local v200 = v_u_6.ViewModels["Glorious Chainsaw"]
local v201 = {
    ["ItemName"] = "Chainsaw",
    ["ImageHighResolution"] = v200.ImageHighResolution
}
v_u_81("Skin", "Common", "Glorious Chainsaw", v200.Image, 3, nil, "Purchased from the Ranked Shop", nil, v201)
local v202 = v_u_6.ViewModels["Glorious Crossbow"]
local v203 = {
    ["ItemName"] = "Crossbow",
    ["ImageHighResolution"] = v202.ImageHighResolution
}
v_u_81("Skin", "Common", "Glorious Crossbow", v202.Image, 3, nil, "Purchased from the Ranked Shop", nil, v203)
local v204 = v_u_6.ViewModels["Glorious Daggers"]
local v205 = {
    ["ItemName"] = "Daggers",
    ["ImageHighResolution"] = v204.ImageHighResolution
}
v_u_81("Skin", "Common", "Glorious Daggers", v204.Image, 3, nil, "Purchased from the Ranked Shop", nil, v205)
local v206 = v_u_6.ViewModels["Glorious Energy Pistols"]
local v207 = {
    ["ItemName"] = "Energy Pistols",
    ["ImageHighResolution"] = v206.ImageHighResolution
}
v_u_81("Skin", "Common", "Glorious Energy Pistols", v206.Image, 3, nil, "Purchased from the Ranked Shop", nil, v207)
local v208 = v_u_6.ViewModels["Glorious Energy Rifle"]
local v209 = {
    ["ItemName"] = "Energy Rifle",
    ["ImageHighResolution"] = v208.ImageHighResolution
}
v_u_81("Skin", "Common", "Glorious Energy Rifle", v208.Image, 3, nil, "Purchased from the Ranked Shop", nil, v209)
local v210 = v_u_6.ViewModels["Glorious Exogun"]
local v211 = {
    ["ItemName"] = "Exogun",
    ["ImageHighResolution"] = v210.ImageHighResolution
}
v_u_81("Skin", "Common", "Glorious Exogun", v210.Image, 3, nil, "Purchased from the Ranked Shop", nil, v211)
local v212 = v_u_6.ViewModels["Glorious Fists"]
local v213 = {
    ["ItemName"] = "Fists",
    ["ImageHighResolution"] = v212.ImageHighResolution
}
v_u_81("Skin", "Common", "Glorious Fists", v212.Image, 3, nil, "Purchased from the Ranked Shop", nil, v213)
local v214 = v_u_6.ViewModels["Glorious Flamethrower"]
local v215 = {
    ["ItemName"] = "Flamethrower",
    ["ImageHighResolution"] = v214.ImageHighResolution
}
v_u_81("Skin", "Common", "Glorious Flamethrower", v214.Image, 3, nil, "Purchased from the Ranked Shop", nil, v215)
local v216 = v_u_6.ViewModels["Glorious Flare Gun"]
local v217 = {
    ["ItemName"] = "Flare Gun",
    ["ImageHighResolution"] = v216.ImageHighResolution
}
v_u_81("Skin", "Common", "Glorious Flare Gun", v216.Image, 3, nil, "Purchased from the Ranked Shop", nil, v217)
local v218 = v_u_6.ViewModels["Glorious Flashbang"]
local v219 = {
    ["ItemName"] = "Flashbang",
    ["ImageHighResolution"] = v218.ImageHighResolution
}
v_u_81("Skin", "Common", "Glorious Flashbang", v218.Image, 3, nil, "Purchased from the Ranked Shop", nil, v219)
local v220 = v_u_6.ViewModels["Glorious Freeze Ray"]
local v221 = {
    ["ItemName"] = "Freeze Ray",
    ["ImageHighResolution"] = v220.ImageHighResolution
}
v_u_81("Skin", "Common", "Glorious Freeze Ray", v220.Image, 3, nil, "Purchased from the Ranked Shop", nil, v221)
local v222 = v_u_6.ViewModels["Glorious Grenade"]
local v223 = {
    ["ItemName"] = "Grenade",
    ["ImageHighResolution"] = v222.ImageHighResolution
}
v_u_81("Skin", "Common", "Glorious Grenade", v222.Image, 3, nil, "Purchased from the Ranked Shop", nil, v223)
local v224 = v_u_6.ViewModels["Glorious Grenade Launcher"]
local v225 = {
    ["ItemName"] = "Grenade Launcher",
    ["ImageHighResolution"] = v224.ImageHighResolution
}
v_u_81("Skin", "Common", "Glorious Grenade Launcher", v224.Image, 3, nil, "Purchased from the Ranked Shop", nil, v225)
local v226 = v_u_6.ViewModels["Glorious Gunblade"]
local v227 = {
    ["ItemName"] = "Gunblade",
    ["ImageHighResolution"] = v226.ImageHighResolution
}
v_u_81("Skin", "Common", "Glorious Gunblade", v226.Image, 3, nil, "Purchased from the Ranked Shop", nil, v227)
local v228 = v_u_6.ViewModels["Glorious Handgun"]
local v229 = {
    ["ItemName"] = "Handgun",
    ["ImageHighResolution"] = v228.ImageHighResolution
}
v_u_81("Skin", "Common", "Glorious Handgun", v228.Image, 3, nil, "Purchased from the Ranked Shop", nil, v229)
local v230 = v_u_6.ViewModels["Glorious Jump Pad"]
local v231 = {
    ["ItemName"] = "Jump Pad",
    ["ImageHighResolution"] = v230.ImageHighResolution
}
v_u_81("Skin", "Common", "Glorious Jump Pad", v230.Image, 3, nil, "Purchased from the Ranked Shop", nil, v231)
local v232 = v_u_6.ViewModels["Glorious Katana"]
local v233 = {
    ["ItemName"] = "Katana",
    ["ImageHighResolution"] = v232.ImageHighResolution
}
v_u_81("Skin", "Common", "Glorious Katana", v232.Image, 3, nil, "Purchased from the Ranked Shop", nil, v233)
local v234 = v_u_6.ViewModels["Glorious Knife"]
local v235 = {
    ["ItemName"] = "Knife",
    ["ImageHighResolution"] = v234.ImageHighResolution
}
v_u_81("Skin", "Common", "Glorious Knife", v234.Image, 3, nil, "Purchased from the Ranked Shop", nil, v235)
local v236 = v_u_6.ViewModels["Glorious Medkit"]
local v237 = {
    ["ItemName"] = "Medkit",
    ["ImageHighResolution"] = v236.ImageHighResolution
}
v_u_81("Skin", "Common", "Glorious Medkit", v236.Image, 3, nil, "Purchased from the Ranked Shop", nil, v237)
local v238 = v_u_6.ViewModels["Glorious Minigun"]
local v239 = {
    ["ItemName"] = "Minigun",
    ["ImageHighResolution"] = v238.ImageHighResolution
}
v_u_81("Skin", "Common", "Glorious Minigun", v238.Image, 3, nil, "Purchased from the Ranked Shop", nil, v239)
local v240 = v_u_6.ViewModels["Glorious Molotov"]
local v241 = {
    ["ItemName"] = "Molotov",
    ["ImageHighResolution"] = v240.ImageHighResolution
}
v_u_81("Skin", "Common", "Glorious Molotov", v240.Image, 3, nil, "Purchased from the Ranked Shop", nil, v241)
local v242 = v_u_6.ViewModels["Glorious Paintball Gun"]
local v243 = {
    ["ItemName"] = "Paintball Gun",
    ["ImageHighResolution"] = v242.ImageHighResolution
}
v_u_81("Skin", "Common", "Glorious Paintball Gun", v242.Image, 3, nil, "Purchased from the Ranked Shop", nil, v243)
local v244 = v_u_6.ViewModels["Glorious RPG"]
local v245 = {
    ["ItemName"] = "RPG",
    ["ImageHighResolution"] = v244.ImageHighResolution
}
v_u_81("Skin", "Common", "Glorious RPG", v244.Image, 3, nil, "Purchased from the Ranked Shop", nil, v245)
local v246 = v_u_6.ViewModels["Glorious Revolver"]
local v247 = {
    ["ItemName"] = "Revolver",
    ["ImageHighResolution"] = v246.ImageHighResolution
}
v_u_81("Skin", "Common", "Glorious Revolver", v246.Image, 3, nil, "Purchased from the Ranked Shop", nil, v247)
local v248 = v_u_6.ViewModels["Glorious Riot Shield"]
local v249 = {
    ["ItemName"] = "Riot Shield",
    ["ImageHighResolution"] = v248.ImageHighResolution
}
v_u_81("Skin", "Common", "Glorious Riot Shield", v248.Image, 3, nil, "Purchased from the Ranked Shop", nil, v249)
local v250 = v_u_6.ViewModels["Glorious Satchel"]
local v251 = {
    ["ItemName"] = "Satchel",
    ["ImageHighResolution"] = v250.ImageHighResolution
}
v_u_81("Skin", "Common", "Glorious Satchel", v250.Image, 3, nil, "Purchased from the Ranked Shop", nil, v251)
local v252 = v_u_6.ViewModels["Glorious Scythe"]
local v253 = {
    ["ItemName"] = "Scythe",
    ["ImageHighResolution"] = v252.ImageHighResolution
}
v_u_81("Skin", "Common", "Glorious Scythe", v252.Image, 3, nil, "Purchased from the Ranked Shop", nil, v253)
local v254 = v_u_6.ViewModels["Glorious Shorty"]
local v255 = {
    ["ItemName"] = "Shorty",
    ["ImageHighResolution"] = v254.ImageHighResolution
}
v_u_81("Skin", "Common", "Glorious Shorty", v254.Image, 3, nil, "Purchased from the Ranked Shop", nil, v255)
local v256 = v_u_6.ViewModels["Glorious Shotgun"]
local v257 = {
    ["ItemName"] = "Shotgun",
    ["ImageHighResolution"] = v256.ImageHighResolution
}
v_u_81("Skin", "Common", "Glorious Shotgun", v256.Image, 3, nil, "Purchased from the Ranked Shop", nil, v257)
local v258 = v_u_6.ViewModels["Glorious Slingshot"]
local v259 = {
    ["ItemName"] = "Slingshot",
    ["ImageHighResolution"] = v258.ImageHighResolution
}
v_u_81("Skin", "Common", "Glorious Slingshot", v258.Image, 3, nil, "Purchased from the Ranked Shop", nil, v259)
local v260 = v_u_6.ViewModels["Glorious Smoke Grenade"]
local v261 = {
    ["ItemName"] = "Smoke Grenade",
    ["ImageHighResolution"] = v260.ImageHighResolution
}
v_u_81("Skin", "Common", "Glorious Smoke Grenade", v260.Image, 3, nil, "Purchased from the Ranked Shop", nil, v261)
local v262 = v_u_6.ViewModels["Glorious Sniper"]
local v263 = {
    ["ItemName"] = "Sniper",
    ["ImageHighResolution"] = v262.ImageHighResolution
}
v_u_81("Skin", "Common", "Glorious Sniper", v262.Image, 3, nil, "Purchased from the Ranked Shop", nil, v263)
local v264 = v_u_6.ViewModels["Glorious Spray"]
local v265 = {
    ["ItemName"] = "Spray",
    ["ImageHighResolution"] = v264.ImageHighResolution
}
v_u_81("Skin", "Common", "Glorious Spray", v264.Image, 3, nil, "Purchased from the Ranked Shop", nil, v265)
local v266 = v_u_6.ViewModels["Glorious Subspace Tripmine"]
local v267 = {
    ["ItemName"] = "Subspace Tripmine",
    ["ImageHighResolution"] = v266.ImageHighResolution
}
v_u_81("Skin", "Common", "Glorious Subspace Tripmine", v266.Image, 3, nil, "Purchased from the Ranked Shop", nil, v267)
local v268 = v_u_6.ViewModels["Glorious Trowel"]
local v269 = {
    ["ItemName"] = "Trowel",
    ["ImageHighResolution"] = v268.ImageHighResolution
}
v_u_81("Skin", "Common", "Glorious Trowel", v268.Image, 3, nil, "Purchased from the Ranked Shop", nil, v269)
local v270 = v_u_6.ViewModels["Glorious Uzi"]
local v271 = {
    ["ItemName"] = "Uzi",
    ["ImageHighResolution"] = v270.ImageHighResolution
}
v_u_81("Skin", "Common", "Glorious Uzi", v270.Image, 3, nil, "Purchased from the Ranked Shop", nil, v271)
local v272 = v_u_6.ViewModels["Glorious War Horn"]
local v273 = {
    ["ItemName"] = "War Horn",
    ["ImageHighResolution"] = v272.ImageHighResolution
}
v_u_81("Skin", "Common", "Glorious War Horn", v272.Image, 3, nil, "Purchased from the Ranked Shop", nil, v273)
local v274 = v_u_6.ViewModels["Glorious Distortion"]
local v275 = {
    ["ItemName"] = "Distortion",
    ["ImageHighResolution"] = v274.ImageHighResolution
}
v_u_81("Skin", "Common", "Glorious Distortion", v274.Image, 3, nil, "Purchased from the Ranked Shop", nil, v275)
local v276 = v_u_6.ViewModels["Glorious Warper"]
local v277 = {
    ["ItemName"] = "Warper",
    ["ImageHighResolution"] = v276.ImageHighResolution
}
v_u_81("Skin", "Common", "Glorious Warper", v276.Image, 3, nil, "Purchased from the Ranked Shop", nil, v277)
local v278 = v_u_6.ViewModels["Glorious Warpstone"]
local v279 = {
    ["ItemName"] = "Warpstone",
    ["ImageHighResolution"] = v278.ImageHighResolution
}
v_u_81("Skin", "Common", "Glorious Warpstone", v278.Image, 3, nil, "Purchased from the Ranked Shop", nil, v279)
local v280 = v_u_6.ViewModels["Glorious Maul"]
local v281 = {
    ["ItemName"] = "Maul",
    ["ImageHighResolution"] = v280.ImageHighResolution
}
v_u_81("Skin", "Common", "Glorious Maul", v280.Image, 3, nil, "Purchased from the Ranked Shop", nil, v281)
local v282 = v_u_6.ViewModels["Glorious Permafrost"]
local v283 = {
    ["ItemName"] = "Permafrost",
    ["ImageHighResolution"] = v282.ImageHighResolution
}
v_u_81("Skin", "Common", "Glorious Permafrost", v282.Image, 3, nil, "Purchased from the Ranked Shop", nil, v283)
local v284 = v_u_6.ViewModels["Warp Handgun"]
local v285 = {
    ["ItemName"] = "Handgun",
    ["ImageHighResolution"] = v284.ImageHighResolution
}
v_u_81("Skin", "Common", "Warp Handgun", v284.Image, 3, nil, nil, nil, v285)
local v286 = v_u_6.ViewModels["Spider Web"]
local v287 = {
    ["ItemName"] = "Jump Pad",
    ["ImageHighResolution"] = v286.ImageHighResolution
}
v_u_81("Skin", "Common", "Spider Web", v286.Image, 3, nil, nil, nil, v287)
local v288 = v_u_6.ViewModels["Tombstone Shield"]
local v289 = {
    ["ItemName"] = "Riot Shield",
    ["ImageHighResolution"] = v288.ImageHighResolution
}
v_u_81("Skin", "Common", "Tombstone Shield", v288.Image, 3, nil, nil, nil, v289)
local v290 = v_u_6.ViewModels.Boneblade
local v291 = {
    ["ItemName"] = "Gunblade",
    ["ImageHighResolution"] = v290.ImageHighResolution
}
v_u_81("Skin", "Common", "Boneblade", v290.Image, 3, nil, nil, nil, v291)
local v292 = v_u_6.ViewModels.Crossbone
local v293 = {
    ["ItemName"] = "Crossbow",
    ["ImageHighResolution"] = v292.ImageHighResolution
}
v_u_81("Skin", "Common", "Crossbone", v292.Image, 3, nil, nil, nil, v293)
local v294 = v_u_6.ViewModels.Warpbone
local v295 = {
    ["ItemName"] = "Warpstone",
    ["ImageHighResolution"] = v294.ImageHighResolution
}
v_u_81("Skin", "Common", "Warpbone", v294.Image, 3, nil, nil, nil, v295)
local v296 = v_u_6.ViewModels["Towerstone Handgun"]
local v297 = {
    ["ItemName"] = "Handgun",
    ["ImageHighResolution"] = v296.ImageHighResolution
}
v_u_81("Skin", "Common", "Towerstone Handgun", v296.Image, 3, nil, "Earned by escaping the Zombie Tower solo", nil, v297)
local v298 = v_u_6.ViewModels["Cyber Warpstone"]
local v299 = {
    ["ItemName"] = "Warpstone",
    ["ImageHighResolution"] = v298.ImageHighResolution
}
v_u_81("Skin", "Common", "Cyber Warpstone", v298.Image, 3, nil, nil, nil, v299)
local v300 = v_u_6.ViewModels["Cyber Distortion"]
local v301 = {
    ["ItemName"] = "Distortion",
    ["ImageHighResolution"] = v300.ImageHighResolution
}
v_u_81("Skin", "Common", "Cyber Distortion", v300.Image, 3, nil, nil, nil, v301)
local v302 = v_u_6.ViewModels["Frozen Grenade"]
local v303 = {
    ["ItemName"] = "Grenade",
    ["ImageHighResolution"] = v302.ImageHighResolution
}
v_u_81("Skin", "Common", "Frozen Grenade", v302.Image, 3, nil, nil, nil, v303)
local v304 = v_u_6.ViewModels["Ice Maul"]
local v305 = {
    ["ItemName"] = "Maul",
    ["ImageHighResolution"] = v304.ImageHighResolution
}
v_u_81("Skin", "Common", "Ice Maul", v304.Image, 3, nil, nil, nil, v305)
local v306 = v_u_6.ViewModels["Ice Permafrost"]
local v307 = {
    ["ItemName"] = "Permafrost",
    ["ImageHighResolution"] = v306.ImageHighResolution
}
v_u_81("Skin", "Common", "Ice Permafrost", v306.Image, 3, nil, nil, nil, v307)
local v308 = v_u_6.ViewModels["Snowman Permafrost"]
local v309 = {
    ["ItemName"] = "Permafrost",
    ["ImageHighResolution"] = v308.ImageHighResolution
}
v_u_81("Skin", "Common", "Snowman Permafrost", v308.Image, 3, nil, nil, nil, v309)
local v310 = v_u_6.ViewModels["Slime Gun"]
local v311 = {
    ["ItemName"] = "Paintball Gun",
    ["ImageHighResolution"] = v310.ImageHighResolution
}
v_u_81("Skin", "Rare", "Slime Gun", v310.Image, 3, nil, nil, nil, v311)
local v312 = v_u_6.ViewModels.Blobsaw
local v313 = {
    ["ItemName"] = "Chainsaw",
    ["ImageHighResolution"] = v312.ImageHighResolution
}
v_u_81("Skin", "Rare", "Blobsaw", v312.Image, 3, nil, nil, nil, v313)
local v314 = v_u_6.ViewModels["Plastic Shovel"]
local v315 = {
    ["ItemName"] = "Trowel",
    ["ImageHighResolution"] = v314.ImageHighResolution
}
v_u_81("Skin", "Rare", "Plastic Shovel", v314.Image, 3, nil, nil, nil, v315)
local v316 = v_u_6.ViewModels.Wondergun
local v317 = {
    ["ItemName"] = "Exogun",
    ["ImageHighResolution"] = v316.ImageHighResolution
}
v_u_81("Skin", "Rare", "Wondergun", v316.Image, 3, nil, "Included in the Exogun Bundle", nil, v317)
local v318 = v_u_6.ViewModels["Boxing Gloves"]
local v319 = {
    ["ItemName"] = "Fists",
    ["ImageHighResolution"] = v318.ImageHighResolution
}
v_u_81("Skin", "Rare", "Boxing Gloves", v318.Image, 3, nil, nil, nil, v319)
local v320 = v_u_6.ViewModels["AK-47"]
local v321 = {
    ["ItemName"] = "Assault Rifle",
    ["ImageHighResolution"] = v320.ImageHighResolution
}
v_u_81("Skin", "Rare", "AK-47", v320.Image, 3, nil, nil, nil, v321)
local v322 = v_u_6.ViewModels.Briefcase
local v323 = {
    ["ItemName"] = "Medkit",
    ["ImageHighResolution"] = v322.ImageHighResolution
}
v_u_81("Skin", "Rare", "Briefcase", v322.Image, 3, nil, "Included in the Medkit Bundle", nil, v323)
local v324 = v_u_6.ViewModels["Scythe of Death"]
local v325 = {
    ["ItemName"] = "Scythe",
    ["ImageHighResolution"] = v324.ImageHighResolution
}
v_u_81("Skin", "Rare", "Scythe of Death", v324.Image, 3, nil, nil, nil, v325)
local v326 = v_u_6.ViewModels.Blaster
local v327 = {
    ["ItemName"] = "Handgun",
    ["ImageHighResolution"] = v326.ImageHighResolution
}
v_u_81("Skin", "Rare", "Blaster", v326.Image, 3, nil, nil, nil, v327)
local v328 = v_u_6.ViewModels["Water Uzi"]
local v329 = {
    ["ItemName"] = "Uzi",
    ["ImageHighResolution"] = v328.ImageHighResolution
}
v_u_81("Skin", "Rare", "Water Uzi", v328.Image, 3, nil, nil, nil, v329)
local v330 = v_u_6.ViewModels["Desert Eagle"]
local v331 = {
    ["ItemName"] = "Revolver",
    ["ImageHighResolution"] = v330.ImageHighResolution
}
v_u_81("Skin", "Rare", "Desert Eagle", v330.Image, 3, nil, nil, nil, v331)
local v332 = v_u_6.ViewModels["Dynamite Gun"]
local v333 = {
    ["ItemName"] = "Flare Gun",
    ["ImageHighResolution"] = v332.ImageHighResolution
}
v_u_81("Skin", "Rare", "Dynamite Gun", v332.Image, 3, nil, nil, nil, v333)
local v334 = v_u_6.ViewModels["Raven Bow"]
local v335 = {
    ["ItemName"] = "Bow",
    ["ImageHighResolution"] = v334.ImageHighResolution
}
v_u_81("Skin", "Rare", "Raven Bow", v334.Image, 3, nil, nil, nil, v335)
local v336 = v_u_6.ViewModels.Anchor
local v337 = {
    ["ItemName"] = "Scythe",
    ["ImageHighResolution"] = v336.ImageHighResolution
}
v_u_81("Skin", "Rare", "Anchor", v336.Image, 3, nil, nil, nil, v337)
local v338 = v_u_6.ViewModels["Water Balloon"]
local v339 = {
    ["ItemName"] = "Grenade",
    ["ImageHighResolution"] = v338.ImageHighResolution
}
v_u_81("Skin", "Rare", "Water Balloon", v338.Image, 3, nil, nil, nil, v339)
local v340 = v_u_6.ViewModels["Garden Shovel"]
local v341 = {
    ["ItemName"] = "Trowel",
    ["ImageHighResolution"] = v340.ImageHighResolution
}
v_u_81("Skin", "Rare", "Garden Shovel", v340.Image, 3, nil, nil, nil, v341)
local v342 = v_u_6.ViewModels["Uranium Launcher"]
local v343 = {
    ["ItemName"] = "Grenade Launcher",
    ["ImageHighResolution"] = v342.ImageHighResolution
}
v_u_81("Skin", "Rare", "Uranium Launcher", v342.Image, 3, nil, nil, nil, v343)
local v344 = v_u_6.ViewModels["Ray Gun"]
local v345 = {
    ["ItemName"] = "Exogun",
    ["ImageHighResolution"] = v344.ImageHighResolution
}
v_u_81("Skin", "Rare", "Ray Gun", v344.Image, 3, nil, nil, nil, v345)
local v346 = v_u_6.ViewModels.Spring
local v347 = {
    ["ItemName"] = "Subspace Tripmine",
    ["ImageHighResolution"] = v346.ImageHighResolution
}
v_u_81("Skin", "Rare", "Spring", v346.Image, 3, nil, nil, nil, v347)
local v348 = v_u_6.ViewModels["Bubble Ray"]
local v349 = {
    ["ItemName"] = "Freeze Ray",
    ["ImageHighResolution"] = v348.ImageHighResolution
}
v_u_81("Skin", "Rare", "Bubble Ray", v348.Image, 3, nil, nil, nil, v349)
local v350 = v_u_6.ViewModels["Aqua Burst"]
local v351 = {
    ["ItemName"] = "Burst Rifle",
    ["ImageHighResolution"] = v350.ImageHighResolution
}
v_u_81("Skin", "Rare", "Aqua Burst", v350.Image, 3, nil, nil, nil, v351)
local v352 = v_u_6.ViewModels["Lightning Bolt"]
local v353 = {
    ["ItemName"] = "Katana",
    ["ImageHighResolution"] = v352.ImageHighResolution
}
v_u_81("Skin", "Rare", "Lightning Bolt", v352.Image, 3, nil, nil, nil, v353)
local v354 = v_u_6.ViewModels["Bat Scythe"]
local v355 = {
    ["ItemName"] = "Scythe",
    ["ImageHighResolution"] = v354.ImageHighResolution
}
v_u_81("Skin", "Rare", "Bat Scythe", v354.Image, 3, nil, nil, nil, v355)
local v356 = v_u_6.ViewModels["Bat Bow"]
local v357 = {
    ["ItemName"] = "Bow",
    ["ImageHighResolution"] = v356.ImageHighResolution
}
v_u_81("Skin", "Rare", "Bat Bow", v356.Image, 3, nil, nil, nil, v357)
local v358 = v_u_6.ViewModels["Devil\'s Trident"]
local v359 = {
    ["ItemName"] = "Katana",
    ["ImageHighResolution"] = v358.ImageHighResolution
}
v_u_81("Skin", "Rare", "Devil\'s Trident", v358.Image, 3, nil, nil, nil, v359)
local v360 = v_u_6.ViewModels.Boneshot
local v361 = {
    ["ItemName"] = "Slingshot",
    ["ImageHighResolution"] = v360.ImageHighResolution
}
v_u_81("Skin", "Rare", "Boneshot", v360.Image, 3, nil, nil, nil, v361)
local v362 = v_u_6.ViewModels.Exogourd
local v363 = {
    ["ItemName"] = "Exogun",
    ["ImageHighResolution"] = v362.ImageHighResolution
}
v_u_81("Skin", "Rare", "Exogourd", v362.Image, 3, nil, nil, nil, v363)
local v364 = v_u_6.ViewModels["Pumpkin Carver"]
local v365 = {
    ["ItemName"] = "Trowel",
    ["ImageHighResolution"] = v364.ImageHighResolution
}
v_u_81("Skin", "Rare", "Pumpkin Carver", v364.Image, 3, nil, nil, nil, v365)
local v366 = v_u_6.ViewModels["Demon Shorty"]
local v367 = {
    ["ItemName"] = "Shorty",
    ["ImageHighResolution"] = v366.ImageHighResolution
}
v_u_81("Skin", "Rare", "Demon Shorty", v366.Image, 3, nil, nil, nil, v367)
local v368 = v_u_6.ViewModels.Broomstick
local v369 = {
    ["ItemName"] = "Shotgun",
    ["ImageHighResolution"] = v368.ImageHighResolution
}
v_u_81("Skin", "Rare", "Broomstick", v368.Image, 3, nil, nil, nil, v369)
local v370 = v_u_6.ViewModels["Demon Uzi"]
local v371 = {
    ["ItemName"] = "Uzi",
    ["ImageHighResolution"] = v370.ImageHighResolution
}
v_u_81("Skin", "Rare", "Demon Uzi", v370.Image, 3, nil, nil, nil, v371)
local v372 = v_u_6.ViewModels["Brain Gun"]
local v373 = {
    ["ItemName"] = "Paintball Gun",
    ["ImageHighResolution"] = v372.ImageHighResolution
}
v_u_81("Skin", "Rare", "Brain Gun", v372.Image, 3, nil, nil, nil, v373)
local v374 = v_u_6.ViewModels["Jack O\'Thrower"]
local v375 = {
    ["ItemName"] = "Flamethrower",
    ["ImageHighResolution"] = v374.ImageHighResolution
}
v_u_81("Skin", "Rare", "Jack O\'Thrower", v374.Image, 3, nil, nil, nil, v375)
local v376 = v_u_6.ViewModels["Boneclaw Revolver"]
local v377 = {
    ["ItemName"] = "Revolver",
    ["ImageHighResolution"] = v376.ImageHighResolution
}
v_u_81("Skin", "Rare", "Boneclaw Revolver", v376.Image, 3, nil, nil, nil, v377)
local v378 = v_u_6.ViewModels["Boneclaw Rifle"]
local v379 = {
    ["ItemName"] = "Assault Rifle",
    ["ImageHighResolution"] = v378.ImageHighResolution
}
v_u_81("Skin", "Rare", "Boneclaw Rifle", v378.Image, 3, nil, nil, nil, v379)
local v380 = v_u_6.ViewModels["Hacker Rifle"]
local v381 = {
    ["ItemName"] = "Energy Rifle",
    ["ImageHighResolution"] = v380.ImageHighResolution
}
v_u_81("Skin", "Rare", "Hacker Rifle", v380.Image, 3, nil, nil, nil, v381)
local v382 = v_u_6.ViewModels["Hacker Pistols"]
local v383 = {
    ["ItemName"] = "Energy Pistols",
    ["ImageHighResolution"] = v382.ImageHighResolution
}
v_u_81("Skin", "Rare", "Hacker Pistols", v382.Image, 3, nil, nil, nil, v383)
local v384 = v_u_6.ViewModels.Trumpet
local v385 = {
    ["ItemName"] = "War Horn",
    ["ImageHighResolution"] = v384.ImageHighResolution
}
v_u_81("Skin", "Rare", "Trumpet", v384.Image, 3, nil, nil, nil, v385)
local v386 = v_u_6.ViewModels["Advanced Satchel"]
local v387 = {
    ["ItemName"] = "Satchel",
    ["ImageHighResolution"] = v386.ImageHighResolution
}
v_u_81("Skin", "Rare", "Advanced Satchel", v386.Image, 3, nil, nil, nil, v387)
local v388 = v_u_6.ViewModels.Aces
local v389 = {
    ["ItemName"] = "Daggers",
    ["ImageHighResolution"] = v388.ImageHighResolution
}
v_u_81("Skin", "Rare", "Aces", v388.Image, 3, nil, nil, nil, v389)
local v390 = v_u_6.ViewModels["Apex Pistols"]
local v391 = {
    ["ItemName"] = "Energy Pistols",
    ["ImageHighResolution"] = v390.ImageHighResolution
}
v_u_81("Skin", "Rare", "Apex Pistols", v390.Image, 3, nil, "Included in the Energy Bundle", nil, v391)
local v392 = v_u_6.ViewModels["Apex Rifle"]
local v393 = {
    ["ItemName"] = "Energy Rifle",
    ["ImageHighResolution"] = v392.ImageHighResolution
}
v_u_81("Skin", "Rare", "Apex Rifle", v392.Image, 3, nil, "Included in the Energy Bundle", nil, v393)
local v394 = v_u_6.ViewModels["Gingerbread Handgun"]
local v395 = {
    ["ItemName"] = "Handgun",
    ["ImageHighResolution"] = v394.ImageHighResolution
}
v_u_81("Skin", "Rare", "Gingerbread Handgun", v394.Image, 3, nil, nil, nil, v395)
local v396 = v_u_6.ViewModels["Gingerbread Sniper"]
local v397 = {
    ["ItemName"] = "Sniper",
    ["ImageHighResolution"] = v396.ImageHighResolution
}
v_u_81("Skin", "Rare", "Gingerbread Sniper", v396.Image, 3, nil, nil, nil, v397)
local v398 = v_u_6.ViewModels["Shining Star"]
local v399 = {
    ["ItemName"] = "Flashbang",
    ["ImageHighResolution"] = v398.ImageHighResolution
}
v_u_81("Skin", "Rare", "Shining Star", v398.Image, 3, nil, nil, nil, v399)
local v400 = v_u_6.ViewModels.Snowglobe
local v401 = {
    ["ItemName"] = "Smoke Grenade",
    ["ImageHighResolution"] = v400.ImageHighResolution
}
v_u_81("Skin", "Rare", "Snowglobe", v400.Image, 3, nil, nil, nil, v401)
local v402 = v_u_6.ViewModels["Jingle Grenade"]
local v403 = {
    ["ItemName"] = "Grenade",
    ["ImageHighResolution"] = v402.ImageHighResolution
}
v_u_81("Skin", "Rare", "Jingle Grenade", v402.Image, 3, nil, nil, nil, v403)
local v404 = v_u_6.ViewModels["Reindeer Slingshot"]
local v405 = {
    ["ItemName"] = "Slingshot",
    ["ImageHighResolution"] = v404.ImageHighResolution
}
v_u_81("Skin", "Rare", "Reindeer Slingshot", v404.Image, 3, nil, nil, nil, v405)
local v406 = v_u_6.ViewModels["Snow Shovel"]
local v407 = {
    ["ItemName"] = "Trowel",
    ["ImageHighResolution"] = v406.ImageHighResolution
}
v_u_81("Skin", "Rare", "Snow Shovel", v406.Image, 3, nil, nil, nil, v407)
local v408 = v_u_6.ViewModels["Snowball Gun"]
local v409 = {
    ["ItemName"] = "Paintball Gun",
    ["ImageHighResolution"] = v408.ImageHighResolution
}
v_u_81("Skin", "Rare", "Snowball Gun", v408.Image, 3, nil, nil, nil, v409)
local v410 = v_u_6.ViewModels.Cookies
local v411 = {
    ["ItemName"] = "Daggers",
    ["ImageHighResolution"] = v410.ImageHighResolution
}
v_u_81("Skin", "Rare", "Cookies", v410.Image, 3, nil, nil, nil, v411)
local v412 = v_u_6.ViewModels["Frostbite Bow"]
local v413 = {
    ["ItemName"] = "Bow",
    ["ImageHighResolution"] = v412.ImageHighResolution
}
v_u_81("Skin", "Rare", "Frostbite Bow", v412.Image, 3, nil, nil, nil, v413)
local v414 = v_u_6.ViewModels["Frostbite Crossbow"]
local v415 = {
    ["ItemName"] = "Crossbow",
    ["ImageHighResolution"] = v414.ImageHighResolution
}
v_u_81("Skin", "Rare", "Frostbite Crossbow", v414.Image, 3, nil, nil, nil, v415)
local v416 = v_u_6.ViewModels["New Year Energy Pistols"]
local v417 = {
    ["ItemName"] = "Energy Pistols",
    ["ImageHighResolution"] = v416.ImageHighResolution
}
v_u_81("Skin", "Rare", "New Year Energy Pistols", v416.Image, 3, nil, nil, nil, v417)
local v418 = v_u_6.ViewModels["New Year Energy Rifle"]
local v419 = {
    ["ItemName"] = "Energy Rifle",
    ["ImageHighResolution"] = v418.ImageHighResolution
}
v_u_81("Skin", "Rare", "New Year Energy Rifle", v418.Image, 3, nil, nil, nil, v419)
local v420 = v_u_6.ViewModels["New Year Katana"]
local v421 = {
    ["ItemName"] = "Katana",
    ["ImageHighResolution"] = v420.ImageHighResolution
}
v_u_81("Skin", "Rare", "New Year Katana", v420.Image, 3, nil, nil, nil, v421)
local v422 = v_u_6.ViewModels.Snowblower
local v423 = {
    ["ItemName"] = "Flamethrower",
    ["ImageHighResolution"] = v422.ImageHighResolution
}
v_u_81("Skin", "Rare", "Snowblower", v422.Image, 3, nil, nil, nil, v423)
local v424 = v_u_6.ViewModels["Cryo Scythe"]
local v425 = {
    ["ItemName"] = "Scythe",
    ["ImageHighResolution"] = v424.ImageHighResolution
}
v_u_81("Skin", "Rare", "Cryo Scythe", v424.Image, 3, nil, nil, nil, v425)
local v426 = v_u_6.ViewModels["Snowball Launcher"]
local v427 = {
    ["ItemName"] = "Grenade Launcher",
    ["ImageHighResolution"] = v426.ImageHighResolution
}
v_u_81("Skin", "Rare", "Snowball Launcher", v426.Image, 3, nil, nil, nil, v427)
local v428 = v_u_6.ViewModels["Bounce House"]
local v429 = {
    ["ItemName"] = "Jump Pad",
    ["ImageHighResolution"] = v428.ImageHighResolution
}
v_u_81("Skin", "Rare", "Bounce House", v428.Image, 3, nil, nil, nil, v429)
local v430 = v_u_6.ViewModels["Dream Bow"]
local v431 = {
    ["ItemName"] = "Bow",
    ["ImageHighResolution"] = v430.ImageHighResolution
}
v_u_81("Skin", "Rare", "Dream Bow", v430.Image, 3, nil, nil, nil, v431)
local v432 = v_u_6.ViewModels["Energy Shield"]
local v433 = {
    ["ItemName"] = "Riot Shield",
    ["ImageHighResolution"] = v432.ImageHighResolution
}
v_u_81("Skin", "Rare", "Energy Shield", v432.Image, 3, nil, nil, nil, v433)
local v434 = v_u_6.ViewModels["Fists of Hurt"]
local v435 = {
    ["ItemName"] = "Fists",
    ["ImageHighResolution"] = v434.ImageHighResolution
}
v_u_81("Skin", "Rare", "Fists of Hurt", v434.Image, 3, nil, nil, nil, v435)
local v436 = v_u_6.ViewModels["Gearnade Launcher"]
local v437 = {
    ["ItemName"] = "Grenade Launcher",
    ["ImageHighResolution"] = v436.ImageHighResolution
}
v_u_81("Skin", "Rare", "Gearnade Launcher", v436.Image, 3, nil, nil, nil, v437)
local v438 = v_u_6.ViewModels.Glitterthrower
local v439 = {
    ["ItemName"] = "Flamethrower",
    ["ImageHighResolution"] = v438.ImageHighResolution
}
v_u_81("Skin", "Rare", "Glitterthrower", v438.Image, 3, nil, nil, nil, v439)
local v440 = v_u_6.ViewModels["Gum Ray"]
local v441 = {
    ["ItemName"] = "Freeze Ray",
    ["ImageHighResolution"] = v440.ImageHighResolution
}
v_u_81("Skin", "Rare", "Gum Ray", v440.Image, 3, nil, nil, nil, v441)
local v442 = v_u_6.ViewModels["Harpoon Crossbow"]
local v443 = {
    ["ItemName"] = "Crossbow",
    ["ImageHighResolution"] = v442.ImageHighResolution
}
v_u_81("Skin", "Rare", "Harpoon Crossbow", v442.Image, 3, nil, nil, nil, v443)
local v444 = v_u_6.ViewModels.Hourglass
local v445 = {
    ["ItemName"] = "Smoke Grenade",
    ["ImageHighResolution"] = v444.ImageHighResolution
}
v_u_81("Skin", "Rare", "Hourglass", v444.Image, 3, nil, nil, nil, v445)
local v446 = v_u_6.ViewModels["Hydro Rifle"]
local v447 = {
    ["ItemName"] = "Energy Rifle",
    ["ImageHighResolution"] = v446.ImageHighResolution
}
v_u_81("Skin", "Rare", "Hydro Rifle", v446.Image, 3, nil, nil, nil, v447)
local v448 = v_u_6.ViewModels["Lava Lamp"]
local v449 = {
    ["ItemName"] = "Molotov",
    ["ImageHighResolution"] = v448.ImageHighResolution
}
v_u_81("Skin", "Rare", "Lava Lamp", v448.Image, 3, nil, nil, nil, v449)
local v450 = v_u_6.ViewModels.Paintbrush
local v451 = {
    ["ItemName"] = "Trowel",
    ["ImageHighResolution"] = v450.ImageHighResolution
}
v_u_81("Skin", "Rare", "Paintbrush", v450.Image, 3, nil, nil, nil, v451)
local v452 = v_u_6.ViewModels["Sakura Scythe"]
local v453 = {
    ["ItemName"] = "Scythe",
    ["ImageHighResolution"] = v452.ImageHighResolution
}
v_u_81("Skin", "Rare", "Sakura Scythe", v452.Image, 3, nil, nil, nil, v453)
local v454 = v_u_6.ViewModels["Squid Launcher"]
local v455 = {
    ["ItemName"] = "RPG",
    ["ImageHighResolution"] = v454.ImageHighResolution
}
v_u_81("Skin", "Rare", "Squid Launcher", v454.Image, 3, nil, nil, nil, v455)
local v456 = v_u_6.ViewModels["Stellar Katana"]
local v457 = {
    ["ItemName"] = "Katana",
    ["ImageHighResolution"] = v456.ImageHighResolution
}
v_u_81("Skin", "Rare", "Stellar Katana", v456.Image, 3, nil, nil, nil, v457)
local v458 = v_u_6.ViewModels["Air Horn"]
local v459 = {
    ["ItemName"] = "War Horn",
    ["ImageHighResolution"] = v458.ImageHighResolution
}
v_u_81("Skin", "Rare", "Air Horn", v458.Image, 3, nil, nil, nil, v459)
local v460 = v_u_6.ViewModels.Masterpiece
local v461 = {
    ["ItemName"] = "Riot Shield",
    ["ImageHighResolution"] = v460.ImageHighResolution
}
v_u_81("Skin", "Rare", "Masterpiece", v460.Image, 3, nil, nil, nil, v461)
local v462 = v_u_6.ViewModels["Cerulean Axe"]
local v463 = {
    ["ItemName"] = "Battle Axe",
    ["ImageHighResolution"] = v462.ImageHighResolution
}
v_u_81("Skin", "Rare", "Cerulean Axe", v462.Image, 3, nil, nil, nil, v463)
local v464 = v_u_6.ViewModels["Hydro Pistols"]
local v465 = {
    ["ItemName"] = "Energy Pistols",
    ["ImageHighResolution"] = v464.ImageHighResolution
}
v_u_81("Skin", "Rare", "Hydro Pistols", v464.Image, 3, nil, nil, nil, v465)
local v466 = v_u_6.ViewModels["Shady Chicken Sandwich"]
local v467 = {
    ["ItemName"] = "Jump Pad",
    ["ImageHighResolution"] = v466.ImageHighResolution
}
v_u_81("Skin", "Rare", "Shady Chicken Sandwich", v466.Image, 3, nil, nil, nil, v467)
local v468 = v_u_6.ViewModels["Violin Crossbow"]
local v469 = {
    ["ItemName"] = "Crossbow",
    ["ImageHighResolution"] = v468.ImageHighResolution
}
v_u_81("Skin", "Rare", "Violin Crossbow", v468.Image, 3, nil, nil, nil, v469)
local v470 = v_u_6.ViewModels["Electropunk Distortion"]
local v471 = {
    ["ItemName"] = "Distortion",
    ["ImageHighResolution"] = v470.ImageHighResolution
}
v_u_81("Skin", "Rare", "Electropunk Distortion", v470.Image, 3, nil, nil, nil, v471)
local v472 = v_u_6.ViewModels["Electropunk Warper"]
local v473 = {
    ["ItemName"] = "Warper",
    ["ImageHighResolution"] = v472.ImageHighResolution
}
v_u_81("Skin", "Rare", "Electropunk Warper", v472.Image, 3, nil, nil, nil, v473)
local v474 = v_u_6.ViewModels["Unstable Warpstone"]
local v475 = {
    ["ItemName"] = "Warpstone",
    ["ImageHighResolution"] = v474.ImageHighResolution
}
v_u_81("Skin", "Rare", "Unstable Warpstone", v474.Image, 3, nil, nil, nil, v475)
local v476 = v_u_6.ViewModels["Boneclaw Spray"]
local v477 = {
    ["ItemName"] = "Spray",
    ["ImageHighResolution"] = v476.ImageHighResolution
}
v_u_81("Skin", "Rare", "Boneclaw Spray", v476.Image, 3, nil, nil, nil, v477)
local v478 = v_u_6.ViewModels["Boneclaw Horn"]
local v479 = {
    ["ItemName"] = "War Horn",
    ["ImageHighResolution"] = v478.ImageHighResolution
}
v_u_81("Skin", "Rare", "Boneclaw Horn", v478.Image, 3, nil, nil, nil, v479)
local v480 = v_u_6.ViewModels["Bat Daggers"]
local v481 = {
    ["ItemName"] = "Daggers",
    ["ImageHighResolution"] = v480.ImageHighResolution
}
v_u_81("Skin", "Rare", "Bat Daggers", v480.Image, 3, nil, nil, nil, v481)
local v482 = v_u_6.ViewModels["Potion Satchel"]
local v483 = {
    ["ItemName"] = "Satchel",
    ["ImageHighResolution"] = v482.ImageHighResolution
}
v_u_81("Skin", "Rare", "Potion Satchel", v482.Image, 3, nil, nil, nil, v483)
local v484 = v_u_6.ViewModels["Jolly Man"]
local v485 = {
    ["ItemName"] = "Jump Pad",
    ["ImageHighResolution"] = v484.ImageHighResolution
}
v_u_81("Skin", "Rare", "Jolly Man", v484.Image, 3, nil, nil, nil, v485)
local v486 = v_u_6.ViewModels["Plasma Distortion"]
local v487 = {
    ["ItemName"] = "Distortion",
    ["ImageHighResolution"] = v486.ImageHighResolution
}
v_u_81("Skin", "Rare", "Plasma Distortion", v486.Image, 3, nil, nil, nil, v487)
local v488 = v_u_6.ViewModels["Magma Distortion"]
local v489 = {
    ["ItemName"] = "Distortion",
    ["ImageHighResolution"] = v488.ImageHighResolution
}
v_u_81("Skin", "Rare", "Magma Distortion", v488.Image, 3, nil, nil, nil, v489)
local v490 = v_u_6.ViewModels.Sleighstortion
local v491 = {
    ["ItemName"] = "Distortion",
    ["ImageHighResolution"] = v490.ImageHighResolution
}
v_u_81("Skin", "Rare", "Sleighstortion", v490.Image, 3, nil, nil, nil, v491)
local v492 = v_u_6.ViewModels["Glitter Warper"]
local v493 = {
    ["ItemName"] = "Warper",
    ["ImageHighResolution"] = v492.ImageHighResolution
}
v_u_81("Skin", "Rare", "Glitter Warper", v492.Image, 3, nil, nil, nil, v493)
local v494 = v_u_6.ViewModels["Frost Warper"]
local v495 = {
    ["ItemName"] = "Warper",
    ["ImageHighResolution"] = v494.ImageHighResolution
}
v_u_81("Skin", "Rare", "Frost Warper", v494.Image, 3, nil, nil, nil, v495)
local v496 = v_u_6.ViewModels["Electropunk Warpstone"]
local v497 = {
    ["ItemName"] = "Warpstone",
    ["ImageHighResolution"] = v496.ImageHighResolution
}
v_u_81("Skin", "Rare", "Electropunk Warpstone", v496.Image, 3, nil, nil, nil, v497)
local v498 = v_u_6.ViewModels["Sleigh Maul"]
local v499 = {
    ["ItemName"] = "Maul",
    ["ImageHighResolution"] = v498.ImageHighResolution
}
v_u_81("Skin", "Rare", "Sleigh Maul", v498.Image, 3, nil, nil, nil, v499)
local v500 = v_u_6.ViewModels.Saber
local v501 = {
    ["ItemName"] = "Katana",
    ["ImageHighResolution"] = v500.ImageHighResolution
}
v_u_81("Skin", "Legendary", "Saber", v500.Image, 3, nil, nil, nil, v501)
local v502 = v_u_6.ViewModels["Nuke Launcher"]
local v503 = {
    ["ItemName"] = "RPG",
    ["ImageHighResolution"] = v502.ImageHighResolution
}
v_u_81("Skin", "Legendary", "Nuke Launcher", v502.Image, 3, nil, nil, nil, v503)
local v504 = v_u_6.ViewModels["Whoopee Cushion"]
local v505 = {
    ["ItemName"] = "Grenade",
    ["ImageHighResolution"] = v504.ImageHighResolution
}
v_u_81("Skin", "Legendary", "Whoopee Cushion", v504.Image, 3, nil, nil, nil, v505)
local v506 = v_u_6.ViewModels["Disco Ball"]
local v507 = {
    ["ItemName"] = "Flashbang",
    ["ImageHighResolution"] = v506.ImageHighResolution
}
v_u_81("Skin", "Legendary", "Disco Ball", v506.Image, 3, nil, nil, nil, v507)
local v508 = v_u_6.ViewModels.Singularity
local v509 = {
    ["ItemName"] = "Exogun",
    ["ImageHighResolution"] = v508.ImageHighResolution
}
v_u_81("Skin", "Legendary", "Singularity", v508.Image, 3, nil, nil, nil, v509)
local v510 = v_u_6.ViewModels["Pixel Sniper"]
local v511 = {
    ["ItemName"] = "Sniper",
    ["ImageHighResolution"] = v510.ImageHighResolution
}
v_u_81("Skin", "Legendary", "Pixel Sniper", v510.Image, 3, nil, nil, nil, v511)
local v512 = v_u_6.ViewModels["Don\'t Press"]
local v513 = {
    ["ItemName"] = "Subspace Tripmine",
    ["ImageHighResolution"] = v512.ImageHighResolution
}
v_u_81("Skin", "Legendary", "Don\'t Press", v512.Image, 3, nil, nil, nil, v513)
local v514 = v_u_6.ViewModels["Lasergun 3000"]
local v515 = {
    ["ItemName"] = "Minigun",
    ["ImageHighResolution"] = v514.ImageHighResolution
}
v_u_81("Skin", "Legendary", "Lasergun 3000", v514.Image, 3, nil, nil, nil, v515)
local v516 = v_u_6.ViewModels["Firework Gun"]
local v517 = {
    ["ItemName"] = "Flare Gun",
    ["ImageHighResolution"] = v516.ImageHighResolution
}
v_u_81("Skin", "Legendary", "Firework Gun", v516.Image, 3, nil, nil, nil, v517)
local v518 = v_u_6.ViewModels["Pixel Flamethrower"]
local v519 = {
    ["ItemName"] = "Flamethrower",
    ["ImageHighResolution"] = v518.ImageHighResolution
}
v_u_81("Skin", "Legendary", "Pixel Flamethrower", v518.Image, 3, nil, nil, nil, v519)
local v520 = v_u_6.ViewModels.Swashbuckler
local v521 = {
    ["ItemName"] = "Grenade Launcher",
    ["ImageHighResolution"] = v520.ImageHighResolution
}
v_u_81("Skin", "Legendary", "Swashbuckler", v520.Image, 3, nil, nil, nil, v521)
local v522 = v_u_6.ViewModels["Electro Rifle"]
local v523 = {
    ["ItemName"] = "Burst Rifle",
    ["ImageHighResolution"] = v522.ImageHighResolution
}
v_u_81("Skin", "Legendary", "Electro Rifle", v522.Image, 3, nil, nil, nil, v523)
local v524 = v_u_6.ViewModels["Balloon Shotgun"]
local v525 = {
    ["ItemName"] = "Shotgun",
    ["ImageHighResolution"] = v524.ImageHighResolution
}
v_u_81("Skin", "Legendary", "Balloon Shotgun", v524.Image, 3, nil, nil, nil, v525)
local v526 = v_u_6.ViewModels["Emoji Cloud"]
local v527 = {
    ["ItemName"] = "Smoke Grenade",
    ["ImageHighResolution"] = v526.ImageHighResolution
}
v_u_81("Skin", "Legendary", "Emoji Cloud", v526.Image, 3, nil, nil, nil, v527)
local v528 = v_u_6.ViewModels.Sandwich
local v529 = {
    ["ItemName"] = "Medkit",
    ["ImageHighResolution"] = v528.ImageHighResolution
}
v_u_81("Skin", "Legendary", "Sandwich", v528.Image, 3, nil, nil, nil, v529)
local v530 = v_u_6.ViewModels["Temporal Ray"]
local v531 = {
    ["ItemName"] = "Freeze Ray",
    ["ImageHighResolution"] = v530.ImageHighResolution
}
v_u_81("Skin", "Legendary", "Temporal Ray", v530.Image, 3, nil, nil, nil, v531)
local v532 = v_u_6.ViewModels["Electro Uzi"]
local v533 = {
    ["ItemName"] = "Uzi",
    ["ImageHighResolution"] = v532.ImageHighResolution
}
v_u_81("Skin", "Legendary", "Electro Uzi", v532.Image, 3, nil, nil, nil, v533)
local v534 = v_u_6.ViewModels["Hand Gun"]
local v535 = {
    ["ItemName"] = "Handgun",
    ["ImageHighResolution"] = v534.ImageHighResolution
}
v_u_81("Skin", "Legendary", "Hand Gun", v534.Image, 3, nil, nil, nil, v535)
local v536 = v_u_6.ViewModels.Sheriff
local v537 = {
    ["ItemName"] = "Revolver",
    ["ImageHighResolution"] = v536.ImageHighResolution
}
v_u_81("Skin", "Legendary", "Sheriff", v536.Image, 3, nil, nil, nil, v537)
local v538 = v_u_6.ViewModels.Karambit
local v539 = {
    ["ItemName"] = "Knife",
    ["ImageHighResolution"] = v538.ImageHighResolution
}
v_u_81("Skin", "Legendary", "Karambit", v538.Image, 3, nil, nil, nil, v539)
local v540 = v_u_6.ViewModels["Spaceship Launcher"]
local v541 = {
    ["ItemName"] = "RPG",
    ["ImageHighResolution"] = v540.ImageHighResolution
}
v_u_81("Skin", "Legendary", "Spaceship Launcher", v540.Image, 3, nil, nil, nil, v541)
local v542 = v_u_6.ViewModels.Handsaws
local v543 = {
    ["ItemName"] = "Chainsaw",
    ["ImageHighResolution"] = v542.ImageHighResolution
}
v_u_81("Skin", "Legendary", "Handsaws", v542.Image, 3, nil, nil, nil, v543)
local v544 = v_u_6.ViewModels.Camera
local v545 = {
    ["ItemName"] = "Flashbang",
    ["ImageHighResolution"] = v544.ImageHighResolution
}
v_u_81("Skin", "Legendary", "Camera", v544.Image, 3, nil, nil, nil, v545)
local v546 = v_u_6.ViewModels["Boba Gun"]
local v547 = {
    ["ItemName"] = "Paintball Gun",
    ["ImageHighResolution"] = v546.ImageHighResolution
}
v_u_81("Skin", "Legendary", "Boba Gun", v546.Image, 3, nil, nil, nil, v547)
local v548 = v_u_6.ViewModels["Hyper Sniper"]
local v549 = {
    ["ItemName"] = "Sniper",
    ["ImageHighResolution"] = v548.ImageHighResolution
}
v_u_81("Skin", "Legendary", "Hyper Sniper", v548.Image, 3, nil, nil, nil, v549)
local v550 = v_u_6.ViewModels["Hyper Shotgun"]
local v551 = {
    ["ItemName"] = "Shotgun",
    ["ImageHighResolution"] = v550.ImageHighResolution
}
v_u_81("Skin", "Legendary", "Hyper Shotgun", v550.Image, 3, nil, nil, nil, v551)
local v552 = v_u_6.ViewModels.Laptop
local v553 = {
    ["ItemName"] = "Medkit",
    ["ImageHighResolution"] = v552.ImageHighResolution
}
v_u_81("Skin", "Legendary", "Laptop", v552.Image, 3, nil, nil, nil, v553)
local v554 = v_u_6.ViewModels["Pixel Minigun"]
local v555 = {
    ["ItemName"] = "Minigun",
    ["ImageHighResolution"] = v554.ImageHighResolution
}
v_u_81("Skin", "Legendary", "Pixel Minigun", v554.Image, 3, nil, nil, nil, v555)
local v556 = v_u_6.ViewModels.AUG
local v557 = {
    ["ItemName"] = "Assault Rifle",
    ["ImageHighResolution"] = v556.ImageHighResolution
}
v_u_81("Skin", "Legendary", "AUG", v556.Image, 3, nil, nil, nil, v557)
local v558 = v_u_6.ViewModels["Pixel Burst"]
local v559 = {
    ["ItemName"] = "Burst Rifle",
    ["ImageHighResolution"] = v558.ImageHighResolution
}
v_u_81("Skin", "Legendary", "Pixel Burst", v558.Image, 3, nil, "Included in the Pixel Bundle", nil, v559)
local v560 = v_u_6.ViewModels["Pixel Handgun"]
local v561 = {
    ["ItemName"] = "Handgun",
    ["ImageHighResolution"] = v560.ImageHighResolution
}
v_u_81("Skin", "Legendary", "Pixel Handgun", v560.Image, 3, nil, "Included in the Pixel Bundle", nil, v561)
local v562 = v_u_6.ViewModels["Pixel Katana"]
local v563 = {
    ["ItemName"] = "Katana",
    ["ImageHighResolution"] = v562.ImageHighResolution
}
v_u_81("Skin", "Legendary", "Pixel Katana", v562.Image, 3, nil, "Included in the Pixel Bundle", nil, v563)
local v564 = v_u_6.ViewModels["Pixel Flashbang"]
local v565 = {
    ["ItemName"] = "Flashbang",
    ["ImageHighResolution"] = v564.ImageHighResolution
}
v_u_81("Skin", "Legendary", "Pixel Flashbang", v564.Image, 3, nil, "Included in the Pixel Bundle", nil, v565)
local v566 = v_u_6.ViewModels.Eyeball
local v567 = {
    ["ItemName"] = "Smoke Grenade",
    ["ImageHighResolution"] = v566.ImageHighResolution
}
v_u_81("Skin", "Legendary", "Eyeball", v566.Image, 3, nil, nil, nil, v567)
local v568 = v_u_6.ViewModels["Spider Ray"]
local v569 = {
    ["ItemName"] = "Freeze Ray",
    ["ImageHighResolution"] = v568.ImageHighResolution
}
v_u_81("Skin", "Legendary", "Spider Ray", v568.Image, 3, nil, nil, nil, v569)
local v570 = v_u_6.ViewModels["Bucket of Candy"]
local v571 = {
    ["ItemName"] = "Medkit",
    ["ImageHighResolution"] = v570.ImageHighResolution
}
v_u_81("Skin", "Legendary", "Bucket of Candy", v570.Image, 3, nil, nil, nil, v571)
local v572 = v_u_6.ViewModels["Pumpkin Launcher"]
local v573 = {
    ["ItemName"] = "RPG",
    ["ImageHighResolution"] = v572.ImageHighResolution
}
v_u_81("Skin", "Legendary", "Pumpkin Launcher", v572.Image, 3, nil, nil, nil, v573)
local v574 = v_u_6.ViewModels["Vexed Flare Gun"]
local v575 = {
    ["ItemName"] = "Flare Gun",
    ["ImageHighResolution"] = v574.ImageHighResolution
}
v_u_81("Skin", "Legendary", "Vexed Flare Gun", v574.Image, 3, nil, nil, nil, v575)
local v576 = v_u_6.ViewModels["Vexed Candle"]
local v577 = {
    ["ItemName"] = "Molotov",
    ["ImageHighResolution"] = v576.ImageHighResolution
}
v_u_81("Skin", "Legendary", "Vexed Candle", v576.Image, 3, nil, nil, nil, v577)
local v578 = v_u_6.ViewModels["Soul Grenade"]
local v579 = {
    ["ItemName"] = "Grenade",
    ["ImageHighResolution"] = v578.ImageHighResolution
}
v_u_81("Skin", "Legendary", "Soul Grenade", v578.Image, 3, nil, nil, nil, v579)
local v580 = v_u_6.ViewModels["Skull Launcher"]
local v581 = {
    ["ItemName"] = "Grenade Launcher",
    ["ImageHighResolution"] = v580.ImageHighResolution
}
v_u_81("Skin", "Legendary", "Skull Launcher", v580.Image, 3, nil, nil, nil, v581)
local v582 = v_u_6.ViewModels.Buzzsaw
local v583 = {
    ["ItemName"] = "Chainsaw",
    ["ImageHighResolution"] = v582.ImageHighResolution
}
v_u_81("Skin", "Legendary", "Buzzsaw", v582.Image, 3, nil, nil, nil, v583)
local v584 = v_u_6.ViewModels["Pixel Crossbow"]
local v585 = {
    ["ItemName"] = "Crossbow",
    ["ImageHighResolution"] = v584.ImageHighResolution
}
v_u_81("Skin", "Legendary", "Pixel Crossbow", v584.Image, 3, nil, nil, nil, v585)
local v586 = v_u_6.ViewModels["Hyper Gunblade"]
local v587 = {
    ["ItemName"] = "Gunblade",
    ["ImageHighResolution"] = v586.ImageHighResolution
}
v_u_81("Skin", "Legendary", "Hyper Gunblade", v586.Image, 3, nil, nil, nil, v587)
local v588 = v_u_6.ViewModels["The Shred"]
local v589 = {
    ["ItemName"] = "Battle Axe",
    ["ImageHighResolution"] = v588.ImageHighResolution
}
v_u_81("Skin", "Legendary", "The Shred", v588.Image, 3, nil, nil, nil, v589)
local v590 = v_u_6.ViewModels["Gingerbread AUG"]
local v591 = {
    ["ItemName"] = "Assault Rifle",
    ["ImageHighResolution"] = v590.ImageHighResolution
}
v_u_81("Skin", "Legendary", "Gingerbread AUG", v590.Image, 3, nil, nil, nil, v591)
local v592 = v_u_6.ViewModels["Peppermint Sheriff"]
local v593 = {
    ["ItemName"] = "Revolver",
    ["ImageHighResolution"] = v592.ImageHighResolution
}
v_u_81("Skin", "Legendary", "Peppermint Sheriff", v592.Image, 3, nil, nil, nil, v593)
local v594 = v_u_6.ViewModels["Firework Launcher"]
local v595 = {
    ["ItemName"] = "RPG",
    ["ImageHighResolution"] = v594.ImageHighResolution
}
v_u_81("Skin", "Legendary", "Firework Launcher", v594.Image, 3, nil, nil, nil, v595)
local v596 = v_u_6.ViewModels["Festive Buzzsaw"]
local v597 = {
    ["ItemName"] = "Chainsaw",
    ["ImageHighResolution"] = v596.ImageHighResolution
}
v_u_81("Skin", "Legendary", "Festive Buzzsaw", v596.Image, 3, nil, nil, nil, v597)
local v598 = v_u_6.ViewModels["Milk & Cookies"]
local v599 = {
    ["ItemName"] = "Medkit",
    ["ImageHighResolution"] = v598.ImageHighResolution
}
v_u_81("Skin", "Legendary", "Milk & Cookies", v598.Image, 3, nil, nil, nil, v599)
local v600 = v_u_6.ViewModels["Hot Coals"]
local v601 = {
    ["ItemName"] = "Molotov",
    ["ImageHighResolution"] = v600.ImageHighResolution
}
v_u_81("Skin", "Legendary", "Hot Coals", v600.Image, 3, nil, nil, nil, v601)
local v602 = v_u_6.ViewModels["Dev-in-the-Box"]
local v603 = {
    ["ItemName"] = "Subspace Tripmine",
    ["ImageHighResolution"] = v602.ImageHighResolution
}
v_u_81("Skin", "Legendary", "Dev-in-the-Box", v602.Image, 3, nil, nil, nil, v603)
local v604 = v_u_6.ViewModels["Candy Cane"]
local v605 = {
    ["ItemName"] = "Knife",
    ["ImageHighResolution"] = v604.ImageHighResolution
}
v_u_81("Skin", "Legendary", "Candy Cane", v604.Image, 3, nil, nil, nil, v605)
local v606 = v_u_6.ViewModels["Balloon Shorty"]
local v607 = {
    ["ItemName"] = "Shorty",
    ["ImageHighResolution"] = v606.ImageHighResolution
}
v_u_81("Skin", "Legendary", "Balloon Shorty", v606.Image, 3, nil, nil, nil, v607)
local v608 = v_u_6.ViewModels["Void Pistols"]
local v609 = {
    ["ItemName"] = "Energy Pistols",
    ["ImageHighResolution"] = v608.ImageHighResolution
}
v_u_81("Skin", "Legendary", "Void Pistols", v608.Image, 3, nil, nil, nil, v609)
local v610 = v_u_6.ViewModels["Money Gun"]
local v611 = {
    ["ItemName"] = "Uzi",
    ["ImageHighResolution"] = v610.ImageHighResolution
}
v_u_81("Skin", "Legendary", "Money Gun", v610.Image, 3, nil, nil, nil, v611)
local v612 = v_u_6.ViewModels.Medkitty
local v613 = {
    ["ItemName"] = "Medkit",
    ["ImageHighResolution"] = v612.ImageHighResolution
}
v_u_81("Skin", "Legendary", "Medkitty", v612.Image, 3, nil, nil, nil, v613)
local v614 = v_u_6.ViewModels.Balisong
local v615 = {
    ["ItemName"] = "Knife",
    ["ImageHighResolution"] = v614.ImageHighResolution
}
v_u_81("Skin", "Legendary", "Balisong", v614.Image, 3, nil, nil, nil, v615)
local v616 = v_u_6.ViewModels["Event Horizon"]
local v617 = {
    ["ItemName"] = "Sniper",
    ["ImageHighResolution"] = v616.ImageHighResolution
}
v_u_81("Skin", "Legendary", "Event Horizon", v616.Image, 3, nil, nil, nil, v617)
local v618 = v_u_6.ViewModels["Banana Flare"]
local v619 = {
    ["ItemName"] = "Flare Gun",
    ["ImageHighResolution"] = v618.ImageHighResolution
}
v_u_81("Skin", "Legendary", "Banana Flare", v618.Image, 3, nil, nil, nil, v619)
local v620 = v_u_6.ViewModels["Fighter Jet"]
local v621 = {
    ["ItemName"] = "Minigun",
    ["ImageHighResolution"] = v620.ImageHighResolution
}
v_u_81("Skin", "Legendary", "Fighter Jet", v620.Image, 3, nil, nil, nil, v621)
local v622 = v_u_6.ViewModels.Harp
local v623 = {
    ["ItemName"] = "Slingshot",
    ["ImageHighResolution"] = v622.ImageHighResolution
}
v_u_81("Skin", "Legendary", "Harp", v622.Image, 3, nil, nil, nil, v623)
local v624 = v_u_6.ViewModels.Repulsor
local v625 = {
    ["ItemName"] = "Exogun",
    ["ImageHighResolution"] = v624.ImageHighResolution
}
v_u_81("Skin", "Legendary", "Repulsor", v624.Image, 3, nil, nil, nil, v625)
local v626 = v_u_6.ViewModels["Tommy Gun"]
local v627 = {
    ["ItemName"] = "Assault Rifle",
    ["ImageHighResolution"] = v626.ImageHighResolution
}
v_u_81("Skin", "Legendary", "Tommy Gun", v626.Image, 3, nil, nil, nil, v627)
local v628 = v_u_6.ViewModels.FAMAS
local v629 = {
    ["ItemName"] = "Burst Rifle",
    ["ImageHighResolution"] = v628.ImageHighResolution
}
v_u_81("Skin", "Legendary", "FAMAS", v628.Image, 3, nil, nil, nil, v629)
local v630 = v_u_6.ViewModels.Peppergun
local v631 = {
    ["ItemName"] = "Revolver",
    ["ImageHighResolution"] = v630.ImageHighResolution
}
v_u_81("Skin", "Legendary", "Peppergun", v630.Image, 3, nil, nil, nil, v631)
local v632 = v_u_6.ViewModels["Mega Drill"]
local v633 = {
    ["ItemName"] = "Chainsaw",
    ["ImageHighResolution"] = v632.ImageHighResolution
}
v_u_81("Skin", "Legendary", "Mega Drill", v632.Image, 3, nil, nil, nil, v633)
local v634 = v_u_6.ViewModels["Spray Bottle"]
local v635 = {
    ["ItemName"] = "Spray",
    ["ImageHighResolution"] = v634.ImageHighResolution
}
v_u_81("Skin", "Legendary", "Spray Bottle", v634.Image, 3, nil, nil, nil, v635)
local v636 = v_u_6.ViewModels["Void Rifle"]
local v637 = {
    ["ItemName"] = "Energy Rifle",
    ["ImageHighResolution"] = v636.ImageHighResolution
}
v_u_81("Skin", "Legendary", "Void Rifle", v636.Image, 3, nil, nil, nil, v637)
local v638 = v_u_6.ViewModels.Gunsaw
local v639 = {
    ["ItemName"] = "Gunblade",
    ["ImageHighResolution"] = v638.ImageHighResolution
}
v_u_81("Skin", "Legendary", "Gunsaw", v638.Image, 3, nil, nil, nil, v639)
local v640 = v_u_6.ViewModels["Soul Pistols"]
local v641 = {
    ["ItemName"] = "Energy Pistols",
    ["ImageHighResolution"] = v640.ImageHighResolution
}
v_u_81("Skin", "Legendary", "Soul Pistols", v640.Image, 3, nil, nil, nil, v641)
local v642 = v_u_6.ViewModels["Soul Rifle"]
local v643 = {
    ["ItemName"] = "Energy Rifle",
    ["ImageHighResolution"] = v642.ImageHighResolution
}
v_u_81("Skin", "Legendary", "Soul Rifle", v642.Image, 3, nil, nil, nil, v643)
local v644 = v_u_6.ViewModels["Mimic Axe"]
local v645 = {
    ["ItemName"] = "Battle Axe",
    ["ImageHighResolution"] = v644.ImageHighResolution
}
v_u_81("Skin", "Legendary", "Mimic Axe", v644.Image, 3, nil, nil, nil, v645)
local v646 = v_u_6.ViewModels["Experiment W4"]
local v647 = {
    ["ItemName"] = "Warper",
    ["ImageHighResolution"] = v646.ImageHighResolution
}
v_u_81("Skin", "Legendary", "Experiment W4", v646.Image, 3, nil, nil, nil, v647)
local v648 = v_u_6.ViewModels["Experiment D15"]
local v649 = {
    ["ItemName"] = "Distortion",
    ["ImageHighResolution"] = v648.ImageHighResolution
}
v_u_81("Skin", "Legendary", "Experiment D15", v648.Image, 3, nil, nil, nil, v649)
local v650 = v_u_6.ViewModels["Hotel Bell"]
local v651 = {
    ["ItemName"] = "Warper",
    ["ImageHighResolution"] = v650.ImageHighResolution
}
v_u_81("Skin", "Legendary", "Hotel Bell", v650.Image, 3, nil, nil, nil, v651)
local v652 = v_u_6.ViewModels["Teleport Disc"]
local v653 = {
    ["ItemName"] = "Warpstone",
    ["ImageHighResolution"] = v652.ImageHighResolution
}
v_u_81("Skin", "Legendary", "Teleport Disc", v652.Image, 3, nil, nil, nil, v653)
local v654 = v_u_6.ViewModels["Arcane Warper"]
local v655 = {
    ["ItemName"] = "Warper",
    ["ImageHighResolution"] = v654.ImageHighResolution
}
v_u_81("Skin", "Legendary", "Arcane Warper", v654.Image, 3, nil, nil, nil, v655)
local v656 = v_u_6.ViewModels.Warpstar
local v657 = {
    ["ItemName"] = "Warpstone",
    ["ImageHighResolution"] = v656.ImageHighResolution
}
v_u_81("Skin", "Legendary", "Warpstar", v656.Image, 3, nil, nil, nil, v657)
local v658 = v_u_6.ViewModels.RPKEY
local v659 = {
    ["ItemName"] = "RPG",
    ["ImageHighResolution"] = v658.ImageHighResolution
}
v_u_81("Skin", "Mythical", "RPKEY", v658.Image, 3, nil, "Used to be included in the Legendary Key Bundle", nil, v659)
local v660 = v_u_6.ViewModels.Keythe
local v661 = {
    ["ItemName"] = "Scythe",
    ["ImageHighResolution"] = v660.ImageHighResolution
}
v_u_81("Skin", "Mythical", "Keythe", v660.Image, 3, nil, "Used to be included in the Legendary Key Bundle", nil, v661)
local v662 = v_u_6.ViewModels.Keyper
local v663 = {
    ["ItemName"] = "Sniper",
    ["ImageHighResolution"] = v662.ImageHighResolution
}
v_u_81("Skin", "Mythical", "Keyper", v662.Image, 3, nil, "Used to be included in the Legendary Key Bundle", nil, v663)
local v664 = v_u_6.ViewModels["AKEY-47"]
local v665 = {
    ["ItemName"] = "Assault Rifle",
    ["ImageHighResolution"] = v664.ImageHighResolution
}
v_u_81("Skin", "Mythical", "AKEY-47", v664.Image, 3, nil, "Used to be included in the Legendary Key Bundle", nil, v665)
local v666 = v_u_6.ViewModels["Crystal Daggers"]
local v667 = {
    ["ItemName"] = "Daggers",
    ["ImageHighResolution"] = v666.ImageHighResolution
}
v_u_81("Skin", "Mythical", "Crystal Daggers", v666.Image, 3, nil, "Used to be included in the Legendary Crystal Bundle", nil, v667)
local v668 = v_u_6.ViewModels.Keytana
local v669 = {
    ["ItemName"] = "Katana",
    ["ImageHighResolution"] = v668.ImageHighResolution
}
v_u_81("Skin", "Mythical", "Keytana", v668.Image, 3, nil, "Used to be included in the Legendary Key Bundle", nil, v669)
local v670 = v_u_6.ViewModels.Keyvolver
local v671 = {
    ["ItemName"] = "Revolver",
    ["ImageHighResolution"] = v670.ImageHighResolution
}
v_u_81("Skin", "Mythical", "Keyvolver", v670.Image, 3, nil, "Used to be included in the Ultra Key Bundle", nil, v671)
local v672 = v_u_6.ViewModels.Shotkey
local v673 = {
    ["ItemName"] = "Shotgun",
    ["ImageHighResolution"] = v672.ImageHighResolution
}
v_u_81("Skin", "Mythical", "Shotkey", v672.Image, 3, nil, "Used to be included in the Legendary Key Bundle", nil, v673)
local v674 = v_u_6.ViewModels.Keyzi
local v675 = {
    ["ItemName"] = "Uzi",
    ["ImageHighResolution"] = v674.ImageHighResolution
}
v_u_81("Skin", "Mythical", "Keyzi", v674.Image, 3, nil, "Used to be included in the Ultra Key Bundle", nil, v675)
local v676 = v_u_6.ViewModels["Key Bow"]
local v677 = {
    ["ItemName"] = "Bow",
    ["ImageHighResolution"] = v676.ImageHighResolution
}
v_u_81("Skin", "Mythical", "Key Bow", v676.Image, 3, nil, "Used to be included in the Legendary Key Bundle", nil, v677)
local v678 = v_u_6.ViewModels.Keynade
local v679 = {
    ["ItemName"] = "Grenade",
    ["ImageHighResolution"] = v678.ImageHighResolution
}
v_u_81("Skin", "Mythical", "Keynade", v678.Image, 3, nil, "Used to be included in the Ultra Key Bundle", nil, v679)
local v680 = v_u_6.ViewModels["Arch Katana"]
local v681 = {
    ["ItemName"] = "Katana",
    ["ImageHighResolution"] = v680.ImageHighResolution
}
v_u_81("Skin", "Mythical", "Arch Katana", v680.Image, 3, nil, "Given to the Top 200 players from Ranked Season 0", nil, v681)
local v682 = v_u_6.ViewModels["Keyst Rifle"]
local v683 = {
    ["ItemName"] = "Burst Rifle",
    ["ImageHighResolution"] = v682.ImageHighResolution
}
v_u_81("Skin", "Mythical", "Keyst Rifle", v682.Image, 3, nil, "Used to be included in the Legendary Key Bundle", nil, v683)
local v684 = v_u_6.ViewModels["Keyttle Axe"]
local v685 = {
    ["ItemName"] = "Battle Axe",
    ["ImageHighResolution"] = v684.ImageHighResolution
}
v_u_81("Skin", "Mythical", "Keyttle Axe", v684.Image, 3, nil, "Used to be included in the Ultra Key Bundle", nil, v685)
local v686 = v_u_6.ViewModels.Warpeye
local v687 = {
    ["ItemName"] = "Warpstone",
    ["ImageHighResolution"] = v686.ImageHighResolution
}
v_u_81("Skin", "Mythical", "Warpeye", v686.Image, 3, nil, "Used to be included in the Legendary Candy Bundle", nil, v687)
local v688 = v_u_6.ViewModels["Arch Crossbow"]
local v689 = {
    ["ItemName"] = "Crossbow",
    ["ImageHighResolution"] = v688.ImageHighResolution
}
v_u_81("Skin", "Mythical", "Arch Crossbow", v688.Image, 3, nil, "Given to the Top 200 players from Ranked Season 1", nil, v689)
local v690 = v_u_6.ViewModels.Keyrambit
local v691 = {
    ["ItemName"] = "Knife",
    ["ImageHighResolution"] = v690.ImageHighResolution
}
v_u_81("Skin", "Mythical", "Keyrambit", v690.Image, 3, nil, "Included in the Legendary Key Bundle", nil, v691)
local v692 = v_u_6.ViewModels.Keylisong
local v693 = {
    ["ItemName"] = "Knife",
    ["ImageHighResolution"] = v692.ImageHighResolution
}
v_u_81("Skin", "Mythical", "Keylisong", v692.Image, 3, nil, "Included in the Legendary Key Bundle", nil, v693)
local v694 = v_u_6.ViewModels.Keynais
local v695 = {
    ["ItemName"] = "Daggers",
    ["ImageHighResolution"] = v694.ImageHighResolution
}
v_u_81("Skin", "Mythical", "Keynais", v694.Image, 3, nil, "Included in the Ultra Key Bundle", nil, v695)
local v696 = v_u_6.ViewModels["Crystal Katana"]
local v697 = {
    ["ItemName"] = "Katana",
    ["ImageHighResolution"] = v696.ImageHighResolution
}
v_u_81("Skin", "Mythical", "Crystal Katana", v696.Image, 3, nil, "Included in the Legendary Crystal Bundle", nil, v697)
local v698 = v_u_6.ViewModels["Crystal Scythe"]
local v699 = {
    ["ItemName"] = "Scythe",
    ["ImageHighResolution"] = v698.ImageHighResolution
}
v_u_81("Skin", "Mythical", "Crystal Scythe", v698.Image, 3, nil, "Included in the 2025 Festive Flash Sale", nil, v699)
local v700 = v_u_6.ViewModels["Bug Net"]
local v701 = {
    ["ItemName"] = "Scythe",
    ["ImageHighResolution"] = v700.ImageHighResolution
}
v_u_81("Skin", "Unobtainable", "Bug Net", v700.Image, 3, true, "Given to the best bug hunters, thank you for helping us improve the game (RIVALS)", nil, v701)
local v702 = v_u_6.ViewModels["Stealth Handgun"]
local v703 = {
    ["ItemName"] = "Handgun",
    ["ImageHighResolution"] = v702.ImageHighResolution
}
v_u_81("Skin", "Unobtainable", "Stealth Handgun", v702.Image, 3, true, "sneaky beaky like", nil, v703)
local v704 = v_u_6.ViewModels["Armature.001"]
local v705 = {
    ["ItemName"] = "Knife",
    ["ImageHighResolution"] = v704.ImageHighResolution
}
v_u_81("Skin", "Unobtainable", "Armature.001", v704.Image, 3, true, "if this is leaked neko will be waterboarded and hit by a car 628 times", nil, v705)
local v706 = v_u_6.ViewModels.MISSING_SKIN
local v707 = {
    ["ItemName"] = "MISSING_WEAPON",
    ["ImageHighResolution"] = v706.ImageHighResolution
}
v_u_81("Skin", "Unobtainable", "MISSING_SKIN", v706.Image, 3, true, "Note to self", nil, v707)
local function v730(p708, p709, p710, p711, p712, p713, p714, p715)
    local v716 = {
        ["WrapGroups"] = {}
    }
    for _, v717 in pairs({ p710, p711, p712 }) do
        local v718, v719, v720, v721, v722, v723, v724 = table.unpack(v717)
        local v725 = typeof(v718) == "string"
        local v726
        if v725 then
            v726 = v_u_2.Wraps:WaitForChild(v718)
        else
            v726 = v725
        end
        local v727 = {}
        local v728 = v726 and v726.BaseMaterial
        if not v728 then
            if v725 or not v718 then
                v728 = nil
            else
                v728 = v718
            end
        end
        v727.Material = v728
        v727.MaterialVariant = v725 and v718 and v718 or ""
        v727.Color = v719 or nil
        v727.Transparency = v720 or nil
        v727.Reflectance = v721 or nil
        v727.Textures = v722 or nil
        v727.CallbackName = v723
        v727.ObjectName = v724
        local v729 = v716.WrapGroups
        table.insert(v729, v727)
    end
    v_u_81("Wrap", p708, p709, nil, nil, p713, p714, p715, v716)
end
v730("Unique", "Community", {
    Enum.Material.Glass,
    Color3.fromRGB(124, 17, 255),
    0,
    0.1,
    nil
}, {
    Enum.Material.Glass,
    Color3.fromRGB(255, 213, 0),
    0,
    0.1,
    nil
}, {
    nil,
    Color3.fromRGB(112, 181, 255),
    nil,
    nil,
    nil
}, nil, "Earned by redeeming codes")
v730("Unique", "1B Visits", {
    Enum.Material.Glass,
    Color3.fromRGB(48, 38, 0),
    0,
    0.4,
    "1BVisits"
}, {
    Enum.Material.Glass,
    Color3.fromRGB(127, 100, 0),
    0,
    0.4,
    "1BVisits"
}, {
    Enum.Material.Neon,
    Color3.fromRGB(173, 155, 123),
    0,
    0,
    nil
}, nil, "Earned by redeeming a code when the game (RIVALS) reached 1,000,000,000 visits")
v730("Unique", "Cream", {
    nil,
    Color3.fromRGB(255, 209, 157),
    0,
    0,
    nil
}, {
    nil,
    Color3.fromRGB(62, 55, 48),
    0,
    0,
    nil
}, nil, nil, "Earned by inviting friends to the game (RIVALS)")
v730("Unique", "Danger", {
    Enum.Material.Neon,
    Color3.fromRGB(168, 0, 0),
    0,
    0,
    "Danger1"
}, {
    Enum.Material.Neon,
    Color3.fromRGB(17, 17, 17),
    0,
    0,
    "Danger2"
}, {
    Enum.Material.Neon,
    Color3.fromRGB(161, 47, 47),
    0,
    0,
    nil
}, nil, "Earned by completing a special challenge during the Roblox 2024 Winter Spotlight")
v730("Unique", "Glacier", {
    "Glacier",
    Color3.fromRGB(175, 221, 255),
    0,
    0,
    nil
}, {
    "Glacier",
    Color3.fromRGB(231, 231, 236),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(130, 157, 166),
    0,
    0,
    nil
}, nil, "Earned from the 2024 Festive Event Advent Calendar")
v730("Unique", "Pine", {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(58, 115, 55),
    0,
    0,
    "Pine"
}, {
    "Pine",
    Color3.fromRGB(72, 51, 40),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(158, 162, 121),
    0,
    0,
    nil
}, nil, "Earned from the 2024 Festive Event Advent Calendar")
v730("Unique", "Glamour", {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(86, 36, 36),
    0,
    0,
    "Glamour"
}, {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(117, 0, 0),
    0,
    0.1,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(170, 128, 99),
    0,
    0,
    nil
}, nil, "Earned by watching a quick video ad in the Shop")
v730("Unique", "Sensite", {
    "Developore",
    Color3.fromRGB(255, 180, 30),
    0,
    0,
    nil
}, {
    "Developore",
    Color3.fromRGB(0, 0, 0),
    0,
    0,
    nil
}, {
    nil,
    Color3.fromRGB(255, 172, 99),
    nil,
    nil,
    nil
})
v730("Unique", "Nosnite", {
    "Developore",
    Color3.fromRGB(180, 128, 255),
    0,
    0,
    nil
}, {
    "Developore",
    Color3.fromRGB(0, 0, 0),
    0,
    0,
    nil
}, {
    nil,
    Color3.fromRGB(136, 114, 202),
    nil,
    nil,
    nil
})
v730("Unique", "Nekore", {
    "Developore",
    Color3.fromRGB(6, 100, 150),
    0,
    0,
    nil
}, {
    "Developore",
    Color3.fromRGB(0, 0, 0),
    0,
    0,
    nil
}, {
    nil,
    Color3.fromRGB(102, 144, 236),
    nil,
    nil,
    nil
})
v730("Unique", "Shadore", {
    "Developore",
    Color3.fromRGB(203, 51, 51),
    0,
    0,
    nil
}, {
    "Developore",
    Color3.fromRGB(0, 0, 0),
    0,
    0,
    nil
}, {
    nil,
    Color3.fromRGB(248, 108, 108),
    nil,
    nil,
    nil
})
v730("Unique", "Brianore", {
    "Developore",
    Color3.fromRGB(101, 255, 93),
    0,
    0,
    nil
}, {
    "Developore",
    Color3.fromRGB(0, 0, 0),
    0,
    0,
    nil
}, {
    nil,
    Color3.fromRGB(157, 248, 163),
    nil,
    nil,
    nil
})
v730("Unique", "Boomore", {
    "Developore",
    Color3.fromRGB(255, 255, 255),
    0,
    0,
    nil
}, {
    "Developore",
    Color3.fromRGB(0, 0, 0),
    0,
    0,
    nil
}, {
    nil,
    Color3.fromRGB(175, 175, 175),
    nil,
    nil,
    nil
})
v730("Unique", "Beggar", {
    Enum.Material.Pebble,
    Color3.fromRGB(255, 176, 0),
    0.05,
    0,
    "dude"
}, {
    Enum.Material.CorrodedMetal,
    Color3.fromRGB(255, 176, 0),
    0.1,
    0,
    "bruh"
}, {
    Enum.Material.Neon,
    Color3.fromRGB(9, 137, 207),
    0,
    1000,
    "epic"
}, nil, "Beggars can\'t be choosers")
v730("Unique", "Snowy Night", {
    Enum.Material.Neon,
    Color3.fromRGB(46, 52, 54),
    0,
    0,
    "Snowflakes_1"
}, {
    Enum.Material.Neon,
    Color3.fromRGB(150, 169, 176),
    0,
    0,
    "Snowflakes_2"
}, {
    Enum.Material.Glass,
    Color3.fromRGB(202, 246, 255),
    0.25,
    0.3,
    nil
}, nil, "Earned from the 2025 Festive Event Advent Calendar")
v730("Common", "Red", {
    nil,
    Color3.fromRGB(255, 50, 50),
    0,
    0,
    nil
})
v730("Common", "Orange", {
    nil,
    Color3.fromRGB(255, 110, 0),
    0,
    0,
    nil
})
v730("Common", "Yellow", {
    nil,
    Color3.fromRGB(255, 215, 0),
    0,
    0,
    nil
})
v730("Common", "Green", {
    nil,
    Color3.fromRGB(100, 255, 50),
    0,
    0,
    nil
})
v730("Common", "Blue", {
    nil,
    Color3.fromRGB(0, 150, 255),
    0,
    0,
    nil
})
v730("Common", "Purple", {
    nil,
    Color3.fromRGB(136, 0, 255),
    0,
    0,
    nil
})
v730("Common", "Pink", {
    nil,
    Color3.fromRGB(255, 60, 236),
    0,
    0,
    nil
})
v730("Common", "Salmon", {
    nil,
    Color3.fromRGB(255, 107, 107),
    0,
    0,
    nil
})
v730("Common", "Brown", {
    nil,
    Color3.fromRGB(91, 54, 35),
    0,
    0,
    nil
})
v730("Common", "Lemon", {
    nil,
    Color3.fromRGB(255, 230, 105),
    0,
    0,
    nil
})
v730("Common", "Mint", {
    nil,
    Color3.fromRGB(167, 255, 135),
    0,
    0,
    nil
})
v730("Common", "Sky", {
    nil,
    Color3.fromRGB(135, 207, 255),
    0,
    0,
    nil
})
v730("Common", "Olive", {
    nil,
    Color3.fromRGB(75, 79, 55),
    0,
    0,
    nil
})
v730("Common", "Blush", {
    nil,
    Color3.fromRGB(255, 164, 255),
    0,
    0,
    nil
})
v730("Common", "Maroon", {
    nil,
    Color3.fromRGB(117, 33, 69),
    0,
    0,
    nil
})
v730("Common", "Beige", {
    nil,
    Color3.fromRGB(184, 156, 110),
    0,
    0,
    nil
})
v730("Common", "Navy", {
    nil,
    Color3.fromRGB(0, 18, 76),
    0,
    0,
    nil
})
v730("Common", "Teal", {
    nil,
    Color3.fromRGB(0, 255, 225),
    0,
    0,
    nil
})
v730("Common", "Highlighter", {
    nil,
    Color3.fromRGB(192, 255, 57),
    0,
    0,
    nil
})
v730("Common", "Crimson", {
    nil,
    Color3.fromRGB(75, 14, 14),
    0,
    0,
    nil
})
v730("Common", "Cool", {
    nil,
    Color3.fromRGB(97, 200, 255),
    0,
    0,
    nil
})
v730("Common", "Gunmetal", {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(40, 40, 40),
    0,
    0.05,
    nil
}, {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(255, 255, 255),
    0,
    1,
    "Gunmetal"
}, {
    Enum.Material.Neon,
    Color3.fromRGB(182, 116, 99),
    0,
    0,
    nil
})
v730("Common", "Venom", {
    Enum.Material.Neon,
    Color3.fromRGB(136, 0, 255),
    0,
    0,
    "Venom"
}, {
    Enum.Material.Metal,
    Color3.fromRGB(0, 0, 0),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(102, 0, 191),
    0.15,
    0,
    nil
})
v730("Common", "MaGGenta", {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(206, 206, 206),
    0,
    0,
    nil
}, {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(115, 40, 255),
    0,
    0,
    nil
})
v730("Common", "Bluesteel", {
    "Bluesteel",
    Color3.fromRGB(38, 96, 150),
    0,
    0,
    nil
}, {
    Enum.Material.Metal,
    Color3.fromRGB(159, 161, 172),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(37, 73, 173),
    0,
    0,
    nil
})
v730("Common", "Cheese", {
    "Cheese",
    Color3.fromRGB(255, 221, 48),
    0,
    0,
    nil
}, {
    "Cheesecloth",
    Color3.fromRGB(248, 221, 194),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(172, 118, 0),
    0,
    0,
    nil
})
v730("Common", "Stained", {
    "Stained",
    Color3.fromRGB(82, 126, 175),
    0,
    0,
    nil
}, {
    "Stained",
    Color3.fromRGB(120, 183, 255),
    0,
    0,
    nil
})
v730("Common", "Lumber", {
    "Lumber1",
    Color3.fromRGB(124, 92, 70),
    0,
    0,
    nil
}, {
    "Lumber2",
    Color3.fromRGB(105, 64, 40),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(198, 135, 114),
    0,
    0,
    nil
})
v730("Common", "Ornate", {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(27, 42, 53),
    0,
    0,
    nil
}, {
    Enum.Material.Metal,
    Color3.fromRGB(226, 155, 64),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(255, 53, 53),
    0,
    0,
    nil
})
v730("Common", "Mustard", {
    nil,
    Color3.fromRGB(136, 102, 0),
    0,
    0,
    nil
})
v730("Common", "Violet", {
    nil,
    Color3.fromRGB(85, 43, 255),
    0,
    0,
    nil
})
v730("Common", "Jean", {
    nil,
    Color3.fromRGB(0, 76, 255),
    0,
    0,
    nil
})
v730("Common", "Copper", {
    Enum.Material.Glass,
    Color3.fromRGB(213, 115, 61),
    0,
    0.3,
    nil
}, {
    Enum.Material.Glass,
    Color3.fromRGB(170, 85, 0),
    0,
    0.3,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(186, 143, 135),
    0,
    0,
    nil
})
v730("Common", "Machine", {
    "BrushedMetal",
    Color3.fromRGB(202, 203, 209),
    0,
    0,
    nil
}, {
    "BrushedMetal",
    Color3.fromRGB(202, 203, 209),
    0,
    0,
    nil
}, {
    "BrushedMetal",
    Color3.fromRGB(202, 203, 209),
    0,
    0,
    nil
})
v730("Common", "Titanium", {
    Enum.Material.Glass,
    Color3.fromRGB(205, 205, 205),
    0,
    0.3,
    nil
}, {
    Enum.Material.Glass,
    Color3.fromRGB(248, 248, 248),
    0,
    0.3,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(171, 171, 171),
    0,
    0,
    nil
})
v730("Common", "Tungsten", {
    Enum.Material.Glass,
    Color3.fromRGB(66, 67, 76),
    0,
    0.3,
    nil
}, {
    Enum.Material.Glass,
    Color3.fromRGB(91, 93, 105),
    0,
    0.3,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(133, 141, 192),
    0,
    0,
    nil
})
v730("Common", "Haunted", {
    Enum.Material.Glass,
    Color3.fromRGB(0, 0, 0),
    0,
    0.4,
    nil
}, {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(0, 255, 238),
    0.5,
    0.2,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(110, 253, 255),
    0,
    0,
    nil
})
v730("Common", "Vexed", {
    Enum.Material.Glass,
    Color3.fromRGB(0, 0, 0),
    0,
    0.4,
    nil
}, {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(105, 46, 255),
    0.5,
    0.2,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(153, 133, 255),
    0,
    0,
    nil
})
v730("Common", "Cursed", {
    Enum.Material.Glass,
    Color3.fromRGB(0, 0, 0),
    0,
    0.4,
    nil
}, {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(255, 0, 0),
    0.5,
    0.2,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(255, 142, 142),
    0,
    0,
    nil
})
v730("Common", "Frigid", {
    nil,
    nil,
    nil,
    nil,
    "Frigid"
}, {
    nil,
    nil,
    nil,
    nil,
    "Frigid"
})
v730("Common", "Midnight", {
    "PBRSimpleMetallic",
    Color3.fromRGB(7, 25, 67),
    0,
    0,
    nil
}, {
    "PBRSimpleMetallic",
    Color3.fromRGB(77, 77, 77),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(82, 122, 255),
    0,
    0,
    nil
})
v730("Common", "Slush", {
    Enum.Material.Neon,
    Color3.fromRGB(136, 168, 161),
    0,
    0,
    "Slush1"
}, {
    Enum.Material.Neon,
    Color3.fromRGB(128, 145, 158),
    0,
    0,
    "Slush2"
}, {
    Enum.Material.Neon,
    Color3.fromRGB(100, 155, 163),
    0,
    0,
    nil
})
v730("Common", "Lavish Crystal", {
    "LavishCrystal",
    Color3.fromRGB(183, 149, 255),
    0,
    0,
    nil
}, {
    "LavishCrystal",
    Color3.fromRGB(219, 196, 236),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(142, 128, 166),
    0,
    0,
    nil
})
v730("Common", "Noir", {
    Enum.Material.Neon,
    Color3.fromRGB(165, 165, 165),
    0,
    0,
    "Noir1"
}, {
    Enum.Material.Neon,
    Color3.fromRGB(17, 17, 17),
    0,
    0,
    "Noir2"
}, {
    Enum.Material.Neon,
    Color3.fromRGB(157, 157, 157),
    0,
    0,
    nil
})
v730("Common", "Normal", {
    Enum.Material.Neon,
    Color3.fromRGB(138, 0, 148),
    0,
    0,
    "Normal1"
}, {
    Enum.Material.Neon,
    Color3.fromRGB(0, 32, 96),
    0,
    0,
    "Normal2"
}, {
    Enum.Material.Neon,
    Color3.fromRGB(158, 58, 58),
    0,
    0,
    nil
})
v730("Common", "Rust", {
    Enum.Material.CorrodedMetal,
    nil,
    0,
    0,
    nil
}, {
    Enum.Material.CorrodedMetal,
    nil,
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(159, 159, 159),
    0,
    0.1,
    nil
})
v730("Common", "Tawny", {
    Enum.Material.Neon,
    Color3.fromRGB(255, 233, 111),
    0,
    0,
    "Tawny1"
}, {
    Enum.Material.Neon,
    Color3.fromRGB(68, 44, 7),
    0,
    0,
    "Tawny2"
}, {
    Enum.Material.Neon,
    Color3.fromRGB(167, 118, 78),
    0,
    0,
    nil
})
v730("Common", "Olo", {
    nil,
    Color3.fromRGB(0, 254, 202),
    0,
    0,
    nil
})
v730("Common", "Glorious", { "CandyGlossy" }, { "CandyGlossy" }, nil, nil, "Purchased from the Ranked Shop")
v730("Common", "Spiral", {
    "Spiral1",
    Color3.fromRGB(180, 128, 255),
    0,
    0.3,
    "Spiral1"
}, {
    "Spiral2",
    Color3.fromRGB(17, 17, 17),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(110, 79, 177),
    0,
    0,
    "Spiral3"
})
v730("Common", "Pink Lemonade", {
    nil,
    Color3.fromRGB(255, 96, 152),
    0,
    0,
    nil
}, {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(255, 212, 57),
    0,
    0,
    nil
}, {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(255, 212, 57),
    0,
    0,
    nil
})
v730("Common", "Playful", {
    nil,
    Color3.fromRGB(20, 67, 176),
    0,
    0,
    nil
}, {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(234, 121, 23),
    0,
    0,
    nil
}, {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(234, 121, 23),
    0,
    0,
    nil
})
v730("Common", "Lapis", {
    nil,
    Color3.fromRGB(65, 73, 114),
    0,
    0,
    nil
}, {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(106, 255, 203),
    0,
    0,
    nil
}, {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(106, 255, 203),
    0,
    0,
    nil
})
v730("Common", "Zombie", {
    Enum.Material.Sand,
    Color3.fromRGB(101, 158, 89),
    0,
    0,
    "Zombie1"
}, {
    Enum.Material.Plastic,
    Color3.fromRGB(38, 39, 52),
    0,
    0,
    "Zombie2"
}, {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(212, 214, 196),
    0,
    0,
    nil
}, nil, "Earned by escaping the Zombie Tower alive")
v730("Common", "Tusky", {
    "MammothFur",
    Color3.fromRGB(129, 86, 65),
    0,
    0,
    "Tusky_1"
}, {
    "Wooly1",
    Color3.fromRGB(255, 247, 231),
    0,
    0,
    "Tusky_2"
}, {
    Enum.Material.Neon,
    Color3.fromRGB(163, 160, 155),
    0,
    0,
    nil
})
v730("Common", "Sleet", {
    nil,
    Color3.fromRGB(83, 79, 106),
    0,
    0,
    nil
}, {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(154, 188, 236),
    0,
    0,
    nil
}, {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(154, 188, 236),
    0,
    0,
    nil
})
v730("Common", "Hot Cocoa", {
    nil,
    Color3.fromRGB(81, 57, 45),
    0,
    0,
    nil
}, {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(217, 224, 236),
    0,
    0,
    nil
}, {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(217, 224, 236),
    0,
    0,
    nil
})
v730("Rare", "Gold", {
    Enum.Material.Glass,
    Color3.fromRGB(255, 170, 24),
    0,
    0.4,
    nil
}, {
    Enum.Material.Glass,
    Color3.fromRGB(255, 170, 24),
    0,
    0.4,
    nil
}, {
    nil,
    Color3.fromRGB(255, 165, 120),
    nil,
    nil,
    nil
}, nil, "Earned from weapon contracts", "Earned from a weapon contract for this weapon")
v730("Rare", "Forest Camo", {
    "Forest Camo",
    Color3.fromRGB(237, 234, 234),
    0,
    0,
    nil
}, {
    Enum.Material.Glass,
    Color3.fromRGB(17, 17, 17),
    0,
    0,
    nil
}, {
    nil,
    Color3.fromRGB(140, 255, 98),
    nil,
    nil,
    nil
})
v730("Rare", "Honeycomb", {
    "Honeycomb",
    Color3.fromRGB(255, 201, 74),
    0,
    0,
    nil
}, {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(0, 0, 0),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(170, 121, 72),
    0,
    0,
    nil
})
v730("Rare", "Patriot", {
    "Patriot",
    Color3.fromRGB(248, 248, 248),
    0,
    0,
    nil
}, {
    Enum.Material.Glass,
    Color3.fromRGB(17, 17, 17),
    0,
    0,
    nil
}, {
    nil,
    Color3.fromRGB(168, 168, 168),
    nil,
    nil,
    nil
})
v730("Rare", "Clouds", {
    "Clouds",
    Color3.fromRGB(248, 248, 248),
    0,
    0,
    nil
}, {
    Enum.Material.Glass,
    Color3.fromRGB(17, 98, 148),
    0,
    0,
    nil
}, {
    nil,
    Color3.fromRGB(123, 150, 163),
    nil,
    nil,
    nil
})
v730("Rare", "Swirls", {
    "Swirls",
    Color3.fromRGB(248, 248, 248),
    0,
    0,
    nil
}, {
    Enum.Material.Glass,
    Color3.fromRGB(17, 17, 17),
    0,
    0,
    nil
}, {
    nil,
    Color3.fromRGB(167, 167, 167),
    nil,
    nil,
    nil
})
v730("Rare", "Brain", {
    "Brain",
    Color3.fromRGB(255, 152, 220),
    0,
    0,
    nil
}, {
    Enum.Material.Glass,
    Color3.fromRGB(0, 0, 0),
    0,
    0,
    nil
}, {
    nil,
    Color3.fromRGB(255, 106, 228),
    nil,
    nil,
    nil
})
v730("Rare", "Arctic Camo", {
    "Arctic Camo",
    Color3.fromRGB(255, 255, 255),
    0,
    0,
    nil
}, {
    Enum.Material.Glass,
    Color3.fromRGB(17, 17, 17),
    0,
    0,
    nil
}, {
    nil,
    Color3.fromRGB(154, 175, 194),
    nil,
    nil,
    nil
})
v730("Rare", "Carpet", {
    "Carpet",
    Color3.fromRGB(255, 255, 255),
    0,
    0,
    nil
}, {
    Enum.Material.Glass,
    Color3.fromRGB(0, 0, 0),
    0,
    0,
    nil
}, {
    nil,
    Color3.fromRGB(139, 139, 255),
    nil,
    nil,
    nil
})
v730("Rare", "Circuit", {
    "Circuit",
    Color3.fromRGB(255, 255, 255),
    0,
    0,
    nil
}, {
    Enum.Material.Glass,
    Color3.fromRGB(0, 0, 0),
    0,
    0,
    nil
}, {
    nil,
    Color3.fromRGB(105, 206, 105),
    nil,
    nil,
    nil
})
v730("Rare", "Desert Camo", {
    "Desert Camo",
    Color3.fromRGB(255, 255, 255),
    0,
    0,
    nil
}, {
    Enum.Material.Glass,
    Color3.fromRGB(17, 17, 17),
    0,
    0,
    nil
}, {
    nil,
    Color3.fromRGB(163, 141, 116),
    nil,
    nil,
    nil
})
v730("Rare", "Digital Camo", {
    "Digital Camo",
    Color3.fromRGB(255, 255, 255),
    0,
    0,
    nil
}, {
    Enum.Material.Glass,
    Color3.fromRGB(17, 17, 17),
    0,
    0,
    nil
}, {
    nil,
    Color3.fromRGB(161, 161, 161),
    nil,
    nil,
    nil
})
v730("Rare", "Frosted", {
    "Frosted",
    Color3.fromRGB(255, 255, 255),
    0,
    0,
    nil
}, {
    Enum.Material.Glass,
    Color3.fromRGB(161, 239, 255),
    0,
    0.4,
    nil
}, {
    nil,
    Color3.fromRGB(128, 163, 175),
    nil,
    nil,
    nil
})
v730("Rare", "Mainframe", {
    "Mainframe",
    Color3.fromRGB(255, 102, 204),
    0,
    0,
    nil
}, {
    "Mainframe",
    Color3.fromRGB(7, 14, 29),
    0,
    0,
    nil
}, {
    nil,
    Color3.fromRGB(231, 135, 255),
    nil,
    nil,
    nil
})
v730("Rare", "Ocean Camo", {
    "Ocean Camo",
    Color3.fromRGB(255, 255, 255),
    0,
    0,
    nil
}, {
    Enum.Material.Glass,
    Color3.fromRGB(17, 17, 17),
    0,
    0,
    nil
}, {
    nil,
    Color3.fromRGB(108, 130, 255),
    nil,
    nil,
    nil
})
v730("Rare", "PB & J", {
    "PB & J",
    Color3.fromRGB(212, 144, 189),
    0,
    0,
    nil
}, {
    "PB & J",
    Color3.fromRGB(212, 144, 189),
    0,
    0,
    nil
}, {
    nil,
    Color3.fromRGB(143, 120, 255),
    nil,
    nil,
    nil
})
v730("Rare", "Reptile", {
    "Reptile",
    Color3.fromRGB(103, 127, 51),
    0,
    0,
    nil
}, {
    "Reptile",
    Color3.fromRGB(0, 0, 0),
    0,
    0,
    nil
}, {
    nil,
    Color3.fromRGB(146, 255, 106),
    nil,
    nil,
    nil
})
v730("Rare", "Rug", {
    "Rug",
    Color3.fromRGB(255, 255, 255),
    0,
    0,
    nil
}, {
    Enum.Material.Glass,
    Color3.fromRGB(157, 157, 157),
    0,
    0,
    nil
}, {
    nil,
    Color3.fromRGB(163, 163, 163),
    nil,
    nil,
    nil
})
v730("Rare", "Steel", {
    "Steel",
    Color3.fromRGB(255, 255, 255),
    0,
    0,
    nil
}, {
    Enum.Material.Glass,
    Color3.fromRGB(54, 54, 54),
    0,
    0.4,
    nil
}, {
    nil,
    Color3.fromRGB(159, 159, 159),
    nil,
    nil,
    nil
})
v730("Rare", "Street Camo", {
    "Street Camo",
    Color3.fromRGB(255, 255, 255),
    0,
    0,
    nil
}, {
    Enum.Material.Glass,
    Color3.fromRGB(17, 17, 17),
    0,
    0,
    nil
}, {
    nil,
    Color3.fromRGB(180, 172, 112),
    nil,
    nil,
    nil
})
v730("Rare", "Urban Camo", {
    "Urban Camo",
    Color3.fromRGB(255, 255, 255),
    0,
    0,
    nil
}, {
    Enum.Material.Glass,
    Color3.fromRGB(17, 17, 17),
    0,
    0,
    nil
}, {
    nil,
    Color3.fromRGB(255, 131, 131),
    nil,
    nil,
    nil
})
v730("Rare", "Medium stone grey", {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(163, 162, 165),
    0,
    0,
    nil
}, {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(163, 162, 165),
    0,
    0,
    nil
}, {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(163, 162, 165),
    0,
    0,
    nil
})
v730("Rare", "Studs", {
    nil,
    nil,
    0,
    0,
    "Studs"
}, {
    nil,
    nil,
    0,
    0,
    "Studs"
})
v730("Rare", "Inlets", {
    nil,
    nil,
    0,
    0,
    "Inlets"
}, {
    nil,
    nil,
    0,
    0,
    "Inlets"
})
v730("Rare", "Universal", {
    nil,
    nil,
    0,
    0,
    "Universal"
}, {
    nil,
    nil,
    0,
    0,
    "Universal"
})
v730("Rare", "Surge", {
    nil,
    Color3.fromRGB(109, 25, 47),
    0,
    0,
    nil
}, {
    nil,
    Color3.fromRGB(23, 59, 111),
    0,
    0,
    nil
})
v730("Rare", "Vile", {
    nil,
    Color3.fromRGB(75, 35, 136),
    0,
    0,
    nil
}, {
    nil,
    Color3.fromRGB(101, 147, 49),
    0,
    0,
    nil
})
v730("Rare", "OranGG", {
    nil,
    Color3.fromRGB(206, 206, 206),
    0,
    0,
    nil
}, {
    nil,
    Color3.fromRGB(255, 106, 0),
    0,
    0,
    nil
})
v730("Rare", "Maize", {
    nil,
    Color3.fromRGB(0, 39, 76),
    0,
    0,
    nil
}, {
    nil,
    Color3.fromRGB(255, 203, 5),
    0,
    0,
    nil
})
v730("Rare", "Spartan", {
    nil,
    Color3.fromRGB(24, 69, 59),
    0,
    0,
    nil
}, {
    nil,
    Color3.fromRGB(255, 255, 255),
    0,
    0,
    nil
})
v730("Rare", "Crossed", {
    "Crossed",
    Color3.fromRGB(0, 153, 255),
    0,
    0,
    nil
}, {
    Enum.Material.Glass,
    Color3.fromRGB(0, 32, 54),
    0,
    0,
    nil
}, {
    nil,
    Color3.fromRGB(76, 94, 255),
    nil,
    nil,
    nil
})
v730("Rare", "Celtic", {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(27, 39, 22),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(175, 142, 86),
    0,
    0,
    "Celtic"
}, {
    Enum.Material.Neon,
    Color3.fromRGB(175, 142, 86),
    0,
    0,
    nil
})
v730("Rare", "Dawn", {
    Enum.Material.Neon,
    Color3.fromRGB(255, 204, 0),
    0,
    0,
    "Dawn1"
}, {
    Enum.Material.Neon,
    Color3.fromRGB(28, 52, 117),
    0,
    0,
    "Dawn2"
}, {
    Enum.Material.Neon,
    Color3.fromRGB(161, 122, 90),
    0,
    0,
    nil
})
v730("Rare", "Termination", {
    Enum.Material.Metal,
    Color3.fromRGB(117, 0, 0),
    0,
    0,
    nil
}, {
    Enum.Material.Glass,
    Color3.fromRGB(255, 255, 255),
    0,
    0.05,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(170, 57, 57),
    0,
    0,
    nil
})
v730("Rare", "Fiery", {
    Enum.Material.Neon,
    Color3.fromRGB(159, 29, 29),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(163, 145, 91),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(185, 34, 34),
    0,
    0,
    nil
})
v730("Rare", "Portal", {
    Enum.Material.Neon,
    Color3.fromRGB(255, 102, 204),
    0,
    0,
    "Portal"
}, {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(255, 152, 220),
    0,
    0.4,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(255, 152, 220),
    0,
    0,
    nil
})
v730("Rare", "Voltaic", {
    "Voltaic",
    Color3.fromRGB(226, 155, 64),
    0,
    0,
    nil
}, {
    Enum.Material.Metal,
    Color3.fromRGB(226, 155, 64),
    0,
    0,
    nil
}, {
    Enum.Material.ForceField,
    Color3.fromRGB(226, 155, 64),
    0,
    0,
    nil
})
v730("Rare", "Carmine", {
    Enum.Material.Glass,
    Color3.fromRGB(117, 0, 0),
    0.15,
    0,
    nil
}, {
    "Carmine",
    Color3.fromRGB(86, 36, 36),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(189, 0, 0),
    0,
    0,
    nil
})
v730("Rare", "Money", {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(255, 255, 255),
    0,
    0,
    "Money"
}, {
    Enum.Material.Plastic,
    Color3.fromRGB(0, 0, 0),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(102, 255, 99),
    0,
    0,
    nil
})
v730("Rare", "Eco", {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(255, 255, 255),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(0, 163, 0),
    0,
    0,
    "Eco"
}, {
    Enum.Material.Neon,
    Color3.fromRGB(0, 163, 0),
    0,
    0,
    nil
})
v730("Rare", "Igneous", {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(0, 0, 0),
    0,
    0.05,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(255, 176, 111),
    0,
    0,
    "Igneous"
}, {
    Enum.Material.Neon,
    Color3.fromRGB(168, 145, 93),
    0,
    0,
    nil
})
v730("Rare", "Spellslinger", {
    Enum.Material.Neon,
    Color3.fromRGB(255, 255, 255),
    0,
    0,
    "Spellsling"
}, {
    "Spellslinger",
    Color3.fromRGB(12, 156, 127),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(101, 182, 159),
    0,
    0,
    nil
})
v730("Rare", "White", {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(255, 255, 255),
    0,
    0,
    nil
}, {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(255, 255, 255),
    0,
    0,
    nil
}, {
    nil,
    Color3.fromRGB(255, 255, 255),
    nil,
    nil,
    nil
}, nil, "Earned by reaching Level 50 on a weapon", "Earned by reaching Level 50 on this weapon")
v730("Rare", "Black", {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(0, 0, 0),
    0,
    0,
    nil
}, {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(0, 0, 0),
    0,
    0,
    nil
}, {
    nil,
    Color3.fromRGB(0, 0, 0),
    nil,
    nil,
    nil
}, nil, "Earned by reaching Level 99 on a weapon", "Earned by reaching Level 99 on this weapon")
v730("Rare", "Nova", {
    "Nova",
    Color3.fromRGB(19, 255, 224),
    0,
    0,
    nil
}, {
    "Nova",
    Color3.fromRGB(0, 120, 94),
    0,
    0,
    nil
}, {
    nil,
    Color3.fromRGB(89, 255, 191),
    nil,
    nil,
    nil
}, nil, "Rare drop from Daily Tasks")
v730("Rare", "Fire", {
    Enum.Material.Neon,
    Color3.fromRGB(102, 77, 0),
    0,
    0,
    "Fire"
}, {
    Enum.Material.Glass,
    Color3.fromRGB(255, 100, 0),
    0,
    0.1,
    nil
}, {
    nil,
    Color3.fromRGB(255, 106, 69),
    nil,
    nil,
    nil
}, nil, "Earned by winning 10 duels in a row")
v730("Rare", "Trophy", {
    Enum.Material.Neon,
    Color3.fromRGB(168, 158, 66),
    0,
    0,
    "Trophy"
}, {
    Enum.Material.Glass,
    Color3.fromRGB(252, 255, 96),
    0,
    0.1,
    nil
}, {
    nil,
    Color3.fromRGB(252, 255, 96),
    nil,
    nil,
    nil
}, nil, "Earned by winning 25 duels")
v730("Rare", "Experience", {
    Enum.Material.Neon,
    Color3.fromRGB(94, 145, 157),
    0,
    0,
    "Experience"
}, {
    Enum.Material.Glass,
    Color3.fromRGB(30, 150, 255),
    0,
    0.1,
    nil
}, {
    nil,
    Color3.fromRGB(106, 166, 191),
    nil,
    nil,
    nil
}, nil, "Earned every 10 career levels")
v730("Rare", "Rage", {
    "Rage",
    Color3.fromRGB(255, 121, 248),
    0,
    0,
    nil
}, {
    Enum.Material.Glass,
    Color3.fromRGB(38, 14, 27),
    0,
    0,
    nil
}, {
    nil,
    Color3.fromRGB(190, 72, 72),
    nil,
    nil,
    nil
})
v730("Rare", "Scales", {
    "Scales",
    Color3.fromRGB(255, 202, 128),
    0,
    0,
    nil
}, {
    Enum.Material.Glass,
    Color3.fromRGB(47, 28, 7),
    0,
    0,
    nil
}, {
    nil,
    Color3.fromRGB(255, 143, 121),
    nil,
    nil,
    nil
})
v730("Rare", "Obsidian", {
    "Arabesque",
    Color3.fromRGB(0, 0, 0),
    0,
    0,
    nil
}, {
    Enum.Material.Glass,
    Color3.fromRGB(25, 24, 36),
    0,
    0,
    nil
}, {
    nil,
    Color3.fromRGB(143, 120, 255),
    nil,
    nil,
    nil
})
v730("Rare", "Toy", {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(55, 134, 37),
    0,
    0.1,
    nil
}, {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(55, 134, 37),
    0,
    0.1,
    nil
}, {
    Enum.Material.Glass,
    Color3.fromRGB(55, 134, 37),
    0,
    0.1,
    nil
})
v730("Rare", "Well Done", {
    "A5",
    Color3.fromRGB(72, 56, 40),
    0,
    0,
    nil
}, {
    Enum.Material.Concrete,
    Color3.fromRGB(0, 0, 0),
    0,
    0,
    nil
}, {
    nil,
    Color3.fromRGB(255, 163, 140),
    nil,
    nil,
    nil
})
v730("Rare", "Dunes", {
    "Dunes",
    Color3.fromRGB(255, 255, 255),
    0,
    0,
    nil
}, {
    "Dunes",
    Color3.fromRGB(0, 0, 0),
    0,
    0,
    nil
}, {
    nil,
    Color3.fromRGB(171, 157, 125),
    nil,
    nil,
    nil
})
v730("Rare", "Glisten", {
    "Glisten",
    Color3.fromRGB(4, 175, 236),
    0,
    0,
    nil
}, {
    "Glisten",
    Color3.fromRGB(0, 88, 120),
    0,
    0,
    nil
}, {
    nil,
    Color3.fromRGB(126, 154, 255),
    nil,
    nil,
    nil
})
v730("Rare", "Glossy", {
    "Glossy",
    Color3.fromRGB(255, 255, 255),
    0,
    0,
    nil
}, {
    "Glossy",
    Color3.fromRGB(255, 255, 255),
    0,
    0,
    nil
}, {
    nil,
    Color3.fromRGB(255, 169, 218),
    nil,
    nil,
    nil
})
v730("Rare", "Storm", {
    "Storm",
    Color3.fromRGB(248, 248, 248),
    0,
    0,
    nil
}, {
    "Storm",
    Color3.fromRGB(44, 41, 70),
    0,
    0,
    nil
}, {
    nil,
    Color3.fromRGB(150, 140, 255),
    nil,
    nil,
    nil
})
v730("Rare", "Bunsen", {
    "Bunsen",
    Color3.fromRGB(33, 84, 185),
    0,
    0,
    nil
}, {
    Enum.Material.Glass,
    Color3.fromRGB(5, 22, 59),
    0,
    0,
    nil
}, {
    nil,
    Color3.fromRGB(17, 61, 255),
    nil,
    nil,
    nil
})
v730("Rare", "Black Granite", {
    "Black Granite",
    Color3.fromRGB(223, 223, 222),
    0,
    0,
    nil
}, {
    "Black Granite",
    Color3.fromRGB(91, 93, 105),
    0,
    0,
    nil
}, {
    Enum.Material.Glass,
    Color3.fromRGB(17, 17, 17),
    0.75,
    0,
    nil
})
v730("Rare", "Cerulean", {
    "Resolute",
    Color3.fromRGB(0, 255, 255),
    0,
    0,
    nil
}, {
    "Resolute",
    Color3.fromRGB(0, 0, 0),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(61, 255, 110),
    0,
    0,
    nil
})
v730("Rare", "Clamshell", {
    "Clamshell",
    Color3.fromRGB(255, 255, 255),
    0,
    0,
    nil
}, {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(255, 226, 212),
    0,
    0.3,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(233, 182, 213),
    0,
    0,
    nil
})
v730("Rare", "Cool Crochet", {
    "Crochet",
    Color3.fromRGB(117, 127, 106),
    0,
    0,
    nil
}, {
    "Crochet",
    Color3.fromRGB(116, 134, 157),
    0,
    0,
    nil
}, {
    "Crochet",
    Color3.fromRGB(116, 134, 157),
    0,
    0,
    nil
})
v730("Rare", "Cork", {
    "Cork",
    Color3.fromRGB(248, 248, 248),
    0,
    0,
    nil
}, {
    "Cork",
    Color3.fromRGB(163, 162, 165),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(203, 171, 149),
    0,
    0,
    nil
})
v730("Rare", "Hammered Copper", {
    "Hammered",
    Color3.fromRGB(140, 96, 64),
    0,
    0,
    nil
}, {
    "Hammered",
    Color3.fromRGB(140, 96, 64),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(204, 117, 95),
    0,
    0,
    nil
})
v730("Rare", "Hypnotic", {
    "Hypnotic 1",
    Color3.fromRGB(248, 248, 248),
    0,
    0,
    nil
}, {
    "Hypnotic 2",
    Color3.fromRGB(248, 248, 248),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(223, 143, 255),
    0,
    0,
    nil
})
v730("Rare", "Leafy Grass", {
    "Leafy Grass",
    Color3.fromRGB(223, 223, 222),
    0,
    0,
    nil
}, {
    "Leafy Grass",
    Color3.fromRGB(163, 162, 165),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(132, 197, 104),
    0,
    0,
    nil
})
v730("Rare", "Liquid Chrome", {
    "Liquid Chrome",
    Color3.fromRGB(193, 193, 193),
    0,
    0,
    nil
}, {
    "Liquid Chrome",
    Color3.fromRGB(255, 255, 255),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(155, 158, 193),
    0,
    0,
    nil
})
v730("Rare", "Mahogany", {
    "Mahogany Wood",
    Color3.fromRGB(194, 124, 74),
    0,
    0,
    nil
}, {
    "Mahogany Wood",
    Color3.fromRGB(117, 62, 0),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(199, 141, 107),
    0,
    0,
    nil
})
v730("Rare", "Neo", {
    "Neo",
    Color3.fromRGB(4, 175, 236),
    0,
    0,
    nil
}, {
    "Neo",
    Color3.fromRGB(61, 21, 133),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(82, 124, 174),
    0,
    0,
    nil
})
v730("Rare", "Pink Crochet", {
    "Crochet",
    Color3.fromRGB(255, 152, 220),
    0,
    0,
    nil
}, {
    "Crochet",
    Color3.fromRGB(172, 103, 149),
    0,
    0,
    nil
}, {
    "Crochet",
    Color3.fromRGB(255, 152, 220),
    0,
    0,
    nil
})
v730("Rare", "Pink Glitter", {
    "Pink Glitter",
    Color3.fromRGB(255, 152, 220),
    0,
    0,
    nil
}, {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(255, 152, 220),
    0,
    0.3,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(183, 113, 197),
    0,
    0,
    nil
})
v730("Rare", "Studded", {
    "Studded",
    nil,
    0,
    0,
    nil
}, {
    "Studded",
    nil,
    0,
    0,
    nil
})
v730("Rare", "Tempest", {
    Enum.Material.Neon,
    Color3.fromRGB(248, 248, 248),
    0,
    0,
    "Tempest1"
}, {
    Enum.Material.Neon,
    Color3.fromRGB(167, 167, 167),
    0,
    0,
    "Tempest2"
}, {
    Enum.Material.Neon,
    Color3.fromRGB(163, 138, 149),
    0,
    0,
    nil
})
v730("Rare", "Yang", {
    "Yin Yang",
    Color3.fromRGB(248, 248, 248),
    0,
    0,
    nil
}, {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(248, 248, 248),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(17, 17, 17),
    0,
    0,
    nil
})
v730("Rare", "Yin", {
    "Yin Yang",
    Color3.fromRGB(248, 248, 248),
    0,
    0,
    nil
}, {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(0, 0, 0),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(255, 255, 255),
    0,
    0,
    nil
})
v730("Rare", "Ancient", {
    "Ancient2",
    Color3.fromRGB(255, 255, 255),
    0,
    0,
    nil
}, {
    "Ancient1",
    Color3.fromRGB(255, 255, 255),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(164, 189, 71),
    0,
    0,
    nil
})
v730("Rare", "Grass", {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(205, 205, 205),
    0,
    0,
    nil
}, {
    "Grass1",
    Color3.fromRGB(223, 223, 222),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(138, 171, 133),
    0,
    0,
    nil
})
v730("Rare", "Rustic", {
    "RusticWood",
    Color3.fromRGB(124, 92, 70),
    0,
    0,
    nil
}, {
    "BrushedMetal",
    Color3.fromRGB(202, 203, 209),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(221, 177, 145),
    0,
    0,
    nil
})
v730("Rare", "Chrome Webs", {
    "Chrome Webs",
    Color3.fromRGB(0, 0, 0),
    0,
    0,
    nil
}, {
    "Chrome Webs",
    Color3.fromRGB(0, 0, 0),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(0, 0, 0),
    0,
    0,
    nil
})
v730("Rare", "Green Goo", {
    Enum.Material.Neon,
    Color3.fromRGB(83, 161, 82),
    0,
    0,
    "GooWelds"
}, {
    Enum.Material.Plastic,
    Color3.fromRGB(76, 46, 29),
    0,
    0,
    "GooStudsG"
}, {
    Enum.Material.Neon,
    Color3.fromRGB(83, 161, 82),
    0,
    0,
    "GooWelds"
})
v730("Rare", "Purple Goo", {
    Enum.Material.Neon,
    Color3.fromRGB(88, 54, 163),
    0,
    0,
    "GooWelds"
}, {
    Enum.Material.Plastic,
    Color3.fromRGB(27, 42, 53),
    0,
    0,
    "GooStudsP"
}, {
    Enum.Material.Neon,
    Color3.fromRGB(88, 54, 163),
    0,
    0,
    "GooWelds"
})
v730("Rare", "Werewolf Fur", {
    "Werewolf Fur",
    Color3.fromRGB(111, 85, 34),
    0,
    0,
    nil
}, {
    "Werewolf Fur",
    Color3.fromRGB(74, 56, 23),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(170, 75, 75),
    0,
    0,
    nil
})
v730("Rare", "Snowfall", {
    Enum.Material.Neon,
    Color3.fromRGB(255, 255, 255),
    0,
    0,
    "Snowfall"
}, {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(0, 0, 0),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(159, 159, 159),
    0,
    0,
    nil
})
v730("Rare", "Ugly Sweater", {
    "UglySweater",
    Color3.fromRGB(255, 255, 255),
    0,
    0,
    nil
}, {
    "UglySweater2",
    Color3.fromRGB(39, 70, 45),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(149, 167, 148),
    0,
    0,
    nil
})
v730("Rare", "Jolly Wrapping", {
    "WrappingPaper",
    Color3.fromRGB(20, 135, 77),
    0,
    0,
    "JollyWrapping"
}, {
    "WrappingPearlescent",
    Color3.fromRGB(247, 42, 55),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(247, 71, 74),
    0,
    0,
    nil
})
v730("Rare", "Forest Wrapping", {
    "WrappingPaper",
    Color3.fromRGB(59, 93, 57),
    0,
    0,
    nil
}, {
    "WrappingPearlescent2",
    Color3.fromRGB(252, 252, 252),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(129, 172, 122),
    0,
    0,
    nil
})
v730("Rare", "Peppermint Wrapping", {
    "WrappingPaper",
    Color3.fromRGB(202, 56, 59),
    0,
    0,
    nil
}, {
    "WrappingPearlescent2",
    Color3.fromRGB(252, 252, 252),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(185, 95, 95),
    0,
    0,
    nil
})
v730("Rare", "Winter Wrapping", {
    "WrappingPaper",
    Color3.fromRGB(22, 78, 130),
    0,
    0,
    "WinterWrapping"
}, {
    "WrappingPearlescent",
    Color3.fromRGB(252, 252, 252),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(135, 146, 177),
    0,
    0,
    nil
})
v730("Rare", "Mocha Wrapping", {
    "WrappingPaper",
    Color3.fromRGB(206, 176, 158),
    0,
    0,
    nil
}, {
    "WrappingPearlescent",
    Color3.fromRGB(116, 93, 87),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(179, 157, 135),
    0,
    0,
    nil
})
v730("Rare", "Minty Wrapping", {
    "WrappingPaper",
    Color3.fromRGB(38, 150, 126),
    0,
    0,
    "MintyWrapping"
}, {
    "WrappingPearlescent",
    Color3.fromRGB(32, 144, 116),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(103, 179, 160),
    0,
    0,
    nil
})
v730("Rare", "Frosty Wrapping", {
    "WrappingPaper",
    Color3.fromRGB(194, 194, 194),
    0,
    0,
    "FrostyWrapping"
}, {
    "WrappingPearlescent",
    Color3.fromRGB(217, 239, 255),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(179, 179, 179),
    0,
    0,
    nil
})
v730("Rare", "Creme Wrapping", {
    "WrappingPaper",
    Color3.fromRGB(150, 47, 69),
    0,
    0,
    "CremeWrapping"
}, {
    "WrappingPearlescent",
    Color3.fromRGB(184, 58, 85),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(184, 101, 119),
    0,
    0,
    nil
})
v730("Rare", "Blush Wrapping", {
    "WrappingPaper",
    Color3.fromRGB(247, 175, 218),
    0,
    0,
    "BlushWrapping"
}, {
    "WrappingPearlescent",
    Color3.fromRGB(230, 140, 152),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(230, 140, 152),
    0,
    0,
    nil
})
v730("Rare", "Cashmere Wrapping", {
    "WrappingPaper",
    Color3.fromRGB(186, 135, 112),
    0,
    0,
    nil
}, {
    "WrappingPearlescent",
    Color3.fromRGB(255, 158, 128),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(255, 149, 128),
    0,
    0,
    nil
})
v730("Rare", "Carbon Wrapping", {
    "WrappingPaper",
    Color3.fromRGB(56, 58, 59),
    0,
    0,
    "CarbonWrapping"
}, {
    "WrappingPearlescent",
    Color3.fromRGB(83, 97, 103),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(151, 157, 179),
    0,
    0,
    nil
})
v730("Rare", "Caned Wrapping", {
    "WrappingPaper",
    Color3.fromRGB(181, 47, 65),
    0,
    0,
    "CanedWrapping"
}, {
    "WrappingPearlescent",
    Color3.fromRGB(150, 39, 56),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(171, 84, 98),
    0,
    0,
    nil
})
v730("Rare", "Arbiter", {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(36, 56, 70),
    0,
    0,
    "Arbiter"
}, {
    "Arbiter",
    Color3.fromRGB(255, 255, 255),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(120, 135, 171),
    0,
    0,
    nil
})
v730("Rare", "Antimatter", {
    Enum.Material.Neon,
    Color3.fromRGB(255, 0, 4),
    0,
    0,
    "Antimatter1"
}, {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(71, 0, 0),
    0,
    0,
    "Antimatter2"
}, {
    Enum.Material.Neon,
    Color3.fromRGB(157, 0, 0),
    0,
    0,
    nil
})
v730("Rare", "Crimson Art", {
    "CrimsonArt",
    Color3.fromRGB(213, 213, 213),
    0,
    0,
    "CrimsonArt1"
}, {
    "CrimsonArt",
    Color3.fromRGB(248, 248, 248),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(159, 73, 73),
    0,
    0,
    nil
})
v730("Rare", "Model", {
    "RBLXPckge",
    Color3.fromRGB(248, 248, 248),
    0,
    0,
    nil
}, {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(163, 162, 165),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(88, 111, 166),
    0,
    0,
    nil
})
v730("Rare", "Plasma", {
    Enum.Material.Neon,
    Color3.fromRGB(163, 137, 176),
    0,
    0,
    "Plasma1"
}, {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(81, 0, 179),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(155, 130, 167),
    0,
    0,
    nil
})
v730("Rare", "Purpleize", {
    "Purpleize",
    Color3.fromRGB(224, 178, 208),
    0,
    0,
    nil
}, {
    "Purpleize",
    Color3.fromRGB(167, 94, 155),
    0,
    0.05,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(163, 122, 172),
    0,
    0,
    nil
})
v730("Rare", "Regal", {
    "RegalFabric",
    Color3.fromRGB(186, 0, 0),
    0,
    0.3,
    nil
}, {
    Enum.Material.Glass,
    Color3.fromRGB(243, 182, 0),
    0,
    0.6,
    "Regal"
}, {
    Enum.Material.Neon,
    Color3.fromRGB(171, 125, 99),
    0,
    0,
    nil
})
v730("Rare", "Sentinel", {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(255, 255, 255),
    0,
    0.5,
    "Sentinel"
}, {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(255, 255, 255),
    0,
    0.5,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(168, 143, 124),
    0,
    0,
    nil
})
v730("Rare", "Strobe", {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(17, 17, 17),
    0,
    0,
    "Strobe1"
}, {
    Enum.Material.Neon,
    Color3.fromRGB(17, 17, 17),
    0,
    0,
    "Strobe2"
}, {
    Enum.Material.Neon,
    Color3.fromRGB(111, 158, 166),
    0,
    0,
    nil
})
v730("Rare", "TIX", {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(19, 21, 22),
    0,
    0,
    "TIXWRAP"
}, {
    Enum.Material.Plastic,
    Color3.fromRGB(71, 44, 12),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(166, 146, 85),
    0,
    0,
    nil
})
v730("Rare", "Tealur", {
    Enum.Material.Neon,
    Color3.fromRGB(73, 166, 138),
    0,
    0,
    "Tealur"
}, {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(23, 23, 23),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(70, 159, 131),
    0,
    0,
    nil
})
v730("Rare", "Waste", {
    Enum.Material.Neon,
    Color3.fromRGB(0, 168, 67),
    0,
    0,
    "Waste1"
}, {
    Enum.Material.Neon,
    Color3.fromRGB(0, 0, 0),
    0,
    0,
    "Waste2"
}, {
    Enum.Material.Neon,
    Color3.fromRGB(58, 158, 58),
    0,
    0,
    nil
})
v730("Rare", "Lovely Leopard", {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(248, 248, 248),
    0,
    0,
    "LovelyLeopard1"
}, {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(17, 17, 17),
    0,
    0,
    "LovelyLeopard2"
}, {
    Enum.Material.Neon,
    Color3.fromRGB(161, 119, 162),
    0,
    0,
    nil
})
v730("Rare", "Facility", {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(57, 58, 72),
    0,
    0,
    "Facility"
}, {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(159, 163, 191),
    0,
    0,
    nil
}, {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(57, 58, 72),
    0,
    0,
    nil
})
v730("Rare", "Vigor", {
    "Vigor",
    Color3.fromRGB(255, 71, 135),
    0,
    0,
    "Vigor1"
}, {
    "Vigor",
    Color3.fromRGB(231, 64, 123),
    0,
    0,
    "Vigor2"
}, {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(255, 37, 95),
    0.33,
    0.4,
    nil
})
v730("Rare", "Bliss", {
    Enum.Material.Glass,
    Color3.fromRGB(164, 166, 255),
    0,
    0.3,
    nil
}, {
    "Bliss",
    Color3.fromRGB(132, 119, 173),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(133, 126, 206),
    0,
    0,
    nil
})
v730("Rare", "Holly Wrapping", {
    "WrappingPaper_01a",
    Color3.fromRGB(135, 33, 33),
    0,
    0,
    "Holly_Wrapping_1"
}, {
    "Pearlescent_01b",
    Color3.fromRGB(61, 149, 72),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(102, 180, 111),
    0,
    0,
    nil
})
v730("Rare", "Fortune Wrapping", {
    "WrappingPaper_01a",
    Color3.fromRGB(45, 85, 55),
    0,
    0,
    "Wrapped_Fortune_1"
}, {
    "Pearlescent_01a",
    Color3.fromRGB(255, 196, 93),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(207, 169, 113),
    0,
    0,
    nil
})
v730("Rare", "Pearly Wrapping", {
    "WrappingPaper_01a",
    Color3.fromRGB(218, 195, 173),
    0,
    0,
    "Pearly_Wrapping_1"
}, {
    "Pearlescent_01b",
    Color3.fromRGB(255, 236, 220),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(167, 154, 144),
    0,
    0,
    nil
})
v730("Rare", "Polar Wrapping", {
    "WrappingPaper_01a",
    Color3.fromRGB(15, 15, 15),
    0,
    0,
    "Polar_Wrapping_1"
}, {
    "Pearlescent_01b",
    Color3.fromRGB(233, 241, 255),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(155, 161, 170),
    0,
    0,
    nil
})
v730("Rare", "Chilled Wrapping", {
    "WrappingPaper_01a",
    Color3.fromRGB(98, 221, 232),
    0,
    0,
    "Chilled_Wrapping_1"
}, {
    "Pearlescent_01b",
    Color3.fromRGB(110, 212, 255),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(112, 196, 204),
    0,
    0,
    nil
})
v730("Rare", "Luxury Wrapping", {
    "WrappingPaper_01a",
    Color3.fromRGB(59, 58, 57),
    0,
    0,
    "Wrapped_Luxury_1"
}, {
    "Pearlescent_01b",
    Color3.fromRGB(255, 233, 190),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(180, 170, 152),
    0,
    0,
    nil
})
v730("Rare", "Regal Wrapping", {
    "WrappingPaper_01a",
    Color3.fromRGB(149, 30, 48),
    0,
    0,
    "Regal_Wrapping_1"
}, {
    "Pearlescent_01b",
    Color3.fromRGB(255, 191, 87),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(207, 154, 113),
    0,
    0,
    nil
})
v730("Rare", "Mousse Wrapping", {
    "WrappingPaper_01a",
    Color3.fromRGB(134, 98, 82),
    0,
    0,
    nil
}, {
    "Pearlescent_01b",
    Color3.fromRGB(117, 85, 72),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(166, 123, 106),
    0,
    0,
    nil
})
v730("Rare", "Periwinkle Wrapping", {
    "WrappingPaper_01a",
    Color3.fromRGB(190, 187, 227),
    0,
    0,
    nil
}, {
    "Pearlescent_01a",
    Color3.fromRGB(95, 70, 107),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(159, 128, 174),
    0,
    0,
    nil
})
v730("Rare", "Evergreen Wrapping", {
    "WrappingPaper_01a",
    Color3.fromRGB(59, 93, 57),
    0,
    0,
    nil
}, {
    "Pearlescent_01a",
    Color3.fromRGB(98, 153, 94),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(113, 170, 107),
    0,
    0,
    nil
})
v730("Rare", "Dusky Wrapping", {
    "WrappingPaper_01a",
    Color3.fromRGB(64, 73, 107),
    0,
    0,
    nil
}, {
    "Pearlescent_01a",
    Color3.fromRGB(117, 134, 171),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(129, 144, 180),
    0,
    0,
    nil
})
v730("Rare", "Merlot Wrapping", {
    "WrappingPaper_01a",
    Color3.fromRGB(143, 47, 65),
    0,
    0,
    nil
}, {
    "Pearlescent_01a",
    Color3.fromRGB(202, 67, 94),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(194, 118, 136),
    0,
    0,
    nil
})
v730("Rare", "Indigo Wrapping", {
    "WrappingPaper_01a",
    Color3.fromRGB(56, 24, 161),
    0,
    0,
    "Indigo_Wrapping_1"
}, {
    "Pearlescent_01b",
    Color3.fromRGB(78, 46, 184),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(135, 122, 184),
    0,
    0,
    nil
})
v730("Rare", "Cold Metal", {
    Enum.Material.Metal,
    Color3.fromRGB(81, 88, 100),
    0,
    0,
    "Cold_Metal_1"
}, {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(97, 104, 120),
    0,
    0.1,
    "Cold_Metal_2"
}, {
    Enum.Material.Glass,
    Color3.fromRGB(130, 136, 153),
    0,
    0,
    nil
})
v730("Rare", "Winter Solstice", {
    "CandyGlossy",
    Color3.fromRGB(248, 248, 248),
    0,
    0,
    "Winter_Solstice_1"
}, {
    "CandyGlossy",
    Color3.fromRGB(248, 248, 248),
    0,
    0,
    "Winter_Solstice_2"
}, {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(162, 218, 255),
    0,
    0.02,
    nil
})
v730("Rare", "Mintbread", {
    Enum.Material.Sand,
    Color3.fromRGB(111, 76, 63),
    0,
    0,
    "Mintbread_1"
}, {
    "WrappingPaper",
    Color3.fromRGB(248, 248, 248),
    0,
    0,
    "Mintbread_2"
}, {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(135, 27, 19),
    0,
    0.1,
    nil
})
v730("Legendary", "Diamond", {
    "Diamond",
    Color3.fromRGB(255, 255, 255),
    0,
    0,
    nil
}, {
    Enum.Material.Glass,
    Color3.fromRGB(255, 170, 24),
    0,
    0.4,
    nil
}, {
    nil,
    Color3.fromRGB(255, 165, 120),
    nil,
    nil,
    nil
}, nil, "Earned from weapon contracts", "Earned from a weapon contract for this weapon")
v730("Legendary", "Scorched", {
    "Scorched",
    Color3.fromRGB(171, 171, 171),
    0,
    0,
    nil
}, {
    "Scorched",
    Color3.fromRGB(43, 43, 43),
    0,
    0,
    nil
}, {
    nil,
    Color3.fromRGB(255, 79, 25),
    nil,
    nil,
    nil
})
v730("Legendary", "Glass", {
    Enum.Material.Glass,
    Color3.fromRGB(255, 255, 255),
    0.5,
    0,
    nil
}, {
    Enum.Material.Glass,
    Color3.fromRGB(255, 255, 255),
    0.5,
    0,
    nil
}, {
    Enum.Material.Glass,
    Color3.fromRGB(255, 255, 255),
    0.5,
    0,
    nil
})
v730("Legendary", "Malevolent", {
    "Malevolent",
    Color3.fromRGB(163, 162, 165),
    0,
    0,
    nil
}, {
    Enum.Material.Glass,
    Color3.fromRGB(25, 15, 39),
    0,
    0,
    nil
}, {
    nil,
    Color3.fromRGB(78, 43, 168),
    nil,
    nil,
    nil
})
v730("Legendary", "Omnisand", {
    "Omnisand",
    Color3.fromRGB(255, 255, 255),
    0,
    0,
    nil
}, {
    "Omnisand",
    Color3.fromRGB(81, 81, 81),
    0,
    0,
    nil
}, {
    nil,
    Color3.fromRGB(166, 97, 48),
    nil,
    nil,
    nil
})
v730("Legendary", "Quasar", {
    Enum.Material.Neon,
    Color3.fromRGB(255, 72, 0),
    0,
    0,
    "Quasar"
}, {
    Enum.Material.Neon,
    Color3.fromRGB(255, 72, 0),
    0,
    0,
    "Quasar"
}, {
    nil,
    Color3.fromRGB(255, 105, 94),
    nil,
    nil,
    nil
})
v730("Legendary", "Slime", {
    "Slime",
    Color3.fromRGB(248, 248, 248),
    0,
    0,
    nil
}, {
    "Slime",
    Color3.fromRGB(70, 53, 0),
    0,
    0,
    nil
}, {
    nil,
    Color3.fromRGB(76, 255, 48),
    nil,
    nil,
    nil
})
v730("Legendary", "Water", {
    Enum.Material.Neon,
    Color3.fromRGB(170, 170, 170),
    0,
    0,
    "Water1"
}, {
    Enum.Material.Neon,
    Color3.fromRGB(46, 89, 107),
    0,
    0,
    "Water2"
}, {
    Enum.Material.Neon,
    Color3.fromRGB(77, 129, 175),
    0,
    0,
    nil
})
v730("Legendary", "Black Opal", {
    Enum.Material.Neon,
    Color3.fromRGB(96, 241, 96),
    0,
    0,
    "BlackOpal"
}, {
    "Black Opal",
    Color3.fromRGB(17, 17, 17),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(92, 163, 125),
    0,
    0,
    nil
})
v730("Legendary", "Hesper", {
    "Hesper",
    Color3.fromRGB(248, 248, 248),
    0,
    0,
    nil
}, {
    "Hesper",
    Color3.fromRGB(11, 33, 48),
    0,
    0,
    nil
}, {
    nil,
    Color3.fromRGB(255, 118, 76),
    nil,
    nil,
    nil
})
v730("Legendary", "Sunset", {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(0, 0, 0),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(213, 115, 61),
    0,
    0,
    "Sunset"
}, {
    Enum.Material.Neon,
    Color3.fromRGB(213, 115, 61),
    0,
    0,
    nil
})
v730("Legendary", ".exe", {
    Enum.Material.Neon,
    Color3.fromRGB(138, 225, 118),
    0,
    0,
    ".exe"
}, {
    Enum.Material.Neon,
    Color3.fromRGB(0, 0, 0),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(138, 225, 118),
    0,
    0,
    nil
})
v730("Legendary", "Disco", {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(255, 255, 255),
    0,
    0.5,
    "Disco"
}, {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(255, 255, 255),
    0,
    0.5,
    nil
}, {
    nil,
    Color3.fromRGB(255, 255, 255),
    nil,
    nil,
    nil
}, nil, "Included in the Standard Weapons Bundle")
v730("Legendary", "Classic", {
    Enum.Material.Plastic,
    Color3.fromRGB(27, 42, 53),
    0,
    0,
    nil
}, {
    Enum.Material.Plastic,
    Color3.fromRGB(27, 42, 53),
    0,
    0,
    nil
}, {
    Enum.Material.Plastic,
    Color3.fromRGB(27, 42, 53),
    0.5,
    0,
    nil
}, nil, "Included in the Classic Bundle")
v730("Legendary", "Magma", {
    Enum.Material.Neon,
    Color3.fromRGB(255, 141, 75),
    0,
    0,
    "Magma"
}, {
    Enum.Material.Neon,
    Color3.fromRGB(255, 141, 75),
    0,
    0,
    "Magma"
}, {
    nil,
    Color3.fromRGB(255, 141, 75),
    nil,
    nil,
    nil
}, nil, "Included in the Heavy Duty Bundle")
v730("Legendary", "Nebula", {
    Enum.Material.Neon,
    Color3.fromRGB(137, 100, 248),
    0,
    0,
    "Nebula1"
}, {
    Enum.Material.Neon,
    Color3.fromRGB(199, 171, 255),
    0,
    0,
    "Nebula2"
}, {
    nil,
    Color3.fromRGB(133, 103, 255),
    nil,
    nil,
    nil
}, nil, "Included in the Exogun Bundle")
v730("Legendary", "Aurum", {
    Enum.Material.Neon,
    Color3.fromRGB(176, 130, 74),
    0,
    0,
    "Aurum"
}, {
    "Aurum",
    Color3.fromRGB(17, 17, 17),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(175, 128, 80),
    0,
    0,
    nil
}, nil, "Included in the Medkit Bundle")
v730("Legendary", "Paint", {
    "Paint",
    Color3.fromRGB(255, 255, 255),
    0,
    0,
    nil
}, {
    Enum.Material.Glass,
    Color3.fromRGB(212, 212, 212),
    0,
    0.1,
    nil
}, {
    nil,
    Color3.fromRGB(212, 212, 212),
    nil,
    nil,
    nil
}, nil, "Included in the Starter Bundle")
v730("Legendary", "Geometric", {
    "Geometric",
    nil,
    nil,
    nil,
    nil
}, {
    "Geometric",
    nil,
    nil,
    nil,
    nil
}, {
    "Geometric",
    nil,
    nil,
    nil,
    nil
}, nil, "Included in the Pixel Bundle")
v730("Legendary", ".dll", {
    Enum.Material.Neon,
    Color3.fromRGB(108, 134, 223),
    0,
    0,
    ".dll"
}, {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(0, 0, 0),
    0,
    0.05,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(97, 123, 184),
    0,
    0,
    nil
}, nil, "Included in the Energy Bundle")
v730("Legendary", "Cardboard", {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(143, 121, 89),
    0,
    0,
    "Cardboard1"
}, {
    Enum.Material.Plaster,
    Color3.fromRGB(117, 98, 72),
    0,
    0,
    "Cardboard2"
}, {
    Enum.Material.Neon,
    Color3.fromRGB(161, 130, 109),
    0,
    0,
    nil
}, nil, "Included in the RPG Bundle")
v730("Legendary", "Wealth", {
    "Wealth",
    Color3.fromRGB(0, 255, 0),
    0,
    0,
    nil
}, {
    "Wealth",
    Color3.fromRGB(0, 0, 0),
    0,
    0,
    nil
}, {
    nil,
    Color3.fromRGB(95, 252, 100),
    nil,
    nil,
    nil
}, nil, "Used to be included in Key Bundles")
v730("Legendary", "Lucre", {
    "Wealth",
    Color3.fromRGB(255, 213, 0),
    0,
    0,
    nil
}, {
    "Wealth",
    Color3.fromRGB(0, 0, 0),
    0,
    0,
    nil
}, {
    nil,
    Color3.fromRGB(255, 140, 73),
    nil,
    nil,
    nil
}, nil, "Used to be included in Key Bundles")
v730("Legendary", "Luxurious", {
    Enum.Material.Glass,
    Color3.fromRGB(255, 176, 0),
    0,
    0.6,
    "Luxurious"
}, {
    Enum.Material.Glass,
    Color3.fromRGB(255, 176, 0),
    0,
    0.6,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(167, 156, 117),
    0,
    0,
    nil
}, nil, "Included in Key Bundles")
v730("Legendary", "Supernova", {
    Enum.Material.Neon,
    Color3.fromRGB(255, 255, 255),
    0,
    0,
    "Supernova"
}, {
    Enum.Material.Neon,
    Color3.fromRGB(255, 255, 255),
    0,
    0,
    "Supernova"
}, {
    nil,
    Color3.fromRGB(84, 246, 255),
    nil,
    nil,
    nil
}, nil, "Legendary drop from Daily Tasks")
v730("Legendary", "Groove", {
    "Groove",
    Color3.fromRGB(255, 255, 255),
    0,
    0,
    nil
}, {
    "Groove",
    Color3.fromRGB(0, 0, 0),
    0,
    0,
    nil
}, {
    nil,
    Color3.fromRGB(255, 99, 99),
    nil,
    nil,
    nil
}, nil, "Used to be purchased from the Shop")
v730("Legendary", "Blaze", {
    Enum.Material.Neon,
    Color3.fromRGB(255, 0, 0),
    0,
    0,
    "Blaze1"
}, {
    Enum.Material.Neon,
    Color3.fromRGB(154, 85, 32),
    0,
    0,
    "Blaze2"
}, {
    nil,
    Color3.fromRGB(255, 106, 69),
    nil,
    nil,
    nil
}, nil, "Earned by winning 100 duels in a row")
v730("Legendary", "Beach", {
    nil,
    Color3.fromRGB(42, 157, 143),
    0,
    0,
    nil
}, {
    nil,
    Color3.fromRGB(233, 196, 106),
    0,
    0,
    nil
}, {
    nil,
    Color3.fromRGB(119, 207, 255),
    nil,
    nil,
    nil
}, nil, "Used to be purchased from the Shop")
v730("Legendary", "Malachite", {
    "Malachite",
    Color3.fromRGB(255, 255, 255),
    0,
    0,
    nil
}, {
    Enum.Material.Glass,
    Color3.fromRGB(0, 0, 0),
    0,
    0,
    nil
}, {
    nil,
    Color3.fromRGB(94, 255, 148),
    nil,
    nil,
    nil
})
v730("Legendary", "Arabesque", {
    "Arabesque",
    Color3.fromRGB(98, 77, 0),
    0,
    0.2,
    nil
}, {
    Enum.Material.Glass,
    Color3.fromRGB(98, 77, 0),
    0,
    0.4,
    nil
}, {
    nil,
    Color3.fromRGB(170, 154, 115),
    nil,
    nil,
    nil
})
v730("Legendary", "Webbed", {
    "Webbed",
    Color3.fromRGB(117, 0, 0),
    0,
    0,
    nil
}, {
    Enum.Material.Glass,
    Color3.fromRGB(27, 0, 0),
    0,
    0,
    nil
}, {
    nil,
    Color3.fromRGB(255, 69, 69),
    nil,
    nil,
    nil
})
v730("Legendary", "Lightning", {
    Enum.Material.Neon,
    Color3.fromRGB(255, 125, 92),
    0,
    0,
    "Lightning"
}, {
    Enum.Material.Glass,
    Color3.fromRGB(72, 34, 14),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(166, 123, 94),
    0,
    0,
    nil
})
v730("Legendary", "Plastic", {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(255, 255, 255),
    0.5,
    0.5,
    nil
}, {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(255, 255, 255),
    0.5,
    0.5,
    nil
}, {
    nil,
    Color3.fromRGB(255, 255, 255),
    nil,
    nil,
    nil
})
v730("Legendary", "Chrome", {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(255, 255, 255),
    0,
    1,
    nil
}, {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(255, 255, 255),
    0,
    1,
    nil
}, {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(255, 255, 255),
    0,
    1,
    nil
})
v730("Legendary", "A5", {
    "A5",
    Color3.fromRGB(255, 255, 255),
    0,
    0,
    nil
}, {
    Enum.Material.Concrete,
    Color3.fromRGB(255, 220, 192),
    0,
    0,
    nil
}, {
    nil,
    Color3.fromRGB(255, 139, 139),
    nil,
    nil,
    nil
})
v730("Legendary", "Amber", {
    "Amber",
    Color3.fromRGB(255, 255, 255),
    0,
    0,
    nil
}, {
    "Amber",
    Color3.fromRGB(0, 0, 0),
    0,
    0,
    nil
}, {
    nil,
    Color3.fromRGB(255, 158, 93),
    nil,
    nil,
    nil
})
v730("Legendary", "Insidious", {
    "Insidious",
    Color3.fromRGB(190, 104, 98),
    0,
    0,
    nil
}, {
    "Insidious",
    Color3.fromRGB(0, 0, 0),
    0,
    0,
    nil
}, {
    nil,
    Color3.fromRGB(255, 111, 111),
    nil,
    nil,
    nil
})
v730("Legendary", "Iridescent", {
    Enum.Material.Neon,
    Color3.fromRGB(166, 145, 211),
    0,
    0,
    "Iridescent1"
}, {
    Enum.Material.Neon,
    Color3.fromRGB(166, 145, 211),
    0,
    0,
    "Iridescent2"
}, {
    Enum.Material.Neon,
    Color3.fromRGB(156, 143, 163),
    0,
    0,
    nil
})
v730("Legendary", "Moonstone", {
    "Moonstone",
    Color3.fromRGB(255, 255, 255),
    0,
    0,
    nil
}, {
    "Moonstone",
    Color3.fromRGB(0, 0, 0),
    0,
    0,
    nil
}, {
    nil,
    Color3.fromRGB(146, 160, 190),
    nil,
    nil,
    nil
})
v730("Legendary", "Bright", {
    Enum.Material.Neon,
    Color3.fromRGB(160, 160, 160),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(160, 160, 160),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(160, 160, 160),
    0,
    0,
    nil
})
v730("Legendary", "Dark", {
    Enum.Material.Neon,
    Color3.fromRGB(0, 0, 0),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(0, 0, 0),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(0, 0, 0),
    0,
    0,
    nil
})
v730("Legendary", "Mischief", {
    Enum.Material.Neon,
    Color3.fromRGB(0, 0, 0),
    0,
    0,
    "Mischief"
}, {
    Enum.Material.Glass,
    Color3.fromRGB(53, 39, 94),
    0,
    0,
    nil
}, {
    nil,
    Color3.fromRGB(139, 131, 255),
    nil,
    nil,
    nil
})
v730("Legendary", "Carbon Fiber", {
    "Carbon Fiber",
    Color3.fromRGB(17, 17, 17),
    0,
    0,
    nil
}, {
    "Carbon Fiber",
    Color3.fromRGB(248, 248, 248),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(0, 0, 0),
    0,
    0,
    nil
})
v730("Legendary", "Hyperdrive", {
    "Hyperdrive",
    Color3.fromRGB(248, 248, 248),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(143, 156, 173),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(159, 173, 192),
    0,
    0,
    nil
})
v730("Legendary", "Insignia", {
    "Insignia",
    Color3.fromRGB(248, 248, 248),
    0,
    0,
    nil
}, {
    "Insignia",
    Color3.fromRGB(17, 17, 17),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(199, 172, 120),
    0,
    0,
    nil
})
v730("Legendary", "Liquid Gold", {
    "Liquid Gold",
    Color3.fromRGB(180, 123, 0),
    0,
    0,
    nil
}, {
    "Liquid Gold",
    Color3.fromRGB(255, 176, 0),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(199, 172, 120),
    0,
    0,
    nil
})
v730("Legendary", "Cardinal", {
    "Cardinal",
    Color3.fromRGB(255, 175, 175),
    0,
    0,
    nil
}, {
    "Cardinal",
    Color3.fromRGB(17, 17, 17),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(227, 74, 76),
    0,
    0,
    nil
})
v730("Legendary", "Starblaze", {
    "Starblaze 2",
    Color3.fromRGB(248, 248, 248),
    0,
    0,
    nil
}, {
    "Starblaze 1",
    Color3.fromRGB(0, 0, 0),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(177, 35, 25),
    0,
    0,
    nil
})
v730("Legendary", "Starfall", {
    "Hyperdrive",
    Color3.fromRGB(9, 137, 207),
    0,
    0,
    nil
}, {
    "Starblaze 1",
    Color3.fromRGB(0, 255, 255),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(24, 74, 255),
    0,
    0,
    nil
})
v730("Legendary", "Tiger", {
    "Tiger",
    Color3.fromRGB(255, 114, 14),
    0,
    0,
    nil
}, {
    "Tiger",
    Color3.fromRGB(17, 17, 17),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(255, 86, 7),
    0,
    0,
    nil
})
v730("Legendary", "Watermelon", {
    "Watermelon Red",
    Color3.fromRGB(255, 131, 131),
    0,
    0,
    nil
}, {
    "Watermelon Green",
    Color3.fromRGB(204, 255, 204),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(163, 75, 75),
    0,
    0,
    nil
}, nil, "Used to be purchased from the Shop")
v730("Legendary", "Damascus", {
    "Damascus",
    Color3.fromRGB(255, 255, 255),
    0,
    0,
    nil
}, {
    Enum.Material.Glass,
    Color3.fromRGB(0, 0, 0),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(195, 195, 195),
    0,
    0,
    nil
}, nil, "Used to be purchased from the Shop")
v730("Legendary", "Black Damascus", {
    "BlackDamascus",
    Color3.fromRGB(0, 0, 0),
    0,
    0,
    nil
}, {
    Enum.Material.Glass,
    Color3.fromRGB(0, 0, 0),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(0, 0, 0),
    0,
    0,
    nil
}, nil, "Used to be purchased from the Shop")
v730("Legendary", "Pixel Blight", {
    Enum.Material.Neon,
    nil,
    0,
    0,
    "PixelBlight",
    "PixelBlight"
}, {
    Enum.Material.Neon,
    nil,
    0,
    0,
    "PixelBlight",
    "PixelBlight"
}, {
    Enum.Material.Neon,
    nil,
    0,
    0,
    nil
}, nil, "Used to be purchased from the Shop")
v730("Legendary", "Empress", {
    Enum.Material.Neon,
    Color3.fromRGB(255, 255, 255),
    0,
    0,
    "Empress"
}, {
    Enum.Material.Neon,
    Color3.fromRGB(255, 255, 255),
    0,
    0,
    "Empress"
}, {
    Enum.Material.Neon,
    Color3.fromRGB(172, 150, 181),
    0,
    0,
    nil
}, nil, "Used to be purchased from the Shop")
v730("Legendary", "Arena", {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(151, 153, 163),
    0,
    0,
    "ArenaTex"
}, {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(132, 134, 143),
    0,
    0,
    "ArenaTex"
}, {
    Enum.Material.Neon,
    Color3.fromRGB(151, 153, 163),
    0,
    0,
    nil
}, nil, "Purchased from the Shop")
v730("Legendary", "Simulation", {
    Enum.Material.Neon,
    Color3.fromRGB(30, 98, 153),
    0,
    0,
    "Simulation_1"
}, {
    Enum.Material.Neon,
    Color3.fromRGB(16, 51, 81),
    0,
    0,
    "Simulation_2"
}, {
    Enum.Material.Neon,
    Color3.fromRGB(80, 122, 170),
    0,
    0,
    nil
}, nil, "Used to be purchased from the Shop")
v730("Legendary", "Sunset Sparkle", {
    Enum.Material.Neon,
    Color3.fromRGB(255, 137, 137),
    0,
    0,
    "SunsetSparkle1"
}, {
    Enum.Material.Neon,
    Color3.fromRGB(88, 0, 117),
    0,
    0,
    "SunsetSparkle2"
}, {
    Enum.Material.Neon,
    Color3.fromRGB(161, 122, 90),
    0,
    0,
    nil
}, nil, "Used to be purchased from the Shop")
v730("Legendary", "Messis", {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(17, 17, 17),
    0,
    0,
    "Messis1"
}, {
    Enum.Material.Neon,
    Color3.fromRGB(0, 0, 0),
    0,
    0,
    "Messis2"
}, {
    Enum.Material.Neon,
    Color3.fromRGB(82, 159, 72),
    0,
    0,
    nil
}, nil, "Used to be purchased from the Shop")
v730("Legendary", "Birthday Wrapping", {
    "WrappingPaper_01c",
    Color3.fromRGB(68, 117, 223),
    0,
    0,
    nil
}, {
    "Pearlescent_01c",
    Color3.fromRGB(255, 173, 32),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(173, 150, 110),
    0,
    0,
    nil
}, nil, "Purchased from the Shop during the RIVALS Birthday Party")
v730("Legendary", "RIVALS Wrapping", {
    "WrappingPaper_01c",
    Color3.fromRGB(255, 148, 26),
    0,
    0,
    "RivalsWrapping"
}, {
    "Pearlescent_01d",
    Color3.fromRGB(161, 18, 166),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(145, 114, 172),
    0,
    0,
    nil
}, nil, "Purchased from the Shop during the RIVALS Birthday Party")
v730("Legendary", "Shadow Ink", {
    Enum.Material.Neon,
    Color3.fromRGB(0, 0, 0),
    0,
    0,
    "ShadowInk1"
}, {
    Enum.Material.Neon,
    Color3.fromRGB(0, 0, 0),
    0,
    0,
    "ShadowInk2"
}, {
    Enum.Material.Neon,
    Color3.fromRGB(91, 76, 171),
    0,
    0,
    nil
}, nil, "Used to be purchased from the Shop")
v730("Legendary", "Triplaser", {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(255, 255, 255),
    0,
    0.5,
    "Tripwire1"
}, {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(199, 199, 199),
    0,
    0.5,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(163, 73, 73),
    0,
    0,
    nil
}, nil, "Used to be purchased from the Shop")
v730("Legendary", "Hologram Arena", {
    Enum.Material.Glass,
    Color3.fromRGB(17, 17, 17),
    0.7,
    0,
    "HologramArena1"
}, {
    Enum.Material.Glass,
    Color3.fromRGB(17, 17, 17),
    0,
    0,
    "HologramArena2"
}, {
    Enum.Material.Neon,
    Color3.fromRGB(96, 155, 176),
    0,
    0,
    nil
}, nil, "Used to be purchased from the Shop")
v730("Legendary", "Honey", {
    "Honey",
    Color3.fromRGB(255, 159, 42),
    0,
    0,
    "Honey1"
}, {
    Enum.Material.Glass,
    Color3.fromRGB(212, 119, 19),
    0.25,
    0,
    "Honey2"
}, {
    Enum.Material.Neon,
    Color3.fromRGB(166, 110, 61),
    0,
    0,
    nil
}, nil, "Used to be purchased from the Shop")
v730("Legendary", "Ornamented", {
    Enum.Material.Glass,
    Color3.fromRGB(151, 25, 42),
    0,
    0.2,
    "Ornament_1"
}, {
    Enum.Material.Glass,
    Color3.fromRGB(190, 149, 115),
    0,
    -1.5,
    nil
}, {
    Enum.Material.Glass,
    Color3.fromRGB(173, 28, 50),
    0.2,
    0.1,
    nil
}, nil, "Purchased from the Shop")
v730("Legendary", "Frostbite", {
    Enum.Material.Neon,
    Color3.fromRGB(109, 113, 172),
    0,
    0,
    "Frostbite_1"
}, {
    "WrappingPearlescent",
    Color3.fromRGB(67, 78, 95),
    0,
    0,
    "Frostbite_2"
}, {
    Enum.Material.Glass,
    Color3.fromRGB(46, 54, 65),
    0.1,
    0,
    nil
}, nil, "Purchased from the Shop")
v730("Legendary", "Resolute", {
    "Resolute",
    Color3.fromRGB(0, 16, 176),
    0,
    0,
    nil
}, {
    "Resolute",
    Color3.fromRGB(0, 0, 0),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(0, 0, 255),
    0,
    0,
    nil
})
v730("Legendary", "Thunderburst", {
    Enum.Material.Neon,
    Color3.fromRGB(253, 234, 141),
    0,
    0,
    "Thunderburst"
}, {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(0, 0, 0),
    0,
    0.05,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(163, 160, 130),
    0,
    0,
    nil
})
v730("Legendary", "Encrypt", {
    "Encrypt",
    Color3.fromRGB(0, 172, 57),
    0,
    0,
    nil
}, {
    "Encrypt",
    Color3.fromRGB(0, 0, 0),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(131, 255, 129),
    0,
    0,
    nil
})
v730("Legendary", "Mummy", {
    Enum.Material.Neon,
    Color3.fromRGB(121, 171, 96),
    0,
    0,
    "Mummy"
}, {
    Enum.Material.Neon,
    Color3.fromRGB(121, 171, 96),
    0,
    0,
    "MummyDark"
}, {
    Enum.Material.Neon,
    Color3.fromRGB(121, 171, 96),
    0,
    0,
    nil
})
v730("Legendary", "Scourge", {
    "Scourge",
    Color3.fromRGB(170, 85, 0),
    0,
    0,
    nil
}, {
    "Scourge",
    Color3.fromRGB(17, 17, 17),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(168, 90, 0),
    0,
    0,
    nil
})
v730("Legendary", "Frankenstein", {
    "Frankenstein",
    Color3.fromRGB(83, 135, 0),
    0,
    0,
    nil
}, {
    "Frankenstein Metal",
    Color3.fromRGB(145, 161, 168),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(104, 163, 109),
    0,
    0,
    nil
})
v730("Legendary", "Hallow", {
    nil,
    Color3.fromRGB(0, 0, 0),
    0,
    0.05,
    nil
}, {
    nil,
    Color3.fromRGB(255, 119, 0),
    0,
    0.1,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(255, 119, 0),
    0,
    0,
    nil
}, nil, "Used to be purchased from the Shop")
v730("Legendary", "Greenflame", {
    Enum.Material.Neon,
    Color3.fromRGB(0, 255, 0),
    0,
    0,
    "Greenflame1"
}, {
    Enum.Material.Neon,
    Color3.fromRGB(117, 162, 48),
    0,
    0,
    "Greenflame2"
}, {
    nil,
    Color3.fromRGB(122, 255, 14),
    nil,
    nil,
    nil
}, nil, "Included in Candy Bundles")
v730("Legendary", "Aurora", {
    Enum.Material.Neon,
    Color3.fromRGB(129, 255, 110),
    0,
    0,
    "Aurora"
}, {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(17, 17, 17),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(129, 255, 110),
    0,
    0,
    nil
})
v730("Legendary", "Wintergreen", {
    "GlossyCandyCane2",
    Color3.fromRGB(255, 255, 255),
    0,
    0,
    nil
}, {
    "GlossyGeneric",
    Color3.fromRGB(0, 134, 19),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(102, 167, 104),
    0,
    0,
    nil
}, nil, "Used to be purchased from the Shop")
v730("Legendary", "Gingerbread", {
    "Gingerbread",
    Color3.fromRGB(225, 156, 107),
    0,
    0,
    "Gingerbread"
}, {
    "Gingerbread",
    Color3.fromRGB(86, 66, 54),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(167, 153, 130),
    0,
    0,
    nil
})
v730("Legendary", "Peppermint", {
    "GlossyCandyCane",
    Color3.fromRGB(255, 255, 255),
    0,
    0,
    nil
}, {
    "GlossyGeneric",
    Color3.fromRGB(255, 255, 255),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(161, 52, 52),
    0,
    0,
    nil
})
v730("Legendary", "Crystallized", {
    Enum.Material.Glass,
    Color3.fromRGB(18, 238, 212),
    0.85,
    0,
    "Crystallized"
}, {
    Enum.Material.Glass,
    Color3.fromRGB(18, 238, 212),
    0.85,
    0,
    "Crystallized"
}, {
    Enum.Material.Glass,
    Color3.fromRGB(175, 221, 255),
    0.5,
    0,
    nil
}, nil, "Included in Crystal Bundles")
v730("Legendary", "2025 Wrapping", {
    "WrappingPaper",
    Color3.fromRGB(59, 58, 57),
    0,
    0,
    "2025Wrapping"
}, {
    "WrappingPearlescent",
    Color3.fromRGB(255, 191, 87),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(179, 173, 88),
    0,
    0,
    nil
})
v730("Legendary", "2026 Wrapping", {
    "WrappingPaper",
    Color3.fromRGB(59, 58, 57),
    0,
    0,
    "2026Wrapping"
}, {
    "WrappingPearlescent",
    Color3.fromRGB(255, 191, 87),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(179, 173, 88),
    0,
    0,
    nil
})
v730("Legendary", "Bombastic", {
    Enum.Material.Neon,
    Color3.fromRGB(220, 97, 40),
    0,
    0,
    "Bombastic1"
}, {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(53, 53, 53),
    0,
    0,
    "Bombastic2"
}, {
    Enum.Material.Neon,
    Color3.fromRGB(161, 93, 47),
    0,
    0,
    nil
})
v730("Legendary", "Candy Apple", {
    "CandyGlossy",
    Color3.fromRGB(23, 152, 0),
    0,
    0,
    "CandyGlossy"
}, {
    "CandyGlossy",
    Color3.fromRGB(255, 128, 0),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(133, 161, 68),
    0,
    0.1,
    nil
})
v730("Legendary", "Dark Arena", {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(35, 35, 35),
    0,
    0,
    "DarkArena1"
}, {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(0, 0, 0),
    0,
    0,
    "DarkArena2"
}, {
    Enum.Material.Neon,
    Color3.fromRGB(0, 0, 0),
    1,
    0,
    "DarkArena3"
})
v730("Legendary", "Green Sparkle", {
    Enum.Material.Neon,
    Color3.fromRGB(39, 70, 45),
    0,
    0,
    "GreenSparkle1"
}, {
    Enum.Material.Neon,
    Color3.fromRGB(0, 0, 0),
    0,
    0,
    "GreenSparkle2"
}, {
    Enum.Material.Neon,
    Color3.fromRGB(124, 161, 64),
    0,
    0,
    nil
})
v730("Legendary", "Indigo Sparkle", {
    Enum.Material.Neon,
    Color3.fromRGB(104, 35, 207),
    0,
    0,
    "IndigoSparkle1"
}, {
    Enum.Material.Neon,
    Color3.fromRGB(0, 0, 0),
    0,
    0,
    "IndigoSparkle2"
}, {
    Enum.Material.Neon,
    Color3.fromRGB(78, 60, 177),
    0,
    0,
    nil
})
v730("Legendary", "Mesh", {
    Enum.Material.ForceField,
    Color3.fromRGB(0, 0, 0),
    0,
    0,
    "DarkMesh"
}, {
    Enum.Material.ForceField,
    Color3.fromRGB(0, 0, 0),
    0,
    0,
    "DarkMesh"
}, {
    Enum.Material.ForceField,
    Color3.fromRGB(255, 255, 255),
    0,
    0,
    "LightMesh"
})
v730("Legendary", "Rift", {
    Enum.Material.Neon,
    Color3.fromRGB(17, 17, 17),
    0,
    0,
    "Rift"
}, {
    Enum.Material.Neon,
    Color3.fromRGB(0, 0, 0),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(172, 99, 156),
    0,
    0,
    nil
})
v730("Legendary", "Spectral", {
    Enum.Material.Neon,
    Color3.fromRGB(55, 255, 95),
    0,
    0,
    "Spectral"
}, {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(71, 255, 203),
    0,
    0.4,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(92, 158, 119),
    0,
    0,
    nil
})
v730("Legendary", "Hologram", {
    Enum.Material.Neon,
    Color3.fromRGB(84, 138, 255),
    0.6,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(84, 138, 255),
    0.6,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(84, 138, 255),
    0.6,
    0,
    nil
})
v730("Legendary", "Bubbles", {
    Enum.Material.ForceField,
    Color3.fromRGB(255, 255, 255),
    0.9,
    0,
    "Bubbles"
}, {
    Enum.Material.ForceField,
    Color3.fromRGB(255, 255, 255),
    0.9,
    0,
    "Bubbles"
}, {
    Enum.Material.ForceField,
    Color3.fromRGB(255, 255, 255),
    0.9,
    0,
    "Bubbles"
}, nil, "Earned by gifting other players")
v730("Legendary", "Black Glass", {
    Enum.Material.Glass,
    Color3.fromRGB(0, 0, 0),
    0.6,
    0,
    nil
}, {
    Enum.Material.Glass,
    Color3.fromRGB(0, 0, 0),
    0.6,
    0,
    nil
}, {
    Enum.Material.Glass,
    Color3.fromRGB(0, 0, 0),
    0.6,
    0,
    nil
}, nil, "Purchased from the Ranked Shop")
v730("Legendary", "Magnetite", {
    Enum.Material.Glass,
    Color3.fromRGB(130, 80, 255),
    0,
    -2,
    "Magnetite"
}, {
    Enum.Material.Glass,
    Color3.fromRGB(55, 33, 108),
    0,
    -2,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(81, 21, 166),
    0,
    0,
    nil
})
v730("Legendary", "Devourer", {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(82, 84, 111),
    0,
    0,
    "Devourer1"
}, {
    Enum.Material.Neon,
    Color3.fromRGB(159, 95, 175),
    0,
    0,
    "Devourer2"
}, {
    Enum.Material.Neon,
    Color3.fromRGB(171, 108, 175),
    0,
    0,
    nil
})
v730("Legendary", "Bee", {
    "Bee",
    Color3.fromRGB(255, 217, 103),
    0,
    0,
    "Bee1"
}, {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(42, 38, 16),
    0,
    0,
    nil
}, {
    "BeeWing",
    Color3.fromRGB(152, 194, 219),
    0.4,
    0,
    nil
})
v730("Legendary", "Mint Choco Chip", {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(225, 255, 164),
    0,
    0,
    "MintChocoChip1"
}, {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(48, 40, 31),
    0,
    0,
    nil
}, {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(225, 255, 164),
    0,
    0,
    nil
})
v730("Legendary", "Necromancer", {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(27, 42, 53),
    0,
    0,
    "Necromancer1"
}, {
    "NecromancerGlossy",
    Color3.fromRGB(48, 52, 80),
    0,
    0,
    "Necromancer2"
}, {
    Enum.Material.Glass,
    Color3.fromRGB(98, 78, 151),
    0.5,
    0,
    nil
}, nil, "Used to be purchased from the Shop")
v730("Legendary", "Stocking Fur", {
    Enum.Material.Sand,
    Color3.fromRGB(151, 0, 0),
    0,
    0,
    "Stocking_1"
}, {
    "StockingFur",
    Color3.fromRGB(234, 242, 255),
    0,
    0,
    nil
}, {
    Enum.Material.Snow,
    Color3.fromRGB(31, 31, 31),
    0,
    0,
    nil
}, nil, "Purchased from the Shop")
v730("Legendary", "Luxe", {
    Enum.Material.Metal,
    Color3.fromRGB(255, 211, 161),
    0,
    0,
    "Luxe_1"
}, {
    Enum.Material.Neon,
    Color3.fromRGB(184, 154, 121),
    0,
    0,
    "Luxe_2"
}, {
    Enum.Material.Neon,
    Color3.fromRGB(171, 149, 125),
    0,
    0,
    nil
})
v730("Legendary", "Peril", {
    "Peril",
    Color3.fromRGB(34, 255, 167),
    0,
    0,
    "Peril1"
}, {
    "Peril",
    Color3.fromRGB(37, 158, 116),
    0,
    0,
    "Peril2"
}, {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(66, 255, 170),
    0.33,
    0.4,
    nil
})
v730("Legendary", "Wintry", {
    Enum.Material.Glass,
    Color3.fromRGB(210, 249, 255),
    0.3,
    0,
    "Wintry_1"
}, {
    Enum.Material.Glacier,
    Color3.fromRGB(248, 248, 248),
    0,
    0,
    "Wintry_2"
}, {
    Enum.Material.Neon,
    Color3.fromRGB(138, 155, 162),
    0,
    0,
    nil
})
v730("Legendary", "Plaid Pajama", {
    "PajamaFur",
    Color3.fromRGB(180, 23, 23),
    0,
    0,
    "Plaid_Pajama_1"
}, {
    Enum.Material.Granite,
    Color3.fromRGB(17, 17, 17),
    0,
    0,
    nil
}, {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(113, 15, 15),
    0,
    0,
    nil
})
v730("Legendary", "Candlelight", {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(254, 249, 219),
    0,
    0,
    "Candle_1"
}, {
    "CandyGlossy",
    Color3.fromRGB(255, 179, 103),
    0,
    0,
    "Candle_2"
}, {
    Enum.Material.Neon,
    Color3.fromRGB(181, 149, 117),
    0,
    0,
    nil
})
v730("Mythical", "Dark Matter", {
    "CandyGlossy",
    Color3.fromRGB(129, 107, 255),
    0,
    0,
    "DarkMatter1",
    nil,
    "Dark Matter"
}, {
    "CandyGlossy",
    Color3.fromRGB(129, 107, 255),
    0,
    0,
    "DarkMatter2",
    nil,
    "Dark Matter"
}, {
    Enum.Material.Neon,
    Color3.fromRGB(142, 98, 238),
    0,
    0,
    "DarkMatter3",
    nil,
    "Dark Matter"
}, nil, "Earned from weapon contracts", "Earned from a weapon contract for this weapon")
v730("Mythical", "Neon Lights", {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(42, 46, 49),
    0,
    0,
    "NeonLights1",
    nil,
    "Neon Lights"
}, {
    Enum.Material.Neon,
    Color3.fromRGB(21, 0, 65),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(125, 111, 165),
    0,
    0,
    nil
})
v730("Mythical", "Solar", {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(98, 15, 0),
    0,
    0,
    "Solar1",
    nil,
    "Solar"
}, {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(120, 52, 21),
    0,
    0,
    "Solar2",
    nil,
    "Solar"
}, {
    Enum.Material.Neon,
    Color3.fromRGB(168, 116, 78),
    0,
    0,
    nil
})
v730("Mythical", "Speed", {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(255, 255, 255),
    0,
    0,
    "Speed2",
    nil,
    "Speed"
}, {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(255, 255, 255),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(161, 105, 73),
    0,
    0,
    nil
})
v730("Mythical", "Celestial", {
    Enum.Material.Glass,
    Color3.fromRGB(0, 32, 96),
    0.25,
    0,
    "Celestial",
    nil,
    "Celestial"
}, {
    Enum.Material.Metal,
    Color3.fromRGB(110, 116, 141),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(77, 114, 173),
    0,
    0,
    nil
}, nil, "Earned by completing your Daily Tasks with a 7 day Task Streak")
v730("Mythical", "Encroached", {
    Enum.Material.Neon,
    Color3.fromRGB(96, 92, 209),
    0,
    0,
    "Encroached1",
    nil,
    "Encroached"
}, {
    Enum.Material.Metal,
    Color3.fromRGB(91, 93, 163),
    0,
    0,
    "Encroached2"
}, {
    Enum.Material.Neon,
    Color3.fromRGB(106, 101, 231),
    0,
    0,
    nil
})
v730("Mythical", "Fracture", {
    Enum.Material.Neon,
    Color3.fromRGB(105, 226, 161),
    0,
    0,
    "Fracture1",
    nil,
    "Fracture"
}, {
    Enum.Material.Metal,
    Color3.fromRGB(0, 0, 0),
    0,
    0,
    "Fracture2"
}, {
    Enum.Material.Neon,
    Color3.fromRGB(114, 255, 180),
    0.5,
    0,
    nil
})
v730("Mythical", "Aegis", {
    "Aegis",
    Color3.fromRGB(134, 207, 255),
    0,
    0,
    "Aegis1",
    nil,
    "Aegis"
}, {
    Enum.Material.Metal,
    Color3.fromRGB(239, 184, 56),
    0,
    0,
    "Aegis2"
}, {
    Enum.Material.Neon,
    Color3.fromRGB(255, 160, 116),
    0,
    0,
    nil
})
v730("Mythical", "Soul Scourge", {
    Enum.Material.Neon,
    Color3.fromRGB(93, 179, 255),
    0,
    0,
    "SoulScourge1",
    nil,
    "Soul Scourge"
}, {
    Enum.Material.Metal,
    Color3.fromRGB(18, 42, 48),
    0,
    0,
    "SoulScourge2",
    nil,
    nil
}, {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(84, 241, 255),
    0.5,
    0.5,
    nil
})
v730("Mythical", "Blizzard", {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(210, 234, 255),
    0,
    0.1,
    "Blizzard_1",
    nil,
    "Blizzard"
}, {
    "WrappingPearlescent",
    Color3.fromRGB(179, 199, 221),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(140, 153, 162),
    0,
    0,
    nil
})
v730("Mythical", "Festive Lights", {
    Enum.Material.Glass,
    Color3.fromRGB(17, 17, 17),
    0,
    0,
    "Festive_Lights_1",
    nil,
    "Festive Lights"
}, {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(248, 248, 248),
    0,
    0,
    "Festive_Lights_2",
    nil,
    "Festive Lights"
}, {
    Enum.Material.Glass,
    Color3.fromRGB(54, 54, 54),
    0.1,
    0,
    nil
})
v730("Mythical", "Ice Queen", {
    Enum.Material.Neon,
    Color3.fromRGB(102, 142, 162),
    0,
    0,
    "Ice_Queen_1",
    nil,
    "Ice Queen"
}, {
    Enum.Material.Glass,
    Color3.fromRGB(102, 190, 203),
    0,
    -3,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(123, 174, 207),
    0.2,
    0,
    nil
})
v730("Mythical", "Borealis", {
    Enum.Material.Neon,
    Color3.fromRGB(0, 0, 255),
    0,
    0,
    "Borealis_1",
    nil,
    "Borealis"
}, {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(17, 17, 17),
    0,
    0.05,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(75, 181, 105),
    0,
    0,
    nil
})
v730("Mythical", "Polaris", {
    Enum.Material.Neon,
    Color3.fromRGB(55, 108, 168),
    0,
    0,
    "Polaris_1",
    nil,
    "Polaris"
}, {
    Enum.Material.Metal,
    Color3.fromRGB(17, 21, 52),
    0,
    0,
    "Polaris_2"
}, {
    Enum.Material.Neon,
    Color3.fromRGB(113, 101, 209),
    0.2,
    0,
    "Polaris_3"
}, nil, "Included in the 2025 Festive Flash Sale")
v730("Unobtainable", "MISSING_WRAP", {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(255, 0, 255),
    0,
    0,
    "MISSING_WRAP",
    nil,
    nil
}, {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(0, 0, 0),
    0,
    0,
    nil,
    nil,
    nil
}, nil, true, "Note to self")
v730("Unobtainable", "Rivalry", {
    "RivalryMaterial",
    Color3.fromRGB(126, 52, 255),
    0,
    0,
    "Rivalry2",
    nil,
    "Rivalry"
}, {
    "RivalryMaterial",
    Color3.fromRGB(126, 52, 255),
    0,
    0,
    "Rivalry2",
    nil,
    "Rivalry"
}, {
    "RivalryMaterial",
    Color3.fromRGB(126, 52, 255),
    0,
    0,
    "Rivalry2",
    nil,
    "Rivalry"
}, true, "Given to team members of the group (Nosniy Games)")
v730("Unobtainable", "Scribble", {
    "ScribbleWrapping",
    Color3.fromRGB(248, 248, 248),
    0,
    0,
    "Scribble1",
    nil,
    "Scribble"
}, {
    "ScribbleWrapping",
    Color3.fromRGB(17, 17, 17),
    0,
    0,
    "Scribble2",
    nil,
    "Scribble"
}, {
    Enum.Material.Neon,
    Color3.fromRGB(0, 0, 0),
    0,
    0,
    nil,
    nil,
    nil
}, true, "Obtained by submitting a concept that makes it into the game (RIVALS)")
v730("Unobtainable", "Net", {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(255, 255, 255),
    0.75,
    0,
    "Net1",
    nil,
    nil
}, {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(165, 114, 55),
    0,
    0,
    "Net2",
    nil,
    nil
}, {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(255, 255, 255),
    1,
    0,
    "Net3",
    nil,
    nil
}, true, "Given to bug hunters, thank you for helping us improve the game (RIVALS)")
v730("Unobtainable", "Accretion", {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(149, 167, 248),
    0,
    0.4,
    nil,
    nil,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(0, 0, 0),
    0,
    0,
    "Accretion2",
    nil,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(0, 0, 0),
    0,
    0,
    "Accretion3",
    nil,
    nil
}, true, "im like hey whats up hello")
v730("Unobtainable", "Eruption", {
    Enum.Material.Neon,
    Color3.fromRGB(255, 112, 69),
    0,
    0,
    "Eruption1",
    nil,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(218, 96, 9),
    0,
    0,
    "Eruption2",
    nil,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(168, 92, 69),
    0,
    0,
    nil,
    nil,
    nil
}, true, "RAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA")
v730("Unobtainable", "Ultrablue", {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(255, 213, 0),
    0,
    10,
    nil,
    nil,
    nil
}, {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(255, 213, 0),
    0,
    10,
    nil,
    nil,
    nil
}, {
    Enum.Material.Glass,
    Color3.fromRGB(255, 255, 255),
    0.5,
    0,
    nil,
    nil,
    nil
}, true, "idk")
v730("Unobtainable", "Only Six", {
    "K_Material",
    Color3.fromRGB(221, 199, 255),
    0.2,
    1,
    "K_Textures",
    nil,
    "Only Six"
}, {
    Enum.Material.Glass,
    Color3.fromRGB(42, 42, 42),
    0.5,
    0,
    nil,
    nil,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(159, 161, 172),
    0,
    0,
    nil,
    nil,
    nil
}, true, "Given to the winners of the tournament in the Ready, Set, Roblox Korea Event")
v730("Unobtainable", "Arcane", {
    Enum.Material.Neon,
    Color3.fromRGB(0, 0, 0),
    0,
    0,
    "Arcane1"
}, {
    Enum.Material.Neon,
    Color3.fromRGB(0, 0, 0),
    0,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(95, 102, 176),
    0,
    0,
    nil
}, true, "i was forced to add this by a chicken")
v730("Unobtainable", "Invisible", {
    Enum.Material.Neon,
    Color3.fromRGB(0, 0, 0),
    1,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(0, 0, 0),
    1,
    0,
    nil
}, {
    Enum.Material.Neon,
    Color3.fromRGB(0, 0, 0),
    1,
    0,
    nil
}, true, "i was forced to add this by a chicken")
v730("Unobtainable", "Limefire", {
    "LimefireMat",
    Color3.fromRGB(248, 248, 248),
    0,
    0,
    "Limefire1"
}, {
    "LimefireMat",
    Color3.fromRGB(248, 248, 248),
    0,
    0,
    "Limefire2"
}, {
    Enum.Material.Neon,
    Color3.fromRGB(97, 174, 81),
    0,
    0,
    nil
}, true, "i was forced to add this by a chicken")
v730("Unobtainable", "Peridot", {
    "PeridotMat",
    Color3.fromRGB(40, 127, 71),
    0,
    0,
    "Peridot1"
}, {
    "PeridotMat",
    Color3.fromRGB(40, 127, 71),
    0,
    0,
    "Peridot2"
}, {
    Enum.Material.Neon,
    Color3.fromRGB(114, 171, 90),
    0,
    0,
    nil
}, true, "i was forced to add this by a chicken")
v730("Unobtainable", "Pixel Light", {
    Enum.Material.Neon,
    Color3.fromRGB(255, 152, 220),
    0,
    1,
    "PixelLight1"
}, {
    Enum.Material.Neon,
    Color3.fromRGB(255, 152, 220),
    0,
    1,
    "PixelLight2"
}, {
    Enum.Material.Neon,
    Color3.fromRGB(217, 129, 188),
    0,
    0,
    nil
}, true, "i was forced to add this by a chicken")
v730("Unobtainable", "Ultra Zed", {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(206, 255, 255),
    0,
    10,
    nil
}, {
    Enum.Material.SmoothPlastic,
    Color3.fromRGB(206, 255, 255),
    0,
    10,
    "UltraZed2"
}, {
    Enum.Material.Glass,
    Color3.fromRGB(206, 255, 255),
    0,
    10,
    nil
}, true, "i was forced to add this by a chicken")
v730("Unobtainable", "Virus", {
    "VirusMat",
    Color3.fromRGB(204, 142, 105),
    0,
    0,
    "Virus1"
}, {
    Enum.Material.ForceField,
    Color3.fromRGB(17, 17, 17),
    0,
    0,
    "Virus2"
}, {
    Enum.Material.Neon,
    Color3.fromRGB(130, 179, 117),
    0,
    0,
    nil
}, true, "i was forced to add this by a chicken")
v_u_81("Charm", "Unique", "Day 1", nil, nil, nil, "Earned by redeeming a code when the game (RIVALS) released", nil, {})
v_u_81("Charm", "Unique", "100M Visits", nil, nil, nil, "Earned by redeeming a code when the game (RIVALS) reached 100,000,000 visits", nil, {})
v_u_81("Charm", "Unique", "Streamer Microphone", nil, nil, nil, "Earned by redeeming a special code", nil, {})
v_u_81("Charm", "Unique", "Frozen Gaming Chair", nil, nil, nil, "Earned by redeeming a special code", nil, {})
v_u_81("Charm", "Unique", "Gaming Headset", nil, nil, nil, "Earned by redeeming a special code", nil, {})
v_u_81("Charm", "Unique", "Nosniy Games", nil, nil, nil, "Join the group (Nosniy Games)", nil, {})
v_u_81("Charm", "Unique", "Shooting Star", nil, nil, nil, "Favorite the game (RIVALS)", nil, {})
v_u_81("Charm", "Unique", "RIVALS", nil, nil, nil, "Like the game (RIVALS)", nil, {})
v_u_81("Charm", "Unique", "Bell", nil, nil, nil, "Enable notifications for the game (RIVALS)", nil, {})
v_u_81("Charm", "Unique", "Mini Present", nil, nil, nil, "Earned during the 2024 Festive Event", nil, {})
v_u_81("Charm", "Unique", "3D Glasses", nil, nil, nil, "Earned by watching a quick video ad in the Shop", nil, {})
v_u_81("Charm", "Unique", "Bungeoppang", nil, nil, nil, "Earned by completing a special challenge during the release of the Bridge map", nil, {})
v_u_81("Charm", "Unique", "Hunt Token", nil, nil, nil, "Earned by completing the Roblox 2025 The Hunt: Mega Edition", nil, {})
v_u_81("Charm", "Unique", "Mega Token", nil, nil, nil, "Earned by finding the Mega Token in the Roblox 2025 The Hunt: Mega Edition", nil, {})
v_u_81("Charm", "Unique", "1st Birthday Cake", nil, nil, nil, "Earned by making it to the 1st birthday party for the game (RIVALS)", nil, {})
v_u_81("Charm", "Unique", "I Survived Season 0", nil, nil, nil, "Given to players affected by the 3,400+ ELO reset during Ranked Season 0", nil, {})
v_u_81("Charm", "Unique", "Season 0", nil, nil, nil, "Earned by playing Ranked Season 0", nil, {})
v_u_81("Charm", "Unique", "Season 1", nil, nil, nil, "Earned by playing Ranked Season 1", nil, {})
v_u_81("Charm", "Unique", "RIA25 Award", nil, nil, nil, "Earned by redeeming a code when the game (RIVALS) won the RIA25 Best Shooter Experience award", nil, {})
v_u_81("Charm", "Unique", "Fireplace", nil, nil, nil, "Earned from the 2025 Festive Event Advent Calendar", nil, {})
v_u_81("Charm", "Unique", "Nosniy", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Unique", "SenseiWarrior", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Unique", "nekoanims", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Unique", "Blizmid", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Unique", "Bandites", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Unique", "CarbonMeister", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Unique", "DV", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Unique", "oPixel", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Unique", "TanqR", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Unique", "BobbVX", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Unique", "MiniBloxia", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Unique", "enriquebruv", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Unique", "Chex", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Unique", "hoppy819", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Unique", "Hoopie", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Unique", "Kaye", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Unique", "Karful", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Unique", "Brian1KB", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Unique", "GreatGuyBoom", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Unique", "ShadowTrojan", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Unique", "Khayri", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Unique", "8sty", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Unique", "Applino", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Unique", "viecti", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Unique", "SharkTactics", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Unique", "D_reamz", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Unique", "atorix", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Unique", "philhood", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Unique", "Mud", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Unique", "KaiM", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Unique", "Darktru", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Common", "Hook", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Common", "Cookie", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Common", "Cupcake", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Common", "Ninja Star", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Common", "Lemon Slice", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Common", "Ship Wheel", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Common", "Star", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Common", "Heart", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Common", "Bowling Pin", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Common", "Life Buoy", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Common", "Cage", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Common", "Magnet", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Common", "Potted Cactus", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Common", "Potted Flower", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Common", "Fedora Stack", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Common", "Pawn", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Common", "Hammer", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Common", "Cog", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Common", "Dice", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Common", "Traffic Cone", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Common", "Bone", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Common", "Candy", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Common", "Candy Corn", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Common", "Cobweb", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Common", "Crystal", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Common", "Mini Candy Cane", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Common", "Ornament", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Common", "Mini Shining Star", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Common", "Snowflake", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Common", "Glory Coin", nil, nil, nil, "Purchased from the Ranked Shop", nil, {})
v_u_81("Charm", "Common", "Runes", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Common", "Rune Ring", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Common", "Armchair", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Common", "Table Lamp", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Common", "Spider", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Common", "Thorn Circle", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Common", "Witch Hat", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Common", "Chombie Head", nil, nil, nil, "Earned by escaping the Zombie Tower", nil, {})
v_u_81("Charm", "Common", "Snowflake Ring", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Common", "Firework", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Common", "Ice Cube", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Common", "Jolly Hat", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Common", "Elf Hat", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Common", "Peppermint Candy", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Common", "Snowman", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Common", "Happy Gingerbread", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Rare", "Blobfish", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Rare", "Pufferfish", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Rare", "Bitster", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Rare", "Mystery Block", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Rare", "Anvil", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Rare", "Basketball", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Rare", "Money Bag", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Rare", "Rubber Duck", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Rare", "10 Gallon Hat", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Rare", "UFO", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Rare", "Emoji: Weary", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Rare", "Poop", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Rare", "Rocket Ship", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Rare", "Hotdog", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Rare", "Moai", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Rare", "Golf Ball", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Rare", "Football", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Rare", "Tennis Ball", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Rare", "Rainbow", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Rare", "Potion", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Rare", "Caramel Apple", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Rare", "Devious Pumpkin", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Rare", "Gravestone", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Rare", "Festive Light", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Rare", "Hot Chocolate", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Rare", "Stocking", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Rare", "Mini Portal", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Rare", "Mini Unstable Portal", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Rare", "Melonkin", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Rare", "Candy Bucket", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Rare", "Jolly Chair", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Rare", "Snowflakes", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Rare", "Decorated Tree", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Legendary", "Mini Ban Hammer", nil, nil, nil, "Included in the Classic Bundle", nil, {})
v_u_81("Charm", "Legendary", "Mini Disco Ball", nil, nil, nil, "Included in the Standard Weapons Bundle", nil, {})
v_u_81("Charm", "Legendary", "Alien Head", nil, nil, nil, "Included in the Exogun Bundle", nil, {})
v_u_81("Charm", "Legendary", "First Aid", nil, nil, nil, "Included in the Medkit Bundle", nil, {})
v_u_81("Charm", "Legendary", "Mini Key", nil, nil, nil, "Included in Key Bundles", nil, {})
v_u_81("Charm", "Legendary", "Emoji: Nauseated", nil, nil, nil, "Included in the Starter Bundle", nil, {})
v_u_81("Charm", "Legendary", "Explosion", nil, nil, nil, "Included in the Heavy Duty Bundle", nil, {})
v_u_81("Charm", "Legendary", "EZ", nil, nil, nil, "Included in the Pixel Bundle", nil, {})
v_u_81("Charm", "Legendary", "Energy Cell", nil, nil, nil, "Included in the Energy Bundle", nil, {})
v_u_81("Charm", "Legendary", "Emoji: Nerd", nil, nil, nil, "Included in the RPG Bundle", nil, {})
v_u_81("Charm", "Legendary", "Skull", nil, nil, nil, "Used to be purchased from the Shop", nil, {})
v_u_81("Charm", "Legendary", "Cauldron", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Legendary", "Eyeclipse", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Legendary", "Frankenblob", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Legendary", "Skullgourd", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Legendary", "Dumbkin", nil, nil, nil, "Included in Candy Bundles", nil, {})
v_u_81("Charm", "Legendary", "Chillman", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Legendary", "Gingerbread Cat", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Legendary", "Wreath", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Legendary", "Jingle Bell", nil, nil, nil, "Used to be purchased from the Shop", nil, {})
v_u_81("Charm", "Legendary", "Mini Snowglobe", nil, nil, nil, "Included in Crystal Bundles", nil, {})
v_u_81("Charm", "Legendary", "Chibi Bow", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Legendary", "Chibi Burst Rifle", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Legendary", "Chibi Chainsaw", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Legendary", "Chibi Daggers", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Legendary", "Chibi Energy Pistols", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Legendary", "Chibi Exogun", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Legendary", "Chibi Fists", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Legendary", "Chibi Flamethrower", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Legendary", "Chibi Grenade", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Legendary", "Chibi Grenade Launcher", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Legendary", "Chibi Handgun", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Legendary", "Chibi Flare Gun", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Legendary", "Chibi Jump Pad", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Legendary", "Chibi Katana", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Legendary", "Chibi Knife", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Legendary", "Chibi Medkit", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Legendary", "Chibi Minigun", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Legendary", "Chibi Molotov", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Legendary", "Chibi Paintball Gun", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Legendary", "Chibi RPG", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Legendary", "Chibi Revolver", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Legendary", "Chibi Satchel", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Legendary", "Chibi Assault Rifle", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Legendary", "Chibi Scythe", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Legendary", "Chibi Shorty", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Legendary", "Chibi Shotgun", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Legendary", "Chibi Slingshot", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Legendary", "Chibi Smoke Grenade", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Legendary", "Chibi Subspace Tripmine", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Legendary", "Chibi Sniper", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Legendary", "Chibi Spray", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Legendary", "Chibi Trowel", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Legendary", "Chibi Uzi", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Legendary", "Chibi War Horn", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Legendary", "Chibi Battle Axe", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Legendary", "Chibi Crossbow", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Legendary", "Chibi Riot Shield", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Legendary", "Chibi Freeze Ray", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Legendary", "Chibi Energy Rifle", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Legendary", "Chibi Gunblade", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Legendary", "Chibi Flashbang", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Legendary", "Chibi Distortion", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Legendary", "Chibi Warper", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Legendary", "Chibi Warpstone", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Legendary", "Chibi Maul", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Legendary", "Chibi Permafrost", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Legendary", "Arena Diorama", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Legendary", "Crossroads Diorama", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Legendary", "Backrooms Diorama", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Legendary", "Battleground Diorama", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Legendary", "Big Arena Diorama", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Legendary", "Big Backrooms Diorama", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Legendary", "Big Crossroads Diorama", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Legendary", "Big Graveyard Diorama", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Legendary", "Big Onyx Diorama", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Legendary", "Big Splash Diorama", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Legendary", "Bridge Diorama", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Legendary", "Construction Diorama", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Legendary", "Docks Diorama", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Legendary", "Graveyard Diorama", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Legendary", "Onyx Diorama", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Legendary", "Playground Diorama", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Legendary", "Shooting Range Diorama", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Legendary", "Splash Diorama", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Legendary", "Station Diorama", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Legendary", "Dimension Diorama", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Legendary", "Village Diorama", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Legendary", "Iceberg Diorama", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Legendary", "Emoji: Imp", nil, nil, nil, "Purchased from the Ranked Shop", nil, {})
v_u_81("Charm", "Legendary", "Keycard 3", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Legendary", "Warp Disc", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Legendary", "Ghost", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Legendary", "Black Cat", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Legendary", "Pumpkin Cat", nil, nil, nil, "Used to be purchased from the Shop", nil, {})
v_u_81("Charm", "Legendary", "Snowblob", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Legendary", "Gingerbread Man", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Legendary", "Yeti", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Legendary", "Cryo Capsule", nil, nil, nil, nil, nil, {})
v_u_81("Charm", "Legendary", "Penguin", nil, nil, nil, "Purchased from the Shop", nil, {})
v_u_81("Charm", "Legendary", "Crystal Heart", nil, nil, nil, "Included in the 2025 Festive Flash Sale", nil, {})
v_u_81("Charm", "Unobtainable", "Coinbama", nil, nil, true, "Friends & Family", nil, {})
v_u_81("Charm", "Unobtainable", "Alpha Coin", nil, nil, true, "Thanks for helping us test :3", nil, {})
v_u_81("Charm", "Unobtainable", "MISSING_CHARM", nil, nil, true, "Note to self", nil, {})
v_u_81("Charm", "Unobtainable", "Team Crown", nil, nil, true, "Given to the winners of the tournament in the Ready, Set, Roblox Korea Event", nil, {})
v_u_81("Finisher", "Unique", "Jolly Judgement", "rbxassetid://90321419599834", nil, nil, "Earned from the 2024 Festive Event\'s Advent Calendar", nil, {})
v_u_81("Finisher", "Unique", "5B Visits", "rbxassetid://114699226490363", nil, nil, "Earned by redeeming a code when the game (RIVALS) reached 5,000,000,000 visits", nil, {})
v_u_81("Finisher", "Unique", "Director\'s Cut", "rbxassetid://103223520666152", nil, nil, "Earned by watching a quick video ad in the Shop", nil, {})
v_u_81("Finisher", "Unique", "Elfify", "rbxassetid://78997438310487", nil, nil, "Earned from the 2025 Festive Event\'s Advent Calendar", nil, {})
v_u_81("Finisher", "Common", "Yoink", "rbxassetid://102829647142590", nil, nil, nil, nil, {})
v_u_81("Finisher", "Common", "Confetti", "rbxassetid://104741243211980", nil, nil, nil, nil, {})
v_u_81("Finisher", "Common", "Hacked", "rbxassetid://82426114825564", nil, nil, nil, nil, {})
v_u_81("Finisher", "Common", "Petrify", "rbxassetid://112332768984387", nil, nil, nil, nil, {})
v_u_81("Finisher", "Common", "Flop", "rbxassetid://96328091359909", nil, nil, nil, nil, {})
v_u_81("Finisher", "Common", "Toot", "rbxassetid://140560743648551", nil, nil, nil, nil, {})
v_u_81("Finisher", "Common", "Spooky Confetti", "rbxassetid://86811497624542", nil, nil, nil, nil, {})
v_u_81("Finisher", "Common", "Batsplosion", "rbxassetid://122057521256858", nil, nil, nil, nil, {})
v_u_81("Finisher", "Common", "Bite", "rbxassetid://82133383488216", nil, nil, nil, nil, {})
v_u_81("Finisher", "Common", "Festive Confetti", "rbxassetid://70544145329602", nil, nil, nil, nil, {})
v_u_81("Finisher", "Common", "Wrapped", "rbxassetid://72445331312364", nil, nil, nil, nil, {})
v_u_81("Finisher", "Common", "Delete", "rbxassetid://115854076287500", nil, nil, nil, nil, {})
v_u_81("Finisher", "Common", "Squawk", "rbxassetid://74088341062653", nil, nil, nil, nil, {})
v_u_81("Finisher", "Common", "Digitize", "rbxassetid://108813637747773", nil, nil, nil, nil, {})
v_u_81("Finisher", "Common", "Chalked", "rbxassetid://97485080586138", nil, nil, nil, nil, {})
v_u_81("Finisher", "Common", "Folded", "rbxassetid://77198370089806", nil, nil, nil, nil, {})
v_u_81("Finisher", "Common", "Very Tragic Banana Peel Accident", "rbxassetid://83991814770184", nil, nil, nil, nil, {})
v_u_81("Finisher", "Common", "For Glory", "rbxassetid://118264756096342", nil, nil, "Purchased from the Ranked Shop", nil, {})
v_u_81("Finisher", "Common", "Warped Away", "rbxassetid://77918264482510", nil, nil, nil, nil, {})
v_u_81("Finisher", "Common", "Blip", "rbxassetid://94841086478106", nil, nil, nil, nil, {})
v_u_81("Finisher", "Common", "Faceplant", "rbxassetid://88948574020907", nil, nil, nil, nil, {})
v_u_81("Finisher", "Common", "Northern Light Show", "rbxassetid://131193643081878", nil, nil, nil, nil, {})
v_u_81("Finisher", "Common", "Coalify", "rbxassetid://137288972288796", nil, nil, nil, nil, {})
v_u_81("Finisher", "Common", "Chill Out", "rbxassetid://128662396670227", nil, nil, nil, nil, {})
v_u_81("Finisher", "Rare", "Freeze", "rbxassetid://98529191510110", nil, nil, nil, nil, {})
v_u_81("Finisher", "Rare", "High Gravity", "rbxassetid://96732292347041", nil, nil, nil, nil, {})
v_u_81("Finisher", "Rare", "Collapse", "rbxassetid://73392477829194", nil, nil, nil, nil, {})
v_u_81("Finisher", "Rare", "Splatter", "rbxassetid://102973927915607", nil, nil, nil, nil, {})
v_u_81("Finisher", "Rare", "Tremble", "rbxassetid://95468028863260", nil, nil, nil, nil, {})
v_u_81("Finisher", "Rare", "Rush", "rbxassetid://126499829143959", nil, nil, nil, nil, {})
v_u_81("Finisher", "Rare", "Midas Touch", "rbxassetid://114357416172786", nil, nil, "Earned from weapon contracts", "Earned from a weapon contract for this weapon", {})
v_u_81("Finisher", "Rare", "Bonesplosion", "rbxassetid://130788066745511", nil, nil, nil, nil, {})
v_u_81("Finisher", "Rare", "Lost Soul", "rbxassetid://118248684115036", nil, nil, nil, nil, {})
v_u_81("Finisher", "Rare", "Reaper", "rbxassetid://127213865323328", nil, nil, nil, nil, {})
v_u_81("Finisher", "Rare", "Frozen", "rbxassetid://134114034173010", nil, nil, nil, nil, {})
v_u_81("Finisher", "Rare", "Gingerbreadify", "rbxassetid://139642060967648", nil, nil, nil, nil, {})
v_u_81("Finisher", "Rare", "Flick", "rbxassetid://91644072854680", nil, nil, nil, nil, {})
v_u_81("Finisher", "Rare", "Heavy Head", "rbxassetid://78860800597917", nil, nil, nil, nil, {})
v_u_81("Finisher", "Rare", "Bad Mood", "rbxassetid://99622848264737", nil, nil, nil, nil, {})
v_u_81("Finisher", "Rare", "Ascend", "rbxassetid://108671357927051", nil, nil, nil, nil, {})
v_u_81("Finisher", "Rare", "Roadrunner", "rbxassetid://123109101762106", nil, nil, nil, nil, {})
v_u_81("Finisher", "Rare", "Hooked", "rbxassetid://135161057713623", nil, nil, nil, nil, {})
v_u_81("Finisher", "Rare", "Bogey", "rbxassetid://78461567525312", nil, nil, nil, nil, {})
v_u_81("Finisher", "Rare", "Warp Sickness", "rbxassetid://95052578441962", nil, nil, nil, nil, {})
v_u_81("Finisher", "Rare", "Decorated Player", "rbxassetid://105447700906346", nil, nil, nil, nil, {})
v_u_81("Finisher", "Rare", "Snowmanify", "rbxassetid://86007852568653", nil, nil, nil, nil, {})
v_u_81("Finisher", "Legendary", "OOF", "rbxassetid://126776522933695", nil, nil, "Included in the Classic Bundle", nil, {})
v_u_81("Finisher", "Legendary", "Ignite", "rbxassetid://134442726960420", nil, nil, "Included in the Heavy Duty Bundle", nil, {})
v_u_81("Finisher", "Legendary", "Boogie", "rbxassetid://73791204303375", nil, nil, "Included in the Standard Weapons Bundle", nil, {})
v_u_81("Finisher", "Legendary", "Low Gravity", "rbxassetid://82935062788662", nil, nil, "Included in the Exogun Bundle", nil, {})
v_u_81("Finisher", "Legendary", "Stiff", "rbxassetid://115882469899440", nil, nil, "Included in the Starter Bundle", nil, {})
v_u_81("Finisher", "Legendary", "Heartbeat", "rbxassetid://87519063117594", nil, nil, "Included in the Medkit Bundle", nil, {})
v_u_81("Finisher", "Legendary", "Pixel Coins", "rbxassetid://92644850029616", nil, nil, "Included in the Pixel Bundle", nil, {})
v_u_81("Finisher", "Legendary", "Beacon", "rbxassetid://98809320060817", nil, nil, "Included in the Energy Bundle", nil, {})
v_u_81("Finisher", "Legendary", "Erased", "rbxassetid://88556189232995", nil, nil, "Included in the RPG Bundle", nil, {})
v_u_81("Finisher", "Legendary", "Opulent", "rbxassetid://101696122903986", nil, nil, "Included in Key Bundles", nil, {})
v_u_81("Finisher", "Legendary", "Orbital Strike", "rbxassetid://109881673283194", nil, nil, nil, nil, {})
v_u_81("Finisher", "Legendary", "Tough Crowd", "rbxassetid://114669648248372", nil, nil, nil, nil, {})
v_u_81("Finisher", "Legendary", "BONK!", "rbxassetid://99051381910214", nil, nil, nil, nil, {})
v_u_81("Finisher", "Legendary", "Darkheart", "rbxassetid://108380782682249", nil, nil, nil, nil, {})
v_u_81("Finisher", "Legendary", "Balloons", "rbxassetid://136702616652550", nil, nil, nil, nil, {})
v_u_81("Finisher", "Legendary", "Electrocute", "rbxassetid://73752311595809", nil, nil, nil, nil, {})
v_u_81("Finisher", "Legendary", "Diamond Hands", "rbxassetid://82379000922589", nil, nil, "Earned from weapon contracts", "Earned from a weapon contract for this weapon", {})
v_u_81("Finisher", "Legendary", "RIP", "rbxassetid://125413876114976", nil, nil, "Used to be purchased from the Shop", nil, {})
v_u_81("Finisher", "Legendary", "Disintegrate", "rbxassetid://122124911858258", nil, nil, nil, nil, {})
v_u_81("Finisher", "Legendary", "Broom Ride", "rbxassetid://94004294239279", nil, nil, nil, nil, {})
v_u_81("Finisher", "Legendary", "Zombified", "rbxassetid://118642793984362", nil, nil, nil, nil, {})
v_u_81("Finisher", "Legendary", "DRIP", "rbxassetid://72617401862034", nil, nil, "Included in Candy Bundles", nil, {})
v_u_81("Finisher", "Legendary", "Snowballed", "rbxassetid://134500016062172", nil, nil, nil, nil, {})
v_u_81("Finisher", "Legendary", "David", "rbxassetid://118078924229498", nil, nil, nil, nil, {})
v_u_81("Finisher", "Legendary", "Giant Ice Spike", "rbxassetid://83215636937328", nil, nil, "Included in Crystal Bundles", nil, {})
v_u_81("Finisher", "Legendary", "Falling Icicles", "rbxassetid://110649955330233", nil, nil, "Used to be purchased from the Shop", nil, {})
v_u_81("Finisher", "Legendary", "Chark Attack", "rbxassetid://129157579936707", nil, nil, nil, nil, {})
v_u_81("Finisher", "Legendary", "GOOAAALLLL", "rbxassetid://84624379263977", nil, nil, nil, nil, {})
v_u_81("Finisher", "Legendary", "Crushed", "rbxassetid://106966455049956", nil, nil, nil, nil, {})
v_u_81("Finisher", "Legendary", "Clapped", "rbxassetid://123917282718123", nil, nil, nil, nil, {})
v_u_81("Finisher", "Legendary", "Enlightened", "rbxassetid://127327248433603", nil, nil, nil, nil, {})
v_u_81("Finisher", "Legendary", "Rainbow Barf", "rbxassetid://132045014783492", nil, nil, nil, nil, {})
v_u_81("Finisher", "Legendary", "Impaled", "rbxassetid://138149693939922", nil, nil, "Purchased from the Ranked Shop", nil, {})
v_u_81("Finisher", "Legendary", "Spaghettified", "rbxassetid://77679769061256", nil, nil, nil, nil, {})
v_u_81("Finisher", "Legendary", "Instability", "rbxassetid://106971261547575", nil, nil, nil, nil, {})
v_u_81("Finisher", "Legendary", "Those Who Know", "rbxassetid://117644060038774", nil, nil, "Used to be purchased from the Shop", nil, {})
v_u_81("Finisher", "Legendary", "Sleigh Away", "rbxassetid://77610232388349", nil, nil, "Purchased from the Shop", nil, {})
v_u_81("Finisher", "Legendary", "Giant Snowball", "rbxassetid://133610440023169", nil, nil, nil, nil, {})
v_u_81("Finisher", "Legendary", "Firework Show", "rbxassetid://109941967577830", nil, nil, nil, nil, {})
v_u_81("Finisher", "Unobtainable", "Ragdoll", "rbxassetid://131997354939473", nil, true, "Used internally when no finisher is equipped", nil, {})
v_u_81("Finisher", "Unobtainable", "Fall Apart", "rbxassetid://131997354939473", nil, true, "Used internally for skeleton deaths", nil, {})
v_u_81("Finisher", "Unobtainable", "Every Finisher Ever", "rbxassetid://131997354939473", nil, true, "play super golf", nil, {})
v_u_81("Finisher", "Unobtainable", "Bubblegum", "rbxassetid://95870163076585", nil, true, "data mining detected, you will be banned shortly", nil, {})
v_u_81("Finisher", "Unobtainable", "MISSING_FINISHER", "rbxassetid://112664260315062", nil, true, "Note to self", nil, {})
local function v740(p731, p732, p733, p734, p735, p736, p737, p738, p739)
    v_u_81("Emote", p731, p732, nil, nil, p736, p739, nil, {
        ["IsAudioIntrusive"] = p733,
        ["IsTraversal"] = p734 ~= nil,
        ["TraversalWalkSpeedMultiplier"] = p734,
        ["HideFootsteps"] = p735,
        ["EmoteDescription"] = p737,
        ["ViewportCFrameOffset"] = p738 or CFrame.identity
    })
end
v740("Common", "Shoulder Brush", nil, nil, nil, nil, "No big deal, man")
v740("Common", "Coo Coo", nil, nil, nil, nil, "Someone\'s tilted")
v740("Common", "Denial", nil, nil, nil, nil, "No, no, not me!")
v740("Common", "Facepalm", nil, nil, nil, nil, "Are you serious right now?")
v740("Common", "Kneel", nil, nil, nil, nil, "That was an honorable try")
v740("Common", "Agree", nil, nil, nil, nil, "Yeah! Yeah!")
v740("Common", "Think", nil, nil, nil, nil, "Think, " .. (v_u_4.IS_CLIENT and v3.LocalPlayer.Name or "Server") .. "!")
v740("Common", "Salty", nil, nil, nil, nil, "If you weren\'t salty already, now you are!")
v740("Rare", "Superhero", true, nil, nil, nil, "Nobody panic! I\'m here now")
v740("Rare", "Cream Cheese Honey", true, nil, nil, nil, "It\'s cream cheese and honey sandwich time")
v740("Rare", "Smile", true, nil, nil, nil, "What a joyful and whimsical day! =)")
v740("Rare", "Vegetable", true, nil)
v740("Rare", "Criss Cross", true, nil)
v740("Rare", "Side To Side", true, nil)
v740("Rare", "Off of You", true, nil)
v740("Rare", "Round & Round", true, nil)
v740("Rare", "Warpmaker", nil, nil, nil, nil, nil, CFrame.Angles(0, 3.141592653589793, 0))
v740("Rare", "Shivering")
v740("Legendary", "Take The L", true, nil, nil, nil, "I promise not to be toxic")
v740("Legendary", "Selfie", nil, nil, nil, nil, "But first..")
v740("Legendary", "Flex", nil, nil, nil, nil, nil, nil, "Purchased from the Ranked Shop")
v740("Legendary", "ROFL", nil, nil)
v740("Legendary", "Portal Glitch", nil, nil)
v740("Legendary", "Witch Waltz", nil, 0.5, true, nil, nil, nil, "Used to be purchased from the Shop")
v740("Legendary", "Sleigh Ride", nil, 0.5, true, nil, nil, nil, "Purchased from the Shop")
v740("Legendary", "It\'s Time")
v740("Legendary", "New Year Sparklers")
v740("Unobtainable", "MISSING_EMOTE", nil, nil, nil, true, "Note to self", nil, "Note to self")
v740("Unobtainable", "Snow Angels", nil, nil, nil, true, nil, nil, "Environment emote")
local function v_u_751(p741, p742, p743, p744, p745, p746, p747)
    local v748 = {
        ["Name"] = p742,
        ["Type"] = p741,
        ["Image"] = p745 or "",
        ["ImageScale"] = p746 or 1,
        ["DisplayName"] = p743,
        ["DisplayNamePlural"] = p744
    }
    for v749, v750 in pairs(p747 or {}) do
        v748[v749] = v750
    end
    v_u_56.Rewards[p742] = v748
end
v_u_751("Custom", "Prime Season Pass", "Upgrade", "Upgrades", "rbxassetid://74965952714478", nil, {
    ["PrioritizeNameOverQuantity"] = true,
    ["BubbleTitle"] = "Prime Season Pass",
    ["BubbleDescription"] = "Upgrades your Season Pass!",
    ["NameStatus"] = nil
})
v_u_751("Custom", "Season Pass XP", "Pass XP", "Pass XP", "rbxassetid://139822751337484", nil, {
    ["PrioritizeNameOverQuantity"] = false,
    ["BubbleTitle"] = "Pass XP",
    ["BubbleDescription"] = "Can level up your Season Pass!",
    ["NameStatus"] = nil
})
v_u_751("Custom", "Season Pass Level", "Pass Level", "Pass Levels", "rbxassetid://93501121694083", nil, {
    ["PrioritizeNameOverQuantity"] = false,
    ["BubbleTitle"] = "Pass Levels",
    ["BubbleDescription"] = "Levels up your Season Pass!",
    ["NameStatus"] = nil
})
v_u_751("Custom", "Prime Nametag", "Shiny Name", "Shiny Name", "rbxassetid://100303529770645", nil, {
    ["PrioritizeNameOverQuantity"] = true,
    ["BubbleTitle"] = "Shiny Name",
    ["BubbleDescription"] = "Makes your name shiny and gold!",
    ["NameStatus"] = "Prime"
})
v_u_751("Custom", "Contraband Nametag", "Glitchy Name", "Glitchy Name", "rbxassetid://75221071226274", nil, {
    ["PrioritizeNameOverQuantity"] = true,
    ["BubbleTitle"] = "Glitchy Name",
    ["BubbleDescription"] = "Makes your name glitchy and purple!",
    ["NameStatus"] = "Contraband"
})
local function v756(p752, p753, p754)
    local v755 = v_u_5.Info[p753]
    local _ = {
        ["DataName"] = v755.DataName,
        ["BubbleDescription"] = p754
    }
    v_u_751("Currency", p752, v755.DisplayName, v755.DisplayNamePlural, v755.Image, 1, {
        ["DataName"] = v755.DataName,
        ["BubbleDescription"] = p754
    })
end
v756("Key", "WeaponKeys", "Can unlock weapons!")
v756("Unlock Token", "UnlockTokens", "Can unlock weapons!")
v756("EventCurrency", "EventCurrency", "Only here for a limited time!")
v756("Glory", "Glory", "Earned by playing Ranked!")
v756("Skin Ticket", "SkinTickets", "Can purchase skin cases!")
local function v_u_772(p757, p758, p759, p760, p_u_761, p762)
    local v763 = {
        ["SoundProfile"] = p759,
        ["GetContents"] = typeof(p_u_761) == "function" and p_u_761 and p_u_761 or function()
            return p_u_761
        end,
        ["LootboxDescription"] = p762 or "Contains special items!",
        ["HasWeaponCosmetics"] = false
    }
    v_u_751("Lootbox", p757, p757, p758, p760, nil, v763)
    local v764 = v_u_56.LootboxOrder
    table.insert(v764, p757)
    local v765 = {}
    for _, v766 in pairs(v763.GetContents()) do
        local v767 = not v765[v766]
        assert(v767, v766)
        v765[v766] = true
        local v768 = v_u_56.Cosmetics[v766]
        local v769 = v_u_6.Items[v766]
        local v770 = v_u_56.Rewards[v766]
        if v768 then
            v_u_56.Cosmetics[v766].Description = "Unboxed from the " .. p757
            v_u_56.CosmeticNameToLootbox[v766] = p757
            if v_u_56.Types[v768.Type].IsWeaponCosmetic then
                v763.HasWeaponCosmetics = true
            end
        elseif not v769 then
            if not v770 then
                local v771 = p757 .. ", " .. v766
                assert(false, v771)
            end
        end
    end
end
v_u_772("Skin Case", "Skin Cases", "Case", "rbxassetid://18185475009", {
    "Sandwich",
    "Saber",
    "Nuke Launcher",
    "Whoopee Cushion",
    "Disco Ball",
    "Singularity",
    "Pixel Sniper",
    "Don\'t Press",
    "Lasergun 3000",
    "Firework Gun",
    "Pixel Flamethrower",
    "Swashbuckler",
    "Electro Rifle",
    "Balloon Shotgun",
    "Emoji Cloud",
    "Pixel Crossbow",
    "Hyper Gunblade",
    "The Shred",
    "Temporal Ray",
    "Plasma Distortion",
    "Glitter Warper",
    "Slime Gun",
    "Blobsaw",
    "Plastic Shovel",
    "Boxing Gloves",
    "AK-47",
    "Scythe of Death",
    "Blaster",
    "Water Uzi",
    "Desert Eagle",
    "Hacker Rifle",
    "Hacker Pistols",
    "Aces",
    "Trumpet",
    "Advanced Satchel",
    "Cyber Warpstone",
    "Compound Bow",
    "Not So Shorty",
    "Stick",
    "Chancla",
    "Coffee",
    "Door",
    "Lovely Spray",
    "Trampoline"
})
v_u_772("Skin Case 2", "Skin Case 2s", "Case", "rbxassetid://18763894913", {
    "Hyper Sniper",
    "Hyper Shotgun",
    "Karambit",
    "AUG",
    "Hand Gun",
    "Sheriff",
    "Laptop",
    "Handsaws",
    "Teleport Disc",
    "Arcane Warper",
    "Electro Uzi",
    "Spaceship Launcher",
    "Camera",
    "Boba Gun",
    "Pixel Minigun",
    "Void Pistols",
    "Bounce House",
    "Magma Distortion",
    "Aqua Burst",
    "Dynamite Gun",
    "Raven Bow",
    "Anchor",
    "Lightning Bolt",
    "Water Balloon",
    "Garden Shovel",
    "Uranium Launcher",
    "Ray Gun",
    "Bubble Ray",
    "Spring",
    "Energy Shield",
    "Harpoon Crossbow",
    "Hydro Rifle",
    "Lovely Shorty",
    "Lamethrower",
    "Brass Knuckles",
    "Balance",
    "Goalpost",
    "Torch",
    "Ban Axe",
    "Crude Gunblade",
    "Megaphone",
    "Nail Gun",
    "Notebook Satchel",
    "Paper Planes"
})
v_u_772("Skin Case 3", "Skin Case 3s", "Case", "rbxassetid://109359591947074", {
    "Hotel Bell",
    "Money Gun",
    "Medkitty",
    "Balisong",
    "Event Horizon",
    "Banana Flare",
    "Fighter Jet",
    "Harp",
    "Repulsor",
    "Tommy Gun",
    "FAMAS",
    "Peppergun",
    "Mega Drill",
    "Balloon Shorty",
    "Spray Bottle",
    "Void Rifle",
    "Gunsaw",
    "Electropunk Warpstone",
    "Dream Bow",
    "Fists of Hurt",
    "Gearnade Launcher",
    "Glitterthrower",
    "Gum Ray",
    "Hourglass",
    "Lava Lamp",
    "Paintbrush",
    "Sakura Scythe",
    "Squid Launcher",
    "Stellar Katana",
    "Cerulean Axe",
    "Air Horn",
    "Masterpiece",
    "Hydro Pistols",
    "Shady Chicken Sandwich",
    "Violin Crossbow",
    "Cyber Distortion",
    "Cactus Shotgun",
    "DIY Tripmine",
    "Dynamite",
    "Gumball Handgun",
    "Ketchup Gun",
    "Lightbulb",
    "Bag o\' Money",
    "Shurikens"
})
v_u_772("Wrap Box", "Wrap Boxes", "Box", "rbxassetid://18185503558", {
    "Solar",
    "Malachite",
    "Lightning",
    "Arabesque",
    "Webbed",
    "Plastic",
    "Chrome",
    "A5",
    "Amber",
    "Insidious",
    "Iridescent",
    "Moonstone",
    "Bright",
    "Dark",
    "Mischief",
    "Rage",
    "Obsidian",
    "Toy",
    "Scales",
    "Well Done",
    "Dunes",
    "Glisten",
    "Glossy",
    "Bunsen",
    "Storm",
    "Mustard",
    "Violet",
    "Jean"
})
v_u_772("Wrap Box 2", "Wrap Box 2s", "Box", "rbxassetid://18763894596", {
    "Speed",
    "Hologram",
    "Thunderburst",
    "Encrypt",
    "Starblaze",
    "Carbon Fiber",
    "Hyperdrive",
    "Insignia",
    "Cardinal",
    "Starfall",
    "Resolute",
    "Liquid Gold",
    "Tiger",
    "Black Granite",
    "Cerulean",
    "Clamshell",
    "Cool Crochet",
    "Cork",
    "Hammered Copper",
    "Hypnotic",
    "Leafy Grass",
    "Liquid Chrome",
    "Mahogany",
    "Neo",
    "Pink Crochet",
    "Pink Glitter",
    "Studded",
    "Tempest",
    "Yang",
    "Yin",
    "Ancient",
    "Grass",
    "Rustic",
    "Copper",
    "Machine",
    "Titanium",
    "Tungsten"
})
v_u_772("Wrap Box 3", "Wrap Box 3s", "Box", "rbxassetid://77468549139941", {
    "Neon Lights",
    "Mesh",
    "Bombastic",
    "Candy Apple",
    "Dark Arena",
    "Green Sparkle",
    "Indigo Sparkle",
    "Rift",
    "Spectral",
    "Lovely Leopard",
    "Arbiter",
    "Antimatter",
    "Crimson Art",
    "Model",
    "Plasma",
    "Waste",
    "Purpleize",
    "Regal",
    "Sentinel",
    "Strobe",
    "TIX",
    "Tealur",
    "Lavish Crystal",
    "Noir",
    "Normal",
    "Rust",
    "Tawny"
})
v_u_772("Charm Capsule", "Charm Capsules", "Capsule", "rbxassetid://18212803422", {
    "Blobfish",
    "Pufferfish",
    "Bitster",
    "Mystery Block",
    "Anvil",
    "Basketball",
    "Money Bag",
    "Rubber Duck",
    "10 Gallon Hat",
    "UFO",
    "Emoji: Weary",
    "Poop",
    "Rocket Ship",
    "Hotdog",
    "Moai",
    "Golf Ball",
    "Football",
    "Tennis Ball",
    "Rainbow",
    "Potion",
    "Hook",
    "Cookie",
    "Cupcake",
    "Ninja Star",
    "Lemon Slice",
    "Ship Wheel",
    "Star",
    "Heart",
    "Bowling Pin",
    "Life Buoy",
    "Cage",
    "Magnet",
    "Potted Cactus",
    "Potted Flower",
    "Fedora Stack",
    "Pawn",
    "Hammer",
    "Cog",
    "Dice",
    "Traffic Cone"
})
v_u_772("Finisher Pack", "Finisher Packs", "Pack", "rbxassetid://138623525652507", {
    "Orbital Strike",
    "Darkheart",
    "BONK!",
    "Tough Crowd",
    "Balloons",
    "Electrocute",
    "Collapse",
    "Splatter",
    "High Gravity",
    "Freeze",
    "Tremble",
    "Rush",
    "Confetti",
    "Petrify",
    "Hacked",
    "Flop",
    "Toot",
    "Yoink"
})
v_u_772("Finisher Pack 2", "Finisher Pack 2s", "Pack", "rbxassetid://81943536585423", {
    "Chark Attack",
    "GOOAAALLLL",
    "Crushed",
    "Enlightened",
    "Clapped",
    "Rainbow Barf",
    "Flick",
    "Ascend",
    "Roadrunner",
    "Heavy Head",
    "Bad Mood",
    "Hooked",
    "Delete",
    "Squawk",
    "Digitize",
    "Chalked",
    "Folded",
    "Very Tragic Banana Peel Accident"
})
v_u_772("Spooky Skin Case", "Spooky Skin Cases", "CaseSpooky", "rbxassetid://89050335387917", {
    "Mimic Axe",
    "Soul Rifle",
    "Soul Pistols",
    "Experiment D15",
    "Experiment W4",
    "Pumpkin Launcher",
    "Skull Launcher",
    "Vexed Flare Gun",
    "Buzzsaw",
    "Bucket of Candy",
    "Spider Ray",
    "Vexed Candle",
    "Soul Grenade",
    "Eyeball",
    "Bat Daggers",
    "Potion Satchel",
    "Boneclaw Spray",
    "Boneclaw Horn",
    "Bat Scythe",
    "Bat Bow",
    "Boneclaw Rifle",
    "Boneclaw Revolver",
    "Jack O\'Thrower",
    "Brain Gun",
    "Broomstick",
    "Boneshot",
    "Exogourd",
    "Demon Uzi",
    "Demon Shorty",
    "Devil\'s Trident",
    "Pumpkin Carver",
    "Spider Web",
    "Tombstone Shield",
    "Boneblade",
    "Crossbone",
    "Warpbone",
    "Eyething Sniper",
    "Spectral Burst",
    "Pumpkin Minigun",
    "Pumpkin Handgun",
    "Pumpkin Claws",
    "Machete",
    "Skullbang",
    "Trick or Treat"
})
v_u_772("Haunted Chest", "Haunted Chests", "Chest", "rbxassetid://79519694224512", {
    "Soul Scourge",
    "Disintegrate",
    "Broom Ride",
    "Zombified",
    "Mummy",
    "Scourge",
    "Frankenstein",
    "Frankenblob",
    "Skullgourd",
    "Eyeclipse",
    "Cauldron",
    "Ghost",
    "Black Cat",
    "Reaper",
    "Bonesplosion",
    "Lost Soul",
    "Purple Goo",
    "Green Goo",
    "Chrome Webs",
    "Werewolf Fur",
    "Caramel Apple",
    "Devious Pumpkin",
    "Gravestone",
    "Melonkin",
    "Candy Bucket",
    "Spooky Confetti",
    "Batsplosion",
    "Bite",
    "Haunted",
    "Vexed",
    "Cursed",
    "Bone",
    "Candy",
    "Candy Corn",
    "Cobweb",
    "Spider",
    "Thorn Circle",
    "Witch Hat"
})
v_u_772("Festive Skin Case", "Festive Skin Cases", "CaseFestive", "rbxassetid://122567993958308", {
    "Gingerbread AUG",
    "Firework Launcher",
    "Peppermint Sheriff",
    "Candy Cane",
    "Festive Buzzsaw",
    "Milk & Cookies",
    "Hot Coals",
    "Dev-in-the-Box",
    "Warpstar",
    "Sleigh Maul",
    "Sleighstortion",
    "Frost Warper",
    "Jolly Man",
    "Gingerbread Sniper",
    "Frostbite Crossbow",
    "Frostbite Bow",
    "Snowblower",
    "Snowball Gun",
    "New Year Energy Rifle",
    "Snowball Launcher",
    "Cookies",
    "Gingerbread Handgun",
    "Reindeer Slingshot",
    "New Year Energy Pistols",
    "Cryo Scythe",
    "New Year Katana",
    "Snow Shovel",
    "Shining Star",
    "Snowglobe",
    "Jingle Grenade",
    "Snowman Permafrost",
    "Wrapped Minigun",
    "Wrapped Shotgun",
    "Pine Burst",
    "Elf\'s Gunblade",
    "Midnight Festive Exogun",
    "Pine Uzi",
    "Wrapped Shorty",
    "Pine Spray",
    "Wrapped Flare Gun",
    "Sled",
    "Nordic Axe",
    "Festive Fists",
    "Suspicious Gift",
    "Wrapped Freeze Ray",
    "Mammoth Horn"
})
v_u_772("Jolly Chest", "Jolly Chests", "ChestFestive", "rbxassetid://125958746511820", {
    "Festive Lights",
    "Snowballed",
    "David",
    "Aurora",
    "Peppermint",
    "Gingerbread",
    "Yeti",
    "Gingerbread Man",
    "Gingerbread Cat",
    "Chillman",
    "Wreath",
    "Frozen",
    "Gingerbreadify",
    "Jolly Wrapping",
    "Snowfall",
    "Ugly Sweater",
    "Jolly Chair",
    "Stocking",
    "Festive Light",
    "Hot Chocolate",
    "Festive Confetti",
    "Wrapped",
    "Midnight",
    "Slush",
    "Frigid",
    "Firework",
    "Jolly Hat",
    "Elf Hat",
    "Peppermint Candy",
    "Crystal",
    "Mini Candy Cane",
    "Snowflake",
    "Mini Shining Star",
    "Ornament"
})
v_u_772("Festive Wrap Box", "Festive Wrap Boxes", "Box", "rbxassetid://85450469885400", {
    "2025 Wrapping",
    "Forest Wrapping",
    "Peppermint Wrapping",
    "Winter Wrapping",
    "Mocha Wrapping",
    "Minty Wrapping",
    "Frosty Wrapping",
    "Creme Wrapping",
    "Blush Wrapping",
    "Cashmere Wrapping",
    "Carbon Wrapping",
    "Caned Wrapping"
})
v_u_772("Festive Wrap Box 2", "Festive Wrap Box 2s", "Box", "rbxassetid://96554434133288", {
    "2026 Wrapping",
    "Chilled Wrapping",
    "Luxury Wrapping",
    "Regal Wrapping",
    "Holly Wrapping",
    "Fortune Wrapping",
    "Pearly Wrapping",
    "Polar Wrapping",
    "Mousse Wrapping",
    "Periwinkle Wrapping",
    "Evergreen Wrapping",
    "Dusky Wrapping",
    "Merlot Wrapping",
    "Indigo Wrapping"
})
v_u_772("Goodie Bag", "Goodie Bags", nil, "rbxassetid://97975295792185", {
    "Charm Capsule",
    "Wrap Box",
    "Wrap Box 2",
    "Wrap Box 3",
    "Finisher Pack",
    "Finisher Pack 2"
})
v_u_772("Prime Goodie Bag", "Prime Goodie Bags", nil, "rbxassetid://123579272651325", {
    "Skin Ticket",
    "Charm Capsule",
    "Wrap Box",
    "Wrap Box 2",
    "Wrap Box 3",
    "Finisher Pack",
    "Finisher Pack 2"
}, "Contains special items & skin tickets!");
(function()
    for _, v773 in pairs(v_u_7.OwnableWeapons) do
        local v774 = {
            ["ImageHighResolution"] = v_u_6.ViewModels[v773].ImageHighResolution
        }
        v_u_751("Weapon", v773, v773, v773, v_u_6.Items[v773].Image, 3, v774)
    end
    local v775 = {
        ["ImageHighResolution"] = v_u_6.ViewModels.MISSING_WEAPON.ImageHighResolution
    }
    v_u_751("Weapon", "MISSING_WEAPON", "MISSING_WEAPON", "MISSING_WEAPON", v_u_6.Items.MISSING_WEAPON.Image, 3, v775)
    local function v_u_786()
        local v776 = {}
        for _, v777 in pairs(v_u_7:GetReleasedOwnableWeapons()) do
            if v_u_7.Weapons[v777].KeyPrice then
                table.insert(v776, v777)
            end
        end
        table.sort(v776, function(p778, p779)
            local v780 = v_u_6.Statuses[v_u_6.Items[p778].Status].Value
            local v781 = v_u_6.Statuses[v_u_6.Items[p779].Status].Value
            if v780 == v781 then
                return v_u_8:StringLessThan(p778, p779)
            else
                return v781 < v780
            end
        end)
        local v782 = {}
        for _, v783 in pairs(v776) do
            local v784 = v_u_6.Items[v783]
            v782[v784.Status] = v782[v784.Status] or {}
            local v785 = v782[v784.Status]
            table.insert(v785, v783)
        end
        return v776, v782
    end
    v_u_772("Weapon Crate", "Weapon Crates", "Crate", "rbxassetid://134795947609872", function()
        local v787, _ = v_u_786()
        return v787
    end)
    for v_u_788 in pairs(v_u_6.Statuses) do
        v_u_772(v_u_788 .. " Weapon Crate", v_u_788 .. " Weapon Crates", "Crate", "rbxassetid://134795947609872", function()
            local _, v789 = v_u_786()
            return v789[v_u_788] or {}
        end)
    end
end)();
(function()
    for v790 in pairs(v_u_56.Cosmetics) do
        local v791 = v_u_56.CosmeticsAlphabetized
        table.insert(v791, v790)
    end
    table.sort(v_u_56.CosmeticsAlphabetized, function(p792, p793)
        return v_u_8:StringLessThan(string.lower(p792), string.lower(p793))
    end)
    task.delay(5, function()
        for v794, v795 in pairs(v_u_56.Cosmetics) do
            if not v795.Description then
                warn("Missing description:", v794)
            end
        end
    end)
end)()
return v_u_56