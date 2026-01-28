-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/brNTY8nX8t)
-- Decompiled on 2026-01-28 07:17:56
-- Luau version 6, Types version 3
-- Time taken: 0.010231 seconds

local Players_upvr = game:GetService("Players")
local SpectateController_upvr = require(Players_upvr.LocalPlayer.PlayerScripts.Controllers.SpectateController)
local FighterController_upvr = require(Players_upvr.LocalPlayer.PlayerScripts.Controllers.FighterController)
local module_upvr_4 = require(
	Players_upvr.LocalPlayer.PlayerScripts.Modules:WaitForChild("UserInterface"):WaitForChild("MatchmadeOverlay")
)
local module_upvr =
	require(Players_upvr.LocalPlayer.PlayerScripts.Modules:WaitForChild("UserInterface"):WaitForChild("MobileButtons"))
local module_upvr_5 =
	require(Players_upvr.LocalPlayer.PlayerScripts.Modules:WaitForChild("UserInterface"):WaitForChild("Teleporting"))
local module_upvr_3 =
	require(Players_upvr.LocalPlayer.PlayerScripts.Modules:WaitForChild("UserInterface"):WaitForChild("Pages"))
local module_upvr_2 = {}
module_upvr_2.__index = module_upvr_2
local PlayerInteractionGui_upvr =
	Players_upvr.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("PlayerInteractionGui")
function module_upvr_2._new() -- Line 23
	--[[ Upvalues[2]:
		[1]: module_upvr_2 (readonly)
		[2]: PlayerInteractionGui_upvr (readonly)
	]]
	local setmetatable_result1 = setmetatable({}, module_upvr_2)
	setmetatable_result1.LocalFighter = nil
	setmetatable_result1._connections = {}
	setmetatable_result1._changed_connections = {}
	setmetatable_result1._bbg = PlayerInteractionGui_upvr:Clone()
	setmetatable_result1._highlight = nil
	setmetatable_result1._next_whitelist = 0
	setmetatable_result1._whitelist = {}
	setmetatable_result1._disabled_until = 0
	setmetatable_result1._hash = 0
	setmetatable_result1:_Init()
	return setmetatable_result1
end
function module_upvr_2._SetAdornee(arg1, arg2) -- Line 52
	--[[ Upvalues[1]:
		[1]: Players_upvr (readonly)
	]]
	local var12 = arg2 or nil
	arg1._bbg.Adornee = var12
	if arg2 then
		var12 = Players_upvr.LocalPlayer.PlayerGui
	else
		var12 = nil
	end
	arg1._bbg.Parent = var12
end
function module_upvr_2._GetWhitelist(arg1) -- Line 57
	--[[ Upvalues[1]:
		[1]: FighterController_upvr (readonly)
	]]
	if arg1._next_whitelist < tick() then
		arg1._next_whitelist = tick() + 3
		arg1._whitelist = FighterController_upvr:GetFighterModels()
	end
	return arg1._whitelist
end
function module_upvr_2._ClearChangedConnections(arg1) -- Line 66
	for _, v in pairs(arg1._changed_connections) do
		v:Disconnect()
	end
	arg1._changed_connections = {}
end
local module_upvr_6 = require(Players_upvr.LocalPlayer.PlayerScripts.Modules:WaitForChild("UILibrary"))
local Utility_upvr = require(game:GetService("ReplicatedStorage").Modules.Utility)
local UserInputService_upvr = game:GetService("UserInputService")
function module_upvr_2._Verify(arg1) -- Line 74
	--[[ Upvalues[9]:
		[1]: module_upvr_3 (readonly)
		[2]: SpectateController_upvr (readonly)
		[3]: module_upvr (readonly)
		[4]: module_upvr_5 (readonly)
		[5]: module_upvr_4 (readonly)
		[6]: Players_upvr (readonly)
		[7]: module_upvr_6 (readonly)
		[8]: Utility_upvr (readonly)
		[9]: UserInputService_upvr (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 54 start (CF ANALYSIS FAILED)
	for _, v_2 in pairs(arg1._connections) do
		v_2:Disconnect()
	end
	arg1._connections = {}
	-- KONSTANTERROR: [0] 1. Error Block 54 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [18] 12. Error Block 4 start (CF ANALYSIS FAILED)
	arg1._highlight:Destroy()
	arg1._highlight = nil
	-- KONSTANTERROR: [18] 12. Error Block 4 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [26] 17. Error Block 5 start (CF ANALYSIS FAILED)
	arg1:_SetAdornee(nil)
	arg1:_ClearChangedConnections()
	arg1._hash += 1
	-- KONSTANTERROR: [26] 17. Error Block 5 end (CF ANALYSIS FAILED)
end
function module_upvr_2._HookLocalFighter(arg1) -- Line 214
	--[[ Upvalues[1]:
		[1]: FighterController_upvr (readonly)
	]]
	arg1.LocalFighter = FighterController_upvr:WaitForLocalFighter()
	arg1.LocalFighter:GetDataChangedSignal("IsInShootingRange"):Connect(function() -- Line 217
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1:_Verify()
	end)
	arg1.LocalFighter:GetDataChangedSignal("IsInDuel"):Connect(function() -- Line 221
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1:_Verify()
	end)
	local function entity_added(arg1_2) -- Line 225
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1_2:GetDataChangedSignal("IsGrabbingSnowball"):Connect(function() -- Line 226
			--[[ Upvalues[1]:
				[1]: arg1 (copied, readonly)
			]]
			arg1._disabled_until = tick() + 2
			task.delay(2, arg1._Verify, arg1)
			arg1:_Verify()
		end)
		arg1:_Verify()
	end
	arg1.LocalFighter.EntityAdded:Connect(entity_added)
	if arg1.LocalFighter.Entity then
		task.defer(entity_added, arg1.LocalFighter.Entity)
	end
	arg1:_Verify()
end
function module_upvr_2._Setup(arg1) -- Line 244
	--[[ Upvalues[1]:
		[1]: Players_upvr (readonly)
	]]
	arg1._bbg.Name = "PlayerInteraction"
	arg1._bbg.Parent = Players_upvr.LocalPlayer.PlayerGui
end
function module_upvr_2._Init(arg1) -- Line 249
	--[[ Upvalues[5]:
		[1]: module_upvr_3 (readonly)
		[2]: SpectateController_upvr (readonly)
		[3]: module_upvr_5 (readonly)
		[4]: module_upvr (readonly)
		[5]: module_upvr_4 (readonly)
	]]
	module_upvr_3.PageSystem.PageOpened:Connect(function() -- Line 250
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1:_Verify()
	end)
	module_upvr_3.PageSystem.PageClosed:Connect(function() -- Line 254
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1:_Verify()
	end)
	SpectateController_upvr.DuelSubjectChanged:Connect(function() -- Line 258
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1:_Verify()
	end)
	module_upvr_5.EnabledChanged:Connect(function() -- Line 262
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1:_Verify()
	end)
	module_upvr.EditorEnabledChanged:Connect(function() -- Line 266
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1:_Verify()
	end)
	module_upvr_4.VisibilityChanged:Connect(function() -- Line 270
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1:_Verify()
	end)
	arg1:_Setup()
	task.defer(arg1._Verify, arg1)
	task.spawn(arg1._HookLocalFighter, arg1)
end
return module_upvr_2._new()
