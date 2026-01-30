local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = require(v1.Modules.CONSTANTS)
local v_u_3 = require(v1.Modules.CosmeticLibrary)
local v_u_4 = require(v1.Modules.ItemLibrary)
local v_u_5 = require(v1.Modules.ShopLibrary)
local v_u_6 = {}
v_u_6.__index = v_u_6
function v_u_6._new()
    local v7 = v_u_6
    local v8 = setmetatable({}, v7)
    v8:_Init()
    return v8
end
function v_u_6.GetCareerLevelsRewardMilestone(_)
    return 10
end
function v_u_6.GetCareerLevelsRewardData(_)
    return {
        ["Name"] = "Experience",
        ["Weapon"] = "IsRandom",
        ["Quantity"] = 1
    }
end
function v_u_6.GetCostToLevelUp(p9, p10, p11)
    local v12 = 10 * (1 - (not p11 and 0 or p11 / p9:GetXPRequiredToLevelUp(p10)))
    local v13 = math.floor(v12)
    return math.clamp(v13, 1, 10)
end
function v_u_6.GetCostToRefreshDailyShop(_, p14)
    local v15 = 3 * 2 ^ p14
    return math.min(24, v15)
end
function v_u_6.GetNextWeaponLevelReward(p16, p17, p18)
    for v19 = p17 + 1, 99 do
        local v20 = p16:GetWeaponLevelReward(v19, p18)
        if v20 then
            return v20, v19
        end
    end
end
function v_u_6.GetWeaponLevelReward(_, p21, p22)
    if p21 == 5 then
        return {
            ["Name"] = "Key",
            ["Quantity"] = 1
        }
    elseif p21 == 50 then
        return {
            ["Name"] = "White",
            ["Weapon"] = p22
        }
    elseif p21 == 99 then
        return {
            ["Name"] = "Black",
            ["Weapon"] = p22
        }
    elseif p21 % 10 ~= 0 then
        local _ = p21 % 5 == 0
    end
end
function v_u_6.GetXPRequiredToLevelUp(_, p23)
    local v24 = 5 + 4 * (p23 - 1) + (math.min(p23, 99) / 40) ^ 2 * 100
    local v25 = math.floor(v24)
    return math.max(50, v25)
end
function v_u_6.GetRecoverStreakCost(_, p26)
    local v27 = 5 * 2 ^ p26
    return math.clamp(v27, 1, 100)
end
function v_u_6.CanCosmeticBeEarnedRandomly(_, p28, p29, p30)
    local v31 = v_u_3.Cosmetics[p28]
    local v32 = v31.Type == "Skin" and { v31.ItemName } or v_u_5.OwnableWeapons
    for _, v33 in pairs(v32) do
        if (v31.Type ~= "Finisher" or v_u_4.Items[v33].CanEliminate) and ((p30[v33] or v_u_5:IsWeaponReleased(v33, v_u_2.WEAPON_EARLY_ACCESS_TIME_OFFSET)) and not v_u_3:OwnsCosmetic(p29, p28, v33)) then
            return true
        end
    end
end
function v_u_6.GetLootboxPossibilities(p_u_34, p_u_35, p_u_36, p_u_37, p38)
    local v_u_39 = p38 or "IsRandom"
    local v_u_40 = {}
    local v_u_41 = {}
    local v_u_42 = {}
    local function v_u_51(p43, p44)
        local v45 = v_u_3.Cosmetics[p43]
        if v45.Type == "Skin" and not (p_u_37[v45.ItemName] or v_u_5:IsWeaponReleased(v45.ItemName, v_u_2.WEAPON_EARLY_ACCESS_TIME_OFFSET)) then
            return
        else
            local v46 = not p44
            if v46 then
                v46 = not p_u_37[v45.ItemName]
            end
            if v46 then
                local v47 = v_u_41
                table.insert(v47, p43)
                return
            else
                local v48
                if v_u_39 == "IsRandom" then
                    v48 = not p_u_34:CanCosmeticBeEarnedRandomly(p43, p_u_36, p_u_37)
                elseif v_u_39 == "IsUniversal" then
                    v48 = v_u_3:OwnsCosmeticUniversally(p_u_36, p43)
                else
                    v48 = v_u_3:OwnsCosmetic(p_u_36, p43, v_u_39)
                end
                if v48 then
                    local v49 = v_u_42
                    table.insert(v49, p43)
                else
                    local v50 = v_u_40
                    table.insert(v50, p43)
                end
            end
        end
    end
    local function v57(p52)
        for _, v53 in pairs(p_u_35) do
            if v_u_3.Cosmetics[v53] then
                v_u_51(v53, p52)
            elseif v_u_3.Rewards[v53] then
                if v_u_3.Rewards[v53].Type == "Weapon" then
                    if p_u_37[v53] then
                        local v54 = v_u_42
                        table.insert(v54, v53)
                    else
                        local v55 = v_u_40
                        table.insert(v55, v53)
                    end
                else
                    local v56 = v_u_40
                    table.insert(v56, v53)
                end
            else
                assert(false, v53)
            end
        end
    end
    v57()
    local v58, v59
    if #v_u_40 == 0 then
        v_u_41 = {}
        v_u_42 = {}
        v57(true)
        v58 = v_u_42
        v59 = v_u_41
    else
        v58 = v_u_42
        v59 = v_u_41
    end
    return v_u_40, v59, v58
end
function v_u_6.GetRandomUnlockedWeapon(_, p60, p61, p62, p63)
    local v64 = {}
    for _, v65 in pairs(p60) do
        local v66 = v65.Name
        local v67
        if p62 then
            local v68 = v_u_3.Cosmetics[p62]
            v67 = not v_u_3:OwnsCosmetic(p63, p62, v66)
            local v69
            if v68.Type == "Skin" and v66 ~= v68.ItemName then
                v69 = true
            elseif v68.Type == "Finisher" then
                v69 = not v_u_4.Items[v66].CanEliminate
            else
                v69 = false
            end
            if v67 then
                v67 = not v69
            end
        else
            v67 = true
        end
        if v67 then
            local v70 = v65.Name
            table.insert(v64, v70)
        end
    end
    if #v64 > 0 then
        return v64[math.random(#v64)]
    end
    if not p61 then
        return nil
    end
    local v71 = {}
    for _, v72 in pairs(v_u_5:GetReleasedOwnableWeapons(v_u_2.WEAPON_EARLY_ACCESS_TIME_OFFSET)) do
        local v73
        if p62 then
            local v74 = v_u_3.Cosmetics[p62]
            v73 = not v_u_3:OwnsCosmetic(p63, p62, v72)
            local v75
            if v74.Type == "Skin" and v72 ~= v74.ItemName then
                v75 = true
            elseif v74.Type == "Finisher" then
                v75 = not v_u_4.Items[v72].CanEliminate
            else
                v75 = false
            end
            if v73 then
                v73 = not v75
            end
        else
            v73 = true
        end
        if v73 then
            table.insert(v71, v72)
        end
    end
    return #v71 > 0 and v71[math.random(#v71)] or nil
end
function v_u_6._Init(_) end
return v_u_6._new()