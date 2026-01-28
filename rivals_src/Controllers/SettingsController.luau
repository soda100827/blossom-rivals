-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/brNTY8nX8t)
-- Decompiled on 2026-01-28 07:30:21
-- Luau version 6, Types version 3
-- Time taken: 0.002538 seconds

local module_upvr = {}
module_upvr.__index = module_upvr
function module_upvr._new() -- Line 7
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local setmetatable_result1 = setmetatable({}, module_upvr)
	setmetatable_result1:_Init()
	return setmetatable_result1
end
function module_upvr.ChangeSetting(arg1, arg2, arg3) -- Line 19
	local tbl_2 = {}
	local tbl = {}
	tbl[1] = arg2
	tbl[2] = arg3
	tbl_2[1] = tbl
	arg1:ChangeSettings(tbl_2)
end
local ReplicatedStorage_upvr = game:GetService("ReplicatedStorage")
function module_upvr.ChangeSettings(arg1, arg2) -- Line 23
	--[[ Upvalues[1]:
		[1]: ReplicatedStorage_upvr (readonly)
	]]
	ReplicatedStorage_upvr.Remotes.Data.ChangeSettings:FireServer(arg2)
end
local TeleportService_upvr = game:GetService("TeleportService")
function module_upvr._ResetHUDSetting(arg1) -- Line 31
	--[[ Upvalues[1]:
		[1]: TeleportService_upvr (readonly)
	]]
	if TeleportService_upvr:GetTeleportSetting("DontResetHUDSetting") then
	else
		TeleportService_upvr:SetTeleportSetting("DontResetHUDSetting", true)
		arg1:ChangeSetting("Settings Hide HUD", false)
	end
end
function module_upvr._Init(arg1) -- Line 40
	task.defer(arg1._ResetHUDSetting, arg1)
end
return module_upvr._new()
