local v1 = game:GetService("ReplicatedStorage")
local v2 = require(v1.Modules.CONSTANTS)
local v_u_3 = require(v1.Modules.ServerOsTime)
local v_u_4 = require(v1.Modules.Utility)
local v_u_5 = {
    {
        ["Name"] = "Jolly Chest",
        ["Quantity"] = 1,
        ["Weapon"] = "IsRandom"
    }
}
local v_u_11 = {
    ["IS_ACTIVE"] = true,
    ["VERSION"] = 3,
    ["START_TIME"] = not v2.IS_STUDIO and 1765515600 or os.time(),
    ["Rewards"] = {},
    ["NumRewards"] = 0,
    ["GetTimeUntilRefresh"] = function(_)
        local v6 = v_u_3:GetRounded() / 86400
        return math.ceil(v6) * 86400 - v_u_3:GetRounded()
    end,
    ["GetReward"] = function(_, p7)
        local v8 = (v_u_3:Get() - v_u_11.START_TIME) / 86400
        local v9 = math.floor(v8) + 1 + (p7 or 0)
        for _, v10 in pairs(v_u_11.Rewards) do
            if v10.Day == v9 then
                return v10, v9
            end
        end
    end
}
local function v18(...)
    local v12 = v_u_11.NumRewards + 1
    local v13 = { ... }
    for _, v14 in pairs(v_u_5 or {}) do
        local v15 = v_u_4
        table.insert(v13, v15:CloneTable(v14))
    end
    local v16 = {
        ["Day"] = v12,
        ["StartTime"] = v_u_11.START_TIME + (v12 - 1) * 86400,
        ["Rewards"] = v13
    }
    v_u_11.Rewards[v12] = v16
    local v17 = v_u_11
    v17.NumRewards = v17.NumRewards + 1
end
v18({
    ["Name"] = "Festive Wrap Box 2",
    ["Weapon"] = "IsRandom",
    ["Quantity"] = 1
})
v18({
    ["Name"] = "EventCurrency",
    ["Quantity"] = 50
})
v18({
    ["Name"] = "Festive Wrap Box 2",
    ["Weapon"] = "IsRandom",
    ["Quantity"] = 2
})
v18({
    ["Name"] = "Key",
    ["Quantity"] = 3
})
v18({
    ["Name"] = "Festive Wrap Box 2",
    ["Weapon"] = "IsRandom",
    ["Quantity"] = 3
})
v18({
    ["Name"] = "EventCurrency",
    ["Quantity"] = 100
})
v18({
    ["Name"] = "Key",
    ["Quantity"] = 3
})
v18({
    ["Name"] = "EventCurrency",
    ["Quantity"] = 150
})
v18({
    ["Name"] = "Fireplace",
    ["Weapon"] = "IsUniversal"
})
v18({
    ["Name"] = "Key",
    ["Quantity"] = 3
})
v18({
    ["Name"] = "Jolly Chest",
    ["Weapon"] = "IsRandom",
    ["Quantity"] = 2
})
v18({
    ["Name"] = "EventCurrency",
    ["Quantity"] = 200
})
v18({
    ["Name"] = "Snowy Night",
    ["Weapon"] = "IsUniversal"
})
v18({
    ["Name"] = "Festive Skin Case",
    ["Weapon"] = "IsRandom",
    ["Quantity"] = 1
})
v18({
    ["Name"] = "Jolly Chest",
    ["Weapon"] = "IsRandom",
    ["Quantity"] = 3
})
v18({
    ["Name"] = "EventCurrency",
    ["Quantity"] = 250
})
v18({
    ["Name"] = "Elfify",
    ["Weapon"] = "IsUniversal"
})
v18({
    ["Name"] = "Key",
    ["Quantity"] = 3
})
v18({
    ["Name"] = "EventCurrency",
    ["Quantity"] = 300
})
v18({
    ["Name"] = "Key",
    ["Quantity"] = 4
})
v18({
    ["Name"] = "Standard Weapon Crate",
    ["Quantity"] = 1
})
return v_u_11