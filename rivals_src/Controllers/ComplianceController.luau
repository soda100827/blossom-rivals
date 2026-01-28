-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/brNTY8nX8t)
-- Decompiled on 2026-01-28 07:19:42
-- Luau version 6, Types version 3
-- Time taken: 0.014191 seconds

local Players_upvr = game:GetService("Players")
local module_upvr_2 = require(Players_upvr.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController"))
local module_upvr = {}
module_upvr.__index = module_upvr
function module_upvr._new() -- Line 13
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local setmetatable_result1 = setmetatable({}, module_upvr)
	setmetatable_result1._is_fetching_user_info = {}
	setmetatable_result1._user_info_cache = {}
	setmetatable_result1:_Init()
	return setmetatable_result1
end
function module_upvr.IsChina(arg1, arg2) -- Line 28
	--[[ Upvalues[1]:
		[1]: module_upvr_2 (readonly)
	]]
	local var5 = arg2
	if not var5 then
		var5 = module_upvr_2:Get("PolicyInfo")
	end
	local var6 = not var5
	if not var6 then
		var6 = var5.IsSubjectToChinaPolicies
	end
	return var6
end
function module_upvr.IsExternalReferencesAllowed(arg1, arg2) -- Line 34
	--[[ Upvalues[1]:
		[1]: module_upvr_2 (readonly)
	]]
	local any_Get_result1 = module_upvr_2:Get("PolicyInfo")
	local var10 = any_Get_result1
	if var10 then
		var10 = not arg1:IsChina()
		if var10 then
			var10 = table.find(any_Get_result1.AllowedExternalLinkReferences, arg2 or "YouTube")
		end
	end
	return var10
end
function module_upvr.ArePaidRandomItemsRestricted(arg1, arg2) -- Line 40
	--[[ Upvalues[1]:
		[1]: module_upvr_2 (readonly)
	]]
	local var13 = arg2
	if not var13 then
		var13 = module_upvr_2:Get("PolicyInfo")
	end
	local var14 = not var13
	if not var14 then
		var14 = var13.ArePaidRandomItemsRestricted
		if not var14 then
			var14 = arg1:IsChina(var13)
		end
	end
	return var14
end
function module_upvr.IsPaidItemTradingAllowed(arg1) -- Line 46
	--[[ Upvalues[1]:
		[1]: module_upvr_2 (readonly)
	]]
	local any_Get_result1_2 = module_upvr_2:Get("PolicyInfo")
	local var16 = any_Get_result1_2
	if var16 then
		var16 = any_Get_result1_2.IsPaidItemTradingAllowed
	end
	return var16
end
function module_upvr.UserIDsAllowed(arg1) -- Line 52
	return not arg1:IsChina()
end
function module_upvr.UsernamesAllowed(arg1) -- Line 56
	return not arg1:IsChina()
end
function module_upvr.UseDisplayNames(arg1) -- Line 60
	return true
end
local Utility_upvr = require(game:GetService("ReplicatedStorage").Modules.Utility)
function module_upvr.GetName(arg1, arg2) -- Line 65
	--[[ Upvalues[1]:
		[1]: Utility_upvr (readonly)
	]]
	local var18
	local function INLINED() -- Internal function, doesn't exist in bytecode
		var18 = arg2.DisplayName
		return var18
	end
	if not arg1:UseDisplayNames() or not INLINED() then
		var18 = arg2.Name
	end
	return Utility_upvr:GetName(arg2, var18)
end
function module_upvr.GetUserInfos(arg1, arg2, arg3) -- Line 69
	if not arg3 then
		return arg1:_GetUserInfos(arg2)
	end
	for i, v in pairs(arg2) do
		if i <= arg3 then
			table.insert({}, v)
		else
			table.insert({}, v)
		end
	end
	local tbl = {}
	-- KONSTANTERROR: Expression was reused, decompilation is incorrect
	tbl[1] = {}
	-- KONSTANTERROR: Expression was reused, decompilation is incorrect
	tbl[2] = {}
	for _, v_2 in pairs(tbl) do
		for i_3, v_3 in pairs(arg1:_GetUserInfos(v_2)) do
			({})[i_3] = v_3
			local var41
		end
	end
	return var41
end
local UserService_upvr = game:GetService("UserService")
function module_upvr._GetUserInfos(arg1, arg2) -- Line 101
	--[[ Upvalues[1]:
		[1]: UserService_upvr (readonly)
	]]
	local tbl_2 = {}
	for _, v_4 in pairs(arg2) do
		if not arg1._user_info_cache[tostring(v_4)] and not arg1._is_fetching_user_info[tostring(v_4)] then
			table.insert(tbl_2, v_4)
		end
	end
	for _, v_5 in pairs(tbl_2) do
		arg1._is_fetching_user_info[tostring(v_5)] = true
	end
	local pcall_result1, pcall_result2_2 = pcall(UserService_upvr.GetUserInfosByUserIdsAsync, UserService_upvr, tbl_2)
	for _, v_6 in pairs(tbl_2) do
		arg1._is_fetching_user_info[tostring(v_6)] = nil
	end
	if not pcall_result1 then
		return {}
	end
	for _, v_7 in pairs(pcall_result2_2) do
		arg1._user_info_cache[tostring(v_7.Id)] = v_7
	end
	for _, v_8 in pairs(arg2) do
		({})[tostring(v_8)] = arg1._user_info_cache[tostring(v_8)] or nil
		local var86
	end
	for _, v_9 in pairs(pcall_result2_2) do
		var86[tostring(v_9.Id)] = v_9
	end
	return var86
end
function module_upvr._BlacklistedObject(arg1, arg2) -- Line 152
	if arg1._country_code == arg2:GetAttribute("CountryCode") then
		task.defer(arg2.Destroy, arg2)
	end
end
function module_upvr._WhitelistedObject(arg1, arg2) -- Line 158
	if arg1._country_code ~= arg2:GetAttribute("CountryCode") then
		task.defer(arg2.Destroy, arg2)
	end
end
local LocalizationService_upvr = game:GetService("LocalizationService")
local CollectionService_upvr = game:GetService("CollectionService")
function module_upvr._SetupLocaleObjects(arg1) -- Line 164
	--[[ Upvalues[3]:
		[1]: LocalizationService_upvr (readonly)
		[2]: Players_upvr (readonly)
		[3]: CollectionService_upvr (readonly)
	]]
	local pcall_result1_2, pcall_result2 = pcall(
		LocalizationService_upvr.GetCountryRegionForPlayerAsync,
		LocalizationService_upvr,
		Players_upvr.LocalPlayer
	)
	if pcall_result1_2 then
		arg1._country_code = pcall_result2
	else
		warn("Failed to fetch country code, error:", pcall_result2)
	end
	CollectionService_upvr:GetInstanceAddedSignal("RegionHideThisObject"):Connect(function(arg1_2) -- Line 173
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1:_BlacklistedObject(arg1_2)
	end)
	CollectionService_upvr:GetInstanceAddedSignal("RegionShowThisObject"):Connect(function(arg1_3) -- Line 177
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1:_WhitelistedObject(arg1_3)
	end)
	for _, v_10 in pairs(CollectionService_upvr:GetTagged("RegionHideThisObject")) do
		task.defer(arg1._BlacklistedObject, arg1, v_10)
	end
	for _, v_11 in pairs(CollectionService_upvr:GetTagged("RegionShowThisObject")) do
		task.defer(arg1._WhitelistedObject, arg1, v_11)
	end
end
function module_upvr._Init(arg1) -- Line 190
	task.defer(arg1._SetupLocaleObjects, arg1)
end
return module_upvr._new()
