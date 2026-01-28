local v_u_1 = {
    ["FootstepSounds"] = {
        ["Default"] = { "rbxassetid://16621776051", "rbxassetid://16621776521" },
        ["Climbing"] = { "rbxassetid://18222266749", "rbxassetid://18222266999", "rbxassetid://18222266464" },
        ["Stomping"] = { "rbxassetid://111711853822950" },
        ["Grass"] = { "rbxassetid://16598817576", "rbxassetid://16598817760" },
        ["LeafyGrass"] = { "rbxassetid://16604463729", "rbxassetid://16598888371", "rbxassetid://16598887984" },
        ["Wood"] = { "rbxassetid://16598817344", "rbxassetid://16598817050" },
        ["Snow"] = { "rbxassetid://120787301888419", "rbxassetid://120787301888419" },
        ["Concrete"] = { "rbxassetid://16614076829", "rbxassetid://16614077242" },
        ["Metal"] = { "rbxassetid://16600019660", "rbxassetid://16600019248" },
        ["Pebble"] = { "rbxassetid://16600018760", "rbxassetid://16600018511" },
        ["Mud"] = { "rbxassetid://113106858242537", "rbxassetid://92366631281116" },
        ["Fabric"] = { "rbxassetid://16621776149", "rbxassetid://16621776381" },
        ["Sand"] = { "rbxassetid://16639468191", "rbxassetid://16639468533" },
        ["DiamondPlate"] = "Metal",
        ["WoodPlanks"] = "Wood",
        ["Salt"] = "Pebble",
        ["Ground"] = "Mud",
        ["Slate"] = "Concrete",
        ["Brick"] = "Concrete"
    },
    ["EquipSounds"] = { "rbxassetid://13158735106", "rbxassetid://13158734943", "rbxassetid://13158735037" },
    ["EnemyDeathSounds"] = {
        "rbxassetid://9276932564",
        "rbxassetid://9276932474",
        "rbxassetid://9276932416",
        "rbxassetid://9276932370",
        "rbxassetid://9276932285"
    },
    ["EliminationSounds"] = { "rbxassetid://16530229616", "rbxassetid://16530229541", "rbxassetid://16530229695" },
    ["ViewModelSounds"] = require(script:WaitForChild("ViewModelSounds")),
    ["ItemSounds"] = require(script:WaitForChild("ItemSounds")),
    ["AnimationSounds"] = {}
}
v_u_1.AlwaysPreload = {
    v_u_1.EquipSounds,
    v_u_1.EliminationSounds,
    {
        "rbxassetid://16537449730",
        "rbxassetid://16537337310",
        "rbxassetid://13110130082",
        "rbxassetid://13455969017",
        "rbxassetid://13949557844",
        "rbxassetid://13949557885",
        "rbxassetid://13087319223",
        "rbxassetid://13159969353",
        "rbxassetid://16540273321",
        "rbxassetid://13702989275",
        "rbxassetid://14441658101",
        "rbxassetid://16736552001",
        "rbxassetid://16736552098",
        "rbxassetid://16737738355",
        "rbxassetid://16737738420",
        "rbxassetid://16770456156",
        "rbxassetid://17662575175",
        "rbxassetid://17662574898",
        "rbxassetid://17662623697",
        "rbxassetid://17826470563",
        "rbxassetid://17826390328",
        "rbxassetid://17662575024"
    }
}
function v_u_1.PreloadSounds(_, p2, p3, ...)
    local v4 = {}
    for _, v5 in pairs({
        p2 or {},
        { ... }
    }) do
        for _, v6 in pairs(v5) do
            local v7 = Instance.new("Sound")
            v7.Volume = 0
            v7.Looped = true
            v7.SoundId = v6
            v7.Parent = script
            v7:Play()
            table.insert(v4, v7)
            if p3 then
                table.insert(p3, v7)
            end
        end
    end
    return v4
end
(function()
    for v8, v9 in pairs(require(script:WaitForChild("ScrapedAnimationSounds"))) do
        v_u_1.AnimationSounds[v8] = v_u_1.AnimationSounds[v8] or {}
        for _, v10 in pairs(v9) do
            local v11 = v_u_1.AnimationSounds[v8]
            table.insert(v11, v10)
        end
    end
end)()
return v_u_1