local v_u_1 = game:GetService("LocalizationService")
local v2 = game:GetService("ReplicatedStorage")
local v_u_3 = game:GetService("CollectionService")
local v_u_4 = game:GetService("UserService")
local v_u_5 = game:GetService("Players")
local v_u_6 = require(v2.Modules.Utility)
local v_u_7 = require(v_u_5.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController"))
local v_u_8 = {}
v_u_8.__index = v_u_8
function v_u_8._new()
    local v9 = v_u_8
    local v10 = setmetatable({}, v9)
    v10._is_fetching_user_info = {}
    v10._user_info_cache = {}
    v10:_Init()
    return v10
end
function v_u_8.IsChina(_, p11)
    local v12 = p11 or v_u_7:Get("PolicyInfo")
    return not v12 or v12.IsSubjectToChinaPolicies
end
function v_u_8.IsExternalReferencesAllowed(p13, p14)
    local v15 = v_u_7:Get("PolicyInfo")
    local v16 = v15 and not p13:IsChina()
    if v16 then
        v16 = table.find(v15.AllowedExternalLinkReferences, p14 or "YouTube")
    end
    return v16
end
function v_u_8.ArePaidRandomItemsRestricted(p17, p18)
    local v19 = p18 or v_u_7:Get("PolicyInfo")
    return not v19 or (v19.ArePaidRandomItemsRestricted or p17:IsChina(v19))
end
function v_u_8.IsPaidItemTradingAllowed(_)
    local v20 = v_u_7:Get("PolicyInfo")
    if v20 then
        v20 = v20.IsPaidItemTradingAllowed
    end
    return v20
end
function v_u_8.UserIDsAllowed(p21)
    return not p21:IsChina()
end
function v_u_8.UsernamesAllowed(p22)
    return not p22:IsChina()
end
function v_u_8.UseDisplayNames(_)
    return true
end
function v_u_8.GetName(p23, p24)
    return v_u_6:GetName(p24, p23:UseDisplayNames() and p24.DisplayName or p24.Name)
end
function v_u_8.GetUserInfos(p25, p26, p27)
    if not p27 then
        return p25:_GetUserInfos(p26)
    end
    local v28 = {}
    local v29 = {}
    for v30, v31 in pairs(p26) do
        if v30 <= p27 then
            table.insert(v28, v31)
        else
            table.insert(v29, v31)
        end
    end
    local v32 = {}
    for _, v33 in pairs({ v28, v29 }) do
        for v34, v35 in pairs(p25:_GetUserInfos(v33)) do
            v32[v34] = v35
        end
    end
    return v32
end
function v_u_8._GetUserInfos(p36, p37)
    local v38 = {}
    for _, v39 in pairs(p37) do
        if not (p36._user_info_cache[tostring(v39)] or p36._is_fetching_user_info[tostring(v39)]) then
            table.insert(v38, v39)
        end
    end
    for _, v40 in pairs(v38) do
        p36._is_fetching_user_info[tostring(v40)] = true
    end
    local v41, v42 = pcall(v_u_4.GetUserInfosByUserIdsAsync, v_u_4, v38)
    for _, v43 in pairs(v38) do
        p36._is_fetching_user_info[tostring(v43)] = nil
    end
    if not v41 then
        return {}
    end
    for _, v44 in pairs(v42) do
        local v45 = p36._user_info_cache
        local v46 = v44.Id
        v45[tostring(v46)] = v44
    end
    local v47 = {}
    for _, v48 in pairs(p37) do
        v47[tostring(v48)] = p36._user_info_cache[tostring(v48)] or nil
    end
    for _, v49 in pairs(v42) do
        local v50 = v49.Id
        v47[tostring(v50)] = v49
    end
    return v47
end
function v_u_8._BlacklistedObject(p51, p52)
    if p51._country_code == p52:GetAttribute("CountryCode") then
        task.defer(p52.Destroy, p52)
    end
end
function v_u_8._WhitelistedObject(p53, p54)
    if p53._country_code ~= p54:GetAttribute("CountryCode") then
        task.defer(p54.Destroy, p54)
    end
end
function v_u_8._SetupLocaleObjects(p_u_55)
    local v56, v57 = pcall(v_u_1.GetCountryRegionForPlayerAsync, v_u_1, v_u_5.LocalPlayer)
    if v56 then
        p_u_55._country_code = v57
    else
        warn("Failed to fetch country code, error:", v57)
    end
    v_u_3:GetInstanceAddedSignal("RegionHideThisObject"):Connect(function(p58)
        p_u_55:_BlacklistedObject(p58)
    end)
    v_u_3:GetInstanceAddedSignal("RegionShowThisObject"):Connect(function(p59)
        p_u_55:_WhitelistedObject(p59)
    end)
    for _, v60 in pairs(v_u_3:GetTagged("RegionHideThisObject")) do
        task.defer(p_u_55._BlacklistedObject, p_u_55, v60)
    end
    for _, v61 in pairs(v_u_3:GetTagged("RegionShowThisObject")) do
        task.defer(p_u_55._WhitelistedObject, p_u_55, v61)
    end
end
function v_u_8._Init(p62)
    task.defer(p62._SetupLocaleObjects, p62)
end
return v_u_8._new()