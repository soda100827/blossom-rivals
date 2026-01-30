local v_u_1 = {
    ["NUM_BEGINNER_TASKS"] = 3,
    ["DAILY_TASKS_RARE_REWARD"] = "Nova",
    ["DAILY_TASKS_RARE_REWARD_CHANCE"] = 0.05,
    ["DAILY_TASKS_LEGENDARY_REWARD"] = "Supernova",
    ["DAILY_TASKS_LEGENDARY_REWARD_CHANCE"] = 0.01,
    ["SPECIAL_CHALLENGES_VERSION"] = 3,
    ["SPECIAL_CHALLENGES"] = nil,
    ["SPECIAL_CHALLENGES_MUST_BE_COMPLETED_IN_ORDER"] = false,
    ["DAILY_TASK_STREAK_REWARD_MAX_MULTIPLIER"] = 1,
    ["NUM_DAILY_TASK_STREAK_REWARD_MILESTONES"] = 0,
    ["Info"] = {},
    ["DailyTaskStreakRewards"] = {}
}
local function v9(p2, p3, p4, p5, p6, p7)
    local v8 = {
        ["Goal"] = p3,
        ["Title"] = p5,
        ["Icon"] = p6 or "rbxassetid://17619445009",
        ["Rewards"] = typeof(p4) == "number" and ({
            {
                ["Name"] = "Key",
                ["Quantity"] = p4
            }
        } or p4) or p4,
        ["BadgeName"] = p7
    }
    v_u_1.Info[p2] = v8
end
v9("Beginner1", 1, 1, "Go to Shooting Range", "rbxassetid://17539215512")
v9("Beginner2", 5, 1, "Break targets", "rbxassetid://17738770088")
v9("Beginner3", 3, 1, "Run + crouch to Slide", "rbxassetid://17735857643")
v9("Beginner4", 1, 2, "Equip Scythe", "rbxassetid://17735878660")
v9("Beginner5", 3, 2, "Scythe Dash (MB2 / Aim)", "rbxassetid://16828140099")
v9("Beginner6", 1, 2, "Throw a Grenade", "rbxassetid://17513805716")
v9("Beginner7", 1, 3, "Play a duel", "rbxassetid://17738769051")
v9("Beginner8", 5, 3, "Eliminations", "rbxassetid://17735857264")
v9("Beginner9", 1, 3, "Win a duel", "rbxassetid://17735868621")
v9("Core1", 5, 2, "Play duels", "rbxassetid://17738769051")
v9("Core2", 15, 3, "Eliminations", "rbxassetid://17735857264")
v9("Core3", 2, 4, "Win a duel", "rbxassetid://17735868621")
v9("RepeatableCore1", 12, 1, "Play duels", "rbxassetid://17738769051")
v9("RepeatableCore2", 40, 2, "Eliminations", "rbxassetid://17735857264")
v9("RepeatableCore3", 12, 3, "Win duels", "rbxassetid://17735868621")
v9("RepeatableWins", 25, {
    {
        ["Name"] = "Trophy",
        ["Weapon"] = "IsRandom",
        ["Quantity"] = 1
    }
}, "Win duels", "rbxassetid://17735868621")
v9("RepeatableStreak", 10, {
    {
        ["Name"] = "Fire",
        ["Weapon"] = "IsRandom",
        ["Quantity"] = 1
    }
}, "Win duels in a row", "rbxassetid://18151049137")
v9("RepeatableStreak2", 100, {
    {
        ["Name"] = "Blaze",
        ["Weapon"] = "IsRandom",
        ["Quantity"] = 1
    }
}, "Win duels in a row", "rbxassetid://18151049137")
v9("EventDuelRoundPlayed", 5, {
    {
        ["Name"] = "EventCurrency",
        ["Quantity"] = 3
    }
}, "Play rounds in a duel", "rbxassetid://17738769051")
v9("EventEliminations", 15, {
    {
        ["Name"] = "EventCurrency",
        ["Quantity"] = 4
    }
}, "Eliminations", "rbxassetid://17735857264")
v9("EventDuelWon", 1, {
    {
        ["Name"] = "EventCurrency",
        ["Quantity"] = 5
    }
}, "Win a duel", "rbxassetid://17735868621")
v9("SpecialChallenge1", 15, {
    {
        ["Name"] = "Key",
        ["Quantity"] = 5
    },
    {
        ["Name"] = "Jolly Chest",
        ["Quantity"] = 1,
        ["Weapon"] = "IsRandom"
    }
}, "Eliminate players in duels", "rbxassetid://101221631717761", "2024WinterSpotlight1")
v9("SpecialChallenge2", 100, {
    {
        ["Name"] = "Key",
        ["Quantity"] = 15
    },
    {
        ["Name"] = "Jolly Chest",
        ["Quantity"] = 3,
        ["Weapon"] = "IsRandom"
    },
    {
        ["Name"] = "Danger",
        ["Quantity"] = 1,
        ["Weapon"] = "IsUniversal"
    }
}, "Eliminate players in ???", "rbxassetid://112147813284051", "2024WinterSpotlight2")
v9("SpecialChallengeBridge1", 5, {
    {
        ["Name"] = "Key",
        ["Quantity"] = 3
    }
}, "Play duels on the Bridge map", "rbxassetid://17738769051")
v9("SpecialChallengeBridge2", 25, {
    {
        ["Name"] = "Bungeoppang",
        ["Quantity"] = 1,
        ["Weapon"] = "IsUniversal"
    }
}, "Eliminate players on the Bridge map", "rbxassetid://17735857264")
local function v16(p10, p11, p12)
    local v13 = {
        ["Milestone"] = p10,
        ["CanMultiplyRewards"] = p11,
        ["Rewards"] = typeof(p12) == "number" and ({
            {
                ["Name"] = "Key",
                ["Quantity"] = p12
            }
        } or p12) or p12
    }
    v_u_1.DailyTaskStreakRewards[p10] = v13
    local v14 = v_u_1
    local v15 = v_u_1.NUM_DAILY_TASK_STREAK_REWARD_MILESTONES
    v14.NUM_DAILY_TASK_STREAK_REWARD_MILESTONES = math.max(v15, p10)
end
v16(1, true, {
    {
        ["Name"] = "Charm Capsule",
        ["Quantity"] = 1,
        ["Weapon"] = "IsRandom"
    }
})
v16(2, true, {
    {
        ["Name"] = "Wrap Box",
        ["Quantity"] = 1,
        ["Weapon"] = "IsRandom"
    }
})
v16(3, true, {
    {
        ["Name"] = "Finisher Pack",
        ["Quantity"] = 1,
        ["Weapon"] = "IsRandom"
    }
})
v16(4, true, {
    {
        ["Name"] = "Wrap Box 2",
        ["Quantity"] = 1,
        ["Weapon"] = "IsRandom"
    }
})
v16(5, true, {
    {
        ["Name"] = "Finisher Pack 2",
        ["Quantity"] = 1,
        ["Weapon"] = "IsRandom"
    }
})
v16(6, true, {
    {
        ["Name"] = "Wrap Box 3",
        ["Quantity"] = 1,
        ["Weapon"] = "IsRandom"
    }
})
v16(7, false, {
    {
        ["Name"] = "Celestial",
        ["Quantity"] = 1,
        ["Weapon"] = "IsRandom"
    }
})
return v_u_1