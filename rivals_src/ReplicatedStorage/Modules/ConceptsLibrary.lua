local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = require(v1.Modules.CosmeticLibrary)
local v_u_3 = {
    ["Kevin_DJiceninja"] = {
        ["UserID"] = 1544275061,
        ["Cosmetics"] = { "Hyper Sniper", "Apex Pistols", "Bat Daggers" }
    },
    ["SooHui_PH2"] = {
        ["UserID"] = 1796756117,
        ["Cosmetics"] = { "Spaceship Launcher", "Boba Gun" }
    },
    ["mozzywalkstheplank"] = {
        ["UserID"] = 10763717,
        ["Cosmetics"] = {
            "Keyttle Axe",
            "Spider Web",
            "Energy Shield",
            "Wrapped Freeze Ray"
        }
    },
    ["Invicibrow"] = {
        ["UserID"] = 7207159625,
        ["Cosmetics"] = {
            "Gearnade Launcher",
            "Squid Launcher",
            "Notebook Satchel",
            "Mega Drill",
            "Masterpiece"
        }
    },
    ["NPC2Z"] = {
        ["UserID"] = 446253736,
        ["Cosmetics"] = { "Water Balloon", "Soul Grenade", "Bounce House" }
    },
    ["NSK0815"] = {
        ["UserID"] = 3746614610,
        ["Cosmetics"] = { "Bag o\' Money", "Ban Axe" }
    },
    ["tazd"] = {
        ["UserID"] = 343054539,
        ["Cosmetics"] = { "Medkitty" }
    },
    ["TheMonkeyMasterSeb"] = {
        ["UserID"] = 4830771682,
        ["Cosmetics"] = { "Hourglass" }
    },
    ["ayroyuusho123"] = {
        ["UserID"] = 4382977409,
        ["Cosmetics"] = { "Fighter Jet" }
    },
    ["myxushi"] = {
        ["UserID"] = 436956865,
        ["Cosmetics"] = { "Mimic Axe" }
    },
    ["S3ntraMyst1c"] = {
        ["UserID"] = 3751863229,
        ["Cosmetics"] = { "Cerulean Axe", "Repulsor" }
    },
    ["StrangerHades0"] = {
        ["UserID"] = 4942063762,
        ["Cosmetics"] = { "Event Horizon" }
    },
    ["ACrystalPirate"] = {
        ["UserID"] = 2592938109,
        ["Cosmetics"] = { "Neon Lights", "Regal" }
    },
    ["MunchFish"] = {
        ["UserID"] = 1544233658,
        ["Cosmetics"] = { "Candy Apple" }
    },
    ["BobbVX"] = {
        ["UserID"] = 301707243,
        ["Cosmetics"] = { "Cardboard" }
    },
    ["Z0Z_Gaming"] = {
        ["UserID"] = 874685655,
        ["Cosmetics"] = { "Diamond" }
    },
    ["nekoanims"] = {
        ["UserID"] = 780350915,
        ["Cosmetics"] = { "Hammered Copper", "Honeycomb" }
    },
    ["SpunkyKatane"] = {
        ["UserID"] = 1325102532,
        ["Cosmetics"] = { "Jolly Man", "Plasma Distortion" }
    }
}
local v_u_16 = {
    ["CONCEPT_REWARD_NAME"] = "Scribble",
    ["Leaderboard"] = {},
    ["Conceptors"] = {},
    ["GetConceptors"] = function(_, p4)
        local v5 = {}
        for v6, v7 in pairs(v_u_16.Conceptors) do
            if table.find(v7.CosmeticConcepts, p4) then
                table.insert(v5, v6)
            end
        end
        return v5
    end,
    ["GetConceptScore"] = function(_, p8)
        local v9 = v_u_16.Conceptors[tostring(p8)]
        if not v9 then
            return 0
        end
        local v10 = 0
        for _, v11 in pairs(v9.CosmeticConcepts) do
            local v12 = #v_u_16:GetConceptors(v11)
            if v12 == 0 then
                warn("??? Conceptors for cosmetic " .. v11 .. " == 0")
            else
                v10 = v10 + 1 / v12
            end
        end
        return v10
    end,
    ["GetNextMilestone"] = function(_, p13)
        for v14, v15 in pairs(v_u_16.Milestones) do
            if p13 < v15[1] then
                return v15, v_u_16.Milestones[v14 - 1]
            end
        end
    end
}
local function v30(p17, p18)
    local v19
    if typeof(p17) == "number" then
        v19 = p17 ~= 0
    else
        v19 = false
    end
    assert(v19)
    local v20 = {}
    for v21 = #p18, 1, -1 do
        local v22 = p18[v21]
        if v_u_2.Cosmetics[v22] then
            local v23 = not v20[v22]
            local v24 = "Item entered in more than once: " .. v22
            assert(v23, v24)
            v20[v22] = true
        else
            table.remove(p18, v21)
            warn("Item doesnt exist: " .. v22)
        end
    end
    local v25 = {
        ["UserID"] = p17,
        ["CosmeticConcepts"] = p18 or {}
    }
    local v26 = v_u_16.Conceptors
    local v27 = v25.UserID
    v26[tostring(v27)] = v25
    local v28 = {
        ["key"] = tostring(p17),
        ["value"] = nil
    }
    local v29 = v_u_16.Leaderboard
    table.insert(v29, v28)
end
for _, v31 in pairs(v_u_3) do
    v30(v31.UserID, v31.Cosmetics)
end
(function()
    for _, v32 in pairs(v_u_16.Leaderboard) do
        v32.value = v_u_16:GetConceptScore(v32.key)
    end
    table.sort(v_u_16.Leaderboard, function(p33, p34)
        return p33.value > p34.value
    end)
    local v35 = {}
    for _, v36 in pairs(v_u_3) do
        if v35[v36.UserID] then
            warn("[CONCEPTS] Duplicate User ID:", v36.UserID)
        end
        v35[v36.UserID] = true
    end
end)()
return v_u_16