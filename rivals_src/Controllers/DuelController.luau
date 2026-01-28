-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/brNTY8nX8t)
-- Decompiled on 2026-01-28 07:16:49
-- Luau version 6, Types version 3
-- Time taken: 0.005896 seconds

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players_upvr = game:GetService("Players")
local ReplicatedController_upvr = require(Players_upvr.LocalPlayer.PlayerScripts.Modules.ReplicatedController)
local setmetatable_result1_upvr = setmetatable({}, ReplicatedController_upvr)
setmetatable_result1_upvr.__index = setmetatable_result1_upvr
local Signal_upvr = require(ReplicatedStorage.Modules.Signal)
function setmetatable_result1_upvr._new() -- Line 13
	--[[ Upvalues[3]:
		[1]: ReplicatedController_upvr (readonly)
		[2]: setmetatable_result1_upvr (readonly)
		[3]: Signal_upvr (readonly)
	]]
	local setmetatable_result1 = setmetatable(ReplicatedController_upvr.new("Duel"), setmetatable_result1_upvr)
	setmetatable_result1.LocalPlayerJoinedOrLeftDuel = Signal_upvr.new()
	setmetatable_result1.LocalPlayerJoinedDuel = Signal_upvr.new()
	setmetatable_result1.LocalPlayerLeftDuel = Signal_upvr.new()
	setmetatable_result1:_Init()
	return setmetatable_result1
end
function setmetatable_result1_upvr.GetDuelByID(arg1, arg2) -- Line 29
	for i, v in pairs(arg1.Objects) do
		if v:Get("ObjectID") == arg2 then
			return v, i
		end
	end
end
function setmetatable_result1_upvr.GetDuel(arg1, arg2) -- Line 37
	for i_2, v_2 in pairs(arg1.Objects) do
		if v_2:GetDueler(arg2) then
			return v_2, i_2
		end
	end
end
local ControlsController_upvr = require(Players_upvr.LocalPlayer.PlayerScripts.Controllers.ControlsController)
local InputLibrary_upvr = require(ReplicatedStorage.Modules.InputLibrary)
function setmetatable_result1_upvr._Init(arg1) -- Line 49
	--[[ Upvalues[3]:
		[1]: Players_upvr (readonly)
		[2]: ControlsController_upvr (readonly)
		[3]: InputLibrary_upvr (readonly)
	]]
	arg1.ObjectAdded:Connect(function(arg1_2) -- Line 50
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: Players_upvr (copied, readonly)
		]]
		local function check_local_dueler(arg1_3) -- Line 51
			--[[ Upvalues[2]:
				[1]: arg1_2 (readonly)
				[2]: arg1 (copied, readonly)
			]]
			if not arg1_3 or not arg1_3.IsLocalPlayer then
			else
				arg1_2.DuelerRemoved:Connect(function(arg1_4) -- Line 56
					--[[ Upvalues[3]:
						[1]: arg1_3 (readonly)
						[2]: arg1 (copied, readonly)
						[3]: arg1_2 (copied, readonly)
					]]
					if arg1_4 == arg1_3 then
						arg1.LocalPlayerLeftDuel:Fire(arg1_2, arg1_4)
						arg1.LocalPlayerJoinedOrLeftDuel:Fire(arg1_2, arg1_4)
					end
				end)
				arg1.LocalPlayerJoinedDuel:Fire(arg1_2, arg1_3)
				arg1.LocalPlayerJoinedOrLeftDuel:Fire(arg1_2, arg1_3)
			end
		end
		arg1_2.DuelerAdded:Connect(check_local_dueler)
		check_local_dueler(arg1_2:GetDueler(Players_upvr.LocalPlayer))
	end)
	arg1.ObjectRemoved:Connect(function(arg1_5) -- Line 71
		--[[ Upvalues[2]:
			[1]: Players_upvr (copied, readonly)
			[2]: arg1 (readonly)
		]]
		local any_GetDueler_result1 = arg1_5:GetDueler(Players_upvr.LocalPlayer)
		if not any_GetDueler_result1 then
		else
			arg1.LocalPlayerLeftDuel:Fire(arg1_5, any_GetDueler_result1)
			arg1.LocalPlayerJoinedOrLeftDuel:Fire(arg1_5, any_GetDueler_result1)
		end
	end)
	ControlsController_upvr.InputBegan:Connect(function(arg1_6, arg2) -- Line 82
		--[[ Upvalues[3]:
			[1]: arg1 (readonly)
			[2]: Players_upvr (copied, readonly)
			[3]: InputLibrary_upvr (copied, readonly)
		]]
		if arg2 then
		else
			local any_GetDuel_result1 = arg1:GetDuel(Players_upvr.LocalPlayer)
			if
				any_GetDuel_result1
				and any_GetDuel_result1.DuelInterface.Buttons:IsSwitchItemsVisible()
				and InputLibrary_upvr:InputIs(arg1_6, "SwitchItems")
			then
				any_GetDuel_result1.DuelInterface.Buttons:SwitchItemsRequest()
				return
			end
			if
				any_GetDuel_result1
				and any_GetDuel_result1.DuelInterface.Buttons:IsRespawnNowVisible()
				and InputLibrary_upvr:InputIs(arg1_6, "Jump")
			then
				any_GetDuel_result1.DuelInterface.Buttons:RespawnNowRequest()
				return
			end
			if any_GetDuel_result1 and InputLibrary_upvr:InputIs(arg1_6, "LeaveDuel") then
				any_GetDuel_result1:LeaveDuelRequest()
			end
		end
	end)
end
return setmetatable_result1_upvr._new()
