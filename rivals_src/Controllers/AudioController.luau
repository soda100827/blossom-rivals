-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/brNTY8nX8t)
-- Decompiled on 2026-01-28 07:19:26
-- Luau version 6, Types version 3
-- Time taken: 0.003773 seconds

local Players = game:GetService("Players")
local module_upvr = {}
module_upvr.__index = module_upvr
function module_upvr._new() -- Line 13
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local setmetatable_result1 = setmetatable({}, module_upvr)
	setmetatable_result1._connections = {}
	setmetatable_result1._local_fighter = nil
	setmetatable_result1:_Init()
	return setmetatable_result1
end
local SpectateController_upvr = require(Players.LocalPlayer.PlayerScripts.Controllers.SpectateController)
function module_upvr._ObjectAdded(arg1, arg2) -- Line 34
	--[[ Upvalues[1]:
		[1]: SpectateController_upvr (readonly)
	]]
	if not SpectateController_upvr.CurrentSubject or not SpectateController_upvr.CurrentSubject.FighterInterface then
	else
		if not arg2:IsDescendantOf(workspace) or not arg2.Parent:IsA("BasePart") then
			return
		end
		SpectateController_upvr.CurrentSubject.FighterInterface.AudioVisualizers:Create(
			arg2,
			arg2.RollOffMinDistance,
			arg2.RollOffMaxDistance
		)
	end
end
function module_upvr._UpdateEnabled(arg1) -- Line 46
	for _, v in pairs(arg1._connections) do
		v:Disconnect()
	end
	arg1._connections = {}
end
local FighterController_upvr = require(Players.LocalPlayer.PlayerScripts.Controllers.FighterController)
function module_upvr._HookLocalFighter(arg1) -- Line 62
	--[[ Upvalues[1]:
		[1]: FighterController_upvr (readonly)
	]]
	arg1._local_fighter = FighterController_upvr:WaitForLocalFighter()
	arg1._local_fighter:GetDataChangedSignal("IsInShootingRange"):Connect(function() -- Line 65
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1:_UpdateEnabled()
	end)
	arg1._local_fighter:GetDataChangedSignal("IsInDuel"):Connect(function() -- Line 69
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1:_UpdateEnabled()
	end)
	arg1:_UpdateEnabled()
end
local PlayerDataController_upvr = require(Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
function module_upvr._Init(arg1) -- Line 76
	--[[ Upvalues[1]:
		[1]: PlayerDataController_upvr (readonly)
	]]
	PlayerDataController_upvr:GetDataChangedSignal("Settings Audio Visualizers"):Connect(function() -- Line 77
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1:_UpdateEnabled()
	end)
	arg1:_UpdateEnabled()
	task.defer(arg1._HookLocalFighter, arg1)
end
return module_upvr._new()
