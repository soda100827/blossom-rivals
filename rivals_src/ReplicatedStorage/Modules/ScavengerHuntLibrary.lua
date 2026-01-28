local v1 = {
    ["Info"] = {}
}
local v2 = {
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9"
}
local v3 = {
    ["AllowedInPrivateServers"] = false,
    ["Name"] = "JumpPad",
    ["Color"] = Color3.fromRGB(49, 210, 255),
    ["ObjectsName"] = "Jump Shard",
    ["ObjectsNamePlural"] = "Jump Shards",
    ["ObjectsImage"] = "rbxassetid://110601089716497",
    ["Objects"] = v2,
    ["NumObjects"] = #v2,
    ["RewardOnCompletion"] = true,
    ["Rewards"] = {
        {
            ["Name"] = "Jump Pad"
        }
    }
}
v1.Info.JumpPad = v3
return v1