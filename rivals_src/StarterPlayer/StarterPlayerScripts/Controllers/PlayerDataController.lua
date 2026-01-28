local v_u_1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v_u_1:WaitForChild("Modules"):WaitForChild("EnumLibrary"))
local v_u_4 = require(v_u_1:WaitForChild("Modules"):WaitForChild("Signal"))
local v_u_5 = require(v2.LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("Modules"):WaitForChild("ClientReplicatedClasses"):WaitForChild("ClientPlayerData"))
local v6 = v_u_1:WaitForChild("Remotes"):WaitForChild("Data")
local v_u_7 = v6:WaitForChild("RequestPlayerData")
local v_u_8 = v6:WaitForChild("PlayerDataChanged")
local v_u_9 = v6:WaitForChild("PlayerDataAdded")
local v_u_10 = {}
v_u_10.__index = v_u_10
function v_u_10._new()
    local v11 = v_u_10
    local v12 = setmetatable({}, v11)
    v12.PlayerDataAdded = v_u_4.new()
    v12.StatisticsUpdated = v_u_4.new()
    v12.SettingsSliderChanged = v_u_4.new()
    v12.CurrentData = nil
    v12:_Init()
    return v12
end
function v_u_10.Get(p13, ...)
    return p13.CurrentData:Get(...)
end
function v_u_10.Set(p14, ...)
    return p14.CurrentData:Set(...)
end
function v_u_10.GetDataChangedSignal(p15, ...)
    return p15.CurrentData:GetDataChangedSignal(...)
end
function v_u_10.IsNosniyGamesTeamMember(p16, ...)
    return require(v_u_1.Modules.PlayerDataUtility):IsNosniyGamesTeamMember(p16, ...)
end
function v_u_10.GetWeaponData(p17, ...)
    return require(v_u_1.Modules.PlayerDataUtility):GetWeaponData(p17, ...)
end
function v_u_10.HasGamepass(p18, ...)
    return require(v_u_1.Modules.PlayerDataUtility):HasGamepass(p18, ...)
end
function v_u_10.GetStatistic(p19, ...)
    return require(v_u_1.Modules.PlayerDataUtility):GetStatistic(p19, ...)
end
function v_u_10.GetDirectoryStatistic(p20, ...)
    return require(v_u_1.Modules.PlayerDataUtility):GetDirectoryStatistic(p20, ...)
end
function v_u_10.GetWeaponStatistic(p21, ...)
    return require(v_u_1.Modules.PlayerDataUtility):GetWeaponStatistic(p21, ...)
end
function v_u_10.GetMapStatistic(p22, ...)
    return require(v_u_1.Modules.PlayerDataUtility):GetMapStatistic(p22, ...)
end
function v_u_10.GetUnlockedWeapons(p23, ...)
    return require(v_u_1.Modules.PlayerDataUtility):GetUnlockedWeapons(p23, ...)
end
function v_u_10.AreTasksCompleted(p24, ...)
    return require(v_u_1.Modules.PlayerDataUtility):AreTasksCompleted(p24, ...)
end
function v_u_10.GetFavoritedWeapons(p25)
    local v26 = {}
    for _, v27 in pairs(p25:Get("WeaponInventory")) do
        if v27.IsFavorited then
            v26[v27.Name] = true
        end
    end
    return v26
end
function v_u_10.OwnsAllWeapons(p28, p29, p30, p31)
    local v32 = require(v_u_1.Modules.ItemLibrary)
    local v33 = require(v_u_1.Modules.ShopLibrary)
    local v34 = 0
    local v35 = 0
    for _, v36 in pairs(v33:GetReleasedOwnableWeapons()) do
        if (not p29 or v32.Items[v36].Status == p29) and ((not p31 or v33:IsWeaponReleased(v36)) and (not p30 or v33.Weapons[v36].KeyPrice)) then
            v34 = v34 + 1
        end
    end
    for _, v37 in pairs(p28:Get("WeaponInventory")) do
        if not p29 or v32.Items[v37.Name].Status == p29 then
            local v38 = not p31 or v33:IsWeaponReleased(v37.Name)
            local v39 = (p30 and true or false) and v33.Weapons[v37.Name]
            if v39 then
                v39 = v33.Weapons[v37.Name].KeyPrice
            end
            if v38 and v39 then
                v35 = v35 + 1
            end
        end
    end
    return v34 <= v35
end
function v_u_10.GetNumTasksCompleted(p40, p41)
    local v42 = 0
    for _, v43 in pairs(p40:Get(p41 or "Tasks")) do
        if v43.Completed then
            v42 = v42 + 1
        end
    end
    return v42
end
function v_u_10.IsEmoteEquipped(p44, p45)
    for _, v46 in pairs(p44:Get("EquippedEmotes")) do
        if v46.Name == p45 then
            return true
        end
    end
end
function v_u_10.SilenceCosmeticNotification(p47, p48, p49)
    if p48 then
        local v50 = p47:Get("CosmeticNotifications")
        if p49 then
            local v51 = v50[p48]
            if typeof(v51) == "table" then
                v50[p48][p49] = nil
                p47.CurrentData:Replicate("CosmeticNotifications")
                v_u_1.Remotes.Data.SilenceCosmeticNotification:FireServer(p48, p49)
            end
        else
            v50[p48] = nil
            p47.CurrentData:Replicate("CosmeticNotifications")
            v_u_1.Remotes.Data.SilenceCosmeticNotification:FireServer(p48, nil)
        end
    else
        p47.CurrentData:SetReplicate("CosmeticNotifications", {})
        v_u_1.Remotes.Data.SilenceCosmeticNotification:FireServer(nil, nil)
        return
    end
end
function v_u_10.WaitUntilLoaded(p52)
    if not p52.CurrentData then
        p52.PlayerDataAdded:Wait()
    end
end
function v_u_10._PlayerDataChanged(p53, p54, ...)
    local v55 = p53.CurrentData
    if not v55 then
        return
    end
    v_u_3:WaitForEnumBuilder()
    local v56 = v_u_3:FromEnum(p54) or p54
    if v56 == "DataValueChanged" then
        v55:SetReplicate(...)
        return
    end
    if v56 == "BulkDataValueChanged" then
        for _, v57 in pairs((...)) do
            v55:SetReplicate(v57[1], v57[2])
        end
        return
    end
    if v56 == "StatisticsBatchUpdate" then
        local v58 = require(v_u_1.Modules.StatisticsLibrary)
        local v59 = ...
        for v60, v61 in pairs(v59[utf8.char(0)] or {}) do
            v55:Set(v55:FromEnum(v60), v61)
        end
        for v62, v63 in pairs(v58.STATISTICS_DIRECTORY_INFO) do
            local v64, _ = table.unpack(v63)
            local v65 = p53:Get(v64)
            for v66, v67 in pairs(v59[utf8.char(0 + v62)] or {}) do
                local v68 = v55:FromEnum(v66)
                v65[v68] = v65[v68] or {}
                for v69, v70 in pairs(v67) do
                    v65[v68][v55:FromEnum(v69)] = v70
                end
            end
        end
        p53.StatisticsUpdated:Fire()
        return
    end
    if v56 ~= "WeaponDataChanged" then
        if v56 == "BatchUpdateWeaponXP" then
            local v71 = false
            for _, v72 in pairs((...)) do
                local v73 = p53:GetWeaponData(v55:FromEnum(v72[utf8.char(0)]))
                if v73 then
                    v73.Level = v72[utf8.char(1)]
                    v73.XP = v72[utf8.char(2)]
                    v71 = true
                end
            end
            if v71 then
                v55:Replicate("WeaponInventory")
                return
            end
        else
            v55:ReplicateFromServer(v56, ...)
        end
        return
    end
    local v74 = v55:Get("WeaponInventory")
    local v75 = ...
    for v76, v77 in pairs(v74) do
        if v77.Name == v75.Name then
            v74[v76] = v75
            break
        end
    end
    v55:Replicate("WeaponInventory")
end
function v_u_10._CreatePlayerData(p78, p79)
    local v80 = typeof(p79) == "table"
    local v81 = "Argument 1 invalid, expected a table, got " .. tostring(p79)
    assert(v80, v81)
    local v82 = v_u_5.new(p79)
    p78.CurrentData = v82
    p78.PlayerDataAdded:Fire(v82)
end
function v_u_10._RequestPlayerData(p83)
    local v84 = v_u_7:InvokeServer()
    if v84 then
        p83:_CreatePlayerData(v84)
    end
end
function v_u_10._Init(p_u_85)
    v_u_8.OnClientEvent:Connect(function(...)
        p_u_85:_PlayerDataChanged(...)
    end)
    v_u_9.OnClientEvent:Connect(function(...)
        p_u_85:_CreatePlayerData(...)
    end)
    task.spawn(p_u_85._RequestPlayerData, p_u_85)
end
return v_u_10._new()