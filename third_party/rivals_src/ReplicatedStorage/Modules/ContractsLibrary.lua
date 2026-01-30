local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = require(v1.Modules.StatisticsLibrary)
local v_u_3 = require(v1.Modules.CosmeticLibrary)
require(v1.Modules.DuelLibrary)
require(v1.Modules.ItemLibrary)
local v_u_4 = require(v1.Modules.ShopLibrary)
local v_u_5 = require(v1.Modules.Utility)
local v_u_6 = {
    ["Assault Rifle"] = { "Blue", "Desert Camo", "Chibi Assault Rifle" },
    ["Bow"] = { "Red", "Forest Camo", "Chibi Bow" },
    ["Burst Rifle"] = { "Orange", "Arctic Camo", "Chibi Burst Rifle" },
    ["Flamethrower"] = { "Maize", "Scorched", "Chibi Flamethrower" },
    ["Grenade Launcher"] = { "Surge", "Glass", "Chibi Grenade Launcher" },
    ["Minigun"] = { "Spartan", "Malevolent", "Chibi Minigun" },
    ["Paintball Gun"] = { "Medium stone grey", "Omnisand", "Chibi Paintball Gun" },
    ["RPG"] = { "Teal", "Swirls", "Chibi RPG" },
    ["Shotgun"] = { "Purple", "Reptile", "Chibi Shotgun" },
    ["Sniper"] = { "Blush", "Patriot", "Chibi Sniper" },
    ["Flare Gun"] = { "Green", "PB & J", "Chibi Flare Gun" },
    ["Handgun"] = { "Yellow", "Digital Camo", "Chibi Handgun" },
    ["Exogun"] = { "Vile", "Quasar", "Chibi Exogun" },
    ["Revolver"] = { "Mint", "Street Camo", "Chibi Revolver" },
    ["Shorty"] = { "Sky", "Steel", "Chibi Shorty" },
    ["Slingshot"] = { "Studs", "Hesper", "Chibi Slingshot" },
    ["Uzi"] = { "Lemon", "Ocean Camo", "Chibi Uzi" },
    ["Chainsaw"] = { "Olive", "Circuit", "Chibi Chainsaw" },
    ["Fists"] = { "Salmon", "Rug", "Chibi Fists" },
    ["Katana"] = { "Crimson", "Clouds", "Chibi Katana" },
    ["Knife"] = { "Highlighter", "Urban Camo", "Chibi Knife" },
    ["Scythe"] = { "Navy", "Frosted", "Chibi Scythe" },
    ["Trowel"] = { "Inlets", "Slime", "Chibi Trowel" },
    ["Flashbang"] = { "Maroon", "Carpet", "Chibi Flashbang" },
    ["Grenade"] = { "Beige", "Brain", "Chibi Grenade" },
    ["Medkit"] = { "OranGG", "Water", "Chibi Medkit" },
    ["Molotov"] = { "Pink", "Mainframe", "Chibi Molotov" },
    ["Smoke Grenade"] = { "Brown", "Honeycomb", "Chibi Smoke Grenade" },
    ["Subspace Tripmine"] = { "Universal", "Black Opal", "Chibi Subspace Tripmine" },
    ["Freeze Ray"] = { "Cool", "Crossed", "Chibi Freeze Ray" },
    ["Energy Rifle"] = { "Termination", ".exe", "Chibi Energy Rifle" },
    ["Energy Pistols"] = { "Eco", "Sunset", "Chibi Energy Pistols" },
    ["Crossbow"] = { "Lumber", "Spellslinger", "Chibi Crossbow" },
    ["Daggers"] = { "Venom", "Fiery", "Chibi Daggers" },
    ["Battle Axe"] = { "MaGGenta", "Carmine", "Chibi Battle Axe" },
    ["War Horn"] = { "Ornate", "Voltaic", "Chibi War Horn" },
    ["Satchel"] = { "Cheese", "Money", "Chibi Satchel" },
    ["Riot Shield"] = { "Bluesteel", "Portal", "Chibi Riot Shield" },
    ["Spray"] = { "Stained", "Igneous", "Chibi Spray" },
    ["Gunblade"] = { "Gunmetal", "Celtic", "Chibi Gunblade" },
    ["Jump Pad"] = { "Olo", "Dawn", "Chibi Jump Pad" },
    ["Distortion"] = { "Bee", "Aegis", "Chibi Distortion" },
    ["Warper"] = { "Mint Choco Chip", "Fracture", "Chibi Warper" },
    ["Warpstone"] = { "Bliss", "Devourer", "Chibi Warpstone" },
    ["Maul"] = { "Cold Metal", "Plaid Pajama", "Chibi Maul" },
    ["Permafrost"] = { "Luxe", "Blizzard", "Chibi Permafrost" }
}
local v_u_24 = {
    ["Types"] = {},
    ["Contracts"] = {},
    ["WeaponContracts"] = {},
    ["MapContracts"] = {},
    ["GetWeaponContracts"] = function(p7, p8)
        return p7.WeaponContracts[p8] or {}
    end,
    ["GetMapContracts"] = function(p9, p10)
        return p9.MapContracts[p10] or {}
    end,
    ["GetContractNamesByStatistic"] = function(p11, p12, p13, p14)
        local v15 = {}
        for v16, v17 in pairs(p11.Contracts) do
            if v17.Type == p12 and (v17.Identifier == p13 and (v17.StatisticName == p14 or table.find(v17.ExtraStatisticNames, p14))) then
                table.insert(v15, v16)
            end
        end
        return v15
    end,
    ["GetWeaponContractNamesByStatistic"] = function(p18, p19, p20)
        return p18:GetContractNameByStatistic("Weapon", p19, p20)
    end,
    ["GetMapContractNamesByStatistic"] = function(p21, p22, p23)
        return p21:GetContractNameByStatistic("Map", p22, p23)
    end
}
v_u_24.Types.Weapon = {}
v_u_24.Types.Map = {}
local function v_u_41(p25, p26, p27, p28, p29, p30, p31)
    local v32 = v_u_24.Types[p25]
    assert(v32)
    local v33 = not v_u_24.Contracts[p26]
    assert(v33)
    for _, v34 in pairs(p29) do
        local v35 = v34[1]
        v34[1] = math.ceil(v35)
    end
    local v36 = {
        ["Type"] = p25,
        ["Name"] = p26,
        ["Identifier"] = p27,
        ["StatisticName"] = p28,
        ["Milestones"] = p29,
        ["ExtraStatisticNames"] = p30 or {},
        ["FullDisplayName"] = ""
    }
    for _, v37 in pairs({
        { v36.StatisticName },
        v36.ExtraStatisticNames
    }) do
        for _, v38 in pairs(v37) do
            v36.FullDisplayName = v36.FullDisplayName .. (v36.FullDisplayName == "" and "" or " + ") .. v_u_2.Info[v38].FullDisplayName
        end
    end
    for v39, v40 in pairs(p31) do
        v36[v39] = v40
    end
    v_u_24.Contracts[p26] = v36
    return v36
end
local function v_u_51(p42, p43, p44, p45, p46)
    local v47 = p42 == "MISSING_WEAPON" and p42 and p42 or (v_u_4:IsWeaponReleased(p42) and p42 and p42 or "unreleased weapon")
    local v48 = string.format("Earned from %s %s weapon contract", v_u_5:GetProperArticle(v47), v47)
    for _, v49 in pairs(v_u_6[p42]) do
        v_u_3:ExternallySetCosmeticDescription(v49, v48)
    end
    v_u_41("Weapon", p43, p42, p44, p45, p46, {})
    v_u_24.WeaponContracts[p42] = v_u_24.WeaponContracts[p42] or {}
    local v50 = v_u_24.WeaponContracts[p42]
    table.insert(v50, p43)
end
local function v_u_55(p52, p53, p54)
    if p52 == "Performance" then
        return ({
            {
                ["Name"] = "Key",
                ["Quantity"] = 1
            },
            {
                ["Name"] = "Charm Capsule",
                ["Weapon"] = p54,
                ["Quantity"] = 1
            },
            {
                ["Name"] = "Charm Capsule",
                ["Weapon"] = p54,
                ["Quantity"] = 1
            },
            {
                ["Name"] = "Wrap Box",
                ["Weapon"] = p54,
                ["Quantity"] = 1
            },
            {
                ["Name"] = "Gold",
                ["Weapon"] = p54
            },
            {
                ["Name"] = "Diamond",
                ["Weapon"] = p54
            },
            {
                ["Name"] = "Midas Touch",
                ["Weapon"] = p54
            },
            {
                ["Name"] = "Diamond Hands",
                ["Weapon"] = p54
            },
            {
                ["Name"] = "Dark Matter",
                ["Weapon"] = p54
            }
        })[p53]
    end
    if p52 == "Playtime" then
        return ({
            {
                ["Name"] = "Key",
                ["Quantity"] = 1
            },
            {
                ["Name"] = "Charm Capsule",
                ["Weapon"] = p54,
                ["Quantity"] = 1
            },
            {
                ["Name"] = v_u_6[p54][1],
                ["Weapon"] = "IsUniversal"
            },
            {
                ["Name"] = "Charm Capsule",
                ["Weapon"] = p54,
                ["Quantity"] = 1
            },
            {
                ["Name"] = "Wrap Box",
                ["Weapon"] = p54,
                ["Quantity"] = 1
            },
            {
                ["Name"] = v_u_6[p54][2],
                ["Weapon"] = "IsUniversal"
            },
            {
                ["Name"] = "Wrap Box 2",
                ["Weapon"] = p54,
                ["Quantity"] = 1
            },
            {
                ["Name"] = v_u_6[p54][3],
                ["Weapon"] = "IsUniversal"
            }
        })[p53]
    end
    assert(false, "???")
end
local function v58(p56, p57)
    v_u_51(p56, p56 .. " Eliminations", "StatisticEliminations", {
        { 5 * p57, v_u_55("Performance", 1, p56) },
        { 20 * p57, v_u_55("Performance", 2, p56) },
        { 100 * p57, v_u_55("Performance", 3, p56) },
        { 500 * p57, v_u_55("Performance", 4, p56) },
        { 2000 * p57, v_u_55("Performance", 5, p56) },
        { 10000 * p57, v_u_55("Performance", 6, p56) },
        { 20000 * p57, v_u_55("Performance", 7, p56) },
        { 30000 * p57, v_u_55("Performance", 8, p56) },
        { 40000 * p57, v_u_55("Performance", 9, p56) }
    })
end
local function v60(p59)
    v_u_51(p59, p59 .. " Playtime", "StatisticPlaytime", {
        { 300, v_u_55("Playtime", 1, p59) },
        { 1200, v_u_55("Playtime", 2, p59) },
        { 3600, v_u_55("Playtime", 3, p59) },
        { 21600, v_u_55("Playtime", 4, p59) },
        { 43200, v_u_55("Playtime", 5, p59) },
        { 86400, v_u_55("Playtime", 6, p59) },
        { 172800, v_u_55("Playtime", 7, p59) },
        { 259200, v_u_55("Playtime", 8, p59) }
    })
end
local v61 = {
    "Fists",
    "Knife",
    "Chainsaw",
    "Katana",
    "Scythe",
    "Trowel",
    "Battle Axe",
    "Maul"
}
local v62 = {
    "Arena",
    "Big Graveyard",
    "Docks",
    "Splash",
    "Bridge",
    "Crossroads",
    "Big Crossroads",
    "Shooting Range",
    "Big Backrooms",
    "Battleground",
    "Big Arena",
    "Construction",
    "Playground",
    "Onyx",
    "Graveyard",
    "Big Splash",
    "Big Onyx",
    "Backrooms",
    "Station",
    "Dimension",
    "Iceberg",
    "Village"
}
local v_u_63 = {
    ["Arena"] = { "Arena Diorama" },
    ["Big Graveyard"] = { "Big Graveyard Diorama" },
    ["Docks"] = { "Docks Diorama" },
    ["Splash"] = { "Splash Diorama" },
    ["Bridge"] = { "Bridge Diorama" },
    ["Crossroads"] = { "Crossroads Diorama" },
    ["Big Crossroads"] = { "Big Crossroads Diorama" },
    ["Shooting Range"] = { "Shooting Range Diorama" },
    ["Big Backrooms"] = { "Big Backrooms Diorama" },
    ["Battleground"] = { "Battleground Diorama" },
    ["Big Arena"] = { "Big Arena Diorama" },
    ["Construction"] = { "Construction Diorama" },
    ["Playground"] = { "Playground Diorama" },
    ["Onyx"] = { "Onyx Diorama" },
    ["Graveyard"] = { "Graveyard Diorama" },
    ["Big Splash"] = { "Big Splash Diorama" },
    ["Big Onyx"] = { "Big Onyx Diorama" },
    ["Backrooms"] = { "Backrooms Diorama" },
    ["Station"] = { "Station Diorama" },
    ["Dimension"] = { "Dimension Diorama" },
    ["Iceberg"] = { "Iceberg Diorama" },
    ["Village"] = { "Village Diorama" }
}
local v64 = {}
for _, v65 in pairs({
    "Assault Rifle",
    "Handgun",
    "Burst Rifle",
    "Sniper",
    "RPG",
    "Shorty",
    "Shotgun",
    "Bow",
    "Uzi",
    "Revolver",
    "Paintball Gun",
    "Slingshot",
    "Grenade Launcher",
    "Minigun",
    "Exogun",
    "Flamethrower",
    "Daggers",
    "Energy Pistols",
    "Energy Rifle",
    "Spray",
    "Crossbow",
    "Gunblade",
    "Distortion",
    "Permafrost"
}) do
    v58(v65, 1)
    v60(v65)
end
for _, v66 in pairs(v61) do
    v58(v66, 0.5)
    v60(v66)
end
v_u_51("Smoke Grenade", "Smoke Grenade Smokeds", "StatisticSmokedsEnemies", {
    { 1, v_u_55("Performance", 1, "Smoke Grenade") },
    { 5, v_u_55("Performance", 2, "Smoke Grenade") },
    { 20, v_u_55("Performance", 3, "Smoke Grenade") },
    { 75, v_u_55("Performance", 4, "Smoke Grenade") },
    { 200, v_u_55("Performance", 5, "Smoke Grenade") },
    { 1000, v_u_55("Performance", 6, "Smoke Grenade") },
    { 4000, v_u_55("Performance", 9, "Smoke Grenade") }
})
v60("Smoke Grenade")
v_u_51("Flashbang", "Flashbang Blinds", "StatisticBlindsEnemies", {
    { 1, v_u_55("Performance", 1, "Flashbang") },
    { 10, v_u_55("Performance", 2, "Flashbang") },
    { 50, v_u_55("Performance", 3, "Flashbang") },
    { 200, v_u_55("Performance", 4, "Flashbang") },
    { 500, v_u_55("Performance", 5, "Flashbang") },
    { 2500, v_u_55("Performance", 6, "Flashbang") },
    { 10000, v_u_55("Performance", 9, "Flashbang") }
})
v60("Flashbang")
v_u_51("Medkit", "Medkit Heals", "StatisticHealsGiven", {
    { 150, v_u_55("Performance", 1, "Medkit") },
    { 500, v_u_55("Performance", 2, "Medkit") },
    { 2500, v_u_55("Performance", 3, "Medkit") },
    { 12000, v_u_55("Performance", 4, "Medkit") },
    { 50000, v_u_55("Performance", 5, "Medkit") },
    { 140000, v_u_55("Performance", 6, "Medkit") },
    { 560000, v_u_55("Performance", 9, "Medkit") }
})
v60("Medkit")
v_u_51("Freeze Ray", "Freeze Ray Freezes", "StatisticFreezesEnemies", {
    { 1, v_u_55("Performance", 1, "Freeze Ray") },
    { 10, v_u_55("Performance", 2, "Freeze Ray") },
    { 50, v_u_55("Performance", 3, "Freeze Ray") },
    { 200, v_u_55("Performance", 4, "Freeze Ray") },
    { 500, v_u_55("Performance", 5, "Freeze Ray") },
    { 2500, v_u_55("Performance", 6, "Freeze Ray") },
    { 10000, v_u_55("Performance", 9, "Freeze Ray") }
})
v60("Freeze Ray")
v_u_51("Flare Gun", "Flare Gun Damage Dealt", "StatisticDamageDealt", {
    { 100, v_u_55("Performance", 1, "Flare Gun") },
    { 500, v_u_55("Performance", 2, "Flare Gun") },
    { 2500, v_u_55("Performance", 3, "Flare Gun") },
    { 12000, v_u_55("Performance", 4, "Flare Gun") },
    { 50000, v_u_55("Performance", 5, "Flare Gun") },
    { 140000, v_u_55("Performance", 6, "Flare Gun") },
    { 280000, v_u_55("Performance", 7, "Flare Gun") },
    { 420000, v_u_55("Performance", 8, "Flare Gun") },
    { 560000, v_u_55("Performance", 9, "Flare Gun") }
})
v60("Flare Gun")
v_u_51("Grenade", "Grenade Damage Dealt", "StatisticDamageDealt", {
    { 100, v_u_55("Performance", 1, "Grenade") },
    { 500, v_u_55("Performance", 2, "Grenade") },
    { 2500, v_u_55("Performance", 3, "Grenade") },
    { 12000, v_u_55("Performance", 4, "Grenade") },
    { 50000, v_u_55("Performance", 5, "Grenade") },
    { 140000, v_u_55("Performance", 6, "Grenade") },
    { 280000, v_u_55("Performance", 7, "Grenade") },
    { 420000, v_u_55("Performance", 8, "Grenade") },
    { 560000, v_u_55("Performance", 9, "Grenade") }
})
v60("Grenade")
v_u_51("Molotov", "Molotov Damage Dealt", "StatisticDamageDealt", {
    { 100, v_u_55("Performance", 1, "Molotov") },
    { 500, v_u_55("Performance", 2, "Molotov") },
    { 2500, v_u_55("Performance", 3, "Molotov") },
    { 12000, v_u_55("Performance", 4, "Molotov") },
    { 50000, v_u_55("Performance", 5, "Molotov") },
    { 140000, v_u_55("Performance", 6, "Molotov") },
    { 280000, v_u_55("Performance", 7, "Molotov") },
    { 420000, v_u_55("Performance", 8, "Molotov") },
    { 560000, v_u_55("Performance", 9, "Molotov") }
})
v60("Molotov")
v_u_51("Subspace Tripmine", "Subspace Tripmine Damage Dealt", "StatisticDamageDealt", {
    { 100, v_u_55("Performance", 1, "Subspace Tripmine") },
    { 500, v_u_55("Performance", 2, "Subspace Tripmine") },
    { 2500, v_u_55("Performance", 3, "Subspace Tripmine") },
    { 12000, v_u_55("Performance", 4, "Subspace Tripmine") },
    { 50000, v_u_55("Performance", 5, "Subspace Tripmine") },
    { 140000, v_u_55("Performance", 6, "Subspace Tripmine") },
    { 280000, v_u_55("Performance", 7, "Subspace Tripmine") },
    { 420000, v_u_55("Performance", 8, "Subspace Tripmine") },
    { 560000, v_u_55("Performance", 9, "Subspace Tripmine") }
})
v60("Subspace Tripmine")
v_u_51("War Horn", "War Horn Empowers", "StatisticEmpowers", {
    { 3, v_u_55("Performance", 1, "War Horn") },
    { 50, v_u_55("Performance", 2, "War Horn") },
    { 250, v_u_55("Performance", 3, "War Horn") },
    { 1250, v_u_55("Performance", 4, "War Horn") },
    { 5000, v_u_55("Performance", 5, "War Horn") },
    { 10000, v_u_55("Performance", 6, "War Horn") },
    { 40000, v_u_55("Performance", 9, "War Horn") }
})
v60("War Horn")
v_u_51("Satchel", "Satchel Damage Dealt", "StatisticDamageDealt", {
    { 100, v_u_55("Performance", 1, "Satchel") },
    { 500, v_u_55("Performance", 2, "Satchel") },
    { 2500, v_u_55("Performance", 3, "Satchel") },
    { 12000, v_u_55("Performance", 4, "Satchel") },
    { 50000, v_u_55("Performance", 5, "Satchel") },
    { 140000, v_u_55("Performance", 6, "Satchel") },
    { 280000, v_u_55("Performance", 7, "Satchel") },
    { 420000, v_u_55("Performance", 8, "Satchel") },
    { 560000, v_u_55("Performance", 9, "Satchel") }
})
v60("Satchel")
v_u_51("Riot Shield", "Riot Shield Heals", "StatisticAbsorbs", {
    { 300, v_u_55("Performance", 1, "Riot Shield") },
    { 1000, v_u_55("Performance", 2, "Riot Shield") },
    { 5000, v_u_55("Performance", 3, "Riot Shield") },
    { 24000, v_u_55("Performance", 4, "Riot Shield") },
    { 100000, v_u_55("Performance", 5, "Riot Shield") },
    { 280000, v_u_55("Performance", 6, "Riot Shield") },
    { 560000, v_u_55("Performance", 7, "Riot Shield") },
    { 840000, v_u_55("Performance", 8, "Riot Shield") },
    { 1120000, v_u_55("Performance", 9, "Riot Shield") }
})
v60("Riot Shield")
v_u_51("Jump Pad", "Jump Pad Bounces", "StatisticBounces", {
    { 1, v_u_55("Performance", 1, "Jump Pad") },
    { 25, v_u_55("Performance", 2, "Jump Pad") },
    { 120, v_u_55("Performance", 3, "Jump Pad") },
    { 500, v_u_55("Performance", 4, "Jump Pad") },
    { 1500, v_u_55("Performance", 5, "Jump Pad") },
    { 4500, v_u_55("Performance", 6, "Jump Pad") },
    { 18000, v_u_55("Performance", 9, "Jump Pad") }
})
v60("Jump Pad")
v_u_51("Warper", "Warper Portals Spawned", "StatisticPortalsSpawned", {
    { 1, v_u_55("Performance", 1, "Warper") },
    { 10, v_u_55("Performance", 2, "Warper") },
    { 50, v_u_55("Performance", 3, "Warper") },
    { 200, v_u_55("Performance", 4, "Warper") },
    { 500, v_u_55("Performance", 5, "Warper") },
    { 2500, v_u_55("Performance", 6, "Warper") },
    { 10000, v_u_55("Performance", 9, "Warper") }
})
v60("Warper")
v_u_51("Warpstone", "Warpstone Warps", "StatisticWarps", {
    { 1, v_u_55("Performance", 1, "Warpstone") },
    { 10, v_u_55("Performance", 2, "Warpstone") },
    { 50, v_u_55("Performance", 3, "Warpstone") },
    { 200, v_u_55("Performance", 4, "Warpstone") },
    { 500, v_u_55("Performance", 5, "Warpstone") },
    { 2500, v_u_55("Performance", 6, "Warpstone") },
    { 10000, v_u_55("Performance", 9, "Warpstone") }
})
v60("Warpstone")
local function v_u_73(p67, p68, p69, p70, p71)
    v_u_41("Map", p68, p67, p69, p70, p71, {})
    v_u_24.MapContracts[p67] = v_u_24.MapContracts[p67] or {}
    local v72 = v_u_24.MapContracts[p67]
    table.insert(v72, p68)
end
local function v_u_77(p74, p75, p76)
    if p74 == "Performance" then
        return ({
            {
                ["Name"] = "Key",
                ["Quantity"] = 1
            },
            {
                ["Name"] = "Charm Capsule",
                ["Weapon"] = "IsRandom",
                ["Quantity"] = 1
            },
            {
                ["Name"] = "Wrap Box",
                ["Weapon"] = "IsRandom",
                ["Quantity"] = 1
            },
            {
                ["Name"] = "Finisher Pack",
                ["Weapon"] = "IsRandom",
                ["Quantity"] = 1
            },
            {
                ["Name"] = "Key",
                ["Quantity"] = 4
            },
            {
                ["Name"] = v_u_63[p76][1],
                ["Weapon"] = "IsUniversal"
            }
        })[p75]
    elseif p74 == "Playtime" then
        assert(false, "Not implemented yet")
    else
        assert(false, "???")
    end
end
local function v80(p78, p79)
    v_u_3:ExternallySetCosmeticDescription(v_u_63[p78][1], string.format("Earned from %s %s map contract", v_u_5:GetProperArticle(p78), p78))
    v_u_73(p78, p78 .. " Rounds Won", "StatisticRoundsWon", {
        { 10 * p79, v_u_77("Performance", 1, p78) },
        { 40 * p79, v_u_77("Performance", 2, p78) },
        { 100 * p79, v_u_77("Performance", 3, p78) },
        { 300 * p79, v_u_77("Performance", 4, p78) },
        { 600 * p79, v_u_77("Performance", 5, p78) },
        { 1000 * p79, v_u_77("Performance", 6, p78) }
    }, { "StatisticRankedRoundsWon" })
end
for _, v81 in pairs(v62) do
    v80(v81, 1)
end
for _, v82 in pairs(v64) do
    v80(v82, 0.5)
end
(function()
    for _, v83 in pairs(v_u_4.OwnableWeapons) do
        local v84 = false
        for _, v85 in pairs(v_u_24.Contracts) do
            if v85.Identifier == v83 then
                v84 = true
                break
            end
        end
        assert(v84, v83)
    end
end)()
return v_u_24