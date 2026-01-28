local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("UserService")
local v_u_3 = require(v1.Modules.CosmeticLibrary)
local v_u_4 = require(v1.Modules.Utility)
local v_u_5 = {
    ["Players"] = {},
    ["Rewards"] = {}
}
local function v11(p6, p7, p8)
    local v9 = {
        ["EliminationReward"] = p7,
        ["WinReward"] = p8
    }
    v_u_5.Players[tostring(p6)] = v9
    if v9.EliminationReward then
        local v10 = p6 == 324386852 and v_u_4:IsAprilFools() and "spell mud backwards" or nil
        v_u_5.Rewards[v9.EliminationReward] = true
        v_u_3.Cosmetics[v9.EliminationReward].Description = v10 or string.format("Earned by eliminating @%s with a weapon", "\226\128\162 \226\128\162 \226\128\162")
        v_u_3.Cosmetics[v9.EliminationReward].DescriptionSpecific = v10 or string.format("Earned by eliminating @%s with this weapon", "\226\128\162 \226\128\162 \226\128\162")
    end
    if v9.WinReward then
        v_u_5.Rewards[v9.WinReward] = true
        v_u_3.Cosmetics[v9.WinReward].Description = string.format("Earned by winning with or against @%s", "\226\128\162 \226\128\162 \226\128\162")
    end
end
v11(15941965, "SenseiWarrior", "Sensite")
v11(20349956, "Nosniy", "Nosnite")
v11(780350915, "nekoanims", "Nekore")
v11(13108868, "ShadowTrojan", "Shadore")
v11(1730213868, "Brian1KB", "Brianore")
v11(8034104, "GreatGuyBoom", "Boomore")
v11(42477697, "D_reamz", nil)
v11(266340204, "Blizmid")
v11(487532097, "CarbonMeister")
v11(964088769, "DV")
v11(64516, "Bandites")
v11(84743203, "TanqR")
v11(301707243, "BobbVX")
v11(341006533, "oPixel")
v11(52392831, "MiniBloxia")
v11(72777686, "enriquebruv")
v11(15315966, "hoppy819")
v11(2528007458, "Chex")
v11(264355696, "Hoopie")
v11(4891355965, "Kaye")
v11(103070346, "Karful")
v11(19737278, "Khayri")
v11(68729698, "viecti")
v11(18394211, "SharkTactics")
v11(1010680683, "Applino")
v11(172669397, "8sty")
v11(1212564846, "atorix")
v11(3410760577, "philhood")
v11(324386852, "Mud")
v11(527669241, "KaiM")
v11(121130556, "Darktru")
task.defer(function()
    local v12 = {}
    for v13 in pairs(v_u_5.Players) do
        local v14 = tonumber(v13)
        table.insert(v12, v14)
    end
    local v15, v16 = pcall(v_u_2.GetUserInfosByUserIdsAsync, v_u_2, v12)
    if v15 then
        for _, v17 in pairs(v16) do
            local v18 = v_u_5.Players
            local v19 = v17.Id
            local v20 = v18[tostring(v19)]
            if v20 then
                if v20.EliminationReward then
                    v_u_3.Cosmetics[v20.EliminationReward].Description = string.format("Earned by eliminating @%s with a weapon", v17.Username)
                    v_u_3.Cosmetics[v20.EliminationReward].DescriptionSpecific = string.format("Earned by eliminating @%s with this weapon", v17.Username)
                end
                if v20.WinReward then
                    v_u_3.Cosmetics[v20.WinReward].Description = string.format("Earned by winning with or against @%s", v17.Username)
                end
            end
        end
    else
        warn("Failed to fetch user infos:", v16, v12)
    end
end)
return v_u_5