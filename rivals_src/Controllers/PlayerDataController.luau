-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/brNTY8nX8t)
-- Decompiled on 2026-01-28 07:30:00
-- Luau version 6, Types version 3
-- Time taken: 0.022112 seconds

local ReplicatedStorage_upvr = game:GetService("ReplicatedStorage")
local Data = ReplicatedStorage_upvr:WaitForChild("Remotes"):WaitForChild("Data")
local module_upvr_2 = {}
module_upvr_2.__index = module_upvr_2
local module_upvr = require(ReplicatedStorage_upvr:WaitForChild("Modules"):WaitForChild("Signal"))
function module_upvr_2._new() -- Line 16
	--[[ Upvalues[2]:
		[1]: module_upvr_2 (readonly)
		[2]: module_upvr (readonly)
	]]
	local setmetatable_result1 = setmetatable({}, module_upvr_2)
	setmetatable_result1.PlayerDataAdded = module_upvr.new()
	setmetatable_result1.StatisticsUpdated = module_upvr.new()
	setmetatable_result1.SettingsSliderChanged = module_upvr.new()
	setmetatable_result1.CurrentData = nil
	setmetatable_result1:_Init()
	return setmetatable_result1
end
function module_upvr_2.Get(arg1, ...) -- Line 34
	return arg1.CurrentData:Get(...)
end
function module_upvr_2.Set(arg1, ...) -- Line 38
	return arg1.CurrentData:Set(...)
end
function module_upvr_2.GetDataChangedSignal(arg1, ...) -- Line 42
	return arg1.CurrentData:GetDataChangedSignal(...)
end
function module_upvr_2.IsNosniyGamesTeamMember(arg1, ...) -- Line 46
	--[[ Upvalues[1]:
		[1]: ReplicatedStorage_upvr (readonly)
	]]
	return require(ReplicatedStorage_upvr.Modules.PlayerDataUtility):IsNosniyGamesTeamMember(arg1, ...)
end
function module_upvr_2.GetWeaponData(arg1, ...) -- Line 51
	--[[ Upvalues[1]:
		[1]: ReplicatedStorage_upvr (readonly)
	]]
	return require(ReplicatedStorage_upvr.Modules.PlayerDataUtility):GetWeaponData(arg1, ...)
end
function module_upvr_2.HasGamepass(arg1, ...) -- Line 56
	--[[ Upvalues[1]:
		[1]: ReplicatedStorage_upvr (readonly)
	]]
	return require(ReplicatedStorage_upvr.Modules.PlayerDataUtility):HasGamepass(arg1, ...)
end
function module_upvr_2.GetStatistic(arg1, ...) -- Line 61
	--[[ Upvalues[1]:
		[1]: ReplicatedStorage_upvr (readonly)
	]]
	return require(ReplicatedStorage_upvr.Modules.PlayerDataUtility):GetStatistic(arg1, ...)
end
function module_upvr_2.GetDirectoryStatistic(arg1, ...) -- Line 66
	--[[ Upvalues[1]:
		[1]: ReplicatedStorage_upvr (readonly)
	]]
	return require(ReplicatedStorage_upvr.Modules.PlayerDataUtility):GetDirectoryStatistic(arg1, ...)
end
function module_upvr_2.GetWeaponStatistic(arg1, ...) -- Line 71
	--[[ Upvalues[1]:
		[1]: ReplicatedStorage_upvr (readonly)
	]]
	return require(ReplicatedStorage_upvr.Modules.PlayerDataUtility):GetWeaponStatistic(arg1, ...)
end
function module_upvr_2.GetMapStatistic(arg1, ...) -- Line 76
	--[[ Upvalues[1]:
		[1]: ReplicatedStorage_upvr (readonly)
	]]
	return require(ReplicatedStorage_upvr.Modules.PlayerDataUtility):GetMapStatistic(arg1, ...)
end
function module_upvr_2.GetUnlockedWeapons(arg1, ...) -- Line 81
	--[[ Upvalues[1]:
		[1]: ReplicatedStorage_upvr (readonly)
	]]
	return require(ReplicatedStorage_upvr.Modules.PlayerDataUtility):GetUnlockedWeapons(arg1, ...)
end
function module_upvr_2.AreTasksCompleted(arg1, ...) -- Line 86
	--[[ Upvalues[1]:
		[1]: ReplicatedStorage_upvr (readonly)
	]]
	return require(ReplicatedStorage_upvr.Modules.PlayerDataUtility):AreTasksCompleted(arg1, ...)
end
function module_upvr_2.GetFavoritedWeapons(arg1) -- Line 91
	for _, v in pairs(arg1:Get("WeaponInventory")) do
		if v.IsFavorited then
			({})[v.Name] = true
		end
	end
	-- KONSTANTERROR: Expression was reused, decompilation is incorrect
	return {}
end
function module_upvr_2.OwnsAllWeapons(arg1, arg2, arg3, arg4) -- Line 103
	--[[ Upvalues[1]:
		[1]: ReplicatedStorage_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local ItemLibrary_2 = require(ReplicatedStorage_upvr.Modules.ItemLibrary)
	local ShopLibrary_2 = require(ReplicatedStorage_upvr.Modules.ShopLibrary)
	local _
	for _, v_2 in pairs(ShopLibrary_2:GetReleasedOwnableWeapons()) do
		if not arg2 or ItemLibrary_2.Items[v_2].Status == arg2 then
			if not not arg4 then
			end
			if not not arg3 then
			end
			if ShopLibrary_2:IsWeaponReleased(v_2) and ShopLibrary_2.Weapons[v_2].KeyPrice then
			end
		end
	end
	local _
	for _, v_3 in pairs(arg1:Get("WeaponInventory")) do
		if not arg2 or ItemLibrary_2.Items[v_3.Name].Status == arg2 then
			if not not arg4 then
			end
			if not not arg3 then
				if ShopLibrary_2.Weapons[v_3.Name] then
				end
			end
			if ShopLibrary_2:IsWeaponReleased(v_3.Name) and ShopLibrary_2.Weapons[v_3.Name].KeyPrice then
			end
		end
	end
	if 0 + 1 > 0 + 1 then
	else
	end
	return true
end
function module_upvr_2.GetNumTasksCompleted(arg1, arg2) -- Line 139
	local var71
	for _, v_4 in pairs(arg1:Get(arg2 or "Tasks")) do
		if v_4.Completed then
			var71 += 1
		end
	end
	return var71
end
function module_upvr_2.IsEmoteEquipped(arg1, arg2) -- Line 151
	for _, v_5 in pairs(arg1:Get("EquippedEmotes")) do
		if v_5.Name == arg2 then
			return true
		end
	end
end
function module_upvr_2.SilenceCosmeticNotification(arg1, arg2, arg3) -- Line 159
	--[[ Upvalues[1]:
		[1]: ReplicatedStorage_upvr (readonly)
	]]
	if not arg2 then
		arg1.CurrentData:SetReplicate("CosmeticNotifications", {})
		ReplicatedStorage_upvr.Remotes.Data.SilenceCosmeticNotification:FireServer(nil, nil)
	else
		local any_Get_result1 = arg1:Get("CosmeticNotifications")
		if not arg3 then
			any_Get_result1[arg2] = nil
			arg1.CurrentData:Replicate("CosmeticNotifications")
			ReplicatedStorage_upvr.Remotes.Data.SilenceCosmeticNotification:FireServer(arg2, nil)
			return
		end
		if typeof(any_Get_result1[arg2]) == "table" then
			any_Get_result1[arg2][arg3] = nil
			arg1.CurrentData:Replicate("CosmeticNotifications")
			ReplicatedStorage_upvr.Remotes.Data.SilenceCosmeticNotification:FireServer(arg2, arg3)
		end
	end
end
function module_upvr_2.WaitUntilLoaded(arg1) -- Line 179
	if not arg1.CurrentData then
		arg1.PlayerDataAdded:Wait()
	end
end
local module_upvr_4 = require(ReplicatedStorage_upvr:WaitForChild("Modules"):WaitForChild("EnumLibrary"))
function module_upvr_2._PlayerDataChanged(arg1, arg2, ...) -- Line 190
	--[[ Upvalues[2]:
		[1]: module_upvr_4 (readonly)
		[2]: ReplicatedStorage_upvr (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [4] 4. Error Block 2 start (CF ANALYSIS FAILED)
	do
		return
	end
	-- KONSTANTERROR: [4] 4. Error Block 2 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [5] 5. Error Block 3 start (CF ANALYSIS FAILED)
	module_upvr_4:WaitForEnumBuilder()
	-- KONSTANTERROR: [5] 5. Error Block 3 end (CF ANALYSIS FAILED)
end
local module_upvr_3 = require(game:GetService("Players").LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("Modules"):WaitForChild("ClientReplicatedClasses"):WaitForChild("ClientPlayerData"))
function module_upvr_2._CreatePlayerData(arg1, arg2) -- Line 272
	--[[ Upvalues[1]:
		[1]: module_upvr_3 (readonly)
	]]
	local var80
	if typeof(arg2) ~= "table" then
		var80 = false
	else
		var80 = true
	end
	assert(var80, "Argument 1 invalid, expected a table, got "..tostring(arg2))
	var80 = module_upvr_3
	var80 = arg2
	local any_new_result1 = var80.new(var80)
	arg1.CurrentData = any_new_result1
	var80 = arg1.PlayerDataAdded:Fire
	var80(any_new_result1)
end
local RequestPlayerData_upvr = Data:WaitForChild("RequestPlayerData")
function module_upvr_2._RequestPlayerData(arg1) -- Line 280
	--[[ Upvalues[1]:
		[1]: RequestPlayerData_upvr (readonly)
	]]
	local any_InvokeServer_result1 = RequestPlayerData_upvr:InvokeServer()
	if not any_InvokeServer_result1 then
	else
		arg1:_CreatePlayerData(any_InvokeServer_result1)
	end
end
local PlayerDataChanged_upvr = Data:WaitForChild("PlayerDataChanged")
local PlayerDataAdded_upvr = Data:WaitForChild("PlayerDataAdded")
function module_upvr_2._Init(arg1) -- Line 290
	--[[ Upvalues[2]:
		[1]: PlayerDataChanged_upvr (readonly)
		[2]: PlayerDataAdded_upvr (readonly)
	]]
	PlayerDataChanged_upvr.OnClientEvent:Connect(function(...) -- Line 291
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1:_PlayerDataChanged(...)
	end)
	PlayerDataAdded_upvr.OnClientEvent:Connect(function(...) -- Line 295
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1:_CreatePlayerData(...)
	end)
	task.spawn(arg1._RequestPlayerData, arg1)
end
return module_upvr_2._new()
