local v_u_1 = game:GetService("ReplicatedStorage")
local v2 = require(v_u_1.Modules.CONSTANTS)
local v3 = require(v_u_1.Modules.EventLibrary)
local v_u_4 = require(v_u_1.Modules.ServerOsTime)
local v_u_5 = require(v_u_1.Modules.ItemLibrary)
local v6 = require(v_u_1.Modules.TestLibrary)
local v_u_7 = require(v_u_1.Modules.ShopEntry)
local v_u_8 = require(v_u_1.Modules.Utility)
local v_u_9
if v2.IS_STUDIO then
    v_u_9 = v6:GetTestAttribute("StudioTestUnreleasedWeapons")
else
    v_u_9 = v2.IS_TESTING_SERVER
end
local _ = v6:GetTestAttribute("StudioEnableFlashSales")
local v_u_31 = {
    ["NUM_GLORIOUS_COSMETICS"] = {},
    ["Entries"] = {},
    ["Weapons"] = {},
    ["OwnableWeapons"] = {},
    ["OwnableWeaponsAlphabetized"] = {},
    ["OwnableWeaponsCanEliminate"] = {},
    ["OwnableWeaponReleaseSchedule"] = {},
    ["DailyShopCosmeticTypes"] = {},
    ["FlashSales"] = {},
    ["Lootboxes"] = {},
    ["GetWeaponKeyPriceInfo"] = function(p10, p11, p12, p13)
        local v14 = p13[p11]
        local v15 = not v14 and (p12 > 0 and v_u_5.Items[p11])
        if v15 then
            v15 = v_u_5.Items[p11].Status == "Standard"
        end
        return v15 and 0 or (p10.Weapons[p11] and p10.Weapons[p11].KeyPrice or (1 / 0)), v15, v14, p12
    end,
    ["GetReleasedOwnableWeapons"] = function(p16, p17, p18)
        local v19 = {}
        for _, v20 in pairs(p18 or p16.OwnableWeapons) do
            if p16:IsWeaponReleased(v20, p17) then
                table.insert(v19, v20)
            end
        end
        return v19
    end,
    ["GetTimeUntilWeaponRelease"] = function(p21, p22)
        local v23 = p21.Weapons[p22]
        return (v23 and v23.ReleaseTime or 0) - v_u_4:GetRounded()
    end,
    ["IsWeaponReleased"] = function(p24, p25, p26)
        local v27 = p24.Weapons[p25]
        if v27 then
            v27 = p24:GetTimeUntilWeaponRelease(p25) <= (p26 or 0)
        end
        return v27
    end,
    ["GetUpcomingWeapon"] = function(p28)
        for v29, v30 in pairs(p28.OwnableWeaponReleaseSchedule) do
            if p28:GetTimeUntilWeaponRelease(v30) > 0 then
                return v30, v29
            end
        end
    end
}
local function v42(p32, p33, p34)
    local v35 = v_u_5.Items[p32]
    local v36 = v_u_9 and #v_u_31.OwnableWeapons or (p34 or 0)
    v_u_31.Weapons[p32] = {
        ["Weapon"] = p32,
        ["KeyPrice"] = p33,
        ["ReleaseTime"] = v36
    }
    local v37 = v_u_31.OwnableWeapons
    table.insert(v37, p32)
    local v38 = v_u_31.OwnableWeaponsAlphabetized
    table.insert(v38, p32)
    if v35.CanEliminate then
        local v39 = v_u_31.OwnableWeaponsCanEliminate
        table.insert(v39, p32)
    end
    table.sort(v_u_31.OwnableWeaponsAlphabetized, function(p40, p41)
        return v_u_8:StringLessThan(string.lower(p40), string.lower(p41))
    end)
end
v42("Assault Rifle", 0)
v42("Bow", 15)
v42("Burst Rifle", 25)
v42("Flamethrower", 400)
v42("Grenade Launcher", 425)
v42("Minigun", 450)
v42("Paintball Gun", 475)
v42("RPG", 25)
v42("Shotgun", 20)
v42("Sniper", 75)
v42("Handgun", 0)
v42("Flare Gun", 10)
v42("Exogun", 350)
v42("Revolver", 25)
v42("Shorty", 20)
v42("Slingshot", 300)
v42("Uzi", 20)
v42("Fists", 0)
v42("Chainsaw", 15)
v42("Katana", 45)
v42("Knife", 20)
v42("Scythe", 40)
v42("Trowel", 200)
v42("Grenade", 0)
v42("Flashbang", 15)
v42("Medkit", 300)
v42("Molotov", 25)
v42("Smoke Grenade", 10)
v42("Subspace Tripmine", 250)
v42("Freeze Ray", 45, 1720886400)
v42("War Horn", 30, 1735275600)
v42("Satchel", 35, 1734670800)
v42("Battle Axe", 50, 1734066000)
v42("Riot Shield", 45, 1735880400)
v42("Daggers", 30, 1733461200)
v42("Energy Pistols", 400)
v42("Energy Rifle", 425)
v42("Spray", 5, 1736485200)
v42("Crossbow", 35, 1732770000)
v42("Gunblade", 45, 1737090000)
v42("Jump Pad", nil)
v42("Distortion", 700)
v42("Warper", 650)
v42("Warpstone", 400)
v42("Maul", nil)
v42("Permafrost", nil)
local function v_u_44(...)
    local v43 = v_u_7.new(...)
    v_u_31.Entries[v43.EntryName] = v43
    return v43
end
v_u_44("Loose", "loose_arena", {
    {
        ["Name"] = "Arena",
        ["Weapon"] = "IsRandom"
    }
}, {
    ["WeaponKeys"] = 25
})
v_u_44("Loose", "loose_randomwrap", {
    {
        ["Name"] = "Ornamented",
        ["Weapon"] = "IsRandom"
    }
}, {
    ["WeaponKeys"] = 25
}, nil, nil, true)
v_u_44("Loose", "loose_universalwrap", {
    {
        ["Name"] = "Frostbite",
        ["Weapon"] = "IsUniversal"
    }
}, {
    ["WeaponKeys"] = 250
}, nil, nil, true)
v_u_44("Loose", "loose_glorycharm", {
    {
        ["Name"] = "Emoji: Imp",
        ["Weapon"] = "IsUniversal"
    }
}, {
    ["Glory"] = 250
})
v_u_44("Loose", "loose_gloryfinisher", {
    {
        ["Name"] = "Impaled",
        ["Weapon"] = "IsUniversal"
    }
}, {
    ["Glory"] = 500
})
v_u_44("Loose", "loose_gloryemote", {
    {
        ["Name"] = "Flex"
    }
}, {
    ["Glory"] = 1000
})
v_u_44("Loose", "loose_glorywrap", {
    {
        ["Name"] = "Black Glass",
        ["Weapon"] = "IsUniversal"
    }
}, {
    ["Glory"] = 2000
})
if v3.IS_ACTIVE then
    v_u_44("Loose", "loose_" .. v3.UNIVERSAL_SHOP_CHARM, {
        {
            ["Name"] = v3.UNIVERSAL_SHOP_CHARM,
            ["Weapon"] = "IsUniversal"
        }
    }, {
        ["EventCurrency"] = 1000
    }, nil, nil, true)
    v_u_44("Loose", "loose_" .. v3.UNIVERSAL_SHOP_WRAP, {
        {
            ["Name"] = v3.UNIVERSAL_SHOP_WRAP,
            ["Weapon"] = "IsUniversal"
        }
    }, {
        ["EventCurrency"] = 2000
    }, nil, nil, true)
    v_u_44("Loose", "loose_" .. v3.UNIVERSAL_SHOP_FINISHER, {
        {
            ["Name"] = v3.UNIVERSAL_SHOP_FINISHER,
            ["Weapon"] = "IsUniversal"
        }
    }, {
        ["EventCurrency"] = 3000
    }, nil, nil, true)
    v_u_44("Loose", "loose_" .. v3.UNIVERSAL_SHOP_EMOTE, {
        {
            ["Name"] = v3.UNIVERSAL_SHOP_EMOTE
        }
    }, {
        ["EventCurrency"] = 5000
    }, nil, nil, true)
end
for _, v45 in pairs(v_u_31:GetReleasedOwnableWeapons(v2.WEAPON_EARLY_ACCESS_TIME_OFFSET, v_u_31.OwnableWeaponsAlphabetized)) do
    local v46 = 0
    for v47 = 1, 4 do
        if v47 ~= 3 or v_u_5.Items[v45].CanEliminate then
            v46 = v46 + 1
            local v48 = "loose_gloriouscosmetic_" .. v46 .. "_" .. v45
            local v49
            if v47 == 1 then
                v49 = "Glory Coin"
            elseif v47 == 2 then
                v49 = "Glorious"
            elseif v47 == 3 then
                v49 = "For Glory"
            elseif v47 == 4 then
                v49 = "Glorious " .. v45
            else
                v49 = assert(false, "???")
            end
            v_u_44("Loose", v48, {
                {
                    ["Name"] = v49,
                    ["Weapon"] = v45
                }
            }, {
                ["Glory"] = v47 == 1 and 100 or (v47 == 2 and 200 or (v47 == 3 and 300 or (v47 == 4 and 400 or assert(false, "???"))))
            })
            v_u_31.NUM_GLORIOUS_COSMETICS[v45] = (v_u_31.NUM_GLORIOUS_COSMETICS[v45] or 0) + 1
        end
    end
end
v_u_31.DailyShopCosmeticTypes.Emote = {
    ["PricesByRarity"] = {
        ["Common"] = {
            ["WeaponKeys"] = 50
        },
        ["Rare"] = {
            ["WeaponKeys"] = 75
        },
        ["Legendary"] = {
            ["WeaponKeys"] = 100
        }
    },
    ["CosmeticNames"] = {}
}
local v50 = v_u_31.DailyShopCosmeticTypes.Emote.CosmeticNames
table.insert(v50, "Shoulder Brush")
local v_u_51 = "Shoulder Brush"
task.defer(function()
    require(v_u_1.Modules.CosmeticLibrary):ExternallySetCosmeticDescription(v_u_51, "Can be purchased from the Daily Shop")
end)
local v52 = v_u_31.DailyShopCosmeticTypes.Emote.CosmeticNames
table.insert(v52, "Vegetable")
local v_u_53 = "Vegetable"
task.defer(function()
    require(v_u_1.Modules.CosmeticLibrary):ExternallySetCosmeticDescription(v_u_53, "Can be purchased from the Daily Shop")
end)
local v54 = v_u_31.DailyShopCosmeticTypes.Emote.CosmeticNames
table.insert(v54, "Coo Coo")
local v_u_55 = "Coo Coo"
task.defer(function()
    require(v_u_1.Modules.CosmeticLibrary):ExternallySetCosmeticDescription(v_u_55, "Can be purchased from the Daily Shop")
end)
local v56 = v_u_31.DailyShopCosmeticTypes.Emote.CosmeticNames
table.insert(v56, "Denial")
local v_u_57 = "Denial"
task.defer(function()
    require(v_u_1.Modules.CosmeticLibrary):ExternallySetCosmeticDescription(v_u_57, "Can be purchased from the Daily Shop")
end)
local v58 = v_u_31.DailyShopCosmeticTypes.Emote.CosmeticNames
table.insert(v58, "Facepalm")
local v_u_59 = "Facepalm"
task.defer(function()
    require(v_u_1.Modules.CosmeticLibrary):ExternallySetCosmeticDescription(v_u_59, "Can be purchased from the Daily Shop")
end)
local v60 = v_u_31.DailyShopCosmeticTypes.Emote.CosmeticNames
table.insert(v60, "Kneel")
local v_u_61 = "Kneel"
task.defer(function()
    require(v_u_1.Modules.CosmeticLibrary):ExternallySetCosmeticDescription(v_u_61, "Can be purchased from the Daily Shop")
end)
local v62 = v_u_31.DailyShopCosmeticTypes.Emote.CosmeticNames
table.insert(v62, "Agree")
local v_u_63 = "Agree"
task.defer(function()
    require(v_u_1.Modules.CosmeticLibrary):ExternallySetCosmeticDescription(v_u_63, "Can be purchased from the Daily Shop")
end)
local v64 = v_u_31.DailyShopCosmeticTypes.Emote.CosmeticNames
table.insert(v64, "Think")
local v_u_65 = "Think"
task.defer(function()
    require(v_u_1.Modules.CosmeticLibrary):ExternallySetCosmeticDescription(v_u_65, "Can be purchased from the Daily Shop")
end)
local v66 = v_u_31.DailyShopCosmeticTypes.Emote.CosmeticNames
table.insert(v66, "Salty")
local v_u_67 = "Salty"
task.defer(function()
    require(v_u_1.Modules.CosmeticLibrary):ExternallySetCosmeticDescription(v_u_67, "Can be purchased from the Daily Shop")
end)
local v68 = v_u_31.DailyShopCosmeticTypes.Emote.CosmeticNames
table.insert(v68, "Superhero")
local v_u_69 = "Superhero"
task.defer(function()
    require(v_u_1.Modules.CosmeticLibrary):ExternallySetCosmeticDescription(v_u_69, "Can be purchased from the Daily Shop")
end)
local v70 = v_u_31.DailyShopCosmeticTypes.Emote.CosmeticNames
table.insert(v70, "Cream Cheese Honey")
local v_u_71 = "Cream Cheese Honey"
task.defer(function()
    require(v_u_1.Modules.CosmeticLibrary):ExternallySetCosmeticDescription(v_u_71, "Can be purchased from the Daily Shop")
end)
local v72 = v_u_31.DailyShopCosmeticTypes.Emote.CosmeticNames
table.insert(v72, "Criss Cross")
local v_u_73 = "Criss Cross"
task.defer(function()
    require(v_u_1.Modules.CosmeticLibrary):ExternallySetCosmeticDescription(v_u_73, "Can be purchased from the Daily Shop")
end)
local v74 = v_u_31.DailyShopCosmeticTypes.Emote.CosmeticNames
table.insert(v74, "Side To Side")
local v_u_75 = "Side To Side"
task.defer(function()
    require(v_u_1.Modules.CosmeticLibrary):ExternallySetCosmeticDescription(v_u_75, "Can be purchased from the Daily Shop")
end)
local v76 = v_u_31.DailyShopCosmeticTypes.Emote.CosmeticNames
table.insert(v76, "Off of You")
local v_u_77 = "Off of You"
task.defer(function()
    require(v_u_1.Modules.CosmeticLibrary):ExternallySetCosmeticDescription(v_u_77, "Can be purchased from the Daily Shop")
end)
local v78 = v_u_31.DailyShopCosmeticTypes.Emote.CosmeticNames
table.insert(v78, "Round & Round")
local v_u_79 = "Round & Round"
task.defer(function()
    require(v_u_1.Modules.CosmeticLibrary):ExternallySetCosmeticDescription(v_u_79, "Can be purchased from the Daily Shop")
end)
local v80 = v_u_31.DailyShopCosmeticTypes.Emote.CosmeticNames
table.insert(v80, "Smile")
local v_u_81 = "Smile"
task.defer(function()
    require(v_u_1.Modules.CosmeticLibrary):ExternallySetCosmeticDescription(v_u_81, "Can be purchased from the Daily Shop")
end)
local v82 = v_u_31.DailyShopCosmeticTypes.Emote.CosmeticNames
table.insert(v82, "Take The L")
local v_u_83 = "Take The L"
task.defer(function()
    require(v_u_1.Modules.CosmeticLibrary):ExternallySetCosmeticDescription(v_u_83, "Can be purchased from the Daily Shop")
end)
local v84 = v_u_31.DailyShopCosmeticTypes.Emote.CosmeticNames
table.insert(v84, "Selfie")
local v_u_85 = "Selfie"
task.defer(function()
    require(v_u_1.Modules.CosmeticLibrary):ExternallySetCosmeticDescription(v_u_85, "Can be purchased from the Daily Shop")
end)
local function v93(p86, p87, p88, p89, p90, p91)
    local v92 = {
        ["ShopEntry"] = v_u_44("Lootbox", "lootbox_" .. p86, {
            {
                ["Name"] = p86,
                ["Weapon"] = "IsRandom",
                ["Quantity"] = 1
            }
        }, p87, p88, p89, p90),
        ["PricesByRarity"] = p91
    }
    v_u_31.Lootboxes[p86] = v92
end
v93("Skin Case", {
    ["SkinTickets"] = 10
}, 1852079505, 1861165031)
v93("Skin Case 2", {
    ["SkinTickets"] = 10
}, 1892542763, 1892543013)
v93("Skin Case 3", {
    ["SkinTickets"] = 10
}, 3251887315, 3251887576)
v93("Wrap Box", {
    ["WeaponKeys"] = 5
}, nil, nil, nil, {
    ["Common"] = {
        ["WeaponKeys"] = 5
    },
    ["Rare"] = {
        ["WeaponKeys"] = 10
    },
    ["Legendary"] = {
        ["WeaponKeys"] = 15
    }
})
v93("Wrap Box 2", {
    ["WeaponKeys"] = 5
}, nil, nil, nil, {
    ["Common"] = {
        ["WeaponKeys"] = 5
    },
    ["Rare"] = {
        ["WeaponKeys"] = 10
    },
    ["Legendary"] = {
        ["WeaponKeys"] = 15
    }
})
v93("Wrap Box 3", {
    ["WeaponKeys"] = 5
}, nil, nil, nil, {
    ["Common"] = {
        ["WeaponKeys"] = 5
    },
    ["Rare"] = {
        ["WeaponKeys"] = 10
    },
    ["Legendary"] = {
        ["WeaponKeys"] = 15
    }
})
v93("Charm Capsule", {
    ["WeaponKeys"] = 3
}, nil, nil, nil, {
    ["Common"] = {
        ["WeaponKeys"] = 3
    },
    ["Rare"] = {
        ["WeaponKeys"] = 4
    },
    ["Legendary"] = {
        ["WeaponKeys"] = 5
    }
})
v93("Finisher Pack", {
    ["WeaponKeys"] = 10
}, nil, nil, nil, {
    ["Common"] = {
        ["WeaponKeys"] = 10
    },
    ["Rare"] = {
        ["WeaponKeys"] = 15
    },
    ["Legendary"] = {
        ["WeaponKeys"] = 20
    }
})
v93("Finisher Pack 2", {
    ["WeaponKeys"] = 10
}, nil, nil, nil, {
    ["Common"] = {
        ["WeaponKeys"] = 10
    },
    ["Rare"] = {
        ["WeaponKeys"] = 15
    },
    ["Legendary"] = {
        ["WeaponKeys"] = 20
    }
})
if v3.IS_ACTIVE then
    v93(v3.SPECIAL_LOOTBOX_SKINS, {
        ["SkinTickets"] = 10
    }, 2154617424, 2154618109, true)
    v93(v3.SPECIAL_LOOTBOX_VARIETY, {
        ["EventCurrency"] = 30
    }, nil, nil, true, {
        ["Common"] = {
            ["EventCurrency"] = 30
        },
        ["Rare"] = {
            ["EventCurrency"] = 60
        },
        ["Legendary"] = {
            ["EventCurrency"] = 90
        }
    })
    v93("Festive Wrap Box 2", {
        ["EventCurrency"] = 30
    }, nil, nil, true, {
        ["Common"] = {
            ["EventCurrency"] = 30
        },
        ["Rare"] = {
            ["EventCurrency"] = 60
        },
        ["Legendary"] = {
            ["EventCurrency"] = 90
        }
    })
end
(function()
    for _, v94 in pairs(v_u_31.OwnableWeapons) do
        local v95 = v_u_31.OwnableWeaponReleaseSchedule
        table.insert(v95, v94)
    end
    table.sort(v_u_31.OwnableWeaponReleaseSchedule, function(p96, p97)
        local v98 = v_u_31.Weapons[p96].ReleaseTime or -1
        local v99 = v_u_31.Weapons[p97].ReleaseTime or -1
        if v98 == v99 then
            return v_u_8:StringLessThan(p96, p97)
        else
            return v98 < v99
        end
    end)
end)()
return v_u_31