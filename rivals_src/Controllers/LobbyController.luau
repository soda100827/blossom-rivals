-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/brNTY8nX8t)
-- Decompiled on 2026-01-28 07:29:49
-- Luau version 6, Types version 3
-- Time taken: 0.014896 seconds

local ReplicatedStorage_upvr = game:GetService("ReplicatedStorage")
local CollectionService_upvr = game:GetService("CollectionService")
local Players_upvr = game:GetService("Players")
local PlayerDataController_upvr = require(Players_upvr.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
local FighterController_upvr = require(Players_upvr.LocalPlayer.PlayerScripts.Controllers.FighterController)
local DuelController_upvr = require(Players_upvr.LocalPlayer.PlayerScripts.Controllers.DuelController)
local tbl_upvr = {"StarterBundleBoards", "LeaderboardDisplays", "EliminationsDisplays", "DuelsDisplays", "DuelsGarageDoor", "LikeBoards", "LooseWeaponDisplays", "Miscellaneous", "DuelsSign", "RotatingBundleDisplay", "WeaponReleaseSchedule", "ToyTrainPaths", "Teleporters", "DailyShopSkinHolograms", "LobbyPortals", "LobbyAnimations", "UpdateCountdowns", "TopPlayerRewards"}
local module_upvr = {}
module_upvr.__index = module_upvr
function module_upvr._new() -- Line 30
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local setmetatable_result1 = setmetatable({}, module_upvr)
	setmetatable_result1.LocalFighter = nil
	setmetatable_result1.Elements = {}
	setmetatable_result1._renderstep_connection = nil
	setmetatable_result1._textures_deleted = false
	setmetatable_result1._attempted_to_favorite = false
	setmetatable_result1:_Init()
	return setmetatable_result1
end
local ShootingRangeController_upvr = require(Players_upvr.LocalPlayer.PlayerScripts.Controllers.ShootingRangeController)
function module_upvr.ToDuels(arg1) -- Line 49
	--[[ Upvalues[3]:
		[1]: FighterController_upvr (readonly)
		[2]: ShootingRangeController_upvr (readonly)
		[3]: CollectionService_upvr (readonly)
	]]
	if FighterController_upvr.LocalFighter and FighterController_upvr.LocalFighter:Get("IsInShootingRange") then
		ShootingRangeController_upvr:Leave(true)
	elseif FighterController_upvr.LocalFighter and not FighterController_upvr.LocalFighter:Get("IsInDuel") and FighterController_upvr.LocalFighter:IsAlive() then
		FighterController_upvr.LocalFighter.Entity.Model:PivotTo(CollectionService_upvr:GetTagged("LobbyDuels")[1].CFrame)
	end
end
function module_upvr._RemoveGiftHolograms(arg1) -- Line 61
	--[[ Upvalues[2]:
		[1]: PlayerDataController_upvr (readonly)
		[2]: CollectionService_upvr (readonly)
	]]
	if not PlayerDataController_upvr:Get("ClaimedGroupReward") then
	else
		for _, v_4 in pairs(CollectionService_upvr:GetTagged("LobbyFreeRewardsHologram")) do
			task.defer(v_4.Destroy, v_4)
		end
	end
end
local Lighting_upvr = game:GetService("Lighting")
function module_upvr._UpdateShadows(arg1) -- Line 71
	--[[ Upvalues[2]:
		[1]: Lighting_upvr (readonly)
		[2]: PlayerDataController_upvr (readonly)
	]]
	Lighting_upvr.GlobalShadows = not PlayerDataController_upvr:Get("Settings Shadows Disabled")
end
local any_GetTestAttribute_result1_upvr = require(ReplicatedStorage_upvr.Modules.TestLibrary):GetTestAttribute("StudioSkipOnboarding")
local AvatarEditorService_upvr = game:GetService("AvatarEditorService")
local CONSTANTS_upvr = require(ReplicatedStorage_upvr.Modules.CONSTANTS)
local ExperienceNotificationService_upvr = game:GetService("ExperienceNotificationService")
function module_upvr._PromptStuff(arg1) -- Line 75
	--[[ Upvalues[8]:
		[1]: any_GetTestAttribute_result1_upvr (readonly)
		[2]: DuelController_upvr (readonly)
		[3]: Players_upvr (readonly)
		[4]: PlayerDataController_upvr (readonly)
		[5]: AvatarEditorService_upvr (readonly)
		[6]: CONSTANTS_upvr (readonly)
		[7]: ExperienceNotificationService_upvr (readonly)
		[8]: ReplicatedStorage_upvr (readonly)
	]]
	if any_GetTestAttribute_result1_upvr then
	else
		wait(1)
		if DuelController_upvr:GetDuel(Players_upvr.LocalPlayer) then return end
		if not arg1._attempted_to_favorite and (PlayerDataController_upvr:GetStatistic("StatisticDuelsPlayed") == 5 or PlayerDataController_upvr:GetStatistic("StatisticDuelsWon") == 1) then
			arg1._attempted_to_favorite = true
			AvatarEditorService_upvr:PromptSetFavorite(CONSTANTS_upvr.HUB_PLACE_ID, Enum.AvatarItemType.Asset, true)
			return
		end
		local function INLINED() -- Internal function, doesn't exist in bytecode
			-- KONSTANTERROR: Expression was reused, decompilation is incorrect
			return 8 <= PlayerDataController_upvr:GetStatistic("StatisticDuelsPlayed")
		end
		local function INLINED_2() -- Internal function, doesn't exist in bytecode
			-- KONSTANTERROR: Expression was reused, decompilation is incorrect
			return PlayerDataController_upvr:GetStatistic("StatisticDuelsWon") == 2
		end
		if not PlayerDataController_upvr:Get("PromptedNotificationPrompt") and (INLINED() or INLINED_2()) then
			local pcall_result1, pcall_result2 = pcall(ExperienceNotificationService_upvr.CanPromptOptInAsync, ExperienceNotificationService_upvr)
			if not pcall_result1 then
				warn("Failed to check if user can prompt notifications:", pcall_result2)
				return
			end
			if pcall_result2 then
				ReplicatedStorage_upvr.Remotes.Data.PromptedNotificationPrompt:FireServer()
				ExperienceNotificationService_upvr:PromptOptIn()
			end
		end
	end
end
local RunService_upvr = game:GetService("RunService")
function module_upvr._UpdateEnabled(arg1) -- Line 104
	--[[ Upvalues[1]:
		[1]: RunService_upvr (readonly)
	]]
	local var42
	if var42 then
		var42 = arg1._renderstep_connection:Disconnect
		var42()
		var42 = nil
		arg1._renderstep_connection = var42
	end
	var42 = arg1.LocalFighter
	if var42 then
		var42 = not arg1.LocalFighter:Get("IsInDuel")
		if var42 then
			var42 = not arg1.LocalFighter:Get("IsInShootingRange")
		end
	end
	for _, v in pairs(arg1.Elements) do
		v:SetEnabled(var42)
	end
	if var42 then
		arg1._renderstep_connection = RunService_upvr.RenderStepped:Connect(function(arg1_3) -- Line 117
			--[[ Upvalues[1]:
				[1]: arg1 (readonly)
			]]
			for _, v_2 in pairs(arg1.Elements) do
				v_2:Update(arg1_3)
			end
		end)
	end
	if var42 then
		task.defer(arg1._PromptStuff, arg1)
	end
end
local Utility_upvr = require(ReplicatedStorage_upvr.Modules.Utility)
function module_upvr._UpdateTextures(arg1) -- Line 129
	--[[ Upvalues[3]:
		[1]: PlayerDataController_upvr (readonly)
		[2]: CollectionService_upvr (readonly)
		[3]: Utility_upvr (readonly)
	]]
	if arg1._textures_deleted or not PlayerDataController_upvr:Get("Settings Textures Disabled") then
	else
		arg1._textures_deleted = true
		for _, v_5 in pairs(CollectionService_upvr:GetTagged("LobbyFolder")) do
			Utility_upvr:DisableTextures(v_5)
		end
	end
end
local LobbyElements_upvr = Players_upvr.LocalPlayer.PlayerScripts.Modules.LobbyElements
function module_upvr._Setup(arg1) -- Line 141
	--[[ Upvalues[3]:
		[1]: FighterController_upvr (readonly)
		[2]: tbl_upvr (readonly)
		[3]: LobbyElements_upvr (readonly)
	]]
	arg1.LocalFighter = FighterController_upvr:WaitForLocalFighter()
	arg1.LocalFighter:GetDataChangedSignal("IsInDuel"):Connect(function() -- Line 144
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1:_UpdateEnabled()
	end)
	arg1.LocalFighter:GetDataChangedSignal("IsInShootingRange"):Connect(function() -- Line 148
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1:_UpdateEnabled()
	end)
	for _, v_3_upvr in pairs(tbl_upvr) do
		task.defer(function() -- Line 153
			--[[ Upvalues[3]:
				[1]: arg1 (readonly)
				[2]: LobbyElements_upvr (copied, readonly)
				[3]: v_3_upvr (readonly)
			]]
			table.insert(arg1.Elements, require(LobbyElements_upvr[v_3_upvr]))
		end)
	end
	task.defer(arg1._UpdateEnabled, arg1)
end
function module_upvr._Init(arg1) -- Line 161
	--[[ Upvalues[3]:
		[1]: PlayerDataController_upvr (readonly)
		[2]: CollectionService_upvr (readonly)
		[3]: DuelController_upvr (readonly)
	]]
	PlayerDataController_upvr:GetDataChangedSignal("StatisticDuelsPlayed"):Connect(function() -- Line 162
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1:_PromptStuff()
	end)
	PlayerDataController_upvr:GetDataChangedSignal("Settings Textures Disabled"):Connect(function() -- Line 166
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1:_UpdateTextures()
	end)
	PlayerDataController_upvr:GetDataChangedSignal("Settings Shadows Disabled"):Connect(function() -- Line 170
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1:_UpdateShadows()
	end)
	PlayerDataController_upvr:GetDataChangedSignal("ClaimedGroupReward"):Connect(function() -- Line 174
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1:_RemoveGiftHolograms()
	end)
	CollectionService_upvr:GetInstanceAddedSignal("LobbyFreeRewardsHologram"):Connect(function() -- Line 178
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1:_RemoveGiftHolograms()
	end)
	DuelController_upvr.LocalPlayerLeftDuel:Connect(function() -- Line 182
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1:_PromptStuff()
	end)
	arg1:_UpdateTextures()
	task.spawn(arg1._Setup, arg1)
	task.defer(arg1._UpdateShadows, arg1)
	task.defer(arg1._RemoveGiftHolograms, arg1)
end
return module_upvr._new()
