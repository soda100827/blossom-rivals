-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/brNTY8nX8t)
-- Decompiled on 2026-01-28 07:29:27
-- Luau version 6, Types version 3
-- Time taken: 0.005154 seconds

local ReplicatedStorage_upvr = game:GetService("ReplicatedStorage")
local ReplicatedClass_upvr = require(ReplicatedStorage_upvr.Modules.ReplicatedClass)
local setmetatable_result1_2_upvr = setmetatable({}, ReplicatedClass_upvr)
setmetatable_result1_2_upvr.__index = setmetatable_result1_2_upvr
function setmetatable_result1_2_upvr._new() -- Line 9
	--[[ Upvalues[2]:
		[1]: ReplicatedClass_upvr (readonly)
		[2]: setmetatable_result1_2_upvr (readonly)
	]]
	local setmetatable_result1 = setmetatable(ReplicatedClass_upvr.new(), setmetatable_result1_2_upvr)
	setmetatable_result1:_Init()
	return setmetatable_result1
end
function setmetatable_result1_2_upvr.GetFFlag(arg1, arg2) -- Line 21
	return arg1:Get(arg2)
end
function setmetatable_result1_2_upvr.SetFFlag(arg1, arg2, arg3) -- Line 25
	arg1:SetReplicate(arg2, arg3)
end
local ItemLibrary_upvr = require(ReplicatedStorage_upvr.Modules.ItemLibrary)
function setmetatable_result1_2_upvr.IsFreeWeaponsActive(arg1) -- Line 29
	--[[ Upvalues[1]:
		[1]: ItemLibrary_upvr (readonly)
	]]
	for i in pairs(ItemLibrary_upvr.Statuses) do
		if arg1:GetFFlag("FreeToUse" .. i .. "Weapons") then
			return true
		end
	end
end
function setmetatable_result1_2_upvr._Fetch(arg1) -- Line 41
	--[[ Upvalues[1]:
		[1]: ReplicatedStorage_upvr (readonly)
	]]
	for i_2, v in pairs(ReplicatedStorage_upvr.Remotes.Misc.RequestFFlags:InvokeServer()) do
		arg1:SetFFlag(i_2, v)
	end
end
function setmetatable_result1_2_upvr._Init(arg1) -- Line 49
	--[[ Upvalues[1]:
		[1]: ReplicatedStorage_upvr (readonly)
	]]
	ReplicatedStorage_upvr.Remotes.Misc.UpdateFFlag.OnClientEvent:Connect(function(...) -- Line 50
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1:SetFFlag(...)
	end)
	task.defer(arg1._Fetch, arg1)
end
return setmetatable_result1_2_upvr._new()
