local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = require(v1.Modules.ShopLibrary)
local v_u_3 = require(v1.Modules.Utility)
local function v9(p4, p5, ...)
    local v6 = v_u_2:GetTimeUntilWeaponRelease(p5)
    if v6 > 0 then
        return {
            { "Header", p4 .. ".   " .. string.rep("?", #p5) },
            { "Description", "\226\143\176 Releases in " .. v_u_3:TimeFormat2(v6, 2) }
        }
    end
    local v7 = {
        { "Header", p4 .. ".   " .. p5 },
        { "Description", "\240\159\142\138 RELEASED" }
    }
    for _, v8 in pairs({ ... }) do
        table.insert(v7, { "Description", v8 })
    end
    return v7
end
return {
    ["Name"] = script.Name,
    ["Date"] = "November 28, 2024",
    ["Title"] = "UPDATE 7 \240\159\148\171",
    ["Image"] = math.random() < 0.5 and "rbxassetid://129689447476971" or "rbxassetid://128718997056742",
    ["Code"] = nil,
    ["Changes"] = {
        { "Title", "\240\159\149\185 NEW WEAPONS" },
        { "Description", "The massive Weapons Update is here! There will be nearly a dozen new weapons added to the game WEEKLY starting NOW!" },
        {
            v9,
            1,
            "Energy Rifle",
            "Shoot an \226\136\158 amount of energy beams that bounce multiple times around walls!",
            "The \"Hacker Rifle\" skin is now available in the Skin Case!"
        },
        {
            v9,
            2,
            "Energy Pistols",
            "Melt your enemies with the newest, fastest, \226\136\158 ammo weapon!",
            "The \"Hacker Pistols\" skin is now available in the Skin Case!"
        },
        {
            v9,
            3,
            "Crossbow",
            "A light-weight, hipfire-accurate sniper!",
            "The \"Pixel Crossbow\" skin is now available in the Skin Case!"
        },
        {
            v9,
            4,
            "Daggers",
            "Double jump and burst your enemies down like a ninja!",
            "The \"Aces\" skin is now available in the Skin Case!"
        },
        {
            v9,
            5,
            "Battle Axe",
            "This heavy-hitting, spin-attacking melee will crush your enemies!",
            "The \"The Shred\" skin is now available in the Skin Case!"
        },
        {
            v9,
            6,
            "Satchel",
            "The Grenade\'s cousin is here \226\128\148 throw multiple of these explosives and detonate them at will!",
            "The \"Advanced Satchel\" skin is now available in the Skin Case!"
        },
        {
            v9,
            7,
            "War Horn",
            "Empower your entire team and charge them into battle!",
            "The \"Trumpet\" skin is now available in the Skin Case!"
        },
        {
            v9,
            8,
            "Riot Shield",
            "Just a huge chunk of metal. Blocks most damage sources!",
            "The \"Door\" skin is now available in the Skin Case!"
        },
        {
            v9,
            9,
            "Spray",
            "This five-round burst secondary will either melt your enemies or get you in trouble with the law (or both)!",
            "The \"Lovely Spray\" skin is now available in the Skin Case!"
        },
        {
            v9,
            10,
            "Gunblade",
            "The final weapon in this massive Weapons Update - a gun that can also be used as a melee!",
            "The \"Hyper Gunblade\" skin is now available in the Skin Case!"
        },
        { "Title", "\226\154\161 ENERGY BUNDLE" },
        { "Header", "Contains the following:" },
        { "Description", "The brand new Energy Rifle weapon!" },
        { "Description", "The brand new Energy Pistols weapon!" },
        { "Description", "Apex Rifle skin for the Energy Rifle!" },
        { "Description", "Apex Pistols skin for the Energy Pistols!" },
        { "Description", "Exclusive Beacon finisher for all weapons!" },
        { "Description", "Exclusive .dll wrap for all weapons!" },
        { "Description", "Exclusive Energy Cell charm for all weapons!" },
        { "Header", "Now available in the Shop!" },
        { "Title", "\240\159\143\161 MAPS" },
        { "Description", "Station changes \226\128\148 adjusted spawn points, extended back wall of the house, added forklift between trains, & changed up the interior flow for the center building" },
        { "Description", "Graveyard changes \226\128\148 adjusted spawn points, removed the underground & basement & steeple interior, & revamped the chapel" },
        { "Description", "Dashing through the water in Splash & Big Splash will no longer eliminate you!" },
        { "Description", "NEW Big Graveyard map \226\128\148 specifically designed for larger lobbies!" },
        { "Description", "Big Splash, Big Graveyard, & Docks have been added to Free For All, Team Deathmatch!" },
        { "Description", "Big Graveyard has been added to 1v1v1 & 2v2v2!" },
        { "Title", "\240\159\148\165 SHOP" },
        { "Description", "NEW Energy Bundle - Contains the brand new Energy Rifle, Energy Pistols, & more!" },
        { "Description", "NEW Skin Case content - As the brand new weapons release weekly, a skin for each of them will also release inside of the Skin Case!" },
        { "Description", "The Damasucs & Black Damascus wraps have been replaced with the brand new, limited time Empress & Pixel Blight wraps!" },
        { "Title", "\240\159\142\168 COSMETICS" },
        { "Description", "New skins can be found in the new Energy Bundle & in the Skin Case as new weapons release every week!" },
        { "Description", "NEW Shadore Wrap - Win with or against @ShadowTrojan to earn this brand new wrap!" },
        { "Description", "NEW Brianore Wrap - Win with or against @Brian1KB to earn this brand new wrap!" },
        { "Description", "NEW Boomore Wrap - Win with or against @GreatGuyBoom to earn this brand new wrap!" },
        { "Description", "NEW ShadowTrojan Charm - Eliminate @ShadowTrojan to earn this brand new charm!" },
        { "Description", "NEW Brian1KB Charm - Eliminate @Brian1KB to earn this brand new charm!" },
        { "Description", "NEW GreatGuyBoom Charm - Eliminate @GreatGuyBoom to earn this brand new charm!" },
        { "Description", "NEW Kaye Charm - Eliminate @swaglord_KAYE to earn this brand new charm!" },
        { "Description", "NEW Karful Charm - Eliminate @Karfulol to earn this brand new charm!" },
        { "Description", "NEW Khayri Charm - Eliminate @Khxyri to earn this brand new charm!" },
        { "Title", "\240\159\148\171 BALANCE CHANGES" },
        { "Header", "Flamethrower" },
        { "Description", "\240\159\147\157 \"The Flamethrower should keep it\'s current power but at a shorter distance\"" },
        { "Description", "\240\159\148\187 Range decreased from 27studs \226\134\146 26studs" },
        { "Header", "Revolver" },
        { "Description", "\240\159\147\157 \"We\'re reducing the Revolver\'s overall power without changing basic interactions\"" },
        { "Description", "\240\159\148\187 Damage reduced from 33 \226\134\146 30" },
        { "Header", "Slingshot" },
        { "Description", "\240\159\147\157 \"The projectile changes weakened the Slingshot and are being reverted\"" },
        { "Description", "\226\158\150 Projectile speed increased from 150studs/s \226\134\146 300studs/s" },
        { "Description", "\226\158\150 Projectile elasticity decreased from 100% \226\134\146 50%" },
        { "Description", "\240\159\146\170 Projectile hitbox size increased from 0.75studs \226\134\146 5studs" },
        { "Header", "Grenade" },
        { "Description", "\240\159\147\157 \"This mechanic turned the Grenade into something completely different and should instead be fleshed out into a new weapon\"" },
        { "Description", "\240\159\148\187 Can no longer be detonated on hit" },
        { "Header", "Other" },
        { "Description", "\240\159\146\170 Auto Shoot will no longer trigger while noscoping with Sniper" },
        { "Description", "\240\159\146\170 All projectile-based weapons now have extremely consistent hitboxes" },
        { "Title", "\240\159\155\160 OTHER" },
        { "Description", "You can now pick a weapon at random in a duel!" },
        { "Description", "The Elimination Feed now displays assists!" },
        { "Description", "You can now see the airborne effect under other players\' feet!" },
        { "Description", "The following wraps have received visual improvements - Pink Glitter, Sensite, Nosnite, & Nekore!" },
        { "Description", "The Water Uzi skin now has a blue muzzle flash!" },
        { "Description", "The Lasergun 3000 colors were changed to be more consistent with what we consider to be \"laser\" themed VS \"energy\" themed" },
        { "Description", "The Spooky Event is over \226\128\148 leftover candy has been converted into Haunted Chests, all of the Spooky shop items have been removed, & maps have been reverted back to normal" },
        { "Title", "\240\159\144\155 BUG FIXES" },
        { "Description", "Fixed several user interface related bugs" },
        { "Description", "Fixed a bug where turning your HUD off prevented you from spinning viewmodels in the Weapons page" },
        { "Description", "Fixed a bug where sometimes stepping off the duel pads wouldn\'t remove you from the queue" },
        { "Description", "Fixed a bug with Revolver where you could cancel it\'s ability by simply shooting during it" },
        { "Description", "Fixed a bug with Mobile where the keyboard would get permanently stuck when chatting during the teleport screen" },
        { "Description", "Fixed a bug where certain fire particles would obstruct vision" },
        { "Description", "Fixed a bug where breaking windows/targets/other objects played finisher effects" },
        { "Description", "Fixed a rare bug where some weapons would incorrectly display as MAX level" },
        { "Description", "Fixed a rare bug that softlocked players that quick attacked right before being frozen" },
        { "Description", "Fixed a rare bug that allowed you to run really fast" },
        { "Title", "\240\159\147\156 A NOTE FROM THE DEVELOPERS" },
        { "Description", "Hey everyone, we hope you enjoy these next few weeks as we release a ton of brand new weapons for the first time in months!" },
        { "Description", "To be further transparent, our next update is planned to be the Winter/Festive update coming out in just a few weeks!" },
        { "Description", "Our plan for the highly anticipated Ranked mode has evolved into a much bigger update, which we now plan to release at the beginning of the new year." },
        { "Description", "We want to make sure Ranked is an amazing experience on release, but we\'ve been backed up with these necessary holiday updates. We thank you all for understanding, it\'ll be worth the wait!" }
    }
}