local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = require(v1.Modules.CONSTANTS)
local v3 = require(v1.Modules.CosmeticLibrary)
local v4 = require(v1.Modules.CurrencyLibrary)
local v5 = require(v1.Modules.SeasonLibrary)
local v6 = require(v1.Modules.EventLibrary)
local v_u_7 = require(v1.Modules.ShopLibrary)
local v_u_8 = require(v1.Modules.ItemLibrary)
local v_u_9 = {
    ["\\"] = true,
    ["|"] = true,
    [" "] = true,
    ["q"] = true,
    ["w"] = true,
    ["e"] = true,
    ["r"] = true,
    ["t"] = true,
    ["y"] = true,
    ["u"] = true,
    ["i"] = true,
    ["o"] = true,
    ["p"] = true,
    ["a"] = true,
    ["s"] = true,
    ["d"] = true,
    ["f"] = true,
    ["g"] = true,
    ["h"] = true,
    ["j"] = true,
    ["k"] = true,
    ["l"] = true,
    ["z"] = true,
    ["x"] = true,
    ["c"] = true,
    ["v"] = true,
    ["b"] = true,
    ["n"] = true,
    ["m"] = true,
    ["1"] = true,
    ["2"] = true,
    ["3"] = true,
    ["4"] = true,
    ["5"] = true,
    ["6"] = true,
    ["7"] = true,
    ["8"] = true,
    ["9"] = true,
    ["0"] = true,
    ["`"] = true,
    ["-"] = true,
    ["="] = true,
    ["["] = true,
    ["]"] = true,
    [";"] = true,
    ["\'"] = true,
    [","] = true,
    ["."] = true,
    ["/"] = true,
    ["~"] = true,
    ["!"] = true,
    ["@"] = true,
    ["#"] = true,
    ["$"] = true,
    ["%"] = true,
    ["^"] = true,
    ["&"] = true,
    ["*"] = true,
    ["("] = true,
    [")"] = true,
    ["_"] = true,
    ["+"] = true,
    ["{"] = true,
    ["}"] = true,
    [":"] = true,
    ["\""] = true,
    ["<"] = true,
    [">"] = true,
    ["?"] = true
}
local v_u_38 = {
    ["NUM_KEY_BUNDLES"] = 5,
    ["NUM_EVENT_CURRENCY_BUNDLES"] = 5,
    ["GIFT_REWARD_DATA"] = "Bubbles",
    ["VIDEO_AD_REWARDS_ENABLED"] = true,
    ["VIDEO_AD_REWARDS_MAX_SCALE_FACTOR"] = 2,
    ["BATTLE_PASS_LEVELS"] = {
        "BattlePassLevels1",
        "BattlePassLevels5",
        "BattlePassLevels10",
        "BattlePassLevels20",
        "BattlePassLevels30",
        "BattlePassLevels40",
        "BattlePassLevels50",
        "BattlePassLevels60",
        "BattlePassLevels70"
    },
    ["MAX_GIFTING_NOTE_CHARACTER_COUNT"] = 128,
    ["Gamepasses"] = {},
    ["Products"] = {},
    ["Bundles"] = {},
    ["Gifts"] = {},
    ["GiftOrder"] = {},
    ["VideoAdRewards"] = {},
    ["GetGiftRewardRobuxSpentRequirement"] = function(_, p10)
        local v11 = 25 + 25 * p10
        return math.min(500, v11)
    end,
    ["GetGamepassName"] = function(p12, p13)
        for v14, v15 in pairs(p12.Gamepasses) do
            if p13 == v15.GamepassID then
                return v14
            end
        end
    end,
    ["GetProductName"] = function(p16, p17)
        for v18, v19 in pairs(p16.Products) do
            if p17 == v19.ProductID then
                return v18
            end
        end
    end,
    ["GetBundleByProductID"] = function(_, p20)
        for v21, v22 in pairs(v_u_38.Bundles) do
            if v22.ProductID == p20 then
                return v21
            end
        end
    end,
    ["GetBundleContainingReward"] = function(_, p23)
        for v24, v25 in pairs(v_u_38.Bundles) do
            for _, v26 in pairs(v25.Rewards) do
                if v26.Name == p23 then
                    return v24
                end
            end
        end
    end,
    ["GetStandardWeaponBundleWeapons"] = function(_)
        local v27 = {}
        for _, v28 in pairs(v_u_7:GetReleasedOwnableWeapons(v_u_2.WEAPON_EARLY_ACCESS_TIME_OFFSET, v_u_7.OwnableWeaponsAlphabetized)) do
            if not table.find(v_u_2.DEFAULT_WEAPONS, v28) and (v_u_8.Items[v28].Status == "Standard" and v_u_7.Weapons[v28].KeyPrice) then
                table.insert(v27, v28)
            end
        end
        return v27
    end,
    ["SanitizeGiftNote"] = function(p29, p30)
        if typeof(p30) ~= "string" or #p30 == 0 then
            return nil
        end
        local v31 = #p30
        local v32 = p29.MAX_GIFTING_NOTE_CHARACTER_COUNT
        local v33 = math.min(v31, v32)
        local v34 = string.sub(p30, 1, v33)
        local v35 = ""
        for v36 = 1, #v34 do
            local v37 = string.sub(v34, v36, v36)
            v35 = v35 .. (not v_u_9[string.lower(v37)] and "#" or v37)
        end
        return v35
    end
}
v_u_38.Gamepasses.StandardWeaponsBundle = {
    ["GamepassID"] = 838203071,
    ["DisplayName"] = "Standard Weapons Bundle",
    ["IsOffsale"] = nil,
    ["BundleName"] = nil
}
v_u_38.Gamepasses.ClassicBundle = {
    ["GamepassID"] = 838160059,
    ["DisplayName"] = "Classic Bundle",
    ["IsOffsale"] = nil,
    ["BundleName"] = nil
}
v_u_38.Gamepasses.HeavyDutyBundle = {
    ["GamepassID"] = 838198043,
    ["DisplayName"] = "Heavy Duty Bundle",
    ["IsOffsale"] = nil,
    ["BundleName"] = nil
}
v_u_38.Gamepasses.ExogunBundle = {
    ["GamepassID"] = 838087219,
    ["DisplayName"] = "Exogun Bundle",
    ["IsOffsale"] = nil,
    ["BundleName"] = nil
}
v_u_38.Gamepasses.MedkitBundle = {
    ["GamepassID"] = 837904767,
    ["DisplayName"] = "Medkit Bundle",
    ["IsOffsale"] = nil,
    ["BundleName"] = nil
}
v_u_38.Gamepasses.StarterBundle = {
    ["GamepassID"] = 839491390,
    ["DisplayName"] = "Starter Bundle",
    ["IsOffsale"] = nil,
    ["BundleName"] = nil
}
v_u_38.Gamepasses.PixelBundle = {
    ["GamepassID"] = 938353691,
    ["DisplayName"] = "Pixel Bundle",
    ["IsOffsale"] = nil,
    ["BundleName"] = nil
}
v_u_38.Gamepasses.EnergyBundle = {
    ["GamepassID"] = 977061826,
    ["DisplayName"] = "Energy Bundle",
    ["IsOffsale"] = nil,
    ["BundleName"] = nil
}
v_u_38.Gamepasses.RPGBundle = {
    ["GamepassID"] = 1162134376,
    ["DisplayName"] = "RPG Bundle",
    ["IsOffsale"] = nil,
    ["BundleName"] = nil
}
local function v46(p39, p40, p41, p42)
    local v43 = {
        ["Name"] = p39,
        ["ProductID"] = p40,
        ["DisplayName"] = p41
    }
    for v44, v45 in pairs(p42 or {}) do
        v43[v44] = v45
    end
    v_u_38.Products[p39] = v43
end
v46("RefreshTasks", 1852077788, "Refresh Daily Tasks")
v46("DailySkin1Common", 1852078966, "Common Skin #1")
v46("DailySkin1Rare", 1852080069, "Rare Skin #1")
v46("DailySkin1Legendary", 1852068440, "Legendary Skin #1")
v46("DailySkin2Common", 1857673571, "Common Skin #2")
v46("DailySkin2Rare", 1857673748, "Rare Skin #2")
v46("DailySkin2Legendary", 1857673858, "Legendary Skin #2")
v46("DailySkin3Common", 2151911761, "Common Skin #3")
v46("DailySkin3Rare", 2151911909, "Rare Skin #3")
v46("DailySkin3Legendary", 2151912016, "Legendary Skin #3")
v46("DailySkin4Common", 2151912274, "Common Skin #4")
v46("DailySkin4Rare", 2151912453, "Rare Skin #4")
v46("DailySkin4Legendary", 2151912592, "Legendary Skin #4")
v46("DailySkin5Common", 2151912371, "Common Skin #5")
v46("DailySkin5Rare", 2151912504, "Rare Skin #5")
v46("DailySkin5Legendary", 2151912645, "Legendary Skin #5")
v46("VideoAdReward", v_u_2.IS_TESTING_SERVER and 3328255161 or 3322045009, "Video Ad Reward")
v46("BattlePassLevels1", 3406958794, "+1 Season Pass Level", {
    ["BattlePassLevelIncrement"] = 1
})
v46("BattlePassLevels5", 3406958927, "+5 Season Pass Levels", {
    ["BattlePassLevelIncrement"] = 5
})
v46("BattlePassLevels10", 3406959039, "+10 Season Pass Levels", {
    ["BattlePassLevelIncrement"] = 10
})
v46("BattlePassLevels20", 3406959143, "+20 Season Pass Levels", {
    ["BattlePassLevelIncrement"] = 20
})
v46("BattlePassLevels30", 3406962774, "+30 Season Pass Levels", {
    ["BattlePassLevelIncrement"] = 30
})
v46("BattlePassLevels40", 3406959259, "+40 Season Pass Levels", {
    ["BattlePassLevelIncrement"] = 40
})
v46("BattlePassLevels50", 3406962880, "+50 Season Pass Levels", {
    ["BattlePassLevelIncrement"] = 50
})
v46("BattlePassLevels60", 3406963062, "+60 Season Pass Levels", {
    ["BattlePassLevelIncrement"] = 60
})
v46("BattlePassLevels70", 3406959434, "+70 Season Pass Levels", {
    ["BattlePassLevelIncrement"] = 70
})
local function v60(p47, p48, p49, p50, p51, p52, p53, p54)
    for _, v55 in pairs(p52) do
        local v56 = v55.Name
        assert(v56)
    end
    local v57 = {
        ["Type"] = p47,
        ["DisplayName"] = p49,
        ["ProductID"] = p50,
        ["GamepassName"] = p51,
        ["Rewards"] = p52,
        ["BubbleText"] = p53
    }
    for v58, v59 in pairs(p54 or {}) do
        v57[v58] = v59
    end
    v_u_38.Bundles[p48] = v57
    if p51 then
        v_u_38.Gamepasses[p51].BundleName = p48
    end
end
v60("Currency", "keybundle_1", "Key Bundle", 1851594490, nil, {
    {
        ["Name"] = "Key",
        ["Quantity"] = 10
    }
})
v60("Currency", "keybundle_2", "Mega Key Bundle", 1851594599, nil, {
    {
        ["Name"] = "Key",
        ["Quantity"] = 40
    },
    {
        ["Name"] = "Charm Capsule",
        ["Weapon"] = "IsRandom",
        ["Quantity"] = 1
    }
})
v60("Currency", "keybundle_3", "Super Key Bundle", 1851594741, nil, {
    {
        ["Name"] = "Key",
        ["Quantity"] = 90
    },
    {
        ["Name"] = "Charm Capsule",
        ["Weapon"] = "IsRandom",
        ["Quantity"] = 3
    },
    {
        ["Name"] = "Wrap Box 3",
        ["Weapon"] = "IsRandom",
        ["Quantity"] = 1
    },
    {
        ["Name"] = "Mini Key",
        ["Weapon"] = "IsRandom",
        ["Quantity"] = 1
    }
})
v60("Currency", "keybundle_4", "Ultra Key Bundle", 1851594902, nil, {
    {
        ["Name"] = "Key",
        ["Quantity"] = 450
    },
    {
        ["Name"] = "Charm Capsule",
        ["Weapon"] = "IsRandom",
        ["Quantity"] = 15
    },
    {
        ["Name"] = "Wrap Box 3",
        ["Weapon"] = "IsRandom",
        ["Quantity"] = 5
    },
    {
        ["Name"] = "Mini Key",
        ["Weapon"] = "IsRandom",
        ["Quantity"] = 5
    },
    {
        ["Name"] = "Luxurious",
        ["Weapon"] = "IsRandom",
        ["Quantity"] = 2
    },
    {
        ["Name"] = "Opulent",
        ["Weapon"] = "IsRandom",
        ["Quantity"] = 1
    },
    {
        ["Name"] = "Keynais",
        ["Weapon"] = "Daggers"
    }
})
v60("Currency", "keybundle_5", "Legendary Key Bundle", 1851595031, nil, {
    {
        ["Name"] = "Key",
        ["Quantity"] = 1100
    },
    {
        ["Name"] = "Charm Capsule",
        ["Weapon"] = "IsRandom",
        ["Quantity"] = 40
    },
    {
        ["Name"] = "Wrap Box 3",
        ["Weapon"] = "IsRandom",
        ["Quantity"] = 15
    },
    {
        ["Name"] = "Mini Key",
        ["Weapon"] = "IsRandom",
        ["Quantity"] = 15
    },
    {
        ["Name"] = "Luxurious",
        ["Weapon"] = "IsRandom",
        ["Quantity"] = 5
    },
    {
        ["Name"] = "Opulent",
        ["Weapon"] = "IsRandom",
        ["Quantity"] = 3
    },
    {
        ["Name"] = "Keyrambit",
        ["Weapon"] = "Knife"
    },
    {
        ["Name"] = "Keylisong",
        ["Weapon"] = "Knife"
    },
    {
        ["Name"] = "Skin Case 3",
        ["Weapon"] = "IsRandom",
        ["Quantity"] = 1
    }
})
if v6.IS_ACTIVE then
    local v61 = v4.Info.EventCurrency.DisplayName
    v60("Currency", "eventcurrencybundle_1", v61 .. " Bundle", 2155532324, nil, {
        {
            ["Name"] = "EventCurrency",
            ["Quantity"] = 100
        }
    })
    v60("Currency", "eventcurrencybundle_2", "Mega " .. v61 .. " Bundle", 2155532405, nil, {
        {
            ["Name"] = "EventCurrency",
            ["Quantity"] = 400
        },
        {
            ["Name"] = v6.SPECIAL_LOOTBOX_VARIETY,
            ["Weapon"] = "IsRandom",
            ["Quantity"] = 1
        }
    })
    v60("Currency", "eventcurrencybundle_3", "Super " .. v61 .. " Bundle", 2155532505, nil, {
        {
            ["Name"] = "EventCurrency",
            ["Quantity"] = 900
        },
        {
            ["Name"] = v6.SPECIAL_LOOTBOX_VARIETY,
            ["Weapon"] = "IsRandom",
            ["Quantity"] = 3
        },
        {
            ["Name"] = v6.CURRENCY_BUNDLE_CHARM,
            ["Weapon"] = "IsRandom",
            ["Quantity"] = 1
        }
    })
    v60("Currency", "eventcurrencybundle_4", "Ultra " .. v61 .. " Bundle", 2155532614, nil, {
        {
            ["Name"] = "EventCurrency",
            ["Quantity"] = 4500
        },
        {
            ["Name"] = v6.SPECIAL_LOOTBOX_VARIETY,
            ["Weapon"] = "IsRandom",
            ["Quantity"] = 15
        },
        {
            ["Name"] = v6.CURRENCY_BUNDLE_CHARM,
            ["Weapon"] = "IsRandom",
            ["Quantity"] = 5
        },
        {
            ["Name"] = v6.CURRENCY_BUNDLE_WRAP,
            ["Weapon"] = "IsRandom",
            ["Quantity"] = 2
        },
        {
            ["Name"] = v6.CURRENCY_BUNDLE_FINISHER,
            ["Weapon"] = "IsRandom",
            ["Quantity"] = 1
        }
    })
    v60("Currency", "eventcurrencybundle_5", "Legendary " .. v61 .. " Bundle", 2155532697, nil, {
        {
            ["Name"] = "EventCurrency",
            ["Quantity"] = 11000
        },
        {
            ["Name"] = v6.SPECIAL_LOOTBOX_VARIETY,
            ["Weapon"] = "IsRandom",
            ["Quantity"] = 30
        },
        {
            ["Name"] = v6.CURRENCY_BUNDLE_CHARM,
            ["Weapon"] = "IsRandom",
            ["Quantity"] = 15
        },
        {
            ["Name"] = v6.CURRENCY_BUNDLE_WRAP,
            ["Weapon"] = "IsRandom",
            ["Quantity"] = 6
        },
        {
            ["Name"] = v6.CURRENCY_BUNDLE_FINISHER,
            ["Weapon"] = "IsRandom",
            ["Quantity"] = 3
        },
        {
            ["Name"] = v6.CURRENCY_BUNDLE_SKIN,
            ["Weapon"] = v3.Cosmetics[v6.CURRENCY_BUNDLE_SKIN].ItemName
        },
        {
            ["Name"] = v6.SPECIAL_LOOTBOX_SKINS,
            ["Weapon"] = "IsRandom",
            ["Quantity"] = 1
        }
    })
end
v60("Gamepass", "starter_bundle", "Starter Bundle", nil, "StarterBundle", {
    {
        ["Name"] = "Standard Weapon Crate",
        ["Quantity"] = 1
    },
    {
        ["Name"] = "Shorty"
    },
    {
        ["Name"] = "Too Shorty",
        ["Weapon"] = "Shorty"
    },
    {
        ["Name"] = "Paint",
        ["Weapon"] = "IsUniversal"
    },
    {
        ["Name"] = "Emoji: Nauseated",
        ["Weapon"] = "IsUniversal"
    },
    {
        ["Name"] = "Stiff",
        ["Weapon"] = "IsUniversal"
    },
    {
        ["Name"] = "Key",
        ["Quantity"] = 10
    }
}, "x12 VALUE")
v60("Gamepass", "standardweapons_bundle", "Standard Weapons Bundle", nil, "StandardWeaponsBundle", {
    {
        ["Name"] = "Disco",
        ["Weapon"] = "IsUniversal"
    },
    {
        ["Name"] = "Mini Disco Ball",
        ["Weapon"] = "IsUniversal"
    },
    {
        ["Name"] = "Boogie",
        ["Weapon"] = "IsUniversal"
    },
    {
        ["Name"] = "Wrap Box",
        ["Weapon"] = "IsRandom",
        ["Quantity"] = 5
    },
    {
        ["Name"] = "Charm Capsule",
        ["Weapon"] = "IsRandom",
        ["Quantity"] = 10
    },
    {
        ["Name"] = "Key",
        ["Quantity"] = 15
    }
}, "x3 VALUE")
v60("Gamepass", "classic_bundle", "Classic Bundle", nil, "ClassicBundle", {
    {
        ["Name"] = "Paintball Gun"
    },
    {
        ["Name"] = "Slingshot"
    },
    {
        ["Name"] = "Trowel"
    },
    {
        ["Name"] = "Subspace Tripmine"
    },
    {
        ["Name"] = "Classic",
        ["Weapon"] = "IsUniversal"
    },
    {
        ["Name"] = "Mini Ban Hammer",
        ["Weapon"] = "IsUniversal"
    },
    {
        ["Name"] = "OOF",
        ["Weapon"] = "IsUniversal"
    },
    {
        ["Name"] = "Wrap Box",
        ["Weapon"] = "IsRandom",
        ["Quantity"] = 10
    },
    {
        ["Name"] = "Charm Capsule",
        ["Weapon"] = "IsRandom",
        ["Quantity"] = 20
    },
    {
        ["Name"] = "Key",
        ["Quantity"] = 40
    }
}, "x7 VALUE")
v60("Gamepass", "heavyduty_bundle", "Heavy Duty Bundle", nil, "HeavyDutyBundle", {
    {
        ["Name"] = "Grenade Launcher"
    },
    {
        ["Name"] = "Minigun"
    },
    {
        ["Name"] = "Flamethrower"
    },
    {
        ["Name"] = "Magma",
        ["Weapon"] = "IsUniversal"
    },
    {
        ["Name"] = "Explosion",
        ["Weapon"] = "IsUniversal"
    },
    {
        ["Name"] = "Ignite",
        ["Weapon"] = "IsUniversal"
    },
    {
        ["Name"] = "Wrap Box",
        ["Weapon"] = "IsRandom",
        ["Quantity"] = 10
    },
    {
        ["Name"] = "Charm Capsule",
        ["Weapon"] = "IsRandom",
        ["Quantity"] = 20
    },
    {
        ["Name"] = "Key",
        ["Quantity"] = 40
    }
}, "x4 VALUE")
v60("Gamepass", "exogun_bundle", "Exogun Bundle", nil, "ExogunBundle", {
    {
        ["Name"] = "Exogun"
    },
    {
        ["Name"] = "Wondergun",
        ["Weapon"] = "Exogun"
    },
    {
        ["Name"] = "Nebula",
        ["Weapon"] = "IsUniversal"
    },
    {
        ["Name"] = "Alien Head",
        ["Weapon"] = "IsUniversal"
    },
    {
        ["Name"] = "Low Gravity",
        ["Weapon"] = "IsUniversal"
    },
    {
        ["Name"] = "Wrap Box",
        ["Weapon"] = "IsRandom",
        ["Quantity"] = 15
    },
    {
        ["Name"] = "Key",
        ["Quantity"] = 20
    }
}, "x4 VALUE")
v60("Gamepass", "medkit_bundle", "Medkit Bundle", nil, "MedkitBundle", {
    {
        ["Name"] = "Medkit"
    },
    {
        ["Name"] = "Briefcase",
        ["Weapon"] = "Medkit"
    },
    {
        ["Name"] = "Aurum",
        ["Weapon"] = "IsUniversal"
    },
    {
        ["Name"] = "First Aid",
        ["Weapon"] = "IsUniversal"
    },
    {
        ["Name"] = "Heartbeat",
        ["Weapon"] = "IsUniversal"
    },
    {
        ["Name"] = "Wrap Box",
        ["Weapon"] = "IsRandom",
        ["Quantity"] = 15
    },
    {
        ["Name"] = "Key",
        ["Quantity"] = 20
    }
}, "x10 VALUE")
v60("Gamepass", "pixel_bundle", "Pixel Bundle", nil, "PixelBundle", {
    {
        ["Name"] = "Pixel Burst",
        ["Weapon"] = "Burst Rifle"
    },
    {
        ["Name"] = "Pixel Handgun",
        ["Weapon"] = "Handgun"
    },
    {
        ["Name"] = "Pixel Katana",
        ["Weapon"] = "Katana"
    },
    {
        ["Name"] = "Pixel Flashbang",
        ["Weapon"] = "Flashbang"
    },
    {
        ["Name"] = "Geometric",
        ["Weapon"] = "IsUniversal"
    },
    {
        ["Name"] = "EZ",
        ["Weapon"] = "IsUniversal"
    },
    {
        ["Name"] = "Pixel Coins",
        ["Weapon"] = "IsUniversal"
    },
    {
        ["Name"] = "Finisher Pack",
        ["Weapon"] = "IsRandom",
        ["Quantity"] = 8
    },
    {
        ["Name"] = "Key",
        ["Quantity"] = 8
    }
}, "x8 VALUE")
v60("Gamepass", "energy_bundle", "Energy Bundle", nil, "EnergyBundle", {
    {
        ["Name"] = "Energy Rifle"
    },
    {
        ["Name"] = "Energy Pistols"
    },
    {
        ["Name"] = "Apex Rifle",
        ["Weapon"] = "Energy Rifle"
    },
    {
        ["Name"] = "Apex Pistols",
        ["Weapon"] = "Energy Pistols"
    },
    {
        ["Name"] = ".dll",
        ["Weapon"] = "IsUniversal"
    },
    {
        ["Name"] = "Energy Cell",
        ["Weapon"] = "IsUniversal"
    },
    {
        ["Name"] = "Beacon",
        ["Weapon"] = "IsUniversal"
    }
}, "x5 VALUE")
v60("Gamepass", "rpg_bundle", "RPG Bundle", nil, "RPGBundle", {
    {
        ["Name"] = "RPG"
    },
    {
        ["Name"] = "Pencil Launcher",
        ["Weapon"] = "RPG"
    },
    {
        ["Name"] = "Emoji: Nerd",
        ["Weapon"] = "IsUniversal"
    },
    {
        ["Name"] = "Cardboard",
        ["Weapon"] = "IsUniversal"
    },
    {
        ["Name"] = "Erased",
        ["Weapon"] = "IsUniversal"
    },
    {
        ["Name"] = "Key",
        ["Quantity"] = 5
    }
}, "x3 VALUE")
if v5.CurrentSeason.BattlePassActive then
    v60("Product", "primeseason_bundle", "Prime Bundle", 3406969974, nil, {
        {
            ["Name"] = "Prime Season Pass"
        },
        {
            ["Name"] = "Prime Nametag"
        }
    }, "<s>" .. utf8.char(57346) .. " 724</s>", {
        ["BattlePassMaxPassTrackNum"] = 2,
        ["UnlockNowDisplayName"] = "Prime Season Pass",
        ["UnlockNowWeaponStatusUIEffect"] = "Prime"
    })
    v60("Product", "contrabandseason_bundle", "Contraband Bundle", 3406992213, nil, {
        {
            ["Name"] = "Prime Season Pass"
        },
        {
            ["Name"] = "Contraband Nametag"
        },
        {
            ["Name"] = "Season Pass Level",
            ["Quantity"] = v5.SEASON_PASS_LEVELS_IN_SEASON_BUNDLE
        },
        {
            ["Name"] = "Prime Goodie Bag",
            ["Quantity"] = 10,
            ["Weapon"] = "IsRandom"
        },
        {
            ["Name"] = v5.CurrentSeason.ContrabandBundleWrapName,
            ["Quantity"] = 1,
            ["Weapon"] = "IsUniversal"
        },
        {
            ["Name"] = v5.CurrentSeason.ContrabandBundleCharmName,
            ["Quantity"] = 1,
            ["Weapon"] = "IsUniversal"
        },
        {
            ["Name"] = v5.CurrentSeason.ContrabandBundleFinisherName,
            ["Quantity"] = 1,
            ["Weapon"] = "IsUniversal"
        },
        {
            ["Name"] = v5.CurrentSeason.ContrabandBundleEmoteName,
            ["Quantity"] = 1
        }
    }, "<s>" .. utf8.char(57346) .. " 2,499</s>", {
        ["BattlePassMaxPassTrackNum"] = 2,
        ["BattlePassLevelIncrement"] = v5.SEASON_PASS_LEVELS_IN_SEASON_BUNDLE
    })
end
if v5.CurrentSeason.BattlePassActive then
    local v62 = v_u_38.Products.BattlePassLevels10 or error("???")
    local v63 = {
        ["ProductID"] = 3407624520,
        ["ProductType"] = "Product",
        ["GiftType"] = "Product",
        ["GiftName"] = "BattlePassLevels10",
        ["TargetProductID"] = v62.ProductID,
        ["DisplayName"] = v62.DisplayName,
        ["IsPaidRandomItem"] = nil,
        ["Quantity"] = nil,
        ["ImageID"] = nil
    }
    v_u_38.Gifts[tostring(3407624520)] = v63
    local v64 = v_u_38.GiftOrder
    local v65 = tostring(3407624520)
    table.insert(v64, v65)
    local v66 = v_u_38.Bundles.primeseason_bundle or error("???")
    local v67 = {
        ["ProductID"] = 3407614262,
        ["ProductType"] = "Product",
        ["GiftType"] = "Bundle",
        ["GiftName"] = "primeseason_bundle",
        ["TargetProductID"] = v66.ProductID,
        ["DisplayName"] = v66.DisplayName,
        ["IsPaidRandomItem"] = nil,
        ["Quantity"] = nil,
        ["ImageID"] = nil
    }
    v_u_38.Gifts[tostring(3407614262)] = v67
    local v68 = v_u_38.GiftOrder
    local v69 = tostring(3407614262)
    table.insert(v68, v69)
    local v70 = v_u_38.Bundles.contrabandseason_bundle or error("???")
    local v71 = {
        ["ProductID"] = 3407615047,
        ["ProductType"] = "Product",
        ["GiftType"] = "Bundle",
        ["GiftName"] = "contrabandseason_bundle",
        ["TargetProductID"] = v70.ProductID,
        ["DisplayName"] = v70.DisplayName,
        ["IsPaidRandomItem"] = nil,
        ["Quantity"] = nil,
        ["ImageID"] = nil
    }
    v_u_38.Gifts[tostring(3407615047)] = v71
    local v72 = v_u_38.GiftOrder
    local v73 = tostring(3407615047)
    table.insert(v72, v73)
end
local v74 = v_u_38.Gamepasses.StandardWeaponsBundle or error("???")
local v75 = {
    ["ProductID"] = 1890371681,
    ["ProductType"] = "Gamepass",
    ["GiftType"] = "Gamepass",
    ["GiftName"] = "StandardWeaponsBundle",
    ["TargetProductID"] = v74.GamepassID or v74.ProductID,
    ["DisplayName"] = v74.DisplayName,
    ["IsPaidRandomItem"] = nil,
    ["Quantity"] = nil,
    ["ImageID"] = nil
}
v_u_38.Gifts[tostring(1890371681)] = v75
local v76 = v_u_38.GiftOrder
local v77 = tostring(1890371681)
table.insert(v76, v77)
local v78 = v_u_38.Gamepasses.ClassicBundle or error("???")
local v79 = {
    ["ProductID"] = 1890372364,
    ["ProductType"] = "Gamepass",
    ["GiftType"] = "Gamepass",
    ["GiftName"] = "ClassicBundle",
    ["TargetProductID"] = v78.GamepassID or v78.ProductID,
    ["DisplayName"] = v78.DisplayName,
    ["IsPaidRandomItem"] = nil,
    ["Quantity"] = nil,
    ["ImageID"] = nil
}
v_u_38.Gifts[tostring(1890372364)] = v79
local v80 = v_u_38.GiftOrder
local v81 = tostring(1890372364)
table.insert(v80, v81)
local v82 = v_u_38.Gamepasses.HeavyDutyBundle or error("???")
local v83 = {
    ["ProductID"] = 1890372130,
    ["ProductType"] = "Gamepass",
    ["GiftType"] = "Gamepass",
    ["GiftName"] = "HeavyDutyBundle",
    ["TargetProductID"] = v82.GamepassID or v82.ProductID,
    ["DisplayName"] = v82.DisplayName,
    ["IsPaidRandomItem"] = nil,
    ["Quantity"] = nil,
    ["ImageID"] = nil
}
v_u_38.Gifts[tostring(1890372130)] = v83
local v84 = v_u_38.GiftOrder
local v85 = tostring(1890372130)
table.insert(v84, v85)
local v86 = v_u_38.Gamepasses.ExogunBundle or error("???")
local v87 = {
    ["ProductID"] = 1890372574,
    ["ProductType"] = "Gamepass",
    ["GiftType"] = "Gamepass",
    ["GiftName"] = "ExogunBundle",
    ["TargetProductID"] = v86.GamepassID or v86.ProductID,
    ["DisplayName"] = v86.DisplayName,
    ["IsPaidRandomItem"] = nil,
    ["Quantity"] = nil,
    ["ImageID"] = nil
}
v_u_38.Gifts[tostring(1890372574)] = v87
local v88 = v_u_38.GiftOrder
local v89 = tostring(1890372574)
table.insert(v88, v89)
local v90 = v_u_38.Gamepasses.MedkitBundle or error("???")
local v91 = {
    ["ProductID"] = 1890372831,
    ["ProductType"] = "Gamepass",
    ["GiftType"] = "Gamepass",
    ["GiftName"] = "MedkitBundle",
    ["TargetProductID"] = v90.GamepassID or v90.ProductID,
    ["DisplayName"] = v90.DisplayName,
    ["IsPaidRandomItem"] = nil,
    ["Quantity"] = nil,
    ["ImageID"] = nil
}
v_u_38.Gifts[tostring(1890372831)] = v91
local v92 = v_u_38.GiftOrder
local v93 = tostring(1890372831)
table.insert(v92, v93)
local v94 = v_u_38.Gamepasses.StarterBundle or error("???")
local v95 = {
    ["ProductID"] = 1890371901,
    ["ProductType"] = "Gamepass",
    ["GiftType"] = "Gamepass",
    ["GiftName"] = "StarterBundle",
    ["TargetProductID"] = v94.GamepassID or v94.ProductID,
    ["DisplayName"] = v94.DisplayName,
    ["IsPaidRandomItem"] = nil,
    ["Quantity"] = nil,
    ["ImageID"] = nil
}
v_u_38.Gifts[tostring(1890371901)] = v95
local v96 = v_u_38.GiftOrder
local v97 = tostring(1890371901)
table.insert(v96, v97)
local v98 = v_u_38.Gamepasses.PixelBundle or error("???")
local v99 = {
    ["ProductID"] = 2146952782,
    ["ProductType"] = "Gamepass",
    ["GiftType"] = "Gamepass",
    ["GiftName"] = "PixelBundle",
    ["TargetProductID"] = v98.GamepassID or v98.ProductID,
    ["DisplayName"] = v98.DisplayName,
    ["IsPaidRandomItem"] = nil,
    ["Quantity"] = nil,
    ["ImageID"] = nil
}
v_u_38.Gifts[tostring(2146952782)] = v99
local v100 = v_u_38.GiftOrder
local v101 = tostring(2146952782)
table.insert(v100, v101)
local v102 = v_u_38.Gamepasses.EnergyBundle or error("???")
local v103 = {
    ["ProductID"] = 2661338143,
    ["ProductType"] = "Gamepass",
    ["GiftType"] = "Gamepass",
    ["GiftName"] = "EnergyBundle",
    ["TargetProductID"] = v102.GamepassID or v102.ProductID,
    ["DisplayName"] = v102.DisplayName,
    ["IsPaidRandomItem"] = nil,
    ["Quantity"] = nil,
    ["ImageID"] = nil
}
v_u_38.Gifts[tostring(2661338143)] = v103
local v104 = v_u_38.GiftOrder
local v105 = tostring(2661338143)
table.insert(v104, v105)
local v106 = v_u_38.Gamepasses.RPGBundle or error("???")
local v107 = {
    ["ProductID"] = 3277561206,
    ["ProductType"] = "Gamepass",
    ["GiftType"] = "Gamepass",
    ["GiftName"] = "RPGBundle",
    ["TargetProductID"] = v106.GamepassID or v106.ProductID,
    ["DisplayName"] = v106.DisplayName,
    ["IsPaidRandomItem"] = nil,
    ["Quantity"] = nil,
    ["ImageID"] = nil
}
v_u_38.Gifts[tostring(3277561206)] = v107
local v108 = v_u_38.GiftOrder
local v109 = tostring(3277561206)
table.insert(v108, v109)
local v110 = v_u_7.Entries["lootbox_Skin Case"] or error("???")
local v111 = {
    ["ProductID"] = 1892544195,
    ["ProductType"] = "Product",
    ["GiftType"] = "ShopEntry",
    ["GiftName"] = "lootbox_Skin Case",
    ["TargetProductID"] = v110.ProductID,
    ["DisplayName"] = v110.Rewards[1].Name .. "" or v110.DisplayName,
    ["IsPaidRandomItem"] = true,
    ["Quantity"] = nil,
    ["ImageID"] = nil
}
v_u_38.Gifts[tostring(1892544195)] = v111
local v112 = v_u_38.GiftOrder
local v113 = tostring(1892544195)
table.insert(v112, v113)
local v114 = v_u_7.Entries["lootbox_Skin Case"] or error("???")
local v115 = {
    ["ProductID"] = 2319692001,
    ["ProductType"] = "Product",
    ["GiftType"] = "ShopEntry",
    ["GiftName"] = "lootbox_Skin Case",
    ["TargetProductID"] = v114.ProductIDTriple or v114.ProductID,
    ["DisplayName"] = v114.Rewards[1].Name .. " [x3]" or v114.DisplayName,
    ["IsPaidRandomItem"] = true,
    ["Quantity"] = 3,
    ["ImageID"] = nil
}
v_u_38.Gifts[tostring(2319692001)] = v115
local v116 = v_u_38.GiftOrder
local v117 = tostring(2319692001)
table.insert(v116, v117)
local v118 = v_u_7.Entries["lootbox_Skin Case 2"] or error("???")
local v119 = {
    ["ProductID"] = 1892544449,
    ["ProductType"] = "Product",
    ["GiftType"] = "ShopEntry",
    ["GiftName"] = "lootbox_Skin Case 2",
    ["TargetProductID"] = v118.ProductID,
    ["DisplayName"] = v118.Rewards[1].Name .. "" or v118.DisplayName,
    ["IsPaidRandomItem"] = true,
    ["Quantity"] = nil,
    ["ImageID"] = nil
}
v_u_38.Gifts[tostring(1892544449)] = v119
local v120 = v_u_38.GiftOrder
local v121 = tostring(1892544449)
table.insert(v120, v121)
local v122 = v_u_7.Entries["lootbox_Skin Case 2"] or error("???")
local v123 = {
    ["ProductID"] = 2319692175,
    ["ProductType"] = "Product",
    ["GiftType"] = "ShopEntry",
    ["GiftName"] = "lootbox_Skin Case 2",
    ["TargetProductID"] = v122.ProductIDTriple or v122.ProductID,
    ["DisplayName"] = v122.Rewards[1].Name .. " [x3]" or v122.DisplayName,
    ["IsPaidRandomItem"] = true,
    ["Quantity"] = 3,
    ["ImageID"] = nil
}
v_u_38.Gifts[tostring(2319692175)] = v123
local v124 = v_u_38.GiftOrder
local v125 = tostring(2319692175)
table.insert(v124, v125)
local v126 = v_u_7.Entries["lootbox_Skin Case 3"] or error("???")
local v127 = {
    ["ProductID"] = 3251887720,
    ["ProductType"] = "Product",
    ["GiftType"] = "ShopEntry",
    ["GiftName"] = "lootbox_Skin Case 3",
    ["TargetProductID"] = v126.ProductID,
    ["DisplayName"] = v126.Rewards[1].Name .. "" or v126.DisplayName,
    ["IsPaidRandomItem"] = true,
    ["Quantity"] = nil,
    ["ImageID"] = nil
}
v_u_38.Gifts[tostring(3251887720)] = v127
local v128 = v_u_38.GiftOrder
local v129 = tostring(3251887720)
table.insert(v128, v129)
local v130 = v_u_7.Entries["lootbox_Skin Case 3"] or error("???")
local v131 = {
    ["ProductID"] = 3251887824,
    ["ProductType"] = "Product",
    ["GiftType"] = "ShopEntry",
    ["GiftName"] = "lootbox_Skin Case 3",
    ["TargetProductID"] = v130.ProductIDTriple or v130.ProductID,
    ["DisplayName"] = v130.Rewards[1].Name .. " [x3]" or v130.DisplayName,
    ["IsPaidRandomItem"] = true,
    ["Quantity"] = 3,
    ["ImageID"] = nil
}
v_u_38.Gifts[tostring(3251887824)] = v131
local v132 = v_u_38.GiftOrder
local v133 = tostring(3251887824)
table.insert(v132, v133)
local v134 = v_u_38.Bundles.keybundle_1 or error("???")
local v135 = {
    ["ProductID"] = 1890374722,
    ["ProductType"] = "Product",
    ["GiftType"] = "Bundle",
    ["GiftName"] = "keybundle_1",
    ["TargetProductID"] = v134.ProductID,
    ["DisplayName"] = v134.DisplayName,
    ["IsPaidRandomItem"] = nil,
    ["Quantity"] = nil,
    ["ImageID"] = nil
}
v_u_38.Gifts[tostring(1890374722)] = v135
local v136 = v_u_38.GiftOrder
local v137 = tostring(1890374722)
table.insert(v136, v137)
local v138 = v_u_38.Bundles.keybundle_2 or error("???")
local v139 = {
    ["ProductID"] = 1890374959,
    ["ProductType"] = "Product",
    ["GiftType"] = "Bundle",
    ["GiftName"] = "keybundle_2",
    ["TargetProductID"] = v138.ProductID,
    ["DisplayName"] = v138.DisplayName,
    ["IsPaidRandomItem"] = nil,
    ["Quantity"] = nil,
    ["ImageID"] = nil
}
v_u_38.Gifts[tostring(1890374959)] = v139
local v140 = v_u_38.GiftOrder
local v141 = tostring(1890374959)
table.insert(v140, v141)
local v142 = v_u_38.Bundles.keybundle_3 or error("???")
local v143 = {
    ["ProductID"] = 1890375172,
    ["ProductType"] = "Product",
    ["GiftType"] = "Bundle",
    ["GiftName"] = "keybundle_3",
    ["TargetProductID"] = v142.ProductID,
    ["DisplayName"] = v142.DisplayName,
    ["IsPaidRandomItem"] = nil,
    ["Quantity"] = nil,
    ["ImageID"] = nil
}
v_u_38.Gifts[tostring(1890375172)] = v143
local v144 = v_u_38.GiftOrder
local v145 = tostring(1890375172)
table.insert(v144, v145)
local v146 = v_u_38.Bundles.keybundle_4 or error("???")
local v147 = {
    ["ProductID"] = 1890375405,
    ["ProductType"] = "Product",
    ["GiftType"] = "Bundle",
    ["GiftName"] = "keybundle_4",
    ["TargetProductID"] = v146.ProductID,
    ["DisplayName"] = v146.DisplayName,
    ["IsPaidRandomItem"] = nil,
    ["Quantity"] = nil,
    ["ImageID"] = nil
}
v_u_38.Gifts[tostring(1890375405)] = v147
local v148 = v_u_38.GiftOrder
local v149 = tostring(1890375405)
table.insert(v148, v149)
local v150 = v_u_38.Bundles.keybundle_5 or error("???")
local v151 = {
    ["ProductID"] = 1890375611,
    ["ProductType"] = "Product",
    ["GiftType"] = "Bundle",
    ["GiftName"] = "keybundle_5",
    ["TargetProductID"] = v150.ProductID,
    ["DisplayName"] = v150.DisplayName,
    ["IsPaidRandomItem"] = nil,
    ["Quantity"] = nil,
    ["ImageID"] = nil
}
v_u_38.Gifts[tostring(1890375611)] = v151
local v152 = v_u_38.GiftOrder
local v153 = tostring(1890375611)
table.insert(v152, v153)
if v6.IS_ACTIVE then
    local v154 = "lootbox_" .. v6.SPECIAL_LOOTBOX_SKINS
    local v155 = v_u_7.Entries[v154] or error("???")
    local v156 = {
        ["ProductID"] = 2154618268,
        ["ProductType"] = "Product",
        ["GiftType"] = "ShopEntry",
        ["GiftName"] = v154,
        ["TargetProductID"] = v155.ProductID,
        ["DisplayName"] = v155.Rewards[1].Name .. "" or v155.DisplayName,
        ["IsPaidRandomItem"] = true,
        ["Quantity"] = nil,
        ["ImageID"] = nil
    }
    v_u_38.Gifts[tostring(2154618268)] = v156
    local v157 = v_u_38.GiftOrder
    local v158 = tostring(2154618268)
    table.insert(v157, v158)
    local v159 = "lootbox_" .. v6.SPECIAL_LOOTBOX_SKINS
    local v160 = v_u_7.Entries[v159] or error("???")
    local v161 = {
        ["ProductID"] = 2319690506,
        ["ProductType"] = "Product",
        ["GiftType"] = "ShopEntry",
        ["GiftName"] = v159,
        ["TargetProductID"] = v160.ProductIDTriple or v160.ProductID,
        ["DisplayName"] = v160.Rewards[1].Name .. " [x3]" or v160.DisplayName,
        ["IsPaidRandomItem"] = true,
        ["Quantity"] = 3,
        ["ImageID"] = nil
    }
    v_u_38.Gifts[tostring(2319690506)] = v161
    local v162 = v_u_38.GiftOrder
    local v163 = tostring(2319690506)
    table.insert(v162, v163)
    local v164 = v_u_38.Bundles.eventcurrencybundle_1 or error("???")
    local v165 = {
        ["ProductID"] = 2319763472,
        ["ProductType"] = "Product",
        ["GiftType"] = "Bundle",
        ["GiftName"] = "eventcurrencybundle_1",
        ["TargetProductID"] = v164.ProductID,
        ["DisplayName"] = v164.DisplayName,
        ["IsPaidRandomItem"] = nil,
        ["Quantity"] = nil,
        ["ImageID"] = nil
    }
    v_u_38.Gifts[tostring(2319763472)] = v165
    local v166 = v_u_38.GiftOrder
    local v167 = tostring(2319763472)
    table.insert(v166, v167)
    local v168 = v_u_38.Bundles.eventcurrencybundle_2 or error("???")
    local v169 = {
        ["ProductID"] = 2319763545,
        ["ProductType"] = "Product",
        ["GiftType"] = "Bundle",
        ["GiftName"] = "eventcurrencybundle_2",
        ["TargetProductID"] = v168.ProductID,
        ["DisplayName"] = v168.DisplayName,
        ["IsPaidRandomItem"] = nil,
        ["Quantity"] = nil,
        ["ImageID"] = nil
    }
    v_u_38.Gifts[tostring(2319763545)] = v169
    local v170 = v_u_38.GiftOrder
    local v171 = tostring(2319763545)
    table.insert(v170, v171)
    local v172 = v_u_38.Bundles.eventcurrencybundle_3 or error("???")
    local v173 = {
        ["ProductID"] = 2319763627,
        ["ProductType"] = "Product",
        ["GiftType"] = "Bundle",
        ["GiftName"] = "eventcurrencybundle_3",
        ["TargetProductID"] = v172.ProductID,
        ["DisplayName"] = v172.DisplayName,
        ["IsPaidRandomItem"] = nil,
        ["Quantity"] = nil,
        ["ImageID"] = nil
    }
    v_u_38.Gifts[tostring(2319763627)] = v173
    local v174 = v_u_38.GiftOrder
    local v175 = tostring(2319763627)
    table.insert(v174, v175)
    local v176 = v_u_38.Bundles.eventcurrencybundle_4 or error("???")
    local v177 = {
        ["ProductID"] = 2319763722,
        ["ProductType"] = "Product",
        ["GiftType"] = "Bundle",
        ["GiftName"] = "eventcurrencybundle_4",
        ["TargetProductID"] = v176.ProductID,
        ["DisplayName"] = v176.DisplayName,
        ["IsPaidRandomItem"] = nil,
        ["Quantity"] = nil,
        ["ImageID"] = nil
    }
    v_u_38.Gifts[tostring(2319763722)] = v177
    local v178 = v_u_38.GiftOrder
    local v179 = tostring(2319763722)
    table.insert(v178, v179)
    local v180 = v_u_38.Bundles.eventcurrencybundle_5 or error("???")
    local v181 = {
        ["ProductID"] = 2319763802,
        ["ProductType"] = "Product",
        ["GiftType"] = "Bundle",
        ["GiftName"] = "eventcurrencybundle_5",
        ["TargetProductID"] = v180.ProductID,
        ["DisplayName"] = v180.DisplayName,
        ["IsPaidRandomItem"] = nil,
        ["Quantity"] = nil,
        ["ImageID"] = nil
    }
    v_u_38.Gifts[tostring(2319763802)] = v181
    local v182 = v_u_38.GiftOrder
    local v183 = tostring(2319763802)
    table.insert(v182, v183)
end
local function v188(p184, p185, p186)
    local v187 = v_u_38.VideoAdRewards
    table.insert(v187, {
        ["NumAdsRequired"] = p184,
        ["RewardDatas"] = p185 or {},
        ["PreRepetitionRewardDatas"] = p186 or {}
    })
end
v188(1, {
    {
        ["Name"] = "3D Glasses",
        ["Quantity"] = 1,
        ["Weapon"] = "IsRandom"
    }
}, nil)
v188(2, {
    {
        ["Name"] = "Glamour",
        ["Quantity"] = 1,
        ["Weapon"] = "IsRandom"
    }
}, nil)
v188(3, {
    {
        ["Name"] = "Director\'s Cut",
        ["Quantity"] = 1,
        ["Weapon"] = "IsRandom"
    }
}, {
    {
        ["Name"] = "Key",
        ["Quantity"] = 3
    }
})
return v_u_38