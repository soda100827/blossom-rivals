-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/brNTY8nX8t)
-- Decompiled on 2026-01-28 07:29:18
-- Luau version 6, Types version 3
-- Time taken: 0.002988 seconds

local ReplicatedStorage_upvr = game:GetService("ReplicatedStorage")
local module_upvr = {}
module_upvr.__index = module_upvr
function module_upvr._new() -- Line 6
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local setmetatable_result1 = setmetatable({}, module_upvr)
	setmetatable_result1._last_update = -1
	setmetatable_result1._time_remaining = nil
	setmetatable_result1:_Init()
	return setmetatable_result1
end
function module_upvr.GetTimeRemaining(arg1) -- Line 21
	if not arg1._time_remaining then
		return
	end
	return math.max(0, math.ceil(arg1._time_remaining - (tick() - arg1._last_update)))
end
function module_upvr._UpdateTimer(arg1, arg2) -- Line 33
	arg1._last_update = tick()
	arg1._time_remaining = arg2
end
function module_upvr._Fetch(arg1) -- Line 38
	--[[ Upvalues[1]:
		[1]: ReplicatedStorage_upvr (readonly)
	]]
	arg1:_UpdateTimer(ReplicatedStorage_upvr.Remotes.Misc.RequestEventTimer:InvokeServer())
end
function module_upvr._Init(arg1) -- Line 42
	--[[ Upvalues[1]:
		[1]: ReplicatedStorage_upvr (readonly)
	]]
	ReplicatedStorage_upvr.Remotes.Misc.UpdateEventTimer.OnClientEvent:Connect(function(arg1_2) -- Line 43
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1:_UpdateTimer(arg1_2)
	end)
	task.defer(arg1._Fetch, arg1)
end
return module_upvr._new()
