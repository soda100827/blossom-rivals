-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/brNTY8nX8t)
-- Decompiled on 2026-01-28 07:29:08
-- Luau version 6, Types version 3
-- Time taken: 0.016759 seconds

local CollectionService_upvr = game:GetService("CollectionService")
local ReplicatedStorage_upvr = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CONSTANTS_upvr = require(ReplicatedStorage_upvr.Modules.CONSTANTS)
local RotatingQueueLibrary_upvr = require(ReplicatedStorage_upvr.Modules.RotatingQueueLibrary)
local FighterController_upvr = require(Players.LocalPlayer.PlayerScripts.Controllers.FighterController)
local module_upvr = {}
module_upvr.__index = module_upvr
local Signal_upvr = require(ReplicatedStorage_upvr.Modules.Signal)
function module_upvr._new() -- Line 20
	--[[ Upvalues[2]:
		[1]: module_upvr (readonly)
		[2]: Signal_upvr (readonly)
	]]
	local setmetatable_result1 = setmetatable({}, module_upvr)
	setmetatable_result1.DuelSet = Signal_upvr.new()
	setmetatable_result1.UpdateJoinCooldown = Signal_upvr.new()
	setmetatable_result1.CurrentDuel = nil
	setmetatable_result1._local_fighter = nil
	setmetatable_result1._has_joined_arcade_duel = false
	setmetatable_result1._hologram_loop_thread = nil
	setmetatable_result1._rotating_queue_hologram = nil
	setmetatable_result1._join_cooldown_hash = 0
	setmetatable_result1:_Init()
	return setmetatable_result1
end
function module_upvr.GetJoinCooldown(arg1) -- Line 43
	local var10
	local function INLINED() -- Internal function, doesn't exist in bytecode
		var10 = arg1._local_fighter:GetJoinCooldown()
		return var10
	end
	if not arg1._local_fighter or not INLINED() then
		var10 = 0
	end
	return math.ceil(var10)
end
function module_upvr.CanJoin(arg1) -- Line 47
	local CurrentDuel = arg1.CurrentDuel
	if CurrentDuel then
		CurrentDuel = false
		if arg1.CurrentDuel:Get("Status") ~= "GameOver" then
			if arg1:GetJoinCooldown() > 0 then
				CurrentDuel = false
			else
				CurrentDuel = true
			end
		end
	end
	return CurrentDuel
end
function module_upvr.ToArcadeServer(arg1, arg2) -- Line 51
	--[[ Upvalues[1]:
		[1]: ReplicatedStorage_upvr (readonly)
	]]
	return ReplicatedStorage_upvr.Remotes.Arcade.TeleportToArcadeServer:InvokeServer(arg2)
end
function module_upvr.Join(arg1) -- Line 55
	--[[ Upvalues[1]:
		[1]: ReplicatedStorage_upvr (readonly)
	]]
	arg1._has_joined_arcade_duel = true
	ReplicatedStorage_upvr.Remotes.Arcade.Join:FireServer()
end
local RotatingQueueHolograms_upvr = Players.LocalPlayer.PlayerScripts.Assets.RotatingQueueHolograms
local SendChat_upvr = require(Players.LocalPlayer.PlayerScripts.Modules.Functions.SendChat)
local Utility_upvr = require(ReplicatedStorage_upvr.Modules.Utility)
function module_upvr._UpdateHologram(arg1, arg2) -- Line 64
	--[[ Upvalues[5]:
		[1]: CollectionService_upvr (readonly)
		[2]: RotatingQueueHolograms_upvr (readonly)
		[3]: RotatingQueueLibrary_upvr (readonly)
		[4]: SendChat_upvr (readonly)
		[5]: Utility_upvr (readonly)
	]]
	if arg1._rotating_queue_hologram then
		arg1._rotating_queue_hologram:Destroy()
		arg1._rotating_queue_hologram = nil
	end
	local _1_upvr = CollectionService_upvr:GetTagged("LobbyRotatingQueueHologram")[1]
	if not _1_upvr then
	else
		task.defer(function() -- Line 76
			--[[ Upvalues[1]:
				[1]: _1_upvr (readonly)
			]]
			local DELETE_AT_RUNTIME = _1_upvr:WaitForChild("DELETE_AT_RUNTIME", 2)
			if DELETE_AT_RUNTIME then
				task.defer(DELETE_AT_RUNTIME.Destroy, DELETE_AT_RUNTIME)
			end
		end)
		local Particles = _1_upvr:WaitForChild("Particles")
		local Attachment_upvr = Particles:WaitForChild("Attachment")
		_1_upvr:WaitForChild("Prompt"):WaitForChild("ProximityPrompt").ObjectText = "Limited Time"
		local SOME = RotatingQueueHolograms_upvr:FindFirstChild(RotatingQueueLibrary_upvr:GetCurrent().Name)
		if not SOME then
			SOME = RotatingQueueHolograms_upvr.Default
		end
		arg1._rotating_queue_hologram = SOME:Clone()
		arg1._rotating_queue_hologram:PivotTo(_1_upvr:WaitForChild("Primary").CFrame)
		arg1._rotating_queue_hologram.Name = "_hologram"
		arg1._rotating_queue_hologram.Parent = _1_upvr
		if arg2 then
			SendChat_upvr({
				Text = "[SERVER] New gamemodes are here! Open the PLAY page now! ?럦",
				Color = Color3.fromRGB(100, 255, 50),
			})
			Utility_upvr:PlayParticles(Particles:WaitForChild("Emit"))
			Utility_upvr:CreateSound("rbxassetid://120776960987657", 0.75, 1, Particles, true, 15)
			Utility_upvr:CreateSound("rbxassetid://75616400922980", 1, 1, Particles, true, 15)
			for _, v_3 in pairs(Attachment_upvr:GetChildren()) do
				v_3.Enabled = true
			end
			task.delay(10, function() -- Line 110
				--[[ Upvalues[1]:
					[1]: Attachment_upvr (readonly)
				]]
				for _, v_4 in pairs(Attachment_upvr:GetChildren()) do
					v_4.Enabled = false
				end
			end)
		end
	end
end
function module_upvr._UpdateHologramLoop(arg1) -- Line 118
	--[[ Upvalues[1]:
		[1]: RotatingQueueLibrary_upvr (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [3] 3. Error Block 2 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [3] 3. Error Block 2 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [11] 9. Error Block 3 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [11] 9. Error Block 3 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [18] 14. Error Block 4 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [18] 14. Error Block 4 end (CF ANALYSIS FAILED)
end
function module_upvr._UpdateJoinCooldown(arg1) -- Line 140
	arg1._join_cooldown_hash += 1
	local _join_cooldown_hash = arg1._join_cooldown_hash
	local any_GetJoinCooldown_result1 = arg1._local_fighter:GetJoinCooldown()
	arg1.UpdateJoinCooldown:Fire()
	for _ = 1, any_GetJoinCooldown_result1 do
		wait(1)
		arg1.UpdateJoinCooldown:Fire()
		if arg1._join_cooldown_hash ~= _join_cooldown_hash then
			return
		end
	end
	wait(tick() + any_GetJoinCooldown_result1 - tick())
	if arg1._join_cooldown_hash ~= _join_cooldown_hash then
	else
		arg1.UpdateJoinCooldown:Fire()
	end
end
function module_upvr._HookLocalFighter(arg1) -- Line 167
	--[[ Upvalues[1]:
		[1]: FighterController_upvr (readonly)
	]]
	arg1._local_fighter = FighterController_upvr:WaitForLocalFighter()
	arg1._local_fighter:GetDataChangedSignal("IsInDuel"):Connect(function() -- Line 170
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1:_UpdateHologramLoop()
	end)
	arg1._local_fighter:GetDataChangedSignal("IsInShootingRange"):Connect(function() -- Line 174
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1:_UpdateHologramLoop()
	end)
	arg1._local_fighter:GetDataChangedSignal("JoinCooldown"):Connect(function() -- Line 178
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1:_UpdateJoinCooldown()
	end)
	task.defer(arg1._UpdateHologramLoop, arg1)
	task.defer(arg1._UpdateJoinCooldown, arg1)
end
function module_upvr._DuelRemoved(arg1, arg2) -- Line 186
	if arg1.CurrentDuel == arg2 then
		arg1.CurrentDuel = nil
		arg1.DuelSet:Fire(arg2)
	end
end
function module_upvr._DuelAdded(arg1, arg2) -- Line 193
	arg2:GetDataChangedSignal("IsCurrentArcadeDuel"):Connect(function() -- Line 194, Named "check_is_arcade_duel"
		--[[ Upvalues[2]:
			[1]: arg2 (readonly)
			[2]: arg1 (readonly)
		]]
		if arg2:Get("IsCurrentArcadeDuel") then
			arg1.CurrentDuel = arg2
			arg1.DuelSet:Fire(arg2)
		end
	end)
	if arg2:Get("IsCurrentArcadeDuel") then
		arg1.CurrentDuel = arg2
		arg1.DuelSet:Fire(arg2)
	end
end
local DuelLibrary_upvr = require(ReplicatedStorage_upvr.Modules.DuelLibrary)
function module_upvr._PromptAdded(arg1, arg2) -- Line 205
	--[[ Upvalues[3]:
		[1]: CONSTANTS_upvr (readonly)
		[2]: ReplicatedStorage_upvr (readonly)
		[3]: DuelLibrary_upvr (readonly)
	]]
	if not CONSTANTS_upvr.IS_ARCADE_SERVER then
	else
		arg2:RemoveTag("LobbyOpenPagePrompt")
		arg2.Triggered:Connect(function() -- Line 212
			--[[ Upvalues[1]:
				[1]: ReplicatedStorage_upvr (copied, readonly)
			]]
			ReplicatedStorage_upvr.Remotes.Matchmaking.BackToHub:FireServer()
		end)
		arg2.ObjectText = DuelLibrary_upvr.ArcadeModeByPlaceID[tostring(CONSTANTS_upvr.PLACE_ID)].DisplayName
		arg2.ActionText = "Leave"
	end
end
local SpectateController_upvr = require(Players.LocalPlayer.PlayerScripts.Controllers.SpectateController)
local DuelController_upvr = require(Players.LocalPlayer.PlayerScripts.Controllers.DuelController)
function module_upvr._Init(arg1) -- Line 220
	--[[ Upvalues[5]:
		[1]: FighterController_upvr (readonly)
		[2]: CONSTANTS_upvr (readonly)
		[3]: SpectateController_upvr (readonly)
		[4]: DuelController_upvr (readonly)
		[5]: CollectionService_upvr (readonly)
	]]
	arg1.DuelSet:Connect(function(arg1_2) -- Line 221
		--[[ Upvalues[4]:
			[1]: arg1 (readonly)
			[2]: FighterController_upvr (copied, readonly)
			[3]: CONSTANTS_upvr (copied, readonly)
			[4]: SpectateController_upvr (copied, readonly)
		]]
		arg1_2:GetDataChangedSignal("Status"):Connect(function() -- Line 222
			--[[ Upvalues[1]:
				[1]: arg1 (copied, readonly)
			]]
			arg1.UpdateJoinCooldown:Fire()
		end)
		arg1.UpdateJoinCooldown:Fire()
		if
			not FighterController_upvr.LocalFighter
			or FighterController_upvr.LocalFighter:Get("IsInDuel")
			or FighterController_upvr.LocalFighter:Get("IsInShootingRange")
		then
		else
			if CONSTANTS_upvr.IS_ARCADE_SERVER and not arg1._has_joined_arcade_duel and 3 <= #arg1_2.Duelers then
				SpectateController_upvr:SpectateDuelRequest(arg1_2)
				return
			end
			arg1:Join()
		end
	end)
	DuelController_upvr.ObjectAdded:Connect(function(arg1_3) -- Line 239
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1:_DuelAdded(arg1_3)
	end)
	DuelController_upvr.ObjectRemoved:Connect(function(arg1_4) -- Line 243
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1:_DuelRemoved(arg1_4)
	end)
	CollectionService_upvr:GetInstanceAddedSignal("LobbyRotatingQueueHologram"):Connect(function(arg1_5) -- Line 247
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1:_UpdateHologram(arg1_5)
	end)
	CollectionService_upvr:GetInstanceAddedSignal("LobbyArcadePrompt"):Connect(function(arg1_6) -- Line 251
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1:_PromptAdded(arg1_6)
	end)
	for _, v in pairs(CollectionService_upvr:GetTagged("LobbyArcadePrompt")) do
		task.defer(arg1._PromptAdded, arg1, v)
	end
	for _, v_2 in pairs(DuelController_upvr.Objects) do
		task.defer(arg1._DuelAdded, arg1, v_2)
	end
	task.defer(arg1._HookLocalFighter, arg1)
end
return module_upvr._new()
